********************************************************************************
*# DO-FILE DESCRIPTION:
* Create simce datasets in dta format
* Create parents' simce datasets in dta format
* Merge simce padres dataset (parents) with alu dataset (students)
* Clean simce datasets to have simce datsets with unique identifier mrun.
* Saves files "$dataTemp/simce_unique_alucpad_`y'"
********************************************************************************


********************************************************************************
**#  Create simce datasets in dta format. Old do-file: "create_simce_alu.do"
********************************************************************************
import excel "$dataRaw/Simce/simce2m2015_alu_publica_final.xlsx", sheet("Sheet1") firstrow clear
saveold "$dataTemp/simce2m2015_alu.dta", replace
import delimited "$dataRaw/Simce/SIMCE_2M_2014_ALU_MRUN.csv", delimiter(";") clear 
destring ptje_lect2m_alu ptje_mate2m_alu ptje_nat2m_alu eem_lect2m_alu eem_mate2m_alu eem_nat2m_alu, replace dpcomma
saveold "$dataTemp/simce2m2014_alu.dta", replace
import delimited "$dataRaw/Simce/SIMCE_2M_2013_ALU_MRUN.csv", delimiter(";") clear 
destring ptje_lect2m_alu ptje_mate2m_alu eem_lect2m_alu eem_mate2m_alu, replace dpcomma
saveold "$dataTemp/simce2m2013_alu.dta", replace
import delimited "$dataRaw/Simce/SIMCE_2M_2012_ALU_MRUN.csv", delimiter(";") clear 
destring ptje_lect2m_alu ptje_mate2m_alu eem_lect2m_alu eem_mate2m_alu, replace dpcomma
saveold "$dataTemp/simce2m2012_alu.dta", replace
import excel "$dataRaw/Simce/SIMCE_2M_2010_ALU_MRUN.xlsx", sheet("SIMCE_2M_2010_ALU_MRUN") firstrow clear
saveold "$dataTemp/simce2m2010_alu.dta", replace

import excel "$dataRaw/Simce/simce2m2015_cest_publica_final.xlsx", sheet("Sheet1") firstrow clear
saveold "$dataTemp/simce2m2015_alu_cest.dta", replace


*********************************************************************************
**#  Create parents' simce datasets in dta format. Old do-file: "create_simce_cpadres.do"
*********************************************************************************
clear all
import excel "$dataRaw/Simce/simce2m2015_cpad_publica_final.xlsx", sheet("Sheet1") firstrow
saveold "$dataTemp/simce2m2015_cpad.dta", replace

clear all
insheet using "$dataRaw/Simce/SIMCE_2M_2012_CPADRES.csv", delim(";")
saveold "$dataTemp/simce2m2012_cpad.dta", replace

clear all
insheet using "$dataRaw/Simce/SIMCE_2M_2013_CPADRES.csv", delim(";")
saveold "$dataTemp/simce2m2013_cpad.dta", replace

clear all
insheet using "$dataRaw/Simce/SIMCE_2M_2014_CPADRES.csv", delim(";")
saveold "$dataTemp/simce2m2014_cpad", replace

clear all
set excelxlsxlargefile on
import excel "$dataRaw/Simce/SIMCE_2M_2010_CPADRES.xlsx", firstrow
saveold "$dataTemp/simce2m2010_cpad.dta", replace




*********************************************************************************
**#  Merge simce padres dataset (parents) with alu dataset (students). Old do-file: "merge_simce_alu_cpadres.do"
*********************************************************************************
forvalues y=2012(1)2015 {
use "$dataTemp/simce2m`y'_alu.dta", clear
merge 1:1 idalumno using "$dataTemp/simce2m`y'_cpad.dta"
gen in_cpad=0
replace in_cpad=1 if _merge==3
lab var in_cpad "Have parental questionnaire"
drop _merge
if `y'==2015 {
merge 1:1 idalumno using "$dataTemp/simce2m2015_alu_cest.dta", nogen
}
saveold "$dataTemp/simce2m`y'_alucpad.dta", replace
}

use "$dataTemp/simce2m2010_alu.dta", clear
merge 1:1 idalumno using "$dataTemp/simce2m2010_cpad.dta"
gen in_cpad=1 if _merge==3
lab var in_cpad "Have parental questionnaire"
drop if _merge==2 /*drop fathers without students*/
drop _merge
saveold "$dataTemp/simce2m2010_alucpad.dta", replace




*********************************************************************************
**#  Clean simce cpad datasets to obtain parents' education and household income.  
*********************************************************************************
cd "$dataTemp"

*clean simce 2015
use simce2m2015_alucpad

** parental education
gen peduc=. if cpad_p07==0 | cpad_p07==99
replace peduc=0 if cpad_p07==1
replace peduc=1 if cpad_p07==2
replace peduc=2 if cpad_p07==3
replace peduc=3 if cpad_p07==4
replace peduc=4 if cpad_p07==5
replace peduc=5 if cpad_p07==6
replace peduc=6 if cpad_p07==7
replace peduc=7 if cpad_p07==8
replace peduc=8 if cpad_p07==9
replace peduc=9 if cpad_p07==10
replace peduc=10 if cpad_p07==11
replace peduc=11 if cpad_p07==12
replace peduc=12 if cpad_p07==13
replace peduc=12 if cpad_p07==14
replace peduc=13 if cpad_p07==15
replace peduc=14.5 if cpad_p07==16
replace peduc=14 if cpad_p07==17
replace peduc=16 if cpad_p07==18
replace peduc=17 if cpad_p07==19
replace peduc=21 if cpad_p07==20

gen meduc=. if cpad_p08==0 | cpad_p08==99
replace meduc=0 if cpad_p08==1
replace meduc=1 if cpad_p08==2
replace meduc=2 if cpad_p08==3
replace meduc=3 if cpad_p08==4
replace meduc=4 if cpad_p08==5
replace meduc=5 if cpad_p08==6
replace meduc=6 if cpad_p08==7
replace meduc=7 if cpad_p08==8
replace meduc=8 if cpad_p08==9
replace meduc=9 if cpad_p08==10
replace meduc=10 if cpad_p08==11
replace meduc=11 if cpad_p08==12
replace meduc=12 if cpad_p08==13
replace meduc=12 if cpad_p08==14
replace meduc=13 if cpad_p08==15
replace meduc=14.5 if cpad_p08==16
replace meduc=14 if cpad_p08==17
replace meduc=16 if cpad_p08==18
replace meduc=17 if cpad_p08==19
replace meduc=21 if cpad_p08==20

gen hh_income=. if cpad_p10==0 | cpad_p10==99
replace hh_income=50 if cpad_p10==1
replace hh_income=150 if cpad_p10==2
replace hh_income=250 if cpad_p10==3
replace hh_income=350 if cpad_p10==4
replace hh_income=450 if cpad_p10==5
replace hh_income=550 if cpad_p10==6
replace hh_income=700 if cpad_p10==7
replace hh_income=900 if cpad_p10==8
replace hh_income=1100 if cpad_p10==9
replace hh_income=1300 if cpad_p10==10
replace hh_income=1500 if cpad_p10==11
replace hh_income=1700 if cpad_p10==12
replace hh_income=1900 if cpad_p10==13
replace hh_income=2100 if cpad_p10==14
replace hh_income=2500 if cpad_p10==15

label var hh_income "HH income in 1000 CLP"

keep agno mrun gen_alu rbd grado letra_curso cod_curso ptje_lect2m_alu ptje_mate2m_alu ptje_soc2m_alu curso in_cpad peduc meduc hh_income cest* cpad_p*

saveold simce2015_alucpad_clean, replace


*clean simce 2014
clear all
use simce2m2014_alucpad

** parental education
gen peduc=. if cpad_p04==0 | cpad_p04==99
replace peduc=0 if cpad_p04==1
replace peduc=1 if cpad_p04==2
replace peduc=2 if cpad_p04==3
replace peduc=3 if cpad_p04==4
replace peduc=4 if cpad_p04==5
replace peduc=5 if cpad_p04==6
replace peduc=6 if cpad_p04==7
replace peduc=7 if cpad_p04==8
replace peduc=8 if cpad_p04==9
replace peduc=9 if cpad_p04==10
replace peduc=10 if cpad_p04==11
replace peduc=11 if cpad_p04==12
replace peduc=12 if cpad_p04==13
replace peduc=12 if cpad_p04==14
replace peduc=13 if cpad_p04==15
replace peduc=14.5 if cpad_p04==16
replace peduc=14 if cpad_p04==17
replace peduc=16 if cpad_p04==18
replace peduc=17 if cpad_p04==19
replace peduc=21 if cpad_p04==20

** meduc
gen meduc=. if cpad_p05==0 | cpad_p05==99
replace meduc=0 if cpad_p05==1
replace meduc=1 if cpad_p05==2
replace meduc=2 if cpad_p05==3
replace meduc=3 if cpad_p05==4
replace meduc=4 if cpad_p05==5
replace meduc=5 if cpad_p05==6
replace meduc=6 if cpad_p05==7
replace meduc=7 if cpad_p05==8
replace meduc=8 if cpad_p05==9
replace meduc=9 if cpad_p05==10
replace meduc=10 if cpad_p05==11
replace meduc=11 if cpad_p05==12
replace meduc=12 if cpad_p05==13
replace meduc=12 if cpad_p05==14
replace meduc=13 if cpad_p05==15
replace meduc=14.5 if cpad_p05==16
replace meduc=14 if cpad_p05==17
replace meduc=16 if cpad_p05==18
replace meduc=17 if cpad_p05==19
replace meduc=21 if cpad_p05==20

gen hh_income=. if cpad_p06==0 | cpad_p06==99
replace hh_income=50 if cpad_p06==1
replace hh_income=150 if cpad_p06==2
replace hh_income=250 if cpad_p06==3
replace hh_income=350 if cpad_p06==4
replace hh_income=450 if cpad_p06==5
replace hh_income=550 if cpad_p06==6
replace hh_income=700 if cpad_p06==7
replace hh_income=900 if cpad_p06==8
replace hh_income=1100 if cpad_p06==9
replace hh_income=1300 if cpad_p06==10
replace hh_income=1500 if cpad_p06==11
replace hh_income=1700 if cpad_p06==12
replace hh_income=1900 if cpad_p06==13
replace hh_income=2100 if cpad_p06==14
replace hh_income=2500 if cpad_p06==15

label var hh_income "HH income in 1000 CLP"
keep agno mrun gen_alu rbd grado letra_curso cod_curso ptje_lect2m_alu ptje_mate2m_alu ptje_nat2m_alu curso in_cpad peduc meduc hh_income   cpad_p*

saveold simce2014_alucpad_clean, replace


*clean simce 2013
clear all 
use simce2m2013_alucpad

** parental education
gen peduc=. if cpad_p07==0 | cpad_p07==99
replace peduc=0 if cpad_p07==1
replace peduc=1 if cpad_p07==2
replace peduc=2 if cpad_p07==3
replace peduc=3 if cpad_p07==4
replace peduc=4 if cpad_p07==5
replace peduc=5 if cpad_p07==6
replace peduc=6 if cpad_p07==7
replace peduc=7 if cpad_p07==8
replace peduc=8 if cpad_p07==9
replace peduc=9 if cpad_p07==10
replace peduc=10 if cpad_p07==11
replace peduc=11 if cpad_p07==12
replace peduc=12 if cpad_p07==13
replace peduc=12 if cpad_p07==14
replace peduc=13 if cpad_p07==15
replace peduc=14.5 if cpad_p07==16
replace peduc=14 if cpad_p07==17
replace peduc=16 if cpad_p07==18
replace peduc=17 if cpad_p07==19
replace peduc=21 if cpad_p07==20

gen meduc=. if cpad_p08==0 | cpad_p08==99
replace meduc=0 if cpad_p08==1
replace meduc=1 if cpad_p08==2
replace meduc=2 if cpad_p08==3
replace meduc=3 if cpad_p08==4
replace meduc=4 if cpad_p08==5
replace meduc=5 if cpad_p08==6
replace meduc=6 if cpad_p08==7
replace meduc=7 if cpad_p08==8
replace meduc=8 if cpad_p08==9
replace meduc=9 if cpad_p08==10
replace meduc=10 if cpad_p08==11
replace meduc=11 if cpad_p08==12
replace meduc=12 if cpad_p08==13
replace meduc=12 if cpad_p08==14
replace meduc=13 if cpad_p08==15
replace meduc=14.5 if cpad_p08==16
replace meduc=14 if cpad_p08==17
replace meduc=16 if cpad_p08==18
replace meduc=17 if cpad_p08==19
replace meduc=21 if cpad_p08==20

gen hh_income=. if cpad_p09==0 | cpad_p09==99
replace hh_income=50 if cpad_p09==1
replace hh_income=150 if cpad_p09==2
replace hh_income=250 if cpad_p09==3
replace hh_income=350 if cpad_p09==4
replace hh_income=450 if cpad_p09==5
replace hh_income=550 if cpad_p09==6
replace hh_income=700 if cpad_p09==7
replace hh_income=900 if cpad_p09==8
replace hh_income=1100 if cpad_p09==9
replace hh_income=1300 if cpad_p09==10
replace hh_income=1500 if cpad_p09==11
replace hh_income=1700 if cpad_p09==12
replace hh_income=1900 if cpad_p09==13
replace hh_income=2100 if cpad_p09==14
replace hh_income=2500 if cpad_p09==15

label var hh_income "HH income in 1000 CLP"

keep agno mrun gen_alu rbd grado letra_curso cod_curso ptje_lect2m_alu ptje_mate2m_alu  curso  in_cpad peduc meduc hh_income  cpad_p*


saveold simce2013_alucpad_clean, replace


*clean simce 2012
clear all
use simce2m2012_alucpad

** parental education
gen peduc=. if cpad_p08==0 | cpad_p08==99
replace peduc=0 if cpad_p08==1
replace peduc=1 if cpad_p08==2
replace peduc=2 if cpad_p08==3
replace peduc=3 if cpad_p08==4
replace peduc=4 if cpad_p08==5
replace peduc=5 if cpad_p08==6
replace peduc=6 if cpad_p08==7
replace peduc=7 if cpad_p08==8
replace peduc=8 if cpad_p08==9
replace peduc=9 if cpad_p08==10
replace peduc=10 if cpad_p08==11
replace peduc=11 if cpad_p08==12
replace peduc=12 if cpad_p08==13
replace peduc=12 if cpad_p08==14
replace peduc=13 if cpad_p08==15
replace peduc=14.5 if cpad_p08==16
replace peduc=14 if cpad_p08==17
replace peduc=16 if cpad_p08==18
replace peduc=17 if cpad_p08==19
replace peduc=21 if cpad_p08==20

gen meduc=. if cpad_p09==0 | cpad_p09==99
replace meduc=0 if cpad_p09==1
replace meduc=1 if cpad_p09==2
replace meduc=2 if cpad_p09==3
replace meduc=3 if cpad_p09==4
replace meduc=4 if cpad_p09==5
replace meduc=5 if cpad_p09==6
replace meduc=6 if cpad_p09==7
replace meduc=7 if cpad_p09==8
replace meduc=8 if cpad_p09==9
replace meduc=9 if cpad_p09==10
replace meduc=10 if cpad_p09==11
replace meduc=11 if cpad_p09==12
replace meduc=12 if cpad_p09==13
replace meduc=12 if cpad_p09==14
replace meduc=13 if cpad_p09==15
replace meduc=14.5 if cpad_p09==16
replace meduc=14 if cpad_p09==17
replace meduc=16 if cpad_p09==18
replace meduc=17 if cpad_p09==19
replace meduc=21 if cpad_p09==20

gen hh_income=. if cpad_p10==0 | cpad_p10==99
replace hh_income=50 if cpad_p10==1
replace hh_income=150 if cpad_p10==2
replace hh_income=250 if cpad_p10==3
replace hh_income=350 if cpad_p10==4
replace hh_income=450 if cpad_p10==5
replace hh_income=550 if cpad_p10==6
replace hh_income=700 if cpad_p10==7
replace hh_income=900 if cpad_p10==8
replace hh_income=1100 if cpad_p10==9
replace hh_income=1300 if cpad_p10==10
replace hh_income=1500 if cpad_p10==11
replace hh_income=1700 if cpad_p10==12
replace hh_income=1900 if cpad_p10==13
replace hh_income=2100 if cpad_p10==14
replace hh_income=2500 if cpad_p10==15

label var hh_income "HH income in 1000 CLP"


keep agno mrun gen_alu rbd grado letra_curso cod_curso ptje_lect2m_alu ptje_mate2m_alu  curso in_cpad peduc meduc hh_income  cpad_p* 

saveold simce2012_alucpad_clean, replace






*********************************************************************************
**#  Clean simce datasets to have simce datsets with unique identifier mrun. Old do-file: "simce_unique_mrun_alucpad.do"
********************************************************************************** 
***Generate matricula 2016 dataset
import delimited "$dataRawPublic/High_school_registration/20160926_Matricula_unica_2016_20160430_PUBL.csv", clear
saveold "$dataTemp/matricula_unica_2016.dta", replace


*----------------------------------2015-----------------------------------------
*Eliminate duplicates in simce 2015
use "$dataTemp/simce2015_alucpad_clean.dta", clear
count if mrun==. /*0 missing mrun*/
unique mrun /* 233278 unique values for mrun, out of 245160 observations*/  
*Drop duplicates in all variables
duplicates drop /*0 duplicates in all variables*/
*Drop observations with all puntaje missing
drop if ptje_lect2m_alu==. & ptje_mate2m_alu==. & ptje_soc2m_alu==. /* 39503 deleted*/
*Generate a variable for the number of mrun duplicates that each observation has
duplicates tag mrun, gen(num_duplicates) 
tab num_duplicates /*65 duplicates. They are all with the same mrun= 25011365 */
drop num_duplicates
drop if mrun==25011365 /*Since this mrun is not present in Matricula, we drop it*/
unique mrun /*Now each observation has a unique mrun*/
saveold "$dataTemp/simce_unique_alucpad_2015.dta", replace


*----------------------------------2014-----------------------------------------
 *Save Matricula 2014 dataset in dta format
import delimited "$dataRawPublic/High_school_registration/20140924_Matricula_unica_2014_20140430_PUBL.csv", clear 
rename let_cur letra_curso
keep mrun gen_alu rbd letra_curso 
saveold "$dataTemp/Matricula_unica_2014_formerge.dta", replace /*temporary file to eliminate the wrong duplicates*/

*Now clean the simce
use "$dataTemp/simce2014_alucpad_clean.dta", clear
count if mrun==. /*0 missing mrun*/
unique mrun /* 233865 unique values for mrun, out of 241730 observations*/  
*Drop duplicates in all variables
duplicates drop /*0 duplicates in all variables*/
*Drop observations with all puntaje missing
destring ptje_lect2m_alu, replace dpcomma
destring ptje_mate2m_alu, replace dpcomma
destring ptje_nat2m_alu, replace dpcomma
drop if ptje_lect2m_alu==. & ptje_mate2m_alu==. & ptje_nat2m_alu==. /*50662 deleted*/
*Generate a variable for the number of mrun duplicates that each observation has
duplicates tag mrun, gen(num_duplicates) 
tab num_duplicates /*118 obs have the same mrun= 25011365. 1,052 obs with 1 duplicate */
drop if mrun==25011365 /*Since this mrun is not present in Matricula, we drop it*/
unique mrun gen_alu rbd letra_curso /*Using these extra variables (gender, school, class) we can uniquely identify observations*/
*Merge with Matricula 2014 to get rid of wrong duplicates
preserve
keep if num_duplicates>0 /*keep only observations with duplicates*/
merge 1:1 mrun gen_alu rbd letra_curso using "$dataTemp/Matricula_unica_2014_formerge.dta"
drop if _merge!=3 /*We drop the duplicates that have not matched with matricula mrun*/
drop _merge
saveold "$dataTemp/simce_correctduplicates_2014.dta", replace
restore
drop if num_duplicates>0 /*drop all duplicates*/
append using "$dataTemp/simce_correctduplicates_2014.dta" /*recover the "correct" duplicates and add them to the simce dataset*/ 
drop num_duplicates
unique mrun /*Now each observation has a unique mrun*/
saveold "$dataTemp/simce_unique_alucpad_2014.dta", replace
*erase temporary datasets
capture erase "$dataTemp/Matricula_unica_2014_formerge.dta"
capture erase "$dataTemp/simce_correctduplicates_2014.dta"


*----------------------------------2013-----------------------------------------
*Save Matricula 2013 dataset in dta format
import delimited "$dataRawPublic/High_school_registration/20140808_matricula_unica_2013_20130430_PUBL.csv", clear 
rename let_cur letra_curso
keep mrun gen_alu rbd letra_curso 
saveold "$dataTemp/Matricula_2013_formerge.dta", replace /*temporary file to eliminate the wrong duplicates*/

*Now clean the simce
use "$dataTemp/simce2013_alucpad_clean.dta", clear
count if mrun==. /*0 missing mrun*/
unique mrun /* 241768 unique values for mrun, out of 254580 observations*/  
*Drop duplicates in all variables
duplicates drop /*0 duplicates in all variables*/
*Drop observations with all puntaje missing
destring ptje_lect2m_alu, replace dpcomma
destring ptje_mate2m_alu, replace dpcomma
drop if ptje_lect2m_alu==. & ptje_mate2m_alu==.  /*52780 deleted*/
*Generate a variable for the number of mrun duplicates that each observation has
duplicates tag mrun, gen(num_duplicates) 
tab num_duplicates /*910 obs have the same mrun= 25011365. 246 obs with 1 duplicate */
drop if mrun==25011365 /*Since this mrun is not present in Matricula, we drop it*/
unique mrun gen_alu rbd letra_curso /*Using these extra variables (gender, school, class) we can uniquely identify observations*/
*Merge with Matricula 2013 to get rid of wrong duplicates
preserve
keep if num_duplicates>0 /*keep only observations with duplicates*/
merge 1:1 mrun gen_alu rbd letra_curso using "$dataTemp/Matricula_2013_formerge.dta"
drop if _merge!=3 /*We drop the duplicates that have not matched with matricula mrun*/
drop _merge
saveold "$dataTemp/simce_correctduplicates_2013.dta", replace
restore
drop if num_duplicates>0 /*drop all duplicates*/
append using "$dataTemp/simce_correctduplicates_2013.dta" /*recover the "correct" duplicates and add them to the simce dataset*/ 
drop num_duplicates
unique mrun /*Now each observation has a unique mrun*/
saveold "$dataTemp/simce_unique_alucpad_2013.dta", replace
*erase temporary datasets
capture erase "$dataTemp/Matricula_2013_formerge.dta"
capture erase "$dataTemp/simce_correctduplicates_2013.dta"


*----------------------------------2012-----------------------------------------
*Save Matricula 2012 dataset in dta format
import delimited  "$dataRawPublic/High_school_registration/20140812_matricula_unica_2012_20120430_PUBL.csv", clear
rename let_cur letra_curso
keep mrun gen_alu rbd letra_curso 
saveold "$dataTemp/Matricula_2012_formerge.dta", replace /*temporary file to eliminate the wrong duplicates*/

*Now clean the simce
use "$dataTemp/simce2012_alucpad_clean.dta", clear
count if mrun==. /*0 missing mrun*/
unique mrun /* 236819 unique values for mrun, out of 244826 observations*/  
*Drop duplicates in all variables
duplicates drop /*0 duplicates in all variables*/
*Drop observations with all puntaje missing
destring ptje_lect2m_alu, replace dpcomma
destring ptje_mate2m_alu, replace dpcomma
drop if ptje_lect2m_alu==. & ptje_mate2m_alu==.  /*37378 deleted*/
*Generate a variable for the number of mrun duplicates that each observation has
duplicates tag mrun, gen(num_duplicates) 
tab num_duplicates /*Many duplicates*/
drop if mrun==25011365 /*Since this mrun is not present in Matricula, we drop it */
drop if mrun==25037651 /*Since this mrun is not present in Matricula, we drop it */
unique mrun gen_alu rbd letra_curso /*Using these extra variables (gender, school, class) we CANNOT uniquely identify observations*/
*Drop the duplicates that are not uniquely identifiable even using the extra variables
duplicates tag mrun gen_alu rbd letra_curso, gen(num_duplicates2)
drop if num_duplicates2>0
*Merge with Matricula 2012 to get rid of wrong duplicates
preserve
keep if num_duplicates>0 /*keep only observations with duplicates*/
merge 1:1 mrun gen_alu rbd letra_curso using "$dataTemp/Matricula_2012_formerge.dta"
drop if _merge!=3 /*We drop the duplicates that have not matched with matricula mrun*/
drop _merge
saveold "$dataTemp/simce_correctduplicates_2012.dta", replace
restore
drop if num_duplicates>0 /*drop all duplicates*/
append using "$dataTemp/simce_correctduplicates_2012.dta" /*recover the "correct" duplicates and add them to the simce dataset*/ 
drop num_duplicates
drop num_duplicates2
unique mrun /*Now each observation has a unique mrun*/
saveold "$dataTemp/simce_unique_alucpad_2012.dta", replace
*erase temporary datasets
capture erase "$dataTemp/Matricula_2012_formerge.dta"
capture erase "$dataTemp/simce_correctduplicates_2012.dta"







********************************************************************************
**#  Clean segundo medio simce datasets in 2006-2010 (for long-term predictions)
********************************************************************************
set excelxlsxlargefile on
* Save students' simce scores
import excel "$dataRaw/Simce/SIMCE_2M_2006_ALU_MRUN.xlsx", firstrow clear
destring ptje_lect2m_alu ptje_mate2m_alu eem_lect2m_alu eem_mate2m_alu, replace 
saveold "$dataTemp/simce2m2006_alu.dta", replace

import excel "$dataRaw/Simce/SIMCE_2M_2008_ALU_MRUN.xlsx", firstrow clear
destring ptje_len ptje_mat, replace
rename ptje_len ptje_lect2m_alu
rename ptje_mat ptje_mate2m_alu
saveold "$dataTemp/simce2m2008_alu.dta", replace

import excel "$dataRaw/Simce/SIMCE_2M_2010_ALU_MRUN.xlsx", firstrow clear
destring ptje_lect2m_alu ptje_mate2m_alu eem_lect2m_alu eem_mate2m_alu, replace 
saveold "$dataTemp/simce2m2010_alu.dta", replace

* Save parents' information
clear all
import excel "$dataRaw/Simce/SIMCE_2M_2006_CPADRES.xlsx", firstrow clear
saveold "$dataTemp/simce2m2006_cpad.dta", replace

clear all
import excel "$dataRaw/Simce/SIMCE_2M_2008_CPADRES.xlsx", firstrow clear
saveold "$dataTemp/simce2m2008_cpad.dta", replace

clear all
import excel "$dataRaw/Simce/SIMCE_2M_2010_CPADRES.xlsx", firstrow clear
saveold "$dataTemp/simce2m2010_cpad.dta", replace



foreach y in 2006 2008 2010 { // foreach y in 2006 2008 2010 {
	use "$dataTemp/simce2m`y'_cpad.dta", clear
	*Variable names change from y to y. We use the names of 2013 to harmonize them
	*Variables description comes from LC_SIMCE_2M_20xx_CPAD and for 2017 data it is in 2017-20190605T170750Z-001.zip

	if `y'==2006 {		
		keep idalumno rbd grado cod_curso letra_curso cpad_p08 cpad_p09 cpad_p14
		rename cpad_p08 cpad_p07 //father's educ
		rename cpad_p09 cpad_p08 //mother's educ
		rename cpad_p14 cpad_p09 //hh income	
	    destring cpad_p07 cpad_p08 cpad_p09, replace dpcomma
	    keep idalumno rbd cod_curso letra_curso cpad_p07 cpad_p08 cpad_p09
		
	    *Parental income
	    gen hh_income=. if cpad_p09==0 | cpad_p09==99
	    replace hh_income=50 if cpad_p09==1
	    replace hh_income=150 if cpad_p09==2
	    replace hh_income=250 if cpad_p09==3
	    replace hh_income=350 if cpad_p09==4
		replace hh_income=450 if cpad_p09==5
		replace hh_income=550 if cpad_p09==6
		replace hh_income=700 if cpad_p09==7
		replace hh_income=900 if cpad_p09==8
		replace hh_income=1100 if cpad_p09==9
		replace hh_income=1300 if cpad_p09==10
		replace hh_income=1500 if cpad_p09==11
		replace hh_income=1700 if cpad_p09==12
		replace hh_income=1900 if cpad_p09==13 // 2006 simce cpad censors at 1800
		* questionnaire answer replaced with midpoint income in CLP
	
		*Father's education in years
		gen peduc=. if cpad_p07==0 | cpad_p07==99
		replace peduc=0 if cpad_p07==1
		replace peduc=1 if cpad_p07==2
		replace peduc=2 if cpad_p07==3
		replace peduc=3 if cpad_p07==4
		replace peduc=4 if cpad_p07==5
		replace peduc=5 if cpad_p07==6
		replace peduc=6 if cpad_p07==7
		replace peduc=7 if cpad_p07==8
		replace peduc=8 if cpad_p07==9
		replace peduc=9 if cpad_p07==10
		replace peduc=10 if cpad_p07==11
		replace peduc=11 if cpad_p07==12
		replace peduc=12 if cpad_p07==13
		replace peduc=12 if cpad_p07==14
		replace peduc=13 if cpad_p07==15
		replace peduc=14.5 if cpad_p07==16
		replace peduc=14 if cpad_p07==17
		replace peduc=16 if cpad_p07==18
		replace peduc=17 if cpad_p07==19
		replace peduc=21 if cpad_p07==20
		
		*Mother's education in years
		gen meduc=. if cpad_p08==0 | cpad_p08==99
		replace meduc=0 if cpad_p08==1
		replace meduc=1 if cpad_p08==2
		replace meduc=2 if cpad_p08==3
		replace meduc=3 if cpad_p08==4
		replace meduc=4 if cpad_p08==5
		replace meduc=5 if cpad_p08==6
		replace meduc=6 if cpad_p08==7
		replace meduc=7 if cpad_p08==8
		replace meduc=8 if cpad_p08==9
		replace meduc=9 if cpad_p08==10
		replace meduc=10 if cpad_p08==11
		replace meduc=11 if cpad_p08==12
		replace meduc=12 if cpad_p08==13
		replace meduc=12 if cpad_p08==14
		replace meduc=13 if cpad_p08==15
		replace meduc=14.5 if cpad_p08==16
		replace meduc=14 if cpad_p08==17
		replace meduc=16 if cpad_p08==18
		replace meduc=17 if cpad_p08==19
		replace meduc=21 if cpad_p08==20	
	}	


	if `y'==2008 {		
		rename codigo cod_curso
		gen letra_curso=substr(curso,-1,.) 
		keep idalumno rbd cod_curso letra_curso preg05_* preg06_* preg07_*
	    destring preg05_* preg06_* preg07_*, replace 
		
	    *Parental income
	    gen hh_income=. 
	    replace hh_income=50 if preg07_1==1
	    replace hh_income=150 if preg07_2==1
	    replace hh_income=250 if preg07_3==1
	    replace hh_income=350 if preg07_4==1
		replace hh_income=450 if preg07_5==1
		replace hh_income=550 if preg07_6==1
		replace hh_income=700 if preg07_7==1
		replace hh_income=900 if preg07_8==1
		replace hh_income=1100 if preg07_9==1
		replace hh_income=1300 if preg07_10==1
		replace hh_income=1500 if preg07_11==1
		replace hh_income=1700 if preg07_12==1
		replace hh_income=1900 if preg07_13==1 // 2008 simce cpad censors at 1800

		* questionnaire answer replaced with midpoint income in CLP
	
		*Father's education in years
		gen peduc=. 
		replace peduc=0 if preg05_2==1
		replace peduc=1 if preg05_3==1
		replace peduc=2 if preg05_4==1
		replace peduc=3 if preg05_5==1
		replace peduc=4 if preg05_6==1
		replace peduc=5 if preg05_7==1
		replace peduc=6 if preg05_8==1
		replace peduc=7 if preg05_9==1
		replace peduc=8 if preg05_10==1
		replace peduc=9 if preg05_11==1
		replace peduc=10 if preg05_12==1
		replace peduc=11 if preg05_13==1
		replace peduc=12 if preg05_14==1
		replace peduc=12 if preg05_15==1
		replace peduc=13 if preg05_16==1
		replace peduc=14.5 if preg05_17==1
		replace peduc=14 if preg05_18==1
		replace peduc=16 if preg05_19==1
		replace peduc=17 if preg05_20==1
		replace peduc=21 if preg05_21==1
		
		*Mother's education in years
		gen meduc=. 
		replace meduc=0 if preg06_2==1
		replace meduc=1 if preg06_3==1
		replace meduc=2 if preg06_4==1
		replace meduc=3 if preg06_5==1
		replace meduc=4 if preg06_6==1
		replace meduc=5 if preg06_7==1
		replace meduc=6 if preg06_8==1
		replace meduc=7 if preg06_9==1
		replace meduc=8 if preg06_10==1
		replace meduc=9 if preg06_11==1
		replace meduc=10 if preg06_12==1
		replace meduc=11 if preg06_13==1
		replace meduc=12 if preg06_14==1
		replace meduc=12 if preg06_15==1
		replace meduc=13 if preg06_16==1
		replace meduc=14.5 if preg06_17==1
		replace meduc=14 if preg06_18==1
		replace meduc=16 if preg06_19==1
		replace meduc=17 if preg06_20==1
		replace meduc=21 if preg06_21==1
	}	

    if `y'==2010 {		
		keep idalumno rbd cod_curso letra_curso cpad_p09* cpad_p10* cpad_p11*
	    destring cpad_p09* cpad_p10* cpad_p11*, replace 
		
	    *Parental income
	    gen hh_income=. 
	    replace hh_income=50 if cpad_p11_01==1
	    replace hh_income=150 if cpad_p11_02==1
	    replace hh_income=250 if cpad_p11_03==1
	    replace hh_income=350 if cpad_p11_04==1
		replace hh_income=450 if cpad_p11_05==1
		replace hh_income=550 if cpad_p11_06==1
		replace hh_income=700 if cpad_p11_07==1
		replace hh_income=900 if cpad_p11_08==1
		replace hh_income=1100 if cpad_p11_09==1
		replace hh_income=1300 if cpad_p11_10==1
		replace hh_income=1500 if cpad_p11_11==1
		replace hh_income=1700 if cpad_p11_12==1
		replace hh_income=1900 if cpad_p11_13==1 
		replace hh_income=2100 if cpad_p11_14==1 
		replace hh_income=1300 if cpad_p11_15==1 
		* questionnaire answer replaced with midpoint income in CLP
	
		*Father's education in years
		gen peduc=. 
		replace peduc=0 if cpad_p09_01==1
		replace peduc=1 if cpad_p09_02==1
		replace peduc=2 if cpad_p09_03==1
		replace peduc=3 if cpad_p09_04==1
		replace peduc=4 if cpad_p09_05==1
		replace peduc=5 if cpad_p09_06==1
		replace peduc=6 if cpad_p09_07==1
		replace peduc=7 if cpad_p09_08==1
		replace peduc=8 if cpad_p09_09==1
		replace peduc=9 if cpad_p09_10==1
		replace peduc=10 if cpad_p09_11==1
		replace peduc=11 if cpad_p09_12==1
		replace peduc=12 if cpad_p09_13==1
		replace peduc=12 if cpad_p09_14==1
		replace peduc=13 if cpad_p09_15==1
		replace peduc=14.5 if cpad_p09_16==1
		replace peduc=14 if cpad_p09_17==1
		replace peduc=16 if cpad_p09_18==1
		replace peduc=17 if cpad_p09_19==1
		replace peduc=21 if cpad_p09_20==1
		
		*Mother's education in years
		gen meduc=. 
		replace meduc=0 if cpad_p10_01==1
		replace meduc=1 if cpad_p10_02==1
		replace meduc=2 if cpad_p10_03==1
		replace meduc=3 if cpad_p10_04==1
		replace meduc=4 if cpad_p10_05==1
		replace meduc=5 if cpad_p10_06==1
		replace meduc=6 if cpad_p10_07==1
		replace meduc=7 if cpad_p10_08==1
		replace meduc=8 if cpad_p10_09==1
		replace meduc=9 if cpad_p10_10==1
		replace meduc=10 if cpad_p10_11==1
		replace meduc=11 if cpad_p10_12==1
		replace meduc=12 if cpad_p10_13==1
		replace meduc=12 if cpad_p10_14==1
		replace meduc=13 if cpad_p10_15==1
		replace meduc=14.5 if cpad_p10_16==1
		replace meduc=14 if cpad_p10_17==1
		replace meduc=16 if cpad_p10_18==1
		replace meduc=17 if cpad_p10_19==1
		replace meduc=21 if cpad_p10_20==1
	}	

	keep idalumno rbd cod_curso letra_curso meduc peduc hh_income	
	label var hh_income "HH income in 1000 CLP"
	label var meduc "Mother's years of education"
	label var peduc "Father's years of education"
	saveold "$dataTemp/simce2m`y'_cpad_cleaned.dta", replace
}

foreach y in 2006 2008 2010 2012 2013 2014 2015 2016 2017 2018 {
	local sourcedir "$dataRawPublic/High_school_registration"
    cd "`sourcedir'"
	local csv_datasets : dir "`sourcedir'" files "*unica_`y'_*.csv*"
   	foreach file in `csv_datasets' {
		   if regexm("`file'","_unica_`y'_") {
		   	  import delimited "$dataRawPublic/High_school_registration/`file'", clear // import data on high school registration
			  if (cod_ense2==. | cod_grado==.) {
			  display as error  "Missings in the variable cod_ense2 or cod_grado"
			  } 
			  keep if cod_ense2 == 5 | cod_ense2 == 7 // drop adults and children
	          keep if cod_grado == 2 // keep only students in their segundo medio to merge with simce data
			  keep mrun rbd gen_alu let_cur
			  destring mrun, replace
			  drop if mrun==.
			  gen long source_order = _n
			  duplicates drop
			  sort mrun source_order
			  by mrun: keep if _n==1 // keep the first surviving record in source-file order
			  drop source_order
  	          save "$dataTemp/segundo_medio_students_`y'.dta", replace
		 }
	}
}



foreach y in 2006 2010 { // foreach y in 2006 2008 2010 {
    use "$dataTemp/simce2m`y'_alu.dta", clear
	cap drop if mrun=="#NULL!"
	destring mrun, replace
	drop if mrun==.
	*these seem to be test scores
	merge 1:1 idalumno using "$dataTemp/simce2m`y'_cpad_cleaned.dta"
	gen in_cpad=0
	replace in_cpad=1 if _merge==3
	lab var in_cpad "Have parental questionnaire"
	drop _merge
    cap drop noptje_lect2m_alu noptje_mate2m_alu
	destring mrun, replace
	*according to LC_SIMCE_2M_2016_alu_mrun, mrun is the longitudinal student identifier
	*similarly, idalumno is the "transversal" student identifier (to match a student in a given year)
	gen noptje_lect2m_alu = 0
	gen noptje_mate2m_alu = 0 
	replace noptje_lect2m_alu = 1 if ptje_lect2m_alu == .
	replace noptje_mate2m_alu = 1 if ptje_mate2m_alu == .
	*gen dummy var if score missing
	
	duplicates tag mrun, generate(dup)
	drop if dup>0 & (noptje_lect2m_alu!=0 & noptje_mate2m_alu!=0) // drop if duplicates and have both scores missing

    preserve
	keep if dup>0 // keep only duplicates
	gen long source_order = _n
	rename * *_simce
	rename  mrun_simce mrun
	merge m:1 mrun using "$dataTemp/segundo_medio_students_`y'.dta", keepusing(rbd gen_alu let_cur)
	drop if _merge==2
	keep if rbd==rbd_simce & gen_alu==gen_alu_simce // keep duplicates with the correct high school and gender
	duplicates tag mrun, generate(dup2)
	drop if dup2>0 & letra_curso_simce!=let_cur // among the remaining duplicates, drop those in the wrong class
	sort mrun source_order_simce
	by mrun: keep if _n==1 // keep the first surviving record in source-file order
	drop rbd gen_alu let_cur dup2 source_order_simce
	rename *_simce *
   	save "$dataTemp/simce_correct_duplicates_`y'.dta", replace
	unique mrun
	restore
	
	drop if dup>0
	append using "$dataTemp/simce_correct_duplicates_`y'.dta"
    capture erase "$dataTemp/simce_correct_duplicates_`y'.dta"
	
    gen simce_avg_notimputed=(ptje_lect2m_alu + ptje_mate2m_alu)/2
    label var simce_avg_notimputed "SIMCE score"
	su simce_avg_notimputed
    gen simce_avg_st_notimputed=(simce_avg_notimputed-`r(mean)')/`r(sd)' // standardized using non-missing data
    lab var simce_avg_st_notimputed "Simce score (standardized by cohort)"
	keep  mrun gen_alu rbd cod_curso ptje_lect2m_alu ptje_mate2m_alu noptje_lect2m_alu noptje_mate2m_alu peduc meduc hh_income in_cpad simce_*	
	saveold "$dataTemp/simce2m`y'_alucpad_cleaned.dta", replace
	}
	



********************************************************************************
**#  Clean segundo medio simce datasets for recent years
********************************************************************************
set excelxlsxlargefile on
* Save students' simce scores
import delimited "$dataRaw/Simce/SIMCE_2M_2018_ALU_PRIV.csv", clear
destring ptje_lect2m_alu ptje_mate2m_alu ptje_nat2m_alu eem_lect2m_alu eem_mate2m_alu eem_nat2m_alu, replace dpcomma
saveold "$dataTemp/simce2m2018_alu.dta", replace

import delimited "$dataRaw/Simce/SIMCE_2M_2017_ALU_MRUN.csv", clear
destring ptje_lect2m_alu ptje_mate2m_alu eem_lect2m_alu eem_mate2m_alu, replace dpcomma 
saveold "$dataTemp/simce2m2017_alu.dta", replace

import delimited "$dataRaw/Simce/SIMCE_2M_2016_ALU_MRUN.csv", clear
destring ptje_lect2m_alu ptje_mate2m_alu ptje_nat2m_alu eem_lect2m_alu eem_mate2m_alu eem_nat2m_alu, replace dpcomma 
saveold "$dataTemp/simce2m2016_alu.dta", replace


* Save parents' information
clear all
insheet using "$dataRaw/Simce/SIMCE_2M_2018_CPAD_OFICIAL.csv", delim(";")
saveold "$dataTemp/simce2m2018_cpad.dta", replace

clear all
insheet using "$dataRaw/Simce/SIMCE_2M_2017_CPAD.csv", delim(";")
saveold "$dataTemp/simce2m2017_cpad.dta", replace

clear all
insheet using "$dataRaw/Simce/SIMCE_2M_2016_CPAD.csv", delim(";")
saveold "$dataTemp/simce2m2016_cpad.dta", replace


********************************************************************************
* Impute simce for all years
********************************************************************************
forvalues y=2012(1)2018 {
	use "$dataTemp/simce2m`y'_cpad.dta", clear
	*Variable names change from y to y. We use the names of 2013 to harmonize them
	*Variables description comes from LC_SIMCE_2M_20xx_CPAD and for 2017 data it is in 2017-20190605T170750Z-001.zip

	if `y'==2012 {		
		keep idalumno rbd grado cod_curso letra_curso cpad_p08 cpad_p09 cpad_p10
		rename cpad_p08 cpad_p07 //father's educ
		rename cpad_p09 cpad_p08 //mother's educ
		rename cpad_p10 cpad_p09 //hh income
		}	
	if `y'==2014 {		
		keep idalumno rbd grado codigocurso letra_curso cpad_p04 cpad_p05 cpad_p06
		rename cpad_p04 cpad_p07 //father's educ
		rename cpad_p05 cpad_p08 //mother's educ
		rename cpad_p06 cpad_p09 //hh income
		rename codigocurso cod_curso
		}
	if `y'==2015 {
		keep idalumno rbd grado cod_curso letra_curso cpad_p07 cpad_p08 cpad_p10
		rename cpad_p10 cpad_p09 //hh income
		}
	if `y'==2016 {
		keep idalumno rbd grado cod_curso letra_curso cpad_p07 cpad_p08 cpad_p10
		rename cpad_p10 cpad_p09 //hh income
		}	
	if `y'==2017 {
		keep idalumno rbd grado cod_curso letra_curso cpad_p06 cpad_p07 cpad_p10
		rename cpad_p07 cpad_p08 //mother's educ
		rename cpad_p06 cpad_p07 //father's educ
		rename cpad_p10 cpad_p09 //hh income
		}
	if `y'==2018 {
		keep idalumno rbd grado cod_curso letra_curso cpad_p06 cpad_p07 cpad_p10
		rename cpad_p07 cpad_p08 //mother's educ
		rename cpad_p06 cpad_p07 //father's educ
		rename cpad_p10 cpad_p09 //hh income
		}

	keep idalumno rbd cod_curso letra_curso cpad_p07 cpad_p08 cpad_p09
	destring cpad_p07 cpad_p08 cpad_p09, replace dpcomma

	*father's education in years
	gen peduc=. if cpad_p07==0 | cpad_p07==99
	replace peduc=0 if cpad_p07==1
	replace peduc=1 if cpad_p07==2
	replace peduc=2 if cpad_p07==3
	replace peduc=3 if cpad_p07==4
	replace peduc=4 if cpad_p07==5
	replace peduc=5 if cpad_p07==6
	replace peduc=6 if cpad_p07==7
	replace peduc=7 if cpad_p07==8
	replace peduc=8 if cpad_p07==9
	replace peduc=9 if cpad_p07==10
	replace peduc=10 if cpad_p07==11
	replace peduc=11 if cpad_p07==12
	replace peduc=12 if cpad_p07==13
	replace peduc=12 if cpad_p07==14
	replace peduc=13 if cpad_p07==15
	replace peduc=14.5 if cpad_p07==16
	replace peduc=14 if cpad_p07==17
	replace peduc=16 if cpad_p07==18
	replace peduc=17 if cpad_p07==19
	replace peduc=21 if cpad_p07==20
	
	*mother's education in years
	gen meduc=. if cpad_p08==0 | cpad_p08==99
	replace meduc=0 if cpad_p08==1
	replace meduc=1 if cpad_p08==2
	replace meduc=2 if cpad_p08==3
	replace meduc=3 if cpad_p08==4
	replace meduc=4 if cpad_p08==5
	replace meduc=5 if cpad_p08==6
	replace meduc=6 if cpad_p08==7
	replace meduc=7 if cpad_p08==8
	replace meduc=8 if cpad_p08==9
	replace meduc=9 if cpad_p08==10
	replace meduc=10 if cpad_p08==11
	replace meduc=11 if cpad_p08==12
	replace meduc=12 if cpad_p08==13
	replace meduc=12 if cpad_p08==14
	replace meduc=13 if cpad_p08==15
	replace meduc=14.5 if cpad_p08==16
	replace meduc=14 if cpad_p08==17
	replace meduc=16 if cpad_p08==18
	replace meduc=17 if cpad_p08==19
	replace meduc=21 if cpad_p08==20
	
	*parental income
	gen hh_income=. if cpad_p09==0 | cpad_p09==99
	replace hh_income=50 if cpad_p09==1
	replace hh_income=150 if cpad_p09==2
	replace hh_income=250 if cpad_p09==3
	replace hh_income=350 if cpad_p09==4
	replace hh_income=450 if cpad_p09==5
	replace hh_income=550 if cpad_p09==6
	replace hh_income=700 if cpad_p09==7
	replace hh_income=900 if cpad_p09==8
	replace hh_income=1100 if cpad_p09==9
	replace hh_income=1300 if cpad_p09==10
	replace hh_income=1500 if cpad_p09==11
	replace hh_income=1700 if cpad_p09==12
	replace hh_income=1900 if cpad_p09==13
	replace hh_income=2100 if cpad_p09==14
	replace hh_income=2500 if cpad_p09==15
	* questionnaire answer replaced with midpoint income in CLP
	
	drop cpad_p07 cpad_p08 cpad_p09
	
	label var hh_income "HH income in 1000 CLP"
	saveold "$dataTemp/simce2m`y'_cpad_cleaned.dta", replace
	}

forvalues y=2012(1)2018 {
	local sourcedir "$dataRawPublic/High_school_registration"
    cd "`sourcedir'"
	local csv_datasets : dir "`sourcedir'" files "*unica_`y'_*.csv*"
   	foreach file in `csv_datasets' {
		   if regexm("`file'","_unica_`y'_") {
		   	  import delimited "$dataRawPublic/High_school_registration/`file'", clear // import data on high school registration
			  if (cod_ense2==. | cod_grado==.) {
			  display as error  "Missings in the variable cod_ense2 or cod_grado"
			  } 
			  keep if cod_ense2 == 5 | cod_ense2 == 7 // drop adults and children
	          keep if cod_grado == 2 // keep only students in their segundo medio to merge with simce data
  	          save "$dataTemp/segundo_medio_students_`y'.dta", replace
		 }
	}
}

forvalues y=2012(1)2018 {
    use "$dataTemp/simce2m`y'_alu.dta", clear
	*these seem to be test scores
	merge 1:1 idalumno using "$dataTemp/simce2m`y'_cpad_cleaned.dta"
	gen in_cpad=0
	replace in_cpad=1 if _merge==3
	lab var in_cpad "Have parental questionnaire"
	drop _merge
    cap drop noptje_lect2m_alu noptje_mate2m_alu
	destring mrun, replace
	*according to LC_SIMCE_2M_2016_alu_mrun, mrun is the longitudinal student identifier
	*similarly, idalumno is the "transversal" student identifier (to match a student in a given year)
	gen noptje_lect2m_alu = 0
	gen noptje_mate2m_alu = 0 
	replace noptje_lect2m_alu = 1 if ptje_lect2m_alu == .
	replace noptje_mate2m_alu = 1 if ptje_mate2m_alu == .
	*gen dummy var if score missing
	
	duplicates tag mrun, generate(dup)
	drop if dup>0 & (noptje_lect2m_alu!=0 & noptje_mate2m_alu!=0) // drop if duplicates and have both scores missing

    preserve
	keep if dup>0 // keep only duplicates
	gen long source_order = _n
	rename * *_simce
	rename  mrun_simce mrun
	merge m:1 mrun using "$dataTemp/segundo_medio_students_`y'.dta", keepusing(rbd gen_alu let_cur)
	drop if _merge==2
	keep if rbd==rbd_simce & gen_alu==gen_alu_simce // keep duplicates with the correct high school and gender
	duplicates tag mrun, generate(dup2)
	drop if dup2>0 & letra_curso_simce!=let_cur // among the remaining duplicates, drop those in the wrong class
	sort mrun source_order_simce
	by mrun: keep if _n==1 // keep the first surviving record in source-file order
	drop rbd gen_alu let_cur dup2 source_order_simce
	rename *_simce *
   	save "$dataTemp/simce_correct_duplicates_`y'.dta", replace
	unique mrun
	restore
	
	drop if dup>0
	append using "$dataTemp/simce_correct_duplicates_`y'.dta"
    capture erase "$dataTemp/simce_correct_duplicates_`y'.dta"
	
    gen simce_avg_notimputed=(ptje_lect2m_alu + ptje_mate2m_alu)/2
    label var simce_avg_notimputed "SIMCE score"
	su simce_avg_notimputed
    gen simce_avg_st_notimputed=(simce_avg_notimputed-`r(mean)')/`r(sd)'
    lab var simce_avg_st_notimputed "Simce score not imputed (standardized by cohort)"  // standardized using non-missing data
	keep  mrun gen_alu rbd cod_curso ptje_lect2m_alu ptje_mate2m_alu noptje_lect2m_alu noptje_mate2m_alu peduc meduc hh_income in_cpad simce_*	
	saveold "$dataTemp/simce2m`y'_alucpad_cleaned.dta", replace
	}

clear all
set maxvar 120000
use "$dataTemp/simce2m2006_alucpad_cleaned.dta", clear
foreach y of numlist 2010 2012(1)2018 { // foreach y of numlist 2008 2010 2012(1)2018 {
	drop if simce_avg_st==.
	merge 1:1 mrun using "$dataTemp/simce2m`y'_alucpad_cleaned.dta", update replace // we use the most recent simce data
	drop _merge
}
gen simce_avg_st=simce_avg_st_notimputed
gen year_segundo=.
forvalues y=2002(1)2018 {
	di "year is `y'"
merge 1:1 mrun using "$dataTemp/rendimiento_2m_nonmissing_`y'.dta", keepusing(GPA_segundo_medio cod_ense rbd let_cur) update replace // impute simce with the most updated GPA
replace year_segundo=`y' if _merge!=1
lab var year_segundo "Year most recent segundo medio"
drop _merge
cap rename cod_ense2_`y' cod_ense2
}
gen modalidad=1 if cod_ense==310 
replace modalidad=0 if cod_ense==410 | cod_ense==510 | cod_ense==610 | ///
		               cod_ense==710 | cod_ense==810 | cod_ense==910 
lab var modalidad "Academic high-school track"
*Impute simce using segundo medio using GPA and school-class-high-school-track in each year
egen class_code=group(rbd let_cur modalidad)
replace class_code=. if let_cur=="" | rbd==. | modalidad==.
gen simce_avg_st_imputed=.
foreach y of numlist 2006 2010 2012(1)2018 { // foreach y of numlist 2006 2008 2010 2012(1)2018 { // year in which simce is available
    timer clear 
	timer on 1
    regress simce_avg_st_notimputed GPA_segundo_medio i.class_code if year_segundo==`y'
    predict simce_avg_st_imputed_`y' if year_segundo==`y'
	replace simce_avg_st_imputed=simce_avg_st_imputed_`y' if simce_avg_st_imputed_`y'!=. // generate imputed simce using most recent segundo medio GPA data for imputation
	timer off 1
    timer list 1
    di "The regression for year `y' took `r(t1)' seconds"
}
replace simce_avg_st=simce_avg_st_imputed if simce_avg_st==. // replace simce with imputed simce only if missing
drop year_segundo modalidad cod_ense simce_avg_st_imputed* let_cur

lab var simce_avg_st "Simce score imputed (standardized by cohort)"
drop if simce_avg_st==.
saveold "$dataTemp/simce2m_all_years_alucpad_cleaned.dta", replace


