********************************************************************************
* DO-FILE DESCRIPTION:
* Clean data on high-school principals
********************************************************************************

use "$dataRaw/Teachers_and_principals/Jefes UTP 23-11_rp.dta", clear
rename Q55_1_0 rbd
keep ResponseId rbd

merge 1:1 ResponseId using "$dataRaw/Teachers_and_principals/Cuestionario+-+Jefe_December+18%252C+2017_13.56_rp.dta"

drop if Q55_1_0 == "1234" | Q55_1_0 == "654" | Q55_1_0 == "7789" | Q55_1_0 == " "
replace rbd = 10645 if Q55_1_0 == "10645-3"
replace rbd = 6753 if Q55_1_0 == "6753-9"
replace rbd = 7049 if Q55_1_0 == "7049"
drop _merge

merge m:1 rbd using "$dataRaw/List_experimental_high_schools/experimental_school_list.dta"
drop if _merge == 2
replace treatment = 1 if _merge == 1
drop _merge

gen stay_same_class = 1 if Q6 == 1 | Q8 == 1
replace stay_same_class = 0 if Q6 == 2 | Q8 == 2
lab var stay_same_class "Obligation to stay in the same class until leave school or change of modalidad"

gen assignclass_byskill = 1 if Q10 == 1
replace assignclass_byskill = 0 if Q10 == 2
lab var assignclass_byskill "Assign students to classes according to their ability"

replace Q11_1 = 1 if Q11_4_TEXT == "es al azar" | Q11_4_TEXT == "aleatoria"
gen assignclass_random = 0 if (Q11_1 != . | Q11_2 != . | Q11_3 != . | Q11_4 != .)
replace assignclass_random = 1 if Q11_1 == 1
lab var assignclass_random "Assign students to classes randomly"

gen assignclass_alphabet = 0 if (Q11_1 != . | Q11_2 != . | Q11_3 != . | Q11_4 != .)
replace assignclass_alphabet = 1 if Q11_2 == 1
lab var assignclass_alphabet "Assign students to classes in alphabetical order"

gen teachers_meet = 1 if Q14 == 1
replace teachers_meet = 0 if Q14 == 2
lab var teachers_meet "Teachers meet at the end of year to discuss grades of each student"

gen teachers_adjust = 1 if Q15 == 1
replace teachers_adjust = 0 if Q15 == 2
lab var teachers_adjust "Teachers adjust grades based on motivation, effort and other reasons"

gen remedial_classes = 1 if Q16 == 1
replace remedial_classes = 0 if Q16 == 2
lab var remedial_classes "Presence of remedial classes to cuarto medio students"

gen freq_remedial = 0.5 if Q19 == 1
replace freq_remedial = 1.5 if Q19 == 2
replace freq_remedial = 3 if Q19 == 3
lab var freq_remedial "Number of times per week in which there are remedial classes"

gen class_for_PSU = 1 if Q20 == 1
replace class_for_PSU = 0 if Q20 == 2
lab var class_for_PSU "School offers classes to prepare for the PSU"

gen n_months_PACE_class_orient_stud = -Q30 + 22
gen hours_month = 0.5 if Q31 == 1
replace hours_month = 1 if Q31 == 2
replace hours_month = Q31 - 1 if Q31 >= 3 & Q31 <= 6
replace hours_month = 8 if Q31 == 7
replace Q31 = 12 if Q31 == 8

gen tot_hrs_PACE_class_unilife = n_months_PACE_class_orient_stud * hours_month
replace tot_hrs_PACE_class_unilife = 0 if treatment == 0
lab var tot_hrs_PACE_class_unilife "Tot hours of PACE instruction on uni life"

gen treatment_above57_PACE_unilife = 1 if treatment == 1 & tot_hrs_PACE_class_unilife >= 57 & tot_hrs_PACE_class_unilife != .
replace treatment_above57_PACE_unilife = 0 if treatment == 0
lab var treatment_above57_PACE_unilife "=1 if PACE AND at least 57 hours of uni life instruction"

gen treatment_below18_PACE_unilife = 1 if treatment == 1 & tot_hrs_PACE_class_unilife <= 18 & tot_hrs_PACE_class_unilife != .
replace treatment_below18_PACE_unilife = 0 if treatment == 0
lab var treatment_below18_PACE_unilife "=1 if PACE AND at most 18 hours of uni life instruction"

gen treatment_18_36_PACE_unilife = 1 if treatment == 1 & tot_hrs_PACE_class_unilife > 18 & tot_hrs_PACE_class_unilife <= 36 & tot_hrs_PACE_class_unilife != .
replace treatment_18_36_PACE_unilife = 0 if treatment == 0
lab var treatment_18_36_PACE_unilife "=1 if PACE AND between 18 and 36 hours of uni life instruction"

gen treatment_36_48_PACE_unilife = 1 if treatment == 1 & tot_hrs_PACE_class_unilife > 36 & tot_hrs_PACE_class_unilife <= 48 & tot_hrs_PACE_class_unilife != .
replace treatment_36_48_PACE_unilife = 0 if treatment == 0
lab var treatment_36_48_PACE_unilife "=1 if PACE AND between 36 and 48 hours of uni life instruction"

gen treatment_above_48_PACE_unilife = 1 if treatment == 1 & tot_hrs_PACE_class_unilife > 48 & tot_hrs_PACE_class_unilife != .
replace treatment_above_48_PACE_unilife = 0 if treatment == 0
lab var treatment_above_48_PACE_unilife "=1 if PACE AND above 48 hours of uni life instruction"

gen treatment_above_80_PACE_unilife = 1 if treatment == 1 & tot_hrs_PACE_class_unilife > 80 & tot_hrs_PACE_class_unilife != .
replace treatment_above_80_PACE_unilife = 0 if treatment == 0
lab var treatment_above_80_PACE_unilife "=1 if PACE AND above 80 hours of uni life instruction"

drop hours_month n_months_PACE_class_orient_stud
drop if rbd == .

gen long source_order = _n
sort rbd source_order
by rbd: keep if _n == 1

rename rbd rbd_basefinal
keep rbd_basefinal treatment stay_same_class assignclass_byskill assignclass_random ///
    assignclass_alphabet teachers_meet teachers_adjust remedial_classes ///
    freq_remedial class_for_PSU tot_hrs_PACE_class_unilife ///
    treatment_above57_PACE_unilife treatment_below18_PACE_unilife ///
    treatment_18_36_PACE_unilife treatment_36_48_PACE_unilife ///
    treatment_above_48_PACE_unilife treatment_above_80_PACE_unilife

saveold "$dataTemp/jefes_clean.dta", replace
