********************************************************************************
* DO-FILE DESCRIPTION:
* This wrapper runs the final Stata output stage after the Julia scripts 20-26.
* It sets package-relative paths once, then runs do-files 27 and 27b in order.
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

capture noisily do "code/stata/00.setup.do"
if _rc {
    do "00.setup.do"
}

discard
which lasso2
which lassoutils
which rwolf2
set scheme cleanplots

local do27_calls_27b 0
tempname fh
file open `fh' using "$do_files/27.Tables_Figures_model_numbers.do", read text
file read `fh' line
while r(eof) == 0 {
    if strpos(`"`macval(line)'"', "27b.In_text_numbers.do") ///
        & !inlist(substr(strtrim(`"`macval(line)'"'), 1, 1), "*", "/") {
        local do27_calls_27b 1
    }
    file read `fh' line
}
file close `fh'

do "$do_files/27.Tables_Figures_model_numbers.do"

if `do27_calls_27b' == 0 {
    do "$do_files/27b.In_text_numbers.do"
}
else {
    display as text "27b.In_text_numbers.do was already called by 27.Tables_Figures_model_numbers.do."
}
