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

	
* For exact reproducibility, this script uses frozen local copies stored inside the project.



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
	
********************************************************************************
**#	4) Dofile execution
********************************************************************************

*Clean dataset on high-school GPA 
do "$do_files/1.Clean_GPA.do"

*Clean dataset on high-school baseline ability 
do "$do_files/2.Clean_simce.do" 

*Clean dataset of high-school teachers 
do "$do_files/3.Clean_docentes.do"

*Clean dataset of high-school principals
do "$do_files/4.Clean_jefes.do"

*Clean dataset on applications, PSU, admission and selectivity
do "$do_files/5.Generate_applic_admi_uni_selectivity.do" 

*Merge all high-school datasets, clean April survey data and create probability weights 
 do "$do_files/6.Merge_basefinal.do" // This do-file automatically runs the do-files "6a.April_cleaning.do" and "6b.Create_inverse_prob_weights.do"

*Clean the merged high-school data and generate high-school variables
do "$do_files/7.Clean_basefinal.do"

*Clean dataset on academic outcomes
do "$do_files/8.Clean_academic_data.do" // This do-file can automatically run the do-file "8.Geolocalize.do", but as a key licence is required, we provide saved geolocalization outputs. 

*Produce all reduced-form tables that are shown in the paper
do "$do_files/9.Tables.do" // This do-file automatically runs the do-file "9.fdr_sharpened_qvalues_adj.do"

*Produce all reduced-form figures that are shown in the paper
do "$do_files/10.Figures.do"

*Generata data for model estimations and estimate model parameters outside the model
do "$do_files/11.Data_for_model_estimation_rescale.do"

*Generata empirical moments and coefficients to be matched in model estimation
do "$do_files/12.Empirical_coefficients_rescale.do"

*Generate bootstrap samples
do "$do_files/13.Create_bootstrap.do"




/*
********************************************************************************
**#	5) Erase temporary datasets to save space
********************************************************************************
cd "$data/Raw/Temp"
local dta : dir . files "*.dta"
foreach fn of local dta {
    erase "$data/Raw/Temp/`fn'" 
}
*/
