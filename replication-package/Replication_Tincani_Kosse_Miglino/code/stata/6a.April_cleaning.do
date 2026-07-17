********************************************************************************
* DO-FILE DESCRIPTION:
* This do-file cleans the April survey data
********************************************************************************

use "$dataTemp/april_rawdata.dta", clear

 

*generate expected top 15 NEM cutoff in April
gen NEM_top15_April=A3
lab var NEM_top15_April "Expected NEM of the student in the 15th percentile (expected in April)"
 

*elicited means of earnings with and without going to university
gen expearn_nouni=100000 if A8==1
replace expearn_nouni=300000 if A8==2
replace expearn_nouni=500000 if A8==3
replace expearn_nouni=700000 if A8==4
replace expearn_nouni=900000 if A8==5
replace expearn_nouni=1100000 if A8==6
replace expearn_nouni=. if A8==8
replace expearn_nouni=expearn_nouni/1000000
gen expearn_uni=100000 if A11==1
replace expearn_uni=300000 if A11==2
replace expearn_uni=500000 if A11==3
replace expearn_uni=700000 if A11==4
replace expearn_uni=900000 if A11==5
replace expearn_uni=1100000 if A11==6
replace expearn_uni=expearn_uni/1000000

*Count missing values in questions on expected earnings in FOCUS 
count if P35!=. & P36!=. & expearn_nouni!=.
count if P35!=. & P36==. & expearn_nouni!=.
count if P36!=. & P35==. & expearn_nouni!=.
count if P37!=. & P38!=. & expearn_uni!=.
count if P37!=. & P38==. & expearn_uni!=.
count if P38!=. & P37==. & expearn_uni!=.

*Count irrational students (those who gave a higher probability to receiving earnings above a higher threshold)
gen incoherent_answers_no_uni=0
gen incoherent_answers_uni=0
replace incoherent_answers_no_uni=. if P35==. & P36==.  /*Send to missing those guys for which we have no answers in August*/
replace incoherent_answers_no_uni=. if (P35==. | P36==.) & A8==.  /*Send to missing those guys for which we have one answer in August and missing mean*/
replace incoherent_answers_no_uni=. if P35==P36 & A8==.  /*Send to missing those guys for which we have same answers in August and missing mean */
replace incoherent_answers_uni=. if P37==. | P38==.   /*Send to missing those guys for which we have no answers in August*/
replace incoherent_answers_uni=. if (P37==. | P38==.) & A11==.  /*Send to missing those guys for which we have one answer in August and missing mean*/
replace incoherent_answers_uni=. if P37==P38 & A11==.  /*Send to missing those guys for which we have same answers in August and missing mean */

replace incoherent_answers_no_uni=1 if P36>P35 & P35!=. & P36!=.
replace incoherent_answers_uni=1 if P38>P37 & P37!=. & P38!=.

*Count irrational students (those who in April have expected earning in a range that is below the threshold above which they are certain to be in August, or viceversa).
replace incoherent_answers_no_uni=1 if P36==5 & (A8==1 | A8==2 | A8==3 | A8==4) 
replace incoherent_answers_no_uni=1 if P35==1 & (A8==3 | A8==4 | A8==5 | A8==6) 
replace incoherent_answers_uni=1 if P38==5 & (A11==1 | A11==2 | A11==3 | A11==4 | A11==5) 
replace incoherent_answers_uni=1 if P37==1 & (A11==3 | A11==4 | A11==5 | A11==6)  

gen nouni200=0.001 if P35==1
replace nouni200=0.25 if P35==2
replace nouni200=0.50 if P35==3
replace nouni200=0.75 if P35==4
replace nouni200=0.999 if P35==5

gen nouni800=0.001 if P36==1
replace nouni800=0.25 if P36==2
replace nouni800=0.50 if P36==3
replace nouni800=0.75 if P36==4
replace nouni800=0.999 if P36==5

gen uni300=0.001 if P37==1
replace uni300=0.25 if P37==2
replace uni300=0.50 if P37==3
replace uni300=0.75 if P37==4
replace uni300=0.999 if P37==5

gen uni1000=0.001 if P38==1
replace uni1000=0.25 if P38==2
replace uni1000=0.50 if P38==3
replace uni1000=0.75 if P38==4
replace uni1000=0.999 if P38==5


*If you give same answers in August, we set them at lower and upper bounds of the interval
replace nouni200=0.125 if P35==1 & P36==1
replace nouni800=0.001 if P35==1 & P36==1
replace nouni200=0.375 if P35==2 & P36==2
replace nouni800=0.125 if P35==2 & P36==2
replace nouni200=0.625 if P35==3 & P36==3
replace nouni800=0.375 if P35==3 & P36==3
replace nouni200=0.875 if P35==4 & P36==4
replace nouni800=0.625 if P35==4 & P36==4
replace nouni200=0.999 if P35==5 & P36==5
replace nouni800=0.875 if P35==5 & P36==5

replace uni300=0.125 if P37==1 & P38==1
replace uni1000=0.001 if P37==1 & P38==1
replace uni300=0.375 if P37==2 & P38==2
replace uni1000=0.125 if P37==2 & P38==2
replace uni300=0.625 if P37==3 & P38==3
replace uni1000=0.375 if P37==3 & P38==3
replace uni300=0.875 if P37==4 & P38==4
replace uni1000=0.625 if P37==4 & P38==4
replace uni300=0.999 if P37==5 & P38==5
replace uni1000=0.875 if P37==5 & P38==5

 

preserve
keep mrun NEM_top15_April in_April_sample 
saveold "$dataTemp/april_other_variables.dta", replace
restore 

preserve
drop if incoherent_answers_no_uni==1
gen nouni200_hat=0
gen nouni800_hat=0
gen exp_var_nouni=0
gen sum_squares_nouni=0
gen expearn_nouni_est=0
order mrun nouni200 nouni800 nouni200_hat nouni800_hat expearn_nouni expearn_nouni_est exp_var_nouni sum_squares_nouni
sort mrun
keep mrun nouni200 nouni800 nouni200_hat nouni800_hat expearn_nouni expearn_nouni_est exp_var_nouni sum_squares_nouni
saveold "$dataTemp/expected_earnings_nouni.dta", replace
restore
preserve
drop if incoherent_answers_uni==1
gen uni300_hat=0
gen uni1000_hat=0
gen exp_var_uni=0
gen sum_squares_uni=0
gen expearn_uni_est=0
order mrun uni300 uni1000 uni300_hat uni1000_hat expearn_uni expearn_uni_est exp_var_uni sum_squares_uni
sort mrun
keep mrun uni300 uni1000 uni300_hat uni1000_hat expearn_uni expearn_uni_est exp_var_uni sum_squares_uni
saveold "$dataTemp/expected_earnings_uni.dta", replace
restore


 
import delimited "$dataRaw/April_survey/data_expvar_nouni_nm.csv", clear
rename v1 mrun
rename v2 nouni200
rename v3 nouni800
rename v4 nouni200_hat
rename v5 nouni800_hat
rename v6 expearn_nouni
rename v7 expearn_nouni_est
rename v8 exp_var_nouni
rename v9 sum_squares_nouni
gen nouni_nm=1
lab var nouni_nm "No missing answers to no-uni expected earnings"
saveold "$dataTemp/data_expvar_nouni_nm.dta", replace

import delimited "$dataRaw/April_survey/data_expvar_uni_nm.csv", clear
rename v1 mrun
rename v2 uni300
rename v3 uni1000
rename v4 uni300_hat
rename v5 uni1000_hat
rename v6 expearn_uni
rename v7 expearn_uni_est
rename v8 exp_var_uni
rename v9 sum_squares_uni
gen uni_nm=1
lab var uni_nm "No missing answers to uni expected earnings"
saveold "$dataTemp/data_expvar_uni_nm.dta", replace

import delimited "$dataRaw/April_survey/data_expvar_nouni_m800.csv", clear
rename v1 mrun
rename v2 nouni200
rename v3 nouni200_hat
rename v4 expearn_nouni
rename v5 expearn_nouni_est
rename v6 exp_var_nouni
rename v7 sum_squares_nouni
gen nouni_m800=1
lab var nouni_m800 "Missing answers to P>800 no-uni expected earnings"
saveold "$dataTemp/data_expvar_nouni_m800.dta", replace

import delimited "$dataRaw/April_survey/data_expvar_nouni_m200.csv", clear
rename v1 mrun
rename v2 nouni800
rename v3 nouni800_hat
rename v4 expearn_nouni
rename v5 expearn_nouni_est
rename v6 exp_var_nouni
rename v7 sum_squares_nouni
gen nouni_m200=1
lab var nouni_m200 "Missing answers to P>200 no-uni expected earnings"
saveold "$dataTemp/data_expvar_nouni_m200.dta", replace

import delimited "$dataRaw/April_survey/data_expvar_uni_m1000.csv", clear
rename v1 mrun
rename v2 uni300
rename v3 uni300_hat
rename v4 expearn_uni
rename v5 expearn_uni_est
rename v6 exp_var_uni
rename v7 sum_squares_uni
gen uni_m1000=1
lab var uni_m1000 "Missing answers to P>1000 uni expected earnings"
saveold "$dataTemp/data_expvar_uni_m1000.dta", replace

import delimited "$dataRaw/April_survey/data_expvar_uni_m300.csv", clear
rename v1 mrun
rename v2 uni1000
rename v3 uni1000_hat
rename v4 expearn_uni
rename v5 expearn_uni_est
rename v6 exp_var_uni
rename v7 sum_squares_uni
gen uni_m300=1
lab var uni_m300 "Missing answers to P>300 uni expected earnings"
saveold "$dataTemp/data_expvar_uni_m300.dta", replace

import delimited "$dataRaw/April_survey/data_expvar_nouni_mMean.csv", clear
rename v1 mrun
rename v2 nouni200
rename v3 nouni800
rename v4 nouni200_hat
rename v5 nouni800_hat
rename v6 expearn_nouni_est
rename v7 exp_var_nouni
rename v8 sum_squares_nouni
gen nouni_mMean=1
lab var nouni_mMean "Missing answer to no-uni expected earnings"
saveold "$dataTemp/data_expvar_nouni_mMean.dta", replace

import delimited "$dataRaw/April_survey/data_expvar_uni_mMean.csv", clear
rename v1 mrun
rename v2 uni300
rename v3 uni1000
rename v4 uni300_hat
rename v5 uni1000_hat
rename v6 expearn_uni_est
rename v7 exp_var_uni
rename v8 sum_squares_uni
gen uni_mMean=1
lab var uni_mMean "Missing answers to uni expected earnings"
saveold "$dataTemp/data_expvar_uni_mMean.dta", replace

use "$dataTemp/data_expvar_nouni_nm.dta", clear
append using "$dataTemp/data_expvar_nouni_m800.dta"
append using "$dataTemp/data_expvar_nouni_m200.dta"
append using "$dataTemp/data_expvar_nouni_mMean.dta"
saveold "$dataTemp/expvar_earnings_clean_nouni.dta", replace


use "$dataTemp/data_expvar_uni_nm.dta", clear
append using "$dataTemp/data_expvar_uni_m300.dta"
append using "$dataTemp/data_expvar_uni_m1000.dta"
append using "$dataTemp/data_expvar_uni_mMean.dta"
saveold "$dataTemp/expvar_earnings_clean_uni.dta", replace

merge 1:1 mrun using "$dataTemp/expvar_earnings_clean_nouni.dta", nogen

*generate university income premium variables
gen exp_premium_uni=expearn_uni-expearn_nouni
gen exp_premium_uni_est=expearn_uni_est-expearn_nouni_est

merge 1:1 mrun using "$dataTemp/april_other_variables.dta", nogen
count if exp_var_nouni!=.
count if expearn_nouni_est!=.
count if exp_var_uni!=.
count if expearn_uni_est!=.

saveold "$dataTemp/april_cleandata.dta", replace

capture erase "$dataTemp/data_expvar_uni_nm.dta"
capture erase "$dataTemp/data_expvar_nouni_nm.dta"
capture erase "$dataTemp/data_expvar_nouni_m800.dta"
capture erase "$dataTemp/data_expvar_nouni_m200.dta"
capture erase "$dataTemp/data_expvar_uni_m300.dta"
capture erase "$dataTemp/data_expvar_uni_m1000.dta"
capture erase "$dataTemp/data_expvar_nouni_mMean.dta"
capture erase "$dataTemp/data_expvar_uni_mMean.dta"
capture erase "$dataTemp/expvar_earnings_clean_nouni.dta"
capture erase "$dataTemp/expvar_earnings_clean_uni.dta"
capture erase "$dataTemp/april_other_variables.dta"
