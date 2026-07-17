********************************************************************************
* DO-FILE DESCRIPTION:
* This do-file reruns the active data construction pipeline through
* data_experimental.dta.
********************************************************************************

version 18
clear all
clear matrix
clear mata
clear results
set more off
set maxvar 20000
capture log close
capture log close data_construction_log
set seed 10005
set sortseed 1989856
set processors 1



********************************************************************************
**#	3) Define globals
********************************************************************************

capture noisily do "code/stata/00_setup.do"
if _rc {
    do "00_setup.do"
}

log using "$do_files/01_run_1_8_data_construction.log", text replace name(data_construction_log)

	

	discard

	which lasso2
	which lassoutils
	which rwolf2

	set scheme cleanplots

********************************************************************************
**#	4) Dofile execution
********************************************************************************

timer clear 1
timer on 1
display as text "Data construction run started: `c(current_date)' `c(current_time)'"

local run_rc = 0

*Clean dataset on high-school GPA
capture noisily do "$do_files/1.Clean_GPA.do"
local run_rc = _rc

*Clean dataset on high-school baseline ability
if `run_rc' == 0 {
	capture noisily do "$do_files/2.Clean_simce.do"
	local run_rc = _rc
}

*Clean dataset of high-school teachers
if `run_rc' == 0 {
	capture noisily do "$do_files/3.Clean_docentes.do"
	local run_rc = _rc
}

*Clean dataset of high-school principals
if `run_rc' == 0 {
	capture noisily do "$do_files/4.Clean_jefes.do"
	local run_rc = _rc
}

*Clean dataset on applications, PSU, admission and selectivity
if `run_rc' == 0 {
	capture noisily do "$do_files/5.Generate_applic_admi_uni_selectivity.do"
	local run_rc = _rc
}

*Merge all high-school datasets, clean April survey data and create probability weights
if `run_rc' == 0 {
	capture noisily do "$do_files/6.Merge_basefinal.do"
	local run_rc = _rc
}

*Clean the merged high-school data and generate high-school variables
if `run_rc' == 0 {
	capture noisily do "$do_files/7.Clean_basefinal.do"
	local run_rc = _rc
}

*Clean dataset on academic outcomes
if `run_rc' == 0 {
	capture noisily do "$do_files/8.Clean_academic_data.do"
	local run_rc = _rc
}

timer off 1
quietly timer list 1
local elapsed_seconds = r(t1)
local elapsed_minutes = `elapsed_seconds' / 60
local elapsed_hours = `elapsed_seconds' / 3600

display as text _newline "Data construction run finished: `c(current_date)' `c(current_time)'"
display as text "Elapsed time: " as result %12.2f `elapsed_seconds' as text " seconds (" ///
    as result %9.2f `elapsed_minutes' as text " minutes; " ///
    as result %9.2f `elapsed_hours' as text " hours)"

if `run_rc' {
    display as error "Data construction run stopped with return code r(`run_rc')."
}
else {
    display as text "Data construction run completed successfully."
}

log close data_construction_log

if `run_rc' {
    exit `run_rc'
}
