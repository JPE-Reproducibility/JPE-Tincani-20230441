********************************************************************************
* DO-FILE DESCRIPTION:
* This do-file reruns the active reduced-form table and figure producers for
* the pre-submission checklist.
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

capture noisily do "code/stata/00_setup.do"
if _rc {
    do "00_setup.do"
}

discard
set scheme cleanplots

log using "$do_files/02_run_submission_tables_figures.log", text replace

timer clear 1
timer on 1
display as text "Submission tables/figures run started: `c(current_date)' `c(current_time)'"

local run_rc = 0

capture noisily do "$do_files/9.Tables.do"
local run_rc = _rc

if `run_rc' == 0 {
    capture noisily do "$do_files/10.Figures.do"
    local run_rc = _rc
}

if `run_rc' == 0 {
    capture noisily do "$do_files/11.Data_for_model_estimation_rescale.do"
    local run_rc = _rc
}

timer off 1
quietly timer list 1
local elapsed_seconds = r(t1)
local elapsed_minutes = `elapsed_seconds' / 60
local elapsed_hours = `elapsed_seconds' / 3600

display as text _newline "Submission tables/figures run finished: `c(current_date)' `c(current_time)'"
display as text "Elapsed time: " as result %12.2f `elapsed_seconds' as text " seconds (" ///
    as result %9.2f `elapsed_minutes' as text " minutes; " ///
    as result %9.2f `elapsed_hours' as text " hours)"

if `run_rc' {
    display as error "Submission tables/figures run stopped with return code r(`run_rc')."
}
else {
    display as text "Submission tables/figures run completed successfully."
}

log close

if `run_rc' {
    exit `run_rc'
}
