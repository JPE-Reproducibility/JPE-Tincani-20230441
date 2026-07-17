********************************************************************************
* DO-FILE DESCRIPTION:
* This do-file defines the globals and calculates the bias w.r.t. the RE cutoff
********************************************************************************
/*------------------------------------------------------------------------------
	1) Install programs
	2) Main setup
	3) Define globals
	4) Execution
	5) Erase intermediary datasets if any
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
	
	
********************************************************************************
**# Calculate bias with respect to RE cutoff
********************************************************************************
import delimited "$dataClean/countRE_CC_cutoffs.csv", clear
merge m:1 mrun using "$dataClean/data_experimental.dta", keep(master match)
gen perceived_top15_cutoff=NEM_top15_April
replace perceived_top15_cutoff=NEM_top15 if NEM_top15_April==.
replace perceived_top15_cutoff=actual_top15_cutoff if perceived_top15_cutoff==. // For those with missing belief, we assume they correctly predict cutoff
gen double biasREcutoff=perceived_top15_cutoff-cutoff
lab var biasREcutoff "Expected cutoff - RE cutoff"
keep mrun treated biasREcutoff shock
reshape wide biasREcutoff, i(mrun treated) j(shock)
keep mrun treated biasREcutoff*
rename treated treatment
save "$dataClean/bias_RE_CC_cutoff.dta", replace

forvalues p=75(5)95 {
   local c=100-`p'
   use "$dataClean/initial_conditions_CC_rescale_RE_top_`c'.dta", clear
   merge 1:1 mrun treatment using "$dataClean/bias_RE_CC_cutoff.dta", nogen
   sort treatment rbd_basefinal mrun
   save "$dataClean/initial_conditions_CC_rescale_RE_with_bias_top_`c'.dta", replace
}
