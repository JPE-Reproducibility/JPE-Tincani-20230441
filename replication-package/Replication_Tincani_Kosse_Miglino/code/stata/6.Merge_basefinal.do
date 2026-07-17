********************************************************************************
* DO-FILE DESCRIPTION:
* This do-file merges all high-school datasets
********************************************************************************

***Generate matricula 2016 dataset
import delimited "$dataRawPublic/High_school_registration/20160926_Matricula_unica_2016_20160430_PUBL.CSV", clear
saveold "$dataTemp/matricula_unica_2016.dta", replace

***Add variable for school in 2017 to check movement across schools 
import delimited "$dataRawPublic/High_school_registration/20170921_Matricula_unica_2017_20170430_PUBL.CSV", clear 
append using "$dataRaw/High_school_registration/four_cases_missing_in_final_mat2017.dta"
gen rbd_matricula2017=rbd
keep mrun rbd_matricula2017 
saveold "$dataTemp/matricula_unica_2017.dta", replace
use "$dataTemp/matricula_unica_2016.dta", clear
merge 1:1 mrun using "$dataTemp/matricula_unica_2017.dta", nogen 
saveold "$dataTemp/matricula_unica_2016_tercero_medio_rbd2017.dta", replace

***Clean FOCUS dataset from duplicate 
use "$dataRaw/August_survey/basefinal_rp.dta", clear
drop if mrun==. /*9 people do not have the mrun*/
duplicates tag mrun, gen(num_duplicates) 
*2 folio have the same name of the person and same mrun. Impossible to say who they are, so we drop these 2 observations.  
drop if num_duplicates>0 
gen rbd_FOCUS2017=rbd
drop rbd
saveold "$dataTemp/FOCUS_no_duplicates.dta", replace

use "$dataTemp/matricula_unica_2016_tercero_medio_rbd2017.dta", clear
merge 1:1 mrun using "$dataTemp/FOCUS_no_duplicates.dta", update 
drop if _merge==2
keep if cod_ense2==5 | cod_ense2==7 //keep only if non-adult student
keep if cod_grado==3                //keep only if in tercero grado
gen in_matricula16=1 if _merge!=2 //Generate a dummy =1 if student is in the matricula 2016 dataset
replace in_matricula16=0 if _merge==2 //Generate a dummy =1 if student is in the matricula 2016 dataset
gen in_sample=1 if _merge!=1     //Generate a dummy =1 if student is in the FOCUS dataset
replace in_sample=0 if _merge==1
drop _merge


*Merge with experimental school list
merge m:1 rbd using "$dataRaw/List_experimental_high_schools/experimental_school_list.dta", update
gen in_experimental_schools=1 if _merge==3
replace in_experimental_schools=0 if _merge!=3
drop _merge
tab in_experimental_schools // 10,345 students in experimental schools

*Merge with all eligible schools
merge m:1 rbd using "$dataTemp/pace221_ucl.dta", update
gen in_eligible_schools=1 if _merge>=3
replace in_eligible_schools=0 if _merge<3
drop if _merge==2
drop _merge
replace treatment=0 if treatment==.
tab in_eligible_schools //16,566 students in eligible schools
gen movers=0 if rbd==rbd_matricula2017 & (rbd==rbd_FOCUS2017 | rbd_FOCUS2017==.)
replace movers=1 if movers==. //Generate a dummy variable for students that change school in the 2016-2017
rename rbd rbd_basefinal
*Dropping the students that change school between 2016-2017
tab movers if in_experimental_schools==1
tab movers if in_sample==1
di 6110/9007 // take-up rate
drop if movers==1

*Generate demographics
gen female=0 if gen_alu==1
replace female=1 if gen_alu==2
replace female=1 if female==. & P1==2 //Use FOCUS data if gender missing in matricula
replace female=0 if female==. & P1==1
replace cod_reg_rbd=REGION if cod_reg_rbd==.
replace cod_grado=4 if cod_grado==3 /*The students were in tercero medio in 2016, but in cuarto medio when we test them*/
destring edad_alu , replace
replace edad_alu=edad_alu+1 /*The students are one year older when we test them*/
rename edad_alu age
rename agno agno_tercero_medio
drop P1 gen_alu
saveold "$dataTemp/basefinal_temp.dta", replace



***Merge with simce data
merge 1:1 mrun using "$dataTemp/simce_unique_alucpad_2015.dta", gen(_merge2015)
preserve
keep if _merge2015==3

saveold "$dataTemp/temp_matched_2015.dta", replace
restore
keep if _merge2015==1
merge 1:1 mrun using "$dataTemp/simce_unique_alucpad_2014.dta", gen(_merge2014)
preserve
keep if _merge2014==3
saveold "$dataTemp/temp_matched_2014.dta", replace
restore
keep if _merge2014==1
merge 1:1 mrun using "$dataTemp/simce_unique_alucpad_2013.dta", gen(_merge2013)
keep if _merge2013==3
saveold "$dataTemp/temp_matched_2013.dta", replace

use "$dataTemp/temp_matched_2015.dta", clear
append using  "$dataTemp/temp_matched_2014.dta"
append using  "$dataTemp/temp_matched_2013.dta"

gen tooksimce=2015 if _merge2015==3
replace tooksimce=2014 if _merge2014==3
replace tooksimce=2013 if _merge2013==3
drop _merge*
label var tooksimce "Year in which student took SIMCE segundo medio"
saveold "$dataTemp/simce_matched_temp.dta", replace
gen in_simce=1
lab var in_simce "Have simce data"
merge 1:1 mrun using "$dataTemp/basefinal_temp.dta", update replace
drop _merge
saveold "$dataTemp/basefinal_merged_mat16.dta", replace

forvalues y=2013(1)2015 {
capture erase "$dataTemp/temp_matched_`y'.dta"
}
capture erase "$dataTemp/simce_matched_temp.dta"
capture erase "$dataTemp/basefinal_temp.dta"


use "$dataTemp/basefinal_merged_mat16.dta", clear
*** merge with rendimiento 2015,2014,2013 segundo medio data
*merge from the least recent year to the most recent, so that when we update and replace we keep the GPA of the last time you took secundo medio
merge 1:1 mrun using "$dataTemp/rendimiento_2m_nonmissing_2013.dta", keepusing(GPA_segundo_medio) gen(_merge2013) 
drop if _merge2013==2
merge 1:1 mrun using "$dataTemp/rendimiento_2m_nonmissing_2014.dta", keepusing(GPA_segundo_medio) gen(_merge2014) update replace
drop if _merge2014==2
merge 1:1 mrun using "$dataTemp/rendimiento_2m_nonmissing_2015.dta", keepusing(GPA_segundo_medio) gen(_merge2015) update replace
drop if _merge2015==2
gen year_secundo_medio=2015 if _merge2015>=3
replace year_secundo_medio=2014 if _merge2014>=3 & _merge2015<3
replace year_secundo_medio=2013 if _merge2013>=3 & _merge2014<3 & _merge2015<3
lab var year_secundo_medio "Year when you pass secundo medio"
gen in_rendimiento2m_2015_14_13=1 if year_secundo_medio!=.
drop num_duplicates agno grado _merge*
drop rbd
*** merge with rendimiento 2014,2013 primero medio data
*merge from the least recent year to the most recent, so that when we update and replace we keep the GPA of the last time you took secundo medio
merge 1:1 mrun using "$dataTemp/rendimiento_1m_nonmissing_2013.dta", keepusing(GPA_primero_medio) gen(_merge2013) 
drop if _merge2013==2
merge 1:1 mrun using "$dataTemp/rendimiento_1m_nonmissing_2014.dta", keepusing(GPA_primero_medio) gen(_merge2014) update replace
drop if _merge2014==2
gen year_primero_medio=2014 if _merge2014>=3 
replace year_primero_medio=2013 if _merge2013>=3 & _merge2014<3 
lab var year_primero_medio "Year when you pass primero medio"
gen in_rendimiento1m_2014_13=1 if year_primero_medio!=.
drop agno _merge*

saveold "$dataTemp/basefinal_merged_mat16_rendimiento.dta", replace



*** Merge with alumno prioritario dataset
import delimited "$dataRawPublic/Low_SES/20151116_Prioritarios_y_Beneficiarios_2015_20151001_PUBL.csv", clear 
saveold "$dataTemp/20151116_Prioritarios_y_Beneficiarios_2015_20151001_PUBL.dta", replace
use "$dataTemp/basefinal_merged_mat16_rendimiento.dta", clear
merge 1:1 mrun using "$dataTemp/20151116_Prioritarios_y_Beneficiarios_2015_20151001_PUBL.dta", keepusing(ben_sep)
gen alumno_prioritario=1 if _merge==3
replace alumno_prioritario=0 if _merge!=3
label var alumno_prioritario "Alumno prioritario"
drop if _merge==2
drop ben_sep
drop _merge



***Merge with the April survey (to get data on expected earnings)
merge 1:1 mrun using "$dataRaw/April_survey/Estudio_PACE_Estudiantes_MRUN.dta", force 
drop if _merge==2 //measurement error
gen in_April_sample=1 if _merge==3
drop _merge
preserve
*keep mrun P35 P36 P37 P38 `vars_April'
saveold "$dataTemp/april_rawdata.dta", replace
do "$do_files/6a.April_cleaning.do" 
restore
merge 1:1 mrun using "$dataTemp/april_cleandata.dta"
drop if _merge==2
drop _merge
*drop RBD rbd_A //we keep only rbd_basefinal


***Merge with datasets on field-workers (to include field-worker fixed effects in the regressions)
merge m:1 rbd_basefinal using "$dataRaw/August_survey/fieldworkers_rp.dta", keepusing(ENCUESTADOR) 
rename ENCUESTADOR id_fieldworker
lab var id_fieldworker "Field worker"
drop if _merge==2 //drop the fieldworkers in the missing school
drop _merge



***Merge with GPA 2016
merge 1:1 mrun using "$dataTemp/rendimiento_2016.dta", update
drop if _merge==2
gen in_rendimiento2016=1 if _merge>=3
drop _merge
capture drop TIPO

***Merge with GPA 2017
merge 1:1 mrun using "$dataTemp/rendimiento_2017.dta", update
drop if _merge==2
gen in_rendimiento2017=1 if _merge>=3
drop _merge

***Merge with GPA 2014-2017 by subject
merge 1:1 mrun using "$dataTemp/GPA_by_subject_eligible_schools.dta"
drop if _merge==2
drop rbd
drop _merge


***Merge with distance from PACE universities variables
merge m:1 rbd_basefinal using "$dataRaw/Distance_and_transfers_to_universities//distance_pace_ucl.dta", nogen
drop grupo_pace


saveold "$dataTemp/allstudents_mat2016.dta", replace //save dataset with all students in tercero medio in 2016
*drop if in_experimental_schools!=1          //drop students that are not in experimental schools
drop if in_eligible_schools!=1          //drop students that are not in eligible schools

***Merge with Jefe dataset
merge m:1 rbd_basefinal using "$dataTemp/jefes_clean.dta", keepusing(tot_hrs_PACE_class_unilife treatment_above57_PACE_unilife treatment_below18_PACE_unilife treatment_18_36_PACE_unilife treatment_36_48_PACE_unilife treatment_above_48_PACE_unilife treatment_above_80_PACE_unilife)
drop if _merge==2
drop _merge


/*
*** Merge past enrollment data from MinEduc - CEM -- 
merge m:1 rbd_basefinal using "$dataRaw/Admission/2017_enrolment_by_uni_type.dta"
drop if _merge==2
drop _merge


label var hc0 "# not enrolled in 2017 from HC"
label var hc1 "# enrolled through SUA in 2017 from HC"
label var hc2 "# enrolled through Acceso Regular in 2017 from HC"
label var hc3 "# enrolled through inclusion policy in 2017 from HC"
label var hc4 "# enrolled through special access in 2017 from HC"
label var hc5 "# enrolled through convalidacion in 2017 from HC"
label var hc6 "# enrolled through other access in 2017 from HC"

label var tp0 "# not enrolled in 2017 from TP"
label var tp1 "# enrolled through SUA in 2017 from TP"
label var tp2 "# enrolled through Acceso Regular in 2017 from TP"
label var tp3 "# enrolled through inclusion policy in 2017 from TP"
label var tp4 "# enrolled through special access in 2017 from TP"
label var tp5 "# enrolled through convalidacion in 2017 from TP"
label var tp6 "# enrolled through other access in 2017 from TP"

egen total_past_size_hc=rowtotal(hc0 hc1 hc2 hc3 hc4 hc5 hc6)
egen total_past_size_tp=rowtotal(tp0 tp1 tp2 tp3 tp4 tp5 tp6)
gen total_past_size=total_past_size_hc+total_past_size_tp

replace hc1=0 if hc1==.
replace hc2=0 if hc2==.
replace hc3=0 if hc3==.
replace hc4=0 if hc4==.
replace hc5=0 if hc5==.
replace hc6=0 if hc6==.

replace tp1=0 if tp1==.
replace tp2=0 if tp2==.
replace tp3=0 if tp3==.
replace tp4=0 if tp4==.
replace tp5=0 if tp5==.
replace tp6=0 if tp6==.

gen selective_uni_frac_hc=hc1/total_past_size_hc
gen selective_uni_frac_tp=tp1/total_past_size_tp
gen selective_uni_frac=(hc1+tp1)/total_past_size
 

label var selective_uni_frac_hc "frac of past HC students in the school enrolling in selective uni"
label var selective_uni_frac_tp "frac of past TP students in the school enrolling in selective uni"
label var selective_uni_frac "frac of past students in the school enrolling in selective uni"
*/


***Complete the dummies for presence in different datasets
replace in_matricula=0 if in_matricula==.
replace in_sample=0 if in_sample==.
replace in_experimental_schools=0 if in_matricula==.
replace in_eligible_schools=0 if in_matricula==.
replace in_simce=0 if in_simce==.
replace in_cpad=0 if in_cpad==.
replace in_rendimiento1m_2014_13=0 if in_rendimiento1m_2014_13==.
replace in_rendimiento2m_2015_14_13=0 if in_rendimiento2m_2015_14_13==.
replace in_rendimiento2016=0 if in_rendimiento2016==.
replace in_rendimiento2017=0 if in_rendimiento2017==.
replace in_April_sample=0 if in_April_sample==.
saveold "$dataTemp/basefinal_merged_all_temp.dta", replace 

*** Change name
use "$dataTemp/basefinal_merged_all_temp.dta", clear
saveold "$dataTemp/basefinal_merged_all_nw.dta", replace
capture erase "$dataTemp/basefinal_merged_all_temp.dta"

***Merge with probability weights
do "$do_files/6b.Create_inverse_prob_weights.do" // The first time you run the do-files, you have to run this line to create the "probability_weights"
use "$dataTemp/basefinal_merged_all_nw.dta", clear
 merge 1:1 mrun using "$dataTemp/probability_weights_april.dta"
 drop if _merge==2
 drop _merge
 merge 1:1 mrun using "$dataTemp/probability_weights.dta"
 drop if _merge==2
 drop _merge
 merge 1:1 mrun using  "$dataTemp/probability_weights_GPAdifferentiated.dta"
 drop if _merge==2
 drop _merge
  merge 1:1 mrun using  "$dataTemp/probability_weights_GPAgeneral.dta"
 drop if _merge==2
 drop _merge
 merge 1:1 mrun using  "$dataTemp/probability_weights_GPAdifferentiated_e.dta"
 drop if _merge==2
 drop _merge
  merge 1:1 mrun using  "$dataTemp/probability_weights_GPAgeneral_e.dta"
 drop if _merge==2
 drop _merge


 ***Merge with teachers' data
*First, define correctly class letter and modalidad in students' data
replace let_cur=LETRA if let_cur=="" | let_cur=="." // use information from August sample if class letter is missing in matricula
replace let_cur="A" if let_cur=="AD" | let_cur=="AF" | let_cur=="AH" | let_cur=="AM" | let_cur=="AQ" // using teachers' information, it appears that these are only class letter "A"
gen modalidad=1 if cod_ense2==5
replace modalidad=1 if cod_ense2==. & P3==1
replace modalidad=0 if cod_ense2==7 
replace modalidad=0 if cod_ense2==. & P3==2
replace modalidad=0 if rbd_basefinal==3641 /*We know for sure that this school has only TP students, so we correct for measurement error*/
*Second, merge with teachers data at school/modalidad/class level
local classes_math_teachers "A B C D E F G H I J K"
foreach class_letter of local classes_math_teachers {
merge m:1 rbd_basefinal modalidad let_cur using "$dataTemp/docentes_math`class_letter'.dta", update
preserve
keep if _merge==2
drop _merge
saveold "$dataTemp/docentes_math`class_letter'_nm.dta", replace // save teachers that were not matched using school, modalidad and class
restore
drop if _merge==2
drop _merge
merge m:1 rbd_basefinal let_cur using "$dataTemp/docentes_math`class_letter'_nm.dta", update // merge with the non-matched teachers, using only school and class
preserve
keep if _merge==2
drop _merge
saveold "$dataTemp/docentes_math`class_letter'_nm2.dta", replace // save teachers that were not matched using rbd, modalidad and class
restore
drop if _merge==2
drop _merge
merge m:1 rbd_basefinal modalidad using "$dataTemp/docentes_math`class_letter'_nm2.dta", update // merge with the remaining non-matched teachers, using only school and modalidad
drop if _merge==2
drop _merge
capture erase "$dataTemp/docentes_math`class_letter'_nm.dta"
capture erase "$dataTemp/docentes_math`class_letter'_nm2.dta"
}

local classes_math_teachers "A B C D E F G H I J K"
foreach class_letter of local classes_math_teachers {
merge m:1 rbd_basefinal using "$dataTemp/docentes_math`class_letter'_mod0.dta", update // merge the non-matched students with the vocational teacher in their school
drop if _merge==2
drop _merge
}

local classes_language_teachers "A B C D E F G H I O"
foreach class_letter of local classes_language_teachers {
merge m:1 rbd_basefinal modalidad let_cur using "$dataTemp/docentes_language`class_letter'.dta", update
preserve
keep if _merge==2
drop _merge
saveold "$dataTemp/docentes_language`class_letter'_nm.dta", replace // save teachers that were not matched using rbd, modalidad and class
restore
drop if _merge==2
drop _merge
merge m:1 rbd_basefinal let_cur using "$dataTemp/docentes_language`class_letter'_nm.dta", update // merge with the non-matched teachers, using only school and class
preserve
keep if _merge==2
drop _merge
saveold "$dataTemp/docentes_language`class_letter'_nm2.dta", replace // save teachers that were not matched using rbd, modalidad and class
restore
drop if _merge==2
drop _merge
merge m:1 rbd_basefinal modalidad using "$dataTemp/docentes_language`class_letter'_nm2.dta", update // merge with the remaining non-matched teachers, using only school and modalidad
drop if _merge==2
drop _merge
capture erase "$dataTemp/docentes_language`class_letter'_nm.dta"
capture erase "$dataTemp/docentes_language`class_letter'_nm2.dta"
}

local classes_language_teachers "A B C D E F G H I O"
foreach class_letter of local classes_language_teachers {
merge m:1 rbd_basefinal using "$dataTemp/docentes_language`class_letter'_mod0.dta", update // merge the non-matched students with the vocational teacher in their school
drop if _merge==2
drop _merge
}

** merge with cuarto medio rank and cutoff data 
merge 1:1 mrun using "$dataTemp/GPA4_rank.dta"
tab _merge
drop if _merge==2
drop _merge

merge m:1 rbd_basefinal using "$dataTemp/GPA4_cutoff.dta"
tab _merge
drop if _merge==2
drop _merge



** merge with all years rank and cutoff data 
merge 1:1 mrun using "$dataTemp/GPAallyears_rank.dta"
tab _merge
drop if _merge==2
drop _merge

merge m:1 rbd_basefinal using "$dataTemp/GPAallyears_cutoff.dta"
tab _merge
drop if _merge==2
drop _merge

** merge with segundo medio rank
merge 1:1 mrun using "$dataTemp/GPA_2_rank.dta"
drop if _merge==2
drop _merge

saveold "$dataTemp/basefinal_merged_all.dta", replace



