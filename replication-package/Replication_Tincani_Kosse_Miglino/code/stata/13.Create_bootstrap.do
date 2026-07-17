

********************************************************************************
* DO-FILE DESCRIPTION:
* This do-file defines the globals and runs the do-files in correct order
********************************************************************************
/*------------------------------------------------------------------------------
	1) Install programs
	2) Main setup
	3) Define globals
	4) Dofile execution
	5) Erase intermediary datasets
------------------------------------------------------------------------------*/

********************************************************************************
**#	1) List of packages  
********************************************************************************
 * cleanplots
 * estout
 * coefplot
 * rwolf2
 * leebounds
 * unique
 * egenmore
 * missings
 * dm89_2 
 * opencagegeo
 * insheetjson
 * libjson
 * geodist

	
* For exact reproducibility, use frozen local copies stored inside the project.



********************************************************************************
**#	2) Main Setup 
********************************************************************************
    version 18
	clear all
	clear matrix
	clear mata
	clear results
	set more off
	set maxvar 20000
	capture log close
	set seed 10005
	set sortseed 1989856
	set processors 1

	

********************************************************************************
**#	3) Define globals 
********************************************************************************



	discard 
	
	which lasso2
	which lassoutils
	which rwolf2
	
	set scheme cleanplots


* CREATE BOOTSTRAP SAMPLES AND PARAMETERS TO ESTIMATE STANDARD ERRORS OF MODEL COEFFICIENTS 

* ==============================================================================
**#            GENERATE BOOTSTRAPPED SAMPLES OF SCHOOLS     
* ==============================================================================

local num_repetitions=53
forvalues s=1(1)`num_repetitions'{
* Clean dataset first
use "$dataClean/data_experimental.dta", clear
keep if in_experimental_schools==1

* Measure of top 15 cutoff, same one used in RF analysis = April measure, if missing then use August measure.
replace NEM_top15_April=NEM_top15 if NEM_top15_April==.
rename NEM_top15_April perceived_top15_cutoff

* Lump together the 9th and 10th region as too few students in 9th region
gen region = cod_reg_rbd 
replace region = 10 if cod_reg_rbd==9

gen region4=1 if region==4
replace region4=0 if region!=4
gen region5=1 if region==5
replace region5=0 if region!=5
gen region7=1 if region==7
replace region7=0 if region!=7
gen region8=1 if region==8
replace region8=0 if region!=8
gen region10=1 if region==10
replace region10=0 if region!=10
gen region13=1 if region==13
replace region13=0 if region!=13
gen region14=1 if region==14
replace region14=0 if region!=14
gen region15=1 if region==15
replace region15=0 if region!=15

local initial_condition mrun age female neverfailed alumno_prioritario ///
simce_avg_st rbd_basefinal class_code treatment modalidad actual_top15_cutoff GPA_segundo_medio GPA_avg_school_1_2 GPA_avg_1_2 region4 region5 ///
 region7 region8 region10 region13 region14 region15 GPA_1_2_rank top15baseline GPAb_coeff_eff  PSUb_coeff_eff_1  PSUb_coeff_eff_2 PSUb_kink Pgradb

* Model initial conditions cannot be missing 
foreach var in `initial_condition' {
*di "`var'"
drop if `var'==.
}

 
merge 1:1 mrun using "$dataTemp/admitted_SUA_pace.dta" , keepusing(quality_adm_uni_major_PACE )
drop if _merge==2 // these are the students who were admitted through PACE in 2018 but they are not in the our experimental sample
drop _merge

*The do file that generate the selectivity variables is: "generate_applic_adm_uni_selectivity.do" in the "Do Files" folder.
merge 1:1 mrun using "$dataTemp/regular_applications_uni_quality.dta" , keepusing( quality_adm_uni_major)
drop if _merge==2

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110



bys rbd_basefinal: gen num_obs_school=_N

gen y_data_missing=1 if score_all_st==.
replace y_data_missing=0 if score_all_st!=.
gen hours_study_data_missing=1 if hours_study==.
replace hours_study_data_missing=0 if hours_study!=.

gen GPA_all_years=( GPA_primero_medio + GPA_segundo_medio + GPA_tercero_medio + GPA_cuarto_medio)/4
label var GPA_all_years "GPA grades 9-12"

foreach var in exp_NEM exp_PSUscore GPA_all_years GPA_cuarto_medio mean_PSU_score_uni_major minus_bias_top15 p_admitted {
   gen `var'_missing=1 if `var'==.
   replace `var'_missing=0 if `var'!=.
}

* Dummy identifying sample for estimation of effect heterogeneity by beliefs:
gen sample_het_by_belief=1 if exp_NEM!=. & exp_PSUscore!=. & perceived_top15_cutoff!=.
replace sample_het_by_belief=0 if sample_het_by_belief==.



drop returns_effort_top15_55 returns_eff_PSUb_1_all returns_eff_PSUb_2_all returns_GPA_est_all



xtile simce_cat5=simce_avg_st, n(5)
gen GPA_1_2_rank_cat5=.
forvalues y=0(0.2)0.8 {
    replace GPA_1_2_rank_cat5=round((`y'+0.2)*5,1) if GPA_1_2_rank>`y' & GPA_1_2_rank<=`y'+0.2
}
quietly su exp_PSUscore, d
gen above_med_exp_PSU=exp_PSUscore>r(p50) if exp_PSUscore!=.
lab var above_med_exp_PSU "Above median belief on PSU"
gen within_med_exp_PSU=1-above_med_exp_PSU
lab var within_med_exp_PSU "PSU belief $\leq$ median"
gen think_top15April=0 if exp_NEM!=. & perceived_top15_cutoff!=.
replace think_top15April=1 if exp_NEM>perceived_top15_cutoff & exp_NEM!=.


rename admitted_SUA_regular_or_pace admitted_SUA
gen believed_distance_from_cutoff=abs(exp_NEM-perceived_top15_cutoff) 
gen TXbelieved_distance_from_cutoff=treatment*believed_distance_from_cutoff
	gen simceXbelieved_distance=simce_avg_st*believed_distance_from_cutoff
	gen femaleXbelieved_distance=female*believed_distance_from_cutoff
	gen modalidadXbelieved_distance=modalidad*believed_distance_from_cutoff
	gen alumnoXbelieved_distance=alumno_prioritario*believed_distance_from_cutoff
	gen ageXbelieved_distance=age*believed_distance_from_cutoff
	gen neverfailedXbelieved_distance=neverfailed*believed_distance_from_cutoff


sort treatment rbd_basefinal mrun


* Bootstrap
set seed `s'
bsample , cluster(rbd_basefinal) idcluster(school_bootstrap_id)

sort treatment rbd_basefinal mrun
save "$dataTemp/data_experimental_est_sample_rescale_bootstrap`s'.dta", replace  

keep school_bootstrap_id  mrun age female neverfailed alumno_prioritario ///
	 simce_avg_st   rbd_basefinal class_code treatment modalidad actual_top15_cutoff perceived_top15_cutoff GPA_segundo_medio GPA_avg_school_1_2 GPA_avg_1_2 region4 region5 ///
     region7 region8 region10 region13 region14 region15  num_obs_school y_data_missing hours_study_data_missing GPA_all_years_missing GPA_cuarto_medio_missing ///
	 mean_PSU_score_uni_major_missing sit_PSU enrolled_SUA_by_y1 enrolled_SUA_pace GPA_1_2_rank top15baseline ///
     exp_NEM_missing exp_PSUscore_missing sample_het_by_belief simce_cat5 GPA_1_2_rank_cat5 within_med_exp_PSU  ///
	 admitted_SUA_regular admitted_SUA_pace ///
	 score_all_st  hours_study GPA_all_years sit_PSU GPAb_coeff_eff  PSUb_coeff_eff_1  PSUb_coeff_eff_2 ///
	 sit_PSU PSU_score_if_positive_st admitted_SUA mean_PSU_score_uni_major enrolled_SUA_by_y5 top15baseline ///
	 exp_PSU_st exp_NEM   Pgradb p_admitted p_admitted_missing PSUb_coeff_eff_1 PSUb_coeff_eff_2 PSUb_kink  GPAb_coeff_eff PSU_st_bias ///
	 p_admitted_above_050   bias_own_NEM  minus_bias_top15 minus_bias_top15_missing think_top15 think_top15April believed_distance_from_cutoff *Xbelieved_distance* ///
	 id_fe* 
sort treatment rbd_basefinal mrun
saveold "$dataClean/initial_conditions_TC_bootstrap`s'.dta", replace
}




* ==============================================================================
**#            ESTIMATE COEFFICIENTS IN BOOTSTRAPPED SAMPLES  
* ==============================================================================
local num_repetitions=53
forvalues s=1(1)`num_repetitions'{
*PREPARE .DTA FILE WITH COEFFICIENT ESTIMATES 
* Initialize dataset for empirical parameters: save parameter names into a vector
clear 
local names_coefficients ///
	sitPSU_fem sitPSU_missing hours_fem hours_simce enrolledC_fem enrolledC_missing enrolledC_cons /// auxiliary models 1-4 (7)
	TEadm_all admC_all TEenroll_all enrollC_all TEpers_all persC_all  /// auxiliary models, TE on admissions, enrollments and persistence in whole sample (6)
	TEadm_15 admC_15 TEenroll_15 enrollC_15 TEpers_15 persC_15     ///  auxiliary models, TE on admissions, enrollments and persistence in top15% sample at baseline (6)
	sitPSUC_expPSU sitPSUC_cons admC_female admC_missing admRC_GPA910 admRC_simce GPA_fem GPA_missing /// auxiliary models 5-8 (8)
	GPA_hours GPA_GPA910 GPA_simce pers_fem pers_simce enrolladmC_Pgradb   /// auxiliary models 9-11 (6)
	TEhours hoursC TEsitPSU sitPSUC TEhours_Xperceived /// auxiliary models TE one ffort and sit PSU (5)
	sitPSUfem0miss0 hoursfem enrolledP_admboth varPSUC GPAC varGPAC admPT admPT_15 varhoursC top15base_end0 top15base_end1 enr_adm0 enr_adm1 /// summary stats (13) 
	TEpers_enr_T15  // TE on persistence conditional on enrolling in top15 (1)
   
	  
local num_obs=`: word count `names_coefficients''
di "`num_obs'"
set obs `num_obs'
gen coefficient_name=""
gen coefficient_value=.
gen coefficient_variance_value=.
gen num_coefficient=_n
	  
forvalues i = 1(1)`num_obs' {
    local coefficient: word `i' of `names_coefficients'
	replace coefficient_name="`coefficient'" if num_coefficient==`i'
}
saveold "$dataClean/empirical_coefficients_rescale_bootstrap`s'.dta", replace

*PREPARE .DTA FILE WITH COEFFICIENT ESTIMATES 
use "$dataTemp/data_experimental_est_sample_rescale_bootstrap`s'.dta", clear

est clear 

* Data prep
rename y_data_missing survey_missing 
gen cutoff_top15b=perceived_top15_cutoff
replace cutoff_top15b=actual_top15_cutoff if cutoff_top15b==. 
gen perceived_dist_cutoff = abs(exp_NEM-cutoff_top15b)
gen Txperceived_dist=treatment*perceived_dist_cutoff 

* Globals for controls - eliminate GPA_segundo from the controls 
global initial_cond_controls_v1 GPA_avg_1_2 simce_avg_st Pgradb GPAb_coeff_eff PSUb_coeff_eff_1 PSUb_coeff_eff_2  PSUb_kink  cutoff_top15b modalidad // includes all model initial conditions (aside from type_prob_controls) except region, but we do not expect systematic correlation between region and other regressors 
global type_prob_controls female survey_missing   // model initial conditions that only affect type prob, excluding top15baseline (not used as control)
global c_initial_cond GPA_avg_1_2 simce_avg_st Pgradb GPAb_coeff_eff PSUb_coeff_eff_1 PSUb_coeff_eff_2  PSUb_kink  cutoff_top15b // continuous
global i_initial_cond modalidad female  // discrete, excluding top15baseline (not used as control)

label var GPA_avg_1_2 "Avg GPA in 9-10"
label var simce_avg_st "Simce"
label var Pgradb "Pgrad belief"
label var GPAb_coeff_eff "GPAb eff coeff"
label var PSUb_coeff_eff_1      "PSUb eff coeff below kink"
label var PSUb_coeff_eff_2 "PSUb eff coeff above kink"
label var PSUb_kink "PSUb kink point (hrs/wk)"
label var cutoff_top15b "Cutoff top15 belief"
label var modalidad "Track"
label var female "Female"
label var survey_missing "Survey missing"
label var treatment "Treatment"
label var expPSUscore_st "PSUb"
label var hours_study "Hours of study"
label var top15baseline "Top 15 baseline"


*rename admitted_SUA_regular_or_pace admitted_SUA 



* --------------------------
* Auxiliary models 1-4 (7)
* --------------------------
* Run regressions, auxiliary models 1-4 

* Match coeff on female and missing survey (2)
	*reg sim_sit_PSU $initial_cond_controls_v1 $type_prob_controls , cluster(rbd_basefinal)
	reg sit_PSU $initial_cond_controls_v1 $type_prob_controls , cluster(rbd_basefinal)
	local sitPSU_fem=_b[female]
	local VsitPSU_fem=(_se[female])^2
	local sitPSU_missing=_b[survey_missing ]
	local VsitPSU_missing=(_se[survey_missing ])^2
	
* Match coeff on female  (1) 
	*reg sim_hours_study $initial_cond_controls_v1 $type_prob_controls if hours_study!=., cluster(rbd_basefinal)  // NB: condition on hours_study nonmissing in data 
	reg hours_study $initial_cond_controls_v1 $type_prob_controls , cluster(rbd_basefinal)
	local hours_fem=_b[female]
	local Vhours_fem=(_se[female])^2
	
* Match coeff on simce (1)
	*reg sim_hours_study simce_avg_st if hours_study!=., cluster(rbd_basefinal) // NB: condition on hours_study nonmissing in data 
	reg hours_study simce_avg_st, cluster(rbd_basefinal)
	local hours_simce=_b[simce_avg_st]
	local Vhours_simce=(_se[simce_avg_st])^2
	
* Match coeff on female and missing_survey and constant  (3)
	*reg sim_enrolled_SUA $type_prob_controls if treatment==0, cluster(rbd_basefinal)
	reg enrolled_SUA_by_y1 $type_prob_controls if treatment==0, cluster(rbd_basefinal)
	local enrolledC_fem=_b[female]
	local VenrolledC_fem=(_se[female])^2
	local enrolledC_missing=_b[survey_missing ]
	local VenrolledC_missing=(_se[survey_missing ])^2
	local enrolledC_cons=_b[_cons]
	local VenrolledC_cons=(_se[_cons])^2
	
	

* -----------------------------------------------------------------
* Auxiliary models TE on admissions, enrollments, persistence (12)
* -----------------------------------------------------------------

* In all regressions, match coefficient on treatment and match outcome mean in control group 

* All sample 
* admissions (2)
	*reg sim_admitted treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
	reg admitted_SUA treatment  $initial_cond_controls_v1 female , cluster(rbd_basefinal)
	local TEadm_all=_b[treatment]
	local VTEadm_all=(_se[treatment])^2
	
	*su sim_admitted  if treatment==0
	quietly su admitted_SUA  if treatment==0, detail
	local admC_all=`r(mean)'
	local VadmC_all=`r(Var)'/`r(N)'
	
* enrollments (2)
	*reg sim_enrolled_SUA  treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
	reg enrolled_SUA_by_y1 treatment  $initial_cond_controls_v1 female , cluster(rbd_basefinal)
	local TEenroll_all=_b[treatment]
	local VTEenroll_all=(_se[treatment])^2
	
	*su sim_enrolled_SUA   if treatment==0
	quietly su enrolled_SUA_by_y1   if treatment==0, detail 
	local enrollC_all=`r(mean)'
	local VenrollC_all=`r(Var)'/`r(N)'
	
* persistence (2)
	* reg sim_persist_SUA  treatment $initial_cond_controls_v1 female, cluster(rbd_basefinal)
	reg enrolled_SUA_by_y5 treatment  $initial_cond_controls_v1 female , cluster(rbd_basefinal)
	local TEpers_all=_b[treatment]
	local VTEpers_all=(_se[treatment])^2
	
	*su sim_persist_SUA   if treatment==0
	quietly su enrolled_SUA_by_y5   if treatment==0, detail 
	local persC_all=`r(mean)'
	local VpersC_all=`r(Var)'/`r(N)'
	
	
*Top 15% sample
* admissions (2)
	*reg sim_admitted treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
	reg admitted_SUA treatment  $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
	local TEadm_15=_b[treatment]
	local VTEadm_15=(_se[treatment])^2
	
	* su sim_admitted  if treatment==0 & top15baseline ==1
	quietly su admitted_SUA  if treatment==0 & top15baseline ==1, detail
	local admC_15=`r(mean)'
	local VadmC_15=`r(Var)'/`r(N)'
	
* enrollments (2)
	*reg sim_enrolled_SUA  treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
	reg enrolled_SUA_by_y1 treatment  $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
	local TEenroll_15=_b[treatment]
	local VTEenroll_15=(_se[treatment])^2
	
	*su sim_enrolled_SUA   if treatment==0 & top15baseline ==1
	quietly su enrolled_SUA_by_y1 if treatment==0 & top15baseline ==1, detail 
	local enrollC_15=`r(mean)'
	local VenrollC_15=`r(Var)'/`r(N)'
	
* persistence (2)
	*reg sim_persist_SUA  treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
	reg enrolled_SUA_by_y5 treatment  $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
	local TEpers_15=_b[treatment]
	local VTEpers_15=(_se[treatment])^2
	
	* su sim_persist_SUA   if treatment==0 & top15baseline ==1
	quietly su enrolled_SUA_by_y5   if treatment==0 & top15baseline ==1, detail 
	local persC_15=`r(mean)'
	local VpersC_15=`r(Var)'/`r(N)'
	
	

* ------------------------------------
* Auxiliary models 5-8 (8)
* ------------------------------------

* Match constant and coefficient on expPSUscore_st (2)
	*reg sim_sit_PSU expPSUscore_st if treatment==0, cluster(rbd_basefinal)  // NB: regress on PSUb from data. Cond on matching hours study, we match PSUb outside model
     reg sit_PSU expPSUscore_st if treatment==0, cluster(rbd_basefinal)  
	 local sitPSUC_cons=_b[_cons]
	 local VsitPSUC_cons=(_se[_cons])^2
	 local sitPSUC_expPSU=_b[expPSUscore_st]
	 local VsitPSUC_expPSU=(_se[expPSUscore_st])^2
	 
* Match coeff on female and survey_missing  (2)
	* reg sim_admitted survey_missing female  if treatment==0, cluster(rbd_basefinal)
	reg admitted_SUA survey_missing female  if treatment==0, cluster(rbd_basefinal)
	local admC_female=_b[female]
	local VadmC_female=(_se[female])^2
	local admC_missing=_b[survey_missing]
	local VadmC_missing=(_se[survey_missing])^2
	
* Match coeff on GPA_avg_1_2 and simce  (2)
	* reg sim_admitted_SUA_regular GPA_avg_1_2 simce_avg_st $type_prob_controls   if treatment==0, cluster(rbd_basefinal)
	reg admitted_SUA_regular GPA_avg_1_2 simce_avg_st $type_prob_controls if treatment==0, cluster(rbd_basefinal)
	local admRC_GPA910=_b[GPA_avg_1_2]
	local VadmRC_GPA910=(_se[GPA_avg_1_2])^2
	local admRC_simce=_b[simce_avg_st]
	local VadmRC_simce=(_se[simce_avg_st])^2
	
* Match coefficient on female and survey_missing (2)
	* reg sim_GPA female survey_missing $initial_cond_controls_v1 $type_prob_controls if GPA_cuarto_medio!=., cluster(rbd_basefinal) // NB condition on nonmissing GPA_carto_medio in data 
	reg GPA_cuarto_medio female survey_missing $initial_cond_controls_v1 $type_prob_controls, cluster(rbd_basefinal)
	local GPA_fem=_b[female]
	local VGPA_fem=(_se[female])^2
	local GPA_missing=_b[survey_missing ]
	local VGPA_missing=(_se[survey_missing ])^2
	 


* ------------------------------------
* Auxiliary models 9-11 (6)
* ------------------------------------
* Match coeff on hours_study, on GPA segundo, on simce (3)
	* reg sim_GPA hours_study  GPA_avg_1_2 simce_avg_st $initial_cond_controls_v1   if hours_study!=., cluster(rbd_basefinal) // NB Use actual hours_study as regressor
	reg GPA_cuarto_medio hours_study  GPA_avg_1_2 simce_avg_st $initial_cond_controls_v1  if hours_study!=., cluster(rbd_basefinal) 
	local GPA_hours=_b[hours_study]
	local VGPA_hours=(_se[hours_study])^2
	local GPA_GPA910=_b[GPA_avg_1_2]
	local VGPA_GPA910=(_se[GPA_avg_1_2])^2
	local GPA_simce=_b[simce_avg_st]
	local VGPA_simce=(_se[simce_avg_st])^2
	
* Match coeff on female and simce (2)
	* reg sim_persist_SUA  simce_avg_st female  survey_missing ,  cluster(rbd_basefinal )
	reg enrolled_SUA_by_y5 simce_avg_st female  survey_missing ,  cluster(rbd_basefinal )
	local pers_fem=_b[female]
	local Vpers_fem=(_se[female])^2
	local pers_simce=_b[simce_avg_st]
	local Vpers_simce=(_se[simce_avg_st])^2
	
* Match coeff on Pgradb (1)
	* reg sim_enrolled_SUA  Pgradb if treatment==0 & admitted_SUA_regular==1, cluster(rbd_basefinal) // NB condition on admitted regular from data 
	reg enrolled_SUA_by_y1  Pgradb if treatment==0 & admitted_SUA_regular==1, cluster(rbd_basefinal)
	local enrolladmC_Pgradb=_b[Pgradb]
	local VenrolladmC_Pgradb=(_se[Pgradb])^2
	
	
	
* ---------------------------------------------------------------
* Auxiliary models TE on effort and sit PSU (5)
* --------------------------------------------------------------
	
* Match TE and outcome mean in C group (2) -- NB: fit becomes worse if we add survey_missing as a control. DO NOT DO THIS. It's not a baseline var anyway and there's a slight imbalance.
	*reg sim_hours_study  treatment $initial_cond_controls_v1 female, cluster(rbd_basefinal)
	reg hours_study treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
	local TEhours=_b[treatment]
	local VTEhours=(_se[treatment])^2
	
	*su sim_hours_study   if treatment==0
	quietly su hours_study  if treatment==0, detail 
	local hoursC=`r(mean)'
	local VhoursC=`r(Var)'/`r(N)'	
	
	
* Match TE and outcome mean in C group (2)
	*reg sim_sit_PSU  treatment $initial_cond_controls_v1  female, cluster(rbd_basefinal)
	reg sit_PSU treatment  $initial_cond_controls_v1 female , cluster(rbd_basefinal)
	local TEsitPSU=_b[treatment]
	local VTEsitPSU=(_se[treatment])^2
	
	*su sim_sit_PSU   if treatment==0
	quietly  su sit_PSU  if treatment==0, detail 
	local sitPSUC=`r(mean)'
	local VsitPSUC=`r(Var)'/`r(N)'	
	
	
	
* Match coeff on interaction treatment X perceived distance cutoff (1)
 
	reg hours_study  Txperceived_dist treatment perceived_dist_cutoff  c.perceived_dist_cutoff##c.($c_initial_cond) c.perceived_dist_cutoff##i.($i_initial_cond) if hours_study!=. ,  cluster(rbd_basefinal)
	local TEhours_Xperceived=_b[Txperceived_dist]
	local VTEhours_Xperceived=(_se[Txperceived_dist])^2

	
	
	

* --------------------------------------------------------
* Summary statisics to match + TE effort top 15% (14)
* -------------------------------------------------------

* Match proportion (1)
	*sum sim_sit_PSU if female==0 & survey_missing==0
	quietly sum sit_PSU if female==0 & survey_missing==0, detail 
	local sitPSUfem0miss0=`r(mean)'
	local VsitPSUfem0miss0=`r(Var)'/`r(N)'
	

* Match mean (1)
	*sum sim_hours_study if female==1 & hours_study!=. // NB condition on hours study nonmissing in data
	quietly sum hours_study if female==1 , detail 
	local hoursfem=`r(mean)'
	local Vhoursfem=`r(Var)'/`r(N)'
	 

* Match proportion (1)
	*sum sim_enrolled_SUA_pace  if admitted_SUA_regular ==1 & admitted_SUA_pace==1 // NB condition on data admissions
	quietly sum enrolled_SUA_pace  if admitted_SUA_regular ==1 & admitted_SUA_pace==1, detail 
	local enrolledP_admboth=`r(mean)'
	local VenrolledP_admboth=`r(Var)'/`r(N)'
	 

* Match standard deviation (1)
	*sum sim_PSU_latent  if sit_PSU==1 & treatment==0 // NB condition on sit PSU from data, use latent sim PSU that is simulated also for those with sim_sit_PSU==0
	quietly sum PSU_score_if_positive_st if sit_PSU==1 & treatment==0, detail 
	local  varPSUC=`r(Var)'
	local  VvarPSUC=2*((`r(Var)')^2)/(`r(N)'-1) 
	
	

* Match mean and standard deviation (2)
	*sum sim_GPA if treatment==0
	quietly sum GPA_cuarto_medio if treatment==0 , detail 
	local GPAC=`r(mean)'
	local VGPAC= `r(Var)'/`r(N)'
	local varGPAC=`r(Var)'
	local VvarGPAC=2*((`r(Var)')^2)/(`r(N)'-1)
	

* Match proportions  (2)
	*sum sim_admitted_SUA_pace if treatment==1 
	quietly sum admitted_SUA_pace if treatment==1 , detail 
	local admPT=`r(mean)'
	local VadmPT=`r(Var)'/`r(N)'
	
	*sum sim_admitted_SUA_pace if treatment==1 & top15baseline==1
	quietly sum admitted_SUA_pace if treatment==1 & top15baseline==1, detail 
	local admPT_15=`r(mean)'
	local VadmPT_15=`r(Var)'/`r(N)'
	

* Match standard deviation  (1)
	*sum sim_hours_study if hours_study!=. & treatment==0 // NB condition on hours study nonmissing in data 
	quietly sum hours_study if treatment==0, detail 
	local varhoursC =`r(Var)'
	local VvarhoursC =2*((`r(Var)')^2)/(`r(N)'-1)
	

* Match top15endline conditional on top15baseline  (2)
      quietly sum top15endline if top15baseline==1 & treatment==0
	  local top15base_end0 =`r(mean)'
	  local Vtop15base_end0 =`r(Var)'/`r(N)'
      quietly sum top15endline if top15baseline==1 & treatment==1
	  local top15base_end1 =`r(mean)'
	  local Vtop15base_end1 =`r(Var)'/`r(N)'
	  
* Match enrollment conditional on admitted e top15 baseline  (2)
     quietly sum enrolled_SUA_in_y1 if top15baseline==1 & treatment==0 & admitted_SUA==1
	  local enr_adm0 =`r(mean)'
	  local Venr_adm0 =`r(Var)'/`r(N)'    
     quietly sum enrolled_SUA_in_y1 if top15baseline==1 & treatment==1 & admitted_SUA==1
	  local enr_adm1 =`r(mean)'
	  local Venr_adm1 =`r(Var)'/`r(N)'  


* --------------------------------------------------------------------------------------
* TE among college entrants to match larger dropout among college entrantes in T group (1)
* -------------------------------------------------------------------------------------- 

* Match TE 
	reg enrolled_SUA_by_y5 treatment if top15baseline ==1 &  enrolled_SUA_by_y1==1 , cluster(rbd_basefinal)
	local TEpers_enr_T15=_b[treatment]
	local VTEpers_enr_T15=(_se[treatment])^2

   
* Store all empirical coefficients in a dataset
use "$dataClean/empirical_coefficients_rescale_bootstrap`s'.dta", clear

forvalues i = 1(1)`num_obs' {
    local coefficient: word `i' of `names_coefficients'
	replace coefficient_value=``coefficient'' if num_coefficient==`i'
	replace coefficient_variance_value=`V`coefficient'' if num_coefficient==`i'
			di "`coefficient'"
}
drop num_coefficient
gen weight=1/coefficient_variance_value
* Rescale to avoid too large weights that make Julia crash
quietly sum weight, de 
local mean_weight=`r(mean)'
gen weightv2=weight/`mean_weight'

drop weight coefficient_variance_value
rename weightv2 weight 

saveold "$dataClean/empirical_coefficients_rescale_bootstrap`s'.dta", replace 
}
