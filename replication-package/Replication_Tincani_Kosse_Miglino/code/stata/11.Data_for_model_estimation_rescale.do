*******************************************************************************
* DO-FILE DESCRIPTION:
* This do-file prepares the data for model estimation, read in by the Julia programs:
*              1. Dataset with initial conditions
*			   2. Vector of parameters estimated outside of the model 
* Authors: Enrico Miglino and Michela M. Tincani
* Year:    2025
********************************************************************************

*==============================================================================*

*                     CLEAN DATA FOR MODEL ESTIMATION                          *  

*==============================================================================*

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



save "$dataTemp/data_experimental_est_sample_rescale.dta", replace  // this dataset restricts the sample to the sample used to estimate the structural model 
                                                             // read in by do file 13b.
use "$dataTemp/data_experimental_est_sample_rescale.dta", clear
 
	 
 
rename admitted_SUA_regular_or_pace admitted_SUA
gen believed_distance_from_cutoff=abs(exp_NEM-perceived_top15_cutoff) 
gen TXbelieved_distance_from_cutoff=treatment*believed_distance_from_cutoff
	gen simceXbelieved_distance=simce_avg_st*believed_distance_from_cutoff
	gen femaleXbelieved_distance=female*believed_distance_from_cutoff
	gen modalidadXbelieved_distance=modalidad*believed_distance_from_cutoff
	gen alumnoXbelieved_distance=alumno_prioritario*believed_distance_from_cutoff
	gen ageXbelieved_distance=age*believed_distance_from_cutoff
	gen neverfailedXbelieved_distance=neverfailed*believed_distance_from_cutoff


keep mrun age female neverfailed alumno_prioritario ///
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
*TO HERE

sort treatment rbd_basefinal mrun

saveold "$dataClean/initial_conditions_TC_rescale.dta", replace


preserve
keep if treatment==1
saveold "$dataClean/initial_conditions_T_rescale.dta", replace
restore

preserve
keep if treatment==0
saveold "$dataClean/initial_conditions_C_rescale.dta", replace
restore


use "$dataClean/initial_conditions_C_rescale.dta", clear
drop treatment
expand 2, gen(treatment)
label var treatment "PACE"
sort treatment rbd_basefinal mrun
saveold "$dataClean/initial_conditions_CC_rescale.dta", replace

use "$dataClean/initial_conditions_T_rescale.dta", clear
drop treatment
expand 2, gen(treatment)
label var treatment "PACE"
sort treatment rbd_basefinal mrun
saveold "$dataClean/initial_conditions_TT_rescale.dta", replace




*==============================================================================*

*                     ESTIMATE PARAMETERS OUTSIDE THE MODEL                    *  

*==============================================================================*

*-------------------------------------------------------------------------------
	
*-- Save parameters' names into a vector ---------------------------------------

*-------------------------------------------------------------------------------
clear all
local names_param gammat_0 gammat_1 gammat_2 gammat_3 lambdaP_0 lambdaP_1 lambdaP_2 lambdaP_3 lambdaP_4 lambdaP_5 lambdaP_6 lambdaP_7 lambdaP_8 lambdaP_9 lambdaP_10 lambdaP_11 lambdaP_12 lambdaP_13 lambdaP_14 sigma_selP lambdaR_0 lambdaR_1 lambdaR_2 lambdaR_3 lambdaR_4 lambdaR_5 lambdaR_6 lambdaR_7 lambdaR_8 lambdaR_9 lambdaR_10 lambdaR_11 lambdaR_12 lambdaR_13 lambdaR_14 sigma_selR  betaPSUb_0 betaPSUb_3 betaPSUb_4 betaGPAb_0 betaGPAb_2 betaGPAb_3
clear 
local total_parameters=`: word count `names_param''
set obs `total_parameters'
gen param_names=""
gen param_values=.
gen param_se=.
gen num_param=_n
                    
forvalues i = 1(1)`total_parameters' {
    local param: word `i' of `names_param'
	replace param_names="`param'" if num_param==`i'
}
saveold "$dataClean/parameters_estimated_outside_rescale.dta", replace

*-------------------------------------------------------------------------------

*--  Prepare data --------------------------------------------------------------

*-------------------------------------------------------------------------------
use "$dataClean/data_experimental.dta", clear
keep if in_experimental_schools==1
merge 1:1 mrun using "$dataTemp/admitted_SUA_pace.dta" , keepusing(quality_adm_uni_major_PACE )
drop if _merge==2 // these are students who were admitted through PACE in 2018 but are not in our experimental sample
drop _merge

merge 1:1 mrun using "$dataTemp/regular_applications_uni_quality.dta" , keepusing( quality_adm_uni_major)  // The do file that generate the selectivity variables is: "generate_applic_adm_uni_selectivity.do"

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110

drop if _merge==2

* Relabel variables for Tables

label var simce_avg_st "Simce"
label var PSU_score_if_positive_st "PSU"
gen GPA_all_years=( GPA_primero_medio + GPA_segundo_medio + GPA_tercero_medio + GPA_cuarto_medio)/4
label var GPA_all_years "GPA grades 9-12"
gen GPA_all_years_sq=GPA_all_years*GPA_all_years

gen cod_reg_rbd_pred=cod_reg_rbd
replace cod_reg_rbd_pred=10 if cod_reg_rbd==9 // only 1.32% of sample is in region 9, lump together 9 and 10
label var cod_reg_rbd_pred "Region"

gen PSU_score_if_positive_st_sq=PSU_score_if_positive_st*PSU_score_if_positive_st 
gen PSU_score_if_positive_st_cube=PSU_score_if_positive_st_sq*PSU_score_if_positive_st
label var PSU_score_if_positive_st_cube "PSU $\times$ PSU $\times$ PSU"


gen simce_avg_st_sq=simce_avg_st*simce_avg_st
gen modalidadXsimce=modalidad*simce_avg_st 

gen region4=1 if cod_reg_rbd_pred==4
replace region4=0 if cod_reg_rbd_pred!=4
gen region5=1 if cod_reg_rbd_pred==5
replace region5=0 if cod_reg_rbd_pred!=5
gen region7=1 if cod_reg_rbd_pred==7
replace region7=0 if cod_reg_rbd_pred!=7
gen region8=1 if cod_reg_rbd_pred==8
replace region8=0 if cod_reg_rbd_pred!=8
gen region10=1 if cod_reg_rbd_pred==10
replace region10=0 if cod_reg_rbd_pred!=10
gen region13=1 if cod_reg_rbd_pred==13
replace region13=0 if cod_reg_rbd_pred!=13
gen region14=1 if cod_reg_rbd_pred==14
replace region14=0 if cod_reg_rbd_pred!=14
gen region15=1 if cod_reg_rbd_pred==15
replace region15=0 if cod_reg_rbd_pred!=15

gen hours_study_sq = hours_study*hours_study

*-------------------------------------------------------------------------------

*-- Regressions: Prob of a regular admission -----------------------------------
*-- gammat_0 gammat_1 gammat_2 gammat_3 ----------------------------------------

*-------------------------------------------------------------------------------

preserve 
keep if sit_PSU==1 //Change applied_SUA_regular==1 to sit_PSU==1 if we do not model application decision 
* Estimating same regression twice (for printing table and for saving parameters) as workaround to table labelling issue. Make sure you use the same specification both times.
* 1. Estimate regression for Table and print table
est clear
probit admitted_SUA_regular PSU_score_if_positive_st c.PSU_score_if_positive_st#c.PSU_score_if_positive_st c.PSU_score_if_positive_st#c.PSU_score_if_positive_st#c.PSU_score_if_positive_st , cluster(rbd_basefinal)
est store m3
esttab  m3 using "$tables/params_outside_model_regularadm.tex", replace ///  Problem: it prints the label of the outcome variable in first column
    booktabs label ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)   ///
     collabels(none) mlabels(none)  nonumbers nodepvars  ///
    stats(r2_p N, fmt(3 0) labels("Pseudo R-squared" "Observations" )) ///
    prehead(`"\begin{table}[H]\centering "' `"\setlength\extrarowheight{-3pt}"' `"\footnotesize "' `"\begin{threeparttable}"' ///
		 `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{\label{tab:outsidev2admreg} \textsc{Parameters estimated outside of the model, regular admission likelihood}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{1}{c}}"' `"\hline"' ///
		`"&   \multicolumn{1}{c}{Likelihood of Regular Admission }  \\  "' ///
		`"& (1)                                \\"' 	 ) ///
    postfoot("\hline" "\end{tabular*}" 	"\begin{tablenotes}" `"\singlespacing"' "\item" ///
             `"\setlength{\baselineskip}{0.8\baselineskip}"' `"\scriptsize"'  `"\noindent"' ///
             `"\textsc{ Note.--} The Table reports estimates from a Probit regression model. Standard errors were clustered at the school level. The estimation sample includes all entrance-exam takers in our study sample. * p$<$0.10; ** p$<$0.05; *** p$<$0.01"' "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 
	
* 2. Estimate regression for saving parameters	
probit admitted_SUA_regular PSU_score_if_positive_st PSU_score_if_positive_st_sq PSU_score_if_positive_st_cube , cluster(rbd_basefinal)
local gammat_0 _b[_cons]
local gammat_1 _b[PSU_score_if_positive_st]
local gammat_2 _b[PSU_score_if_positive_st_sq]
local gammat_3 _b[PSU_score_if_positive_st_cube]
local segammat_0 _se[_cons]
local segammat_1 _se[PSU_score_if_positive_st]
local segammat_2 _se[PSU_score_if_positive_st_sq]
local segammat_3 _se[PSU_score_if_positive_st_cube]

* 3. Graph showing fit
predict admitted_regular_pred if e(sample)==1 
graph twoway (lpoly admitted_regular_pred PSU_score_if_positive_st , lcolor(navy) lpattern(shortdash) xscale(range (-3  3)  ) ) (lpoly admitted_SUA_regular PSU_score_if_positive_st , lcolor(navy) xscale(range (-3  3)  )  ), ytitle("Likelihood of " "regular channel admission", size(medium)) xtitle("PSU score", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual"))   saving("$dataTemp/admission_PSU_regular.gph", replace )

kdensity PSU_score_if_positive_st if e(sample)==1 , lcolor(navy)  ///
graphregion(color(white)) xtitle("PSU score", size(medium)) title("Marginal distribution", size(medium)) xscale(range (-3 3))  ///
saving("$dataTemp/distribution_PSU_applicants.gph", replace)

graph combine "$dataTemp/admission_PSU_regular.gph" "$dataTemp/distribution_PSU_applicants.gph", col(1) ///
	graphregion(color(white)) ///	
	saving("$dataTemp/admission_regular_PSU_fit.gph", replace) 
	graph export "$graphs/admission_regular_PSU_fit.png" , replace
		
* 4. Save parameters	
use "$dataClean/parameters_estimated_outside_rescale.dta", clear
replace param_values=`gammat_0' if num_param==1
replace param_values=`gammat_1' if num_param==2
replace param_values=`gammat_2' if num_param==3
replace param_values=`gammat_3' if num_param==4
replace param_se=`segammat_0' if num_param==1
replace param_se=`segammat_1' if num_param==2
replace param_se=`segammat_2' if num_param==3
replace param_se=`segammat_3' if num_param==4
saveold "$dataClean/parameters_estimated_outside_rescale.dta", replace

restore 


			 
*-------------------------------------------------------------------------------	

*-- Regressions: Quality/selectivity of PACE and of regular admission ----------
*-- lambdaP_x, sigma_selP ------------------------------------------------------
*-- lambdaR_x, sigma_selR ------------------------------------------------------

*-------------------------------------------------------------------------------
	  
* Estimating same regression twice (for printing table and for saving parameters) as workaround to table labelling issue. Make sure you use the same specification both times.
* 1. Estimate regressions of selectivity PACE and regular for Table and save intermediate fit figures

est clear
reg quality_adm_uni_major_PACE GPA_all_years c.GPA_all_years#c.GPA_all_years simce_avg_st c.simce_avg_st#c.simce_avg_st i.modalidad#c.simce_avg_st  i.modalidad   i.cod_reg_rbd_pred  , cluster(rbd_basefinal)
est store m1
* Graph showing fit of selectivity PACE, intermediate
predict sel_PACE_pred if quality_adm_uni_major_PACE!=.
graph twoway (lpoly sel_PACE_pred GPA_all_years , lcolor(navy) lpattern(shortdash)) (lpoly quality_adm_uni_major_PACE GPA_all_years, lcolor(navy) ), ytitle("Selectivity of PACE admission", size(medium)) xtitle("High school GPA", size(medium)) legend(order(1 "Predicted" 2 "Actual")) title("Goodness of fit (PACE)", size(medium))  saving("$dataTemp/selectivity_adm_PACE_rescale.gph", replace )

kdensity GPA_all_years if  quality_adm_uni_major_PACE!=., lcolor(navy)  ///
graphregion(color(white)) xtitle("High school GPA", size(medium))  title("Marginal distribution", size(medium)) ///
saving("$dataTemp/distribution_GPA12.gph", replace)


reg quality_adm_uni_major PSU_score_if_positive_st c.PSU_score_if_positive_st#c.PSU_score_if_positive_st simce_avg_st c.simce_avg_st#c.simce_avg_st i.modalidad#c.simce_avg_st i.modalidad   i.cod_reg_rbd_pred   , cluster(rbd_basefinal)
est store m2
* Graph showing fit of selectivity regular, intermediate
predict sel_regular_pred if quality_adm_uni_major!=.
graph twoway (lpoly sel_regular_pred PSU_score_if_positive_st , lcolor(navy) lpattern(shortdash)) (lpoly quality_adm_uni_major PSU_score_if_positive_st, lcolor(navy) ), ytitle("Selectivity of regular admission", size(medium)) xtitle("PSU score", size(medium)) title("Goodness of fit (Regular)", size(medium)) legend(order(1 "Predicted" 2 "Actual")) saving("$dataTemp/selectivity_adm_regular_rescale.gph", replace )

kdensity PSU_score_if_positive_st if quality_adm_uni_major!=., lcolor(navy)  ///
graphregion(color(white)) xtitle("PSU score", size(medium)) title("Marginal distribution", size(medium)) ///
saving("$dataTemp/distribution_PSU.gph", replace)


* Print Table with estimates related to admission selectivity PACE and regular
esttab m1 m2 using "$tables/params_outside_model_rescale.tex", replace ///
    booktabs label  ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) /// *drop(*.cod_reg_rbd_pred) 
     collabels(none) mlabels(none)  nonumbers nobase /// *nolines nomtitles nodep noomitted ///
    stats(r2  N, fmt(3  0) labels("R-squared" "Observations" )) ///
    prehead(`"\begin{table}[H]\centering"'  `"\setlength\extrarowheight{-3pt}"'  `"\footnotesize "'  ///
	`"\begin{threeparttable}"' ///
	 `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{\label{tab:outsidev2sel} \textsc{Parameters estimated outside of the model, program selectivity}}"' ///
     `"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\hline"' `"\\"' ///
		`"&  \multicolumn{1}{c}{Selectivity PACE} & \multicolumn{1}{c}{Selectivity Regular}   \\  "' ///
		`"& (1)                                   &           (2)                             \\"' ) ///
    postfoot("\hline" "\end{tabular*}" `"\begin{tablenotes}"' `"\singlespacing"' `"\item"' ///
             `"\setlength{\baselineskip}{0.8\baselineskip}"' `"\scriptsize"' `"\noindent"' ///
             `"\textsc{ Note.--} The Table reports OLS estimates. Standard errors were clustered at the school level. Selectivity is measured as the average PSU score among all regular entrants into the degree program, defined as a selective college and major pair. The reference categories are the vocational track and the third region. The region refers to the location of the high school. The ninth and nearby tenth regions are lumped together, since only 1.32\% of the sample went to school in the ninth region, and none of these students was admitted to college through PACE. The samples are: all those admitted through the PACE channel in column (1), all those admitted through the regular channel in column (2). * p$<$0.10; ** p$<$0.05; *** p$<$0.01"' "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 			 

* 2. Graph showing fit of selectivity regular and PACE
graph combine "$dataTemp/selectivity_adm_PACE_rescale.gph" "$dataTemp/distribution_GPA12.gph"   "$dataTemp/selectivity_adm_regular_rescale.gph" "$dataTemp/distribution_PSU.gph", colfirst ///
graphregion(color(white)) ///	
saving("$dataTemp/admission_quality_fit_rescale.gph", replace) 
graph export "$graphs/admission_quality_fit_rescale.png" , replace

* 3. Re-estimate regressions for saving parameters. Ensure it is the same specification as in point 1.
* Selecrivity PACE
est clear
reg quality_adm_uni_major_PACE GPA_all_years GPA_all_years_sq simce_avg_st simce_avg_st_sq modalidadXsimce  modalidad region4 region5 region7 region8 region10 region13 region14 region15  , cluster(rbd_basefinal)			 
local lambdaP_0 _b[_cons]
local lambdaP_1 _b[GPA_all_years]
local lambdaP_2 _b[GPA_all_years_sq]
local lambdaP_3 _b[simce_avg_st]
local lambdaP_4 _b[simce_avg_st_sq]
local lambdaP_5 _b[modalidadXsimce]
local lambdaP_6 _b[modalidad]
local lambdaP_7 _b[region4]
local lambdaP_8 _b[region5]
local lambdaP_9 _b[region7]
local lambdaP_10 _b[region8]
local lambdaP_11 _b[region10]
local lambdaP_12 _b[region13]
local lambdaP_13 _b[region14]
local lambdaP_14 _b[region15]

local selambdaP_0 _se[_cons]
local selambdaP_1 _se[GPA_all_years]
local selambdaP_2 _se[GPA_all_years_sq]
local selambdaP_3 _se[simce_avg_st]
local selambdaP_4 _se[simce_avg_st_sq]
local selambdaP_5 _se[modalidadXsimce]
local selambdaP_6 _se[modalidad]
local selambdaP_7 _se[region4]
local selambdaP_8 _se[region5]
local selambdaP_9 _se[region7]
local selambdaP_10 _se[region8]
local selambdaP_11 _se[region10]
local selambdaP_12 _se[region13]
local selambdaP_13 _se[region14]
local selambdaP_14 _se[region15]

predict shock_selP, residuals
su shock_selP, d
local sigma_selP `r(sd)'

* Save parameters
preserve 
use "$dataClean/parameters_estimated_outside_rescale.dta", clear
replace param_values=`lambdaP_0' if num_param==5
replace param_values=`lambdaP_1' if num_param==6
replace param_values=`lambdaP_2' if num_param==7
replace param_values=`lambdaP_3' if num_param==8
replace param_values=`lambdaP_4' if num_param==9
replace param_values=`lambdaP_5' if num_param==10
replace param_values=`lambdaP_6' if num_param==11
replace param_values=`lambdaP_7' if num_param==12
replace param_values=`lambdaP_8' if num_param==13
replace param_values=`lambdaP_9' if num_param==14
replace param_values=`lambdaP_10' if num_param==15
replace param_values=`lambdaP_11' if num_param==16
replace param_values=`lambdaP_12' if num_param==17
replace param_values=`lambdaP_13' if num_param==18
replace param_values=`lambdaP_14' if num_param==19
replace param_values=`sigma_selP' if num_param==20
replace param_se=`selambdaP_0' if num_param==5
replace param_se=`selambdaP_1' if num_param==6
replace param_se=`selambdaP_2' if num_param==7
replace param_se=`selambdaP_3' if num_param==8
replace param_se=`selambdaP_4' if num_param==9
replace param_se=`selambdaP_5' if num_param==10
replace param_se=`selambdaP_6' if num_param==11
replace param_se=`selambdaP_7' if num_param==12
replace param_se=`selambdaP_8' if num_param==13
replace param_se=`selambdaP_9' if num_param==14
replace param_se=`selambdaP_10' if num_param==15
replace param_se=`selambdaP_11' if num_param==16
replace param_se=`selambdaP_12' if num_param==17
replace param_se=`selambdaP_13' if num_param==18
replace param_se=`selambdaP_14' if num_param==19

saveold "$dataClean/parameters_estimated_outside_rescale.dta", replace
restore

* Selectivity regular 
est clear
*gen PSU_score_if_positive_st_sq=PSU_score_if_positive_st*PSU_score_if_positive_st
reg quality_adm_uni_major PSU_score_if_positive_st PSU_score_if_positive_st_sq simce_avg_st simce_avg_st_sq modalidadXsimce modalidad region4 region5 region7 region8 region10 region13 region14 region15  , cluster(rbd_basefinal)
local lambdaR_0 _b[_cons]
local lambdaR_1 _b[PSU_score_if_positive_st]
local lambdaR_2 _b[PSU_score_if_positive_st_sq]
local lambdaR_3 _b[simce_avg_st]
local lambdaR_4 _b[simce_avg_st_sq]
local lambdaR_5 _b[modalidadXsimce]
local lambdaR_6 _b[modalidad]
local lambdaR_7 _b[region4]
local lambdaR_8 _b[region5]
local lambdaR_9 _b[region7]
local lambdaR_10 _b[region8]
local lambdaR_11 _b[region10]
local lambdaR_12 _b[region13]
local lambdaR_13 _b[region14]
local lambdaR_14 _b[region15]

local selambdaR_0 _se[_cons]
local selambdaR_1 _se[PSU_score_if_positive_st]
local selambdaR_2 _se[PSU_score_if_positive_st_sq]
local selambdaR_3 _se[simce_avg_st]
local selambdaR_4 _se[simce_avg_st_sq]
local selambdaR_5 _se[modalidadXsimce]
local selambdaR_6 _se[modalidad]
local selambdaR_7 _se[region4]
local selambdaR_8 _se[region5]
local selambdaR_9 _se[region7]
local selambdaR_10 _se[region8]
local selambdaR_11 _se[region10]
local selambdaR_12 _se[region13]
local selambdaR_13 _se[region14]
local selambdaR_14 _se[region15]

predict shock_selR, residuals
su shock_selR, d
local sigma_selR `r(sd)'

* Save parameters
preserve 
use "$dataClean/parameters_estimated_outside_rescale.dta", clear
replace param_values=`lambdaR_0' if num_param==21
replace param_values=`lambdaR_1' if num_param==22
replace param_values=`lambdaR_2' if num_param==23
replace param_values=`lambdaR_3' if num_param==24
replace param_values=`lambdaR_4' if num_param==25
replace param_values=`lambdaR_5' if num_param==26
replace param_values=`lambdaR_6' if num_param==27
replace param_values=`lambdaR_7' if num_param==28
replace param_values=`lambdaR_8' if num_param==29
replace param_values=`lambdaR_9' if num_param==30
replace param_values=`lambdaR_10' if num_param==31
replace param_values=`lambdaR_11' if num_param==32
replace param_values=`lambdaR_12' if num_param==33
replace param_values=`lambdaR_13' if num_param==34
replace param_values=`lambdaR_14' if num_param==35

replace param_values=`sigma_selR' if num_param==36

replace param_se=`selambdaR_0' if num_param==21
replace param_se=`selambdaR_1' if num_param==22
replace param_se=`selambdaR_2' if num_param==23
replace param_se=`selambdaR_3' if num_param==24
replace param_se=`selambdaR_4' if num_param==25
replace param_se=`selambdaR_5' if num_param==26
replace param_se=`selambdaR_6' if num_param==27
replace param_se=`selambdaR_7' if num_param==28
replace param_se=`selambdaR_8' if num_param==29
replace param_se=`selambdaR_9' if num_param==30
replace param_se=`selambdaR_10' if num_param==31
replace param_se=`selambdaR_11' if num_param==32
replace param_se=`selambdaR_12' if num_param==33
replace param_se=`selambdaR_13' if num_param==34
replace param_se=`selambdaR_14' if num_param==35

saveold "$dataClean/parameters_estimated_outside_rescale.dta", replace
restore 

* ----------------------------------------------------------------------------------------------------------------------
* GPAb and PSUb believed production functions // betaPSUb_0 betaPSUb_3 betaPSUb_4 betaGPAb_0 betaGPAb_1 betaGPAb_2
* ----------------------------------------------------------------------------------------------------------------------
est clear 
* 1. Estimate regressions for Table 

label var GPA_segundo "GPA in grade 10"
label var GPA_avg_1_2 "GPA in grades 9-10"
label var simce_avg_st "Simce test score in grade 10"


* Generate outcome variables: expected score (GPA, PSU) net of perceived effort impacts
gen GPAb_34=2*(exp_NEM-0.5*GPA_avg_1_2)  // We assume exp_NEM captures the expected GPA in the last 4 high school years 
										  // GPAb_34 is the believed score in years 3 and 4 of high school, from the poingt of view of
										  // the start of year 3, when GPA_1_2 is known 
gen res_GPAb= GPAb_34 - GPAb_coeff_eff *hours_study 
gen res_PSUb=expPSUscore_st- PSUb_coeff_eff_2*hours_study  if exp_PSUscore>=450 & exp_PSUscore!=.
replace res_PSUb=expPSUscore_st- PSUb_coeff_eff_1*hours_study  if exp_PSUscore<450 & exp_PSUscore!=.


label var res_PSUb "Perceived PSU"
label var  res_GPAb "Perceived GPA"


* PSUb
reg res_PSUb  GPA_avg_1_2 simce_avg_st  
est store m1
predict pred_res_PSUb if e(sample)==1 
gen pred_PSUb=pred_res_PSUb + PSUb_coeff_eff_1*hours_study  if exp_PSUscore<450 & exp_PSUscore!=.
replace pred_PSUb=pred_res_PSUb + PSUb_coeff_eff_2*hours_study  if exp_PSUscore>=450 & exp_PSUscore!=.


* GPAb
reg res_GPAb  GPA_avg_1_2 simce_avg_st   , cluster(rbd_basefinal)
est store m2
predict pred_res_GPAb if e(sample)==1 
gen pred_GPAb = pred_res_GPAb + GPAb_coeff_eff * hours_study 






* Print Table with estimates related to PSUb and GPAb
esttab m1 m2 using "$tables/params_outside_model_PSUbGPAb.tex", replace ///
    booktabs label  ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) /// 
     collabels(none) mlabels(none)  nonumbers nobase /// * nomtitles nodep noomitted /// 
    stats( N, fmt(0) labels( "Observations" )) /// * do not show R2 because we do not care of R2 of perceived achievemends net of effort
    prehead(`"\begin{table}[H]\centering"'  `"\setlength\extrarowheight{-3pt}"'  `"\footnotesize "'  ///
	`"\begin{threeparttable}"' ///
	 `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{\label{tab:outsidePSUbGPAb} \textsc{Parameters estimated outside of the model, perceived PSU and GPA production}}"' ///
     `"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\hline"' `"\\"' ///
		`"&  \multicolumn{1}{c}{\$PSU^{b,net}\$} & \multicolumn{1}{c}{\$GPA^{b,net}\$}   \\  "' ///
		`"& (1)                                   &           (2)                             \\"' ) ///
    postfoot("\hline" "\end{tabular*}" `"\begin{tablenotes}"' `"\singlespacing"' `"\item"' ///
             `"\setlength{\baselineskip}{0.8\baselineskip}"' `"\scriptsize"' `"\noindent"' ///
             `"\textsc{ Note.--} The Table reports OLS estimates of equations \eqref{eq:PSUboutside} and \eqref{eq:GPAboutside}. Standard errors were clustered at the school level. The outcome variables are perceived achievement outcomes, net of the measured perceived impact of effort.  * p$<$0.10; ** p$<$0.05; *** p$<$0.01"' "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 			 

*Perceived GPA is a linear function of effort; the perceived PSU score is a piecewise linear function with one kink, as in equations \eqref{eq:GPAb} and \eqref{eq:PSUb}. Effort levels and the marginal returns to effort are elicited from the survey. The outcome variable in column (1) is the perceived GPA in the last two years of high school net of perceived effort impacts. The survey elicited the perceived GPA for all four years of high school. To construct the perceived GPA for the final two years, we first define the perceived GPA for the years 9 and 10 as the actual average GPA in years 9 and 10, which students had already observed at the time of the survey. The perceived GPA for the last two years is then inferred based on the reported expected four-year average and the perceived GPA for years 9 and 10. The outcome variable in column (2) is the expected PSU score elicited in the survey net of perceived effort impacts.



* 2. Create and save graph with fit 


 	graph twoway (lpoly pred_GPAb GPA_avg_1_2  , lcolor(navy) lpattern(shortdash)) (lpoly GPAb_34 GPA_avg_1_2 , lcolor(navy) ) ///
	(kdensity GPA_avg_1_2 , lcolor(gray) lpattern(dash) yaxis(2)), ///
	ytitle("Perceived GPA at chosen effort", size(medium)) ytitle("Baseline GPA density", axis(2) size(medium)) ///
	xtitle("Baseline GPA", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density"))  saving("$dataTemp/GPAb_belief_GoF_nolasso_GPAseg.gph", replace )
	
	 	graph twoway (lpoly pred_GPAb simce_avg_st , lcolor(navy) lpattern(shortdash)) (lpoly GPAb_34 simce_avg_st, lcolor(navy) ) ///
		(kdensity simce_avg_st, lcolor(gray) lpattern(dash) yaxis(2)), ///
		 ytitle("Perceived GPA at chosen effort", size(medium)) ytitle("Simce density", axis(2) size(medium)) ///
		 xtitle("Simce", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density" ))  saving("$dataTemp/GPAb_belief_GoF_nolasso.gph", replace )
		
		graph twoway ///
		(lpoly pred_PSUb simce_avg_st , lcolor(navy) lpattern(shortdash)) ///
		(lpoly expPSUscore_st simce_avg_st, lcolor(navy) ) ///
		(kdensity simce_avg_st, lcolor(gray) lpattern(dash) yaxis(2)), ///
		ytitle("Perceived PSU at chosen effort", size(medium)) ytitle("Simce density", axis(2) size(medium)) ///
		xtitle("Simce", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density"))  saving("$dataTemp/PSUb_belief_GoF_nolasso.gph", replace )
			
		graph twoway (lpoly pred_PSUb GPA_avg_1_2  , lcolor(navy) lpattern(shortdash)) (lpoly expPSUscore_st GPA_avg_1_2 , lcolor(navy) ) ///
		(kdensity GPA_avg_1_2 , lcolor(gray) lpattern(dash) yaxis(2)), ///
		ytitle("Perceived PSU at chosen effort", size(medium))  ytitle("Baseline GPA density", axis(2) size(medium)) ///
		xtitle("Baseline GPA", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density" ))  saving("$dataTemp/PSUb_belief_GoF_nolasso_GPAseg.gph", replace )	
		
			graph combine "$dataTemp/PSUb_belief_GoF_nolasso.gph" "$dataTemp/GPAb_belief_GoF_nolasso.gph" "$dataTemp/PSUb_belief_GoF_nolasso_GPAseg.gph" "$dataTemp/GPAb_belief_GoF_nolasso_GPAseg.gph", saving("$dataTemp/PSUbGPAb_belief_GoF_nolasso.gph", replace)
graph export "$graphs/PSUbGPAb_belief_GoF_nolasso.png", replace 


* 3.  Re-estimate regressions for saving parameters. Ensure it is the same specification as in point 1.



* PSUb 

reg res_PSUb simce_avg_st GPA_avg_1_2  , cluster(rbd_basefinal)
local betaPSUb_0 _b[_cons]
local betaPSUb_3 _b[GPA_avg_1_2]
local betaPSUb_4 _b[simce_avg_st]

local sebetaPSUb_0 _se[_cons]
local sebetaPSUb_3 _se[GPA_avg_1_2]
local sebetaPSUb_4 _se[simce_avg_st]

preserve 
* Save parameters
use "$dataClean/parameters_estimated_outside_rescale.dta", clear

replace param_values=`betaPSUb_0' if num_param==37
replace param_values=`betaPSUb_3' if num_param==38
replace param_values=`betaPSUb_4' if num_param==39

replace param_se=`sebetaPSUb_0' if num_param==37
replace param_se=`sebetaPSUb_4' if num_param==38
replace param_se=`sebetaPSUb_4' if num_param==39

saveold "$dataClean/parameters_estimated_outside_rescale.dta", replace

restore 

* GPAb
est clear 
reg res_GPAb GPA_avg_1_2  simce_avg_st   , cluster(rbd_basefinal)
local betaGPAb_0 _b[_cons]
local betaGPAb_1 _b[GPA_avg_1_2]
local betaGPAb_2 _b[simce_avg_st]

local sebetaGPAb_0 _se[_cons]
local sebetaGPAb_1 _se[GPA_avg_1_2]
local sebetaGPAb_2 _se[simce_avg_st]


 

* Save parameters
use "$dataClean/parameters_estimated_outside_rescale.dta", clear



replace param_values=`betaGPAb_0' if num_param==40
replace param_values=`betaGPAb_1' if num_param==41
replace param_values=`betaGPAb_2' if num_param==42

replace param_se=`sebetaGPAb_0' if num_param==40
replace param_se=`sebetaGPAb_1' if num_param==41
replace param_se=`sebetaGPAb_2' if num_param==42



keep param_names param_values param_se 
foreach var in param_values param_se  {
	replace `var'=round(`var',0.001)
}
saveold "$dataClean/parameters_estimated_outside_rescale.dta", replace



********************************************************************************
**# Calculate residualized objective probability of being in top c %
********************************************************************************
* Reference-machine EBIC lambdas (for full replicability)
local lebic_25 = 20.1175830772592299
local lebic_20 = 35.9235609087178176
local lebic_15 = 20.3395057117779388
local lebic_10 = 14.4835203709222000
local lebic_5  = 18.9270529639457905


forvalues p=75(5)95 {
clear all
local c=100-`p'


use "$dataTemp/data_experimental_est_sample_rescale.dta", clear
keep if in_experimental_schools==1
local initial_condition mrun age female neverfailed alumno_prioritario ///
simce_avg_st rbd_basefinal class_code treatment modalidad GPA_segundo_medio GPA_avg_school_1_2

foreach var in `initial_condition' {
di "`var'"
drop if `var'==.
}




* Outcome variable: being in the top X% according to GPA in all 4 high school years  
forvalues pc=70(5)95 {
   gen over_pc_`pc'=1 if allyears_GPA_rank>=0.`pc' & allyears_GPA_rank!=.
   replace over_pc_`pc'=0 if allyears_GPA_rank<0.`pc' & allyears_GPA_rank!=.
}

*** Generate regressors that are potentially relevant to predict prob. of being in the top `c' percent
forvalues pc=10(5)95 {
    gen over_pc_`pc'_segundo=1 if ranking_school_GPA_segundo_medio>=0.`pc' & ranking_school_GPA_segundo_medio!=.
    replace over_pc_`pc'_segundo=0 if ranking_school_GPA_segundo_medio<0.`pc' & ranking_school_GPA_segundo_medio!=.
}
	gen cutoff_segundo_temp=GPA_segundo_medio if ranking_school_GPA_segundo_medio>=0.`p' 
    bys rbd_basefinal: egen cutoff_segundo=min(cutoff_segundo_temp)
	
    gen cutoff_avg_1_2_temp=GPA_avg_1_2 if ranking_school_GPA_avg_1_2>=0.`p' 
    bys rbd_basefinal: egen cutoff_avg_1_2=min(cutoff_avg_1_2_temp)

forvalues pc=10(5)95 {
    gen over_pc_`pc'_avg_1_2=1 if ranking_school_GPA_avg_1_2>=0.`pc' & ranking_school_GPA_avg_1_2!=.
    replace over_pc_`pc'_avg_1_2=0 if ranking_school_GPA_avg_1_2<0.`pc' & ranking_school_GPA_avg_1_2!=.
}

bys rbd_basefinal: egen GPA_sd_school_1_2=sd(GPA_avg_1_2)
bys rbd_basefinal: egen GPA_sd_school_2=sd(GPA_segundo_medio)
bys rbd_basefinal: egen frac_academic_school=mean(modalidad)

gen simce_avg_st_sq=simce_avg_st*simce_avg_st
gen simce_avg_st_cu=simce_avg_st*simce_avg_st_sq

gen GPA_segundo_medio_sq=GPA_segundo_medio*GPA_segundo_medio
gen GPA_segundo_medio_cu=GPA_segundo_medio*GPA_segundo_medio_sq
gen GPA_avg_1_2_sq=GPA_avg_1_2*GPA_avg_1_2
gen GPA_avg_1_2_cu=GPA_avg_1_2*GPA_avg_1_2_sq
gen ranking_school_GPA_segundo_2=ranking_school_GPA_segundo_medio*ranking_school_GPA_segundo_medio


*** Select the most predictive regressors using Lasso regression
est clear
sort mrun
set seed 10
lasso2 over_pc_`p' GPA_all_years over_pc_*_segundo over_pc_*_avg_1_2 ///
       GPA_segundo_medio GPA_segundo_medio_sq GPA_segundo_medio_cu GPA_avg_1_2 ///
       GPA_avg_1_2_sq GPA_avg_1_2_cu modalidad ///
       GPA_avg_school_1_2 GPA_sd_school_1_2 GPA_sd_school_2 ///
       female age neverfailed simce_avg_st simce_avg_st_sq ///
       alumno_prioritario tot_size_school frac_academic_school ///
       cutoff_segundo cutoff_avg_1_2, long

local lam = `lebic_`c''

* Replay the same lasso path using the frozen reference-machine lambda.
lasso2, newlambda(`lam') ols

di e(betaOLS)[1,1]
gen coeff_GPA_all_years = e(betaOLS)[1,1]
replace GPA_all_years = 0
predict x_val0, xb ols


*** Save relevant variables 
keep treatment rbd_basefinal mrun x_val0 coeff_GPA_all_years
sort treatment rbd_basefinal mrun x_val0 coeff_GPA_all_years
saveold "$dataClean/variables_prob_top_`c'_TC.dta", replace
 


*==============================================================================*

*                     CLEAN DATA FOR MODEL ESTIMATION                          *  
*                     GENERATE INITIAL CONDITIONS FOR RE COMBINING 
*                     GENERAL INITIAL CONDITIONS WITH VARIABLES FOR PREDICTION
*                     PF PROB `c' IN T
*==============================================================================*
use  "$dataClean/initial_conditions_TC_rescale.dta", replace

merge 1:1 mrun using "$dataClean/variables_prob_top_`c'_TC.dta", nogen

sort treatment rbd_basefinal mrun
save "$dataClean/initial_conditions_TC_rescale_RE_top_`c'.dta", replace 


preserve
keep if treatment==1
sort treatment rbd_basefinal mrun
saveold "$dataTemp/initial_conditions_T_rescale_RE_top_`c'.dta", replace
restore

preserve
keep if treatment==0
sort treatment rbd_basefinal mrun
saveold "$dataTemp/initial_conditions_C_rescale_RE_top_`c'.dta", replace
restore


use "$dataTemp/initial_conditions_C_rescale_RE_top_`c'.dta", clear
drop treatment
expand 2, gen(treatment)
label var treatment "PACE"
sort treatment rbd_basefinal mrun
saveold "$dataClean/initial_conditions_CC_rescale_RE_top_`c'.dta", replace

use "$dataTemp/initial_conditions_T_rescale_RE_top_`c'.dta", clear
drop treatment
expand 2, gen(treatment)
label var treatment "PACE"
sort treatment rbd_basefinal mrun
saveold "$dataClean/initial_conditions_TT_rescale_RE_top_`c'.dta", replace




}
