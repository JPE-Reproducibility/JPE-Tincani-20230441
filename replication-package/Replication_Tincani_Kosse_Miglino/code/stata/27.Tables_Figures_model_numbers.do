********************************************************************************
* DO-FILE DESCRIPTION:
* This do-file defines the globals and then
* i) creates the Tables and Figures related to model results
* ii) creates a log file with all in-text-numbers

********************************************************************************
/*------------------------------------------------------------------------------
	1) Install programs
	2) Main setup
	3) Define globals
	4) Execution
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
		
capture noisily do "code/stata/00.setup.do"
if _rc {
    do "00.setup.do"
}


	discard 
	
	which lasso2
	which lassoutils
	which rwolf2
	
	set scheme cleanplots
	
	
*******************************************************************************
**#	Table 7: Returns to pre-college effort in persistence and omitted variable bias
********************************************************************************
* Run this after model simulations
insheet using "$dataClean/baseline_TC_2types_rescale.csv", clear
rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
rename x11 sim_sit_PSU
rename x12 sim_PSU_latent
gen sim_PSU_observed=sim_PSU_latent if sim_sit_PSU==1
label var sim_PSU_latent "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA
rename x14 sim_PSUb
rename x15 sim_prob_adm_pace_b
rename x16 sim_prob_adm_regular_b
rename x17 sim_GPAb
rename x18 sim_pr_persist
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data
rename x21 sim_ret_eff_pr_adm_b_0
rename x22 sim_ret_eff_pr_adm_b_1
rename x23 sim_ret_eff_pr_adm_b_2
rename x24 sim_ret_eff_pr_adm_b_3
rename x25 sim_ret_eff_pr_adm_b_4
rename x26 sim_ret_eff_pr_adm_b_5
rename x27 sim_ret_eff_pr_adm_b_6
rename x28 sim_ret_eff_pr_adm_b_7
rename x29 sim_ret_eff_pr_adm_b_8
rename x30 sim_ret_eff_pr_adm_b_9
rename x31 sim_hours_study_latent

forvalues h = 0/9 {
	replace sim_ret_eff_pr_adm_b_`h'=. if sim_ret_eff_pr_adm_b_`h' ==-99
}

* Actual returns to effort according to simulated hours of study 
gen sim_ret_eff_pr_adm_b_actual = .

forvalues h = 0/9 {
    replace sim_ret_eff_pr_adm_b_actual = sim_ret_eff_pr_adm_b_`h' if sim_hours_study_latent == `h'
}

rename x32 sim_type
gen high_type=1 if sim_type==1
replace high_type=0 if sim_type==2
rename x33 sim_utility_expected // ex-post utility based on perceptions, before dropouts occur
rename x34 sim_utility_actual   // ex-post utility based on actual dropouts
rename x35 sim_top15_actual
label var sim_top15_actual  "Sim. in top 15 actual"
rename x36 sim_sel_regular
rename x37 sim_sel_pace
gen sim_sel_enrolled=sim_sel_regular if sim_enrolled_SUA_regular==1
replace sim_sel_enrolled=sim_sel_pace if sim_enrolled_SUA_pace==1
rename x38 sim_PDV_2_nosit 
rename x39 sim_PDV_2_sit
rename x40 sim_PDV_4_ER // we have this value even for those without admissions
rename x41 sim_PDV_4_EP // we have this value even for those without admissions
rename x42 sim_PDV_4_ERdropout // we have this value even for those without admissions
rename x43 sim_PDV_4_EPdropout // we have this value even for those without admissions
rename x44 sim_PDV_4_GradP // we have this value even for those without admissions
rename x45 sim_PDV_4_GradR // we have this value even for those without admissions
rename x46 sim_GPA_all
label var sim_GPA_all "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0
rename x48 sim_PDV_1_eff1
rename x49 sim_PDV_1_eff2
rename x50 sim_PDV_1_eff3
rename x51 sim_PDV_1_eff4
rename x52 sim_PDV_1_eff5
rename x53 sim_PDV_1_eff6
rename x54 sim_PDV_1_eff7
rename x55 sim_PDV_1_eff8
rename x56 sim_PDV_1_eff9
rename x57 sim_PDV_1_eff10
rename x58 sim_Ut_1_eff0
rename x59 sim_Ut_1_eff1
rename x60 sim_Ut_1_eff2
rename x61 sim_Ut_1_eff3
rename x62 sim_Ut_1_eff4
rename x63 sim_Ut_1_eff5
rename x64 sim_Ut_1_eff6
rename x65 sim_Ut_1_eff7
rename x66 sim_Ut_1_eff8
rename x67 sim_Ut_1_eff9
rename x68 sim_Ut_1_eff10
rename x69 sim_Emax_1_eff0
rename x70 sim_Emax_1_eff1
rename x71 sim_Emax_1_eff2
rename x72 sim_Emax_1_eff3
rename x73 sim_Emax_1_eff4
rename x74 sim_Emax_1_eff5
rename x75 sim_Emax_1_eff6
rename x76 sim_Emax_1_eff7
rename x77 sim_Emax_1_eff8
rename x78 sim_Emax_1_eff9
rename x79 sim_Emax_1_eff10
rename x80 m_shock 
rename x81 sim_ut_enroll_dropout_R
rename x82 sim_ut_enroll_dropout_P
rename x83 sim_ut_enroll_grad_R
rename x84 sim_ut_enroll_grad_P

merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110

sum sim_PDV_1_eff* 
sum sim_Ut_1_eff*
sum sim_Emax_1_eff*


* Generate simulated variables used in the analysis
* Used in description of beliefs: 
gen sim_PSU_bias=sim_PSUb-sim_PSU_observed 
label var sim_PSU_bias "Simulated believed minus actual entrance exam score \$|\$ sim. took exam (\$\sigma\$)"
gen sim_bias_own_NEM=sim_GPAb-sim_GPA 
label var sim_bias_own_NEM "Simulated believed minus actual \$12^{th}\$ grade GPA (GPA points)"
gen sim_p_admitted_above_050=1 if sim_prob_adm_regular_b>=0.5 & sim_prob_adm_regular_b!=.
replace sim_p_admitted_above_050=0 if sim_prob_adm_regular_b<0
label var sim_p_admitted_above_050 "Simulated subj prob regular admission \$\geq 0.50\$"
label var sim_prob_adm_regular_b "Simulated subjective probability of a regular admission"
label var sim_GPAb "Believed GPA"
*Top 15 cutoff used in model
gen perceived_top15_cutoff=NEM_top15_April
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
gen sim_minus_bias_top15=sim_top15_actual-perceived_top15_cutoff
label var  sim_minus_bias_top15 "Simuulated actual minus believed top \$15\%\$ cutoff in school (GPA points)"
gen sim_think_top15=1 if sim_GPAb>=perceived_top15_cutoff & sim_GPAb!=.
replace sim_think_top15=0 if sim_GPAb<perceived_top15_cutoff
label var sim_think_top15 "Simulated to believe is in top \$15\%\$ of school"

gen sim_perceived_above_cutoff=sim_GPAb-perceived_top15_cutoff
label var sim_perceived_above_cutoff "Sim. expected GPA minus expected cutoff"

gen perceived_above_cutoff=exp_NEM-perceived_top15_cutoff
label var perceived_above_cutoff "Expected GPA minus expected cutoff"

* Following variables used only to guide calibration 
gen y_data_missing=1 if score_all_st==.
replace y_data_missing=0 if score_all_st!=.

gen top15_actual=top15endline 
label var top15_actual "Top 15% based on all years GPA"

gen GPA_all = 0.5*GPA_avg_1_2 + 0.25 * GPA_tercero_medio +0.2*GPA_cuarto_medio 
label var GPA_all "GPA all 4 years"

* Regression without and with type as a control 
est clear 
reg  sim_pr_persist sim_hours_study_latent   simce_avg_st 
su sim_pr_persist
estadd scalar MEAN=`r(mean)'
est store m1
reg sim_pr_persist sim_hours_study_latent  simce_avg_st  high_type 
su sim_pr_persist
estadd scalar MEAN=`r(mean)'
est store m2

label var  sim_hours_study_latent "Simulated study hours/week"
label var high_type "Unobserved type 1"
label var simce_avg_st "Simce score"

* Store results 
esttab m1 m2 using "$tables/causal_correlational_returns_eff_pers.tex", replace  ///
    booktabs label unstack noobs keep(sim_hours_study_latent high_type) ///   // simce_avg_st 
    cells(b(fmt(3))) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers  nomtitles ///
    stats(MEAN  , fmt(3) labels("\hline Outcome mean"     )) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\begin{threeparttable}  "' ///
	`"\setlength\tabcolsep{0pt} "' 	`"\setlength\extrarowheight{2pt}"' 	`"\caption{\label{reteffpers} \textsc{Returns to pre-college effort in persistence and omitted variable bias}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\hline"' ///
		`"&  \multicolumn{2}{c}{Simulated college persistence probability}    \\  "' ///
		`"& (1)             & (2)  \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--} The coefficients are OLS estimates of regressions of the simulated persistence probability on baseline Simce test scores and on simulated weekly study hours in high school. The second column includes a dummy for the unobserved student type as control variable. Simulations are performed using the structural-model estimation sample and the estimated model parameters. Outcome mean for this sample reported. " "\end{tablenotes}" `"\end{threeparttable}  "' "\end{table}") 
	


*******************************************************************************
**#	Table 8: Returns to pre-college effort in persistence and omitted variable bias
********************************************************************************
insheet using "$dataClean/baseline_TC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
rename x11 sim_sit_PSU
rename x12 sim_PSU_latent
gen sim_PSU_observed=sim_PSU_latent if sim_sit_PSU==1
label var sim_PSU_latent "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA
rename x14 sim_PSUb
rename x15 sim_prob_adm_pace_b
rename x16 sim_prob_adm_regular_b
rename x17 sim_GPAb
rename x18 sim_pr_persist
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data
rename x21 sim_ret_eff_pr_adm_b_0
rename x22 sim_ret_eff_pr_adm_b_1
rename x23 sim_ret_eff_pr_adm_b_2
rename x24 sim_ret_eff_pr_adm_b_3
rename x25 sim_ret_eff_pr_adm_b_4
rename x26 sim_ret_eff_pr_adm_b_5
rename x27 sim_ret_eff_pr_adm_b_6
rename x28 sim_ret_eff_pr_adm_b_7
rename x29 sim_ret_eff_pr_adm_b_8
rename x30 sim_ret_eff_pr_adm_b_9
rename x31 sim_hours_study_latent
rename x32 sim_type
gen high_type=1 if sim_type==1
replace high_type=0 if sim_type==2
rename x33 sim_utility_expected // ex-post utility based on perceptions, before dropouts occur
rename x34 sim_utility_actual   // ex-post utility based on actual dropouts
rename x35 sim_top15_actual
label var sim_top15_actual  "Sim. in top 15 actual"
rename x36 sim_sel_regular
rename x37 sim_sel_pace
gen sim_sel_enrolled=sim_sel_regular if sim_enrolled_SUA_regular==1
replace sim_sel_enrolled=sim_sel_pace if sim_enrolled_SUA_pace==1
rename x38 sim_PDV_2_nosit 
rename x39 sim_PDV_2_sit
rename x40 sim_PDV_4_ER // we have this value even for those without admissions
rename x41 sim_PDV_4_EP // we have this value even for those without admissions
rename x42 sim_PDV_4_ERdropout // we have this value even for those without admissions
rename x43 sim_PDV_4_EPdropout // we have this value even for those without admissions
rename x44 sim_PDV_4_GradP // we have this value even for those without admissions
rename x45 sim_PDV_4_GradR // we have this value even for those without admissions
rename x46 sim_GPA_all
label var sim_GPA_all "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0
rename x48 sim_PDV_1_eff1
rename x49 sim_PDV_1_eff2
rename x50 sim_PDV_1_eff3
rename x51 sim_PDV_1_eff4
rename x52 sim_PDV_1_eff5
rename x53 sim_PDV_1_eff6
rename x54 sim_PDV_1_eff7
rename x55 sim_PDV_1_eff8
rename x56 sim_PDV_1_eff9
rename x57 sim_PDV_1_eff10
rename x58 sim_Ut_1_eff0
rename x59 sim_Ut_1_eff1
rename x60 sim_Ut_1_eff2
rename x61 sim_Ut_1_eff3
rename x62 sim_Ut_1_eff4
rename x63 sim_Ut_1_eff5
rename x64 sim_Ut_1_eff6
rename x65 sim_Ut_1_eff7
rename x66 sim_Ut_1_eff8
rename x67 sim_Ut_1_eff9
rename x68 sim_Ut_1_eff10
rename x69 sim_Emax_1_eff0
rename x70 sim_Emax_1_eff1
rename x71 sim_Emax_1_eff2
rename x72 sim_Emax_1_eff3
rename x73 sim_Emax_1_eff4
rename x74 sim_Emax_1_eff5
rename x75 sim_Emax_1_eff6
rename x76 sim_Emax_1_eff7
rename x77 sim_Emax_1_eff8
rename x78 sim_Emax_1_eff9
rename x79 sim_Emax_1_eff10
rename x80 m_shock 

merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110

sum sim_PDV_1_eff* 
sum sim_Ut_1_eff*
sum sim_Emax_1_eff*


* Generate simulated variables used in the analysis
gen sim_PSU_bias=sim_PSUb-sim_PSU_observed 
label var sim_PSU_bias "Simulated believed minus actual entrance exam score \$|\$ sim. took exam (\$\sigma\$)"
gen sim_bias_own_NEM=sim_GPAb-sim_GPA 
label var sim_bias_own_NEM "Simulated believed minus actual \$12^{th}\$ grade GPA (GPA points)"
gen sim_p_admitted_above_050=1 if sim_prob_adm_regular_b>=0.5 & sim_prob_adm_regular_b!=.
replace sim_p_admitted_above_050=0 if sim_prob_adm_regular_b<0
label var sim_p_admitted_above_050 "Simulated subj prob regular admission \$\geq 0.50\$"
label var sim_prob_adm_regular_b "Simulated subjective probability of a regular admission"
label var sim_GPAb "Believed GPA"
gen perceived_top15_cutoff=NEM_top15_April // Top 15 cutoff used in model
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
gen sim_minus_bias_top15=sim_top15_actual-perceived_top15_cutoff
label var  sim_minus_bias_top15 "Simuulated actual minus believed top \$15\%\$ cutoff in school (GPA points)"
gen sim_think_top15=1 if sim_GPAb>=perceived_top15_cutoff & sim_GPAb!=.
replace sim_think_top15=0 if sim_GPAb<perceived_top15_cutoff
label var sim_think_top15 "Simulated to believe is in top \$15\%\$ of school"
gen sim_perceived_above_cutoff=sim_GPAb-perceived_top15_cutoff
label var sim_perceived_above_cutoff "Sim. expected GPA minus expected cutoff"
gen perceived_above_cutoff=exp_NEM-perceived_top15_cutoff
label var perceived_above_cutoff "Expected GPA minus expected cutoff"
gen y_data_missing=1 if score_all_st==.
replace y_data_missing=0 if score_all_st!=.
gen top15_actual=top15endline 
label var top15_actual "Top 15% based on all years GPA"
gen GPA_all = 0.5*GPA_avg_1_2 + 0.25 * GPA_tercero_medio +0.2*GPA_cuarto_medio 
label var GPA_all "GPA all 4 years"


global initial_cond_controls_v1 GPA_avg_1_2 simce_avg_st Pgradb GPAb_coeff_eff PSUb_coeff_eff_1 PSUb_coeff_eff_2 PSUb_kink  cutoff_top15b modalidad // includes all model initial conditions (aside from type_prob_controls) except region, but we do not expect systematic correlation between region and other regressors 

label var sim_score  "Sim. Test Score"
label var sim_hours_study "Sim. Hours Study"
label var hours_study "Hours Study"
label var GPA_cuarto_medio "GPA Grade 12"
label var sim_GPA "Sim. GPA Grade 12"
label var treatment "Treatment"
gen cutoff_top15b=perceived_top15_cutoff
replace cutoff_top15b=actual_top15_cutoff if cutoff_top15b==. 
replace NEM_top15_April=NEM_top15 if NEM_top15_April==.
gen believed_distance_from_cutoff=abs(exp_NEM-NEM_top15_April) 
lab var believed_distance_from_cutoff "perceived dist. from cutoff"

*if `bloc_ATE_fe' == 1 {
est clear 

reg hours_study  treatment $initial_cond_controls_v1 female i.id_fieldworker  [weight=weight_mat] ,  cluster(rbd_basefinal)
su hours_study  if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m1

reg sim_hours_study  treatment $initial_cond_controls_v1 female  i.id_fieldworker  if hours_study!=.  [weight=weight_mat] ,  cluster(rbd_basefinal)
su sim_hours_study  if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'

est store m1sim

reg hours_study  treatment i.treatment##c.believed_distance_from_cutoff  c.believed_distance_from_cutoff##c.GPA_avg_1_2 c.believed_distance_from_cutoff##c.simce_avg_st c.believed_distance_from_cutoff##c.Pgradb c.believed_distance_from_cutoff##c.GPAb_coeff_eff c.believed_distance_from_cutoff##c.PSUb_coeff_eff_1 c.believed_distance_from_cutoff##c.PSUb_coeff_eff_2 c.believed_distance_from_cutoff##c.PSUb_kink  c.believed_distance_from_cutoff##c.cutoff_top15b c.believed_distance_from_cutoff##c.modalidad c.believed_distance_from_cutoff##i.female  c.believed_distance_from_cutoff##i.id_fieldworker [weight=weight_mat]    if hours_study!=. ,  cluster(rbd_basefinal)
su hours_study if e(sample)==1 
estadd scalar MEAN=`r(mean)'
est store m2

reg sim_hours_study treatment i.treatment##c.believed_distance_from_cutoff  c.believed_distance_from_cutoff##c.GPA_avg_1_2 c.believed_distance_from_cutoff##c.simce_avg_st c.believed_distance_from_cutoff##c.Pgradb c.believed_distance_from_cutoff##c.GPAb_coeff_eff c.believed_distance_from_cutoff##c.PSUb_coeff_eff_1 c.believed_distance_from_cutoff##c.PSUb_coeff_eff_2 c.believed_distance_from_cutoff##c.PSUb_kink  c.believed_distance_from_cutoff##c.cutoff_top15b c.believed_distance_from_cutoff##c.modalidad c.believed_distance_from_cutoff##i.female  c.believed_distance_from_cutoff##i.id_fieldworker [weight=weight_mat]   if hours_study!=. & believed_distance_from_cutoff!=. ,  cluster(rbd_basefinal)
su sim_hours_study if e(sample)==1 
estadd scalar MEAN=`r(mean)'

est store m2sim

reg  GPA_cuarto_medio treatment $initial_cond_controls_v1 female  if in_sample == 1  [pweight=weight_mat] , cluster(rbd_basefinal)
su GPA_cuarto_medio if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m3

reg  sim_GPA treatment $initial_cond_controls_v1 female if in_sample == 1  & GPA_cuarto_medio!=. [pweight=weight_mat] , cluster(rbd_basefinal)
su sim_GPA if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'

est store m3sim 

reg sit_PSU  treatment $initial_cond_controls_v1 female,  cluster(rbd_basefinal)
su sit_PSU  if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m4

reg sim_sit_PSU treatment $initial_cond_controls_v1 female,  cluster(rbd_basefinal)
su sim_sit_PSU  if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'

est store m4sim

esttab m1 m1sim m2 m2sim m3 m3sim m4 m4sim  using "$tables/TE_pre_college_outcomes_model_fit.tex", replace ///
    booktabs label unstack noobs keep(treatment 1.treatment#c.believed_distance_from_cutoff) ///
	coeflabels(treatment  "Treatment" 1.treatment#c.believed_distance_from_cutoff "Treatment $\times$ Perceived distance") ///
    cells(b(fmt(3)) se(par fmt(3) pattern(1 0 1 0 1 0 1 0))) nostar ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN, fmt(3) labels("Control mean" )) ///
    prehead(`"\begin{table}[h]\centering %htbp"' `"\footnotesize "' `"\begin{threeparttable}  "' ///
	`"\setlength\tabcolsep{0pt} "' 	`"\setlength\extrarowheight{2pt}"' 	`"\caption{\label{TEprecollegeoutcomes} \textsc{Model Fit - Effect of PACE on pre-College Outcomes}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{8}{c}}"' `"\hline"' ///
		`"&   \multicolumn{2}{c}{Study hours/week} & \multicolumn{2}{c}{Study hours/week}  & \multicolumn{2}{c}{$12^{th}$ grade GPA} & \multicolumn{2}{c}{Take PSU}  \\  "' ///
		`"&  \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} &  \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} &  \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} &  \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations}  \\  "'  ///
		`"& (1)             & (2)   &  (3) & (4) & (5) & (6) & (7) & (8) \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  The coefficients are OLS estimates; standard errors clustered at the school level are reported in parentheses for the data columns. All regressions include all model initial conditions except region and survey missing. Field-worker fixed effects were used for columns (1)-(4). Inverse Probability Weights were used for columns (1)-(6). {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. {\itshape Perceived distance} is the absolute value of the difference between perceived own GPA and the perceived $85^{th}$ percentile of the GPA distribution in the school. The outcome variable in columns (1)-(4) is the number of hours of study per week. In columns (3) and (4) we add the interaction of {\itshape Perceived distance} with {\itshape Treatment} and with all the initial conditions and fieldworker fixed effects. The outcome variable in columns (5) and (6) are the GPA in grade 12, measured in GPA points (ranging from 1 to 7). The outcome variable in columns (7) and (8) is an indicator for sitting the college entrance exam.  All regressions are estimated on the sample of students for whom the outcome variable is non-missing in the data." "\end{tablenotes}" `"\end{threeparttable}  "' "\end{table}") 


********************************************************************************
**# Table 9: Simulated effects of baseline and counterfactual intervention
********************************************************************************
insheet using "$dataClean/baseline_CC_2types_rescale.csv", clear
rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
gen sim_enroll_dropout=1 if sim_enrolled_SUA ==1 & sim_persist_SUA ==0
replace sim_enroll_dropout=0 if sim_enroll_dropout==. 
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
rename x11 sim_sit_PSU
rename x12 sim_PSU_latent
gen sim_PSU_observed=sim_PSU_latent if sim_sit_PSU==1
label var sim_PSU_latent "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA
rename x14 sim_PSUb
rename x15 sim_prob_adm_pace_b
rename x16 sim_prob_adm_regular_b
gen sim_prob_adm_b=(1.0-treatment)*sim_prob_adm_regular_b+treatment*(sim_prob_adm_regular_b+sim_prob_adm_pace_b-sim_prob_adm_pace_b*sim_prob_adm_regular_b)
rename x17 sim_GPAb
rename x18 sim_pr_persist
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data
rename x21 sim_ret_eff_pr_adm_b_0
rename x22 sim_ret_eff_pr_adm_b_1
rename x23 sim_ret_eff_pr_adm_b_2
rename x24 sim_ret_eff_pr_adm_b_3
rename x25 sim_ret_eff_pr_adm_b_4
rename x26 sim_ret_eff_pr_adm_b_5
rename x27 sim_ret_eff_pr_adm_b_6
rename x28 sim_ret_eff_pr_adm_b_7
rename x29 sim_ret_eff_pr_adm_b_8
rename x30 sim_ret_eff_pr_adm_b_9
rename x31 sim_hours_study_latent
rename x32 sim_type
gen high_type=1 if sim_type==1
replace high_type=0 if sim_type==2
rename x33 sim_utility_expected // ex-post utility based on perceptions, before dropouts occur
rename x34 sim_utility_actual   // ex-post utility based on actual dropouts
gen welfare_gap_perc=100*(sim_utility_actual -sim_utility_expected)/sim_utility_expected
label var welfare_gap_perc "Ex-post realized welfare gain, percent of ex-ante"
rename x35 sim_top15_actual
label var sim_top15_actual  "Sim. in top 15 actual"
rename x36 sim_sel_regular
rename x37 sim_sel_pace
gen sim_sel_enrolled=sim_sel_regular if sim_enrolled_SUA_regular==1
replace sim_sel_enrolled=sim_sel_pace if sim_enrolled_SUA_pace==1
rename x38 sim_PDV_2_nosit 
rename x39 sim_PDV_2_sit
rename x40 sim_PDV_4_ER // we have this value even for those without admissions
rename x41 sim_PDV_4_EP // we have this value even for those without admissions
rename x42 sim_PDV_4_ERdropout // we have this value even for those without admissions
rename x43 sim_PDV_4_EPdropout // we have this value even for those without admissions
rename x44 sim_PDV_4_GradP // we have this value even for those without admissions
rename x45 sim_PDV_4_GradR // we have this value even for those without admissions
rename x46 sim_GPA_all
label var sim_GPA_all "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0
rename x48 sim_PDV_1_eff1
rename x49 sim_PDV_1_eff2
rename x50 sim_PDV_1_eff3
rename x51 sim_PDV_1_eff4
rename x52 sim_PDV_1_eff5
rename x53 sim_PDV_1_eff6
rename x54 sim_PDV_1_eff7
rename x55 sim_PDV_1_eff8
rename x56 sim_PDV_1_eff9
rename x57 sim_PDV_1_eff10
rename x58 sim_Ut_1_eff0
rename x59 sim_Ut_1_eff1
rename x60 sim_Ut_1_eff2
rename x61 sim_Ut_1_eff3
rename x62 sim_Ut_1_eff4
rename x63 sim_Ut_1_eff5
rename x64 sim_Ut_1_eff6
rename x65 sim_Ut_1_eff7
rename x66 sim_Ut_1_eff8
rename x67 sim_Ut_1_eff9
rename x68 sim_Ut_1_eff10
rename x69 sim_Emax_1_eff0
rename x70 sim_Emax_1_eff1
rename x71 sim_Emax_1_eff2
rename x72 sim_Emax_1_eff3
rename x73 sim_Emax_1_eff4
rename x74 sim_Emax_1_eff5
rename x75 sim_Emax_1_eff6
rename x76 sim_Emax_1_eff7
rename x77 sim_Emax_1_eff8
rename x78 sim_Emax_1_eff9
rename x79 sim_Emax_1_eff10
rename x80 m_shock 
rename x81 sim_Ut_1 
rename x82 sim_Ut_2 
rename x83 sim_Ut_5_ante_b 
rename x84 sim_Ut_5_ante_RE
rename x85 sim_Ut_5_post

gen sim_overenrolled=1 if sim_enrolled_SUA==1 & sim_Ut_5_ante_RE<0
replace sim_overenrolled=0 if sim_overenrolled==.
gen sim_underenrolled=1 if sim_enrolled_SUA==0 & sim_Ut_5_ante_RE>0 &  sim_Ut_5_ante_RE!=. 
replace sim_underenrolled=0 if sim_underenrolled==. 
gen sim_mismatched=1 if sim_underenrolled==1 | sim_overenrolled==1 
replace sim_mismatched=0 if sim_mismatched==.
gen sim_optim_bias_ut_5 = sim_Ut_5_ante_b  - sim_Ut_5_ante_RE

merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110
sum sim_PDV_1_eff* 
sum sim_Ut_1_eff*
sum sim_Emax_1_eff*
* Generate simulated variables used in the analysis
* Used in description of beliefs: 
gen sim_PSU_bias=sim_PSUb-sim_PSU_observed 
label var sim_PSU_bias "Simulated believed minus actual entrance exam score \$|\$ sim. took exam (\$\sigma\$)"
gen sim_bias_own_NEM=sim_GPAb-sim_GPA 
label var sim_bias_own_NEM "Simulated believed minus actual \$12^{th}\$ grade GPA (GPA points)"
gen sim_p_admitted_above_050=1 if sim_prob_adm_regular_b>=0.5 & sim_prob_adm_regular_b!=.
replace sim_p_admitted_above_050=0 if sim_prob_adm_regular_b<0
label var sim_p_admitted_above_050 "Simulated subj prob regular admission \$\geq 0.50\$"
label var sim_prob_adm_regular_b "Simulated subjective probability of a regular admission"
label var sim_GPAb "Believed GPA"
*Top 15 cutoff used in model
gen perceived_top15_cutoff=NEM_top15_April
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
gen sim_minus_bias_top15=sim_top15_actual-perceived_top15_cutoff
label var  sim_minus_bias_top15 "Simuulated actual minus believed top \$15\%\$ cutoff in school (GPA points)"
gen sim_think_top15=1 if sim_GPAb>=perceived_top15_cutoff & sim_GPAb!=.
replace sim_think_top15=0 if sim_GPAb<perceived_top15_cutoff
label var sim_think_top15 "Simulated to believe is in top \$15\%\$ of school"
gen sim_perceived_above_cutoff=sim_GPAb-perceived_top15_cutoff
label var sim_perceived_above_cutoff "Sim. expected GPA minus expected cutoff"
gen perceived_above_cutoff=exp_NEM-perceived_top15_cutoff
label var perceived_above_cutoff "Expected GPA minus expected cutoff"
* Following variables used only to guide calibration 
gen y_data_missing=1 if score_all_st==.
replace y_data_missing=0 if score_all_st!=.
gen top15_actual=top15endline 
label var top15_actual "Top 15% based on all years GPA"
gen GPA_all = 0.5*GPA_avg_1_2 + 0.25 * GPA_tercero_medio +0.2*GPA_cuarto_medio 
label var GPA_all "GPA all 4 years"
preserve
* Open RE simulations and save as .dta 
insheet using "$dataClean/countREandPACE_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score_REP
rename x5 sim_hours_study_REP
rename x6 sim_enrolled_SUA_regular_REP
rename x7 sim_enrolled_SUA_pace_REP 
gen sim_enrolled_SUA_REP = 1 if sim_enrolled_SUA_regular_REP==1 | sim_enrolled_SUA_pace_REP==1
replace sim_enrolled_SUA_REP = 0 if sim_enrolled_SUA_REP==.
rename x8 sim_persist_SUA_REP
gen sim_enroll_dropout_REP=1 if sim_enrolled_SUA_REP ==1 & sim_persist_SUA_REP ==0
replace sim_enroll_dropout_REP=0 if sim_enroll_dropout_REP==. 
rename x9 sim_admitted_SUA_regular_REP
rename x10 sim_admitted_SUA_pace_REP 
gen sim_admitted_REP = 1 if sim_admitted_SUA_regular_REP==1 | sim_admitted_SUA_pace_REP==1
replace sim_admitted_REP = 0 if sim_admitted_REP==.
rename x11 sim_sit_PSU_REP
rename x12 sim_PSU_latent_REP
gen sim_PSU_observed_REP = sim_PSU_latent_REP if sim_sit_PSU_REP==1
label var sim_PSU_latent_REP "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed_REP "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA_REP
rename x14 sim_PSUb_REP
rename x15 sim_prob_adm_pace_b_REP
rename x16 sim_prob_adm_regular_b_REP
gen sim_prob_adm_b_REP=(1.0-treatment)*sim_prob_adm_regular_b_REP+treatment*(sim_prob_adm_regular_b_REP+sim_prob_adm_pace_b_REP-sim_prob_adm_pace_b_REP*sim_prob_adm_regular_b_REP)
rename x17 sim_GPAb_REP
rename x18 sim_pr_persist_REP
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data
rename x21 sim_ret_eff_pr_adm_b_0_REP
rename x22 sim_ret_eff_pr_adm_b_1_REP
rename x23 sim_ret_eff_pr_adm_b_2_REP
rename x24 sim_ret_eff_pr_adm_b_3_REP
rename x25 sim_ret_eff_pr_adm_b_4_REP
rename x26 sim_ret_eff_pr_adm_b_5_REP
rename x27 sim_ret_eff_pr_adm_b_6_REP
rename x28 sim_ret_eff_pr_adm_b_7_REP
rename x29 sim_ret_eff_pr_adm_b_8_REP
rename x30 sim_ret_eff_pr_adm_b_9_REP
rename x31 sim_hours_study_latent_REP
rename x32 sim_type_REP
gen high_type_REP = 1 if sim_type_REP==1
replace high_type_REP = 0 if sim_type_REP==2
rename x33 sim_utility_expected_REP
rename x34 sim_utility_actual_REP
gen welfare_gap_perc_REP=100*(sim_utility_actual_REP -sim_utility_expected_REP)/sim_utility_expected_REP
label var welfare_gap_perc_REP "Ex-post realized welfare gain, percent of ex-ante"
rename x35 sim_top15_actual_REP
label var sim_top15_actual_REP "Sim. in top 15 actual"
rename x36 sim_sel_regular_REP
rename x37 sim_sel_pace_REP
gen sim_sel_enrolled_REP = sim_sel_regular_REP if sim_enrolled_SUA_regular_REP==1
replace sim_sel_enrolled_REP = sim_sel_pace_REP if sim_enrolled_SUA_pace_REP==1
rename x38 sim_PDV_2_nosit_REP 
rename x39 sim_PDV_2_sit_REP
rename x40 sim_PDV_4_ER_REP
rename x41 sim_PDV_4_EP_REP
rename x42 sim_PDV_4_ERdropout_REP
rename x43 sim_PDV_4_EPdropout_REP
rename x44 sim_PDV_4_GradP_REP
rename x45 sim_PDV_4_GradR_REP
rename x46 sim_GPA_all_REP
label var sim_GPA_all_REP "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0_REP
rename x48 sim_PDV_1_eff1_REP
rename x49 sim_PDV_1_eff2_REP
rename x50 sim_PDV_1_eff3_REP
rename x51 sim_PDV_1_eff4_REP
rename x52 sim_PDV_1_eff5_REP
rename x53 sim_PDV_1_eff6_REP
rename x54 sim_PDV_1_eff7_REP
rename x55 sim_PDV_1_eff8_REP
rename x56 sim_PDV_1_eff9_REP
rename x57 sim_PDV_1_eff10_REP
rename x58 sim_Ut_1_eff0_REP
rename x59 sim_Ut_1_eff1_REP
rename x60 sim_Ut_1_eff2_REP
rename x61 sim_Ut_1_eff3_REP
rename x62 sim_Ut_1_eff4_REP
rename x63 sim_Ut_1_eff5_REP
rename x64 sim_Ut_1_eff6_REP
rename x65 sim_Ut_1_eff7_REP
rename x66 sim_Ut_1_eff8_REP
rename x67 sim_Ut_1_eff9_REP
rename x68 sim_Ut_1_eff10_REP
rename x69 sim_Emax_1_eff0_REP
rename x70 sim_Emax_1_eff1_REP
rename x71 sim_Emax_1_eff2_REP
rename x72 sim_Emax_1_eff3_REP
rename x73 sim_Emax_1_eff4_REP
rename x74 sim_Emax_1_eff5_REP
rename x75 sim_Emax_1_eff6_REP
rename x76 sim_Emax_1_eff7_REP
rename x77 sim_Emax_1_eff8_REP
rename x78 sim_Emax_1_eff9_REP
rename x79 sim_Emax_1_eff10_REP
rename x80 m_shock
rename x81 sim_Ut_1_REP
rename x82 sim_Ut_2_REP 
rename x83 sim_Ut_5_ante_b_REP
rename x84 sim_Ut_5_ante_RE_REP
rename x85 sim_Ut_5_post_REP

gen sim_overenrolled_REP=1 if sim_enrolled_SUA_REP==1 & sim_Ut_5_ante_RE_REP<0
replace sim_overenrolled_REP=0 if sim_overenrolled_REP==.
gen sim_underenrolled_REP=1 if sim_enrolled_SUA_REP==0 & sim_Ut_5_ante_RE_REP>0 &  sim_Ut_5_ante_RE_REP!=. 
replace sim_underenrolled_REP=0 if sim_underenrolled_REP==. 
gen sim_mismatched_REP=1 if sim_underenrolled_REP==1 | sim_overenrolled_REP==1 
replace sim_mismatched_REP=0 if sim_mismatched_REP==.
gen sim_optim_bias_ut_5_REP = sim_Ut_5_ante_b_REP  - sim_Ut_5_ante_RE_REP
save "$dataClean/countREandPACE_CC_2types.dta", replace
restore 

merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/countREandPACE_CC_2types.dta"
drop _merge 
tab high_type high_type_REP // ok
drop high_type_REP 
preserve
* Open RE-only simulations and save as .dta 
insheet using "$dataClean/counteffpersandPACE_CC_2types.csv", clear
rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score_effpP
rename x5 sim_hours_study_effpP
rename x6 sim_enrolled_SUA_regular_effpP
rename x7 sim_enrolled_SUA_pace_effpP
gen sim_enrolled_SUA_effpP = 1 if sim_enrolled_SUA_regular_effpP==1 | sim_enrolled_SUA_pace_effpP==1
replace sim_enrolled_SUA_effpP = 0 if sim_enrolled_SUA_effpP==.
rename x8 sim_persist_SUA_effpP
gen sim_enroll_dropout_effpP=1 if sim_enrolled_SUA_effpP ==1 & sim_persist_SUA_effpP ==0
replace sim_enroll_dropout_effpP=0 if sim_enroll_dropout_effpP==. 
rename x9 sim_admitted_SUA_regular_effpP
rename x10 sim_admitted_SUA_pace_effpP 
gen sim_admitted_effpP = 1 if sim_admitted_SUA_regular_effpP==1 | sim_admitted_SUA_pace_effpP==1
replace sim_admitted_effpP = 0 if sim_admitted_effpP==.
rename x11 sim_sit_PSU_effpP
rename x12 sim_PSU_latent_effpP
gen sim_PSU_observed_effpP = sim_PSU_latent_effpP if sim_sit_PSU_effpP==1
label var sim_PSU_latent_effpP "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed_effpP "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA_effpP
rename x14 sim_PSUb_effpP
rename x15 sim_prob_adm_pace_b_effpP
rename x16 sim_prob_adm_regular_b_effpP
gen sim_prob_adm_b_effpP=(1.0-treatment)*sim_prob_adm_regular_b_effpP+treatment*(sim_prob_adm_regular_b_effpP+sim_prob_adm_pace_b_effpP-sim_prob_adm_pace_b_effpP*sim_prob_adm_regular_b_effpP)
rename x17 sim_GPAb_effpP
rename x18 sim_pr_persist_effpP
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data
rename x21 sim_ret_eff_pr_adm_b_0_effpP
rename x22 sim_ret_eff_pr_adm_b_1_effpP
rename x23 sim_ret_eff_pr_adm_b_2_effpP
rename x24 sim_ret_eff_pr_adm_b_3_effpP
rename x25 sim_ret_eff_pr_adm_b_4_effpP
rename x26 sim_ret_eff_pr_adm_b_5_effpP
rename x27 sim_ret_eff_pr_adm_b_6_effpP
rename x28 sim_ret_eff_pr_adm_b_7_effpP
rename x29 sim_ret_eff_pr_adm_b_8_effpP
rename x30 sim_ret_eff_pr_adm_b_9_effpP
rename x31 sim_hours_study_latent_effpP
rename x32 sim_type_effpP
gen high_type_effpP = 1 if sim_type_effpP==1
replace high_type_effpP = 0 if sim_type_effpP==2
rename x33 sim_utility_expected_effpP
rename x34 sim_utility_actual_effpP
gen welfare_gap_perc_effpP=100*(sim_utility_actual_effpP -sim_utility_expected_effpP)/sim_utility_expected_effpP
label var welfare_gap_perc_effpP "Ex-post realized welfare gain, percent of ex-ante"
rename x35 sim_top15_actual_effpP
label var sim_top15_actual_effpP "Sim. in top 15 actual"
rename x36 sim_sel_regular_effpP
rename x37 sim_sel_pace_effpP
gen sim_sel_enrolled_effpP = sim_sel_regular_effpP if sim_enrolled_SUA_regular_effpP==1
replace sim_sel_enrolled_effpP = sim_sel_pace_effpP if sim_enrolled_SUA_pace_effpP==1
rename x38 sim_PDV_2_nosit_effpP 
rename x39 sim_PDV_2_sit_effpP
rename x40 sim_PDV_4_ER_effpP
rename x41 sim_PDV_4_EP_effpP
rename x42 sim_PDV_4_ERdropout_effpP
rename x43 sim_PDV_4_EPdropout_effpP
rename x44 sim_PDV_4_GradP_effpP
rename x45 sim_PDV_4_GradR_effpP
rename x46 sim_GPA_all_effpP
label var sim_GPA_all_effpP "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0_effpP
rename x48 sim_PDV_1_eff1_effpP
rename x49 sim_PDV_1_eff2_effpP
rename x50 sim_PDV_1_eff3_effpP
rename x51 sim_PDV_1_eff4_effpP
rename x52 sim_PDV_1_eff5_effpP
rename x53 sim_PDV_1_eff6_effpP
rename x54 sim_PDV_1_eff7_effpP
rename x55 sim_PDV_1_eff8_effpP
rename x56 sim_PDV_1_eff9_effpP
rename x57 sim_PDV_1_eff10_effpP
rename x58 sim_Ut_1_eff0_effpP
rename x59 sim_Ut_1_eff1_effpP
rename x60 sim_Ut_1_eff2_effpP
rename x61 sim_Ut_1_eff3_effpP
rename x62 sim_Ut_1_eff4_effpP
rename x63 sim_Ut_1_eff5_effpP
rename x64 sim_Ut_1_eff6_effpP
rename x65 sim_Ut_1_eff7_effpP
rename x66 sim_Ut_1_eff8_effpP
rename x67 sim_Ut_1_eff9_effpP
rename x68 sim_Ut_1_eff10_effpP
rename x69 sim_Emax_1_eff0_effpP
rename x70 sim_Emax_1_eff1_effpP
rename x71 sim_Emax_1_eff2_effpP
rename x72 sim_Emax_1_eff3_effpP
rename x73 sim_Emax_1_eff4_effpP
rename x74 sim_Emax_1_eff5_effpP
rename x75 sim_Emax_1_eff6_effpP
rename x76 sim_Emax_1_eff7_effpP
rename x77 sim_Emax_1_eff8_effpP
rename x78 sim_Emax_1_eff9_effpP
rename x79 sim_Emax_1_eff10_effpP
rename x80 m_shock
rename x81 sim_Ut_1_effpP
rename x82 sim_Ut_2_effpP
rename x83 sim_Ut_5_ante_b_effpP
rename x84 sim_Ut_5_ante_RE_effpP
rename x85 sim_Ut_5_post_effpP

gen sim_overenrolled_effpP=1 if sim_enrolled_SUA_effpP==1 & sim_Ut_5_ante_RE_effpP<0
replace sim_overenrolled_effpP=0 if sim_overenrolled_effpP==.
gen sim_underenrolled_effpP=1 if sim_enrolled_SUA_effpP==0 & sim_Ut_5_ante_RE_effpP>0 &  sim_Ut_5_ante_RE_effpP!=. 
replace sim_underenrolled_effpP=0 if sim_underenrolled_effpP==. 
gen sim_mismatched_effpP=1 if sim_underenrolled_effpP==1 | sim_overenrolled_effpP==1 
replace sim_mismatched_effpP=0 if sim_mismatched_effpP==.
save "$dataClean/counteffpersandPACE_CC_2types.dta", replace
restore

merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/counteffpersandPACE_CC_2types.dta"
drop _merge 
tab high_type high_type_effpP // ok
drop high_type_effpP
gen sim_optim_bias_ut_5_effpP = sim_Ut_5_ante_b_effpP  - sim_Ut_5_ante_RE_effpP

* Get percentiles
summarize simce_avg_st, detail
global simce_p1 = r(p1)
global simce_p99 = r(p99)

forval y=0/9 {
	
		egen hugo = mean(sim_ret_eff_pr_adm_b_`y') if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen sim_ret_eff_pr_adm_b_`y'_count1_0=max(hugo)
				drop hugo
				
				egen hugo = mean(sim_ret_eff_pr_adm_b_`y'_REP) if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen sim_ret_eff_pr_adm_b_`y'_count1_1=max(hugo)
				drop hugo 
				
				gen sim_ret_eff_pr_adm_b_`y'_count1 =  sim_ret_eff_pr_adm_b_`y'_count1_0 if treatment==0 
				replace sim_ret_eff_pr_adm_b_`y'_count1 = sim_ret_eff_pr_adm_b_`y'_count1_1 if treatment==1
				drop sim_ret_eff_pr_adm_b_`y'_count1_1 sim_ret_eff_pr_adm_b_`y'_count1_0
}

* Counterfactual 2 = give full RE AND PACE
gen sim_admitted_count2 = sim_admitted if treatment==0
replace sim_admitted_count2 = sim_admitted_REP if treatment==1 

gen sim_enrolled_SUA_count2 = sim_enrolled_SUA if treatment==0 
replace sim_enrolled_SUA_count2 = sim_enrolled_SUA_REP if treatment==1 

gen sim_persist_SUA_count2 = sim_persist_SUA if treatment==0
replace sim_persist_SUA_count2 = sim_persist_SUA_REP if treatment==1 

gen sim_hours_study_latent_count2 = sim_hours_study_latent if treatment==0
replace sim_hours_study_latent_count2 = sim_hours_study_latent_REP if treatment==1

gen sim_hours_study_count2 = sim_hours_study if treatment==0
replace sim_hours_study_count2 = sim_hours_study_REP if treatment==1

gen sim_GPA_count2 = sim_GPA if treatment==0
replace sim_GPA_count2 = sim_GPA_REP if treatment==1 

gen sim_sit_PSU_count2 = sim_sit_PSU if treatment==0
replace sim_sit_PSU_count2 = sim_sit_PSU_REP if treatment==1


forval y=0/9 {
gen sim_ret_eff_pr_adm_b_`y'_count2 = sim_ret_eff_pr_adm_b_`y' if treatment==0
replace sim_ret_eff_pr_adm_b_`y'_count2 = sim_ret_eff_pr_adm_b_`y'_REP if treatment==1	
}

gen sim_optim_bias_ut_5_count2 = sim_optim_bias_ut_5 if treatment==0
replace sim_optim_bias_ut_5_count2 = sim_optim_bias_ut_5_REP if treatment==1

gen welfare_gap_perc_count2 = welfare_gap_perc if treatment==0
replace welfare_gap_perc_count2 = welfare_gap_perc_REP if treatment==1

gen sim_utility_actual_count2 = sim_utility_actual if treatment==0
replace sim_utility_actual_count2 = sim_utility_actual_REP if treatment==1

gen sim_utility_expected_count2 = sim_utility_expected if treatment==0
replace sim_utility_expected_count2 = sim_utility_expected_REP if treatment==1

gen sim_enroll_dropout_count2 = sim_enroll_dropout if treatment==0
replace sim_enroll_dropout_count2 = sim_enroll_dropout_REP if treatment==1

gen sim_Ut_5_post_count2 = sim_Ut_5_post if treatment==0 
replace sim_Ut_5_post_count2 = sim_Ut_5_post_REP if treatment==1 

gen sim_Ut_2_count2 = sim_Ut_2 if treatment==0 
replace sim_Ut_2_count2 = sim_Ut_2_REP if treatment==1 

gen sim_Ut_5_ante_b_count2 = sim_Ut_5_ante_b  if treatment==0 
replace sim_Ut_5_ante_b_count2 = sim_Ut_5_ante_b_REP if treatment==1 

gen sim_Ut_1_count2 = sim_Ut_1 if treatment==0 
replace sim_Ut_1_count2 = sim_Ut_1_REP if treatment==1 

gen sim_overenrolled_count2 = sim_overenrolled if treatment==0
replace sim_overenrolled_count2 =  sim_overenrolled_REP if treatment==1

gen sim_underenrolled_count2 = sim_underenrolled if treatment==0
replace sim_underenrolled_count2 = sim_underenrolled_REP if treatment==1 

gen sim_mismatched_count2 = sim_mismatched if treatment==0
replace sim_mismatched_count2 = sim_mismatched_REP if treatment==1

gen sim_persist_if_enr_REP = sim_persist_SUA_REP if sim_enrolled_SUA_REP==1
gen sim_persist_if_enr_count2 = sim_persist_SUA if sim_enrolled_SUA==1 & treatment==0 
replace sim_persist_if_enr_count2 = sim_persist_SUA_REP if sim_enrolled_SUA_REP==1 & treatment==1

* Counterfactual 5 = give info on returns to effort in persistence, without correcting beliefs, AND PACE 

gen sim_admitted_count5 = sim_admitted if treatment==0
replace sim_admitted_count5 = sim_admitted_effpP if treatment==1 

gen sim_enrolled_SUA_count5 = sim_enrolled_SUA if treatment==0 
replace sim_enrolled_SUA_count5 = sim_enrolled_SUA_effpP if treatment==1 

gen sim_persist_SUA_count5 = sim_persist_SUA if treatment==0
replace sim_persist_SUA_count5 = sim_persist_SUA_effpP if treatment==1 

gen sim_hours_study_latent_count5 = sim_hours_study_latent if treatment==0
replace sim_hours_study_latent_count5 = sim_hours_study_latent_effpP if treatment==1

gen sim_hours_study_count5 = sim_hours_study if treatment==0
replace sim_hours_study_count5 = sim_hours_study_effpP if treatment==1

gen sim_GPA_count5 = sim_GPA if treatment==0
replace sim_GPA_count5 = sim_GPA_effpP if treatment==1 

gen sim_sit_PSU_count5 = sim_sit_PSU if treatment==0
replace sim_sit_PSU_count5 = sim_sit_PSU_effpP if treatment==1

forval y=0/9 {
gen sim_ret_eff_pr_adm_b_`y'_count5 = sim_ret_eff_pr_adm_b_`y' if treatment==0
replace sim_ret_eff_pr_adm_b_`y'_count5 = sim_ret_eff_pr_adm_b_`y'_effpP if treatment==1	
}

gen sim_optim_bias_ut_5_count5 = sim_optim_bias_ut_5 if treatment==0
replace sim_optim_bias_ut_5_count5 = sim_optim_bias_ut_5_effpP if treatment==1

gen welfare_gap_perc_count5 = welfare_gap_perc if treatment==0
replace welfare_gap_perc_count5 = welfare_gap_perc_effpP if treatment==1

gen sim_utility_actual_count5 = sim_utility_actual if treatment==0
replace sim_utility_actual_count5 = sim_utility_actual_effpP if treatment==1

gen sim_utility_expected_count5 = sim_utility_expected if treatment==0
replace sim_utility_expected_count5 = sim_utility_expected_effpP if treatment==1

gen sim_enroll_dropout_count5 = sim_enroll_dropout if treatment==0
replace sim_enroll_dropout_count5 = sim_enroll_dropout_effpP if treatment==1

gen sim_Ut_5_post_count5 = sim_Ut_5_post if treatment==0 
replace sim_Ut_5_post_count5 = sim_Ut_5_post_effpP if treatment==1 

gen sim_Ut_2_count5 = sim_Ut_2 if treatment==0 
replace sim_Ut_2_count5 = sim_Ut_2_effpP if treatment==1 

gen sim_Ut_5_ante_b_count5 = sim_Ut_5_ante_b  if treatment==0 
replace sim_Ut_5_ante_b_count5 = sim_Ut_5_ante_b_effpP if treatment==1 

gen sim_Ut_1_count5 = sim_Ut_1 if treatment==0 
replace sim_Ut_1_count5 = sim_Ut_1_effpP if treatment==1 

gen sim_overenrolled_count5 = sim_overenrolled if treatment==0
replace sim_overenrolled_count5 =  sim_overenrolled_effpP if treatment==1

gen sim_underenrolled_count5 = sim_underenrolled if treatment==0
replace sim_underenrolled_count5 = sim_underenrolled_effpP if treatment==1 

gen sim_mismatched_count5 = sim_mismatched if treatment==0
replace sim_mismatched_count5 = sim_mismatched_effpP if treatment==1  


gen sim_persist_if_enr_effpP = sim_persist_SUA_effpP if sim_enrolled_SUA_effpP==1
gen sim_persist_if_enr_count5 = sim_persist_SUA if sim_enrolled_SUA==1 & treatment==0 
replace sim_persist_if_enr_count5 = sim_persist_SUA_effpP if sim_enrolled_SUA_effpP==1 & treatment==1

gen sim_persist_if_enr = sim_persist_SUA if sim_enrolled_SUA==1
sort mrun m_shock 
local bases sim_admitted sim_enrolled_SUA sim_persist_SUA sim_enroll_dropout ///
             sim_hours_study_latent sim_hours_study ///
             sim_GPA sim_sit_PSU welfare_gap_perc sim_utility_actual sim_utility_expected ///
			 sim_Ut_2 sim_Ut_5_post  sim_Ut_1 sim_Ut_5_ante_b  ///
			 sim_overenrolled sim_mismatched sim_underenrolled  sim_optim_bias_ut_5 sim_persist_if_enr

			 foreach y of local bases {
			 	
				egen hugo = mean(`y') if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen `y'_0=max(hugo)
				drop hugo
				
				egen hugo = mean(`y'_REP) if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen `y'_1=max(hugo)
				drop hugo 
				gen `y'_count1_TE=`y'_1 - `y'_0
				drop `y'_1 `y'_0
			 }
			 
* Sort by your grouping identifiers
sort mrun m_shock

* define the base variable stems (everything before "_count")
local bases sim_admitted sim_enrolled_SUA sim_persist_SUA sim_enroll_dropout ///
             sim_hours_study_latent sim_hours_study ///
             sim_GPA sim_sit_PSU welfare_gap_perc sim_utility_actual sim_utility_expected ///
			 sim_Ut_2 sim_Ut_5_post  sim_Ut_1 sim_Ut_5_ante_b ///
			 sim_overenrolled sim_mismatched sim_underenrolled sim_optim_bias_ut_5 sim_persist_if_enr

* loop over suffixes 1–5
foreach c in  2  5 {
    * loop over each base name
    foreach b of local bases {
        * construct the full varname
        local y = "`b'_count`c'"

        * compute treated and control values, difference them
		egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_1=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_0=max(hugo)
	  drop hugo
       * egen `y'_0 = mean(`y') if treatment==0, by(mrun m_shock)
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
    }
}

local bases sim_admitted sim_enrolled_SUA sim_persist_SUA sim_enroll_dropout  ///
             sim_hours_study_latent sim_hours_study ///
             sim_GPA sim_sit_PSU welfare_gap_perc sim_utility_actual sim_utility_expected ///
			 sim_Ut_2 sim_Ut_5_post  sim_Ut_1 sim_Ut_5_ante_b ///
			 sim_overenrolled sim_mismatched sim_underenrolled sim_optim_bias_ut_5 sim_persist_if_enr
foreach y of local bases {
			egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_1=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_0=max(hugo)
	  drop hugo
       * egen `y'_0 = mean(`y') if treatment==0, by(mrun m_shock)
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
}


est clear 
local outcomes ///
    hours_study ///
    sit_PSU      ///
    admitted     ///
    enrolled_SUA ///
    persist_SUA  ///
	enroll_dropout  

cap matrix M
local i = 1

foreach out of local outcomes {
    * baseline TE
    quietly summarize sim_`out'_TE
    local m0 = round(r(mean),0.001)
	   * counterfactual 1: RE only
    quietly summarize sim_`out'_count1_TE
	local m1 = round(r(mean),0.001)
    * counterfactual 2: PACE + RE
    quietly summarize sim_`out'_count2_TE
    local m2 = round(r(mean),0.001)
    * counterfactual 5: PACE + info on value
    quietly summarize sim_`out'_count5_TE
    local m5 = round(r(mean),0.001)

    * build or append row i
    if `i' == 1 {
        matrix M = ( `m0', `m1', `m2',  `m5' )
    }
    else {
        matrix M = M \ ( `m0', `m1', `m2', `m5' )
    }
    local ++i
}

matrix rownames M = ///
    "Study hours/week" ///
    "Took entrance exam" ///
    "Admitted" ///
    "Enrolled" ///
    "Enrolled and persisted" ///
	"Enrolled and dropped out" 

matrix colnames M = ///
    "PACE" ///
	"Rational expectations" ///
    "PACE+Rational expectations" ///
    "PACE+Correct effort returns"
  
esttab matrix(M) using "$tables/simulated_ATEs.tex", replace ///
    fragment booktabs ///
    nomtitles nonumbers nogap ///
    prehead(  `"   \begin{table}[ht]\centering \scriptsize  "'   ///
 `"\begin{threeparttable}"' ///
            `"\caption{\textsc{Simulated effects of baseline and counterfactual interventions\label{tab:ATEinfocount}}}"' ///
            `"\begin{tabular}{l*{4}{c}}"' ///
			`"\hline"' ///
			 `" & (1) & (2) & (3) & (4)  \\"')  ///
			 postfoot(`"\hline"'  `"\vspace{-10pt}"' `"\end{tabular}"'  `"\begin{tablenotes}\singlespacing"' ///
         `"\item	\scriptsize \textsc{ Note. --} This table shows average effects of various hypothetical interventions. For each individual in the control group in the data, we simulate a control condition in which no intervention is introduced, and various conditions in which the intervention indicated in the column heading is introduced. We calculate the intervention effect for each individual, and report here the sample average. Column 1 introduces PACE alone. Column 2 introduces rational expectations in the absence of PACE. Column 3 combines PACE with rational expectations. Column 4 combines PACE with information about the correct marginal effect of effort on the probability of persisting in college."' ///
         `"\end{tablenotes}"'  `"\end{threeparttable}"' `"\end{table}"')
					 



********************************************************************************
**# Table A22: Parameter Estimates
********************************************************************************
* Estimated in Julia


********************************************************************************
**# Table A23: Average utilities from college participation
********************************************************************************
insheet using "$dataClean/baseline_TC_2types_rescale.csv", clear
rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
rename x11 sim_sit_PSU
rename x12 sim_PSU_latent
gen sim_PSU_observed=sim_PSU_latent if sim_sit_PSU==1
label var sim_PSU_latent "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA
rename x14 sim_PSUb
rename x15 sim_prob_adm_pace_b
rename x16 sim_prob_adm_regular_b
rename x17 sim_GPAb
rename x18 sim_pr_persist
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data
rename x21 sim_ret_eff_pr_adm_b_0
rename x22 sim_ret_eff_pr_adm_b_1
rename x23 sim_ret_eff_pr_adm_b_2
rename x24 sim_ret_eff_pr_adm_b_3
rename x25 sim_ret_eff_pr_adm_b_4
rename x26 sim_ret_eff_pr_adm_b_5
rename x27 sim_ret_eff_pr_adm_b_6
rename x28 sim_ret_eff_pr_adm_b_7
rename x29 sim_ret_eff_pr_adm_b_8
rename x30 sim_ret_eff_pr_adm_b_9
rename x31 sim_hours_study_latent

forvalues h = 0/9 {
	replace sim_ret_eff_pr_adm_b_`h'=. if sim_ret_eff_pr_adm_b_`h' ==-99
}

* Actual returns to effort according to simulated hours of study 
gen sim_ret_eff_pr_adm_b_actual = .

forvalues h = 0/9 {
    replace sim_ret_eff_pr_adm_b_actual = sim_ret_eff_pr_adm_b_`h' if sim_hours_study_latent == `h'
}

rename x32 sim_type
gen high_type=1 if sim_type==1
replace high_type=0 if sim_type==2
rename x33 sim_utility_expected // ex-post utility based on perceptions, before dropouts occur
rename x34 sim_utility_actual   // ex-post utility based on actual dropouts
rename x35 sim_top15_actual
label var sim_top15_actual  "Sim. in top 15 actual"
rename x36 sim_sel_regular
rename x37 sim_sel_pace
gen sim_sel_enrolled=sim_sel_regular if sim_enrolled_SUA_regular==1
replace sim_sel_enrolled=sim_sel_pace if sim_enrolled_SUA_pace==1
rename x38 sim_PDV_2_nosit 
rename x39 sim_PDV_2_sit
rename x40 sim_PDV_4_ER // we have this value even for those without admissions
rename x41 sim_PDV_4_EP // we have this value even for those without admissions
rename x42 sim_PDV_4_ERdropout // we have this value even for those without admissions
rename x43 sim_PDV_4_EPdropout // we have this value even for those without admissions
rename x44 sim_PDV_4_GradP // we have this value even for those without admissions
rename x45 sim_PDV_4_GradR // we have this value even for those without admissions
rename x46 sim_GPA_all
label var sim_GPA_all "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0
rename x48 sim_PDV_1_eff1
rename x49 sim_PDV_1_eff2
rename x50 sim_PDV_1_eff3
rename x51 sim_PDV_1_eff4
rename x52 sim_PDV_1_eff5
rename x53 sim_PDV_1_eff6
rename x54 sim_PDV_1_eff7
rename x55 sim_PDV_1_eff8
rename x56 sim_PDV_1_eff9
rename x57 sim_PDV_1_eff10
rename x58 sim_Ut_1_eff0
rename x59 sim_Ut_1_eff1
rename x60 sim_Ut_1_eff2
rename x61 sim_Ut_1_eff3
rename x62 sim_Ut_1_eff4
rename x63 sim_Ut_1_eff5
rename x64 sim_Ut_1_eff6
rename x65 sim_Ut_1_eff7
rename x66 sim_Ut_1_eff8
rename x67 sim_Ut_1_eff9
rename x68 sim_Ut_1_eff10
rename x69 sim_Emax_1_eff0
rename x70 sim_Emax_1_eff1
rename x71 sim_Emax_1_eff2
rename x72 sim_Emax_1_eff3
rename x73 sim_Emax_1_eff4
rename x74 sim_Emax_1_eff5
rename x75 sim_Emax_1_eff6
rename x76 sim_Emax_1_eff7
rename x77 sim_Emax_1_eff8
rename x78 sim_Emax_1_eff9
rename x79 sim_Emax_1_eff10
rename x80 m_shock 
rename x81 sim_ut_enroll_dropout_R
rename x82 sim_ut_enroll_dropout_P
rename x83 sim_ut_enroll_grad_R
rename x84 sim_ut_enroll_grad_P

merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110

sum sim_PDV_1_eff* 
sum sim_Ut_1_eff*
sum sim_Emax_1_eff*


* Generate simulated variables used in the analysis
* Used in description of beliefs: 
gen sim_PSU_bias=sim_PSUb-sim_PSU_observed 
label var sim_PSU_bias "Simulated believed minus actual entrance exam score \$|\$ sim. took exam (\$\sigma\$)"
gen sim_bias_own_NEM=sim_GPAb-sim_GPA 
label var sim_bias_own_NEM "Simulated believed minus actual \$12^{th}\$ grade GPA (GPA points)"
gen sim_p_admitted_above_050=1 if sim_prob_adm_regular_b>=0.5 & sim_prob_adm_regular_b!=.
replace sim_p_admitted_above_050=0 if sim_prob_adm_regular_b<0
label var sim_p_admitted_above_050 "Simulated subj prob regular admission \$\geq 0.50\$"
label var sim_prob_adm_regular_b "Simulated subjective probability of a regular admission"
label var sim_GPAb "Believed GPA"
*Top 15 cutoff used in model
gen perceived_top15_cutoff=NEM_top15_April
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
gen sim_minus_bias_top15=sim_top15_actual-perceived_top15_cutoff
label var  sim_minus_bias_top15 "Simuulated actual minus believed top \$15\%\$ cutoff in school (GPA points)"
gen sim_think_top15=1 if sim_GPAb>=perceived_top15_cutoff & sim_GPAb!=.
replace sim_think_top15=0 if sim_GPAb<perceived_top15_cutoff
label var sim_think_top15 "Simulated to believe is in top \$15\%\$ of school"

gen sim_perceived_above_cutoff=sim_GPAb-perceived_top15_cutoff
label var sim_perceived_above_cutoff "Sim. expected GPA minus expected cutoff"

gen perceived_above_cutoff=exp_NEM-perceived_top15_cutoff
label var perceived_above_cutoff "Expected GPA minus expected cutoff"

* Following variables used only to guide calibration 
gen y_data_missing=1 if score_all_st==.
replace y_data_missing=0 if score_all_st!=.

gen top15_actual=top15endline 
label var top15_actual "Top 15% based on all years GPA"

gen GPA_all = 0.5*GPA_avg_1_2 + 0.25 * GPA_tercero_medio +0.2*GPA_cuarto_medio 
label var GPA_all "GPA all 4 years"

est clear 

label var sim_ut_enroll_dropout_P "Utility from enrolling via PACE and dropping out"
label var sim_ut_enroll_dropout_R "Utility from enrolling via the regular channel and dropping out"
label var sim_ut_enroll_grad_P "Utility from enrolling via PACE and graduating"
label var sim_ut_enroll_grad_R "Utility from enrolling via the regular channel and graduating"

summarize simce_avg_st, detail
generate above_median_simce = (simce_avg_st > r(p50))

local sim_variables sim_ut_enroll_grad_R sim_ut_enroll_grad_P  sim_ut_enroll_dropout_R sim_ut_enroll_dropout_P  

cap matrix P

* Loop over each variable and add its statstics to matrix P
local k=1
foreach sim_var in `sim_variables' {

    quietly summarize `sim_var' , detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    if `k'==1 {
        matrix P = (`mean', `sd')
    }
    else {
        matrix P = P \ (`mean', `sd')
    }
	
	
	
    local k=`k'+1
}

* Label the rows and columns of the matrix P
matrix rownames P = `sim_variables'
matrix colnames P = Mean SD 

matrix final_P = P

* Display the table  
esttab matrix(final_P) using "$tables/utilities_enrolling_dropping_out.tex", nogap label replace fragment nomtitles nolines collabels(none) nonumbers nolines  ///
prehead(`"\begin{table}[H]\centering"' ///
        `"\scriptsize"' `"\begin{threeparttable}"' ///
        `"\caption{\label{tab:collegeutilities} \textsc{Average utilities from college participation }}"' ///
        `"\begin{tabular}{l*{1}{cc}}"' `"\hline"' ///
		 `"    &        \multicolumn{2}{c}{Simulations} \\ "' ///
        `"           & Mean & St.dev.  \\ "' ///
        `"   & (1) & (2)   \\ "' ///
        `"\multicolumn{3}{l}{\textsc{A. All Students}}\\"' `"\cline{1-1}"' )  ///
postfoot(`"\hline"' `"\end{tabular}"' `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
         `"\item	\scriptsize \textsc{ Note. --} Using the estimated parameters, we simulate utilities for each student, and report sample averages. The utility from enrolling and graduating from college is $\lambda_{0k_{i}}+\lambda^G_0+q_i^R+\nu_i^R$ via the regular channel and $\lambda_{0k_{i}}+\delta+\lambda^G_0+q_i^P+\nu_i^P$ via the PACE channel,  the utility from enrolling and dropping out of college is $\lambda_{0k_{i}}+\delta+\nu_i^P$ via the PACE channel and $\lambda_{0k_{i}}+\nu_i^R$ via the regular channel. The utility from the outside option (no college experience) is normalized to zero.    "' ///
         `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"')		


********************************************************************************
**# Table A24-A25: Model Fit - Description of Choices and Outcomes. Fit of auxiliary models for TE on admissions, enrollments, persistence.
********************************************************************************
insheet using "$dataClean/baseline_TC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
rename x11 sim_sit_PSU
rename x12 sim_PSU_latent
gen sim_PSU_observed=sim_PSU_latent if sim_sit_PSU==1
label var sim_PSU_latent "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA
rename x14 sim_PSUb
rename x15 sim_prob_adm_pace_b
rename x16 sim_prob_adm_regular_b
rename x17 sim_GPAb
rename x18 sim_pr_persist
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data
rename x21 sim_ret_eff_pr_adm_b_0
rename x22 sim_ret_eff_pr_adm_b_1
rename x23 sim_ret_eff_pr_adm_b_2
rename x24 sim_ret_eff_pr_adm_b_3
rename x25 sim_ret_eff_pr_adm_b_4
rename x26 sim_ret_eff_pr_adm_b_5
rename x27 sim_ret_eff_pr_adm_b_6
rename x28 sim_ret_eff_pr_adm_b_7
rename x29 sim_ret_eff_pr_adm_b_8
rename x30 sim_ret_eff_pr_adm_b_9
rename x31 sim_hours_study_latent
rename x32 sim_type
gen high_type=1 if sim_type==1
replace high_type=0 if sim_type==2
rename x33 sim_utility_expected // ex-post utility based on perceptions, before dropouts occur
rename x34 sim_utility_actual   // ex-post utility based on actual dropouts
rename x35 sim_top15_actual
label var sim_top15_actual  "Sim. in top 15 actual"
rename x36 sim_sel_regular
rename x37 sim_sel_pace
gen sim_sel_enrolled=sim_sel_regular if sim_enrolled_SUA_regular==1
replace sim_sel_enrolled=sim_sel_pace if sim_enrolled_SUA_pace==1
rename x38 sim_PDV_2_nosit 
rename x39 sim_PDV_2_sit
rename x40 sim_PDV_4_ER // we have this value even for those without admissions
rename x41 sim_PDV_4_EP // we have this value even for those without admissions
rename x42 sim_PDV_4_ERdropout // we have this value even for those without admissions
rename x43 sim_PDV_4_EPdropout // we have this value even for those without admissions
rename x44 sim_PDV_4_GradP // we have this value even for those without admissions
rename x45 sim_PDV_4_GradR // we have this value even for those without admissions
rename x46 sim_GPA_all
label var sim_GPA_all "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0
rename x48 sim_PDV_1_eff1
rename x49 sim_PDV_1_eff2
rename x50 sim_PDV_1_eff3
rename x51 sim_PDV_1_eff4
rename x52 sim_PDV_1_eff5
rename x53 sim_PDV_1_eff6
rename x54 sim_PDV_1_eff7
rename x55 sim_PDV_1_eff8
rename x56 sim_PDV_1_eff9
rename x57 sim_PDV_1_eff10
rename x58 sim_Ut_1_eff0
rename x59 sim_Ut_1_eff1
rename x60 sim_Ut_1_eff2
rename x61 sim_Ut_1_eff3
rename x62 sim_Ut_1_eff4
rename x63 sim_Ut_1_eff5
rename x64 sim_Ut_1_eff6
rename x65 sim_Ut_1_eff7
rename x66 sim_Ut_1_eff8
rename x67 sim_Ut_1_eff9
rename x68 sim_Ut_1_eff10
rename x69 sim_Emax_1_eff0
rename x70 sim_Emax_1_eff1
rename x71 sim_Emax_1_eff2
rename x72 sim_Emax_1_eff3
rename x73 sim_Emax_1_eff4
rename x74 sim_Emax_1_eff5
rename x75 sim_Emax_1_eff6
rename x76 sim_Emax_1_eff7
rename x77 sim_Emax_1_eff8
rename x78 sim_Emax_1_eff9
rename x79 sim_Emax_1_eff10
rename x80 m_shock 

merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110

sum sim_PDV_1_eff* 
sum sim_Ut_1_eff*
sum sim_Emax_1_eff*


* Generate simulated variables used in the analysis
gen sim_PSU_bias=sim_PSUb-sim_PSU_observed 
label var sim_PSU_bias "Simulated believed minus actual entrance exam score \$|\$ sim. took exam (\$\sigma\$)"
gen sim_bias_own_NEM=sim_GPAb-sim_GPA 
label var sim_bias_own_NEM "Simulated believed minus actual \$12^{th}\$ grade GPA (GPA points)"
gen sim_p_admitted_above_050=1 if sim_prob_adm_regular_b>=0.5 & sim_prob_adm_regular_b!=.
replace sim_p_admitted_above_050=0 if sim_prob_adm_regular_b<0
label var sim_p_admitted_above_050 "Simulated subj prob regular admission \$\geq 0.50\$"
label var sim_prob_adm_regular_b "Simulated subjective probability of a regular admission"
label var sim_GPAb "Believed GPA"
gen perceived_top15_cutoff=NEM_top15_April // Top 15 cutoff used in model
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
gen sim_minus_bias_top15=sim_top15_actual-perceived_top15_cutoff
label var  sim_minus_bias_top15 "Simuulated actual minus believed top \$15\%\$ cutoff in school (GPA points)"
gen sim_think_top15=1 if sim_GPAb>=perceived_top15_cutoff & sim_GPAb!=.
replace sim_think_top15=0 if sim_GPAb<perceived_top15_cutoff
label var sim_think_top15 "Simulated to believe is in top \$15\%\$ of school"
gen sim_perceived_above_cutoff=sim_GPAb-perceived_top15_cutoff
label var sim_perceived_above_cutoff "Sim. expected GPA minus expected cutoff"
gen perceived_above_cutoff=exp_NEM-perceived_top15_cutoff
label var perceived_above_cutoff "Expected GPA minus expected cutoff"
gen y_data_missing=1 if score_all_st==.
replace y_data_missing=0 if score_all_st!=.
gen top15_actual=top15endline 
label var top15_actual "Top 15% based on all years GPA"
gen GPA_all = 0.5*GPA_avg_1_2 + 0.25 * GPA_tercero_medio +0.2*GPA_cuarto_medio 
label var GPA_all "GPA all 4 years"

est clear

label var score_all_st "Test score"
label var hours_study "Study hours/week"
label var GPA_cuarto_medio "GPA grade 12"
lab var sit_PSU "Took college entrance exam"
lab var admitted_SUA_regular_or_pace "Admitted to selective college"
label var admitted_SUA_pace "Admitted to selective college via PACE"
lab var enrolled_SUA_by_y1 "Enrolled in selective college"
gen sel_uni_major_st=( mean_PSU_score_uni_major-500)/110
lab var sel_uni_major_st "Selectivity of program (college-major pair)"
lab var enrolled_SUA_by_y5  "Enrolled and persisted in selective college, year 5"
label var GPA_all "GPA grades 9-12"
label var top15_actual "In top 15, GPA grades 9-12"
label var sim_score "Sim. Test score"
label var sim_hours_study "Sim. hours study"
label var sim_GPA "Sim. GPA grade 12"
lab var sim_sit_PSU "Took college entrance exam - simulation"
lab var sim_admitted "Admitted to selective college - simulation"
label var sim_admitted_SUA_pace "Admitted to selective college via PACE - simulation"
lab var sim_enrolled_SUA "Enrolled in selective college - simulation"
lab var sim_sel_enrolled "Selectivity of program (college-major pair) - simulation"
lab var sim_persist_SUA  "Enrolled and persisted in selective college, year 5 - simulation"
label var sim_GPA_all "Sim. GPA grades 9-12"
label var sim_top15_actual "Sim. in top 15, GPA grades 9-12"
* List your variables and corresponding simulated variables
local variables   hours_study GPA_cuarto_medio GPA_all top15_actual sit_PSU admitted_SUA_regular_or_pace enrolled_SUA_by_y1 sel_uni_major_st enrolled_SUA_by_y5 
local sim_variables  sim_hours_study sim_GPA sim_GPA_all sim_top15_actual  sim_sit_PSU sim_admitted sim_enrolled_SUA sim_sel_enrolled sim_persist_SUA  

cap matrix A
cap matrix C

* Loop over each real variable and add its statistics to matrix A
local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==0, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    if `k'==1 {
        matrix A = (`mean', `sd')
    }
    else {
        matrix A = A \ (`mean', `sd')
    }
    local k=`k'+1
}

* Loop over each simulated variable and add its statistics to matrix C
local k=1
foreach sim_var in `sim_variables' {
	
	if "`sim_var'"=="sim_hours_study" {
    quietly summarize `sim_var' if treatment==0 & hours_study!=., detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    local N: display %9.0g r(N)
    if `k'==1 {
        matrix C = (`mean', `sd')
    }
    else {
        matrix C = C \ (`mean', `sd')
    }				
	}
	
	else if "`sim_var'"=="sim_GPA" {
    quietly summarize `sim_var' if treatment==0 & GPA_cuarto_medio!=., detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    local N: display %9.0g r(N)
    if `k'==1 {
        matrix C = (`mean', `sd')
    }
    else {
        matrix C = C \ (`mean', `sd')
    }				
	}
	
	else {
	    quietly summarize `sim_var' if treatment==0, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    local N: display %9.0g r(N)
    if `k'==1 {
        matrix C = (`mean', `sd')
    }
    else {
        matrix C = C \ (`mean', `sd')
    }
	}
	
    local k=`k'+1
	
}

* Label the rows and columns of the matrices A and C
matrix rownames A = `variables'
matrix colnames A = Mean SD 
matrix rownames C = `sim_variables'
matrix colnames C = Mean SD 

* Combine matrices A and C to show columns (1)-(2) for real data and columns (4)-(5) for simulated data
matrix final = A , C

* Display the table
esttab matrix(final) using "$tables/summary_stats_outcomes_model_fit.tex", nogap label replace fragment nomtitles nolines collabels(none) nonumbers nolines ///
prehead(`"\begin{table}[h]\centering"' ///
        `"\scriptsize"' `"\begin{threeparttable}"' ///
        `"\caption{\label{tab:descriptionoutcomes} \textsc{Model Fit - Description of Choices and Outcomes }}"' ///
        `"\begin{tabular}{l*{1}{cc|cc}}"' `"\hline"' ///
		 `"    &        \multicolumn{2}{c}{Data} &  \multicolumn{2}{c}{Simulations} \\ "' ///
        `"    &        Mean &   St.dev. & Mean & St.dev. \\ "' ///
        `"   & (1) & (2) & (3) & (4)  \\ "' ///
        `"\multicolumn{5}{l}{\textsc{A. Control}}\\"' `"\cline{1-1}"' )

est clear
label var score_all_st "Test score"
label var hours_study "Study hours/week"
label var GPA_cuarto_medio "GPA grade 12"
lab var sit_PSU "Took college entrance exam"
lab var admitted_SUA_regular_or_pace "Admitted to selective college"
lab var enrolled_SUA_by_y1 "Enrolled in selective college"
lab var sel_uni_major_st "Selectivity of program (college-major pair)"
lab var enrolled_SUA_by_y5  "Enrolled and persisted in selective college, year 5"
label var GPA_all "GPA grades 9-12"
label var sim_score "Sim. Test score"
label var sim_hours_study "Sim. hours study"
label var sim_GPA "Sim. GPA grade 12"
lab var sim_sit_PSU "Took college entrance exam - simulation"
lab var sim_admitted "Admitted to selective college - simulation"
lab var sim_enrolled_SUA "Enrolled in selective college - simulation"
lab var sim_sel_enrolled "Selectivity of program (college-major pair) - simulation"
lab var sim_persist_SUA  "Enrolled and persisted in selective college, year 5 - simulation"
label var sim_enrolled_SUA_pace "Sim. enrolled pace if admitted both"
label var enrolled_SUA_pace "Enrolled pace if admitted both"
label var sim_GPA_all "Sim GPA grades 9-12"
* List your variables and corresponding simulated variables
local variables hours_study GPA_cuarto_medio GPA_all top15_actual  sit_PSU admitted_SUA_regular_or_pace admitted_SUA_pace  enrolled_SUA_by_y1 sel_uni_major_st enrolled_SUA_by_y5 enrolled_SUA_pace 
local sim_variables  sim_hours_study sim_GPA sim_GPA_all sim_top15_actual  sim_sit_PSU sim_admitted sim_admitted_SUA_pace  sim_enrolled_SUA sim_sel_enrolled sim_persist_SUA  sim_enrolled_SUA_pace
* G H I L
cap matrix G
cap matrix I

* Loop over each real variable and add its statistics to matrix A
local k=1
foreach var in `variables' {
	
	if "`var'"== "enrolled_SUA_pace" {
	 quietly summarize `var' if treatment==1 & admitted_SUA_pace==1 & admitted_SUA_regular==1, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    if `k'==1 {
        matrix G = (`mean', `sd')
    }
    else {
        matrix G = G \ (`mean', `sd')
    }
    local k=`k'+1	
		
	}
	else {
    quietly summarize `var' if treatment==1, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    if `k'==1 {
        matrix G = (`mean', `sd')
    }
    else {
        matrix G = G \ (`mean', `sd')
    }
    local k=`k'+1
	}
}

* Loop over each simulated variable and add its statistics to matrix C
local k=1
foreach sim_var in `sim_variables' {
	
	if "`sim_var'"=="sim_enrolled_SUA_pace" {
    quietly summarize `sim_var' if treatment==1 & sim_admitted_SUA_pace==1 & sim_admitted_SUA_regular==1, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    if `k'==1 {
        matrix I = (`mean', `sd')
    }
    else {
        matrix I = I \ (`mean', `sd')
    }
	}
	
	else if "`sim_var'"=="sim_hours_study" {
    quietly summarize `sim_var' if treatment==1 & hours_study!=., detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    if `k'==1 {
        matrix I = (`mean', `sd')
    }
    else {
        matrix I = I \ (`mean', `sd')
    }				
	}
	
	else if "`sim_var'"=="sim_GPA" {
    quietly summarize `sim_var' if treatment==1 & GPA_cuarto_medio!=., detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    if `k'==1 {
        matrix I = (`mean', `sd')
    }
    else {
        matrix I = I \ (`mean', `sd')
    }				
	}
	
	else {
	    quietly summarize `sim_var' if treatment==1, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    if `k'==1 {
        matrix I = (`mean', `sd')
    }
    else {
        matrix I = I \ (`mean', `sd')
    }
	}
	
    local k=`k'+1
	
}

* Label the rows and columns of the matrices A and C
matrix rownames G = `variables'
matrix colnames G = Mean SD 
matrix rownames I = `sim_variables'
matrix colnames I = Mean SD 

* Combine matrices A Hnd C to show columns (1)-(3) for real data and columns (4)-(6) for simulated data
matrix final_treat = G , I

* Display the table
esttab matrix(final_treat) using "$tables/summary_stats_outcomes_model_fit.tex", nogap label append fragment nomtitles nolines collabels(none) nonumbers nolines ///
prehead(`" & & & &  \\"' `" \multicolumn{5}{l}{\textsc{B. Treatment}}\\"' `"\cline{1-1}"' ) ///
postfoot(`"\hline"' `"\end{tabular}"' `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"'  `"\item	\scriptsize \textsc{ Note. --} Sample of students enrolled in control schools. Simulated test scores, hours of study and GPA in grade 12 are summarized in the sample for which the corresponding variable is nonmissing in the data. The selectivity of the program is the average entrance exam score among all regular entrants in the selective college and major the student enrolled in. A student is coded as persisting in the fifth year if he/she enrolled in the first year after high school and stayed continuously enrolled in selective college every year up until and including year $5$, or if he/she enrolled in the first year after high school and graduated from a selective college in a year prior to year $5$.  If a student transfers to a different selective college program without taking a break in their studies, they are still considered continuously enrolled in a selective college."'   ///
         `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"')
		 

global initial_cond_controls_v1 GPA_avg_1_2 simce_avg_st Pgradb GPAb_coeff_eff PSUb_coeff_eff_1 PSUb_coeff_eff_2 PSUb_kink  cutoff_top15b modalidad // includes all model initial conditions (aside from type_prob_controls) except region, but we do not expect systematic correlation between region and other regressors 

label var sim_score  "Sim. Test Score"
label var sim_hours_study "Sim. Hours Study"
label var hours_study "Hours Study"
label var GPA_cuarto_medio "GPA Grade 12"
label var sim_GPA "Sim. GPA Grade 12"
label var treatment "Treatment"
gen cutoff_top15b=perceived_top15_cutoff
replace cutoff_top15b=actual_top15_cutoff if cutoff_top15b==. 
replace NEM_top15_April=NEM_top15 if NEM_top15_April==.
est clear 

* Data prep
rename y_data_missing survey_missing 
cap drop cutoff_top15b
gen cutoff_top15b=perceived_top15_cutoff
replace cutoff_top15b=actual_top15_cutoff if cutoff_top15b==. 
gen perceived_dist_cutoff = abs(exp_NEM-cutoff_top15b)

* Globals for controls
// ** NB the initial conditions now have the two coefficients, and the kink
global initial_cond_controls_v1 GPA_avg_1_2 simce_avg_st Pgradb GPAb_coeff_eff PSUb_coeff_eff_1 PSUb_coeff_eff_2 PSUb_kink  cutoff_top15b modalidad // includes all model initial conditions (aside from type_prob_controls) except region, but we do not expect systematic correlation between region and other regressors 
global type_prob_controls female survey_missing  // model initial conditions that only affect type prob 
global c_initial_cond GPA_avg_1_2  simce_avg_st Pgradb GPAb_coeff_eff PSUb_coeff_eff_1 PSUb_coeff_eff_2 PSUb_kink cutoff_top15b // continuous
global i_initial_cond modalidad female // discrete

label var GPA_avg_1_2 "Avg GPA in 9-10"
label var simce_avg_st "Simce"
label var Pgradb "Pgrad belief"
label var GPAb_coeff_eff "GPAb eff coeff"
label var PSUb_coeff_eff_1  "PSUb eff coeff 1"
label var PSUb_coeff_eff_2 "PSUb eff coeff 2"
label var PSUb_kink "PSUb eff kink"
label var cutoff_top15b "Cutoff top15 belief"
label var modalidad "Track"
label var female "Female"
label var survey_missing "Survey missing"
label var treatment "Treatment"
label var expPSUscore_st "PSUb"
label var hours_study "Hours of study"
	
* All sample 
* admissions (2)
reg admitted_SUA_regular_or_pace treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su admitted_SUA_regular_or_pace  if treatment==0
estadd scalar MEAN=`r(mean)'
est store m5
reg sim_admitted treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su sim_admitted  if treatment==0
estadd scalar MEAN=`r(mean)'
est store m5_sim 

* enrollments (2)
reg enrolled_SUA_18 treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su enrolled_SUA_18   if treatment==0
estadd scalar MEAN=`r(mean)'
est store m6
reg sim_enrolled_SUA  treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su sim_enrolled_SUA   if treatment==0
estadd scalar MEAN=`r(mean)'
est store m6_sim 

* persistence (2)
reg enrolled_SUA_22 treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su enrolled_SUA_22   if treatment==0
estadd scalar MEAN=`r(mean)'
est store m7
reg sim_persist_SUA treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su sim_persist_SUA   if treatment==0
estadd scalar MEAN=`r(mean)'
est store m7_sim 

esttab m5 m5_sim m6 m6_sim m7 m7_sim using "$tables/fit_TE_moments_adm_enr_per.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    cells(b(fmt(3)) se(par fmt(3) pattern(1 0 1 0 1 0))) nostar ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN, fmt(3) labels("Control mean")) ///
    prehead(`"\begin{table}[h]\centering"' `"\footnotesize "' `"\begin{threeparttable} "' ///
	`"\setlength\tabcolsep{0pt} "' 	`"\setlength\extrarowheight{2pt}"' 	`"\caption{\label{fitTEadmenrper} \textsc{Fit of auxiliary models for TE on admissions, enrollments, persistence.}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{6}{c}}"' `"\hline"' ///
		`"&  \multicolumn{2}{c}{Admissions} & \multicolumn{2}{c}{Enrollments} & \multicolumn{2}{c}{Persistence}  \\  "' ///
		`" & \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} & \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} & \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} \\ "' ///
		`"& (1)             & (2)   &  (3)  & (4) & (5)  & (6) \\"' 	`"\hline"'  `" \multicolumn{7}{c}{A. All students} \\"' ) 

* Top 15% sample 
* admissions (2)
reg admitted_SUA_regular_or_pace treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su admitted_SUA_regular_or_pace  if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m8
reg sim_admitted treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su sim_admitted  if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m8_sim 

* enrollments (2)
reg enrolled_SUA_18 treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su enrolled_SUA_18   if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m9
reg sim_enrolled_SUA treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su sim_enrolled_SUA   if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m9_sim 

* persistence (2)
reg enrolled_SUA_22 treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su enrolled_SUA_22   if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m10
reg sim_persist_SUA treatment $initial_cond_controls_v1 female  if top15baseline ==1, cluster(rbd_basefinal)
su sim_persist_SUA   if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m10_sim 

esttab m8 m8_sim m9 m9_sim m10 m10_sim using "$tables/fit_TE_moments_adm_enr_per.tex", append ///
    booktabs label unstack noobs keep(treatment) ///
    cells(b(fmt(3)) se(par fmt(3) pattern(1 0 1 0 1 0))) nostar ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN, fmt(3) labels("Control mean")) ///
    prehead(`"\\"'  `"\multicolumn{7}{c}{B. Top 15 percent at baseline} \\"' ) ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--} This table shows treatment effects and control means that we aim to match in the model estimation. The coefficients are OLS estimates; standard errors clustered at the school level are reported in parentheses for the data columns. All regressions include all model initial conditions except region and survey missing. {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. The outcome variable in columns (1)-(2) and is an indicator for being admitted to a selective college via regular or preferential admissions. The outcome variable in columns (3)-(4) and is an indicator for being enrolled in a selective college one year after high school. The outcome variable in columns (5)-(6) and is an indicator for being enrolled in a selective college five years after high school. Regressions in panel A are estimated on the entire sample of students in experimental schools. Regressions in panel B are estimated on the sample of students who at the end of $10^{th}$ grade were in the top $15\%$ of their school according to GPA in the first two high school years." "\end{tablenotes}" "\end{threeparttable}" "\end{table}") 
	
	
	
	

********************************************************************************
**# Table A26: Simulated PACE effects in Rational Expectations world
********************************************************************************
insheet using "$dataClean/baseline_CC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA

gen sim_enroll_dropout=1 if sim_enrolled_SUA ==1 & sim_persist_SUA ==0
replace sim_enroll_dropout=0 if sim_enroll_dropout==. 

rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
rename x11 sim_sit_PSU
rename x12 sim_PSU_latent
gen sim_PSU_observed=sim_PSU_latent if sim_sit_PSU==1
label var sim_PSU_latent "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA
rename x14 sim_PSUb
rename x15 sim_prob_adm_pace_b
rename x16 sim_prob_adm_regular_b
gen sim_prob_adm_b=(1.0-treatment)*sim_prob_adm_regular_b+treatment*(sim_prob_adm_regular_b+sim_prob_adm_pace_b-sim_prob_adm_pace_b*sim_prob_adm_regular_b)

rename x17 sim_GPAb
rename x18 sim_pr_persist
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data

rename x21 sim_ret_eff_pr_adm_b_0
rename x22 sim_ret_eff_pr_adm_b_1
rename x23 sim_ret_eff_pr_adm_b_2
rename x24 sim_ret_eff_pr_adm_b_3
rename x25 sim_ret_eff_pr_adm_b_4
rename x26 sim_ret_eff_pr_adm_b_5
rename x27 sim_ret_eff_pr_adm_b_6
rename x28 sim_ret_eff_pr_adm_b_7
rename x29 sim_ret_eff_pr_adm_b_8
rename x30 sim_ret_eff_pr_adm_b_9

rename x31 sim_hours_study_latent
rename x32 sim_type
gen high_type=1 if sim_type==1
replace high_type=0 if sim_type==2
rename x33 sim_utility_expected // ex-post utility based on perceptions, before dropouts occur
rename x34 sim_utility_actual   // ex-post utility based on actual dropouts

gen welfare_gap_perc=100*(sim_utility_actual -sim_utility_expected)/sim_utility_expected
label var welfare_gap_perc "Ex-post realized welfare gain, percent of ex-ante"

rename x35 sim_top15_actual
label var sim_top15_actual  "Sim. in top 15 actual"
rename x36 sim_sel_regular
rename x37 sim_sel_pace
gen sim_sel_enrolled=sim_sel_regular if sim_enrolled_SUA_regular==1
replace sim_sel_enrolled=sim_sel_pace if sim_enrolled_SUA_pace==1
rename x38 sim_PDV_2_nosit 
rename x39 sim_PDV_2_sit
rename x40 sim_PDV_4_ER // we have this value even for those without admissions
rename x41 sim_PDV_4_EP // we have this value even for those without admissions
rename x42 sim_PDV_4_ERdropout // we have this value even for those without admissions
rename x43 sim_PDV_4_EPdropout // we have this value even for those without admissions
rename x44 sim_PDV_4_GradP // we have this value even for those without admissions
rename x45 sim_PDV_4_GradR // we have this value even for those without admissions
rename x46 sim_GPA_all
label var sim_GPA_all "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0
rename x48 sim_PDV_1_eff1
rename x49 sim_PDV_1_eff2
rename x50 sim_PDV_1_eff3
rename x51 sim_PDV_1_eff4
rename x52 sim_PDV_1_eff5
rename x53 sim_PDV_1_eff6
rename x54 sim_PDV_1_eff7
rename x55 sim_PDV_1_eff8
rename x56 sim_PDV_1_eff9
rename x57 sim_PDV_1_eff10

rename x58 sim_Ut_1_eff0
rename x59 sim_Ut_1_eff1
rename x60 sim_Ut_1_eff2
rename x61 sim_Ut_1_eff3
rename x62 sim_Ut_1_eff4
rename x63 sim_Ut_1_eff5
rename x64 sim_Ut_1_eff6
rename x65 sim_Ut_1_eff7
rename x66 sim_Ut_1_eff8
rename x67 sim_Ut_1_eff9
rename x68 sim_Ut_1_eff10

rename x69 sim_Emax_1_eff0
rename x70 sim_Emax_1_eff1
rename x71 sim_Emax_1_eff2
rename x72 sim_Emax_1_eff3
rename x73 sim_Emax_1_eff4
rename x74 sim_Emax_1_eff5
rename x75 sim_Emax_1_eff6
rename x76 sim_Emax_1_eff7
rename x77 sim_Emax_1_eff8
rename x78 sim_Emax_1_eff9
rename x79 sim_Emax_1_eff10
rename x80 m_shock 
rename x81 sim_Ut_1 
rename x82 sim_Ut_2 
rename x83 sim_Ut_5_ante_b 
rename x84 sim_Ut_5_ante_RE
rename x85 sim_Ut_5_post

gen sim_overenrolled=1 if sim_enrolled_SUA==1 & sim_Ut_5_ante_RE<0
replace sim_overenrolled=0 if sim_overenrolled==.

gen sim_underenrolled=1 if sim_enrolled_SUA==0 & sim_Ut_5_ante_RE>0 &  sim_Ut_5_ante_RE!=. 
replace sim_underenrolled=0 if sim_underenrolled==. 

gen sim_mismatched=1 if sim_underenrolled==1 | sim_overenrolled==1 
replace sim_mismatched=0 if sim_mismatched==.

gen sim_optim_bias_ut_5 = sim_Ut_5_ante_b  - sim_Ut_5_ante_RE

merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110
sum sim_PDV_1_eff* 
sum sim_Ut_1_eff*
sum sim_Emax_1_eff*

* Generate simulated variables used in the analysis
* Used in description of beliefs: 
gen sim_PSU_bias=sim_PSUb-sim_PSU_observed 
label var sim_PSU_bias "Simulated believed minus actual entrance exam score \$|\$ sim. took exam (\$\sigma\$)"
gen sim_bias_own_NEM=sim_GPAb-sim_GPA 
label var sim_bias_own_NEM "Simulated believed minus actual \$12^{th}\$ grade GPA (GPA points)"
gen sim_p_admitted_above_050=1 if sim_prob_adm_regular_b>=0.5 & sim_prob_adm_regular_b!=.
replace sim_p_admitted_above_050=0 if sim_prob_adm_regular_b<0
label var sim_p_admitted_above_050 "Simulated subj prob regular admission \$\geq 0.50\$"
label var sim_prob_adm_regular_b "Simulated subjective probability of a regular admission"
label var sim_GPAb "Believed GPA"
*Top 15 cutoff used in model
gen perceived_top15_cutoff=NEM_top15_April
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
gen sim_minus_bias_top15=sim_top15_actual-perceived_top15_cutoff
label var  sim_minus_bias_top15 "Simuulated actual minus believed top \$15\%\$ cutoff in school (GPA points)"
gen sim_think_top15=1 if sim_GPAb>=perceived_top15_cutoff & sim_GPAb!=.
replace sim_think_top15=0 if sim_GPAb<perceived_top15_cutoff
label var sim_think_top15 "Simulated to believe is in top \$15\%\$ of school"

gen sim_perceived_above_cutoff=sim_GPAb-perceived_top15_cutoff
label var sim_perceived_above_cutoff "Sim. expected GPA minus expected cutoff"

gen perceived_above_cutoff=exp_NEM-perceived_top15_cutoff
label var perceived_above_cutoff "Expected GPA minus expected cutoff"

* Following variables used only to guide calibration 
gen y_data_missing=1 if score_all_st==.
replace y_data_missing=0 if score_all_st!=.

gen top15_actual=top15endline 
label var top15_actual "Top 15% based on all years GPA"

gen GPA_all = 0.5*GPA_avg_1_2 + 0.25 * GPA_tercero_medio +0.2*GPA_cuarto_medio 
label var GPA_all "GPA all 4 years"

preserve
* Open RE simulations and save as .dta 
insheet using "$dataClean/countREandPACE_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score_REP
rename x5 sim_hours_study_REP
rename x6 sim_enrolled_SUA_regular_REP
rename x7 sim_enrolled_SUA_pace_REP 
gen sim_enrolled_SUA_REP = 1 if sim_enrolled_SUA_regular_REP==1 | sim_enrolled_SUA_pace_REP==1
replace sim_enrolled_SUA_REP = 0 if sim_enrolled_SUA_REP==.
rename x8 sim_persist_SUA_REP

gen sim_enroll_dropout_REP=1 if sim_enrolled_SUA_REP ==1 & sim_persist_SUA_REP ==0
replace sim_enroll_dropout_REP=0 if sim_enroll_dropout_REP==. 

rename x9 sim_admitted_SUA_regular_REP
rename x10 sim_admitted_SUA_pace_REP 
gen sim_admitted_REP = 1 if sim_admitted_SUA_regular_REP==1 | sim_admitted_SUA_pace_REP==1
replace sim_admitted_REP = 0 if sim_admitted_REP==.
rename x11 sim_sit_PSU_REP
rename x12 sim_PSU_latent_REP
gen sim_PSU_observed_REP = sim_PSU_latent_REP if sim_sit_PSU_REP==1
label var sim_PSU_latent_REP "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed_REP "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA_REP
rename x14 sim_PSUb_REP
rename x15 sim_prob_adm_pace_b_REP
rename x16 sim_prob_adm_regular_b_REP
gen sim_prob_adm_b_REP=(1.0-treatment)*sim_prob_adm_regular_b_REP+treatment*(sim_prob_adm_regular_b_REP+sim_prob_adm_pace_b_REP-sim_prob_adm_pace_b_REP*sim_prob_adm_regular_b_REP)

rename x17 sim_GPAb_REP
rename x18 sim_pr_persist_REP
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data

rename x21 sim_ret_eff_pr_adm_b_0_REP
rename x22 sim_ret_eff_pr_adm_b_1_REP
rename x23 sim_ret_eff_pr_adm_b_2_REP
rename x24 sim_ret_eff_pr_adm_b_3_REP
rename x25 sim_ret_eff_pr_adm_b_4_REP
rename x26 sim_ret_eff_pr_adm_b_5_REP
rename x27 sim_ret_eff_pr_adm_b_6_REP
rename x28 sim_ret_eff_pr_adm_b_7_REP
rename x29 sim_ret_eff_pr_adm_b_8_REP
rename x30 sim_ret_eff_pr_adm_b_9_REP

rename x31 sim_hours_study_latent_REP
rename x32 sim_type_REP
gen high_type_REP = 1 if sim_type_REP==1
replace high_type_REP = 0 if sim_type_REP==2

rename x33 sim_utility_expected_REP
rename x34 sim_utility_actual_REP

gen welfare_gap_perc_REP=100*(sim_utility_actual_REP -sim_utility_expected_REP)/sim_utility_expected_REP
label var welfare_gap_perc_REP "Ex-post realized welfare gain, percent of ex-ante"

rename x35 sim_top15_actual_REP
label var sim_top15_actual_REP "Sim. in top 15 actual"
rename x36 sim_sel_regular_REP
rename x37 sim_sel_pace_REP
gen sim_sel_enrolled_REP = sim_sel_regular_REP if sim_enrolled_SUA_regular_REP==1
replace sim_sel_enrolled_REP = sim_sel_pace_REP if sim_enrolled_SUA_pace_REP==1
rename x38 sim_PDV_2_nosit_REP 
rename x39 sim_PDV_2_sit_REP
rename x40 sim_PDV_4_ER_REP
rename x41 sim_PDV_4_EP_REP
rename x42 sim_PDV_4_ERdropout_REP
rename x43 sim_PDV_4_EPdropout_REP
rename x44 sim_PDV_4_GradP_REP
rename x45 sim_PDV_4_GradR_REP
rename x46 sim_GPA_all_REP
label var sim_GPA_all_REP "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0_REP
rename x48 sim_PDV_1_eff1_REP
rename x49 sim_PDV_1_eff2_REP
rename x50 sim_PDV_1_eff3_REP
rename x51 sim_PDV_1_eff4_REP
rename x52 sim_PDV_1_eff5_REP
rename x53 sim_PDV_1_eff6_REP
rename x54 sim_PDV_1_eff7_REP
rename x55 sim_PDV_1_eff8_REP
rename x56 sim_PDV_1_eff9_REP
rename x57 sim_PDV_1_eff10_REP

rename x58 sim_Ut_1_eff0_REP
rename x59 sim_Ut_1_eff1_REP
rename x60 sim_Ut_1_eff2_REP
rename x61 sim_Ut_1_eff3_REP
rename x62 sim_Ut_1_eff4_REP
rename x63 sim_Ut_1_eff5_REP
rename x64 sim_Ut_1_eff6_REP
rename x65 sim_Ut_1_eff7_REP
rename x66 sim_Ut_1_eff8_REP
rename x67 sim_Ut_1_eff9_REP
rename x68 sim_Ut_1_eff10_REP

rename x69 sim_Emax_1_eff0_REP
rename x70 sim_Emax_1_eff1_REP
rename x71 sim_Emax_1_eff2_REP
rename x72 sim_Emax_1_eff3_REP
rename x73 sim_Emax_1_eff4_REP
rename x74 sim_Emax_1_eff5_REP
rename x75 sim_Emax_1_eff6_REP
rename x76 sim_Emax_1_eff7_REP
rename x77 sim_Emax_1_eff8_REP
rename x78 sim_Emax_1_eff9_REP
rename x79 sim_Emax_1_eff10_REP
rename x80 m_shock
rename x81 sim_Ut_1_REP
rename x82 sim_Ut_2_REP 
rename x83 sim_Ut_5_ante_b_REP
rename x84 sim_Ut_5_ante_RE_REP
rename x85 sim_Ut_5_post_REP


gen sim_overenrolled_REP=1 if sim_enrolled_SUA_REP==1 & sim_Ut_5_ante_RE_REP<0
replace sim_overenrolled_REP=0 if sim_overenrolled_REP==.

gen sim_underenrolled_REP=1 if sim_enrolled_SUA_REP==0 & sim_Ut_5_ante_RE_REP>0 &  sim_Ut_5_ante_RE_REP!=. 
replace sim_underenrolled_REP=0 if sim_underenrolled_REP==. 

gen sim_mismatched_REP=1 if sim_underenrolled_REP==1 | sim_overenrolled_REP==1 
replace sim_mismatched_REP=0 if sim_mismatched_REP==.

gen sim_optim_bias_ut_5_REP = sim_Ut_5_ante_b_REP  - sim_Ut_5_ante_RE_REP


save "$dataClean/countREandPACE_CC_2types.dta", replace

restore 

merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/countREandPACE_CC_2types.dta"
drop _merge 
tab high_type high_type_REP // ok
drop high_type_REP 

preserve

* Open RE-only simulations and save as .dta 
insheet using "$dataClean/counteffpersandPACE_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score_effpP
rename x5 sim_hours_study_effpP
rename x6 sim_enrolled_SUA_regular_effpP
rename x7 sim_enrolled_SUA_pace_effpP
gen sim_enrolled_SUA_effpP = 1 if sim_enrolled_SUA_regular_effpP==1 | sim_enrolled_SUA_pace_effpP==1
replace sim_enrolled_SUA_effpP = 0 if sim_enrolled_SUA_effpP==.
rename x8 sim_persist_SUA_effpP

gen sim_enroll_dropout_effpP=1 if sim_enrolled_SUA_effpP ==1 & sim_persist_SUA_effpP ==0
replace sim_enroll_dropout_effpP=0 if sim_enroll_dropout_effpP==. 

rename x9 sim_admitted_SUA_regular_effpP
rename x10 sim_admitted_SUA_pace_effpP 
gen sim_admitted_effpP = 1 if sim_admitted_SUA_regular_effpP==1 | sim_admitted_SUA_pace_effpP==1
replace sim_admitted_effpP = 0 if sim_admitted_effpP==.
rename x11 sim_sit_PSU_effpP
rename x12 sim_PSU_latent_effpP
gen sim_PSU_observed_effpP = sim_PSU_latent_effpP if sim_sit_PSU_effpP==1
label var sim_PSU_latent_effpP "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed_effpP "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA_effpP
rename x14 sim_PSUb_effpP
rename x15 sim_prob_adm_pace_b_effpP
rename x16 sim_prob_adm_regular_b_effpP
gen sim_prob_adm_b_effpP=(1.0-treatment)*sim_prob_adm_regular_b_effpP+treatment*(sim_prob_adm_regular_b_effpP+sim_prob_adm_pace_b_effpP-sim_prob_adm_pace_b_effpP*sim_prob_adm_regular_b_effpP)

rename x17 sim_GPAb_effpP
rename x18 sim_pr_persist_effpP
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data

rename x21 sim_ret_eff_pr_adm_b_0_effpP
rename x22 sim_ret_eff_pr_adm_b_1_effpP
rename x23 sim_ret_eff_pr_adm_b_2_effpP
rename x24 sim_ret_eff_pr_adm_b_3_effpP
rename x25 sim_ret_eff_pr_adm_b_4_effpP
rename x26 sim_ret_eff_pr_adm_b_5_effpP
rename x27 sim_ret_eff_pr_adm_b_6_effpP
rename x28 sim_ret_eff_pr_adm_b_7_effpP
rename x29 sim_ret_eff_pr_adm_b_8_effpP
rename x30 sim_ret_eff_pr_adm_b_9_effpP

rename x31 sim_hours_study_latent_effpP
rename x32 sim_type_effpP
gen high_type_effpP = 1 if sim_type_effpP==1
replace high_type_effpP = 0 if sim_type_effpP==2

rename x33 sim_utility_expected_effpP
rename x34 sim_utility_actual_effpP
gen welfare_gap_perc_effpP=100*(sim_utility_actual_effpP -sim_utility_expected_effpP)/sim_utility_expected_effpP
label var welfare_gap_perc_effpP "Ex-post realized welfare gain, percent of ex-ante"

rename x35 sim_top15_actual_effpP
label var sim_top15_actual_effpP "Sim. in top 15 actual"
rename x36 sim_sel_regular_effpP
rename x37 sim_sel_pace_effpP
gen sim_sel_enrolled_effpP = sim_sel_regular_effpP if sim_enrolled_SUA_regular_effpP==1
replace sim_sel_enrolled_effpP = sim_sel_pace_effpP if sim_enrolled_SUA_pace_effpP==1
rename x38 sim_PDV_2_nosit_effpP 
rename x39 sim_PDV_2_sit_effpP
rename x40 sim_PDV_4_ER_effpP
rename x41 sim_PDV_4_EP_effpP
rename x42 sim_PDV_4_ERdropout_effpP
rename x43 sim_PDV_4_EPdropout_effpP
rename x44 sim_PDV_4_GradP_effpP
rename x45 sim_PDV_4_GradR_effpP
rename x46 sim_GPA_all_effpP
label var sim_GPA_all_effpP "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0_effpP
rename x48 sim_PDV_1_eff1_effpP
rename x49 sim_PDV_1_eff2_effpP
rename x50 sim_PDV_1_eff3_effpP
rename x51 sim_PDV_1_eff4_effpP
rename x52 sim_PDV_1_eff5_effpP
rename x53 sim_PDV_1_eff6_effpP
rename x54 sim_PDV_1_eff7_effpP
rename x55 sim_PDV_1_eff8_effpP
rename x56 sim_PDV_1_eff9_effpP
rename x57 sim_PDV_1_eff10_effpP

rename x58 sim_Ut_1_eff0_effpP
rename x59 sim_Ut_1_eff1_effpP
rename x60 sim_Ut_1_eff2_effpP
rename x61 sim_Ut_1_eff3_effpP
rename x62 sim_Ut_1_eff4_effpP
rename x63 sim_Ut_1_eff5_effpP
rename x64 sim_Ut_1_eff6_effpP
rename x65 sim_Ut_1_eff7_effpP
rename x66 sim_Ut_1_eff8_effpP
rename x67 sim_Ut_1_eff9_effpP
rename x68 sim_Ut_1_eff10_effpP

rename x69 sim_Emax_1_eff0_effpP
rename x70 sim_Emax_1_eff1_effpP
rename x71 sim_Emax_1_eff2_effpP
rename x72 sim_Emax_1_eff3_effpP
rename x73 sim_Emax_1_eff4_effpP
rename x74 sim_Emax_1_eff5_effpP
rename x75 sim_Emax_1_eff6_effpP
rename x76 sim_Emax_1_eff7_effpP
rename x77 sim_Emax_1_eff8_effpP
rename x78 sim_Emax_1_eff9_effpP
rename x79 sim_Emax_1_eff10_effpP
rename x80 m_shock

rename x81 sim_Ut_1_effpP
rename x82 sim_Ut_2_effpP
rename x83 sim_Ut_5_ante_b_effpP
rename x84 sim_Ut_5_ante_RE_effpP
rename x85 sim_Ut_5_post_effpP


gen sim_overenrolled_effpP=1 if sim_enrolled_SUA_effpP==1 & sim_Ut_5_ante_RE_effpP<0
replace sim_overenrolled_effpP=0 if sim_overenrolled_effpP==.

gen sim_underenrolled_effpP=1 if sim_enrolled_SUA_effpP==0 & sim_Ut_5_ante_RE_effpP>0 &  sim_Ut_5_ante_RE_effpP!=. 
replace sim_underenrolled_effpP=0 if sim_underenrolled_effpP==. 

gen sim_mismatched_effpP=1 if sim_underenrolled_effpP==1 | sim_overenrolled_effpP==1 
replace sim_mismatched_effpP=0 if sim_mismatched_effpP==.


save "$dataClean/counteffpersandPACE_CC_2types.dta", replace

restore


merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/counteffpersandPACE_CC_2types.dta"
drop _merge 
tab high_type high_type_effpP // ok
drop high_type_effpP

gen sim_optim_bias_ut_5_effpP = sim_Ut_5_ante_b_effpP  - sim_Ut_5_ante_RE_effpP

* Get percentiles
summarize simce_avg_st, detail
global simce_p1 = r(p1)
global simce_p99 = r(p99)


forval y=0/9 {
	
		egen hugo = mean(sim_ret_eff_pr_adm_b_`y') if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen sim_ret_eff_pr_adm_b_`y'_count1_0=max(hugo)
				drop hugo
				
				egen hugo = mean(sim_ret_eff_pr_adm_b_`y'_REP) if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen sim_ret_eff_pr_adm_b_`y'_count1_1=max(hugo)
				drop hugo 
				
				gen sim_ret_eff_pr_adm_b_`y'_count1 =  sim_ret_eff_pr_adm_b_`y'_count1_0 if treatment==0 
				replace sim_ret_eff_pr_adm_b_`y'_count1 = sim_ret_eff_pr_adm_b_`y'_count1_1 if treatment==1
				drop sim_ret_eff_pr_adm_b_`y'_count1_1 sim_ret_eff_pr_adm_b_`y'_count1_0
			
}

* Counterfactual 2 = give full RE AND PACE
gen sim_admitted_count2 = sim_admitted if treatment==0
replace sim_admitted_count2 = sim_admitted_REP if treatment==1 

gen sim_enrolled_SUA_count2 = sim_enrolled_SUA if treatment==0 
replace sim_enrolled_SUA_count2 = sim_enrolled_SUA_REP if treatment==1 

gen sim_persist_SUA_count2 = sim_persist_SUA if treatment==0
replace sim_persist_SUA_count2 = sim_persist_SUA_REP if treatment==1 

gen sim_hours_study_latent_count2 = sim_hours_study_latent if treatment==0
replace sim_hours_study_latent_count2 = sim_hours_study_latent_REP if treatment==1

gen sim_hours_study_count2 = sim_hours_study if treatment==0
replace sim_hours_study_count2 = sim_hours_study_REP if treatment==1

gen sim_GPA_count2 = sim_GPA if treatment==0
replace sim_GPA_count2 = sim_GPA_REP if treatment==1 

gen sim_sit_PSU_count2 = sim_sit_PSU if treatment==0
replace sim_sit_PSU_count2 = sim_sit_PSU_REP if treatment==1


forval y=0/9 {
gen sim_ret_eff_pr_adm_b_`y'_count2 = sim_ret_eff_pr_adm_b_`y' if treatment==0
replace sim_ret_eff_pr_adm_b_`y'_count2 = sim_ret_eff_pr_adm_b_`y'_REP if treatment==1	
}

gen sim_optim_bias_ut_5_count2 = sim_optim_bias_ut_5 if treatment==0
replace sim_optim_bias_ut_5_count2 = sim_optim_bias_ut_5_REP if treatment==1

gen welfare_gap_perc_count2 = welfare_gap_perc if treatment==0
replace welfare_gap_perc_count2 = welfare_gap_perc_REP if treatment==1

gen sim_utility_actual_count2 = sim_utility_actual if treatment==0
replace sim_utility_actual_count2 = sim_utility_actual_REP if treatment==1

gen sim_utility_expected_count2 = sim_utility_expected if treatment==0
replace sim_utility_expected_count2 = sim_utility_expected_REP if treatment==1

gen sim_enroll_dropout_count2 = sim_enroll_dropout if treatment==0
replace sim_enroll_dropout_count2 = sim_enroll_dropout_REP if treatment==1

gen sim_Ut_5_post_count2 = sim_Ut_5_post if treatment==0 
replace sim_Ut_5_post_count2 = sim_Ut_5_post_REP if treatment==1 

gen sim_Ut_2_count2 = sim_Ut_2 if treatment==0 
replace sim_Ut_2_count2 = sim_Ut_2_REP if treatment==1 

gen sim_Ut_5_ante_b_count2 = sim_Ut_5_ante_b  if treatment==0 
replace sim_Ut_5_ante_b_count2 = sim_Ut_5_ante_b_REP if treatment==1 

gen sim_Ut_1_count2 = sim_Ut_1 if treatment==0 
replace sim_Ut_1_count2 = sim_Ut_1_REP if treatment==1 

gen sim_overenrolled_count2 = sim_overenrolled if treatment==0
replace sim_overenrolled_count2 =  sim_overenrolled_REP if treatment==1

gen sim_underenrolled_count2 = sim_underenrolled if treatment==0
replace sim_underenrolled_count2 = sim_underenrolled_REP if treatment==1 

gen sim_mismatched_count2 = sim_mismatched if treatment==0
replace sim_mismatched_count2 = sim_mismatched_REP if treatment==1

gen sim_persist_if_enr_REP = sim_persist_SUA_REP if sim_enrolled_SUA_REP==1
gen sim_persist_if_enr_count2 = sim_persist_SUA if sim_enrolled_SUA==1 & treatment==0 
replace sim_persist_if_enr_count2 = sim_persist_SUA_REP if sim_enrolled_SUA_REP==1 & treatment==1




* Counterfactual 5 = give info on returns to effort in persistence, without correcting beliefs, AND PACE 

gen sim_admitted_count5 = sim_admitted if treatment==0
replace sim_admitted_count5 = sim_admitted_effpP if treatment==1 

gen sim_enrolled_SUA_count5 = sim_enrolled_SUA if treatment==0 
replace sim_enrolled_SUA_count5 = sim_enrolled_SUA_effpP if treatment==1 

gen sim_persist_SUA_count5 = sim_persist_SUA if treatment==0
replace sim_persist_SUA_count5 = sim_persist_SUA_effpP if treatment==1 

gen sim_hours_study_latent_count5 = sim_hours_study_latent if treatment==0
replace sim_hours_study_latent_count5 = sim_hours_study_latent_effpP if treatment==1

gen sim_hours_study_count5 = sim_hours_study if treatment==0
replace sim_hours_study_count5 = sim_hours_study_effpP if treatment==1

gen sim_GPA_count5 = sim_GPA if treatment==0
replace sim_GPA_count5 = sim_GPA_effpP if treatment==1 

gen sim_sit_PSU_count5 = sim_sit_PSU if treatment==0
replace sim_sit_PSU_count5 = sim_sit_PSU_effpP if treatment==1

forval y=0/9 {
gen sim_ret_eff_pr_adm_b_`y'_count5 = sim_ret_eff_pr_adm_b_`y' if treatment==0
replace sim_ret_eff_pr_adm_b_`y'_count5 = sim_ret_eff_pr_adm_b_`y'_effpP if treatment==1	
}

gen sim_optim_bias_ut_5_count5 = sim_optim_bias_ut_5 if treatment==0
replace sim_optim_bias_ut_5_count5 = sim_optim_bias_ut_5_effpP if treatment==1

gen welfare_gap_perc_count5 = welfare_gap_perc if treatment==0
replace welfare_gap_perc_count5 = welfare_gap_perc_effpP if treatment==1

gen sim_utility_actual_count5 = sim_utility_actual if treatment==0
replace sim_utility_actual_count5 = sim_utility_actual_effpP if treatment==1

gen sim_utility_expected_count5 = sim_utility_expected if treatment==0
replace sim_utility_expected_count5 = sim_utility_expected_effpP if treatment==1

gen sim_enroll_dropout_count5 = sim_enroll_dropout if treatment==0
replace sim_enroll_dropout_count5 = sim_enroll_dropout_effpP if treatment==1


gen sim_Ut_5_post_count5 = sim_Ut_5_post if treatment==0 
replace sim_Ut_5_post_count5 = sim_Ut_5_post_effpP if treatment==1 

gen sim_Ut_2_count5 = sim_Ut_2 if treatment==0 
replace sim_Ut_2_count5 = sim_Ut_2_effpP if treatment==1 

gen sim_Ut_5_ante_b_count5 = sim_Ut_5_ante_b  if treatment==0 
replace sim_Ut_5_ante_b_count5 = sim_Ut_5_ante_b_effpP if treatment==1 

gen sim_Ut_1_count5 = sim_Ut_1 if treatment==0 
replace sim_Ut_1_count5 = sim_Ut_1_effpP if treatment==1 

gen sim_overenrolled_count5 = sim_overenrolled if treatment==0
replace sim_overenrolled_count5 =  sim_overenrolled_effpP if treatment==1

gen sim_underenrolled_count5 = sim_underenrolled if treatment==0
replace sim_underenrolled_count5 = sim_underenrolled_effpP if treatment==1 

gen sim_mismatched_count5 = sim_mismatched if treatment==0
replace sim_mismatched_count5 = sim_mismatched_effpP if treatment==1  


gen sim_persist_if_enr_effpP = sim_persist_SUA_effpP if sim_enrolled_SUA_effpP==1
gen sim_persist_if_enr_count5 = sim_persist_SUA if sim_enrolled_SUA==1 & treatment==0 
replace sim_persist_if_enr_count5 = sim_persist_SUA_effpP if sim_enrolled_SUA_effpP==1 & treatment==1

gen sim_persist_if_enr = sim_persist_SUA if sim_enrolled_SUA==1
sort mrun m_shock 
local bases sim_admitted sim_enrolled_SUA sim_persist_SUA sim_enroll_dropout ///
             sim_hours_study_latent sim_hours_study ///
             sim_GPA sim_sit_PSU welfare_gap_perc sim_utility_actual sim_utility_expected ///
			 sim_Ut_2 sim_Ut_5_post  sim_Ut_1 sim_Ut_5_ante_b  ///
			 sim_overenrolled sim_mismatched sim_underenrolled  sim_optim_bias_ut_5 sim_persist_if_enr

			 foreach y of local bases {
			 	
				egen hugo = mean(`y') if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen `y'_0=max(hugo)
				drop hugo
				
				egen hugo = mean(`y'_REP) if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen `y'_1=max(hugo)
				drop hugo 
				gen `y'_count1_TE=`y'_1 - `y'_0
				drop `y'_1 `y'_0
			 }
			 		 
* Sort by your grouping identifiers
sort mrun m_shock

* define the base variable stems (everything before "_count")
local bases sim_admitted sim_enrolled_SUA sim_persist_SUA sim_enroll_dropout ///
             sim_hours_study_latent sim_hours_study ///
             sim_GPA sim_sit_PSU welfare_gap_perc sim_utility_actual sim_utility_expected ///
			 sim_Ut_2 sim_Ut_5_post  sim_Ut_1 sim_Ut_5_ante_b ///
			 sim_overenrolled sim_mismatched sim_underenrolled sim_optim_bias_ut_5 sim_persist_if_enr

* loop over suffixes 1–5
foreach c in  2  5 {
    * loop over each base name
    foreach b of local bases {
        * construct the full varname
        local y = "`b'_count`c'"

        * compute treated and control values, difference them
		egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_1=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_0=max(hugo)
	  drop hugo
       * egen `y'_0 = mean(`y') if treatment==0, by(mrun m_shock)
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
    }
}


local bases sim_admitted sim_enrolled_SUA sim_persist_SUA sim_enroll_dropout  ///
             sim_hours_study_latent sim_hours_study ///
             sim_GPA sim_sit_PSU welfare_gap_perc sim_utility_actual sim_utility_expected ///
			 sim_Ut_2 sim_Ut_5_post  sim_Ut_1 sim_Ut_5_ante_b ///
			 sim_overenrolled sim_mismatched sim_underenrolled sim_optim_bias_ut_5 sim_persist_if_enr
foreach y of local bases {
			egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_1=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_0=max(hugo)
	  drop hugo
       * egen `y'_0 = mean(`y') if treatment==0, by(mrun m_shock)
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
}


* Generate indiviaul-level TE under RE in both T and C (_REP simulations)

local bases sim_admitted_REP sim_enrolled_SUA_REP sim_persist_SUA_REP sim_enroll_dropout_REP  ///
             sim_hours_study_latent_REP sim_hours_study_REP ///
             sim_GPA_REP sim_sit_PSU_REP  ///
			 sim_Ut_2_REP sim_Ut_5_post_REP sim_Ut_1_REP sim_Ut_5_ante_b_REP ///
			 sim_persist_if_enr_REP
foreach y of local bases {
			egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_1=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_0=max(hugo)
	  drop hugo
       * egen `y'_0 = mean(`y') if treatment==0, by(mrun m_shock)
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
}


est clear 
local outcomes ///
    hours_study ///
    sit_PSU      ///
    admitted     ///
    enrolled_SUA ///
    persist_SUA  ///
	enroll_dropout  

cap matrix M
local i = 1

foreach out of local outcomes {
    * Baseline PACE effect under estimated beliefs
    quietly summarize sim_`out'_TE
    local m0 = round(r(mean), 0.0001)

    * PACE effect when beliefs are set to rational expectations
    quietly summarize sim_`out'_REP_TE
    local m1 = round(r(mean), 0.0001)

    if `i' == 1 {
        matrix M = ( `m0', `m1' )
    }
    else {
        matrix M = M \ ( `m0', `m1' )
    }
    local ++i
}

matrix rownames M = ///
    "Study hours/week" ///
    "Took entrance exam" ///
    "Admitted" ///
    "Enrolled" ///
    "Enrolled and persisted" ///
	"Enrolled and dropped out" 

matrix colnames M = ///
    Baseline_PACE ///
    PACE_RE
 
	
esttab matrix(M) using "$tables/simulated_ATEs_RE.tex", replace ///
    fragment booktabs ///
	    cells("fmt(4)") ///
		  collabels(none) ///
    nomtitles nonumbers nogap ///
    prehead(`"\begin{table}[ht]\centering \begin{threeparttable}"' ///
            `"\scriptsize"' ///
            `"\caption{\textsc{Simulated PACE effects under estimated beliefs and under rational expectations \label{tab:ATERE}}}"' ///
            `"\begin{tabular}{l*{2}{c}}"' ///
            `"\hline"' ///
             `" & (1) & (2) \\"'  ///
`" & \multicolumn{1}{c}{Baseline PACE effects} & \multicolumn{1}{c}{PACE effects under rational expectations} \\"' ) ///
			 postfoot(`"\hline"'  `"\vspace{-10pt}"' `"\end{tabular}"'  `"\begin{tablenotes}\singlespacing"' ///
         `"\item	\scriptsize \textsc{ Note. --}  This table reports average simulated effects of introducing PACE under two belief environments. Column (1) uses the estimated baseline belief environment. Column (2) sets beliefs to rational expectations in both the no-PACE and PACE simulations. In each column, the reported effect is the simulated mean outcome with PACE minus the simulated mean outcome without PACE, averaged over the model simulation sample, which corresponds to all individuals in the control group in the data. "' ///
         `"\end{tablenotes}"'  `"\end{threeparttable}"' `"\end{table}"')
			 

********************************************************************************
**# Figure 6: Model fit - targeted moments
********************************************************************************
* The following csv is created in julia
insheet using "$dataClean/baseline_TC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.



merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge


est clear
foreach sample in all top15baseline {
	
    local varlist1 admitted_SUA_regular_or_pace  enrolled_SUA_by_y1 enrolled_SUA_by_y5 sim_admitted sim_enrolled_SUA sim_persist_SUA

    local count=0
    foreach var of varlist `varlist1' {
        local count=`count'+1
		* LPM regression 
        reg `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if `sample'==1, ///
		cluster(rbd_basefinal)
		lincom treatment
        local fig_b`count'= r(estimate)
        local fig_se`count'= r(se) 
        local lab_b`count' : display %4.3f `fig_b`count''
        local lab_se`count' : display %4.3f `fig_se`count'' 
	}
    
    * Extract simulated data estimates separately
    local sim_count = 0
    foreach var of varlist sim_admitted sim_enrolled_SUA sim_persist_SUA {
        local sim_count = `sim_count' + 1
        reg `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if `sample'==1, ///
        cluster(rbd_basefinal)
        lincom treatment
        local fig_sim_b`sim_count' = r(estimate)
    }

    * Prepare dataset for visualization
    preserve 
    clear
    set obs 3  // We now only include the real data TEs

    cap drop fig*
    gen fig_b = .
    gen fig_se = .
    gen fig_sim_b = .   // Variable for simulated TEs

    forvalues num=1(1)3 {
        replace fig_b = `fig_b`num'' if _n == `num'
        replace fig_se = `fig_se`num'' if _n == `num'
        replace fig_sim_b = `fig_sim_b`num'' if _n == `num'
    }

    gen fig_upper = fig_b + 1.96 * fig_se
    gen fig_lower = fig_b - 1.96 * fig_se
    gen fig_t = _n

    if "`sample'" == "all" {
        twoway ///
        (bar fig_b fig_t, barw(0.6) color(midblue*0.4)) || /// Real data bars
        (rcap fig_upper fig_lower fig_t, lcolor(navy) c(l) m(i)) || /// Error bars for real data
        (scatter fig_sim_b fig_t, msize(large) mcolor(black) msymbol(triangle)), /// Simulated TE as triangles
        graphregion(fcolor(white)) yline(0, lc(gs11) lp(shortdash)) title("All", size(large)) ///
        ylab(0(0.02)0.08, nogrid) ytitle("Treatment effect")  legend(order(1 "Data" 3 "Simulations") ring(100) position(6) row(1))  xtitle("") /// position(6) row(1)) ///
        xlabel(1 "Admissions" ///
               2 `" "Enrollments" "in 1{superscript:st} year" "' ///
               3 `" "Enrollments" "in 5{superscript:th} year" "' 3.3 " ", nogrid) ///
			 saving("$dataTemp/TE_over_time_enrolled_SUA_`sample'", replace)
        restore
    }

    if "`sample'" == "top15baseline" {
        twoway ///
        (bar fig_b fig_t, barw(0.6) color(midblue*0.4)) || /// Real data bars
        (rcap fig_upper fig_lower fig_t, lcolor(navy) c(l) m(i)) || /// Error bars for real data
        (scatter fig_sim_b fig_t, msize(large) mcolor(black) msymbol(triangle)), /// Simulated TE as triangles
        graphregion(fcolor(white)) yline(0, lc(gs11) lp(shortdash)) title("Top 15% at baseline", size(large)) ///
        ylab(0(0.05)0.35, nogrid) ytitle("Treatment effect") legend(order(1 "Data" 3 "Simulations")  ring(100) position(6) row(1)) xtitle("") ///
        xlabel(1 "Admissions" ///
               2 `" "Enrollments" "in 1{superscript:st} year" "' ///
               3 `" "Enrollments" "in 5{superscript:th} year" "' 3.3 " ", nogrid) ///
			   saving("$dataTemp/TE_over_time_enrolled_SUA_`sample'", replace)
        restore
    }
}

* Combine the graphs for the two samples into one graph 

graph combine "$dataTemp/TE_over_time_enrolled_SUA_all" "$dataTemp/TE_over_time_enrolled_SUA_top15baseline", saving("$dataTemp/TE_over_time_enrolled_SUA", replace) 
graph export "$graphs/TE_over_time_enrolled_SUA.png", replace





********************************************************************************
**# Figure 7: Model fit - untargeted moments
********************************************************************************

insheet using "$dataClean/baseline_TC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x5 sim_hours_study




merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge


global controls simce_avg_st female age alumno_prioritario neverfailed modalidad
xtile simce_cat5=simce_avg_st, n(5)

* Store simulated point estimates
matrix sim_pts = J(5, 1, .)  // Adjust size based on number of quintiles

forval y=0(2)8 {
    reg sim_hours_study treatment $controls if GPA_1_2_rank>0.`y' & GPA_1_2_rank<=0.`y'+0.2 , cluster(rbd_basefinal)
    matrix sim_pts[`y'/2+1, 1] = _b[treatment]  // Store simulated point estimates
}

* Effect on effort by within-school rank quintile
label var treatment "Baseline school rank (quintile)"
forval y=0(2)8 {
    reg hours_study treatment $controls i.id_fieldworker if GPA_1_2_rank>0.`y' & GPA_1_2_rank<=0.`y'+0.2 , cluster(rbd_basefinal)
    est sto equint`y'
}
coefplot equint0 equint2 equint4 equint6 equint8, ///
    xlabel(0.67 "Q1" 0.83 "Q2" 1.0 "Q3" 1.17 "Q4" 1.33 "Q5") keep(treatment) pstyle(p2) mcolor(maroon) ///
    yscale(range(-1. .4)) ylabel(-1.0(0.1).4) yline(0,lcolor(black)) vertical graphregion(fcolor(white)) ///
    note("Baseline school rank (quintiles)", size(medium) position(6)) ytitle("TE on study hours per week", size(medium))  ///
    color(maroon) ciopts(lcolor(maroon) recast(rcap)) citop  title("By school rank", size(large)) ///
    addplot(scatteri `=sim_pts[1,1]' 0.67 `=sim_pts[2,1]' 0.83 `=sim_pts[3,1]' 1.0 `=sim_pts[4,1]' 1.17 `=sim_pts[5,1]' 1.33, mcolor(black) msymbol(triangle)  ) ///
	legend(order(1 "Data" 11 "Simulations") size(medium) ring(100) position(6) row(1) ) ///
    saving("$dataTemp/TE_effort_byrank_fe_model1", replace)
	graph export "$graphs/TE_effort_byrank_fe_model1.png", replace



	
	
	
	
	
******************************************************************************************************
**# Figure 8: Simulated effects of various interventions on admissions, enrollments and persistence
******************************************************************************************************

* data prep

insheet using "$dataClean/baseline_CC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment

rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA



rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.

rename x80 m_shock 





merge m:1 mrun using "$dataClean/data_experimental.dta" 
drop if _merge==2
drop _merge




* ========================================================

* Merge in simulations that give RE and PACE to T group 

* =========================================================


preserve
* Open RE simulations and save as .dta 
insheet using "$dataClean/countREandPACE_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment

rename x6 sim_enrolled_SUA_regular_REP
rename x7 sim_enrolled_SUA_pace_REP 
gen sim_enrolled_SUA_REP = 1 if sim_enrolled_SUA_regular_REP==1 | sim_enrolled_SUA_pace_REP==1
replace sim_enrolled_SUA_REP = 0 if sim_enrolled_SUA_REP==.
rename x8 sim_persist_SUA_REP


rename x9 sim_admitted_SUA_regular_REP
rename x10 sim_admitted_SUA_pace_REP 
gen sim_admitted_REP = 1 if sim_admitted_SUA_regular_REP==1 | sim_admitted_SUA_pace_REP==1
replace sim_admitted_REP = 0 if sim_admitted_REP==.

rename x80 m_shock



save "$dataClean/countREandPACE_CC_2types.dta", replace

restore 

merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/countREandPACE_CC_2types.dta"
drop _merge 



* ===============================================================================================================

* Merge in simulations that give info on returns to effort in persistence and PACE - effpers_and_PACE 

* ===============================================================================================================

preserve

* Open RE-only simulations and save as .dta 
insheet using "$dataClean/counteffpersandPACE_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment

rename x6 sim_enrolled_SUA_regular_effpP
rename x7 sim_enrolled_SUA_pace_effpP
gen sim_enrolled_SUA_effpP = 1 if sim_enrolled_SUA_regular_effpP==1 | sim_enrolled_SUA_pace_effpP==1
replace sim_enrolled_SUA_effpP = 0 if sim_enrolled_SUA_effpP==.
rename x8 sim_persist_SUA_effpP



rename x9 sim_admitted_SUA_regular_effpP
rename x10 sim_admitted_SUA_pace_effpP 
gen sim_admitted_effpP = 1 if sim_admitted_SUA_regular_effpP==1 | sim_admitted_SUA_pace_effpP==1
replace sim_admitted_effpP = 0 if sim_admitted_effpP==.

rename x80 m_shock



save "$dataClean/counteffpersandPACE_CC_2types.dta", replace

restore


merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/counteffpersandPACE_CC_2types.dta"
drop _merge 





* Counterfactual 2 = give full RE AND PACE
gen sim_admitted_count2 = sim_admitted if treatment==0
replace sim_admitted_count2 = sim_admitted_REP if treatment==1 

gen sim_enrolled_SUA_count2 = sim_enrolled_SUA if treatment==0 
replace sim_enrolled_SUA_count2 = sim_enrolled_SUA_REP if treatment==1 

gen sim_persist_SUA_count2 = sim_persist_SUA if treatment==0
replace sim_persist_SUA_count2 = sim_persist_SUA_REP if treatment==1 




* Counterfactual 5 = give info on returns to effort in persistence, without correcting beliefs, AND PACE 

gen sim_admitted_count5 = sim_admitted if treatment==0
replace sim_admitted_count5 = sim_admitted_effpP if treatment==1 

gen sim_enrolled_SUA_count5 = sim_enrolled_SUA if treatment==0 
replace sim_enrolled_SUA_count5 = sim_enrolled_SUA_effpP if treatment==1 

gen sim_persist_SUA_count5 = sim_persist_SUA if treatment==0
replace sim_persist_SUA_count5 = sim_persist_SUA_effpP if treatment==1 




* ------------------------------------------------------------

* Generate individual level treatment effects 

* ------------------------------------------------------------


* Counterfactual 1: only give RE.
* Use control group baseline for no-intervention group
* Use control group REP for interventon group 

sort mrun m_shock 
local bases sim_admitted sim_enrolled_SUA sim_persist_SUA 

			 foreach y of local bases {
			 	
				egen hugo = mean(`y') if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen `y'_0=max(hugo)
				drop hugo
				
				egen hugo = mean(`y'_REP) if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen `y'_1=max(hugo)
				drop hugo 
				gen `y'_count1_TE=`y'_1 - `y'_0
				drop `y'_1 `y'_0
			 }
			 
	


			 
* Sort by your grouping identifiers
sort mrun m_shock


* define the base variable stems (everything before "_count")
local bases sim_admitted sim_enrolled_SUA sim_persist_SUA 

* loop over suffixes 1–5
foreach c in  2  5 {
    * loop over each base name
    foreach b of local bases {
        * construct the full varname
        local y = "`b'_count`c'"

        * compute treated and control values, difference them
		egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_1=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_0=max(hugo)
	  drop hugo
       * egen `y'_0 = mean(`y') if treatment==0, by(mrun m_shock)
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
    }
}


local bases sim_admitted sim_enrolled_SUA sim_persist_SUA 
foreach y of local bases {
			egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_1=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_0=max(hugo)
	  drop hugo
       * egen `y'_0 = mean(`y') if treatment==0, by(mrun m_shock)
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
}






rename sim_admitted_count5 sim_admitted_count3
rename sim_enrolled_SUA_count5 sim_enrolled_SUA_count3 
rename sim_persist_SUA_count5 sim_persist_SUA_count3

* Plot figure 

est clear
foreach sample in all top15baseline {

    local varlist1 sim_admitted sim_enrolled_SUA sim_persist_SUA
    local count=0

    * Get simulated treatment effects at baseline 
    foreach var of varlist `varlist1' {
        local count=`count'+1
        reg `var' treatment  if `sample'==1, ///   
        cluster(rbd_basefinal)
        lincom treatment
        local fig_b`count' = r(estimate)
    }

    * Now grab the counterfactual treatment effects
    forvalues c = 2/3 {
        local count=0
        foreach var of varlist sim_admitted sim_enrolled_SUA sim_persist_SUA {
            local count=`count'+1
            reg `var'_count`c' treatment  if `sample'==1, ///   // simce_avg_st female age alumno_prioritario neverfailed modalidad
            cluster(rbd_basefinal)
            lincom treatment
            local fig_count`c'_b`count' = r(estimate)
        }
    }

    * Create dataset for plotting
    preserve
    clear
    set obs 3

    gen fig_b = .
 
    gen fig_count2_b = .
    gen fig_count3_b = .
 
 gen fig_t = _n

    forvalues i = 1/3 {
        replace fig_b = `fig_b`i'' if _n == `i'
        replace fig_count2_b = `fig_count2_b`i'' if _n == `i'
        replace fig_count3_b = `fig_count3_b`i'' if _n == `i'

    }

    if "`sample'" == "all" {
        twoway ///
        (bar fig_b fig_t, barw(0.6) color(midblue*0.4)) || ///   
        (scatter fig_count2_b fig_t, msize(medium) mcolor(red) msymbol(diamond)) || ///
		(scatter fig_count3_b fig_t, msize(large) mcolor(black) msymbol(X))		, ///
        graphregion(fcolor(white)) yline(0, lc(gs11) lp(shortdash)) title("All", size(large)) ///
        ylab(0.0(0.02)0.08, nogrid) ytitle("Treatment effect") ///
        legend(order(1 "Baseline" 2 "P + RE" 3 "P + Correct effort returns") ///
        ring(100) position(6) cols(3) rows(2)) xtitle("") ///
        xlabel(1 "Admissions" ///
               2 `" "Enrollments" "in 1{superscript:st} year" "' ///
               3 `" "Enrollments" "in 5{superscript:th} year" "' 3.3 " ", nogrid) ///
        saving("$dataTemp/TE_over_time_enrolled_SUA_`sample'_count", replace)

        restore
    }

    if "`sample'" == "top15baseline" {
        twoway ///
        (bar fig_b fig_t, barw(0.6) color(midblue*0.4)) || /// 
        (scatter fig_count2_b fig_t, msize(medium) mcolor(red) msymbol(diamond)) || ///
		(scatter fig_count3_b fig_t, msize(large) mcolor(black) msymbol(X))		, ///
        graphregion(fcolor(white)) yline(0, lc(gs11) lp(shortdash)) title("Top 15% at baseline", size(large)) ///
        ylab(0.0(0.05)0.3, nogrid) ytitle("Treatment effect") ///
        legend(order(1 "Baseline" 2 "P + RE" 3  "P + Correct effort returns") ///
        ring(100) position(6) cols(3) rows(2)) xtitle("") ///
        xlabel(1 "Admissions" ///
               2 `" "Enrollments" "in 1{superscript:st} year" "' ///
               3 `" "Enrollments" "in 5{superscript:th} year" "' 3.3 " ", nogrid) ///
        saving("$dataTemp/TE_over_time_enrolled_SUA_`sample'_count", replace)

        restore
    }
}




* Combine the graphs for the two samples into one graph 

graph combine "$dataTemp/TE_over_time_enrolled_SUA_all_count" "$dataTemp/TE_over_time_enrolled_SUA_top15baseline_count", saving("$dataTemp/TE_over_time_enrolled_SUA_count", replace) 
graph export "$graphs/TE_over_time_enrolled_SUA_count.png", replace






	
******************************************************************************************************
**# Figure 9: College persistence and characteristics of college entrants.
******************************************************************************************************

* data prep

insheet using "$dataClean/baseline_CC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment

rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA



rename x31 sim_hours_study_latent
rename x80 m_shock 





merge m:1 mrun using "$dataClean/data_experimental.dta" 
drop if _merge==2
drop _merge




* ========================================================

* Merge in simulations that give RE and PACE to T group 

* =========================================================


preserve
* Open RE simulations and save as .dta 
insheet using "$dataClean/countREandPACE_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment

rename x6 sim_enrolled_SUA_regular_REP
rename x7 sim_enrolled_SUA_pace_REP 
gen sim_enrolled_SUA_REP = 1 if sim_enrolled_SUA_regular_REP==1 | sim_enrolled_SUA_pace_REP==1
replace sim_enrolled_SUA_REP = 0 if sim_enrolled_SUA_REP==.
rename x8 sim_persist_SUA_REP



rename x31 sim_hours_study_latent_REP
rename x80 m_shock



save "$dataClean/countREandPACE_CC_2types.dta", replace

restore 

merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/countREandPACE_CC_2types.dta"
drop _merge 



* ===============================================================================================================

* Merge in simulations that give info on returns to effort in persistence and PACE - effpers_and_PACE 

* ===============================================================================================================

preserve

* Open RE-only simulations and save as .dta 
insheet using "$dataClean/counteffpersandPACE_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment

rename x6 sim_enrolled_SUA_regular_effpP
rename x7 sim_enrolled_SUA_pace_effpP
gen sim_enrolled_SUA_effpP = 1 if sim_enrolled_SUA_regular_effpP==1 | sim_enrolled_SUA_pace_effpP==1
replace sim_enrolled_SUA_effpP = 0 if sim_enrolled_SUA_effpP==.
rename x8 sim_persist_SUA_effpP



rename x31 sim_hours_study_latent_effpP
rename x80 m_shock




save "$dataClean/counteffpersandPACE_CC_2types.dta", replace

restore


merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/counteffpersandPACE_CC_2types.dta"
drop _merge 

	 
			 
			 
sort mrun m_shock

	
	
quietly sum sim_hours_study_latent if treatment==0    , de 
global mu  = r(mean)     // store mean in a local macro
global sd  = r(sd)       // store SD   in a local macro   (sqrt of r(Var))

local vars sim_hours_study_latent sim_hours_study_latent_REP sim_hours_study_latent_effpP
foreach v of local vars {
	gen z_`v'=(`v'-$mu)/$sd
}

quietly sum simce_avg_st if treatment==0, de 
global mus = r(mean)
global sds = r(sd) 
gen z_simce_avg_st=(simce_avg_st-$mus)/$sds


****************************************************************************
* 1. Harvest the means for every (scenario × outcome) combination
****************************************************************************
tempname M
mata: st_matrix("`M'", J(4,3,.))          // 4 rows = scenarios, 3 cols = outcomes

*── Scenario 1 : C group (no intervention) ─────────────────────────────────
summ sim_persist_SUA                     if sim_enrolled_SUA==1          & treatment==0, meanonly
matrix `M'[1,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA==1          & treatment==0, meanonly
matrix `M'[1,2] = r(mean)

summ z_sim_hours_study_latent             if sim_enrolled_SUA==1          & treatment==0, meanonly
matrix `M'[1,3] = r(mean)

*── Scenario 2 : PACE ──────────────────────────────────────────────────────
summ sim_persist_SUA                     if sim_enrolled_SUA==1          & treatment==1, meanonly
matrix `M'[2,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA==1          & treatment==1, meanonly
matrix `M'[2,2] = r(mean)

summ z_sim_hours_study_latent               if sim_enrolled_SUA==1          & treatment==1, meanonly
matrix `M'[2,3] = r(mean)

*── Scenario 3 : PACE + RE ────────────────────────────────────────────────
summ sim_persist_SUA_REP                 if sim_enrolled_SUA_REP==1      & treatment==1, meanonly
matrix `M'[3,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA_REP==1      & treatment==1, meanonly
matrix `M'[3,2] = r(mean)

summ z_sim_hours_study_latent_REP         if sim_enrolled_SUA_REP==1      & treatment==1, meanonly
matrix `M'[3,3] = r(mean)



*── Scenario 4 : PACE + Value eff ─────────────────────────────────────────
summ sim_persist_SUA_effpP               if sim_enrolled_SUA_effpP==1    & treatment==1, meanonly
matrix `M'[4,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA_effpP==1    & treatment==1, meanonly
matrix `M'[4,2] = r(mean)

summ z_sim_hours_study_latent_effpP           if sim_enrolled_SUA_effpP==1    & treatment==1, meanonly
matrix `M'[4,3] = r(mean)

*── Name the columns so svmat creates correctly‑named variables ───────────
matrix colnames `M' = persist simce  study_hours  


****************************************************************************
* 2. Drop the numbers into a tidy 6-row data set
****************************************************************************
preserve 
clear
set obs 4
gen scenario = _n
label define scen 1 "C group (no intervention)" 2 "PACE" 3 "PACE + RE" ///
                    4 "PACE + Correct effort returns"
label values scenario scen

svmat double `M', names(col)              // creates: persist simce  study_hours

label variable persist     "Persistence"
label variable simce       "SIMCE score (std)"
label variable study_hours "Pre-college effort (std)"



****************************************************************************
* 3. Draw one bar-graph per outcome
****************************************************************************

local outlist persist simce study_hours 
local titles  `" "A. Persistence" "B. SIMCE score (std)" "C. Pre-college effort (std)" "' 
forvalues j = 1/3 {
    local v   : word `j' of `outlist'
    local ttl : word `j' of `titles'
	
	
	 * control-group (scenario == 1) mean of this outcome
    quietly summarize `v' if scenario == 1, meanonly
    local ctrl = r(mean)
    
    graph bar `v', over(scenario, gap(5) ///
                relabel(1 "Control" 2 "PACE" 3 "PACE + RE" 4 "PACE + Correct effort returns")  ///
				label(angle(45))) ///
        bar(1, color(midblue)) blabel((none)) ///  //bar, size(*0.8) format(%6.3f)
		yline(0, lcolor(black) lpattern(solid)) ///  
		yline(`ctrl', lcolor(black) lwidth(thin) ) ///  
        ytitle("Average") title("`ttl'", size(medsmall)) ///
        graphregion(fcolor(white)) name(g_`v', replace)

}



 graph combine g_persist g_simce  g_study_hours , cols(2) ///    
      graphregion(fcolor(white)) ///   
       saving("$dataTemp/means_all", replace)
 graph export "$graphs/college_entrants_info_count.png", replace
 
restore 






******************************************************************************************************
**# Figure 10: Simulated effects of PACE with alternative cutoffs on selective college outcomes
******************************************************************************************************

insheet using "$dataClean/baseline_CC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA

gen sim_enroll_dropout=1 if sim_enrolled_SUA ==1 & sim_persist_SUA ==0
replace sim_enroll_dropout=0 if sim_enroll_dropout==. 

rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.

rename x80 m_shock 




merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge



* ========================================================

* Merge in simulations that change the cutoffs 

* =========================================================

forvalues pc=5(5)25{
preserve
* Open RE simulations and save as .dta 
insheet using "$dataClean/countRE_top`pc'_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x6 sim_enrolled_SUA_regular_top`pc'
rename x7 sim_enrolled_SUA_pace_top`pc' 
gen sim_enrolled_SUA_top`pc' = 1 if sim_enrolled_SUA_regular_top`pc'==1 | sim_enrolled_SUA_pace_top`pc'==1
replace sim_enrolled_SUA_top`pc' = 0 if sim_enrolled_SUA_top`pc'==.
rename x8 sim_persist_SUA_top`pc'


gen sim_enroll_dropout_top`pc'=1 if sim_enrolled_SUA_top`pc' ==1 & sim_persist_SUA_top`pc' ==0
replace sim_enroll_dropout_top`pc'=0 if sim_enroll_dropout_top`pc'==. 


rename x9 sim_admitted_SUA_regular_top`pc'
rename x10 sim_admitted_SUA_pace_top`pc' 
gen sim_admitted_top`pc' = 1 if sim_admitted_SUA_regular_top`pc'==1 | sim_admitted_SUA_pace_top`pc'==1
replace sim_admitted_top`pc' = 0 if sim_admitted_top`pc'==.

rename x80 m_shock



save "$dataClean/countRE_top`pc'_CC_2types.dta", replace

restore 

merge 1:1 mrun treatment rbd_basefinal m_shock using "$dataClean/countRE_top`pc'_CC_2types.dta"
drop _merge 
}


* =================================================

* Generate individual level treatment effects

* ================================================


			 
* Sort by your grouping identifiers
sort mrun m_shock

* define the base variable stems (everything before "_count")
local bases sim_admitted_top sim_enrolled_SUA_top sim_persist_SUA_top sim_enroll_dropout_top 


			 
* loop over suffixes 1–5
foreach c in  5 10 15 20 25 {
    * loop over each base name
    foreach b of local bases {
        * construct the full varname
        local y = "`b'`c'"

        * compute treated and control values, difference them
		egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_0=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_1=max(hugo)
	  drop hugo
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
    }
}



*=====================================================================
*  BAR GRAPHS OF SIMULATED ATEs FOR FIVE CUTOFF SCENARIOS
*  ────────────────────────────────────────────────────────────────────
*  Scenarios (bars): 1 Top 5   2 Top 10   3 Top 15   4 Top 20   5 Top 25
*  Outcomes (separate graphs): 
*     A. Admitted
*     B. Enrolled & persisted
*     C. Enrolled & dropped out
*=====================================================================
collapse (mean) sim_*_top*_TE
* 0.  Define a consistent list of color shades and cut labels
local labs "Top 5" "Top 10" "Top 15" "Top 20" "Top 25"

** 1.  Label each of your TE‐vars with its "Top k" text
foreach out in admitted persist_SUA enroll_dropout {
    foreach k in 5 10 15 20 25 {
        label variable sim_`out'_top`k'_TE "Top `k'"
    }
}

* 2.  Now draw one bar‐graph per outcome
local outcomes admitted persist_SUA enroll_dropout
local ttladmitted   "A. Admitted"
local ttlpersist_SUA  "B. Enrolled & persisted" 
local ttlenroll_dropout "C. Enrolled & dropped out"
local ytitle "Average treatment effect"
local ylabeladmitted "0(0.02)0.12"
local ylabelpersist_SUA "0(0.01)0.06"
local ylabelenroll_dropout "0(0.01)0.06"
forvalues j = 1/3 {
    local out  : word `j' of `outcomes'

    quietly graph bar (mean) ///
        sim_`out'_top5_TE  ///
        sim_`out'_top10_TE ///
        sim_`out'_top15_TE ///
        sim_`out'_top20_TE ///
        sim_`out'_top25_TE,  ///          
        bar(1, fcolor(midblue) lw(none))  ///
        bar(2, fcolor(midblue*0.8) lw(none))  ///
        bar(3, fcolor(midblue*0.6) lw(none))  ///
        bar(4, fcolor(midblue*0.4) lw(none))  ///
        bar(5, fcolor(midblue*0.2) lw(none))  ///
		note("    5% 10% 15% 20% 25%", size(medsmall)) ///
        ytitle("`ytitle'") ylabel(`ylabel`out'') ///
        title("`ttl`out''")  text(2 0 "Cutoff", size(small))               ///
        legend(off)                    ///
        name(g`j', replace)

}

* 3.  Stack them 
graph combine g1 g2 g3, cols(3)
graph export "$graphs/Counterfactual_multiple_cutoffs_avg_individual_TE.png", replace

	

************************************************************************************************************************************************************
**# Figure A13: Simulated returns to effort in college admission probabilities at each effort level by treatment group, rational expectations simulations.
************************************************************************************************************************************************************

* Open RE simulations 
insheet using "$dataClean/countREandPACE_CC_2types.csv", clear


rename x3 treatment


rename x21 sim_ret_eff_pr_adm_b_0_REP
rename x22 sim_ret_eff_pr_adm_b_1_REP
rename x23 sim_ret_eff_pr_adm_b_2_REP
rename x24 sim_ret_eff_pr_adm_b_3_REP
rename x25 sim_ret_eff_pr_adm_b_4_REP
rename x26 sim_ret_eff_pr_adm_b_5_REP
rename x27 sim_ret_eff_pr_adm_b_6_REP
rename x28 sim_ret_eff_pr_adm_b_7_REP
rename x29 sim_ret_eff_pr_adm_b_8_REP
rename x30 sim_ret_eff_pr_adm_b_9_REP




forvalues i = 0/9 {
    rename sim_ret_eff_pr_adm_b_`i'_REP sim_ret_eff_pr_adm_b_`i'
}

forval y=0(1)9 {
	replace sim_ret_eff_pr_adm_b_`y'=100*sim_ret_eff_pr_adm_b_`y'
}

* Step 1: Create a long format dataset for easier plotting
gen id = _n  // Create an ID variable for reshaping
reshape long sim_ret_eff_pr_adm_b_, i(id) j(effort)

* Step 2: Compute averages by effort level and treatment group
collapse (mean) sim_ret_eff_pr_adm_b_, by(effort treatment)

* Step 3: Plot the graph
twoway ///
    (scatter sim_ret_eff_pr_adm_b_ effort if treatment==0, mcolor(blue) msymbol(circle) ) ///
	 (line sim_ret_eff_pr_adm_b_ effort if treatment==0, lcolor(blue)) ///
    (scatter sim_ret_eff_pr_adm_b_ effort if treatment==1, mcolor(red) msymbol(S)) ///
	(line sim_ret_eff_pr_adm_b_ effort if treatment==1, lcolor(red)), ///
    xlabel(0(1)9) ///
    ylabel(, angle(0)) ///
    xtitle("Effort Level (Study Hours per Week)") ///
    ytitle("Returns to Effort in Admission" "(Percentage Points)") ///
    legend(order(1 "Control" 3 "Treatment"))
	graph export "$graphs/TE_perceived_returns_effort_REC_REPT.png", replace  // RE in C group, RE + PACE in T group




********************************************************************************************
**# Figure A14: Simulated effects of various interventions, by baseline SIMCE test scores.
********************************************************************************************


* data prep

insheet using "$dataClean/baseline_CC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA

gen sim_enroll_dropout=1 if sim_enrolled_SUA ==1 & sim_persist_SUA ==0
replace sim_enroll_dropout=0 if sim_enroll_dropout==. 

rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.

rename x11 sim_sit_PSU

rename x80 m_shock 



merge m:1 mrun using "$dataClean/data_experimental.dta" 
drop if _merge==2
drop _merge




* ========================================================

* Merge in simulations that give RE and PACE to T group 

* =========================================================


preserve
* Open RE simulations and save as .dta 
insheet using "$dataClean/countREandPACE_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x5 sim_hours_study_REP
rename x6 sim_enrolled_SUA_regular_REP
rename x7 sim_enrolled_SUA_pace_REP 
gen sim_enrolled_SUA_REP = 1 if sim_enrolled_SUA_regular_REP==1 | sim_enrolled_SUA_pace_REP==1
replace sim_enrolled_SUA_REP = 0 if sim_enrolled_SUA_REP==.
rename x8 sim_persist_SUA_REP

gen sim_enroll_dropout_REP=1 if sim_enrolled_SUA_REP ==1 & sim_persist_SUA_REP ==0
replace sim_enroll_dropout_REP=0 if sim_enroll_dropout_REP==. 

rename x9 sim_admitted_SUA_regular_REP
rename x10 sim_admitted_SUA_pace_REP 
gen sim_admitted_REP = 1 if sim_admitted_SUA_regular_REP==1 | sim_admitted_SUA_pace_REP==1
replace sim_admitted_REP = 0 if sim_admitted_REP==.

rename x11 sim_sit_PSU_REP

rename x80 m_shock

save "$dataClean/countREandPACE_CC_2types.dta", replace

restore 

merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/countREandPACE_CC_2types.dta"
drop _merge 



* ===============================================================================================================

* Merge in simulations that give info on returns to effort in persistence and PACE - effpers_and_PACE 

* ===============================================================================================================

preserve

* Open RE-only simulations and save as .dta 
insheet using "$dataClean/counteffpersandPACE_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
*rename x4 sim_score_effpP
rename x5 sim_hours_study_effpP
rename x6 sim_enrolled_SUA_regular_effpP
rename x7 sim_enrolled_SUA_pace_effpP
gen sim_enrolled_SUA_effpP = 1 if sim_enrolled_SUA_regular_effpP==1 | sim_enrolled_SUA_pace_effpP==1
replace sim_enrolled_SUA_effpP = 0 if sim_enrolled_SUA_effpP==.
rename x8 sim_persist_SUA_effpP

gen sim_enroll_dropout_effpP=1 if sim_enrolled_SUA_effpP ==1 & sim_persist_SUA_effpP ==0
replace sim_enroll_dropout_effpP=0 if sim_enroll_dropout_effpP==. 

rename x9 sim_admitted_SUA_regular_effpP
rename x10 sim_admitted_SUA_pace_effpP 
gen sim_admitted_effpP = 1 if sim_admitted_SUA_regular_effpP==1 | sim_admitted_SUA_pace_effpP==1
replace sim_admitted_effpP = 0 if sim_admitted_effpP==.

rename x11 sim_sit_PSU_effpP

rename x80 m_shock



save "$dataClean/counteffpersandPACE_CC_2types.dta", replace

restore


merge 1:1 mrun rbd_basefinal m_shock treatment using "$dataClean/counteffpersandPACE_CC_2types.dta"
drop _merge 






* Get percentiles
summarize simce_avg_st, detail
global simce_p1 = r(p1)
global simce_p99 = r(p99)




* ------------------------------------------------------------

* Generate policy outcomes:
*  = baseline in C group
* = counterfactual in T group

* ------------------------------------------------------------


* Counterfactual 2 = give full RE AND PACE
gen sim_admitted_count2 = sim_admitted if treatment==0
replace sim_admitted_count2 = sim_admitted_REP if treatment==1 

gen sim_enrolled_SUA_count2 = sim_enrolled_SUA if treatment==0 
replace sim_enrolled_SUA_count2 = sim_enrolled_SUA_REP if treatment==1 

gen sim_persist_SUA_count2 = sim_persist_SUA if treatment==0
replace sim_persist_SUA_count2 = sim_persist_SUA_REP if treatment==1 

gen sim_hours_study_count2 = sim_hours_study if treatment==0
replace sim_hours_study_count2 = sim_hours_study_REP if treatment==1

gen sim_sit_PSU_count2 = sim_sit_PSU if treatment==0
replace sim_sit_PSU_count2 = sim_sit_PSU_REP if treatment==1

gen sim_enroll_dropout_count2 = sim_enroll_dropout if treatment==0
replace sim_enroll_dropout_count2 = sim_enroll_dropout_REP if treatment==1



* Counterfactual 5 = give info on returns to effort in persistence, without correcting beliefs, AND PACE 

gen sim_admitted_count5 = sim_admitted if treatment==0
replace sim_admitted_count5 = sim_admitted_effpP if treatment==1 

gen sim_enrolled_SUA_count5 = sim_enrolled_SUA if treatment==0 
replace sim_enrolled_SUA_count5 = sim_enrolled_SUA_effpP if treatment==1 

gen sim_persist_SUA_count5 = sim_persist_SUA if treatment==0
replace sim_persist_SUA_count5 = sim_persist_SUA_effpP if treatment==1 

gen sim_hours_study_count5 = sim_hours_study if treatment==0
replace sim_hours_study_count5 = sim_hours_study_effpP if treatment==1

gen sim_sit_PSU_count5 = sim_sit_PSU if treatment==0
replace sim_sit_PSU_count5 = sim_sit_PSU_effpP if treatment==1

gen sim_enroll_dropout_count5 = sim_enroll_dropout if treatment==0
replace sim_enroll_dropout_count5 = sim_enroll_dropout_effpP if treatment==1





* ------------------------------------------------------------

* Generate individual level treatment effects 

* ------------------------------------------------------------


* Counterfactual 1: only give RE.
* Use control group baseline for no-intervention group
* Use control group REP for interventon group 

sort mrun m_shock 
local bases sim_admitted sim_enrolled_SUA sim_persist_SUA  sim_enroll_dropout sim_hours_study sim_sit_PSU 

			 foreach y of local bases {
			 	
				egen hugo = mean(`y') if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen `y'_0=max(hugo)
				drop hugo
				
				egen hugo = mean(`y'_REP) if treatment==0, by(mrun m_shock) 
				bysort mrun m_shock: egen `y'_1=max(hugo)
				drop hugo 
				gen `y'_count1_TE=`y'_1 - `y'_0
				drop `y'_1 `y'_0
			 }
			 
	


			 
* Sort by your grouping identifiers
sort mrun m_shock



* define the base variable stems (everything before "_count")
local bases sim_admitted sim_enrolled_SUA sim_persist_SUA  sim_enroll_dropout sim_hours_study sim_sit_PSU 

* loop over suffixes 1–5
foreach c in  2  5 {
    * loop over each base name
    foreach b of local bases {
        * construct the full varname
        local y = "`b'_count`c'"

        * compute treated and control values, difference them
		egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_1=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_0=max(hugo)
	  drop hugo
       * egen `y'_0 = mean(`y') if treatment==0, by(mrun m_shock)
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
    }
}


			 */
local bases sim_admitted sim_enrolled_SUA sim_persist_SUA  sim_enroll_dropout sim_hours_study sim_sit_PSU 
foreach y of local bases {
			egen hugo = mean(`y') if treatment==1, by(mrun m_shock)
		bysort mrun m_shock: egen `y'_1=max(hugo)
		drop hugo 
      *  egen `y'_1 = mean(`y') if treatment==1, by(mrun m_shock)
	  egen hugo = mean(`y') if treatment==0, by(mrun m_shock)
	  bysort mrun m_shock: egen `y'_0=max(hugo)
	  drop hugo
       * egen `y'_0 = mean(`y') if treatment==0, by(mrun m_shock)
        gen `y'_TE = `y'_1 - `y'_0

        * drop the temps
        drop `y'_1 `y'_0
}




* Plots



	graph twoway ///
	( lpoly sim_hours_study_count1_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,   lcolor (cyan) )  ///
   ( lpoly sim_hours_study_count2_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (red) lpattern (shortdash) )  ///
	( lpoly sim_hours_study_count5_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (orange)   )  ///
    ( lpoly sim_hours_study_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (black) lpattern (shortdash)  ) ///
	(function y=0, range($simce_p1 $simce_p99) lcolor(black) lpattern(solid) lwidth(vthin)),  ///
    legend(order(1 "RE" 2  "P + RE" 3 "P + Correct effort returns" 4 "P") pos(6) cols(2) size(small)) ///
	xtitle("Simce test score", size(medium)) ytitle("Effect", size(small)) title("Effort", size(medium)) ///
	saving("$dataTemp/effort_effect_CC_combined", replace)
	
	graph twoway ///
	   ( lpoly sim_sit_PSU_count1_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,   lcolor (cyan)  )  ///
   ( lpoly sim_sit_PSU_count2_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,   lcolor (red) lpattern (shortdash) )  ///
	( lpoly sim_sit_PSU_count5_TE   simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (orange)) ///
	( lpoly sim_sit_PSU_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (black) lpattern (shortdash)   ) ///
	 (function y=0, range($simce_p1 $simce_p99) lcolor(black) lpattern(solid) lwidth(vthin)),  ///
    legend(order(1 "RE" 2  "P + RE" 3 "P + Correct effort returns" 4 "P") pos(6) cols(2) size(small)) ///
	xtitle("Simce test score", size(medium)) ytitle("Effect", size(small)) title("Entrance exam taking", size(medium)) ///
	saving("$dataTemp/sitPSU_effect_CC_combined", replace)
	
	graph twoway ///
	   ( lpoly sim_admitted_count1_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1, lcolor (cyan) )  ///
   ( lpoly sim_admitted_count2_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1, lcolor (red) lpattern (shortdash) )  ///
	( lpoly sim_admitted_count5_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,   lcolor (orange) )  ///
	( lpoly sim_admitted_TE   simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (black) lpattern (shortdash)   ) ///
	(function y=0, range($simce_p1 $simce_p99) lcolor(black) lpattern(solid) lwidth(vthin)),  ///
    legend(order(1 "RE" 2  "P + RE" 3  "P + Correct effort returns" 4 "P") pos(6) cols(2) size(small)) ///
	xtitle("Simce test score", size(medium)) ytitle("Effect", size(small)) title("Admissions",size(medium)) ///
	saving("$dataTemp/adm_effect_CC_combined", replace)
	
	graph twoway ///
	   ( lpoly sim_enrolled_SUA_count1_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (cyan) )  ///
   ( lpoly sim_enrolled_SUA_count2_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (red) lpattern (shortdash) )  ///
	( lpoly sim_enrolled_SUA_count5_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,   lcolor (orange)   )  ///
	( lpoly sim_enrolled_SUA_TE   simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (black)  lpattern (shortdash)  ) ///
	(function y=0, range($simce_p1 $simce_p99) lcolor(black) lpattern(solid) lwidth(vthin)),  ///
    legend(order(1 "RE" 2  "P + RE" 3  "P + Correct effort returns" 4 "P") pos(6) cols(2) size(small)) ///
	xtitle("Simce test score", size(medium)) ytitle("Effect", size(small)) title("Enrollments", size(medium)) ///
	saving("$dataTemp/enr_effect_CC_combined", replace)
	
	graph twoway ///
   ( lpoly sim_persist_SUA_count1_TE simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,  lcolor (cyan) )  ///
   ( lpoly sim_persist_SUA_count2_TE simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,  lcolor (red) lpattern (shortdash)  )  ///
	( lpoly sim_persist_SUA_count5_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,   lcolor (orange)  )  ///
	( lpoly sim_persist_SUA_TE   simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,   lcolor (black) lpattern (shortdash)   ) ///	
	(function y=0, range($simce_p1 $simce_p99) lcolor(black) lpattern(solid) lwidth(vthin)),  ///
    legend(order(1 "RE" 2  "P + RE" 3  "P + Correct effort returns" 4 "P") pos(6) cols(2) size(small)) ///
	xtitle("Simce test score", size(medium)) ytitle("Effect", size(small))  title("Persistence", size(medium))  ylab(-0.05(0.05)0.2, nogrid)  ///
	saving("$dataTemp/pers_effect_CC_combined", replace)
	
	
	
		graph twoway ///
	( lpoly sim_enroll_dropout_count1_TE simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,  lcolor (cyan) )  ///
   ( lpoly sim_enroll_dropout_count2_TE simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,  lcolor (red) lpattern (shortdash))  ///
	( lpoly sim_enroll_dropout_count5_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,   lcolor (orange)  )  ///
	( lpoly sim_enroll_dropout_TE  simce_avg_st  if simce_avg_st >= $simce_p1 & simce_avg_st <= $simce_p99 & treatment==1,    lcolor (black) lpattern (shortdash)  ) ///	
	(function y=0, range($simce_p1 $simce_p99) lcolor(black) lpattern(solid) lwidth(vthin)),  ///
    legend(order(1 "RE" 2  "P + RE" 3  "P + Correct effort returns" 4 "P") pos(6) cols(2) size(small)) ///
	xtitle("Simce test score", size(medium)) ytitle("Effect", size(small))  title("Dropouts", size(medium))  ylab(-0.05(0.05)0.2, nogrid)  ///
	saving("$dataTemp/drop_effect_CC_combined", replace)
	
	

	
		* Combine all graphs  title("Effects of various interventions by baseline test scores") 
	graph combine "$dataTemp/effort_effect_CC_combined" "$dataTemp/sitPSU_effect_CC_combined"  "$dataTemp/adm_effect_CC_combined" "$dataTemp/enr_effect_CC_combined" "$dataTemp/pers_effect_CC_combined"  "$dataTemp/drop_effect_CC_combined", row(2) ///
	saving("$dataTemp/effects_CC_combined", replace)
	graph export "$graphs/effects_info_CC_bysimce.png", replace 
	



********************************************************************************************
**# Figure A15: College persistence and characteristics of college entrants.
********************************************************************************************

insheet using "$dataClean/baseline_CC_2types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment

rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.

rename x8 sim_persist_SUA
rename x31 sim_hours_study_latent
rename x80 m_shock 



merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge


* ========================================================

* Merge in simulations that change the cutoffs 

* =========================================================

forvalues pc=5(5)25{
preserve
* Open RE simulations and save as .dta 
insheet using "$dataClean/countRE_top`pc'_CC_2types.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment

rename x6 sim_enrolled_SUA_regular_top`pc'
rename x7 sim_enrolled_SUA_pace_top`pc' 
gen sim_enrolled_SUA_top`pc' = 1 if sim_enrolled_SUA_regular_top`pc'==1 | sim_enrolled_SUA_pace_top`pc'==1
replace sim_enrolled_SUA_top`pc' = 0 if sim_enrolled_SUA_top`pc'==.

rename x8 sim_persist_SUA_top`pc'
rename x31 sim_hours_study_latent_top`pc'
rename x80 m_shock

save "$dataClean/countRE_top`pc'_CC_2types.dta", replace

restore 

merge 1:1 mrun treatment rbd_basefinal m_shock using "$dataClean/countRE_top`pc'_CC_2types.dta"
drop _merge 
}



/*
* =======================================================================================================================

*  FIGURE: BAR GRAPHS OF MEANS FOR SIX POLICY SCENARIOS
*  ──────────────────────────────────────────────────────────────────────────────────────
*  Scenarios (rows)               Outcomes (columns)
*  1  C group (no intervention)   1 Persistence (5th-year enrolment)
*  2  PACE  top 5                 2 SIMCE score (language+math std‑scores)
*  3  PACE top 10                 3 Latent study-hours per week
*  4  PACE top 15                 
*  5  PACE top 20
*  6  PACE top 25
*
*  Y-axis label on every graph:  "Mean"
* =======================================================================================================================

*/


quietly sum sim_hours_study_latent if treatment==0    , de 
global mu  = r(mean)     // store mean in a local macro
global sd  = r(sd)       // store SD   in a local macro   (sqrt of r(Var))

local vars sim_hours_study_latent_top5 sim_hours_study_latent_top10  sim_hours_study_latent_top15 sim_hours_study_latent_top20 sim_hours_study_latent_top25 
foreach v of local vars {
	gen z_`v'=(`v'-$mu)/$sd
}

quietly sum simce_avg_st if treatment==0, de 
global mus = r(mean)
global sds = r(sd) 
gen z_simce_avg_st=(simce_avg_st-$mus)/$sds

****************************************************************************
* 1. Harvest the means for every (scenario × outcome) combination
****************************************************************************
tempname M
mata: st_matrix("`M'", J(6,3,.))          // 6 rows = scenarios, 4 cols = outcomes

*── Scenario 1 : C group (no intervention) ─────────────────────────────────
summ sim_persist_SUA                     if sim_enrolled_SUA==1          & treatment==0, meanonly
matrix `M'[1,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA==1          & treatment==0, meanonly
matrix `M'[1,2] = r(mean)
summ z_sim_hours_study_latent_top15             if sim_enrolled_SUA==1          & treatment==0, meanonly
matrix `M'[1,3] = r(mean)

*── Scenario 2 : PACE top 5 ──────────────────────────────────────────────────────
summ sim_persist_SUA_top5                     if sim_enrolled_SUA_top5==1          & treatment==1, meanonly
matrix `M'[2,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA_top5==1          & treatment==1, meanonly
matrix `M'[2,2] = r(mean)
summ z_sim_hours_study_latent_top5               if sim_enrolled_SUA_top5==1          & treatment==1, meanonly
matrix `M'[2,3] = r(mean)

*── Scenario 3 : PACE top 10 ────────────────────────────────────────────────
summ sim_persist_SUA_top10                 if sim_enrolled_SUA_top10==1      & treatment==1, meanonly
matrix `M'[3,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA_top10==1      & treatment==1, meanonly
matrix `M'[3,2] = r(mean)
summ z_sim_hours_study_latent_top10         if sim_enrolled_SUA_top10==1      & treatment==1, meanonly
matrix `M'[3,3] = r(mean)

*── Scenario 4 : PACE top 15 ─────────────────────────────────────
summ sim_persist_SUA_top15                 if sim_enrolled_SUA_top15==1      & treatment==1, meanonly
matrix `M'[4,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA_top15==1      & treatment==1, meanonly
matrix `M'[4,2] = r(mean)
summ z_sim_hours_study_latent_top15         if sim_enrolled_SUA_top15==1      & treatment==1, meanonly
matrix `M'[4,3] = r(mean)

*── Scenario 5 : PACE +top 20 ─────────────────────────────────────────
summ sim_persist_SUA_top20             if sim_enrolled_SUA_top20==1  & treatment==1, meanonly
matrix `M'[5,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA_top20==1  & treatment==1, meanonly
matrix `M'[5,2] = r(mean)
summ z_sim_hours_study_latent_top20       if sim_enrolled_SUA_top20==1  & treatment==1, meanonly
matrix `M'[5,3] = r(mean)

*── Scenario 6 : PACE top 25 ─────────────────────────────────────────
summ sim_persist_SUA_top25               if sim_enrolled_SUA_top25==1    & treatment==1, meanonly
matrix `M'[6,1] = r(mean)
summ z_simce_avg_st                        if sim_enrolled_SUA_top25==1    & treatment==1, meanonly
matrix `M'[6,2] = r(mean)
summ z_sim_hours_study_latent_top25           if sim_enrolled_SUA_top25==1    & treatment==1, meanonly
matrix `M'[6,3] = r(mean)

*── Name the columns so svmat creates correctly‑named variables ───────────
matrix colnames `M' = persist simce study_hours


****************************************************************************
* 2. Drop the numbers into a tidy 6-row data set
****************************************************************************
preserve 
clear
set obs 6
gen scenario = _n
label define scen 1 "C group (no intervention)" 2 "PACE Top 5" 3 "PACE Top 10" ///
                    4 "PACE Top 15"    5 "PACE Top 20"   ///
                    6 "PACE Top 25"
label values scenario scen

svmat double `M', names(col)              // creates: persist simce high_type study_hours

label variable persist     "Persistence"
label variable simce       "SIMCE score (std)"
label variable study_hours "Pre-college effort (std)"



****************************************************************************
* 3. Draw one bar-graph per outcome
****************************************************************************
local outlist persist simce study_hours   
local titles  `" "A. Persistence" "B. SIMCE score (std)" "C. Pre-college effort (std)"   "'

forvalues j = 1/3 {
    local v   : word `j' of `outlist'
    local ttl : word `j' of `titles'
	
	
	 * control-group (scenario == 1) mean of this outcome
    quietly summarize `v' if scenario == 1, meanonly
    local ctrl = r(mean)
    
    graph bar `v', over(scenario, gap(5) ///
                relabel(1 "Control" 2 "PACE Top 5" 3 "PACE Top 10" 4 "PACE Top 15" 5 "PACE Top 20" 6 "PACE Top 25")  ///
				label(angle(45))) ///
        bar(1, color(midblue)) blabel((none)) ///  //bar, size(*0.8) format(%6.3f)
		yline(0, lcolor(black) lpattern(solid)) ///  
		yline(`ctrl', lcolor(black) lwidth(thin) ) ///  
        ytitle("Average") title("`ttl'", size(medsmall)) ///
        graphregion(fcolor(white)) name(g_`v', replace)
        
  *  graph export "$graphs/mean_`v'.png", replace
}





* If you prefer a single 2×2 panel of the four graphs, uncomment:
 graph combine g_persist g_simce  g_study_hours , cols(2) ///   
      graphregion(fcolor(white)) ///   // title("College persistence and characteristics of college entrants") 
       saving("$dataTemp/means_all", replace)
graph export "$graphs/college_entrants_multiple_cutoffs_count.png", replace
restore 






**********************************************************************************
**# Table A35: Model fit - Description of choices and outcomes. Three Types.
**********************************************************************************
insheet using "$dataClean/baseline_TC_3types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
rename x11 sim_sit_PSU
rename x12 sim_PSU_latent
gen sim_PSU_observed=sim_PSU_latent if sim_sit_PSU==1
label var sim_PSU_latent "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA
rename x14 sim_PSUb
rename x15 sim_prob_adm_pace_b
rename x16 sim_prob_adm_regular_b
rename x17 sim_GPAb
rename x18 PSUb_coeff_eff_1_data
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data
 

rename x21 sim_ret_eff_pr_adm_b_0
rename x22 sim_ret_eff_pr_adm_b_1
rename x23 sim_ret_eff_pr_adm_b_2
rename x24 sim_ret_eff_pr_adm_b_3
rename x25 sim_ret_eff_pr_adm_b_4
rename x26 sim_ret_eff_pr_adm_b_5
rename x27 sim_ret_eff_pr_adm_b_6
rename x28 sim_ret_eff_pr_adm_b_7
rename x29 sim_ret_eff_pr_adm_b_8
rename x30 sim_ret_eff_pr_adm_b_9




rename x31 sim_hours_study_latent
rename x32 sim_type
gen high_type=1 if sim_type==1
replace high_type=0 if sim_type!=1
gen medium_type=1 if sim_type==2 
replace medium_type=0 if sim_type!=2
gen low_type=1 if sim_type==3
replace low_type=0 if sim_type!=3
rename x33 sim_utility_expected // ex-post utility based on perceptions, before dropouts occur
rename x34 sim_utility_actual   // ex-post utility based on actual dropouts
rename x35 sim_top15_actual
label var sim_top15_actual  "Sim. in top 15 actual"
rename x36 sim_sel_regular
rename x37 sim_sel_pace
gen sim_sel_enrolled=sim_sel_regular if sim_enrolled_SUA_regular==1
replace sim_sel_enrolled=sim_sel_pace if sim_enrolled_SUA_pace==1
rename x38 sim_PDV_2_nosit 
rename x39 sim_PDV_2_sit
rename x40 sim_PDV_4_ER // we have this value even for those without admissions
rename x41 sim_PDV_4_EP // we have this value even for those without admissions
rename x42 sim_PDV_4_ERdropout // we have this value even for those without admissions
rename x43 sim_PDV_4_EPdropout // we have this value even for those without admissions
rename x44 sim_PDV_4_GradP // we have this value even for those without admissions
rename x45 sim_PDV_4_GradR // we have this value even for those without admissions
rename x46 sim_GPA_all
label var sim_GPA_all "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0
rename x48 sim_PDV_1_eff1
rename x49 sim_PDV_1_eff2
rename x50 sim_PDV_1_eff3
rename x51 sim_PDV_1_eff4
rename x52 sim_PDV_1_eff5
rename x53 sim_PDV_1_eff6
rename x54 sim_PDV_1_eff7
rename x55 sim_PDV_1_eff8
rename x56 sim_PDV_1_eff9
rename x57 sim_PDV_1_eff10

rename x58 sim_Ut_1_eff0
rename x59 sim_Ut_1_eff1
rename x60 sim_Ut_1_eff2
rename x61 sim_Ut_1_eff3
rename x62 sim_Ut_1_eff4
rename x63 sim_Ut_1_eff5
rename x64 sim_Ut_1_eff6
rename x65 sim_Ut_1_eff7
rename x66 sim_Ut_1_eff8
rename x67 sim_Ut_1_eff9
rename x68 sim_Ut_1_eff10

rename x69 sim_Emax_1_eff0
rename x70 sim_Emax_1_eff1
rename x71 sim_Emax_1_eff2
rename x72 sim_Emax_1_eff3
rename x73 sim_Emax_1_eff4
rename x74 sim_Emax_1_eff5
rename x75 sim_Emax_1_eff6
rename x76 sim_Emax_1_eff7
rename x77 sim_Emax_1_eff8
rename x78 sim_Emax_1_eff9
rename x79 sim_Emax_1_eff10
rename x80 m_shock 

merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110


sum sim_PDV_1_eff* 
sum sim_Ut_1_eff*
sum sim_Emax_1_eff*


* Generate simulated variables used in the analysis

* Used in description of beliefs: 
gen sim_PSU_bias=sim_PSUb-sim_PSU_observed 
label var sim_PSU_bias "Simulated believed minus actual entrance exam score \$|\$ sim. took exam (\$\sigma\$)"
gen sim_bias_own_NEM=sim_GPAb-sim_GPA 
label var sim_bias_own_NEM "Simulated believed minus actual \$12^{th}\$ grade GPA (GPA points)"
gen sim_p_admitted_above_050=1 if sim_prob_adm_regular_b>=0.5 & sim_prob_adm_regular_b!=.
replace sim_p_admitted_above_050=0 if sim_prob_adm_regular_b<0
label var sim_p_admitted_above_050 "Simulated subj prob regular admission \$\geq 0.50\$"
label var sim_prob_adm_regular_b "Simulated subjective probability of a regular admission"
label var sim_GPAb "Believed GPA"
*Top 15 cutoff used in model
gen perceived_top15_cutoff=NEM_top15_April
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
gen sim_minus_bias_top15=sim_top15_actual-perceived_top15_cutoff
label var  sim_minus_bias_top15 "Simuulated actual minus believed top \$15\%\$ cutoff in school (GPA points)"
gen sim_think_top15=1 if sim_GPAb>=perceived_top15_cutoff & sim_GPAb!=.
replace sim_think_top15=0 if sim_GPAb<perceived_top15_cutoff
label var sim_think_top15 "Simulated to believe is in top \$15\%\$ of school"

gen sim_perceived_above_cutoff=sim_GPAb-perceived_top15_cutoff
label var sim_perceived_above_cutoff "Sim. expected GPA minus expected cutoff"

gen perceived_above_cutoff=exp_NEM-perceived_top15_cutoff
label var perceived_above_cutoff "Expected GPA minus expected cutoff"

* Following variables used only to guide calibration 
gen y_data_missing=1 if score_all_st==.
replace y_data_missing=0 if score_all_st!=.

 
gen top15_actual=top15endline 
label var top15_actual "Top 15% based on all years GPA"

gen GPA_all = 0.5*GPA_avg_1_2 + 0.25 * GPA_tercero_medio +0.2*GPA_cuarto_medio 
label var GPA_all "GPA all 4 years"

est clear


label var score_all_st "Test score"
label var hours_study "Study hours/week"
label var GPA_cuarto_medio "GPA grade 12"
lab var sit_PSU "Took college entrance exam"
lab var PSU_score_if_positive_st "College entrance exam score $|$ took exam"
lab var admitted_SUA_regular_or_pace "Admitted to selective college"
label var admitted_SUA_pace "Admitted to selective college via PACE"
lab var enrolled_SUA_by_y1 "Enrolled in selective college"
gen sel_uni_major_st=( mean_PSU_score_uni_major-500)/110
lab var sel_uni_major_st "Selectivity of program (college-major pair)"
lab var enrolled_SUA_by_y5  "Enrolled and persisted in selective college, year 5"
label var GPA_all "GPA grades 9-12"
label var top15_actual "In top 15, GPA grades 9-12"

label var sim_score "Sim. Test score"
label var sim_hours_study "Sim. hours study"
label var sim_GPA "Sim. GPA grade 12"
lab var sim_sit_PSU "Took college entrance exam - simulation"
lab var sim_PSU_observed "College entrance exam score $|$ took exam - simulation"
lab var sim_admitted "Admitted to selective college - simulation"
label var sim_admitted_SUA_pace "Admitted to selective college via PACE - simulation"
lab var sim_enrolled_SUA "Enrolled in selective college - simulation"
lab var sim_sel_enrolled "Selectivity of program (college-major pair) - simulation"
lab var sim_persist_SUA  "Enrolled and persisted in selective college, year 5 - simulation"
label var sim_GPA_all "Sim. GPA grades 9-12"
label var sim_top15_actual "Sim. in top 15, GPA grades 9-12"
* List your variables and corresponding simulated variables
local variables   hours_study GPA_cuarto_medio GPA_all top15_actual sit_PSU   admitted_SUA_regular_or_pace enrolled_SUA_by_y1 sel_uni_major_st enrolled_SUA_by_y5 
local sim_variables  sim_hours_study sim_GPA sim_GPA_all sim_top15_actual  sim_sit_PSU   sim_admitted sim_enrolled_SUA sim_sel_enrolled sim_persist_SUA  

cap matrix A
cap matrix C

* Loop over each real variable and add its statistics to matrix A
local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==0, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
  *  local N: display %9.0g r(N)
    if `k'==1 {
        matrix A = (`mean', `sd')
    }
    else {
        matrix A = A \ (`mean', `sd')
    }
    local k=`k'+1
}

* Loop over each simulated variable and add its statistics to matrix C
local k=1
foreach sim_var in `sim_variables' {
	

	
	if "`sim_var'"=="sim_hours_study" {
    quietly summarize `sim_var' if treatment==0 & hours_study!=., detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
 *   local N: display %9.0g r(N)
    if `k'==1 {
        matrix C = (`mean', `sd')
    }
    else {
        matrix C = C \ (`mean', `sd')
    }				
	}
	
	else if "`sim_var'"=="sim_GPA" {
    quietly summarize `sim_var' if treatment==0 & GPA_cuarto_medio!=., detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
  *  local N: display %9.0g r(N)
    if `k'==1 {
        matrix C = (`mean', `sd')
    }
    else {
        matrix C = C \ (`mean', `sd')
    }				
	}
	
	else {
	    quietly summarize `sim_var' if treatment==0, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
   * local N: display %9.0g r(N)
    if `k'==1 {
        matrix C = (`mean', `sd')
    }
    else {
        matrix C = C \ (`mean', `sd')
    }
	}
	
    local k=`k'+1
	
}

* Label the rows and columns of the matrices A and C
matrix rownames A = `variables'
matrix colnames A = Mean SD 
matrix rownames C = `sim_variables'
matrix colnames C = Mean SD 

* Combine matrices A and C to show columns (1)-(3) for real data and columns (4)-(6) for simulated data
matrix final = A , C

* Display the table
esttab matrix(final) using "$tables/summary_stats_outcomes_3types.tex", nogap label replace fragment nomtitles nolines collabels(none) nonumbers nolines ///
prehead(`"\begin{table}[H]\centering"' ///
        `"\scriptsize"' `"\begin{threeparttable}"' ///
        `"\caption{\label{tab:descriptionoutcomes3types} \textsc{Description of Choices and Outcomes. Three types. }}"' ///
        `"\begin{tabular}{l*{1}{cc|cc}}"' `"\hline"' ///
		 `"    &        \multicolumn{2}{c}{Data} &  \multicolumn{2}{c}{Simulations} \\ "' ///
        `"    &        Mean &   St.dev. & Mean & St.dev. \\ "' ///
        `"   & (1) & (2) & (3) & (4)  \\ "' ///
        `"\multicolumn{5}{l}{\textsc{A. Control}}\\"' `"\cline{1-1}"' )

	
**  Description of choices and outcomes in the treatment group 
est clear
label var score_all_st "Test score"
label var hours_study "Study hours/week"
label var GPA_cuarto_medio "GPA grade 12"
lab var sit_PSU "Took college entrance exam"
*lab var PSU_score_if_positive_st "College entrance exam score $|$ took exam"
lab var admitted_SUA_regular_or_pace "Admitted to selective college"
lab var enrolled_SUA_by_y1 "Enrolled in selective college"
lab var sel_uni_major_st "Selectivity of program (college-major pair)"
lab var enrolled_SUA_by_y5  "Enrolled and persisted in selective college, year 5"
label var GPA_all "GPA grades 9-12"

label var sim_score "Sim. Test score"
label var sim_hours_study "Sim. hours study"
label var sim_GPA "Sim. GPA grade 12"
lab var sim_sit_PSU "Took college entrance exam - simulation"
*lab var sim_PSU_observed "College entrance exam score $|$ took exam - simulation"
lab var sim_admitted "Admitted to selective college - simulation"
lab var sim_enrolled_SUA "Enrolled in selective college - simulation"
lab var sim_sel_enrolled "Selectivity of program (college-major pair) - simulation"
lab var sim_persist_SUA  "Enrolled and persisted in selective college, year 5 - simulation"
label var sim_enrolled_SUA_pace "Sim. enrolled pace if admitted both"
label var enrolled_SUA_pace "Enrolled pace if admitted both"
label var sim_GPA_all "Sim GPA grades 9-12"
* List your variables and corresponding simulated variables
local variables hours_study GPA_cuarto_medio GPA_all top15_actual  sit_PSU   admitted_SUA_regular_or_pace admitted_SUA_pace  enrolled_SUA_by_y1 sel_uni_major_st enrolled_SUA_by_y5 enrolled_SUA_pace 
local sim_variables  sim_hours_study sim_GPA sim_GPA_all sim_top15_actual  sim_sit_PSU   sim_admitted sim_admitted_SUA_pace  sim_enrolled_SUA sim_sel_enrolled sim_persist_SUA  sim_enrolled_SUA_pace
* G H I L
cap matrix G
cap matrix I

* Loop over each real variable and add its statistics to matrix A
local k=1
foreach var in `variables' {
	
	if "`var'"== "enrolled_SUA_pace" {
	 quietly summarize `var' if treatment==1 & admitted_SUA_pace==1 & admitted_SUA_regular==1, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
   * local N: display %9.0g r(N)
    if `k'==1 {
        matrix G = (`mean', `sd')
    }
    else {
        matrix G = G \ (`mean', `sd')
    }
    local k=`k'+1	
		
	}
	else {
    quietly summarize `var' if treatment==1, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
   * local N: display %9.0g r(N)
    if `k'==1 {
        matrix G = (`mean', `sd')
    }
    else {
        matrix G = G \ (`mean', `sd')
    }
    local k=`k'+1
	}
}

* Loop over each simulated variable and add its statistics to matrix C
local k=1
foreach sim_var in `sim_variables' {
	
	if "`sim_var'"=="sim_enrolled_SUA_pace" {
    quietly summarize `sim_var' if treatment==1 & sim_admitted_SUA_pace==1 & sim_admitted_SUA_regular==1, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
  *  local N: display %9.0g r(N)
    if `k'==1 {
        matrix I = (`mean', `sd')
    }
    else {
        matrix I = I \ (`mean', `sd')
    }
	}
	
	else if "`sim_var'"=="sim_hours_study" {
    quietly summarize `sim_var' if treatment==1 & hours_study!=., detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
 *   local N: display %9.0g r(N)
    if `k'==1 {
        matrix I = (`mean', `sd')
    }
    else {
        matrix I = I \ (`mean', `sd')
    }				
	}
	
	else if "`sim_var'"=="sim_GPA" {
    quietly summarize `sim_var' if treatment==1 & GPA_cuarto_medio!=., detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
   * local N: display %9.0g r(N)
    if `k'==1 {
        matrix I = (`mean', `sd')
    }
    else {
        matrix I = I \ (`mean', `sd')
    }				
	}
	
	else {
	    quietly summarize `sim_var' if treatment==1, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
   * local N: display %9.0g r(N)
    if `k'==1 {
        matrix I = (`mean', `sd')
    }
    else {
        matrix I = I \ (`mean', `sd')
    }
	}
	
    local k=`k'+1
	
}

* Label the rows and columns of the matrices A and C
matrix rownames G = `variables'
matrix colnames G = Mean SD 
matrix rownames I = `sim_variables'
matrix colnames I = Mean SD 

* Combine matrices A Hnd C to show columns (1)-(3) for real data and columns (4)-(6) for simulated data
matrix final_treat = G , I

* Display the table
esttab matrix(final_treat) using "$tables/summary_stats_outcomes_3types.tex", nogap label append fragment nomtitles nolines collabels(none) nonumbers nolines ///
prehead(`" & & & &  \\"' `" \multicolumn{5}{l}{\textsc{B. Treatment}}\\"' `"\cline{1-1}"' )  ///
postfoot(`"\hline"' `"\end{tabular}"' `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
         `"\item	\scriptsize \textsc{ Note. --} Sample of students enrolled in control schools. Simulated test scores, hours of study and GPA in grade 12 are summarized in the sample for which the corresponding variable is nonmissing in the data. The selectivity of the program is the average entrance exam score among all regular entrants in the selective college and major the student enrolled in. A student is coded as persisting in the fifth year if he/she enrolled in the first year after high school and stayed continuously enrolled in selective college every year up until and including year $5$, or if he/she enrolled in the first year after high school and graduated from a selective college in a year prior to year $5$.  If a student transfers to a different selective college program without taking a break in their studies, they are still considered continuously enrolled in a selective college."' ///
         `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"')
 
	

**********************************************************************************
**# Table A36: Model fit - effect of PACE on pre-college outcomes. Three Types.
**********************************************************************************

insheet using "$dataClean/baseline_TC_3types_rescale.csv", clear

rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
rename x11 sim_sit_PSU
rename x12 sim_PSU_latent
gen sim_PSU_observed=sim_PSU_latent if sim_sit_PSU==1
label var sim_PSU_latent "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA
rename x14 sim_PSUb
rename x15 sim_prob_adm_pace_b
rename x16 sim_prob_adm_regular_b
rename x17 sim_GPAb
rename x18 PSUb_coeff_eff_1_data
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data


rename x21 sim_ret_eff_pr_adm_b_0
rename x22 sim_ret_eff_pr_adm_b_1
rename x23 sim_ret_eff_pr_adm_b_2
rename x24 sim_ret_eff_pr_adm_b_3
rename x25 sim_ret_eff_pr_adm_b_4
rename x26 sim_ret_eff_pr_adm_b_5
rename x27 sim_ret_eff_pr_adm_b_6
rename x28 sim_ret_eff_pr_adm_b_7
rename x29 sim_ret_eff_pr_adm_b_8
rename x30 sim_ret_eff_pr_adm_b_9




rename x31 sim_hours_study_latent
rename x32 sim_type
gen high_type=1 if sim_type==1
replace high_type=0 if sim_type!=1
gen medium_type=1 if sim_type==2 
replace medium_type=0 if sim_type!=2
gen low_type=1 if sim_type==3
replace low_type=0 if sim_type!=3
rename x33 sim_utility_expected // ex-post utility based on perceptions, before dropouts occur
rename x34 sim_utility_actual   // ex-post utility based on actual dropouts
rename x35 sim_top15_actual
label var sim_top15_actual  "Sim. in top 15 actual"
rename x36 sim_sel_regular
rename x37 sim_sel_pace
gen sim_sel_enrolled=sim_sel_regular if sim_enrolled_SUA_regular==1
replace sim_sel_enrolled=sim_sel_pace if sim_enrolled_SUA_pace==1
rename x38 sim_PDV_2_nosit 
rename x39 sim_PDV_2_sit
rename x40 sim_PDV_4_ER // we have this value even for those without admissions
rename x41 sim_PDV_4_EP // we have this value even for those without admissions
rename x42 sim_PDV_4_ERdropout // we have this value even for those without admissions
rename x43 sim_PDV_4_EPdropout // we have this value even for those without admissions
rename x44 sim_PDV_4_GradP // we have this value even for those without admissions
rename x45 sim_PDV_4_GradR // we have this value even for those without admissions
rename x46 sim_GPA_all
label var sim_GPA_all "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0
rename x48 sim_PDV_1_eff1
rename x49 sim_PDV_1_eff2
rename x50 sim_PDV_1_eff3
rename x51 sim_PDV_1_eff4
rename x52 sim_PDV_1_eff5
rename x53 sim_PDV_1_eff6
rename x54 sim_PDV_1_eff7
rename x55 sim_PDV_1_eff8
rename x56 sim_PDV_1_eff9
rename x57 sim_PDV_1_eff10

rename x58 sim_Ut_1_eff0
rename x59 sim_Ut_1_eff1
rename x60 sim_Ut_1_eff2
rename x61 sim_Ut_1_eff3
rename x62 sim_Ut_1_eff4
rename x63 sim_Ut_1_eff5
rename x64 sim_Ut_1_eff6
rename x65 sim_Ut_1_eff7
rename x66 sim_Ut_1_eff8
rename x67 sim_Ut_1_eff9
rename x68 sim_Ut_1_eff10

rename x69 sim_Emax_1_eff0
rename x70 sim_Emax_1_eff1
rename x71 sim_Emax_1_eff2
rename x72 sim_Emax_1_eff3
rename x73 sim_Emax_1_eff4
rename x74 sim_Emax_1_eff5
rename x75 sim_Emax_1_eff6
rename x76 sim_Emax_1_eff7
rename x77 sim_Emax_1_eff8
rename x78 sim_Emax_1_eff9
rename x79 sim_Emax_1_eff10
rename x80 m_shock 







merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge

label var sim_GPAb "Believed GPA"
*Top 15 cutoff used in model
gen perceived_top15_cutoff=NEM_top15_April
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
gen sim_minus_bias_top15=sim_top15_actual-perceived_top15_cutoff
label var  sim_minus_bias_top15 "Simuulated actual minus believed top \$15\%\$ cutoff in school (GPA points)"
gen sim_think_top15=1 if sim_GPAb>=perceived_top15_cutoff & sim_GPAb!=.
replace sim_think_top15=0 if sim_GPAb<perceived_top15_cutoff
label var sim_think_top15 "Simulated to believe is in top \$15\%\$ of school"

gen sim_perceived_above_cutoff=sim_GPAb-perceived_top15_cutoff
label var sim_perceived_above_cutoff "Sim. expected GPA minus expected cutoff"

gen perceived_above_cutoff=exp_NEM-perceived_top15_cutoff
label var perceived_above_cutoff "Expected GPA minus expected cutoff"
global initial_cond_controls_v1 GPA_avg_1_2 simce_avg_st Pgradb GPAb_coeff_eff PSUb_coeff_eff_1 PSUb_coeff_eff_2 PSUb_kink  cutoff_top15b modalidad // includes all model initial conditions (aside from type_prob_controls) except region, but we do not expect systematic correlation between region and other regressors 

label var sim_score  "Sim. Test Score"
label var sim_hours_study "Sim. Hours Study"
label var hours_study "Hours Study"
label var GPA_cuarto_medio "GPA Grade 12"
label var sim_GPA "Sim. GPA Grade 12"
label var treatment "Treatment"
gen cutoff_top15b=perceived_top15_cutoff
replace cutoff_top15b=actual_top15_cutoff if cutoff_top15b==. 
replace NEM_top15_April=NEM_top15 if NEM_top15_April==.
gen believed_distance_from_cutoff=abs(exp_NEM-NEM_top15_April) 
lab var believed_distance_from_cutoff "perceived dist. from cutoff"
est clear 

reg hours_study  treatment $initial_cond_controls_v1 female i.id_fieldworker  [weight=weight_mat] ,  cluster(rbd_basefinal)
su hours_study  if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m1

reg sim_hours_study  treatment $initial_cond_controls_v1 female  i.id_fieldworker  if hours_study!=.  [weight=weight_mat] ,  cluster(rbd_basefinal)
su sim_hours_study  if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m1sim

reg hours_study  treatment i.treatment##c.believed_distance_from_cutoff  c.believed_distance_from_cutoff##c.GPA_avg_1_2 c.believed_distance_from_cutoff##c.simce_avg_st c.believed_distance_from_cutoff##c.Pgradb c.believed_distance_from_cutoff##c.GPAb_coeff_eff c.believed_distance_from_cutoff##c.PSUb_coeff_eff_1 c.believed_distance_from_cutoff##c.PSUb_coeff_eff_2 c.believed_distance_from_cutoff##c.PSUb_kink  c.believed_distance_from_cutoff##c.cutoff_top15b c.believed_distance_from_cutoff##c.modalidad c.believed_distance_from_cutoff##i.female  c.believed_distance_from_cutoff##i.id_fieldworker [weight=weight_mat]    if hours_study!=. ,  cluster(rbd_basefinal)
su hours_study if e(sample)==1 
estadd scalar MEAN=`r(mean)'
est store m2

reg sim_hours_study treatment i.treatment##c.believed_distance_from_cutoff  c.believed_distance_from_cutoff##c.GPA_avg_1_2 c.believed_distance_from_cutoff##c.simce_avg_st c.believed_distance_from_cutoff##c.Pgradb c.believed_distance_from_cutoff##c.GPAb_coeff_eff c.believed_distance_from_cutoff##c.PSUb_coeff_eff_1 c.believed_distance_from_cutoff##c.PSUb_coeff_eff_2 c.believed_distance_from_cutoff##c.PSUb_kink  c.believed_distance_from_cutoff##c.cutoff_top15b c.believed_distance_from_cutoff##c.modalidad c.believed_distance_from_cutoff##i.female  c.believed_distance_from_cutoff##i.id_fieldworker [weight=weight_mat]   if hours_study!=. & believed_distance_from_cutoff!=. ,  cluster(rbd_basefinal)
su sim_hours_study if e(sample)==1 
estadd scalar MEAN=`r(mean)'
est store m2sim

reg  GPA_cuarto_medio treatment $initial_cond_controls_v1 female  if in_sample == 1  [pweight=weight_mat] , cluster(rbd_basefinal)
su GPA_cuarto_medio if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m3

reg  sim_GPA treatment $initial_cond_controls_v1 female if in_sample == 1  & GPA_cuarto_medio!=. [pweight=weight_mat] , cluster(rbd_basefinal)
su sim_GPA if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m3sim 

reg sit_PSU  treatment $initial_cond_controls_v1 female,  cluster(rbd_basefinal)
su sit_PSU  if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m4

reg sim_sit_PSU treatment $initial_cond_controls_v1 female,  cluster(rbd_basefinal)
su sim_sit_PSU  if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m4sim

esttab m1 m1sim m2 m2sim m3 m3sim m4 m4sim  using "$tables/TE_pre_college_outcomes_3types.tex", replace ///
    booktabs label unstack noobs keep(treatment 1.treatment#c.believed_distance_from_cutoff) ///
	coeflabels(treatment  "Treatment" 1.treatment#c.believed_distance_from_cutoff "Treatment $\times$ Perceived distance") ///
    cells(b(fmt(3)) se(par fmt(3) pattern(1 0 1 0 1 0 1 0))) nostar ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN, fmt(3) labels("Control mean" )) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\begin{threeparttable}  "' ///
	`"\setlength\tabcolsep{0pt} "' 	`"\setlength\extrarowheight{2pt}"' 	`"\caption{\label{TEprecollegeoutcomes3types} \textsc{Effect of PACE on Pre-College Outcomes. Three types.}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{8}{c}}"' `"\hline"' ///
		`"&   \multicolumn{2}{c}{Study hours/week} & \multicolumn{2}{c}{Study hours/week}  & \multicolumn{2}{c}{$12^{th}$ grade GPA} & \multicolumn{2}{c}{Take PSU}  \\  "' ///
		`"&  \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} &  \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} &  \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} &  \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations}  \\  "'  ///
		`"& (1)             & (2)   &  (3) & (4) & (5) & (6) & (7) & (8) \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  The coefficients are OLS estimates; standard errors clustered at the school level are reported in parentheses for the data columns. All regressions include all model initial conditions except region and survey missing. Field-worker fixed effects were used for columns (1)-(4). Inverse Probability Weights were used for columns (1)-(6). {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. {\itshape Perceived distance} is the absolute value of the difference between perceived own GPA and the perceived $85^{th}$ percentile of the GPA distribution in the school. The outcome variable in columns (1)-(4) is the number of hours of study per week. In columns (3) and (4) we add the interaction of {\itshape Perceived distance} with {\itshape Treatment} and with all the initial conditions and fieldworker fixed effects. The outcome variable in columns (5) and (6) are the GPA in grade 12, measured in GPA points (ranging from 1 to 7). The outcome variable in columns (7) and (8) is an indicator for sitting the college entrance exam.  All regressions are estimated on the sample of students for whom the outcome variable is non-missing in the data." "\end{tablenotes}" `"\end{threeparttable}  "' "\end{table}") 


**********************************************************************************
**# Table A37: Fit of auxiliary models for TE on admissions, enrollments, //
*              Persistence, three types
**********************************************************************************
insheet using "$dataClean/baseline_TC_3types_rescale.csv", clear
rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x4 sim_score
rename x5 sim_hours_study
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
rename x11 sim_sit_PSU
rename x12 sim_PSU_latent
gen sim_PSU_observed=sim_PSU_latent if sim_sit_PSU==1
label var sim_PSU_latent "Sim. PSU score latent (non-missing even if sim_sit_PSU==0)"
label var sim_PSU_observed "Sim. PSU cond on sim_sit_PSU==1"
rename x13 sim_GPA
rename x14 sim_PSUb
rename x15 sim_prob_adm_pace_b
rename x16 sim_prob_adm_regular_b
rename x17 sim_GPAb
rename x18 PSUb_coeff_eff_1_data
rename x19 PSUb_coeff_eff_2_data
rename x20 GPAb_coeff_eff_data
 
rename x21 sim_ret_eff_pr_adm_b_0
rename x22 sim_ret_eff_pr_adm_b_1
rename x23 sim_ret_eff_pr_adm_b_2
rename x24 sim_ret_eff_pr_adm_b_3
rename x25 sim_ret_eff_pr_adm_b_4
rename x26 sim_ret_eff_pr_adm_b_5
rename x27 sim_ret_eff_pr_adm_b_6
rename x28 sim_ret_eff_pr_adm_b_7
rename x29 sim_ret_eff_pr_adm_b_8
rename x30 sim_ret_eff_pr_adm_b_9
rename x31 sim_hours_study_latent
rename x32 sim_type
gen high_type=1 if sim_type==1
replace high_type=0 if sim_type!=1
gen medium_type=1 if sim_type==2 
replace medium_type=0 if sim_type!=2
gen low_type=1 if sim_type==3
replace low_type=0 if sim_type!=3
rename x33 sim_utility_expected // ex-post utility based on perceptions, before dropouts occur
rename x34 sim_utility_actual   // ex-post utility based on actual dropouts
rename x35 sim_top15_actual
label var sim_top15_actual  "Sim. in top 15 actual"
rename x36 sim_sel_regular
rename x37 sim_sel_pace
gen sim_sel_enrolled=sim_sel_regular if sim_enrolled_SUA_regular==1
replace sim_sel_enrolled=sim_sel_pace if sim_enrolled_SUA_pace==1
rename x38 sim_PDV_2_nosit 
rename x39 sim_PDV_2_sit
rename x40 sim_PDV_4_ER // we have this value even for those without admissions
rename x41 sim_PDV_4_EP // we have this value even for those without admissions
rename x42 sim_PDV_4_ERdropout // we have this value even for those without admissions
rename x43 sim_PDV_4_EPdropout // we have this value even for those without admissions
rename x44 sim_PDV_4_GradP // we have this value even for those without admissions
rename x45 sim_PDV_4_GradR // we have this value even for those without admissions
rename x46 sim_GPA_all
label var sim_GPA_all "Sim. GPA all 4 years"
rename x47 sim_PDV_1_eff0
rename x48 sim_PDV_1_eff1
rename x49 sim_PDV_1_eff2
rename x50 sim_PDV_1_eff3
rename x51 sim_PDV_1_eff4
rename x52 sim_PDV_1_eff5
rename x53 sim_PDV_1_eff6
rename x54 sim_PDV_1_eff7
rename x55 sim_PDV_1_eff8
rename x56 sim_PDV_1_eff9
rename x57 sim_PDV_1_eff10

rename x58 sim_Ut_1_eff0
rename x59 sim_Ut_1_eff1
rename x60 sim_Ut_1_eff2
rename x61 sim_Ut_1_eff3
rename x62 sim_Ut_1_eff4
rename x63 sim_Ut_1_eff5
rename x64 sim_Ut_1_eff6
rename x65 sim_Ut_1_eff7
rename x66 sim_Ut_1_eff8
rename x67 sim_Ut_1_eff9
rename x68 sim_Ut_1_eff10

rename x69 sim_Emax_1_eff0
rename x70 sim_Emax_1_eff1
rename x71 sim_Emax_1_eff2
rename x72 sim_Emax_1_eff3
rename x73 sim_Emax_1_eff4
rename x74 sim_Emax_1_eff5
rename x75 sim_Emax_1_eff6
rename x76 sim_Emax_1_eff7
rename x77 sim_Emax_1_eff8
rename x78 sim_Emax_1_eff9
rename x79 sim_Emax_1_eff10
rename x80 m_shock 



merge m:1 mrun using "$dataClean/data_experimental.dta" // if you simulate only one shock, change this to merge 1:1
drop if _merge==2
drop _merge

label var sim_GPAb "Believed GPA"
*Top 15 cutoff used in model
gen perceived_top15_cutoff=NEM_top15_April
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
gen sim_minus_bias_top15=sim_top15_actual-perceived_top15_cutoff
label var  sim_minus_bias_top15 "Simuulated actual minus believed top \$15\%\$ cutoff in school (GPA points)"
gen sim_think_top15=1 if sim_GPAb>=perceived_top15_cutoff & sim_GPAb!=.
replace sim_think_top15=0 if sim_GPAb<perceived_top15_cutoff
label var sim_think_top15 "Simulated to believe is in top \$15\%\$ of school"

gen sim_perceived_above_cutoff=sim_GPAb-perceived_top15_cutoff
label var sim_perceived_above_cutoff "Sim. expected GPA minus expected cutoff"

gen perceived_above_cutoff=exp_NEM-perceived_top15_cutoff
label var perceived_above_cutoff "Expected GPA minus expected cutoff"
global initial_cond_controls_v1 GPA_avg_1_2 simce_avg_st Pgradb GPAb_coeff_eff PSUb_coeff_eff_1 PSUb_coeff_eff_2 PSUb_kink  cutoff_top15b modalidad // includes all model initial conditions (aside from type_prob_controls) except region, but we do not expect systematic correlation between region and other regressors 

label var sim_score  "Sim. Test Score"
label var sim_hours_study "Sim. Hours Study"
label var hours_study "Hours Study"
label var GPA_cuarto_medio "GPA Grade 12"
label var sim_GPA "Sim. GPA Grade 12"
label var treatment "Treatment"
gen cutoff_top15b=perceived_top15_cutoff
replace cutoff_top15b=actual_top15_cutoff if cutoff_top15b==. 
replace NEM_top15_April=NEM_top15 if NEM_top15_April==.
gen believed_distance_from_cutoff=abs(exp_NEM-NEM_top15_April) 
lab var believed_distance_from_cutoff "perceived dist. from cutoff"
est clear 


label var treatment "Treatment"
* All sample 
* admissions (2)
est clear 
reg admitted_SUA_regular_or_pace treatment  $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su admitted_SUA_regular_or_pace  if treatment==0
estadd scalar MEAN=`r(mean)'
est store m5
reg sim_admitted treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su sim_admitted  if treatment==0
estadd scalar MEAN=`r(mean)'
est store m5_sim 

* enrollments (2)
reg enrolled_SUA_18 treatment  $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su enrolled_SUA_18   if treatment==0
estadd scalar MEAN=`r(mean)'
est store m6
reg sim_enrolled_SUA  treatment $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su sim_enrolled_SUA   if treatment==0
estadd scalar MEAN=`r(mean)'
est store m6_sim 

* persistence (2)
reg enrolled_SUA_22 treatment  $initial_cond_controls_v1 female , cluster(rbd_basefinal)
su enrolled_SUA_22   if treatment==0
estadd scalar MEAN=`r(mean)'
est store m7
reg sim_persist_SUA  treatment $initial_cond_controls_v1 female, cluster(rbd_basefinal)
su sim_persist_SUA   if treatment==0
estadd scalar MEAN=`r(mean)'
est store m7_sim 

esttab m5 m5_sim m6 m6_sim m7 m7_sim using "$tables/fit_TE_moments_adm_enr_per_3types.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    cells(b(fmt(3)) se(par fmt(3) pattern(1 0 1 0 1 0))) nostar ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN, fmt(3) labels("Control mean")) ///
    prehead(`"\begin{table}[H]\centering"' `"\footnotesize "' `"\begin{threeparttable} "' ///
	`"\setlength\tabcolsep{0pt} "' 	`"\setlength\extrarowheight{2pt}"' 	`"\caption{\label{fitTEadmenrper3types} \textsc{Fit of auxiliary models for TE on admissions, enrollments, persistence. Three types.}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{6}{c}}"' `"\hline"' ///
		`"&  \multicolumn{2}{c}{Admissions} & \multicolumn{2}{c}{Enrollments} & \multicolumn{2}{c}{Persistence}  \\  "' ///
		`" & \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} & \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} & \multicolumn{1}{c}{Data} & \multicolumn{1}{c}{Simulations} \\ "' ///
		`"& (1)             & (2)   &  (3)  & (4) & (5)  & (6) \\"' 	`"\hline"'  `" \multicolumn{7}{c}{A. All students} \\"' ) 



* Top 15% sample 
* admissions (2)
reg admitted_SUA_regular_or_pace treatment  $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su admitted_SUA_regular_or_pace  if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m8
reg sim_admitted treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su sim_admitted  if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m8_sim 

* enrollments (2)
reg enrolled_SUA_18 treatment  $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su enrolled_SUA_18   if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m9
reg sim_enrolled_SUA  treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su sim_enrolled_SUA   if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m9_sim 

* persistence (2)
reg enrolled_SUA_22 treatment  $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su enrolled_SUA_22   if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m10
reg sim_persist_SUA  treatment $initial_cond_controls_v1 female if top15baseline ==1, cluster(rbd_basefinal)
su sim_persist_SUA   if treatment==0 & top15baseline ==1
estadd scalar MEAN=`r(mean)'
est store m10_sim 


esttab m8 m8_sim m9 m9_sim m10 m10_sim using "$tables/fit_TE_moments_adm_enr_per_3types.tex", append ///
    booktabs label unstack noobs keep(treatment) ///
    cells(b(fmt(3)) se(par fmt(3) pattern(1 0 1 0 1 0))) nostar ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN, fmt(3) labels("Control mean")) ///
    prehead(`"\\"'  `"\multicolumn{7}{c}{B. Top 15 percent at baseline} \\"' ) ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--} This table shows treatment effects and control means that we aim to match in the model estimation. The coefficients are OLS estimates; standard errors clusteted at school level are reported in parentheses for the data columns. All regressions include all model initial conditions except region and survey missing. {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. The outcome variable in columns (1)-(2) and is an indicator for being admitted to a selective college via regular or preferential admissions. The outcome variable in columns (3)-(4) and is an indicator for being enrolled in a selective college one year after high school. The outcome variable in columns (5)-(6) and is an indicator for being enrolled in a selective college five years after high school. Regressions in panel A are estimated on the entire sample of students in experimental schools. Regressions in panel B are estimated on the sample of students who at the end of $10^{th}$ grade were in the top $15\%$ of their school according to GPA in the first two high school years. " "\end{tablenotes}" "\end{threeparttable}" "\end{table}") 
	
	



************************************************** 
**# Figure A16: Type distribution - three types
************************************************** 

* Panel (a)
insheet using "$dataClean/baseline_TC_2types_rescale.csv", clear
rename x32 sim_type

hist sim_type, start(0.5) w(1) color(navy) xlabel(1 "1" 2 "2" 3.5 " ") xtitle(Type of student) fraction
graph export "$graphs/type_histogram_2types.png", replace


* Panel (b)
insheet using "$dataClean/baseline_TC_3types_rescale.csv", clear

rename x32 sim_type

hist sim_type, start(0.5) w(1) color(navy) xlabel(1(1)3) xtitle(Type of student) fraction
graph export "$graphs/type_histogram_3types.png", replace



*****************************************
** # In text numbers 
*****************************************
do "$do_files/27b.In_text_numbers.do"

