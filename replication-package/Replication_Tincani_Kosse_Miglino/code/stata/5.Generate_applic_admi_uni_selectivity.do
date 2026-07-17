********************************************************************************
* DO-FILE DESCRIPTION:
* This do-file merges all high-school datasets
********************************************************************************

* Create Stata datsets
import delimited "$dataRaw/PSU/C_POSTULACIONES_SELECCION_PSU_CUPOS_PACE_2018_PRIV_MRUN.csv", clear
save "$dataTemp/C_POSTULACIONES_SELECCION_PSU_CUPOS_PACE_2018_PRIV_MRUN.dta", replace

import delimited "$dataRaw/PSU/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_MRUN.csv", clear
save "$dataTemp/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_MRUN.dta", replace

import delimited "$dataRaw/Admission/20180829_Matricula_Ed_Superior_2018_PRIV_MRUN.csv", clear
save "$dataTemp/20180829_Matricula_Ed_Superior_2018_PRIV_MRUN.dta", replace

import delimited "$dataRaw/PSU/D_MATRICULA_PSU_2018_PRIV_MRUN.csv", clear
duplicates tag mrun, gen(dupli)
drop if dupli>0 & via_ingreso!=3
drop dupli
save "$dataTemp/D_MATRICULA_PSU_2018_PRIV_uniqueMRUN.dta", replace
save "$dataTemp/matricula2018.dta", replace

import delimited "$dataRaw/PSU/A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN.csv", clear
duplicates tag mrun, gen(dupli)
drop if dupli>0 
drop dupli
save "$dataTemp/A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN.dta", replace

import delimited "$dataRaw/Admission/archivo_E_PACE_2018_MRUN.csv", clear
save "$dataTemp/archivio_E_PACE_MRUN.dta", replace


forvalues y=2018(1)2022{
	if `y'<=2019 {
         import delimited "$dataRaw/PSU/D_MATRICULA_PSU_`y'_PRIV_MRUN.csv", clear
    }
	if `y'>=2020 {
         import delimited "$dataRaw/PSU/D_MATRICULA_PSU_`y'_PUB_MRUN.csv", clear
    }
	di `y'
    cap destring mrun, replace
	duplicates report mrun
	duplicates tag mrun, gen(dup)
	drop if dup>0  // We drop observations for which we don't have info about their true enrollment
	drop dup
	gen uni_code = sigla_universidad
	* Change Code - Reference Year: 2022 * 
	* U. AUSTRAL DE CHILE
	replace uni_code="UACH" if uni_code=="UACh"
	* U. DE UNIVERSIDAD DE PLAYA ANCHA
	replace uni_code="UPLA" if uni_code=="UPA"
	* U. DE TALCA
	replace uni_code="UTALCA" if uni_code=="UTAL"
	* U. DE UNIVERSIDAD DE PLAYA ANCHA
	replace uni_code="UPLA" if uni_code=="UPA"
	* U. DE LOS LAGOS
	replace uni_code="ULAGOS" if uni_code=="ULAG"
	* Universidad Técnica Federico Santa María 
	replace uni_code="UTFSM" if uni_code=="USM"
	* PONTIFICIA U. CATÓLICA DE CHILE
	replace uni_code="PUCCH" if uni_code=="UC"
	* U. DE CHILE
	replace uni_code= "UCHILE" if uni_code== "UCH"
	* U. AUTONOMA
	replace uni_code = "UAUTONOMA" if uni_code == "UA"
    save "$dataTemp/D_MATRICULA_PSU_`y'_PRIV_uniqueMRUN.dta", replace
}
********************************************************************************



***** clean admissions
use "$dataTemp/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_MRUN.dta", clear
gen admitted_waiting_list=1 if situacion_postulante =="P"
replace admitted_waiting_list=0 if situacion_postulante =="C"
gen admitted=1 if admitted_waiting_list==1 & ( estado_de_la_preferencia == 24 | estado_de_la_preferencia ==26)
replace admitted=0 if admitted==.
bysort mrun: egen max_admitted=max(admitted)
drop admitted
rename max_admitted admitted
keep mrun admitted admitted_waiting_list
label var admitted_waiting_list "admitted or in waiting list through regular channel"
label var admitted "admitted through regular channel"
duplicates drop
save "$dataTemp/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_uniqueMRUN_admitted.dta", replace


*** Clean enrollments in all kinds of higher education institution
use "$dataTemp/20180829_Matricula_Ed_Superior_2018_PRIV_MRUN.dta", clear 
keep if anio_mat_pri_anio ==2018
 drop if mrun=="7035251" | mrun=="16573091" | mrun=="9955622"
drop if sem_mat_pri_anio =="2"
gen long source_order = _n
sort mrun nacionalidad source_order
by mrun nacionalidad: keep if _n==1
drop nacionalidad
drop if mrun=="7035251" | mrun=="16573091" | mrun=="9955622" // three foreign students

keep mrun tipo_inst_1 tipo_inst_2 tipo_inst_3 cod_inst nomb_inst forma_de_ingreso tipo_inst_1 tipo_inst_2

drop cod_inst nomb_inst 

duplicates drop

drop if mrun==" "

gen long source_order = _n
bysort mrun: gen aux=_n
bysort mrun: egen dup=max(aux)
drop aux

** now there are few duplicates ---drop the duplicates drop
sort mrun source_order
by mrun: keep if _n==1

destring mrun, replace
drop dup
drop source_order

saveold "$dataTemp/20180829_Matricula_Ed_Superior_2018_PRIV_MRUN_UNIQUEMRUN.dta" , replace


********************************************************************************
* applications
********************************************************************************

use "$dataTemp/C_POSTULACIONES_SELECCION_PSU_CUPOS_PACE_2018_PRIV_MRUN.dta"

gen hugo=1 if situacion_postulante =="P"
replace hugo=0 if situacion_postulante=="C"

bysort mrun: egen admitted_pace=max(hugo)
replace sigla_universidad="UACH" if sigla_universidad=="UACh"
replace sigla_universidad="UPA" if sigla_universidad=="UPLA"

label var admitted_pace "admitted or waiting list through pace"

** keep one observation per student

keep mrun admitted_pace
duplicates drop

saveold "$dataTemp/admitted_pace.dta", replace


clear

use "$dataTemp/20180829_Matricula_Ed_Superior_2018_PRIV_MRUN.dta"
keep if anio_mat_pri_anio ==2018
duplicates drop

drop if mrun==" "
destring mrun, replace

gen hugo=1 if tipo_inst_2=="Universidades CRUCH"
replace hugo=0 if hugo==.


bysort mrun: egen cruch=max(hugo)




keep mrun cruch
duplicates drop 

saveold  "$dataTemp/top_enrollment_2018.dta", replace

clear

use "$dataTemp/A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN.dta" //dataset of all those who registered to take the PSU (PSU scores for each individual) 
                                                                                       //(we dropped 5 observations that enrolled both through pace and regular channel -kept pace enrollment)
merge 1:1 mrun using  "$dataTemp/D_MATRICULA_PSU_2018_PRIV_uniqueMRUN.dta", keepusing (sigla_universidad codigo_carrera via_ingreso) // dataset of all those who enrolled in 2018 in a SUA uni 
replace sigla_universidad="UACH" if sigla_universidad=="UACh"
replace sigla_universidad="UPA" if sigla_universidad=="UPLA"
drop if _merge==1
drop if _merge==2
keep if via_ingreso==1
* issue: we are dropping USM, where PACE students enroll!

drop via_ingreso
destring promlm_actual , replace dpcomma
replace promlm_actual =. if promlm_actual ==0
bysort sigla_universidad : egen mean_PSU_score_uni=mean(promlm_actual )
bysort sigla_universidad: egen min_PSU_score_uni=min(promlm_actual)

bysort sigla_universidad codigo_carrera : egen mean_PSU_score_uni_major=mean(promlm_actual )
bysort sigla_universidad codigo_carrera: egen min_PSU_score_uni_major=min(promlm_actual)

keep mrun mean_PSU_score_uni min_PSU_score_uni mean_PSU_score_uni_major min_PSU_score_uni_major
label var mean_PSU_score_uni "average PSU score of regular entrants in SUA uni in which are enrolled in 2018"
label var min_PSU_score_uni "min PSU score of regular entrants in SUA uni in which are enrolled in 2018 "
label var mean_PSU_score_uni_major "average PSU score of regular entrants in SUA uni/major in which are enrolled in 2018"
label var min_PSU_score_uni_major "min PSU score of regular entrants in SUA uni/major in which are enrolled in 2018 "
saveold "$dataTemp/mean_psu_score.dta", replace

clear
*** now generate a dataset that contains for each applicant through the regular channel, the avergae PSU scores of REGULAR entrants into that codigo_carrera and university, then 
** merge with the dataset of all applications and for each applicant generata  a variable "quality of top choice, quality of top 3 choices, quality of all choices"
use "$dataTemp/A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN.dta" //dataset of all those who registered to take the PSU (PSU scores for each individual) 
                                                                                       //(we dropped 5 observations that enrolled both through pace and regular channel -kept pace enrollment)
																					   
merge 1:1 mrun using  "$dataTemp/D_MATRICULA_PSU_2018_PRIV_uniqueMRUN.dta", keepusing (sigla_universidad uni_code codigo_carrera via_ingreso nombre_carrera sede_carrera año_proceso) // dataset pf a;; those 
*who enrolled in 2018 in a SUA uni 
replace sigla_universidad="UACH" if sigla_universidad=="UACh"
replace sigla_universidad="UPA" if sigla_universidad=="UPLA"
drop if _merge==1
drop if _merge==2
keep if via_ingreso==1

drop via_ingreso
destring promlm_actual , replace dpcomma
replace promlm_actual =. if promlm_actual ==0
	replace mate_actual=. if mate_actual==0
	* language and communication
	replace lyc_actual=. if lyc_actual==0
	* history and social science // not compulsory, do not use 
	replace hycs_actual =. if hycs_actual ==0
	* science // not compulsory, do not use
	replace ciencias_actual =. if ciencias_actual ==0
	
	* Overall PSU score 
	bysort uni_code : egen mean_PSU_score_uni = mean(promlm_actual )
	bysort uni_code: egen min_PSU_score_uni = min(promlm_actual)
	
	bysort uni_code codigo_carrera : egen mean_PSU_score_uni_major = mean(promlm_actual)
	bysort uni_code codigo_carrera: egen min_PSU_score_uni_major = min(promlm_actual)

	* Mathematics component of PSU score 
	bysort uni_code : egen mean_PSU_math_uni = mean(mate_actual)
	bysort uni_code: egen min_PSU_math_uni = min(mate_actual)
	
	bysort uni_code codigo_carrera : egen mean_PSU_math_uni_major = mean(mate_actual)
	bysort uni_code codigo_carrera: egen min_PSU_math_uni_major = min(mate_actual)
	
	* Language component of PSU score 
	bysort uni_code : egen mean_PSU_lang_uni = mean(lyc_actual)
	bysort uni_code: egen min_PSU_lang_uni = min(lyc_actual)
	
	bysort uni_code codigo_carrera : egen mean_PSU_lang_uni_major = mean(lyc_actual)
	bysort uni_code codigo_carrera: egen min_PSU_lang_uni_major = min(lyc_actual)
	
	keep  sigla_universidad uni_code sede_carrera codigo_carrera nombre_carrera año_proceso mean_PSU* min_PSU_* 
	gen long source_order_uni = _n
	sort uni_code codigo_carrera source_order_uni
	by uni_code codigo_carrera: keep if _n==1
	drop source_order_uni
	
	label var mean_PSU_score_uni "average PSU score of regular entrants in SUA uni in 2018"
	label var min_PSU_score_uni "min PSU score of regular entrants in SUA uni in 2018 "
	label var mean_PSU_score_uni_major "average PSU score of regular entrants in SUA uni/major in 2018"
	label var min_PSU_score_uni_major "min PSU score of regular entrants in SUA uni/major in 2018 "
	
	label var mean_PSU_math_uni "average PSU math of regular entrants in SUA uni in 2018"
	label var min_PSU_math_uni "min PSU math of regular entrants in SUA uni in 2018 "
	label var mean_PSU_math_uni_major "average PSU math of regular entrants in SUA uni/major in 2018"
	label var min_PSU_math_uni_major "min PSU math of regular entrants in SUA uni/major in 2018 "
	
		
	label var mean_PSU_lang_uni "average PSU lang of regular entrants in SUA uni in 2018"
	label var min_PSU_lang_uni "min PSU lang of regular entrants in SUA uni in 2018 "
	label var mean_PSU_lang_uni_major "average PSU lang of regular entrants in SUA uni/major in 2018"
	label var min_PSU_lang_uni_major "min PSU lang of regular entrants in SUA uni/major in 2018 "
	
	save "$dataTemp/mean_psu_score_unimajor_level", replace



********************************************************************************
* End old do-file "open_pace_applications.do"
********************************************************************************


***** generate dataset with quality of PACE admission for each mrun

use "$dataTemp/C_POSTULACIONES_SELECCION_PSU_CUPOS_PACE_2018_PRIV_MRUN.dta"

gen hugo=1 if situacion_postulante =="P"
replace hugo=0 if situacion_postulante=="C"

bysort mrun: egen admitted_SUA_pace=max(hugo)

label var admitted_SUA_pace "admitted or waiting list through pace"
drop hugo



** for each applicant, create variable "selectivity of university got admitted to  through PACE"

replace sigla_universidad="UACH" if sigla_universidad=="UACh"
replace sigla_universidad="UPA" if sigla_universidad=="UPLA"

merge m:1 sigla_universidad codigo_carrera using "$dataTemp/mean_psu_score_unimajor_level.dta"

drop if _merge==2

drop _merge


*** estado_de_la_preferencia=24 means admitted
*** estado_de_la_preferencia=25 means on waiting list
*** If you don't have an admission (25), but you are admitted_SUA_pace==1, then assign as an admission the degree programme in which you are on waiting list (25). This way we keep all those who eventually were admitted and have no missing info on degree-program quality.

count if situacion_postulante =="C" & estado_de_la_preferencia ==24 // 0 students
gen hugo=min_PSU_score_uni_major if estado_de_la_preferencia ==24
bysort mrun: egen select_adm_uni_major_PACE=max(hugo) 
drop hugo
label var select_adm_uni_major_PACE "Min PSU to enter uni-major to which admitted through PACE"

gen hugo=min_PSU_score_uni_major if estado_de_la_preferencia ==25 & admitted_SUA_pace==1 & select_adm_uni_major_PACE==.
* since I don't know in which one he/she was eventually admitted, I take the average quality of those he/she was admitted to
bysort mrun: egen mean_hugo=mean(hugo)
replace select_adm_uni_major_PACE=mean_hugo if select_adm_uni_major_PACE==.
drop hugo mean_hugo

gen hugo=mean_PSU_score_uni_major if estado_de_la_preferencia ==24
bysort mrun: egen quality_adm_uni_major_PACE=max(hugo)
drop hugo
label var quality_adm_uni_major_PACE "Avg PSU of uni-major to which admitted through PACE"
* never the case that we have mean_PSU_score_uni_major info when estado_preferenceia==25 and quality_adm_uni_major_PACE==.



gen hugo=min_PSU_score_uni if   estado_de_la_preferencia ==24
bysort mrun: egen select_adm_uni_PACE=max(hugo)
drop hugo
label var select_adm_uni_PACE "Min PSU to enter uni to which admitted through PACE"
gen hugo=min_PSU_score_uni if   estado_de_la_preferencia ==25 & admitted_SUA_pace==1 & select_adm_uni_PACE==.
* since I don't know in which one he/she was eventually admitted, I take the average quality of those he/she was admitted to
bysort mrun: egen mean_hugo=mean(hugo)
replace select_adm_uni_PACE=mean_hugo if select_adm_uni_PACE==.
drop hugo mean_hugo


gen hugo=mean_PSU_score_uni if   estado_de_la_preferencia ==24
bysort mrun: egen quality_adm_uni_PACE=max(hugo)
drop hugo
label var quality_adm_uni_PACE "Avg PSU of uni to which admitted through PACE"
gen hugo=mean_PSU_score_uni if   estado_de_la_preferencia ==25 & admitted_SUA_pace==1 & quality_adm_uni_PACE==.
* since I don't know in which one he/she was eventually admitted, I take the average quality of those he/she was admitted to
bysort mrun: egen mean_hugo=mean(hugo)
replace quality_adm_uni_PACE=mean_hugo if quality_adm_uni_PACE==.
drop hugo mean_hugo






gen hugo=preferencia if   estado_de_la_preferencia ==24
bysort mrun: egen highest_pref_order_PACE=max(hugo)
drop hugo
label var highest_pref_order_PACE "highest pref order of uni-major to which admitted through PACE"
gen hugo=preferencia if   estado_de_la_preferencia ==25 & admitted_SUA_pace==1 & highest_pref_order_PACE==.
* since I don't know in which one he/she was eventually admitted, I take the average quality of those he/she was admitted to
bysort mrun: egen mean_hugo=mean(hugo)
replace highest_pref_order_PACE=mean_hugo if highest_pref_order_PACE==.
drop hugo mean_hugo

** keep information on codigo_carrera nombre_carrera sede_carrera sigla_universidad of the programme to which student is admitted through PACE
gen hugo=codigo_carrera if estado_de_la_preferencia ==24
bysort mrun: egen major_code_PACE=max(hugo)
drop hugo
label var major_code_PACE "Code of major to which admitted through PACE"
gen hugo=codigo_carrera if estado_de_la_preferencia ==25 & admitted_SUA_pace==1 & major_code_PACE==.
* assume that you get into your most preferred one if you're on the waiting list
bysort mrun (preferencia): gen order=_n if hugo!=.
gen which_hugo=hugo if order==1
drop order
bysort mrun: egen which_hugo2=max(which_hugo)
replace major_code_PACE=which_hugo2 if major_code_PACE==.
drop which_hugo which_hugo2 hugo

gen hugo=nombre_carrera if estado_de_la_preferencia ==24
sort mrun hugo
by mrun: replace hugo=hugo[_N]
rename hugo major_name_PACE
label var major_name_PACE "Name of major to which admitted through PACE"
gen hugo=nombre_carrera if estado_de_la_preferencia ==25 & admitted_SUA_pace==1 & major_name_PACE==""
* assume that you get into your most preferred one if you're on the waiting list
bysort mrun (preferencia): gen order=_n if hugo!=""
gen which_hugo=hugo if order==1
drop order
sort mrun which_hugo
by mrun: replace which_hugo=which_hugo[_N]
rename which_hugo which_hugo2

replace major_name_PACE=which_hugo2 if major_name_PACE==""
drop which_hugo which_hugo2 hugo

** sede_carrera of the programme to which student is admitted through PACE
gen hugo=sede_carrera if estado_de_la_preferencia ==24
sort mrun hugo
by mrun: replace hugo=hugo[_N]
rename hugo sede_carrera_PACE
label var sede_carrera_PACE "Location of seat to which admitted through PACE"
gen hugo=sede_carrera if estado_de_la_preferencia ==25 & admitted_SUA_pace==1 & sede_carrera_PACE==""
* assume that you get into your most preferred one if you're on the waiting list
bysort mrun (preferencia): gen order=_n if hugo!=""
gen which_hugo=hugo if order==1
drop order
sort mrun which_hugo
by mrun: replace which_hugo=which_hugo[_N]
rename which_hugo which_hugo2

replace sede_carrera_PACE=which_hugo2 if sede_carrera_PACE==""
drop which_hugo which_hugo2 hugo


** sigla_universidad of the university to which student is admitted through PACE
gen hugo=sigla_universidad if estado_de_la_preferencia ==24
sort mrun hugo
by mrun: replace hugo=hugo[_N]
rename hugo sigla_universidad_PACE
label var sigla_universidad_PACE "University to which admitted through PACE"
gen hugo=sigla_universidad if estado_de_la_preferencia ==25 & admitted_SUA_pace==1 & sigla_universidad_PACE==""
* assume that you get into your most preferred one if you're on the waiting list
bysort mrun (preferencia): gen order=_n if hugo!=""
gen which_hugo=hugo if order==1
drop order
sort mrun which_hugo
by mrun: replace which_hugo=which_hugo[_N]
rename which_hugo which_hugo2

replace sigla_universidad_PACE=which_hugo2 if sigla_universidad_PACE==""
drop which_hugo which_hugo2 hugo


** keep one observation per student
keep mrun admitted_SUA_pace select_adm_uni_major_PACE select_adm_uni_PACE quality_adm_uni_major_PACE quality_adm_uni_PACE highest_pref_order_PACE major_code_PACE major_name_PACE sede_carrera_PACE sigla_universidad_PACE
*keep mrun admitted_SUA_pace select_adm_uni_major_PACE major_code_PACE major_name_PACE sede_carrera_PACE sigla_universidad_PACE
duplicates drop

saveold "$dataTemp/admitted_SUA_pace.dta", replace
















clear

use "$dataTemp/20180829_Matricula_Ed_Superior_2018_PRIV_MRUN.dta"
keep if anio_mat_pri_anio ==2018
duplicates drop

drop if mrun==" "
destring mrun, replace

gen hugo=1 if tipo_inst_2=="Universidades CRUCH"
replace hugo=0 if hugo==.

*crash
*gen  top_uni =1 if nomb_inst =="PONTIFICIA UNIVERSIDAD CATOLICA DE CHILE"
*replace top_uni=1 if  nomb_inst =="UNIVERSIDAD DE CHILE"
*replace top_uni=0 if top_uni==.

bysort mrun: egen cruch=max(hugo)




keep mrun cruch
duplicates drop 

saveold  "$dataTemp/top_enrollment_2018.dta", replace










****** create dataset with quality of university to which you are admitted through the regular channel

clear

use "$dataTemp/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_MRUN.dta"



merge m:1 sigla_universidad codigo_carrera using "$dataTemp/mean_psu_score_unimajor_level.dta"
* alternatively:
* merge m:m sigla_universidad  using "$datamean_psu_score_unimajor_level.dta"
* this way we match all!

drop _merge

** for each applicant, create 3 variables: top_choice_mean_PSU; top_3_choice_mean_PSU, top_all_choice_mean_PSU

gen hugo=mean_PSU_score_uni_major if preferencia ==1
bysort mrun: egen top_choice_mean_PSU=max(hugo)
drop hugo

gen top_3=1 if preferencia<=3

bysort mrun top_3: egen hugo=mean(mean_PSU_score_uni_major)

replace  hugo=. if top_3==.

drop top_3
bysort mrun: egen top_3_choice_mean_PSU=max(hugo)

drop hugo

bysort mrun: egen hugo=mean(mean_PSU_score_uni_major)
rename hugo top_all_choice_mean_PSU


** for each applicant, create 3 variables: top_choice_min_PSU; top_3_choice_min_PSU, top_all_choice_min_PSU

gen hugo=min_PSU_score_uni_major if preferencia ==1
bysort mrun: egen top_choice_min_PSU=max(hugo)
drop hugo

gen top_3=1 if preferencia<=3

bysort mrun top_3: egen hugo=mean(min_PSU_score_uni_major)

replace  hugo=. if top_3==.

drop top_3
bysort mrun: egen top_3_choice_min_PSU=max(hugo)

drop hugo

bysort mrun: egen hugo=mean(min_PSU_score_uni_major)
rename hugo top_all_choice_min_PSU





** for each applicant, create variable "selectivity of university got admitted to"


gen hugo=1 if situacion_postulante =="P"
replace hugo=0 if situacion_postulante=="C"

bysort mrun: egen admitted_SUA_regular=max(hugo)

label var admitted_SUA_regular "admitted or waiting list through regular"
drop hugo




gen hugo=min_PSU_score_uni_major if   estado_de_la_preferencia ==24
bysort mrun: egen select_adm_uni_major=max(hugo)
drop hugo
label var select_adm_uni_major "Min PSU of regular entrants in uni-major to which admitted through regular channel"
gen hugo=min_PSU_score_uni_major if   estado_de_la_preferencia ==25 & admitted_SUA_regular==1 & select_adm_uni_major==.
* since I don't know in which one he/she was eventually admitted, I take the average quality of those he/she was admitted to
bysort mrun: egen mean_hugo=mean(hugo)
replace select_adm_uni_major=mean_hugo if select_adm_uni_major==.
drop hugo mean_hugo



gen hugo=mean_PSU_score_uni_major if   estado_de_la_preferencia ==24
bysort mrun: egen quality_adm_uni_major=max(hugo)
drop hugo
label var quality_adm_uni_major "Avg PSU of regular entrants in uni-major to which admitted through regular channel"
** never the case that estado_de_la_preferencia ==25 & admitted_SUA_regular==1 & mean_PSU_score_uni_major==.



gen hugo=min_PSU_score_uni if   estado_de_la_preferencia ==24
bysort mrun: egen select_adm_uni=max(hugo)
drop hugo
label var select_adm_uni "Min PSU of regular entrants in uni to which admitted through regular channel"
gen hugo=min_PSU_score_uni if   estado_de_la_preferencia ==25 & admitted_SUA_regular==1 & select_adm_uni==.
* since I don't know in which one he/she was eventually admitted, I take the average quality of those he/she was admitted to
bysort mrun: egen mean_hugo=mean(hugo)
replace select_adm_uni=mean_hugo if select_adm_uni==.
drop hugo mean_hugo



gen hugo=mean_PSU_score_uni if   estado_de_la_preferencia ==24
bysort mrun: egen quality_adm_uni=max(hugo)
drop hugo
label var quality_adm_uni "Avg PSU of regular entrants in uni to which admitted through regular channel"
gen hugo=mean_PSU_score_uni if   estado_de_la_preferencia ==25 & admitted_SUA_regular==1 & quality_adm_uni==.
* since I don't know in which one he/she was eventually admitted, I take the average quality of those he/she was admitted to
bysort mrun: egen mean_hugo=mean(hugo)
replace quality_adm_uni=mean_hugo if quality_adm_uni==.
drop hugo mean_hugo





gen hugo=preferencia if   estado_de_la_preferencia ==24
bysort mrun: egen highest_pref_order_regular=max(hugo)
drop hugo
label var highest_pref_order_regular "highest pref order of uni-major to which admitted through regular channel"
gen hugo=preferencia if   estado_de_la_preferencia ==25 & admitted_SUA_regular==1 & highest_pref_order_regular==.
* since I don't know in which one he/she was eventually admitted, I take the average quality of those he/she was admitted to
bysort mrun: egen mean_hugo=mean(hugo)
replace highest_pref_order_regular=mean_hugo if highest_pref_order_regular==.
drop hugo mean_hugo

** generate major code and major name of admission codigo_carrera nombre_carrera
gen hugo=codigo_carrera if estado_de_la_preferencia==24
bysort mrun: egen major_code_regular=max(hugo)
drop hugo
label var major_code_regular  "Code of major to which admitted through regular"
gen hugo=codigo_carrera if  estado_de_la_preferencia ==25 & admitted_SUA_regular==1 & major_code_regular==.
* assume you get admitted to your most preferred one
bysort mrun (preferencia): gen order=_n if hugo!=.
gen which_hugo=hugo if order==1
drop order
bysort mrun: egen which_hugo2=max(which_hugo)
replace major_code_regular=which_hugo2 if major_code_regular==.
drop which_hugo which_hugo2 hugo






gen hugo=nombre_carrera if estado_de_la_preferencia ==24
sort mrun hugo
by mrun: replace hugo=hugo[_N]
rename hugo major_name_regular
label var major_name_regular "Name of major to which admitted through regular"
gen hugo=nombre_carrera if estado_de_la_preferencia ==25 & admitted_SUA_regular==1 & major_name_regular==""
* assume that you get into your most preferred one if you're on the waiting list
bysort mrun (preferencia): gen order=_n if hugo!=""
gen which_hugo=hugo if order==1
drop order
sort mrun which_hugo
by mrun: replace which_hugo=which_hugo[_N]
rename which_hugo which_hugo2

replace major_name_regular=which_hugo2 if major_name_regular==""
drop which_hugo which_hugo2 hugo



gen hugo=sede_carrera if estado_de_la_preferencia ==24
sort mrun hugo
by mrun: replace hugo=hugo[_N]
rename hugo sede_carrera_regular
label var sede_carrera_regular "Location of seat to which admitted through regular"
gen hugo=sede_carrera if estado_de_la_preferencia ==25 & admitted_SUA_regular==1 & sede_carrera_regular==""
* assume that you get into your most preferred one if you're on the waiting list
bysort mrun (preferencia): gen order=_n if hugo!=""
gen which_hugo=hugo if order==1
drop order
sort mrun which_hugo
by mrun: replace which_hugo=which_hugo[_N]
rename which_hugo which_hugo2

replace sede_carrera_regular=which_hugo2 if sede_carrera_regular==""
drop which_hugo which_hugo2 hugo


gen hugo=sigla_universidad if estado_de_la_preferencia ==24
sort mrun hugo
by mrun: replace hugo=hugo[_N]
rename hugo sigla_universidad_regular
label var sigla_universidad_regular "University to which admitted through regular"
gen hugo=sigla_universidad if estado_de_la_preferencia ==25 & admitted_SUA_regular==1 & sigla_universidad_regular==""
* assume that you get into your most preferred one if you're on the waiting list
bysort mrun (preferencia): gen order=_n if hugo!=""
gen which_hugo=hugo if order==1
drop order
sort mrun which_hugo
by mrun: replace which_hugo=which_hugo[_N]
rename which_hugo which_hugo2

replace sigla_universidad_regular=which_hugo2 if sigla_universidad_regular==""
drop which_hugo which_hugo2 hugo






keep mrun top_3_choice_mean_PSU top_all_choice_mean_PSU top_choice_mean_PSU  top_3_choice_min_PSU top_all_choice_min_PSU top_choice_min_PSU   select_adm_uni  select_adm_uni_major quality_adm_uni quality_adm_uni_major  highest_pref_order_regular admitted_SUA_regular major_code_regular major_name_regular sede_carrera_regular sigla_universidad_regular

*keep mrun select_adm_uni_major admitted_SUA_regular major_code_regular major_name_regular sede_carrera_regular sigla_universidad_regular

gen long source_order_regular = _n
sort mrun source_order_regular
by mrun: keep if _n==1
drop source_order_regular

label var top_3_choice_mean_PSU "Quality (mean PSU) of top 3 uni-major regular application preferences"
label var top_choice_mean_PSU "Quality (mean PSU) of top uni-major regular application preference"
label var top_all_choice_mean_PSU "Quality (mean PSU) of uni-major application preferences"


label var top_3_choice_min_PSU "Selectivity (min PSU) of top 3 uni-major regular application preferences"
label var top_choice_min_PSU "Selectivity (min PSU) of top uni-major regular application preference"
label var top_all_choice_min_PSU "Selectivity (min PSU) of uni-major application preferences"

saveold "$dataTemp/regular_applications_uni_quality.dta", replace

