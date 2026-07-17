********************************************************************************
* DO-FILE DESCRIPTION:
* create list of experimental schools
* create high-school GPA in 2017
* clean GPA by subject
* generate GPA rank in high school
********************************************************************************


* Save list of 221 experimental schools in dta
import excel "$dataRaw/List_experimental_high_schools/pace221_ucl.xlsx", sheet("Sheet1") firstrow clear
saveold "$dataTemp/pace221_ucl.dta", replace 


**********************************************************************************
**#  Clean GPA by subject. Old do-file: "clean_GPA_by_subject.do"
********************************************************************************** 
*Import GPA by subject datasets for each year
import delimited "$dataRaw/GPA/20150316_Notas_por_estudiante_y_subsector_2014_20150218_PUBL.csv", delimiter(";") clear
keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | cod_ense==710 | cod_ense==810 | cod_ense==910 //keep only non-adult students in HC or TP high schools
keep if cod_grado==1 // keep only students that were in primero medio in 2014
destring nota_num, replace dpcomma //eliminate commas from GPA by subject
merge m:1 rbd using "$dataTemp/pace221_ucl.dta"
keep if _merge==3
drop _merge
saveold "$dataTemp/GPA_by_subject_eligible_schools_raw1m.dta", replace

import delimited "$dataRaw/GPA/20160226_Notas_por_estudiante_y_subsector_2015_20160131_PUBL.csv", delimiter(";") clear
keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | cod_ense==710 | cod_ense==810 | cod_ense==910 //keep only non-adult students in HC or TP high schools
keep if cod_grado==2 // keep only students that were in segundo medio in 2015
destring nota_num, replace dpcomma //eliminate commas from GPA by subject
merge m:1 rbd using "$dataTemp/pace221_ucl.dta"
keep if _merge==3
drop _merge
saveold "$dataTemp/GPA_by_subject_eligible_schools_raw2m.dta", replace

import delimited "$dataRaw/GPA/20170315_Notas_por_estudiante_y_subsector_2016_20170131_PUBL.csv", delimiter(";") clear
keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | cod_ense==710 | cod_ense==810 | cod_ense==910 //keep only non-adult students in HC or TP high schools
keep if cod_grado==3 // keep only students that were in tercero medio in 2016
destring nota_num, replace dpcomma //eliminate commas from GPA by subject
merge m:1 rbd using "$dataTemp/pace221_ucl.dta"
keep if _merge==3
drop _merge
saveold "$dataTemp/GPA_by_subject_eligible_schools_raw3m.dta", replace

import delimited "$dataRaw/GPA/20180220_Notas_por_estudiante_y_subsector_2017_20180131_PUBL.csv", delimiter(";") clear
keep if cod_ense2==5 | cod_ense2==7 //keep only non-adult students in HC or TP high schools
keep if cod_grado==4 // keep only students that were in cuarto medio in 2017
destring nota_num, replace dpcomma //eliminate commas from GPA by subject
merge m:1 rbd using "$dataTemp/pace221_ucl.dta"
keep if _merge==3
drop _merge
saveold "$dataTemp/GPA_by_subject_eligible_schools_raw4m.dta", replace


forvalue y=1(1)4 {
use "$dataTemp/GPA_by_subject_eligible_schools_raw`y'm.dta", clear

/*
preserve
merge m:1 cod_subsector using "$dataRaw/GPA/classification_high_school_subject_chatGPT.dta"
keep if stem==1
collapse (mean) nota_num rbd, by(mrun)
rename nota_num GPA_stem_`y'm
lab var GPA_stem_`y'm "GPA in STEM subjects (grade `y')"
saveold "$dataTemp/GPA_stem`y'.dta", replace
restore

preserve
merge m:1 cod_subsector using "$dataRaw/GPA/classification_high_school_subject_chatGPT.dta"
keep if stem==0
collapse (mean) nota_num rbd, by(mrun)
rename nota_num GPA_nostem_`y'm
lab var GPA_nostem_`y'm "GPA in non-STEM subjects (grade `y')"
saveold "$dataTemp/GPA_nostem`y'.dta", replace
restore
*/
preserve
keep if tipo_subsector==2
collapse (mean) nota_num rbd, by(mrun)
rename nota_num GPA_general_subjects_`y'm
lab var GPA_general_subjects_`y'm "GPA in general subjects (grade `y')"
saveold "$dataTemp/GPA_general_subject`y'.dta", replace
restore

preserve
keep if tipo_subsector==3
collapse (mean) nota_num rbd, by(mrun)
rename nota_num GPA_differentiated_subjects_`y'm
lab var GPA_differentiated_subjects_`y'm "GPA in track-specific subjects (grade `y')"
saveold "$dataTemp/GPA_differentiated_subject`y'.dta", replace
restore


preserve
keep if nom_subsector=="MATEMÁTICA"
collapse (mean) nota_num rbd, by(mrun)
rename nota_num GPA_math_subjects_`y'm
lab var GPA_math_subjects_`y'm "GPA in mathematics (grade `y')"
saveold "$dataTemp/GPA_math_subject`y'.dta", replace
restore

preserve
keep if nom_subsector=="LENGUA CASTELLANA Y COMUNICACIÓN" | nom_subsector=="LENGUAJE Y COMUNICACIÓN"
collapse (mean) nota_num rbd, by(mrun)
rename nota_num GPA_language_subjects_`y'm
lab var GPA_language_subjects_`y'm "GPA in language and communication (grade `y')"
saveold "$dataTemp/GPA_language_subject`y'.dta", replace
restore

}
/*
use "$dataTemp/GPA_stem1.dta", clear
forvalue y=2(1)4 {
merge 1:1 mrun using "$dataTemp/GPA_stem`y'.dta", nogen
}
saveold "$dataTemp/GPA_stem.dta", replace

use "$dataTemp/GPA_nostem1.dta", clear
forvalue y=2(1)4 {
merge 1:1 mrun using "$dataTemp/GPA_nostem`y'.dta", nogen
}
saveold "$dataTemp/GPA_nostem.dta", replace
*/
use "$dataTemp/GPA_general_subject1.dta", clear
forvalue y=2(1)4 {
merge 1:1 mrun using "$dataTemp/GPA_general_subject`y'.dta", nogen
}
saveold "$dataTemp/GPA_general_subject.dta", replace

use "$dataTemp/GPA_differentiated_subject1.dta", clear
forvalue y=2(1)4 {
merge 1:1 mrun using "$dataTemp/GPA_differentiated_subject`y'.dta", nogen
}
saveold "$dataTemp/GPA_differentiated_subject.dta", replace

use "$dataTemp/GPA_math_subject1.dta", clear
forvalue y=2(1)4 {
merge 1:1 mrun using "$dataTemp/GPA_math_subject`y'.dta", nogen
}
saveold "$dataTemp/GPA_math_subject.dta", replace

use "$dataTemp/GPA_language_subject1.dta", clear
forvalue y=2(1)4 {
merge 1:1 mrun using "$dataTemp/GPA_language_subject`y'.dta", nogen
}
saveold "$dataTemp/GPA_language_subject.dta", replace

use "$dataTemp/GPA_general_subject.dta", clear
merge 1:1 mrun using "$dataTemp/GPA_differentiated_subject.dta", nogen
merge 1:1 mrun using "$dataTemp/GPA_math_subject.dta", nogen
merge 1:1 mrun using "$dataTemp/GPA_language_subject.dta", nogen
*merge 1:1 mrun using "$dataTemp/GPA_stem.dta", nogen
*merge 1:1 mrun using "$dataTemp/GPA_nostem.dta", nogen

forvalue y=1(1)4 {
egen GPA_mathlang_subjects_`y'm=rowmean(GPA_math_subjects_`y'm GPA_language_subjects_`y'm)
lab var GPA_mathlang_subjects_`y'm "GPA average in math and language (grade `y')"
}

saveold "$dataTemp/GPA_by_subject_eligible_schools.dta", replace

forvalue y=1(1)4 {
capture erase "$dataTemp/GPA_general_subject`y'.dta"
capture erase "$dataTemp/GPA_differentiated_subject`y'.dta"
capture erase "$dataTemp/GPA_math_subject`y'.dta"
*capture erase "$dataTemp/GPA_stem`y'.dta"
*capture erase "$dataTemp/GPA_nostem`y'.dta"
}


**********************************************************************************
**#  Clean GPA in 2002-2018 by grade
********************************************************************************** 
forvalues y=2002(1)2018{ // for each year
	forvalues g=2(1)2{
		if `y'==2002 | `y'==2003 | `y'==2005 | (`y'>=2007 & `y'<=2015) {
            import delimited "$dataRaw/GPA/Rendimiento por estudiante `y'.csv", delimiter(";") clear
		}
		if `y'==2004  {
            import delimited "$dataRaw/GPA/20130422_Rendimiento_2004_20050323_PUBL.csv", delimiter(";") clear
		}
		if `y'==2006  {
            import delimited "$dataRaw/GPA/20130305_Rendimiento_2006_20070620_PUBL.csv", delimiter(";") clear
		}
		if `y'==2016 {
            import delimited "$dataRaw/GPA/20170216_Rendimiento_2016_20170131_PUBL.csv", delimiter(";") clear
		}
		if `y'==2017 {
            import delimited "$dataRaw/GPA/20180213_Rendimiento_2017_20180131_PUBL.csv", delimiter(";") clear
		}
		if `y'==2018 {
            import delimited "$dataRaw/GPA/20190220_Rendimiento_2018_20190131_PUBL.csv", delimiter(";") clear
		}
		if `g'==1 {
		    local grade_name primero
		}
		if `g'==2 {
		    local grade_name segundo
		}
		if `g'==3 {
		    local grade_name tercero
		}
		if `g'==4 {
		    local grade_name cuarto
		}
        keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | ///
		        cod_ense==710 | cod_ense==810 | cod_ense==910  //keep only non-adult students in HC or TP high schools
        keep if cod_grado==`g' // keep only students that were in grade `g' 
		cap rename cod_ense2 cod_ense2_`y'
        cap rename cod_grado cod_grado_`y'
        cap rename ïagno agno
        cap rename sit_final_r sit_fin_r
        gen failed_`grade_name'_medio_`y'=0 if sit_fin_r=="P" 
        replace failed_`grade_name'_medio_`y'=1 if sit_fin_r=="R" | sit_fin_r=="Y"
        lab var failed_`grade_name'_medio_`y' "Has failed the `grade_name' medio year in `y'"
        rename prom_gral GPA_`grade_name'_medio
        lab var GPA_`grade_name'_medio "GPA in `grade_name' medio"
        destring GPA_`grade_name'_medio, replace dpcomma  
        keep if GPA_`grade_name'_medio!=0 //GPA==0 means missing
        destring fec_nac_alu, replace dpcomma  
        gen long source_order = _n
        duplicates tag mrun, gen(dup)
        drop if dup==1 & sit_fin_r=="T" /*drop the duplicate of student that transferred to another school*/     
        drop dup
        replace asistencia=. if asistencia==0  //asistencia==0 means missing 
		destring mrun, replace
		sort mrun source_order
		by mrun: keep if _n==1
		drop source_order
        saveold "$dataTemp/rendimiento_`g'm_nonmissing_`y'.dta", replace
	}
}


*********************************************************************************
**#  Create high-school GPA. 
********************************************************************************** 
*-------------------------------------------------------------------------------
***Clean Rendimiento 2017
import delimited "$dataRaw/GPA/20180213_Rendimiento_2017_20180131_PUBL.csv", delimiter(";") clear 
keep if cod_ense2==5 | cod_ense2==7 //keep only non-adult students in HC or TP high schools
keep if cod_grado==4 // keep only students that were in cuarto medio in 2017
gen passed_cuarto_medio=1 if sit_fin_r=="P" 
replace passed_cuarto_medio=0 if sit_fin_r=="R" | sit_fin_r=="Y"
lab var passed_cuarto_medio "Has passed the cuarto medio year"
gen transferred_cuarto_medio=1 if sit_fin_r=="T"
replace transferred_cuarto_medio=0 if sit_fin_r=="P" | sit_fin_r=="R" | sit_fin_r=="Y"
lab var transferred_cuarto_medio "Has changed school during cuarto medio"
gen droppedout_cuarto_medio=1 if sit_fin_r=="Y"
replace droppedout_cuarto_medio=0 if sit_fin_r=="P" | sit_fin_r=="R" | sit_fin_r=="T"
lab var droppedout_cuarto_medio "Has dropped out of school during cuarto medio"

destring prom_gral , replace dpcomma
rename prom_gral GPA_cuarto_medio
rename cod_ense2 cod_ense2_2017
rename cod_grado cod_grado_2017
saveold "$dataTemp/rendimiento_2017_population.dta", replace
merge m:1 rbd using "$dataTemp/pace221_ucl.dta"  //merge with experimental schools
keep if _merge==3 //keep only students of experimental schools
drop _merge
replace GPA_cuarto_medio=. if GPA_cuarto_medio==0 //GPA==0 means missing
replace asistencia=. if asistencia==0  //asistencia==0 means missing 
drop if transferred_cuarto_medio==1
destring edad_alu, gen(age)
saveold "$dataTemp/rendimiento_2017.dta", replace
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
***Clean Rendimiento 2016
import delimited "$dataRaw/GPA/20170216_Rendimiento_2016_20170131_PUBL.csv", delimiter(";") clear
cap rename ïagno agno
keep if cod_ense2==5 | cod_ense2==7 //keep only non-adult students in HC or TP high schools
keep if cod_grado==3 // keep only students that were in tercero medio in 2016
gen passed_tercero_medio=1 if sit_fin_r=="P" 
replace passed_tercero_medio=0 if sit_fin_r=="R" | sit_fin_r=="Y"
lab var passed_tercero_medio "Has passed the tercero medio year"
gen transferred_tercero_medio=1 if sit_fin_r=="T"
replace transferred_tercero_medio=0 if sit_fin_r=="P" | sit_fin_r=="R" | sit_fin_r=="Y"
lab var transferred_tercero_medio "Has changed school during tercero medio"
gen droppedout_tercero_medio=1 if sit_fin_r=="Y"
replace droppedout_tercero_medio=0 if sit_fin_r=="P" | sit_fin_r=="R" | sit_fin_r=="T"
lab var droppedout_tercero_medio "Has dropped out of school during tercero medio"

destring prom_gral , replace dpcomma
rename prom_gral GPA_tercero_medio
rename cod_ense2 cod_ense2_2016
rename cod_grado cod_grado_2016
merge m:1 rbd using "$dataTemp/pace221_ucl.dta"  //merge with experimental schools
keep if _merge==3 //keep only students of experimental schools
drop _merge
replace GPA_tercero_medio=. if GPA_tercero_medio==0 //GPA==0 means missing
replace asistencia=. if asistencia==0  //asistencia==0 means missing 
drop if transferred_tercero_medio==1
destring edad_alu, gen(age)
saveold "$dataTemp/rendimiento_2016.dta", replace
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
***Clean Rendimiento 2015 segundo medio
import delimited "$dataRaw/GPA/Rendimiento por estudiante 2015.csv", delimiter(";") clear
keep if cod_ense2==5 | cod_ense2==7 //keep only non-adult students in HC or TP high schools
keep if cod_grado==2 // keep only students that were in segundo medio in 2015
rename prom_gral GPA_segundo_medio
lab var GPA_segundo_medio "GPA in segundo medio"
destring GPA_segundo_medio, replace dpcomma  
keep if GPA_segundo_medio!=0
duplicates tag mrun, gen(dup)
drop if dup==1 & sit_fin_r=="T" /*drop the duplicate of student that transferred to another school*/
drop dup
saveold "$dataTemp/rendimiento_2m_nonmissing_2015.dta", replace
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
***Clean Rendimiento 2014 segundo medio (for the students that failed an year)
import delimited "$dataRaw/GPA/Rendimiento por estudiante 2014.csv", delimiter(";") clear
keep if cod_ense2==5 | cod_ense2==7 //keep only non-adult students in HC or TP high schools
keep if cod_grado==2 // keep only students that were in segundo medio in 2014
rename prom_gral GPA_segundo_medio
lab var GPA_segundo_medio "GPA in segundo medio"
destring GPA_segundo_medio, replace dpcomma  
keep if GPA_segundo_medio!=0
duplicates tag mrun, gen(dup)
drop if dup==1 & sit_final_r=="T" /*drop the duplicate of student that transferred to another school*/
drop dup
saveold "$dataTemp/rendimiento_2m_nonmissing_2014.dta", replace
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
***Clean Rendimiento 2013 segundo medio (for the students that failed two years)
import delimited "$dataRaw/GPA/Rendimiento por estudiante 2013.csv", delimiter(";") clear
keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | cod_ense==710 | cod_ense==810 | cod_ense==910 //keep only non-adult students in HC or TP high schools
keep if cod_grado==2 // keep only students that were in segundo medio in 2013
rename prom_gral GPA_segundo_medio
lab var GPA_segundo_medio "GPA in segundo medio"
destring GPA_segundo_medio, replace dpcomma  
keep if GPA_segundo_medio!=0
duplicates tag mrun, gen(dup)
drop if dup==1 & sit_fin_r=="T" /*drop the duplicate of student that transferred to another school*/
drop dup
saveold "$dataTemp/rendimiento_2m_nonmissing_2013.dta", replace
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
***Clean Rendimiento 2014 primero medio
import delimited "$dataRaw/GPA/Rendimiento por estudiante 2014.csv", delimiter(";") clear
keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | cod_ense==710 | cod_ense==810 | cod_ense==910 //keep only non-adult students in HC or TP high schools
keep if cod_grado==1 // keep only students that were in primero medio in 2014
rename prom_gral GPA_primero_medio
lab var GPA_primero_medio "GPA in primero medio"
destring GPA_primero_medio, replace dpcomma  
keep if GPA_primero_medio!=0
duplicates tag mrun, gen(dup)
drop if dup==1 & sit_final_r=="T" /*drop the duplicate of student that transferred to another school*/
drop dup
saveold "$dataTemp/rendimiento_1m_nonmissing_2014.dta", replace
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
***Clean Rendimiento 2013 primero medio (for the students that failed an year)
import delimited "$dataRaw/GPA/Rendimiento por estudiante 2013.csv", delimiter(";") clear
keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | cod_ense==710 | cod_ense==810 | cod_ense==910 //keep only non-adult students in HC or TP high schools
keep if cod_grado==1 // keep only students that were in primero medio in 2013
rename prom_gral GPA_primero_medio
lab var GPA_primero_medio "GPA in primero medio"
destring GPA_primero_medio, replace dpcomma  
keep if GPA_primero_medio!=0
duplicates tag mrun, gen(dup)
drop if dup==1 & sit_fin_r=="T" /*drop the duplicate of student that transferred to another school*/
drop dup
saveold "$dataTemp/rendimiento_1m_nonmissing_2013.dta", replace
*-------------------------------------------------------------------------------








********************************************************************************
**# Generate rank in high school. 
********************************************************************************

********************************************************************************
***               Generate rank in school based on cuarto medio GPA          ***
********************************************************************************

use "$dataTemp/rendimiento_2017.dta", clear   // use GPA cuarto medio dataset
keep rbd mrun GPA_cuarto_medio 
bysort rbd (GPA_cuarto_medio): gen order_GPA=_n if GPA_cuarto_medio!=.   // generate ascending order of GPA cuarto medio in each school
bysort rbd : egen observations_in_school=max(order_GPA)   //  generate number of students in each school with non-missing GPA cuarto medio
gen temp_rank=order_GPA/observations_in_school
bysort rbd GPA_cuarto_medio: egen actual_GPA_rank=max(temp_rank)
drop temp_rank
label var actual_GPA_rank "Rank based on cuarto medio GPA, 1 means top"

gen top_cutoff_indicator=1 if actual_GPA_rank==1   // generate dummy=1 if top student
gen temp=GPA_cuarto_medio  if top_cutoff_indicator==1
bysort rbd: egen actual_top_cutoff=max(temp)
drop temp top_cutoff_indicator
label var actual_top_cutoff "Highest cuarto medio GPA in school"
  
gen top15_cutoff_indicator=1 if actual_GPA_rank >=1-0.15   // generate dummy=1 if top 15% student
gen temp=GPA_cuarto_medio if top15_cutoff_indicator ==1
bysort rbd : egen actual_top15_cutoff=min(temp)
drop temp top15_cutoff_indicator 
label var actual_top15_cutoff "Top 15 percent cuarto medio GPA in school"
  
gen top30_cutoff_indicator=1 if actual_GPA_rank >=1-0.30   // generate dummy=1 if top 30% student
gen temp=GPA_cuarto_medio if top30_cutoff_indicator ==1
bysort rbd : egen actual_top30_cutoff=min(temp)
drop temp top30_cutoff_indicator 
label var actual_top30_cutoff "Top 30 percent cuarto medio GPA in school"

gen top75_cutoff_indicator=1 if actual_GPA_rank >=1-0.75   // generate dummy=1 if top 75% student
gen temp=GPA_cuarto_medio if top75_cutoff_indicator ==1
bysort rbd : egen actual_top75_cutoff=min(temp)
drop temp top75_cutoff_indicator 
label var actual_top75_cutoff "Top 75 percent cuarto medio GPA in school"  

rename rbd rbd_basefinal

preserve
collapse actual_top_cutoff actual_top15_cutoff actual_top30_cutoff actual_top75_cutoff, by(rbd_basefinal)
saveold  "$dataTemp/GPA4_cutoff.dta", replace
restore

keep mrun actual_GPA_rank
saveold  "$dataTemp/GPA4_rank.dta", replace


********************************************************************************
***       Generate rank in school based on GPA average across all years      ***
********************************************************************************
import delimited "$dataRaw/GPA/20180604_NEM_PERCENTILES_JOVENES_2018_20180524_PUBL.csv", delimiter(";") clear
save "$dataTemp/20180604_NEM_PERCENTILES_JOVENES_2018_20180524_PUBL.dta", replace
merge m:1 rbd using "$dataTemp/pace221_ucl.dta", keepusing(rbd)
keep if _merge==3
destring nem, replace dpcomma
bysort rbd (nem): gen order_GPA=_n if nem!=.
bysort rbd : egen observations_in_school=max(order_GPA)
gen temp_rank=order_GPA/observations_in_school
bysort rbd nem: egen allyears_GPA_rank=max(temp_rank)
drop temp_rank
label var allyears_GPA_rank "Rank based on GPA average (all years), 1 means top"

  gen top_cutoff_indicator=1 if allyears_GPA_rank==1
  gen temp=nem if top_cutoff_indicator==1
  bysort rbd: egen allyears_top_cutoff=max(temp)
  drop temp top_cutoff_indicator
  label var allyears_top_cutoff "Highest GPA average (all years) in school"
  
  gen top15_cutoff_indicator=1 if allyears_GPA_rank >=1-0.15
  gen temp=nem if top15_cutoff_indicator ==1
  bysort rbd : egen allyears_top15_cutoff=min(temp)
  drop temp top15_cutoff_indicator 
  label var allyears_top15_cutoff "Top 15 percent GPA average (all years) in school"
  
  gen top30_cutoff_indicator=1 if allyears_GPA_rank >=1-0.30
  gen temp=nem if top30_cutoff_indicator ==1
  bysort rbd : egen allyears_top30_cutoff=min(temp)
  drop temp top30_cutoff_indicator 
  label var allyears_top30_cutoff "Top 30 percent GPA average (all years) in school"

  gen top75_cutoff_indicator=1 if allyears_GPA_rank >=1-0.75
  gen temp=nem if top75_cutoff_indicator ==1
  bysort rbd : egen allyears_top75_cutoff=min(temp)
  drop temp top75_cutoff_indicator 
  label var allyears_top75_cutoff "Top 75 percent GPA average (all years) in school"  
  
rename rbd rbd_basefinal

preserve
collapse allyears_top_cutoff allyears_top15_cutoff allyears_top30_cutoff allyears_top75_cutoff, by(rbd_basefinal)
save  "$dataTemp/GPAallyears_cutoff.dta"  , replace
restore

keep mrun allyears_GPA_rank
save  "$dataTemp/GPAallyears_rank.dta"  , replace



 
********************************************************************************
***       Generate rank in school based on GPA in primero and segundo medio  ***
********************************************************************************
***Generate matricula 2016 dataset
import delimited "$dataRawPublic/High_school_registration/20160926_Matricula_unica_2016_20160430_PUBL.CSV", clear
saveold "$dataTemp/matricula_unica_2016.dta", replace


clear all

use "$dataTemp/rendimiento_2m_nonmissing_2015.dta"
 keep mrun GPA_segundo_medio 
 
 save "$dataTemp/GPA_segundo_medio_2015.dta", replace
 
 clear 
 
 
use "$dataTemp/rendimiento_1m_nonmissing_2014.dta"


 
 keep mrun GPA_primero_medio 
 
 merge 1:1 mrun using "$dataTemp/GPA_segundo_medio_2015.dta", update
 
 drop _merge
 
 merge 1:1 mrun using "$dataTemp/matricula_unica_2016.dta", keepusing(rbd cod_grado cod_ense2)
 keep if cod_grado==3
 keep if cod_ense2==5 | cod_ense2==7

 keep if _merge==3
 drop _merge
 
merge m:1 rbd using "$dataTemp/pace221_ucl.dta", update  //merge with eligible schools
keep if _merge==3
drop _merge


 egen GPA_primero_segundo=rowmean( GPA_primero_medio GPA_segundo_medio)
 label var GPA_primero_segundo "Average of primero and segundo medio GPA"
 
 
   bysort rbd (GPA_primero_segundo): gen order_GPA=_n if GPA_primero_segundo!=.
  bysort rbd : egen observations_in_school=max(order_GPA)
   gen temp=order_GPA /observations_in_school
  bysort rbd GPA_primero_segundo: egen GPA_1_2_rank=max(temp)

  * we are assuming that GPA info is missing at random. If so, the quantiles computed on the non-missing distribution of GPA
  * are a consistent and unbiased estimate of the quantiles in the population
  label var GPA_1_2_rank "Rank based on primero and segundo medio GPA, 1 means top"
  
  
  drop order_GPA observations_in_school temp
 
  
  bysort rbd (GPA_segundo_medio): gen order_GPA=_n if GPA_segundo_medio!=.
  bysort rbd : egen observations_in_school=max(order_GPA)
  gen temp=order_GPA /observations_in_school
  bysort rbd GPA_segundo_medio: egen GPA_2_rank=max(temp)
  label var GPA_2_rank "Rank based on segundo medio GPA, 1 means top"
  drop observations_in_school order_GPA
  
  keep mrun GPA_2_rank GPA_1_2_rank

 save "$dataTemp/GPA_2_rank.dta", replace
 
 
 




 
 
