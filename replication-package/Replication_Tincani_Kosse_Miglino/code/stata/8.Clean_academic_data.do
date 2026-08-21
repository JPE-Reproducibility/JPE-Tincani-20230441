*******************************************************************************
* DO-FILE DESCRIPTION:
* This do-file cleans datasets on enrollment and graduation.
* It merges them with our dataset on experimental students.
********************************************************************************
global last_year_enrollment 22


*----------------------------------------------------------------------------------------------------------------------------------------------------------------------
**#----------------------------------------------------------------- APPLICATIONS -------------------------------------------------------------------------------------

**#------------1. GENERATE STUDENT-LEVEL DATASET WITH INFORMATION ON QUALITY AND FIELD OF STUDY OF APPLICATION SENT THROUGH PACE AND REGULAR --------------------------

**#------------2. GENERATE CODIGO-CARRERA-LEVEL DATASET WITH INFORMATION ON QUALITY AND FIELD OF STUDY OF ALL PROGRAMS THAT APPEAR           ------------------------//
**#------------   IN PACE APPLICATIONS FROM OUR SAMPLE                                                                                       --------------------------

**#------------3. GENERATE CODIGO-CARRERA-LEVEL DATASET WITH INFORMATION ON QUALITY AND FIELD OF STUDY OF ALL PROGRAMS THAT APPEAR           ------------------------//
**#------------   IN REGULAR APPLICATIONS FROM OUR SAMPLE                                                                                    --------------------------
*----------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Generate a dataset where for each student we have their applications and admissions through the regular and pace channels, and for each application we know: selectivity AND field of study according to oecd categorizaion

** Set globals
global controls simce_avg_st female age alumno_prioritario neverfailed modalidad 

use "$dataTemp/basefinal_merged_all_clean.dta", clear
keep if in_experimental_schools==1


preserve 
		import delimited "$dataRaw/PSU/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_MRUN.csv", clear		
		save "$dataTemp/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_MRUN.dta", replace

		
		import delimited "$dataRaw/PSU/C_POSTULACIONES_SELECCION_PSU_CUPOS_PACE_2018_PRIV_MRUN.csv", clear	
		save "$dataTemp/C_POSTULACIONES_SELECCION_PSU_CUPOS_PACE_2018_PRIV_MRUN.dta", replace
		
		
		use "$dataTemp/20180829_Matricula_Ed_Superior_2018_PRIV_MRUN.dta", clear 
		keep nomb_carrera oecd_area oecd_subarea  area_conocimiento area_carrera_generica 
		duplicates drop
	    recast str195 nomb_carrera, force
		save "$dataTemp/majors_fields_all_enrollments_2018.dta", replace 
		
		keep nomb_carrera oecd_area
		duplicates drop 
		save "$dataTemp/majors_oecd_area_all_enrollments_2018.dta", replace 
		
restore 

	
**************************************************
* FIELD OF STUDY PACE CHANNEL APPLICATIONS
**************************************************
drop codigo_carrera nombre_carrera sigla_universidad sigla_universidad_PACE sigla_universidad_regular mean_PSU_score_uni mean_PSU_score_uni_major  
	
	
merge 1:m mrun using "$dataTemp/C_POSTULACIONES_SELECCION_PSU_CUPOS_PACE_2018_PRIV_MRUN.dta", keepusing( nombre_carrera preferencia codigo_carrera  sigla_universidad)
drop if _merge==2 
drop _merge 
duplicates report mrun preferencia //ok
rename nombre_carrera nomb_carrera 
merge m:1 nomb_carrera using "$dataTemp/majors_oecd_area_all_enrollments_2018.dta"
drop if _merge==2 
duplicates report mrun preferencia //ok
drop _merge 


rename preferencia preferencia_PACE
rename codigo_carrera codigo_carrera_PACE 
rename nomb_carrera nombre_carrera_PACE 
rename sigla_universidad sigla_universidad_PACE
rename oecd_area oecd_area_PACE 
count if oecd_area_PACE =="" & preferencia_PACE!=.

** Save the lists of carreras for which we have missing area:
preserve
keep if oecd_area_PACE =="" & preferencia_PACE!=.
keep nombre_carrera_PACE codigo_carrera_PACE 
duplicates drop 
sort nombre_carrera_PACE
save "$dataTemp/PACE_major_apps_with_missing_oecd_area.dta", replace 
sort nombre_carrera_PACE
*outsheet nombre_carrera_PACE codigo_carrera_PACE using "$dataRaw/major_class/PACE_major_apps_with_missing_oecd_area.csv", delim(,) replace
 
restore 



merge m:1 codigo_carrera_PACE using "$dataRaw/major_class/PACE_major_apps_with_missing_oecd_area_manually_added_area.dta", update
duplicates report mrun preferencia_PACE //ok
drop _merge 
count if oecd_area_PACE =="" & preferencia_PACE!=. //ok

* fix conflicting oecd_area_PACE spellings:
replace oecd_area_PACE="Ciencias Sociales, Enseñanza Comercial y Derecho" if oecd_area_PACE=="Ciencias Sociales"

** merge in quality using sigla_universidad and codigo_carrera_PACE
rename sigla_universidad_PACE sigla_universidad 
rename codigo_carrera_PACE codigo_carrera 
replace sigla_universidad="UACH" if sigla_universidad=="UACh"

merge m:1 sigla_universidad codigo_carrera  using "$dataTemp/mean_psu_score_unimajor_level", keepusing(mean_PSU_score_uni_major)
drop if _merge==2 
duplicates report mrun preferencia_PACE //ok


	
gen STEM_PACE=1 if oecd_area_PACE=="Ciencias" | oecd_area_PACE=="Ingeniería, Industria y Construcción" | oecd_area_PACE=="Salud y Servicios Sociales" | oecd_area_PACE=="Agricultura"
replace STEM_PACE=0 if STEM_PACE==. & oecd_area_PACE!=""
label var STEM_PACE "Sciences, Engineering, or Health"

**************************************************************************************************
* SAVE CARRERA-LEVEL DATASET WITH QUALITY AND FIELD OF STUDY OF APPLICATIONS THROUGH PACE CHANNEL
**************************************************************************************************
preserve
rename oecd_area_PACE oecd_area
rename STEM_PACE STEM 
keep sigla_universidad codigo_carrera mean_PSU_score_uni_major oecd_area STEM 
drop if codigo_carrera==.
duplicates drop 
save "$dataTemp/field_quality_carrera_PACE", replace 
restore 


rename sigla_universidad sigla_universidad_PACE 
rename codigo_carrera codigo_carrera_PACE 
rename mean_PSU_score_uni_major  mean_PSU_score_uni_major_PACE



** Make dataset wide 
sort mrun preferencia_PACE 
gen oecd_area_PACE_top1=oecd_area_PACE if preferencia_PACE==1 
bysort mrun: replace oecd_area_PACE_top1= oecd_area_PACE_top1[1] if missing(oecd_area_PACE_top1)
label var oecd_area_PACE_top1 "Field of top 1 preference in PACE application list"

sort mrun preferencia_PACE 
gen oecd_area_PACE_top2=oecd_area_PACE if preferencia_PACE==2
bysort mrun: replace oecd_area_PACE_top2= oecd_area_PACE_top2[2] if missing(oecd_area_PACE_top2)
label var oecd_area_PACE_top2 "Field of second preference from the top in PACE application list"

sort mrun preferencia_PACE 
gen oecd_area_PACE_top3=oecd_area_PACE if preferencia_PACE==3
bysort mrun: replace oecd_area_PACE_top3= oecd_area_PACE_top3[3] if missing(oecd_area_PACE_top3)
label var oecd_area_PACE_top3 "Field of third preference from the top in PACE application list"




sort mrun preferencia_PACE 
gen hugo=STEM_PACE if preferencia_PACE==1 
bysort mrun: egen STEM_PACE_top1= max(hugo) 
drop hugo 
label var STEM_PACE_top1 "Top preference in PACE application list is Sciences, Engineering, or Health"

sort mrun preferencia_PACE 
bysort mrun: egen hugo = mean(STEM_PACE) if preferencia_PACE<=3 & preferencia_PACE!=.
bysort mrun: egen STEM_PACE_within_top3=max(hugo)
drop hugo
label var STEM_PACE_within_top3 "Fraction of top 3 preferences in PACE application list that are in Sciences, Engineering, or Health"



sort mrun preferencia_PACE 
gen hugo=mean_PSU_score_uni_major_PACE if preferencia_PACE==1 
bysort mrun: egen mean_PSU_PACE_top1= max(hugo) 
drop hugo 
label var mean_PSU_PACE_top1 "Selectivity (mean PSU of regular entrants) of top preference in PACE application list"

sort mrun preferencia_PACE 
bysort mrun: egen hugo = mean(mean_PSU_score_uni_major_PACE) if preferencia_PACE<=3 & preferencia_PACE!=.
bysort mrun: egen mean_PSU_PACE_within_top3=max(hugo)
drop hugo
label var mean_PSU_PACE_within_top3 "Average selectivity (mean PSU of regular entrants) of top three preference in PACE application list"





drop preferencia_PACE sigla_universidad_PACE codigo_carrera_PACE nombre_carrera_PACE oecd_area_PACE mean_PSU_score_uni_major_PACE

keep mrun oecd_area_PACE_top1 oecd_area_PACE_top2  oecd_area_PACE_top3 STEM_PACE_top1   STEM_PACE_within_top3  mean_PSU_PACE_top1  mean_PSU_PACE_within_top3 treatment rbd_basefinal $controls 
duplicates drop 



**************************************************
* FIELD OF STUDY REGULAR CHANNEL APPLICATIONS
**************************************************

merge 1:m mrun using "$dataTemp/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_MRUN.dta", keepusing(  nombre_carrera preferencia codigo_carrera   sigla_universidad)
drop if _merge==2
duplicates report mrun preferencia // not ok
drop _merge 
rename nombre_carrera nomb_carrera 
merge m:1 nomb_carrera using "$dataTemp/majors_oecd_area_all_enrollments_2018.dta"
drop if _merge==2 
drop _merge


rename preferencia preferencia_regular
rename codigo_carrera codigo_carrera_regular 
rename nomb_carrera nombre_carrera_regular 
rename sigla_universidad sigla_universidad_regular
rename oecd_area oecd_area_regular 
count if oecd_area_regular =="" & preferencia_regular!=.

merge m:1 codigo_carrera_regular using "$dataRaw/major_class/majors_regular_with_oecd_area", update 
drop if _merge==2 
drop _merge 

count if oecd_area_regular =="" & preferencia_regular!=.


** Save the lists of carreras for which we have missing area:
preserve
keep if oecd_area_regular =="" & preferencia_regular!=.
keep nombre_carrera_regular codigo_carrera_regular
duplicates drop 
sort nombre_carrera_regular 
save "$dataTemp/regular_major_apps_with_missing_oecd_area.dta", replace 
sort nombre_carrera_regular
outsheet nombre_carrera_regular codigo_carrera_regular using "$dataTemp/regular_major_apps_with_missing_oecd_area.csv", delim(,) replace
** Then manually add the oecd ara into the file  PACE_major_apps_with_missing_oecd_area_manually_added_area ans save to $dataRaw/major_class
restore 



merge m:1 codigo_carrera_regular using "$dataRaw/major_class/regular_major_apps_with_missing_oecd_area_manually_added_area.dta", update
drop if _merge==2
drop _merge 

count if oecd_area_regular =="" & preferencia_regular!=.

* fix conflicting oecd_area_regular spellings:
replace oecd_area_regular="Agricultura" if oecd_area_regular==" Agricultura"
replace oecd_area_regular="Salud y Servicios Sociales" if oecd_area_regular==" Salud y Servicios Sociales"
replace oecd_area_regular="Ciencias" if oecd_area_regular==" Ciencias"

** Generate STEM and non-STEM
gen STEM_regular=1 if oecd_area_regular=="Ciencias" | oecd_area_regular=="Ingeniería, Industria y Construcción" | oecd_area_regular=="Salud y Servicios Sociales"
replace STEM_regular=0 if STEM_regular==. & oecd_area_regular!=""
label var STEM_regular "Sciences, Engineering, or Health"
	
	
	
	
** merge in quality using sigla_universidad and codigo_carrera_PACE
rename sigla_universidad_regular sigla_universidad 
rename codigo_carrera_regular codigo_carrera 
replace sigla_universidad="UACH" if sigla_universidad=="UACh"

merge m:1 sigla_universidad codigo_carrera  using "$dataTemp/mean_psu_score_unimajor_level", keepusing(mean_PSU_score_uni_major)
drop if _merge==2 
duplicates report mrun preferencia_regular //ok


	
	
*****************************************************************************************************
* SAVE CARRERA-LEVEL DATASET WITH QUALITY AND FIELD OF STUDY OF APPLICATIONS THROUGH REGULAR CHANNEL
*****************************************************************************************************
preserve
rename oecd_area_regular oecd_area
rename STEM_regular STEM 
keep sigla_universidad codigo_carrera mean_PSU_score_uni_major oecd_area STEM 
drop if codigo_carrera==.
duplicates drop 
save "$dataTemp/field_quality_carrera_regular", replace 
restore 



rename sigla_universidad sigla_universidad_regular 
rename codigo_carrera codigo_carrera_regular
rename mean_PSU_score_uni_major  mean_PSU_score_uni_major_regular



** Make dataset wide 

sort mrun preferencia_regular 
gen oecd_area_regular_top1=oecd_area_regular if preferencia_regular==1 
bysort mrun: replace oecd_area_regular_top1= oecd_area_regular_top1[1] if missing(oecd_area_regular_top1)
label var oecd_area_regular_top1 "Field of top 1 preference in regular application list"

sort mrun preferencia_regular 
gen oecd_area_regular_top2=oecd_area_regular if preferencia_regular==2
bysort mrun: replace oecd_area_regular_top2= oecd_area_regular_top2[2] if missing(oecd_area_regular_top2)
label var oecd_area_regular_top2 "Field of second preference from the top in PACE application list"

sort mrun preferencia_regular 
gen oecd_area_regular_top3=oecd_area_regular if preferencia_regular==3
bysort mrun: replace oecd_area_regular_top3= oecd_area_regular_top3[3] if missing(oecd_area_regular_top3)
label var oecd_area_regular_top3 "Field of third preference from the top in regular application list"




sort mrun preferencia_regular
gen hugo=STEM_regular if preferencia_regular==1 
bysort mrun: egen STEM_regular_top1= max(hugo) 
drop hugo 
label var STEM_regular_top1 "Top preference in regular application list is Sciences, Engineering, or Health"

sort mrun preferencia_regular 
bysort mrun: egen hugo = mean(STEM_regular) if preferencia_regular<=3 & preferencia_regular!=.
bysort mrun: egen STEM_regular_within_top3=max(hugo)
drop hugo
label var STEM_regular_within_top3 "Fraction of top 3 preferences in regular application list that are in Sciences, Engineering, or Health"



sort mrun preferencia_regular 
gen hugo=mean_PSU_score_uni_major_regular if preferencia_regular==1 
bysort mrun: egen mean_PSU_regular_top1= max(hugo) 
drop hugo 
label var mean_PSU_regular_top1 "Selectivity (mean PSU of regular entrants) of top preference in regular application list"

sort mrun preferencia_regular 
bysort mrun: egen hugo = mean(mean_PSU_score_uni_major_regular) if preferencia_regular<=3 & preferencia_regular!=.
bysort mrun: egen mean_PSU_regular_within_top3=max(hugo)
drop hugo
label var mean_PSU_regular_within_top3 "Average selectivity (mean PSU of regular entrants) of top three preference in regular application list"




drop preferencia_regular sigla_universidad_regular codigo_carrera_regular nombre_carrera_regular oecd_area_regular mean_PSU_score_uni_major_regular

keep mrun oecd_area_regular_top1 oecd_area_regular_top2  oecd_area_regular_top3 STEM_regular_top1   STEM_regular_within_top3  mean_PSU_regular_top1  mean_PSU_regular_within_top3 oecd_area_PACE_top1 oecd_area_PACE_top2  oecd_area_PACE_top3 STEM_PACE_top1   STEM_PACE_within_top3  mean_PSU_PACE_top1  mean_PSU_PACE_within_top3 treatment rbd_basefinal $controls 
duplicates drop 


**************************************************************************************************
* SAVE STUDENT-LEVEL DATASET WITH QUALITY AND FIELD OF STUDY OF APPLICATIONS THROUGH BOTH CHANNELS
**************************************************************************************************
save "$dataTemp/data_experimental_applications_quality_field.dta", replace 



*-------------------------------------------------------------------------------
**# CLEAN APPLICATION PREFERENCE LISTS FOR PACE AND NON-PACE
*-------------------------------------------------------------------------------
/*
For metadata see
ER_Alumnos_PSU_2016_2019_PRIV_MRUN_(C_POSTULACION_SELECCION_CUPOS_PACE).pdf
ER_Alumnos_PSU_2004_2019_PRIV_MRUN_(C_POSTULACION_SELECCION_CUPOS_REGULARES).pdf
*/
* Clean applications
foreach k in PACE regular {
	if "`k'"=="PACE" {
		import delimited  "$dataRaw/PSU/C_POSTULACIONES_SELECCION_PSU_CUPOS_PACE_2018_PRIV_MRUN.csv", clear
	}
	if "`k'"=="regular" {
        import delimited "$dataRaw/PSU/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_MRUN.csv", clear
	}
    merge m:1 mrun using "$dataTemp/basefinal_merged_all_clean.dta"
    keep if _merge==3
    drop _merge
    preserve 
    keep sede_carrera sigla_universidad in_experimental_schools
    collapse in_experimental_schools, by(sede_carrera sigla_universidad)
    drop in_experimental_schools
    save "$dataTemp/ranking_applications_university_municipality_`k'.dta", replace
    restore
    preserve 
    keep nom_com_rbd nom_deprov_rbd in_experimental_schools
    collapse in_experimental_schools, by(nom_com_rbd nom_deprov_rbd)
    drop in_experimental_schools
    save "$dataTemp/ranking_applications_high_school_`k'.dta", replace
    restore
    lab var preferencia "Ranking in application list"
    save "$dataTemp/ranking_applications_`k'.dta", replace
}


import delimited "$dataRaw/List_selective_colleges/universidades.csv", clear 
rename sigla sigla_universidad
drop if sigla_universidad==""
duplicates tag sigla, gen(dup)
drop if dup>0
drop dup
rename nombre nombre_universidad
keep sigla_universidad nombre_universidad
*save "$dataRaw/List_selective_colleges/universidades.dta", replace

* IMPORTANT!
* Need key licence to run the following. We have saved the output of the geocoding.
*do "$do_files/8.Geolocalize.do"

* Compute distance between high schools and universities in which students enrolled
import delimited "$dataRawPublic/Enrollment/20220719_Matrícula_Ed_Superior_2018_PUBL_MRUN.csv", delimiter(";") clear // upload all enrolled
gen long source_order = _n
sort mrun source_order
by mrun: keep if _n==1
drop source_order
rename codigo_demre codigo_carrera
keep mrun nomb_sede nomb_inst codigo_carrera
merge m:1 mrun using "$dataTemp/basefinal_merged_all_clean.dta", keepusing(mrun rbd_basefinal) // keep only experimental students
keep if _merge==3
drop _merge
merge m:1 rbd_basefinal using  "$dataRaw/Distance_and_transfers_to_universities/high_school_geocoded.dta" // obtain coordinates of high schools
drop if _merge==2
drop _merge
merge m:1 nomb_sede nomb_inst  using "$dataRaw/Distance_and_transfers_to_universities/enrollment_university_geocoded.dta"
drop if _merge==2
drop _merge
geodist latitude_high_school longitude_high_school latitude_university longitude_university, generate(distance_high_school_uni)
merge m:1 codigo_carrera using  "$dataTemp/mean_psu_score_unimajor_level"
drop if _merge==2
drop _merge
replace mean_PSU_score_uni_major=(mean_PSU_score_uni_major-500)/110
rename distance_high_school_uni distance_enrolled
rename mean_PSU_score_uni_major mean_PSU_score_enrolled
lab var distance_enrolled "Distance to degree program enrolled in 2018"
lab var mean_PSU_score_enrolled  "Selectivity of degree program enrolled in 2018"
keep mrun distance_enrolled mean_PSU_score_enrolled region_university town_university region_high_school town_high_school
save "$dataTemp/data_enrollment_distance_selectivity.dta", replace


* Compute distance between high schools and universities to which students applied
foreach k in PACE regular {
	local k_file = lower("`k'")
use "$dataTemp/ranking_applications_`k'.dta", replace
merge m:1 sede_carrera sigla_universidad using "$dataRaw/Distance_and_transfers_to_universities/ranking_applications_university_geocoded.dta"
drop if _merge==2
drop _merge
merge m:1 nom_com_rbd nom_deprov_rbd  using "$dataRaw/Distance_and_transfers_to_universities/ranking_applications_high_school_geocoded.dta"
drop if _merge==2
drop _merge
geodist latitude_high_school longitude_high_school latitude_university longitude_university, generate(distance_high_school_uni)
drop mean_PSU_score_uni_major
merge m:1 codigo_carrera using "$dataTemp/field_quality_carrera_`k'.dta", nogen
replace mean_PSU_score_uni_major=(mean_PSU_score_uni_major-500)/110
gen slot_assigned=0
replace slot_assigned=1 if estado_de_la_preferencia==24
bys mrun: gen num_listed_preferences=_N
lab var num_listed_preferences "Number of listed preferences in application"
bys mrun: egen num_colleges=nvals(sigla_universidad)
lab var num_colleges "Number of different colleges listed in applications"
bys mrun: egen distance_average=mean(distance_high_school_uni)
lab var distance_average "Average distance from degree programs listed in applications"
bys mrun: egen fraction_STEM=mean(STEM)
lab var fraction_STEM "Fraction of STEM in degree programs listed in applications"
encode oecd_area, gen(oecd_area_num)
tab oecd_area_num, gen(oecd_area_)
su oecd_area_num, d
di r(max)
forvalues n=1(1)`r(max)'{
	bys mrun: egen fraction_oecd_area_`n'=mean(oecd_area_`n')
}
bys mrun: egen mean_PSU_score_avg=mean(mean_PSU_score_uni_major)
lab var mean_PSU_score_avg "Selectivity of degree programs listed in applications"
gen codigo_carrera_preferred_temp= codigo_carrera if preferencia==1 // course 1st in the ranking
bys mrun: egen codigo_carrera_preferred=mean(codigo_carrera_preferred_temp)
lab var codigo_carrera_preferred "Code course preferred"
gen town_university_pref_temp= town_university if preferencia==1 // town 1st in the ranking
bys mrun: egen town_university_preferred=mode(town_university_pref_temp)
lab var town_university_preferred "Top-listed municipality"
gen distance_preferred_temp= distance_high_school_uni if preferencia==1 // distance 1st in the ranking
bys mrun: egen distance_preferred=mode(distance_preferred_temp)
lab var distance_preferred "Distance from top-listed degree program"
gen STEM_preferred_temp= STEM if preferencia==1 // STEM 1st in the ranking
bys mrun: egen STEM_preferred=mean(STEM_preferred_temp)
lab var STEM_preferred "Top-listed degree program is STEM"
gen mean_PSU_score_pref_temp= mean_PSU_score_uni_major if preferencia==1 // Study field 1st in the ranking
bys mrun: egen mean_PSU_score_preferred=mean(mean_PSU_score_pref_temp)
lab var mean_PSU_score_preferred "Selectivity of top-listed degree program"
gen mean_PSU_score_top2_temp= mean_PSU_score_uni_major if preferencia==2 // Study field 2nd in the ranking
bys mrun: egen mean_PSU_score_top2=mean(mean_PSU_score_top2_temp)
lab var mean_PSU_score_top2 "Selectivity of top-2 degree programs"
gen mean_PSU_score_top3_temp= mean_PSU_score_uni_major if preferencia==3 // Study field 3rd in the ranking
bys mrun: egen mean_PSU_score_top3=mean(mean_PSU_score_top3_temp)
lab var mean_PSU_score_top3 "Selectivity of top-3 degree programs"

gen  oecd_area_preferred_temp=  oecd_area if preferencia==1 // Study field 1st in the ranking
bys mrun: egen  oecd_area_preferred=mode(oecd_area_preferred_temp)
lab var  oecd_area_preferred "Study field area of top-listed degree program"
gen  oecd_area_top2_temp=  oecd_area if preferencia==2 // Study field 2nd in the ranking
bys mrun: egen  oecd_area_top2=mode( oecd_area_top2_temp)
lab var  oecd_area_top2 "Study field area of top-2 degree program"
gen  oecd_area_top3_temp=  oecd_area if preferencia==3 // Study field 3rd in the ranking
bys mrun: egen  oecd_area_top3=mode( oecd_area_top3_temp)
lab var  oecd_area_top3 "Study field area of top-3 degree program"

gen codigo_carrera_last_temp= codigo_carrera if preferencia==num_listed_preferences // course last in the ranking
bys mrun: egen codigo_carrera_last=mean(codigo_carrera_last_temp)
lab var codigo_carrera_last "Code course last-listed"
gen town_university_last_temp= town_university if preferencia==num_listed_preferences // town last in the ranking
bys mrun: egen town_university_last=mode(town_university_last_temp)
lab var town_university_last "Municipality of last-listed degree program"
gen distance_last_temp= distance_high_school_uni if preferencia==num_listed_preferences // distance last in the ranking
bys mrun: egen distance_last=mode(distance_last_temp)
lab var distance_last "Distance from last-listed degree program in application list"
gen STEM_last_temp= STEM if preferencia==num_listed_preferences // STEM last in the ranking
bys mrun: egen STEM_last=mean(STEM_last_temp)
lab var distance_last "Last-listed degree program is STEM"
gen mean_PSU_score_last_temp= mean_PSU_score_uni_major if preferencia==num_listed_preferences // Study field last in the ranking
bys mrun: egen mean_PSU_score_last=mean(mean_PSU_score_last_temp)
lab var mean_PSU_score_last "Selectivity of last degree program in application list"
gen  oecd_area_last_temp=  oecd_area if preferencia==num_listed_preferences // Study field last in the ranking
bys mrun: egen  oecd_area_last=mode(oecd_area_last_temp)
lab var  oecd_area_last "Study field area of last degree program in application list"

gen codigo_carrera_admitted_temp= codigo_carrera if slot_assigned==1 // course 1st in the ranking
bys mrun: egen codigo_carrera_admitted=mean(codigo_carrera_admitted_temp)
lab var codigo_carrera_admitted "Code course admitted"
gen town_university_adm_temp= town_university if slot_assigned==1 // town 1st in the ranking
bys mrun: egen town_university_admitted=mode(town_university_adm_temp)
lab var town_university_admitted "Municipality of degree program to which admitted"
gen region_university_adm_temp= region_university if slot_assigned==1 // region 1st in the ranking
bys mrun: egen region_university_admitted=mode(region_university_adm_temp)
lab var region_university_admitted "Region of degree program to which admitted"
gen distance_admitted_temp= distance_high_school_uni if slot_assigned==1 // distance 1st in the ranking
bys mrun: egen distance_admitted=mode(distance_admitted_temp)
lab var distance_admitted "Distance from degree program to which admitted"
gen STEM_admitted_temp= STEM if slot_assigned==1 // STEM 1st in the ranking
bys mrun: egen STEM_admitted=mean(STEM_admitted_temp)
lab var STEM_admitted "Degree program to which admitted is STEM"
gen mean_PSU_score_adm_temp= mean_PSU_score_uni_major if slot_assigned==1 // Selectivity 1st in the ranking
bys mrun: egen mean_PSU_score_admitted=mean(mean_PSU_score_adm_temp)
lab var mean_PSU_score_admitted "Selectivity of degree program to which admitted"
gen  oecd_area_adm_temp=  oecd_area if slot_assigned==1  // Study field 1st in the ranking
bys mrun: egen  oecd_area_admitted=mode(oecd_area_adm_temp)
lab var oecd_area_admitted "Study field area of degree program to which admitted"
gen preferred_municipality=0 if town_university_admitted!=""
replace preferred_municipality=1 if town_university_admitted==town_university_preferred & town_university_admitted!=""
gen preferred_course=0 if codigo_carrera_admitted!=.
replace preferred_course=1 if codigo_carrera_admitted==codigo_carrera_preferred & codigo_carrera_admitted!=.
gen app_admitted_temp=1  if slot_assigned==1 
bys mrun: egen app_admitted=mean(app_admitted_temp)
replace app_admitted=0 if app_admitted==.
lab var app_admitted "Student admitted to a listed degree program"
keep if in_experimental_schools==1
collapse num_listed_preferences num_colleges distance_average fraction_STEM mean_PSU_score_avg ///
         STEM_preferred distance_preferred mean_PSU_score_preferred mean_PSU_score_top2 mean_PSU_score_top3 ///
         STEM_last distance_last mean_PSU_score_last ///
		 STEM_admitted distance_admitted mean_PSU_score_admitted preferred_municipality preferred_course app_admitted codigo_carrera_admitted ///
		 (firstnm) region_university_admitted town_university_admitted region_high_school town_high_school ///
		           oecd_area_preferred oecd_area_admitted oecd_area_top2 oecd_area_top3 fraction_oecd_area_*, by(mrun)
lab var app_admitted "Student admitted to a  degree program in the application list"
lab var num_listed_preferences "Number of listed preferences in application"
lab var num_colleges "Number of different colleges listed in applications"
lab var distance_average "Average distance from degree programs listed in applications"
lab var fraction_STEM "Fraction of STEM in degree programs listed in applications"
lab var mean_PSU_score_avg "Selectivity of degree programs listed in applications"
lab var distance_preferred "Distance from degree program preferred"
lab var STEM_preferred "STEM degree program preferred"
lab var mean_PSU_score_preferred "Selectivity of degree program preferred"
lab var mean_PSU_score_top2 "Selectivity of degree program top-2 preference"
lab var mean_PSU_score_top3 "Selectivity of degree program top-3 preference"
lab var oecd_area_preferred "Study field area of degree program preferred"
lab var oecd_area_top2 "Study field area of degree program top 2 preference"
lab var oecd_area_top3 "Study field area of degree program top 3 preference"
lab var distance_admitted "Distance from degree program admitted"
lab var STEM_admitted "STEM degree program admitted"
lab var mean_PSU_score_admitted "Selectivity of degree program admitted"
lab var oecd_area_admitted "Study field area of degree program admitted"
lab var STEM_last "Last degree program in application list is STEM"
lab var distance_last "Distance to last degree program in application list"
lab var mean_PSU_score_last  "Selectivity of last degree program in application list"
save "$dataTemp/ranking_selected_applications_`k_file'.dta", replace
}

use "$dataTemp/ranking_selected_applications_regular.dta", clear
merge m:1 mrun using "$dataTemp/basefinal_merged_all_clean.dta", keepusing(sit_PSU)
drop if _merge==2
drop if sit_PSU==0 & _merge==3 // you shouldn't be able to apply if you didn't sit the PSU
drop _merge
drop sit_PSU
gen regular_application=1
gen pace_application=0
save "$dataTemp/ranking_selected_applications_regular_temp.dta", replace


use "$dataTemp/ranking_selected_applications_pace.dta", clear
merge m:1 mrun using "$dataTemp/basefinal_merged_all_clean.dta", keepusing(applied_SUA_pace)
drop if _merge==2
drop if applied_SUA_pace==0 & _merge==3 // eliminate invalid applications 
drop _merge
drop applied_SUA_pace
gen regular_application=0 
gen pace_application=1 
save "$dataTemp/ranking_selected_applications_pace_temp.dta", replace

use "$dataTemp/ranking_selected_applications_regular_temp.dta", clear
append using "$dataTemp/ranking_selected_applications_pace_temp.dta" 
save "$dataClean/data_applications_assignments.dta", replace

capture erase "$dataTemp/ranking_selected_applications_regular_temp.dta"
capture erase "$dataTemp/ranking_selected_applications_pace_temp.dta"



*-------------------------------------------------------------------------------
**# CLEAN ENROLLMENT DATA IN 2019, 2020, 2021 and 2022 (2nd to 5th year) 
*-------------------------------------------------------------------------------
forvalues y=18(1)$last_year_enrollment{
	
	import delimited "$dataRawPublic/Enrollment/20220719_Matrícula_Ed_Superior_20`y'_PUBL_MRUN.csv", delimiter(";") clear
    destring mrun, force replace
    drop if mrun==7035251 | mrun==16573091 | mrun==9955622
    drop if mrun==.
    bysort mrun: gen dup_num=_N
    drop if dup_num>1 & dup_num!=.
    keep mrun cod_inst nomb_inst tipo_inst_3 cod_carrera forma_ingreso cine_f_13_subarea dur_total_carr anio_ing_carr_act anio_ing_carr_ori
    rename cod_inst cod_inst_`y'
    lab var cod_inst_`y' "Code of institution enrolled in year `year'"
    rename nomb_inst nomb_inst_`y'
    lab var nomb_inst_`y' "Name of institution enrolled in year `year'"
    rename tipo_inst_3 tipo_inst_3_`y'
    lab var tipo_inst_3_`y' "Type of institution enrolled in year `year'"
	 rename cod_carrera cod_carrera_`y'
    lab var cod_carrera_`y' "Code of course enrolled in year `year'"
	rename forma_ingreso forma_ingreso_`y'
	lab var forma_ingreso_`y' "Admission Channel enrolled in year `year'"
    replace tipo_inst_3_`y'="Centros de Formación Técnica" if tipo_inst_3_`y'=="Centros de FormaciÃ³n TÃ©cnica" /*fixes text mistakes*/
    replace tipo_inst_3_`y'="Centros de Formación Técnica Estatal" if tipo_inst_3_`y'=="Centros de FormaciÃ³n TÃ©cnica Estatales"
	**------------------------- MAJOR + STEM ---------------------------------**
	gen cine_f_13_subarea_num = . 
	replace cine_f_13_subarea_num = 1 if cine_f_13_subarea == "Educación Comercial y Administración"
	replace cine_f_13_subarea_num = 2 if cine_f_13_subarea == "Ciencias Sociales y del Comportamiento"
	replace cine_f_13_subarea_num = 3 if cine_f_13_subarea == "Derecho"
	replace cine_f_13_subarea_num = 5 if cine_f_13_subarea == "Artes"
	replace cine_f_13_subarea_num = 6 if cine_f_13_subarea == "Educación"
	replace cine_f_13_subarea_num = 8 if cine_f_13_subarea == "Humanidades"
	replace cine_f_13_subarea_num = 9 if cine_f_13_subarea == "Periodismo e Información"
	replace cine_f_13_subarea_num = 10 if cine_f_13_subarea == "Arquitectura y Construcción"
	replace cine_f_13_subarea_num = 12 if cine_f_13_subarea == "Servicios personales"
	replace cine_f_13_subarea_num = 13 if cine_f_13_subarea == "Idiomas"
	replace cine_f_13_subarea_num = 15 if cine_f_13_subarea == "Bienestar"
	replace cine_f_13_subarea_num = 17 if cine_f_13_subarea == "Servicios de Higiene y Salud Ocupacional"
	replace cine_f_13_subarea_num = 21 if cine_f_13_subarea == "Servicios de Seguridad"
	replace cine_f_13_subarea_num = 27 if cine_f_13_subarea == "Servicios de Transportes"
	replace cine_f_13_subarea_num = 29 if cine_f_13_subarea == "Artes y Humanidades sin mayor definición"
	replace cine_f_13_subarea_num = 4 if cine_f_13_subarea == "Ingeniería y Profesiones Afines"
	replace cine_f_13_subarea_num = 7 if cine_f_13_subarea == "Tecnología de la Información y la Comunicación (TIC)"
	replace cine_f_13_subarea_num = 11 if cine_f_13_subarea == "Salud"
	replace cine_f_13_subarea_num = 14 if cine_f_13_subarea == "Medio Ambiente"
	replace cine_f_13_subarea_num = 16 if cine_f_13_subarea == "Matemáticas y Estadísticas"
	replace cine_f_13_subarea_num = 18 if cine_f_13_subarea == "Ciencias Físicas"
	replace cine_f_13_subarea_num = 19 if cine_f_13_subarea == "Industria y Producción"
	replace cine_f_13_subarea_num = 20 if cine_f_13_subarea == "Ciencias Biológicas y Afines"
	replace cine_f_13_subarea_num = 22 if cine_f_13_subarea == "Veterinaria"
	replace cine_f_13_subarea_num = 23 if cine_f_13_subarea == "Agricultura"
	replace cine_f_13_subarea_num = 24 if cine_f_13_subarea == "Silvicultura"
	replace cine_f_13_subarea_num = 25 if cine_f_13_subarea == "Ciencias Naturales, Matemáticas y Estadísticas sin mayor definición"
	replace cine_f_13_subarea_num = 26 if cine_f_13_subarea == "Pesca"
	replace cine_f_13_subarea_num = 28 if cine_f_13_subarea == "Agricultura, Silvicultura, Pesca y Veterinaria sin mayor definición"
	rename cine_f_13_subarea_num major_area_`y' 
	rename cine_f_13_subarea major_area_string_`y'
	label var major_area_string_`y' "Name of major area enrolled in year `y'" // Number identifying the subarea of the major
	label var major_area_`y' "Code of major area enrolled in year `y'" // Number identifying the subarea of the major
	rename dur_total_carr dur_estudio_carr_`y'
    lab var dur_estudio_carr_`y' "Duration of the major enrolled in year `y' (n. of semesters)"
	
	
	

merge 1:1 mrun using "$dataTemp/simce2m_all_years_alucpad_cleaned.dta" // merge with simce data to obtain major-HE institution rank in baseline ability
drop if _merge==2
drop _merge 

bysort cod_inst_`y' major_area_`y' (simce_avg_st): gen order_simce = _n ///	
                   if simce_avg_st != . 
bysort cod_inst_`y' major_area_`y' : egen observations_in_uni_major=max(order_simce) ///
	               if simce_avg_st != . 
gen temp = order_simce/observations_in_uni_major  ///
	               if simce_avg_st != .
bysort cod_inst_`y' major_area_`y' simce_avg_st: egen simce_rank_major_inst_`y'=max(temp) ///
	               if simce_avg_st != .
label var simce_rank_major_inst_`y' "Rank in major-HE institute based on SIMCE Score if first year is `y'"
drop observations_in_uni_major order_simce temp


gen simce_rank_major_inst=.
    replace simce_rank_major_inst=simce_rank_major_inst_`y' if simce_rank_major_inst_`y'!=.
	drop simce_rank_major_inst_`y'

label var simce_rank_major_inst "Rank in major-HE institute in first enrollment year based on SIMCE Score"

bysort cod_inst_`y' cod_carrera_`y' (simce_avg_st): gen order_simce_carrera = _n ///	
                   if simce_avg_st != .
bysort cod_inst_`y' cod_carrera_`y' : egen observations_in_uni_carrera=max(order_simce_carrera) ///
	               if simce_avg_st != . 
gen temp = order_simce_carrera/observations_in_uni_carrera  ///
	               if simce_avg_st != . 
bysort cod_inst_`y' cod_carrera_`y' simce_avg_st: egen simce_rank_carrera_inst_`y'=max(temp) ///
	               if simce_avg_st != . 
label var simce_rank_carrera_inst_`y' "Rank in course-institute based on SIMCE Score if first year is `y'"
drop observations_in_uni_carrera order_simce temp


*************************** Selectivity Course + HE ****************************

gen simce_rank_carrera_inst=.
    replace simce_rank_carrera_inst=simce_rank_carrera_inst_`y' if simce_rank_carrera_inst_`y'!=.
	drop simce_rank_carrera_inst_`y'

label var simce_rank_carrera_inst "Rank in course-institute in first enrollment year based on SIMCE Score"


	bysort cod_inst_`y' cod_carrera_`y': egen average_simce_carrera_regular = mean(simce_avg_st) if simce_avg_st != . & forma_ingreso_`y' != "7- Ingreso a través de PACE" 
	
	egen average_simce_carrera = max(average_simce_carrera_regular), by(cod_inst_`y' cod_carrera_`y')
	
	gen average_simce_carrera_`y' = .
	
	replace average_simce_carrera_`y' = average_simce_carrera
	
	label var average_simce_carrera_`y' "Selectivity in course-institute based on SIMCE Score if first year is `y'"
	
	egen pc90_`y' =pctile(average_simce_carrera_`y') ,p(90)
	gen most_selective_`y'=(average_simce_carrera_`y'>pc90_`y') if average_simce_carrera_`y' != .
	
	drop average_simce_carrera_regular average_simce_carrera pc90_`y'



gen average_simce_carrera_first=.
gen most_selective_first = .
    replace average_simce_carrera_first=average_simce_carrera_`y' if average_simce_carrera_`y'!=.
	replace most_selective_first = most_selective_`y' if most_selective_`y' != . & average_simce_carrera_`y'!=.

label var average_simce_carrera_first "Selectivity in course-institute in first enrollment year based on SIMCE Score"

*************************** Selectivity Major + HE *****************************
	
	bysort cod_inst_`y' major_area_`y': egen average_simce_major_regular = mean(simce_avg_st) if simce_avg_st != . & forma_ingreso_`y' != "7- Ingreso a través de PACE" 
	
	egen average_simce_major = max(average_simce_major_regular), by(cod_inst_`y' major_area_`y')
	
	gen average_simce_major_`y' = .
	
	replace average_simce_major_`y' = average_simce_major 
	
	label var average_simce_major_`y' "Selectivity in course-institute based on SIMCE Score if first year is `y'"
	
	drop average_simce_major_regular average_simce_major


gen average_simce_major_first=.
    replace average_simce_major_first=average_simce_major_`y' if average_simce_major_`y'!=.
label var average_simce_major_first "Selectivity in major-institute in first enrollment year based on SIMCE Score"

***************************** Selectivity HE ***********************************

	
	bysort cod_inst_`y': egen average_simce_inst_regular = mean(simce_avg_st) if simce_avg_st != . & forma_ingreso_`y' != "7- Ingreso a través de PACE" 
	
	egen average_simce_inst = max(average_simce_inst_regular), by(cod_inst_`y')
	
	gen average_simce_inst_`y' = .
	
	replace average_simce_inst_`y' = average_simce_inst 
	
	label var average_simce_inst_`y' "Selectivity in higher education institute based on SIMCE Score if first year is `y'"
	
	drop average_simce_inst_regular average_simce_inst



gen average_simce_inst_first=.
    replace average_simce_inst_first=average_simce_inst_`y' if average_simce_inst_`y'!=.

label var average_simce_inst_first "Selectivity in higher education institute in first enrollment year based on SIMCE Score"
	
	
    isid mrun
    sort mrun
save "$dataTemp/matricula_es_20`y'.dta", replace
}

*-------------------------------------------------------------------------------
**#----------------------------- Selectivity -----------------------------------
*-------------------------------------------------------------------------------

preserve

use "$dataTemp/matricula_es_2018.dta", clear
keep cod_inst_18 cod_carrera_18 simce_avg_st major_area_18 mrun

bysort cod_inst_18 cod_carrera_18: egen average_simce_carrera_regular = mean(simce_avg_st) if simce_avg_st != . 

bysort cod_inst_18 cod_carrera_18: egen average_simce_carrera = max(average_simce_carrera_regular)

bysort cod_inst_18: egen average_simce_inst_regular = mean(simce_avg_st) if simce_avg_st != . 

bysort cod_inst_18: egen average_simce_inst = max(average_simce_inst_regular)

bysort cod_inst_18 major_area_18: egen average_simce_major_regular = mean(simce_avg_st) if simce_avg_st != . 

bysort cod_inst_18 major_area_18: egen average_simce_major = max(average_simce_major_regular)

drop mrun simce_avg_st average_simce_carrera_regular average_simce_inst_regular average_simce_major_regular

rename cod_inst_18 cod_inst

rename major_area_18 major_area

rename cod_carrera_18 cod_carrera

duplicates drop

drop if cod_carrera == .

lab var average_simce_inst "Selectivity in institute in 2018 based on SIMCE Score"
lab var average_simce_carrera "Selectivity in course-institute in 2018 based on SIMCE Score"
lab var average_simce_major "Selectivity in major-institute in 2018 based on SIMCE Score"

save "$dataTemp/enrollment_selectivity_18.dta", replace

restore 	

*-------------------------------------------------------------------------------
**# CLEAN GRADUATION DATA IN 2019, 2020, 2021 and 2022 (2nd to 5th year) 
*-------------------------------------------------------------------------------
forvalues y=19(1)$last_year_enrollment { // no graduates in the first year (2018)
	if `y'==19{
        import delimited "$dataRawPublic/Graduation/20220804_Titulados_Ed_Superior_2019_WEB.csv", delimiter(";") clear
	}
	if `y'==20{
        import delimited "$dataRawPublic/Graduation/20220804_Titulados_Ed_Superior_2020_WEB.csv", delimiter(";") clear
	}
	if `y'==21{
        import delimited "$dataRawPublic/Graduation/20220804_Titulados_Ed_Superior_2021_WEB.csv", delimiter(";") clear
	}
	if `y'==22{
       import delimited "$dataRawPublic/Graduation/20230714_Titulados_Ed_Superior_2022_WEB.csv", delimiter(";") clear	
	}
	destring mrun, force replace
    drop if mrun==.
    bysort mrun: gen dup_num=_N
    drop if dup_num>1 & dup_num!=.
    keep mrun cod_inst nomb_inst cod_carrera tipo_inst_3 subarea_cine_f_13
    save "$dataTemp/graduation_20`y'.dta", replace		
}



*-------------------------------------------------------------------------------
**# GENERATE STILL ENROLLED OR GRADUATED IN 5TH YEAR
*-------------------------------------------------------------------------------
* Load our dataset and keep only randomized schools
use "$dataTemp/basefinal_merged_all_clean.dta", clear
keep if in_experimental_schools==1
* Generate variables used in analysis
tab id_fieldworker, gen(id_fe)
* Identify those who graduate during our sample years
gen graduated_in_18=0 // no graduates in the first year (2018)
cap drop cod_inst
cap drop nomb_inst
cap drop cod_carrera
cap drop tipo_inst_3
cap drop subarea_cine_f_13
forvalues y=19(1)$last_year_enrollment { 
    merge 1:1 mrun using "$dataTemp/graduation_20`y'.dta"
    drop if _merge==2
    gen graduated_in_`y'=1 if _merge==3
    replace graduated_in_`y'=0 if _merge!=3
	lab var graduated_in_`y' "Graduated in year `y'"
    drop _merge
	rename cod_inst cod_inst_grad_`y'
    lab var cod_inst_grad_`y' "Code of institution graduated in year `y'"
    rename nomb_inst nomb_inst_grad_`y'
    lab var nomb_inst_grad_`y' "Name of institution graduated in year `y'"
	 rename cod_carrera cod_carrera_grad_`y'
    lab var cod_carrera_grad_`y' "Course graduated in year `y'"
    rename tipo_inst_3 tipo_inst_3_grad_`y'
    lab var tipo_inst_3_grad_`y' "Type of institution graduated in year `y'"
	rename subarea_cine_f_13 cine_f_13_subarea
	gen cine_f_13_subarea_num = . 
	replace cine_f_13_subarea_num = 1 if cine_f_13_subarea == "Educación Comercial y Administración"
	replace cine_f_13_subarea_num = 2 if cine_f_13_subarea == "Ciencias Sociales y del Comportamiento"
	replace cine_f_13_subarea_num = 3 if cine_f_13_subarea == "Derecho"
	replace cine_f_13_subarea_num = 4 if cine_f_13_subarea == "Ingeniería y Profesiones Afines"
	replace cine_f_13_subarea_num = 5 if cine_f_13_subarea == "Artes"
	replace cine_f_13_subarea_num = 6 if cine_f_13_subarea == "Educación"
	replace cine_f_13_subarea_num = 7 if cine_f_13_subarea == "Tecnología de la Información y la Comunicación (TIC)"
	replace cine_f_13_subarea_num = 8 if cine_f_13_subarea == "Humanidades"
	replace cine_f_13_subarea_num = 9 if cine_f_13_subarea == "Periodismo e Información"
	replace cine_f_13_subarea_num = 10 if cine_f_13_subarea == "Arquitectura y Construcción"
	replace cine_f_13_subarea_num = 11 if cine_f_13_subarea == "Salud"
	replace cine_f_13_subarea_num = 12 if cine_f_13_subarea == "Servicios personales"
	replace cine_f_13_subarea_num = 13 if cine_f_13_subarea == "Idiomas"
	replace cine_f_13_subarea_num = 14 if cine_f_13_subarea == "Medio Ambiente"
	replace cine_f_13_subarea_num = 15 if cine_f_13_subarea == "Bienestar"
	replace cine_f_13_subarea_num = 16 if cine_f_13_subarea == "Matemáticas y Estadísticas"
	replace cine_f_13_subarea_num = 17 if cine_f_13_subarea == "Servicios de Higiene y Salud Ocupacional"
	replace cine_f_13_subarea_num = 18 if cine_f_13_subarea == "Ciencias Físicas"
	replace cine_f_13_subarea_num = 19 if cine_f_13_subarea == "Industria y Producción"
	replace cine_f_13_subarea_num = 20 if cine_f_13_subarea == "Ciencias Biológicas y Afines"
	replace cine_f_13_subarea_num = 21 if cine_f_13_subarea == "Servicios de Seguridad"
	replace cine_f_13_subarea_num = 22 if cine_f_13_subarea == "Veterinaria"
	replace cine_f_13_subarea_num = 23 if cine_f_13_subarea == "Agricultura"
	replace cine_f_13_subarea_num = 24 if cine_f_13_subarea == "Silvicultura"
	replace cine_f_13_subarea_num = 25 if cine_f_13_subarea == "Ciencias Naturales, Matemáticas y Estadísticas sin mayor definición"
	replace cine_f_13_subarea_num = 26 if cine_f_13_subarea == "Pesca"
	replace cine_f_13_subarea_num = 27 if cine_f_13_subarea == "Servicios de Transportes"
	replace cine_f_13_subarea_num = 28 if cine_f_13_subarea == "Agricultura, Silvicultura, Pesca y Veterinaria sin mayor definición"
	replace cine_f_13_subarea_num = 29 if cine_f_13_subarea == "Artes y Humanidades sin mayor definición"
	rename cine_f_13_subarea major_area_grad_string_`y' 
	label var major_area_grad_string_`y' "Name of graduation major area in year `y'" // Number identifying the subarea of the major
	rename cine_f_13_subarea_num major_area_grad_`y' 
	label var major_area_grad_`y' "Code of graduation major area in year `y'" // Number identifying the subarea of the major
}
drop tipo_inst_1

gen graduated_18=0
forvalues y=19(1)$last_year_enrollment {
	local y_1=`y'-1
	gen graduated_`y'=0
	replace graduated_`y'=1 if graduated_in_`y'==1 | graduated_`y_1'==1 
	lab var graduated_`y' "Graduated by year `y'" 
}

* Merge in type of insitution enrolled in first year (2018) to keep track of outside options
rename enrolled_SUA enrolled_SUA_18
merge 1:1 mrun using "$dataTemp/matricula_es_2018.dta"
drop if _merge==2
gen enrolled_voc_18=1 if _merge==3 & ( tipo_inst_3_18=="Centros de Formación Técnica" | tipo_inst_3_18=="Centros de Formación Técnica Estatal" | tipo_inst_3_18=="Institutos Profesionales")
replace enrolled_voc_18=0 if enrolled_voc_18==.
gen enrolled_nonSUA_18=1 if enrolled_SUA_18==0 & (tipo_inst_3_18=="Universidades Estatales CRUCH" | tipo_inst_3_18=="Universidades Privadas" | tipo_inst_3_18=="Universidades Privadas CRUCH")
replace enrolled_nonSUA_18= 0 if enrolled_SUA_18==1 
replace enrolled_nonSUA_18=0 if enrolled_nonSUA_18==. 
label var enrolled_nonSUA_18 "Enrolled in off-platform university in first year in 2018"
gen enrolled_out_18=enrolled_nonSUA_18+enrolled_voc_18
gen enrolled_any_18=enrolled_SUA_18+enrolled_out_18
drop _merge  

* Merge in second year enrollment data 
merge 1:1 mrun using "$dataTemp/matricula_es_2019.dta"
drop if _merge==2
gen enrolled_SUA_19=1 if (tipo_inst_3_19=="Universidades Estatales CRUCH" | tipo_inst_3_19=="Universidades Privadas" | tipo_inst_3_19=="Universidades Privadas CRUCH")  & enrolled_SUA_18==1 
replace enrolled_SUA_19=0 if enrolled_SUA_18==0
replace enrolled_SUA_19=0 if enrolled_SUA_19==.
replace enrolled_SUA_19=1 if enrolled_SUA_18==1 & graduated_in_18==1
label var enrolled_SUA_19 "Continuously enrolled in SUA in second year in 2019"
gen enrolled_voc_19=1 if (tipo_inst_3_19=="Centros de FormaciÃ³n TÃ©cnica" | tipo_inst_3_19=="Institutos Profesionales") & enrolled_voc_18==1
replace enrolled_voc_19=0 if enrolled_voc_18==0 
replace enrolled_voc_19=0 if enrolled_voc_19==.
label var enrolled_voc_19 "Continuously enrolled in vocational in second year in 2019"
gen enrolled_nonSUA_19=1 if enrolled_nonSUA_18==1 & enrolled_SUA_19==0 & ///
                           (tipo_inst_3_19=="Universidades Estatales CRUCH" | tipo_inst_3_19=="Universidades Privadas"  | tipo_inst_3_19=="Universidades Privadas CRUCH" )
replace enrolled_nonSUA_19=0 if enrolled_nonSUA_19==.
replace enrolled_nonSUA_19=1 if enrolled_nonSUA_18==1 & graduated_in_18==1 
label var enrolled_nonSUA_19 "Enrolled in off-platform university in third year in 2019 or graduated in 2018" 
gen enrolled_out_19=enrolled_nonSUA_19+enrolled_voc_19
gen enrolled_any_19=enrolled_SUA_19+enrolled_out_19
drop _merge 


* Merge in third year enrollment data, generate variable still enrolled or graduated (nobody has graduated from SUA yet)
merge 1:1 mrun using "$dataTemp/matricula_es_2020.dta"
drop if _merge==2
gen enrolled_SUA_20=1 if (tipo_inst_3_20=="Universidades Estatales CRUCH" | tipo_inst_3_20=="Universidades Privadas" | tipo_inst_3_20=="Universidades Privadas CRUCH")   & enrolled_SUA_19==1 
replace enrolled_SUA_20=0 if enrolled_SUA_19==0
replace enrolled_SUA_20=0 if enrolled_SUA_20==.
replace enrolled_SUA_20=1 if enrolled_SUA_19==1 & graduated_in_19==1
label var enrolled_SUA_20 "Continuously enrolled in SUA in third year in 2020"
gen enrolled_voc_20=1 if (tipo_inst_3_20=="Centros de Formación Técnica" | tipo_inst_3_20=="Centros de Formación Técnica Estatales" | tipo_inst_3_20=="Institutos Profesionales") & enrolled_voc_19==1
replace enrolled_voc_20=0 if enrolled_voc_19==0 
replace enrolled_voc_20=0 if enrolled_voc_20==.
replace enrolled_voc_20=1 if enrolled_voc_19==1 & graduated_in_19==1 
label var enrolled_voc_20 "Continuously enrolled in vocational in third year in 2020"
gen enrolled_nonSUA_20=1 if enrolled_nonSUA_19==1 & enrolled_SUA_20==0 & (tipo_inst_3_20=="Universidades Estatales CRUCH" | tipo_inst_3_20=="Universidades Privadas"  | tipo_inst_3_20=="Universidades Privadas CRUCH" )
replace enrolled_nonSUA_20=0 if enrolled_nonSUA_20==.
replace enrolled_nonSUA_20=1 if enrolled_nonSUA_19==1 &  graduated_in_19==1 
label var enrolled_nonSUA_20 "Enrolled in off-platform university in third year in 2020 or graduated in 2019"
gen enrolled_out_20=enrolled_nonSUA_20+enrolled_voc_20
gen enrolled_any_20=enrolled_SUA_20+enrolled_out_20
drop _merge 

 
* Merge in fourth year enrollment data, generate variable still enrolled or graduated
merge 1:1 mrun using "$dataTemp/matricula_es_2021.dta"
drop if _merge==2
gen enrolled_SUA_21=1 if (tipo_inst_3_21=="Universidades Estatales CRUCH" | tipo_inst_3_21=="Universidades Privadas" | tipo_inst_3_21=="Universidades Privadas CRUCH")   & enrolled_SUA_20==1 
replace enrolled_SUA_21=0 if enrolled_SUA_20==0
replace enrolled_SUA_21=0 if enrolled_SUA_21==.
replace enrolled_SUA_21=1 if (enrolled_SUA_20==1 & graduated_in_20==1) | (enrolled_SUA_19==1 & graduated_in_19==1)
label var enrolled_SUA_21 "Continuously enrolled in SUA in fourth year in 2021 or graduated the previous year"
gen enrolled_voc_21=1 if (tipo_inst_3_21=="Centros de Formación Técnica" | tipo_inst_3_21=="Centros de Formación Técnica Estatales" | tipo_inst_3_21=="Institutos Profesionales") & enrolled_voc_20==1
replace enrolled_voc_21=0 if enrolled_voc_20==0 
replace enrolled_voc_21=0 if enrolled_voc_21==.
replace enrolled_voc_21=1 if (enrolled_voc_20==1 & graduated_in_20==1 )  | (enrolled_voc_19==1 & graduated_in_19==1)
label var enrolled_voc_21 "Continuously enrolled in SUA in fourth year in 2021 or graduated the previous year"
gen enrolled_nonSUA_21=1 if enrolled_nonSUA_20==1 & enrolled_SUA_21==0 & (tipo_inst_3_21=="Universidades Estatales CRUCH" | tipo_inst_3_21=="Universidades Privadas"  | tipo_inst_3_21=="Universidades Privadas CRUCH" )
replace enrolled_nonSUA_21=0 if enrolled_nonSUA_21==.
replace enrolled_nonSUA_21=1 if (enrolled_nonSUA_20==1 &  graduated_in_20==1 ) |  (enrolled_nonSUA_19==1 & graduated_in_19==1)
label var enrolled_nonSUA_21 "Enrolled in off-platform university in fourth year in 2021 or graduated in 2020"
gen enrolled_out_21=enrolled_nonSUA_21+enrolled_voc_21
gen enrolled_any_21=enrolled_SUA_21+enrolled_out_21
drop _merge 
 
 
* Merge in fifth year enrollment data, generate variable still enrolled or graduated
merge 1:1 mrun using "$dataTemp/matricula_es_2022.dta"
drop if _merge==2
gen enrolled_SUA_22=1 if (tipo_inst_3_22=="Universidades Estatales CRUCH" | tipo_inst_3_22=="Universidades Privadas" | tipo_inst_3_22=="Universidades Privadas CRUCH")   & enrolled_SUA_21==1 
replace enrolled_SUA_22=0 if enrolled_SUA_21==0
replace enrolled_SUA_22=0 if enrolled_SUA_22==.
replace enrolled_SUA_22=1 if (enrolled_SUA_19==1 & graduated_in_19==1)  | (enrolled_SUA_20==1 & graduated_in_20==1)  | (enrolled_SUA_21==1 & graduated_in_21==1)
label var enrolled_SUA_22 "Continuously enrolled in SUA in fifth year in 2022 or graduated the previous year(s)" 
gen enrolled_voc_22=1 if (tipo_inst_3_22=="Centros de Formación Técnica" | tipo_inst_3_22=="Centros de Formación Técnica Estatales" | tipo_inst_3_22=="Institutos Profesionales") & enrolled_voc_21==1
replace enrolled_voc_22=0 if enrolled_voc_21==0 
replace enrolled_voc_22=0 if enrolled_voc_22==.
replace enrolled_voc_22=1 if  (enrolled_voc_19==1 & graduated_in_19==1 ) |  (enrolled_voc_20==1 & graduated_in_20==1 ) | (enrolled_voc_21==1 & graduated_in_21==1 ) 
label var enrolled_voc_22 "Continuously enrolled in vocational in fifth year in 2022 or graduated the previous year"
gen enrolled_nonSUA_22=1 if enrolled_nonSUA_21==1 & enrolled_SUA_22==0 & (tipo_inst_3_22=="Universidades Estatales CRUCH" | tipo_inst_3_22=="Universidades Privadas"  | tipo_inst_3_22=="Universidades Privadas CRUCH" )
replace enrolled_nonSUA_22=0 if enrolled_nonSUA_22==.
replace enrolled_nonSUA_22=1 if (enrolled_nonSUA_19==1 &  graduated_in_19==1 ) | (enrolled_nonSUA_20==1 &  graduated_in_20==1 ) | (enrolled_nonSUA_21==1 &  graduated_in_21==1 )
label var enrolled_nonSUA_22 "Enrolled in off-platform university in fifth year in 2022 or graduated in 2021"
gen enrolled_out_22=enrolled_nonSUA_22+enrolled_voc_22
gen enrolled_any_22=enrolled_SUA_22+enrolled_out_22
drop _merge 


foreach k in SUA voc nonSUA out any {
	gen enrolled_`k'_in_18=enrolled_`k'_18
	label var enrolled_`k'_in_18 "Enrolled in `k' in 2018"
}
* We define as going to a selective universities, students that passed the PSU test to obtain their admission
* In case you were enrolled in a selective university the year before and you are still enrolled in a non-vocational college, 
* you are still considered enrolled in a selective university. 
forvalues y=19(1)$last_year_enrollment{
	local y_1=`y'-1
	merge 1:1 mrun using "$dataTemp/D_MATRICULA_PSU_20`y'_PRIV_uniqueMRUN.dta", keepusing(mrun)
	drop if _merge==2
	gen enrolled_SUA_in_`y'=0
	replace enrolled_SUA_in_`y'=1 if _merge==3
	replace enrolled_SUA_in_`y'=1 if enrolled_SUA_in_`y_1'==1 & ///
	                                (tipo_inst_3_`y'=="Universidades Estatales CRUCH" | tipo_inst_3_`y'=="Universidades Privadas" | tipo_inst_3_`y'=="Universidades Privadas CRUCH") 
	label var enrolled_SUA_in_`y' "Enrolled in SUA in 20`y'"
	gen enrolled_voc_in_`y'=0
    replace enrolled_voc_in_`y'=1 if (tipo_inst_3_`y'=="Centros de Formación Técnica" | tipo_inst_3_`y'=="Centros de Formación Técnica Estatales" | tipo_inst_3_`y'=="Institutos Profesionales")
	label var enrolled_voc_in_`y' "Enrolled in voc in 20`y'"
    gen enrolled_nonSUA_in_`y'=0
	replace enrolled_nonSUA_in_`y'=1 if enrolled_SUA_in_`y'==0 & ///
	                                   (tipo_inst_3_`y'=="Universidades Estatales CRUCH" | tipo_inst_3_`y'=="Universidades Privadas"  | tipo_inst_3_`y'=="Universidades Privadas CRUCH" )
	label var enrolled_SUA_in_`y' "Enrolled in nonSUA in 20`y'"
    gen enrolled_out_in_`y'=enrolled_nonSUA_in_`y'+enrolled_voc_in_`y'
	label var enrolled_out_in_`y' "Enrolled in outside in 20`y'"
    gen enrolled_any_in_`y'=enrolled_SUA_in_`y'+enrolled_out_in_`y'
	label var enrolled_any_in_`y' "Enrolled in any in 20`y'"
	drop _merge
}

	

*-------------------------------------------------------------------------------
**#--------------------- CLEAN ENROLLMENT DATASETS IN 2018-2023 ----------------
*-------------------------------------------------------------------------------

forvalues y=18(1)$last_year_enrollment{
	local year=20`y'
	** STEM **
	gen STEM_enrolled_in_`y' = 0
	replace STEM_enrolled_in_`y' = 1 if major_area_`y' == 4 | major_area_`y' == 7 | major_area_`y' ==  11| major_area_`y' == 14 | major_area_`y' == 16 | major_area_`y' == 18 | ///
	                                    major_area_`y' == 19 | major_area_`y' == 20 | major_area_`y' == 22 | major_area_`y' == 23 | major_area_`y' == 24 | major_area_`y' == 25 | ///
										major_area_`y' == 26 | major_area_`y' == 28
	label var STEM_enrolled_in_`y' "Enrolled in STEM major in year `y'" // == 1 if the student is enrolled in STEM major in year `y' 
	foreach k in SUA voc nonSUA out any {
	    gen  STEM_enrolled_`k'_in_`y'=0 
		replace  STEM_enrolled_`k'_in_`y' = 1 if STEM_enrolled_in_`y' == 1 & enrolled_`k'_in_`y' == 1 // ==1 if enrolled in STEM in year `y'
    	gen  No_STEM_enrolled_`k'_in_`y' =0 
		replace   No_STEM_enrolled_`k'_in_`y' = 1 if  STEM_enrolled_in_`y' == 0 & enrolled_`k'_in_`y' == 1 // ==1 if enrolled in Non-STEM in year `y'
	}
	lab var STEM_enrolled_SUA_in_`y' "Enrolled in STEM major in selective college in year `year'"
	lab var STEM_enrolled_voc_in_`y' "Enrolled in STEM major in vocational institution in year `year'"
	lab var STEM_enrolled_nonSUA_in_`y' "Enrolled in STEM major in non-selective college in year `year'"
	lab var STEM_enrolled_out_in_`y' "Enrolled in STEM major in outside selective college in year `year'"
	lab var STEM_enrolled_any_in_`y' "Enrolled in STEM major in any higher education institute in year `year'"
	lab var No_STEM_enrolled_SUA_in_`y' "Enrolled in non-STEM major in selective college in year `year'"
	lab var No_STEM_enrolled_voc_in_`y' "Enrolled in non-STEM major in vocational institution in year `year'"
	lab var No_STEM_enrolled_nonSUA_in_`y' "Enrolled in non-STEM major in non-selective college in year `year'"
	lab var No_STEM_enrolled_out_in_`y' "Enrolled in non-STEM major in outside selective college in year `year'"
	lab var No_STEM_enrolled_any_in_`y' "Enrolled in non-STEM major in any higher education institute in year `year'"
	
	
	foreach k in SUA voc nonSUA out any {
	    gen  dur_estudio_carr_`k'_`y'=0 
		replace  dur_estudio_carr_`k'_`y' = dur_estudio_carr_`y' if enrolled_`k'_in_`y' == 1  
	}
	
	if `y'<18 {
		cap gen sforma_ingreso_`y' = string(forma_ingreso_`y')
		cap drop forma_ingreso_`y' 
		cap rename sforma_ingreso_`y' forma_ingreso_`y' 
	}

	lab var dur_estudio_carr_SUA_`y' "Duration of the major enrolled in selective college in year `year'"
	lab var dur_estudio_carr_voc_`y' "Duration of the major enrolled in vocational institution in year `year'"
	lab var dur_estudio_carr_nonSUA_`y' "Duration of the major enrolled in non-selective college in year `year'"
	lab var dur_estudio_carr_out_`y' "Duration of the major enrolled in outside selective college in year `year'"
	lab var dur_estudio_carr_any_`y' "Duration of the major enrolled in any higher education institute in year `year'"
	
}


gen enrollment_year = .
local first_year=18 // first year is 2018
replace enrollment_year = `first_year' if enrolled_any_in_`first_year' == 1
forvalues y=$last_year_enrollment(-1)`first_year'{
	di `y'
    replace enrollment_year = `y' if enrolled_any_in_`y' == 1
	local y_1=`y'-1
	forvalues j=`first_year'(1)`y_1'{
        replace enrollment_year = . if enrolled_any_in_`j' == 1		
	}
}
label var enrollment_year "Year of first enrollment"

gen predicted_graduation_year = .
label var predicted_graduation_year "Predicted graduation year"
gen predicted_graduation_year_plus_1 = .
label var predicted_graduation_year_plus_1 "Predicted graduation year plus 1 Semester"
gen type_college_enrollment = ""
label var type_college_enrollment "Type of institution of first enrollment"
gen duration_first_enrollment = .
label var duration_first_enrollment "Duration of the first course of enrollment"

forvalues y=18(1)$last_year_enrollment{
	replace predicted_graduation_year = floor(enrollment_year + (dur_estudio_carr_`y'/2)) if enrollment_year == `y'
	
	replace predicted_graduation_year_plus_1 = floor(enrollment_year + ((dur_estudio_carr_`y' + 1)/2)) if enrollment_year == `y'
	
	replace duration_first_enrollment = dur_estudio_carr_`y' if enrollment_year == `y'
}

	foreach k in SUA voc nonSUA {
		gen  type_`k' = 0
		forvalues y=18(1)$last_year_enrollment{
			replace  type_`k' = 1 if enrollment_year == `y' & enrolled_`k'_in_`y' == 1
			replace type_college_enrollment = "`k'" if enrollment_year == `y' & enrolled_`k'_in_`y' == 1
		}
	}
	

gen  STEM_first_enrollment = 0
		forvalues y=18(1)$last_year_enrollment{
			replace  STEM_first_enrollment = 1 if enrollment_year == `y' & STEM_enrolled_any_in_`y' == 1
		}
		
label var STEM_first_enrollment "The student enrolled for the first time in a STEM major"
	
gen after_graduation = predicted_graduation_year + 1
label var after_graduation "First year after predicted graduation year"
gen enrolled_after_pred_grad = 0
label var enrolled_after_pred_grad "Enrollment in the year after the predicted graduation"
forvalues y=18(1)$last_year_enrollment{
	replace enrolled_after_pred_grad = 1 if after_graduation == `y' & enrolled_any_in_`y' == 1
}

*-------------------------------------------------------------------------------
**#--------------------- CLEAN GRADUATION DATASETS IN 2018-2023 ----------------
*-------------------------------------------------------------------------------
* To obtain this data, go to https://datosabiertos.mineduc.cl/titulados-en-educacion-superior/

gen STEM_graduated_in_18=0
gen No_STEM_graduated_in_18=0
foreach k in SUA voc nonSUA out any {
    gen graduated_`k'_in_18=0
    gen STEM_graduated_`k'_in_18=0 
	gen No_STEM_graduated_`k'_in_18=0 
	gen graduated_`k'_18=0
	gen STEM_graduated_`k'_18=0
	gen No_STEM_graduated_`k'_18=0
}
forvalues y=19(1)$last_year_enrollment {
	
	foreach k in SUA voc nonSUA out any {
	    gen graduated_`k'_in_`y'=0
	    replace graduated_`k'_in_`y'=1 if enrolled_`k'_in_`y'==1 & graduated_in_`y'==1
        lab var graduated_`k'_in_`y' "Graduated `k' in year `year'"
	    local y_1=`y'-1
        gen graduated_`k'_`y'=0
	    replace graduated_`k'_`y'=1 if graduated_`k'_in_`y'==1 | graduated_`k'_`y_1'==1
	    lab var graduated_`k'_`y'  "Graduated `k' by year `year'"
	}
	
	gen STEM_graduated_in_`y' = 0
	replace STEM_graduated_in_`y' = 1 if major_area_grad_`y' == 4  | major_area_grad_`y' == 18 | major_area_grad_`y' ==  11| major_area_grad_`y' == 14 | major_area_grad_`y' == 16 | ///
	                                     major_area_grad_`y' == 18 | major_area_grad_`y' == 19 | major_area_grad_`y' == 20 | major_area_grad_`y' == 22 | major_area_grad_`y' == 23 | ///
										 major_area_grad_`y' == 24 | major_area_grad_`y' == 25 | major_area_grad_`y' == 26 | major_area_grad_`y' == 28
	label var STEM_graduated_in_`y' "Graduated in STEM major in year `y'" // ==1 if the student graduates in STEM major in year `y'
	gen No_STEM_graduated_in_`y' = 0
	replace No_STEM_graduated_in_`y' = 1 if graduated_in_`y' ==1 & STEM_graduated_in_`y' ==0
	label var No_STEM_graduated_in_`y' "Graduated in non-STEM major in year `y'" // ==1 if the student graduates in STEM major in year `y'
	foreach k in SUA voc nonSUA out any {
	    gen STEM_graduated_`k'_in_`y' =0 
		replace STEM_graduated_`k'_in_`y' = 1 if STEM_graduated_in_`y' == 1 & graduated_`k'_in_`y' == 1
	    lab var STEM_graduated_`k'_in_`y'  "Graduated in STEM major in `k' by year `year'"
		gen No_STEM_graduated_`k'_in_`y' =0 
		replace No_STEM_graduated_`k'_in_`y' = 1 if STEM_graduated_in_`y' == 0 & graduated_`k'_in_`y' == 1
	    lab var No_STEM_graduated_`k'_in_`y'  "Graduated in non-STEM major in `k' by year `year'"
        gen STEM_graduated_`k'_`y'=0
	    replace STEM_graduated_`k'_`y'=1 if STEM_graduated_`k'_in_`y'==1 | STEM_graduated_`k'_`y_1'==1
	    lab var STEM_graduated_`k'_`y'  "Graduated in STEM major by `k' by year `year'"
        gen No_STEM_graduated_`k'_`y'=0
	    replace No_STEM_graduated_`k'_`y'=1 if No_STEM_graduated_`k'_in_`y'==1 | No_STEM_graduated_`k'_`y_1'==1
	    lab var No_STEM_graduated_`k'_`y'  "Graduated in non-STEM major by `k' by year `year'"
	}
}


gen graduation_year = .
forvalues y=18(1)$last_year_enrollment{
	replace graduation_year = `y' if graduated_any_in_`y' == 1 & graduation_year==.
}



gen cod_inst_enroll = .
gen cod_carrera_enroll = .
gen major_area_enroll = .

forvalues y=18(1)$last_year_enrollment{
	replace cod_inst_enroll = cod_inst_`y' if enrollment_year == `y'
	replace cod_carrera_enroll = cod_carrera_`y' if enrollment_year == `y'
	replace major_area_enroll = major_area_`y' if enrollment_year == `y'
}

rename cod_inst_enroll cod_inst
rename cod_carrera_enroll cod_carrera
rename major_area_enroll major_area

merge m:1 cod_inst cod_carrera major_area using "$dataTemp/enrollment_selectivity_18.dta"


replace year=2018  // identify the experimental cohort 
lab var year "Year after high school"
lab var age "Age in cuarto medio"
lab var treatment "Treatment"

gen top15baseline=1 if GPA_1_2_rank >=0.85 & GPA_1_2_rank !=. 
replace top15baseline=0 if GPA_1_2_rank<0.85
lab var top15baseline "baseline top 15\%"
gen bottom85baseline=1 if top15baseline==0 
replace bottom85baseline=0 if top15baseline==1
lab var bottom85baseline "bottom 85\%" // indicator for bottom 85% students at baseline

gen top15endline=.
replace top15endline=1 if  allyears_GPA_rank>=0.85 & allyears_GPA_rank!=.
replace top15endline=0 if  allyears_GPA_rank<0.85 & allyears_GPA_rank!=.
lab var top15endline "top 15\% based on all years GPA" // indicator for top 15% students at endline
gen bottom85endline=1 if top15endline==0 
replace bottom85endline=0 if top15endline==1
lab var bottom85endline "bottom 85\% based on all years GPA" // indicator for bottom 85% students at endline

gen all=1 // indicator for all students
lab var all "all students"


* Generate indicator for simce above median in that cohort
su simce_avg_st, d
gen above_med_simce_avg_st=0 if simce_avg_st!=.
replace above_med_simce_avg_st=1 if simce_avg_st!=. &  simce_avg_st>r(p50)
lab var above_med_simce_avg_st "Above median simce in the treated schools of same cohort"
gen below_med_simce_avg_st=0 if simce_avg_st!=.
replace below_med_simce_avg_st=1 if simce_avg_st!=. &  simce_avg_st<=r(p50)
lab var below_med_simce_avg_st "Below median simce in the treated schools of same cohort"

* Generate indicator for perceived prob. graduation above median in that cohort (only 2018)
su p_graduate, d
gen above_med_p_graduate=0 if p_graduate!=.
replace above_med_p_graduate=1 if p_graduate!=. &  p_graduate>r(p50)
lab var above_med_p_graduate "Above median perceived probability of graduating at baseline"
gen below_med_p_graduate=0 if p_graduate!=.
replace below_med_p_graduate=1 if p_graduate!=. &  p_graduate<=r(p50)
lab var below_med_p_graduate "Below median perceived probability of graduating at baseline"


forvalues y=18(1)18 { // for each first year after high school
    local years_of_data=($last_year_enrollment + 1) - `y' 
    forvalues n=1(1)`years_of_data'{ // for each year of data after high school
       cap gen cod_inst_y`n'=.
	   cap gen major_area_y`n'=.
	   lab var cod_inst_y`n' "Code of institution `n' years after high school"
	   lab var major_area_y`n' "Major area `n' years after high school"
	   local yplusn_1=`y'+`n'-1	
	    cap replace cod_inst_y`n'=cod_inst_`yplusn_1' if year==20`y'
	    cap replace major_area_y`n'=major_area_`yplusn_1' if year==20`y'
	}
}

forvalues y=18(1)18 { // for each first year after high school
    local years_of_data=($last_year_enrollment + 1) - `y'  
    forvalues n=1(1)`years_of_data'{ // for each year of data after high school
	   cap gen cod_inst_grad_y`n'=.
	   cap gen major_area_grad_y`n'=.
	   lab var cod_inst_grad_y`n' "Code of institution graduated `n' years after high school"
	   lab var major_area_grad_y`n' "Major area graduated `n' years after high school"
	   local yplusn_1=`y'+`n'-1	
	    cap replace cod_inst_grad_y`n'=cod_inst_grad_`yplusn_1' if year==20`y'
	    cap replace major_area_grad_y`n'=major_area_grad_`yplusn_1' if year==20`y'
	}
}

forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=1(1)`years_of_data'{ // for each year of data after high school
	   cap gen average_simce_inst_y`n'=.
	   cap gen average_simce_major_y`n'=.
	   cap gen average_simce_carrera_y`n'=.
	   lab var average_simce_inst_y`n' "Selectivity in HE institute based on SIMCE Score if first enrolled `n' years after high school"
	   lab var average_simce_major_y`n' "Selectivity in major-institute based on SIMCE Score if first enrolled `n' years after high school"
	   lab var average_simce_carrera_y`n' "Selectivity in course-institute based on SIMCE Score if first enrolled `n' years after high school"
	   local yplusn_1=`y'+`n'-1	
	    cap replace average_simce_inst_y`n'=average_simce_inst_`yplusn_1' if year==20`y'
	    cap replace average_simce_major_y`n'=average_simce_major_`yplusn_1' if year==20`y'
	    cap replace average_simce_carrera_y`n'=average_simce_carrera_`yplusn_1' if year==20`y'
	}
}

********************************************************************************
**# Create enrollment in each year outcomes
********************************************************************************
* Create enrolled and graduated in each year after high school
foreach outcome in enrolled STEM_enrolled No_STEM_enrolled {
    foreach k in SUA voc nonSUA out any { // for each type of college
       forvalues y=18(1)18 { // for each first year after high school
		    local  years_of_data= ($last_year_enrollment + 1) - `y'
            forvalues n=1(1)`years_of_data' { // for each year of data after high school
		        cap gen `outcome'_`k'_in_y`n'=.
		        local yplusn_1=`y'+`n'-1
	            replace `outcome'_`k'_in_y`n'=0 if `outcome'_`k'_in_`yplusn_1'==0 & year==20`y'
	            replace `outcome'_`k'_in_y`n'=1 if `outcome'_`k'_in_`yplusn_1'==1 & year==20`y'
	            lab var `outcome'_`k'_in_y`n' "`outcome' `k' in year `n' after high-school"
			}
		}
    }
}

foreach outcome in graduated STEM_graduated No_STEM_graduated {
    foreach k in SUA voc nonSUA out any { // for each type of college
	    forvalues y=18(1)18 { // for each first year after high school
		    local  years_of_data= ($last_year_enrollment + 1) - `y'
            forvalues n=1(1)`years_of_data'{ // for each year of data after high school
		        cap gen `outcome'_`k'_in_y`n'=.
		        local yplusn_1=`y'+`n'-1
	            replace `outcome'_`k'_in_y`n'=0 if `outcome'_`k'_in_`yplusn_1'==0 & year==20`y'
	            replace `outcome'_`k'_in_y`n'=1 if `outcome'_`k'_in_`yplusn_1'==1 & year==20`y'
	            lab var `outcome'_`k'_in_y`n' "`outcome' `k' in year `n' after high-school"
			}
		}
    }
}

foreach outcome in graduated STEM_graduated No_STEM_graduated {
	foreach k in SUA voc nonSUA out any { // for each type of college
		cap gen `outcome'_`k'_by_y1=. 
	    replace `outcome'_`k'_by_y1 = 0 if `outcome'_`k'_in_y1==0
		replace `outcome'_`k'_by_y1 = 1 if `outcome'_`k'_in_y1==1 
	    lab var `outcome'_`k'_by_y1 "`outcome' `k' by year 1 after high school"	
	    forvalues y=18(1)18 { // for each first year after high school
		    local years_of_data= ($last_year_enrollment + 1) - `y'
            forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	        local n_1=`n'-1 // local for previous year
		    cap gen `outcome'_`k'_by_y`n'=. 
	        replace `outcome'_`k'_by_y`n' = 0 if `outcome'_`k'_in_y`n'==0 & year==20`y'
		    replace `outcome'_`k'_by_y`n' = 1 if (`outcome'_`k'_by_y`n_1'==1 | `outcome'_`k'_in_y`n'==1) & year==20`y'
	        lab var `outcome'_`k'_by_y`n' "`outcome' `k' by year `n' after high school"	
			}
		}
	}
}


*-------------------------------------------------------------------------------
**#---------------- GENERATE GRADUATION IN TIME -----------------------------
*-------------------------------------------------------------------------------

gen graduated_in_time = 0
label var graduated_in_time "Graduated in time"
gen graduated_in_time_plus_1 = 0
label var graduated_in_time_plus_1 "Graduated in time plus 1 semester"
replace graduated_in_time = 1 if graduation_year <= predicted_graduation_year & graduation_year !=. & predicted_graduation_year!=.
replace graduated_in_time_plus_1 = 1 if graduation_year <= predicted_graduation_year_plus_1 & graduation_year !=. & predicted_graduation_year!=.

foreach k in SUA voc nonSUA {
	cap gen graduated_`k'_in_time = 0
	replace graduated_`k'_in_time = 1 if graduated_in_time == 1 & type_`k' == 1
    forvalues y=18(1)18 { // for each first year after high school
         local years_of_data= ($last_year_enrollment + 1) - `y'
        forvalues n=1(1)`years_of_data'{ // for each year of data after high school
		    cap gen graduated_`k'_in_time_y`n' = .
		    replace graduated_`k'_in_time_y`n' =0 if year==20`n'
		    replace graduated_`k'_in_time_y`n' = 1 if graduated_`k'_in_time == 1 & graduated_`k'_in_y`n' == 1 & year==20`n'
		}
	}
}
	

label var graduated_SUA_in_time "Graduated in time after enrolling in a selective college"
label var graduated_voc_in_time "Graduated in time after enrolling in a vocational institution"
label var graduated_nonSUA_in_time "Graduated in time after enrolling in a non-selective college"

replace enrolled_after_pred_grad = 0 if enrolled_after_pred_grad == .

foreach k in SUA voc nonSUA {
	    gen enrolled_`k'_after_grad = 0
		replace enrolled_`k'_after_grad = 1 if enrolled_after_pred_grad == 1 & type_`k' == 1 //Enrolled after grad after starting in college of type k
}

label var enrolled_SUA_after_grad "Enrolled after graduation year after enrolling in a selective college"
label var enrolled_voc_after_grad "Enrolled after graduation year after enrolling in a vocational institution"
label var enrolled_nonSUA_after_grad "Enrolled after graduation year after enrolling in a non-selective college"

foreach k in SUA voc nonSUA {
	    gen STEM_graduated_`k'_inti = 0
		replace STEM_graduated_`k'_inti = 1 if graduated_in_time == 1 & type_`k' == 1 & STEM_first_enrollment == 1
		
		gen NonSTEM_graduated_`k'_inti = 0
		replace NonSTEM_graduated_`k'_inti = 1 if graduated_in_time == 1 & type_`k' == 1 & STEM_first_enrollment == 0
}

label var STEM_graduated_SUA_inti "Graduated in time after enrolling in a STEM major in a selective college"
label var STEM_graduated_voc_inti "Graduated in time after enrolling in a STEM major in a vocational institution"
label var STEM_graduated_nonSUA_inti "Graduated in time after enrolling in a STEM major in a non-selective college"

label var NonSTEM_graduated_SUA_inti "Graduated in time after enrolling in a Non-STEM major in a selective college"
label var NonSTEM_graduated_voc_inti "Graduated in time after enrolling in a Non-STEM major in a vocational institution"
label var NonSTEM_graduated_nonSUA_inti "Graduated in time after enrolling in a Non-STEM major in a non-selective college"

foreach k in SUA voc nonSUA {
	    gen STEM_enrolled_`k'_aft_grad = 0
		replace STEM_enrolled_`k'_aft_grad = 1 if enrolled_after_pred_grad == 1 & type_`k' == 1 & STEM_first_enrollment == 1
		
		gen NonSTEM_enrolled_`k'_aft_grad = 0
		replace NonSTEM_enrolled_`k'_aft_grad = 1 if enrolled_after_pred_grad == 1 & type_`k' == 1 & STEM_first_enrollment == 0
		
}

label var STEM_enrolled_SUA_aft_grad "Enrolled after graduation year after enrolling in a STEM major in a selective college"
label var STEM_enrolled_voc_aft_grad "Enrolled after graduation year after enrolling in a STEM major in a vocational institution"
label var STEM_enrolled_nonSUA_aft_grad "Enrolled after graduation year after enrolling in a STEM major in a non-selective college"

label var NonSTEM_enrolled_SUA_aft_grad "Enrolled after graduation year after enrolling in a Non-STEM major in a selective college"
label var NonSTEM_enrolled_voc_aft_grad "Enrolled after graduation year after enrolling in a Non-STEM major in a vocational institution"
label var NonSTEM_enrolled_nonSUA_aft_grad "Enrolled after graduation year after enrolling in a Non-STEM major in a non-selective college"

gen graduated_out_in_time = graduated_voc_in_time + graduated_nonSUA_in_time
gen graduated_any_in_time = graduated_voc_in_time + graduated_nonSUA_in_time + graduated_SUA_in_time

label var graduated_out_in_time "Graduated in time after enrolling in an outside selective college"
label var graduated_any_in_time "Graduated in time after enrolling in any higher educational institution"

gen enrolled_out_after_grad = enrolled_voc_after_grad + enrolled_nonSUA_after_grad
gen enrolled_any_after_grad = enrolled_voc_after_grad + enrolled_nonSUA_after_grad + enrolled_SUA_after_grad

label var enrolled_out_after_grad "Enrolled after graduation year after enrolling in an outside selective college"
label var enrolled_any_after_grad "Enrolled after graduation year after enrolling in any higher educational institution"

foreach k in STEM NonSTEM {
	    gen `k'_graduated_out_inti = `k'_graduated_voc_inti + `k'_graduated_nonSUA_inti
		gen `k'_graduated_any_inti = `k'_graduated_voc_inti + `k'_graduated_nonSUA_inti + `k'_graduated_SUA_inti
		
		gen `k'_enrolled_out_aftgrad = `k'_enrolled_voc_aft_grad + `k'_enrolled_nonSUA_aft_grad
		gen `k'_enrolled_any_aft_grad = `k'_enrolled_voc_aft_grad + `k'_enrolled_nonSUA_aft_grad + `k'_enrolled_SUA_aft_grad

}

label var STEM_graduated_out_inti "Graduated in time after enrolling in a STEM major in an outside selective college"
label var STEM_graduated_any_inti "Graduated in time after enrolling in a STEM major in any higher educational institution"

label var NonSTEM_graduated_out_inti "Graduated in time after enrolling in a Non-STEM major in an outside selective college"
label var NonSTEM_graduated_any_inti "Graduated in time after enrolling in a Non-STEM major in any higher educational institution"

label var STEM_enrolled_out_aftgrad "Enrolled after graduation year after enrolling in a STEM major in an outside selective college"
label var STEM_enrolled_any_aft_grad "Enrolled after graduation year after enrolling in a STEM major in any higher educational institution"

label var NonSTEM_enrolled_out_aftgrad "Enrolled after graduation year after enrolling in a Non-STEM major in an outside selective college"
label var NonSTEM_enrolled_any_aft_grad "Enrolled after graduation year after enrolling in a Non-STEM major in any higher educational institution"


*-------------------------------------------------------------------------------
**#---------------------- GENERATE DEGREE DURATION -----------------------------
*-------------------------------------------------------------------------------

foreach k in SUA voc nonSUA {
		
		gen duration_enroll_`k' = duration_first_enrollment if type_`k' == 1

	    gen STEM_duration_enroll_`k' = duration_enroll_`k' if STEM_first_enrollment == 1 
		
		gen NonSTEM_duration_enroll_`k' = duration_enroll_`k' if STEM_first_enrollment == 0 
		
}


gen duration_enroll_any = duration_first_enrollment if type_nonSUA == 1 | type_SUA == 1 | type_voc == 1
gen  STEM_duration_enroll_any = duration_enroll_any if STEM_first_enrollment == 1 
gen  NonSTEM_duration_enroll_any = duration_enroll_any if STEM_first_enrollment == 0

gen duration_enroll_out = duration_first_enrollment if type_nonSUA == 1 | type_voc == 1
gen STEM_duration_enroll_out = duration_enroll_out if STEM_first_enrollment == 1 
gen  NonSTEM_duration_enroll_out = duration_enroll_out if STEM_first_enrollment == 0

label var duration_enroll_SUA "Duration of the course if enrolled in a selective college"
label var duration_enroll_voc "Duration of the course if enrolled in a vocational institution"
label var duration_enroll_nonSUA "Duration of the course if enrolled in a non-selective college"
label var duration_enroll_out "Duration of the course if enrolled in an outside selective college"
label var duration_enroll_any "Duration of the course if enrolled in any higher education istitution"

label var STEM_duration_enroll_SUA "Duration of the course if enrolled in a STEM major in a selective college"
label var STEM_duration_enroll_voc "Duration of the course if enrolled in a STEM major in a vocational institution"
label var STEM_duration_enroll_nonSUA "Duration of the course if enrolled in a STEM major in a non-selective college"
label var STEM_duration_enroll_out "Duration of the course if enrolled in a STEM major in an outside selective college"
label var STEM_duration_enroll_any "Duration of the course if enrolled in a STEM major in any higher education istitution"

label var NonSTEM_duration_enroll_SUA "Duration of the course if enrolled in a Non-STEM major in a selective college"
label var NonSTEM_duration_enroll_voc "Duration of the course if enrolled in a Non-STEM major in a vocational institution"
label var NonSTEM_duration_enroll_nonSUA "Duration of the course if enrolled in a Non-STEM major in a non-selective college"
label var NonSTEM_duration_enroll_out "Duration of the course if enrolled in a Non-STEM major in an outside selective college"
label var NonSTEM_duration_enroll_any "Duration of the course if enrolled in a Non-STEM major in any higher education istitution"


*-------------------------------------------------------------------------------
**#-GENERATE GRADUATED BY EACH YEAR CONDITIONAL ON INITIAL UNIVERSITY TYPE -----
*-------------------------------------------------------------------------------
forvalues y=18(1)18 { // for each first year after high school
     local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=1(1)`years_of_data'{ // for each year of data after high school
	    foreach k in SUA voc nonSUA out any {
	
	    cap gen graduated_start_`k'_by_y`n' =.
		replace graduated_start_`k'_by_y`n' =0 if year==20`y'
		replace graduated_start_`k'_by_y`n' = 1 if graduated_`k'_by_y`n' == 1 & enrolled_`k'_in_y1 == 1 & year==20`y'
		
	    cap gen STEM_grad_start_`k'_by_y`n' =.
		replace STEM_grad_start_`k'_by_y`n' =0 if year==20`y'
		replace STEM_grad_start_`k'_by_y`n' = 1 if STEM_graduated_`k'_by_y`n' == 1 & enrolled_`k'_in_y1 == 1 & year==20`y'
		
	    cap gen No_STEM_grad_start_`k'_by_y`n' =.
		replace No_STEM_grad_start_`k'_by_y`n' =0 if year==20`y'
		replace No_STEM_grad_start_`k'_by_y`n' = 1 if No_STEM_graduated_`k'_by_y`n' == 1 & enrolled_`k'_in_y1 == 1 & year==20`y'
		}
	lab var graduated_start_SUA_by_y`n' "Graduated in a selective college by year `n' if beginning in selective college"
	lab var graduated_start_voc_by_y`n' "Graduated in a vocational institution by year `n' if beginning in vocational institution"
	lab var graduated_start_nonSUA_by_y`n' "Graduated in non-selective college by year `n' if beginning in non-selective college"
	lab var graduated_start_out_by_y`n' "Graduated in outside selective college by year `n' if beginning outside selective college"
	lab var graduated_start_any_by_y`n' "Graduated in any higher education institute by year `n' if beginning in any higher education institute"
	
	lab var STEM_grad_start_SUA_by_y`n' "Graduated in STEM major in a selective college by year `n' if beginning in selective college"
	lab var STEM_grad_start_voc_by_y`n' "Graduated in STEM major in a vocational institution by year `n' if beginning in vocational institution"
	lab var STEM_grad_start_nonSUA_by_y`n' "Graduated in STEM major in non-selective college by year `n' if beginning in non-selective college"
	lab var STEM_grad_start_out_by_y`n' "Graduated in STEM major in outside selective college by year `n' if beginning outside selective college"
	lab var STEM_grad_start_any_by_y`n' "Graduated in STEM major in any higher education institute by year `n' if beginning in any higher education institute"
	
	lab var No_STEM_grad_start_SUA_by_y`n' "Graduated in Non-STEM major in a selective college by year `n' if beginning in selective college"
	lab var No_STEM_grad_start_voc_by_y`n' "Graduated in Non-STEM major in a vocational institution by year `n' if beginning in vocational institution"
	lab var No_STEM_grad_start_nonSUA_by_y`n' "Graduated in Non-STEM major in non-selective college by year `n' if beginning in non-selective college"
	lab var No_STEM_grad_start_out_by_y`n' "Graduated in Non-STEM major in outside selective college by year `n' if beginning outside selective college"
	lab var No_STEM_grad_start_any_by_y`n' "Graduated in Non-STEM major in any higher education institute by year `n' if beginning in any higher education institute"
		
	}
}

*-------------------------------------------------------------------------------
**#---GENERATE GRADUATED IN THE SAME INSTITUTION AS IN YEAR 1 ------------------
*-------------------------------------------------------------------------------	
gen graduated_same_inst_by_y1=0
lab var graduated_same_inst_by_y1 "Graduated by year 1 in the same institution in which enrolled in year 1 after high school"
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
     	local n_1=`n'-1 // local for previous year
        cap gen graduated_same_inst_by_y`n'=.
		replace graduated_same_inst_by_y`n'=0 if year==20`y'
        replace graduated_same_inst_by_y`n'=1 if enrolled_any_in_y1==1 & ///
		                                         cod_inst_grad_y`n'==cod_inst_y1 & cod_inst_y1!=. & year==20`y'
    	replace graduated_same_inst_by_y`n'=1 if graduated_same_inst_by_y`n_1'==1 & year==20`y'
        label var graduated_same_inst_by_y`n' "Graduated by year `n' in the same institution in which enrolled in year 1 after high school" 
	}
}

*-------------------------------------------------------------------------------
**#---GENERATE CONTINUOUSLY ENROLLED IN THE SAME INSTITUTION AS IN YEAR 1-------
*-------------------------------------------------------------------------------
gen enrolled_same_inst_by_y1=enrolled_any_in_y1
lab var enrolled_same_inst_by_y1 "Continuously enrolled by year 1 in the same institution in which enrolled in year 1 after high school"
forvalues y=18(1)18 { // for each first year after high school
     local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
        cap gen enrolled_same_inst_by_y`n'=.
	    replace enrolled_same_inst_by_y`n'=0 if year==20`y'
        replace enrolled_same_inst_by_y`n'=1 if  enrolled_same_inst_by_y`n_1'==1 & enrolled_any_in_y`n'==1 & cod_inst_y`n'==cod_inst_y`n_1' & cod_inst_y`n'!=. & year==20`y' // continuously enrolled in the same institution
        label var enrolled_same_inst_by_y`n' "Continuously enrolled by year `n' in the same institution in which enrolled in year 1 after high school"
	}
}



*-------------------------------------------------------------------------------
**#---GENERATE GRADUATED IN THE SAME STEM MAJOR AS IN YEAR 1 -------------------
*-------------------------------------------------------------------------------
gen STEM_graduated_same_maj_by_y1 =0
lab var STEM_graduated_same_maj_by_y1  "Graduated by year 1 in the same STEM major in which enrolled in year 1"

gen No_STEM_graduated_same_maj_by_y1 =0
lab var  No_STEM_graduated_same_maj_by_y1  "Graduated by year 1 in the same Non-STEM major in which enrolled in year 1"

forvalues y=18(1)18 { // for each first year after high school
     local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
        cap gen STEM_graduated_same_maj_by_y`n' =.
	    replace STEM_graduated_same_maj_by_y`n' =0  if year==20`y'
        replace STEM_graduated_same_maj_by_y`n' =1 if STEM_enrolled_any_in_y1 == 1 & major_area_grad_y`n'== major_area_y1 & major_area_y1!=. & cod_inst_grad_y`n' == cod_inst_y1 & cod_inst_y1!=. & year==20`y'
	    replace STEM_graduated_same_maj_by_y`n'=1 if STEM_graduated_same_maj_by_y`n_1'==1 & year==20`y'	
        label var STEM_graduated_same_maj_by_y`n' "Graduated by year `n' in the same STEM major in which enrolled in year 1"

        cap gen  No_STEM_graduated_same_maj_by_y`n' =.
     	replace  No_STEM_graduated_same_maj_by_y`n' =0  if year==20`y'
        replace  No_STEM_graduated_same_maj_by_y`n' =1 if  No_STEM_enrolled_any_in_y1 == 1 & major_area_grad_y`n'== major_area_y1 & major_area_y1!=. & cod_inst_grad_y`n' == cod_inst_y1 & cod_inst_y1!=. & year==20`y'
	    replace  No_STEM_graduated_same_maj_by_y`n'=1 if  No_STEM_graduated_same_maj_by_y`n_1'==1 & year==20`y'
        label var  No_STEM_graduated_same_maj_by_y`n' "Graduated by year y`n' in the same Non-STEM major in which enrolled in year 1"
	}
}



*-------------------------------------------------------------------------------
**#--GENERATE CONTINUOUSLY ENROLLED IN THE SAME STEM/NON-STEM MAJOR AS IN YEAR 1
*-------------------------------------------------------------------------------
gen enrolled_same_maj_by_y1 = enrolled_any_in_y1
lab var enrolled_same_maj_by_y1 "Continuously enrolled by year 1 in the same major/institution in which enrolled in year 1"

gen STEM_enrolled_same_maj_by_y1 = STEM_enrolled_any_in_y1
lab var STEM_enrolled_same_maj_by_y1 "Continuously enrolled by year 1 in the same STEM major/institution in which enrolled in year 1"

gen No_STEM_enrolled_same_maj_by_y1 = No_STEM_enrolled_any_in_y1
lab var No_STEM_enrolled_same_maj_by_y1 "Continuously enrolled by year 1 in the same Non-STEM major/institution in which enrolled in year 1"


forvalues y=18(1)18 { // for each first year after high school
     local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
        cap gen enrolled_same_maj_by_y`n' = .
        replace enrolled_same_maj_by_y`n' = 0 if year==20`y'
        replace enrolled_same_maj_by_y`n' =1 if  enrolled_same_maj_by_y`n_1' ==1 & enrolled_any_in_y`n' ==1 & major_area_y`n' == major_area_y`n_1'  & major_area_y`n' !=. & cod_inst_y`n'==cod_inst_y`n_1' & cod_inst_y`n'!=. & year==20`y'  // continuously enrolled in the same institution + same STEM major
        label var enrolled_same_maj_by_y`n' "Continuously enrolled by year `n' in the same major/institution in which enrolled in year 1"

        cap gen STEM_enrolled_same_maj_by_y`n' = .
        replace STEM_enrolled_same_maj_by_y`n' = 0 if year==20`y'
        replace STEM_enrolled_same_maj_by_y`n' =1 if  STEM_enrolled_same_maj_by_y`n_1' ==1 & STEM_enrolled_any_in_y`n' ==1 & major_area_y`n' == major_area_y`n_1'  & major_area_y`n' !=. & cod_inst_y`n'==cod_inst_y`n_1' & cod_inst_y`n'!=. & year==20`y'  // continuously enrolled in the same institution + same STEM major
        label var STEM_enrolled_same_maj_by_y`n' "Continuously enrolled by year `n' in the same STEM major/institution in which enrolled in year 1"
	
	    cap gen No_STEM_enrolled_same_maj_by_y`n' = .
        replace No_STEM_enrolled_same_maj_by_y`n' = 0 if year==20`y'
        replace No_STEM_enrolled_same_maj_by_y`n' =1 if  No_STEM_enrolled_same_maj_by_y`n_1' ==1 & No_STEM_enrolled_any_in_y`n' ==1 & major_area_y`n' == major_area_y`n_1'  & major_area_y`n' !=. & cod_inst_y`n'==cod_inst_y`n_1' & cod_inst_y`n'!=. & year==20`y' // continuously enrolled in the same institution + same STEM major
        label var No_STEM_enrolled_same_maj_by_y`n' "Continuously enrolled by year `n' in the same Non-STEM major/institution in which enrolled in year 1"
	}
}


*-------------------------------------------------------------------------------
**#---GENERATE CONTINUOSLY ENROLLED OR ALREADY GRADUATED BY INITIAL TYPE -------
*-------------------------------------------------------------------------------
gen enrolled_SUA_by_y1=enrolled_SUA_in_y1
lab var enrolled_SUA_by_y1 "Continuously enrolled or graduated in selective college by year 1"
gen enrolled_voc_by_y1=enrolled_voc_in_y1
lab var enrolled_voc_by_y1 "Continuously enrolled or graduated in vocational institution by year 1"
gen enrolled_nonSUA_by_y1=enrolled_nonSUA_in_y1
lab var enrolled_nonSUA_by_y1 "Continuously enrolled or graduated in non-selective college by year 1"
gen enrolled_out_by_y1=enrolled_out_in_y1
lab var enrolled_out_by_y1 "Continuously enrolled or graduated in outside selective college by year 1"
gen enrolled_any_by_y1=enrolled_any_in_y1
lab var enrolled_any_by_y1 "Continuously enrolled or graduated in any higher education institute by year 1"

forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	    foreach k in SUA voc nonSUA out any {
            cap gen enrolled_`k'_by_y`n'=.
            replace enrolled_`k'_by_y`n'=0 if year==20`y'
            replace enrolled_`k'_by_y`n'=1 if enrolled_`k'_in_y1==1 & (enrolled_same_inst_by_y`n'==1 | graduated_same_inst_by_y`n'==1) & year==20`y' 
            label var enrolled_`k'_by_y`n' "Continuously enrolled or graduated in `k' by year `n'"
	    }
	}
	
}



*-------------------------------------------------------------------------------
**#---GENERATE EVER ENROLLED BY TYPE -------------------------------------------
*-------------------------------------------------------------------------------
foreach outcome in enrolled {
	foreach k in SUA voc nonSUA out any { // for each type of college
		gen `outcome'_ever_`k'_by_y1=. 
	    replace `outcome'_ever_`k'_by_y1 = 0 if `outcome'_`k'_in_y1==0
		replace `outcome'_ever_`k'_by_y1 = 1 if `outcome'_`k'_in_y1==1 
	    lab var `outcome'_ever_`k'_by_y1 "`outcome' `k' by year 1 after high school"	
	    forvalues y=18(1)18 { // for each first year after high school
		    local years_of_data= ($last_year_enrollment + 1) - `y'
            forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	        local n_1=`n'-1 // local for previous year
		    cap gen `outcome'_ever_`k'_by_y`n'=. 
	        replace `outcome'_ever_`k'_by_y`n' = 0 if `outcome'_`k'_in_y`n'==0 & year==20`y'
		    replace `outcome'_ever_`k'_by_y`n' = 1 if (`outcome'_ever_`k'_by_y`n_1'==1 | `outcome'_`k'_in_y`n'==1) & year==20`y'
	        lab var `outcome'_ever_`k'_by_y`n' "Ever `outcome' `k' by year `n' after high school"	
			}
		}
	}
}

*-------------------------------------------------------------------------------
**#---GENERATE ENROLLED OR GRADUATED IN EACH YEAR BY TYPE-----------------------
*-------------------------------------------------------------------------------
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	    foreach k in SUA voc nonSUA out any {
            cap gen enrolled_grad_`k'_in_y`n'=.
            replace enrolled_grad_`k'_in_y`n'=0 if year==20`y'
            replace enrolled_grad_`k'_in_y`n'=1 if (enrolled_`k'_in_y`n'==1 | graduated_`k'_by_y`n'==1) & year==20`y'
            label var enrolled_grad_`k'_in_y`n' "Enrolled or graduated in `k' in year `n'"
		}
	}
}

*-------------------------------------------------------------------------------
**#---GENERATE ENROLLED OR GRADUATED IN EACH YEAR BY TYPE STEM/Non-STEM)--------
*-------------------------------------------------------------------------------
foreach j in STEM No_STEM {
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	    foreach k in SUA voc nonSUA out any {
            cap gen `j'_enroll_grad_`k'_in_y`n'=.
            replace `j'_enroll_grad_`k'_in_y`n'=0 if year==20`y'
            replace `j'_enroll_grad_`k'_in_y`n'=1 if (`j'_enrolled_`k'_in_y`n'==1 | `j'_graduated_`k'_by_y`n'==1) & year==20`y'
            label var `j'_enroll_grad_`k'_in_y`n' "Enrolled or graduated in `j' majors in `k' in year `n'"
		}
	}
}
}

*-------------------------------------------------------------------------------
**#---GENERATE CONTINUOSLY ENROLLED OR ALREADY GRADUATED STEM BY INITIAL TYPE  -------
*-------------------------------------------------------------------------------
gen  STEM_enrolled_SUA_by_y1 = STEM_enrolled_SUA_in_y1 
lab var  STEM_enrolled_SUA_by_y1  "Continuously enrolled or graduated in STEM major in selective college by year 1"
gen  STEM_enrolled_voc_by_y1 = STEM_enrolled_voc_in_y1 
lab var  STEM_enrolled_voc_by_y1  "Continuously enrolled or graduated in STEM major in vocational institution by year 1"
gen  STEM_enrolled_nonSUA_by_y1 = STEM_enrolled_nonSUA_in_y1 
lab var  STEM_enrolled_nonSUA_by_y1  "Continuously enrolled or graduated in STEM major in non-selective college by year 1"
gen  STEM_enrolled_out_by_y1 =STEM_enrolled_out_in_y1 
lab var  STEM_enrolled_out_by_y1  "Continuously enrolled or graduated in STEM major in outside selective college by year 1"
gen  STEM_enrolled_any_by_y1 = STEM_enrolled_any_in_y1 
lab var  STEM_enrolled_any_by_y1  "Continuously enrolled or graduated in STEM major in any higher education institute by year 1"

gen  No_STEM_enrolled_SUA_by_y1 = No_STEM_enrolled_SUA_in_y1 
lab var  No_STEM_enrolled_SUA_by_y1  "Continuously enrolled or graduated in Non-STEM major in selective college by year 1"
gen  No_STEM_enrolled_voc_by_y1 = No_STEM_enrolled_voc_in_y1 
lab var  No_STEM_enrolled_voc_by_y1  "Continuously enrolled or graduated in Non-STEM major in vocational institution by year 1"
gen  No_STEM_enrolled_nonSUA_by_y1 = No_STEM_enrolled_nonSUA_in_y1 
lab var  No_STEM_enrolled_nonSUA_by_y1  "Continuously enrolled or graduated in Non-STEM major in non-selective college by year 1"
gen  No_STEM_enrolled_out_by_y1 =No_STEM_enrolled_out_in_y1 
lab var  No_STEM_enrolled_out_by_y1  "Continuously enrolled or graduated in Non-STEM major in outside selective college by year 1"
gen  No_STEM_enrolled_any_by_y1 = No_STEM_enrolled_any_in_y1 
lab var  No_STEM_enrolled_any_by_y1  "Continuously enrolled or graduated in Non-STEM major in any higher education institute by year 1"

forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	    foreach k in SUA voc nonSUA out any {	
		    cap gen STEM_enrolled_`k'_by_y`n' =.
		    replace STEM_enrolled_`k'_by_y`n' =0 if year==20`y'
		    replace STEM_enrolled_`k'_by_y`n' =1 if STEM_enrolled_`k'_in_y1 ==1 & (STEM_enrolled_same_maj_by_y`n' ==1 | STEM_graduated_same_maj_by_y`n' ==1) & year==20`y'
		    cap gen No_STEM_enrolled_`k'_by_y`n' =.
		    replace No_STEM_enrolled_`k'_by_y`n' =0 if year==20`y'
		    replace No_STEM_enrolled_`k'_by_y`n' =1 if No_STEM_enrolled_`k'_in_y1 ==1 & (No_STEM_enrolled_same_maj_by_y`n' ==1 | No_STEM_graduated_same_maj_by_y`n' ==1) & year==20`y'
			}
    label var STEM_enrolled_SUA_by_y`n' "Continuously enrolled or graduated in STEM major in SUA by year `n'"
    label var STEM_enrolled_voc_by_y`n' "Continuously enrolled or graduated in STEM major in vocational institution by year `n'"
    label var STEM_enrolled_nonSUA_by_y`n' "Continuously enrolled or graduated in STEM major in non-selective college by year `n'"
    lab var STEM_enrolled_out_by_y`n' "Continuously enrolled or graduated in STEM major in outside selective college by year `n'"
    lab var STEM_enrolled_any_by_y`n'  "Continuously enrolled or graduated in STEM major in any higher education institute in `num_year' in `n'"
	
	label var No_STEM_enrolled_SUA_by_y`n' "Continuously enrolled or graduated in Non-STEM major in SUA by year `n'"
    label var No_STEM_enrolled_voc_by_y`n' "Continuously enrolled or graduated in Non-STEM major in vocational institution by year `n'"
    label var No_STEM_enrolled_nonSUA_by_y`n' "Continuously enrolled or graduated in Non-STEM major in non-selective college by year `n'"
    lab var No_STEM_enrolled_out_by_y`n' "Continuously enrolled or graduated in Non-STEM major in outside selective college by year `n'"
    lab var No_STEM_enrolled_any_by_y`n'  "Continuously enrolled or graduated in Non-STEM major in any higher education institute in `num_year' in `n'"
	}
	
}
 

*-------------------------------------------------------------------------------
**#--------GENERATE DROPOUT BY YEAR AND INITIAL ENROLLMENT TYPE-----------------
*-------------------------------------------------------------------------------
* Generate dropout in each year
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	    foreach k in SUA voc nonSUA out any {
		* Dropout is defined as enrolled in year 1, not graduated by the previous year and not enrolled in any higher education institute in the current year
	    cap gen dropout_`k'_y`n'=.
	    replace dropout_`k'_y`n'=0 if year==20`y'
	    replace dropout_`k'_y`n'=1 if enrolled_`k'_in_y1==1 & graduated_any_by_y`n'==0 & enrolled_any_in_y`n'==0 & year==20`y'
	    }
	    lab var dropout_SUA_y`n' "Dropout by year `n' after enrolling in selective college in year 1"
	    lab var dropout_voc_y`n' "Dropout by year `n' after enrolling in vocational institution in year 1"
	    lab var dropout_nonSUA_y`n' "Dropout by year `n' after enrolling in non-selective college in year 1"
	    lab var dropout_out_y`n' "Dropout by year `n' after enrolling in outside selective college in year 1"
	    lab var dropout_any_y`n' "Dropout by by year `n' after enrolling in any higher education institute in year 1"
	}
}



*-------------------------------------------------------------------------------
**#--------GENERATE STEM DROPOUT BY YEAR AND INITIAL ENROLLMENT TYPE-----------------
*-------------------------------------------------------------------------------
* Generate dropout in each year
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	    foreach k in SUA voc nonSUA out any {
		* Dropout is defined as enrolled in year 1, not graduated by the previous year and not enrolled in any higher education institute in the current year
	    cap gen STEM_dropout_`k'_y`n' =. 
	    replace STEM_dropout_`k'_y`n' =0 if year==20`y'
	    replace STEM_dropout_`k'_y`n' =1 if STEM_enrolled_`k'_in_y1 ==1 & graduated_any_by_y`n'==0 & enrolled_any_in_y`n'==0 & year==20`y'
	    cap gen No_STEM_dropout_`k'_y`n' =. 
	    replace No_STEM_dropout_`k'_y`n' =0 if year==20`y'
	    replace No_STEM_dropout_`k'_y`n' =1 if No_STEM_enrolled_`k'_in_y1 ==1 & graduated_any_by_y`n'==0 & enrolled_any_in_y`n'==0 & year==20`y'
			}
	lab var STEM_dropout_SUA_y`n' "Dropout by year `n' after enrolling in STEM major in selective college in year 1"
	lab var STEM_dropout_voc_y`n' "Dropout by year `n' after enrolling in STEM major in vocational institution in year 1"
	lab var STEM_dropout_nonSUA_y`n' "Dropout by `n' after enrolling in STEM major in non-selective college in year 1"
	lab var STEM_dropout_out_y`n' "Dropout by `n' after enrolling in STEM major in outside selective college in year 1"
	lab var STEM_dropout_any_y`n' "Dropout by `n' after enrolling in STEM major in any higher education institute in year 1"

	lab var No_STEM_dropout_SUA_y`n' "Dropout by year `n' after enrolling in Non-STEM major in selective college in year 1"
	lab var No_STEM_dropout_voc_y`n' "Dropout by year `n' after enrolling in Non-STEM major in vocational institution in year 1"
	lab var No_STEM_dropout_nonSUA_y`n' "Dropout by `n' after enrolling in Non-STEM major in non-selective college in year 1"
	lab var No_STEM_dropout_out_y`n' "Dropout by `n' after enrolling in Non-STEM major in outside selective college in year 1"
	lab var No_STEM_dropout_any_y`n' "Dropout by `n' after enrolling in Non-STEM major in any higher education institute in year 1"
	}
}
 
*-------------------------------------------------------------------------------
**#--------GENERATE STOPOUT BY YEAR AND INITIAL ENROLLMENT TYPE-----------------
*-------------------------------------------------------------------------------
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=3(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	    foreach k in SUA voc nonSUA out any {
		    * Stopout in t is defined as enrolled in year 1, not enrolled in any HE in tau (with tau>year 1), enrolled in HE in T (with tau<T<=t), not graduated in any HE before T
	        cap gen stopout_`k'_y`n'=.
	        replace stopout_`k'_y`n'=0  if year==20`y'
	        replace stopout_`k'_y`n'=1 if enrolled_`k'_in_y1==1 & enrolled_any_in_y`n_1'==0 & enrolled_any_in_y`n'==1  & graduated_any_by_y`n'==0 & year==20`y'
	        cap replace stopout_`k'_y`n'=1 if stopout_`k'_y`n_1'==1 & year==20`y'
	    }
	    lab var stopout_SUA_y`n' "Stopout by year `n' after enrolling in selective college in year 1"
	    lab var stopout_voc_y`n' "Stopout by year `n' after enrolling in vocational institution in year 1"
	    lab var stopout_nonSUA_y`n' "Stopout by year `n' after enrolling in non-selective college in year 1"
	    lab var stopout_out_y`n' "Stopout by year `n' after enrolling in outside selective college in year 1"
	    lab var stopout_any_y`n' "Stopout by year `n' after enrolling in any higher education institute in year 1"
	}
}

*-------------------------------------------------------------------------------
**#--------GENERATE STEM STOPOUT BY YEAR AND INITIAL ENROLLMENT TYPE-----------------
*-------------------------------------------------------------------------------
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=3(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	    foreach k in SUA voc nonSUA out any {
		* Stopout in t is defined as enrolled in year 1, not enrolled in any HE in tau (with tau>year 1), enrolled in HE in T (with tau<T<=t), not graduated in any HE before T
	        cap gen STEM_stopout_`k'_y`n' =.
	        replace STEM_stopout_`k'_y`n' =0 if year==20`y'
	        replace STEM_stopout_`k'_y`n' = 1 if STEM_enrolled_`k'_in_y1 == 1 & enrolled_any_in_y`n_1'==0 & enrolled_any_in_y`n'==1  & graduated_any_by_y`n'==0 & year==20`y'
	        cap replace STEM_stopout_`k'_y`n'=1 if STEM_stopout_`k'_y`n_1'==1 & year==20`y'
	        cap gen No_STEM_stopout_`k'_y`n' =.
	        replace No_STEM_stopout_`k'_y`n' =0 if year==20`y'
	        replace No_STEM_stopout_`k'_y`n' = 1 if No_STEM_enrolled_`k'_in_y1 == 1 & enrolled_any_in_y`n_1'==0 & enrolled_any_in_y`n'==1  & graduated_any_by_y`n'==0 & year==20`y'
	        cap replace No_STEM_stopout_`k'_y`n'=1 if No_STEM_stopout_`k'_y`n_1'==1 & year==20`y'
		
    	}
	lab var STEM_stopout_SUA_y`n' "Stopout by year `n' after enrolling in STEM major in selective college in year 1"
	lab var STEM_stopout_voc_y`n' "Stopout by year `n' after enrolling in STEM major in vocational institution in year 1"
	lab var STEM_stopout_nonSUA_y`n' "Stopout by year `n' after enrolling in STEM major in non-selective college in year 1"
	lab var STEM_stopout_out_y`n' "Stopout by year `n' after enrolling in STEM major in outside selective college in year 1"
	lab var STEM_stopout_any_y`n' "Stopout by year `n' after enrolling in STEM major in any higher education institute in year 1"
	
	lab var No_STEM_stopout_SUA_y`n' "Stopout by year `n' after enrolling in Non-STEM major in selective college in year 1"
	lab var No_STEM_stopout_voc_y`n' "Stopout by year `n' after enrolling in Non-STEM major in vocational institution in year 1"
	lab var No_STEM_stopout_nonSUA_y`n' "Stopout by year `n' after enrolling in Non-STEM major in non-selective college in year 1"
	lab var No_STEM_stopout_out_y`n' "Stopout by year `n' after enrolling in Non-STEM major in outside selective college in year 1"
	lab var No_STEM_stopout_any_y`n' "Stopout by year `n' after enrolling in Non-STEM major in any higher education institute in year 1"
	}
}

*-------------------------------------------------------------------------------
**#-GENERATE SWITCH TO TYPE OF INSTITUTION FROM AN INITIAL ENROLLMENT TYPE BY YEAR -
*-------------------------------------------------------------------------------
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	    foreach k in SUA voc nonSUA out any {
			foreach j in SUA voc nonSUA out any {
		    * switch_to_any_from_ in t is defined as enrolled in a type of institution in year 1, enrolled in any other institution in any year<=t
	        cap gen switch_to_`j'_from_`k'_y`n'=.
	        replace switch_to_`j'_from_`k'_y`n'=0 if year==20`y'
	        replace switch_to_`j'_from_`k'_y`n'=1 if enrolled_`k'_in_y1 & enrolled_`j'_in_y`n'==1 & cod_inst_y`n'!=cod_inst_y1 & year==20`y'
	        cap replace switch_to_`j'_from_`k'_y`n'=1 if switch_to_`j'_from_`k'_y`n_1'==1 & year==20`y' & year==20`y'
		    lab var switch_to_`j'_from_`k'_y`n' "Switch to `j' by year `n' after enrolling in `k' in year 1"
			}
	    }
	}
}



*-------------------------------------------------------------------------------
**#-GENERATE SWITCH TO ANY INSTITUTION FROM AN INITIAL ENROLLMENT TYPE BY YEAR -
*-------------------------------------------------------------------------------
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	foreach k in SUA voc nonSUA out any {
		* switch_to_fr_ in t is defined as enrolled in a type of institution in year 1, enrolled in any other institution in any year<=t
		cap gen STEM_switch_to_fr_`k'_y`n' =.
	    replace STEM_switch_to_fr_`k'_y`n' =0 if year==20`y'
	    replace STEM_switch_to_fr_`k'_y`n' =1 if STEM_enrolled_`k'_in_y1 == 1 & enrolled_any_in_y`n'==1 & cod_inst_y`n'!=cod_inst_y1  & year==20`y'
	    cap replace STEM_switch_to_fr_`k'_y`n' =1 if switch_to_fr_`k'_y`n_1' ==1  & year==20`y'

	    cap gen No_STEM_switch_to_fr_`k'_y`n' =.
	    replace No_STEM_switch_to_fr_`k'_y`n' =0 if year==20`y'
	    replace No_STEM_switch_to_fr_`k'_y`n' =1 if No_STEM_enrolled_`k'_in_y1 == 1 & enrolled_any_in_y`n'==1 & cod_inst_y`n'!=cod_inst_y1  & year==20`y'
	}
	    cap replace No_STEM_switch_to_fr_`k'_y`n' =1 if switch_to_fr_`k'_y`n_1' ==1  & year==20`y'
	lab var STEM_switch_to_fr_SUA_y`n' "Switch to any other college by year `n' after enrolling in STEM major in selective college in year 1"
	lab var STEM_switch_to_fr_voc_y`n' "Switch to any other college by year `n' after enrolling in STEM major in vocational college in year 1"
	lab var STEM_switch_to_fr_nonSUA_y`n' "Switch to any other college by year `n' after enrolling in STEM major in non-selective college in year 1"
	lab var STEM_switch_to_fr_out_y`n' "Switch to any other college by year `n' after enrolling in STEM major outside selective college in year 1"
	lab var STEM_switch_to_fr_any_y`n' "Switch to any other college by year `n' after enrolling in STEM major in any college in year 1"
	
	lab var No_STEM_switch_to_fr_SUA_y`n' "Switch to any other college by year `n' after enrolling in Non-STEM major in selective college in year 1"
	lab var No_STEM_switch_to_fr_voc_y`n' "Switch to any other college by year `n' after enrolling in Non-STEM major in vocational college in year 1"
	lab var No_STEM_switch_to_fr_nonSUA_y`n' "Switch to any other college by year `n' after enrolling in Non-STEM major in non-selective college in year 1"
	lab var No_STEM_switch_to_fr_out_y`n' "Switch to any other college by year `n' after enrolling in Non-STEM major outside selective college in year 1"
	lab var No_STEM_switch_to_fr_any_y`n' "Switch to any other college by year `n' after enrolling in Non-STEM major in any college in year 1"
	}
}

forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
    	foreach k in SUA voc nonSUA out any {
		* switch_to_fr_ in t is defined as enrolled in a type of institution in year 1, enrolled in any other institution in any year<=t
	    cap gen STEM_switch_to_NoSTEM_`k'_y`n' =.
		replace STEM_switch_to_NoSTEM_`k'_y`n' =0 if year==20`y'
	    replace STEM_switch_to_NoSTEM_`k'_y`n' =1 if STEM_enrolled_`k'_in_y1 == 1 & STEM_enrolled_any_in_y`n' == 0 & enrolled_any_in_y`n' == 1 & No_STEM_enrolled_any_in_y`n' == 1 & year==20`y'
	    cap replace STEM_switch_to_NoSTEM_`k'_y`n' =1 if STEM_switch_to_NoSTEM_`k'_y`n_1' ==1 & year==20`y'
		
		cap gen No_STEM_switch_STEM_`k'_y`n' =. 
		replace No_STEM_switch_STEM_`k'_y`n' =0 if year==20`y' 
	    replace No_STEM_switch_STEM_`k'_y`n' =1 if No_STEM_enrolled_`k'_in_y1 == 1 & No_STEM_enrolled_any_in_y`n' == 0 & enrolled_any_in_y`n' == 1 & STEM_enrolled_any_in_y`n' == 1 & year==20`y'
	    cap replace No_STEM_switch_STEM_`k'_y`n' =1 if No_STEM_switch_STEM_`k'_y`n_1' ==1 & year==20`y'
	}
	lab var STEM_switch_to_NoSTEM_SUA_y`n' "Switch to non-STEM major by year `n' after enrolling in STEM major in selective college in year 1"
	lab var STEM_switch_to_NoSTEM_voc_y`n' "Switch to non-STEM major by year `n' after enrolling in STEM major in vocational college in year 1"
	lab var STEM_switch_to_NoSTEM_nonSUA_y`n' "Switch to non-STEM major by year `n' after enrolling in STEM major in non-selective college in year 1"
	lab var STEM_switch_to_NoSTEM_out_y`n' "Switch to non-STEM major by year `n' after enrolling in STEM major outside selective college in year 1"
	lab var STEM_switch_to_NoSTEM_any_y`n' "Switch to non-STEM major by year `n' after enrolling in STEM major in any college in year 1"
	
	lab var No_STEM_switch_STEM_SUA_y`n' "Switch to STEM major by year `n' after enrolling in Non-STEM major in selective college in year 1"
	lab var No_STEM_switch_STEM_voc_y`n' "Switch to STEM major by year `n' after enrolling in Non-STEM major in vocational college in year 1"
	lab var No_STEM_switch_STEM_nonSUA_y`n' "Switch to STEM major by year `n' after enrolling in Non-STEM major in non-selective college in year 1"
	lab var No_STEM_switch_STEM_out_y`n' "Switch to STEM major by year `n' after enrolling in Non-STEM major outside selective college in year 1"
	lab var No_STEM_switch_STEM_any_y`n' "Switch to STEM major by year `n' after enrolling in Non-STEM major in any college in year 1"
	}
}

*-------------------------------------------------------------------------------
**#-GENERATE SWITCH TO ANY MAJOR FROM AN INITIAL ENROLLMENT TYPE BY YEAR -
*-------------------------------------------------------------------------------
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	    local n_1=`n'-1 // local for previous year
	foreach k in SUA voc nonSUA out any {
		* switch_maj_ in t is defined as enrolled in a type of institution in year 1, enrolled in any other institution in any year<=t
		cap gen switch_maj_`k'_y`n' =.
	    replace switch_maj_`k'_y`n' =0 if year==20`y'
	    replace switch_maj_`k'_y`n' =1 if enrolled_`k'_in_y1 == 1 & enrolled_any_in_y`n'==1 & major_area_y`n'!=major_area_y1  & year==20`y'
	    cap replace switch_maj_`k'_y`n' =1 if switch_maj_`k'_y`n_1' ==1  & year==20`y'

		cap gen STEM_switch_maj_`k'_y`n' =.
	    replace STEM_switch_maj_`k'_y`n' =0 if year==20`y'
	    replace STEM_switch_maj_`k'_y`n' =1 if STEM_enrolled_`k'_in_y1 == 1 & enrolled_any_in_y`n'==1 & major_area_y`n'!=major_area_y1  & year==20`y'
	    cap replace STEM_switch_maj_`k'_y`n' =1 if STEM_switch_maj_`k'_y`n_1' ==1  & year==20`y'

	    cap gen No_STEM_switch_maj_`k'_y`n' =.
	    replace No_STEM_switch_maj_`k'_y`n' =0 if year==20`y'
	    replace No_STEM_switch_maj_`k'_y`n' =1 if No_STEM_enrolled_`k'_in_y1 == 1 & enrolled_any_in_y`n'==1 & major_area_y`n'!=major_area_y1  & year==20`y'
	    cap replace No_STEM_switch_maj_`k'_y`n' =1 if No_STEM_switch_maj_`k'_y`n_1' ==1  & year==20`y'
	}
	
	lab var switch_maj_SUA_y`n' "Switch to any other major by year `n' after enrolling  in selective college in year 1"
	lab var switch_maj_voc_y`n' "Switch to any other major by year `n' after enrolling  in vocational college in year 1"
	lab var switch_maj_nonSUA_y`n' "Switch to any other major by year `n' after enrolling  in non-selective college in year 1"
	lab var switch_maj_out_y`n' "Switch to any other major by year `n' after enrolling  outside selective college in year 1"
	lab var switch_maj_any_y`n' "Switch to any other major by year `n' after enrolling  in any college in year 1"

	lab var STEM_switch_maj_SUA_y`n' "Switch to any other major by year `n' after enrolling in STEM major in selective college in year 1"
	lab var STEM_switch_maj_voc_y`n' "Switch to any other major by year `n' after enrolling in STEM major in vocational college in year 1"
	lab var STEM_switch_maj_nonSUA_y`n' "Switch to any other major by year `n' after enrolling in STEM major in non-selective college in year 1"
	lab var STEM_switch_maj_out_y`n' "Switch to any other major by year `n' after enrolling in STEM major outside selective college in year 1"
	lab var STEM_switch_maj_any_y`n' "Switch to any other major by year `n' after enrolling in STEM major in any college in year 1"
	
	lab var No_STEM_switch_maj_SUA_y`n' "Switch to any other major by year `n' after enrolling in Non-STEM major in selective college in year 1"
	lab var No_STEM_switch_maj_voc_y`n' "Switch to any other major by year `n' after enrolling in Non-STEM major in vocational college in year 1"
	lab var No_STEM_switch_maj_nonSUA_y`n' "Switch to any other major by year `n' after enrolling in Non-STEM major in non-selective college in year 1"
	lab var No_STEM_switch_maj_out_y`n' "Switch to any other major by year `n' after enrolling in Non-STEM major outside selective college in year 1"
	lab var No_STEM_switch_maj_any_y`n' "Switch to any other major by year `n' after enrolling in Non-STEM major in any college in year 1"
	}
}


*-------------------------------------------------------------------------------
**#-GENERATE SWITCH TO AN ENROLLMENT TYPE FROM ANY INSTITUTION BY YEAR ---------
*-------------------------------------------------------------------------------
forvalues y=18(1)18 { // for each first year after high school
    local years_of_data= ($last_year_enrollment + 1) - `y'
    forvalues n=2(1)`years_of_data'{ // for each year of data after high school
	local n_1=`n'-1 // local for previous year
	foreach k in SUA voc nonSUA out any {
		* switch_from_any_to_ in t is defined as enrolled in any institution in year 1, enrolled in another institution of some type in any year<=t
	    cap gen switch_from_any_to_`k'_y`n'=. 
	    replace switch_from_any_to_`k'_y`n'=0 if year==20`y'
	    replace switch_from_any_to_`k'_y`n'=1 if enrolled_any_in_y1 & enrolled_`k'_in_y`n'==1 & cod_inst_y`n'!=cod_inst_y1 & year==20`y'
	    cap replace switch_from_any_to_`k'_y`n'=1 if switch_from_any_to_`k'_y`n_1'==1 & year==20`y'
		
		cap gen STEM_switch_to_`k'_y`n' =. 
	    replace STEM_switch_to_`k'_y`n'=0 if year==20`y'
		replace STEM_switch_to_`k'_y`n' =1 if STEM_enrolled_any_in_y1 == 1 & enrolled_`k'_in_y`n'==1 & cod_inst_y`n'!=cod_inst_y1 & year==20`y'
	    cap replace STEM_switch_to_`k'_y`n' =1 if STEM_switch_to_`k'_y`n_1' ==1 & year==20`y'
		
		cap gen No_STEM_switch_to_`k'_y`n' =.
	    replace No_STEM_switch_to_`k'_y`n'=0 if year==20`y'
		replace No_STEM_switch_to_`k'_y`n' =1 if No_STEM_enrolled_any_in_y1  == 1 & enrolled_`k'_in_y`n'==1 & cod_inst_y`n'!=cod_inst_y1 & year==20`y'
	    cap replace No_STEM_switch_to_`k'_y`n' =1 if No_STEM_switch_to_`k'_y`n_1' ==1 & year==20`y'
		
	}
	lab var switch_from_any_to_SUA_y`n' "Switch to another selective college by year `n' after enrolling in any higher education institute in year 1"
	lab var switch_from_any_to_voc_y`n' "Switch to vocational institution by year `n' after enrolling in any higher education institute in year 1"
	lab var switch_from_any_to_nonSUA_y`n' "Switch to non-selective college by year `n' after enrolling in any higher education institute in year 1"
	lab var switch_from_any_to_out_y`n' "Switch to outside selective college  by year `n' after enrolling in any higher education institute in year 1"
	lab var switch_from_any_to_any_y`n' "Switch to any college by year `n' after enrolling in any higher education institute in year 1"
	
	lab var STEM_switch_to_SUA_y`n' "Switch to another selective college by year `n' after enrolling in STEM major in any higher education institute in year 1"
	lab var STEM_switch_to_voc_y`n' "Switch to vocational institution by year `n' after enrolling in STEM major in any higher education institute in year 1"
	lab var STEM_switch_to_nonSUA_y`n' "Switch to non-selective college by year `n' after enrolling in STEM major in any higher education institute in year 1"
	lab var STEM_switch_to_out_y`n' "Switch to outside selective college  by year `n' after enrolling in STEM major in any higher education institute in year 1"
	lab var STEM_switch_to_any_y`n' "Switch to any college by year `n' after enrolling in STEM major in any higher education institute in year 1"
	
	lab var No_STEM_switch_to_SUA_y`n' "Switch to another selective college by year `n' after enrolling in Non-STEM major in any higher education institute in year 1"
	lab var No_STEM_switch_to_voc_y`n' "Switch to vocational institution by year `n' after enrolling in Non-STEM major in any higher education institute in year 1"
	lab var No_STEM_switch_to_nonSUA_y`n' "Switch to non-selective college by year `n' after enrolling in Non-STEM major in any higher education institute in year 1"
	lab var No_STEM_switch_to_out_y`n' "Switch to outside selective college  by year `n' after enrolling in Non-STEM major in any higher education institute in year 1"
	lab var No_STEM_switch_to_any_y`n' "Switch to any college by year `n' after enrolling in Non-STEM major in any higher education institute in year 1"
	}
}

*-------------------------------------------------------------------------------
**# Number of Degrees
*-------------------------------------------------------------------------------


	foreach k in SUA voc nonSUA out any {
	
	forvalues mayor=1(1)29 {
			
		gen m`mayor'_grad_`k'_sum = 0
		
		forvalues y=18(1)18 { // for each first year after high school
		
		local years_of_data= ($last_year_enrollment + 1) - `y'
		
			 forvalues n=2(1)`years_of_data'{ // for each year of data after high school
			 
			local n_1=`n'-1 // local for previous year
			
				*gen m`mayor'_grad_`k'_by_y`n' = 0
				*replace m`mayor'_grad_`k'_by_y`n' = 1 if (graduated_`k'_in_y`n' == 1 & major_area_grad_y`n' == `mayor') | (m`mayor'_grad_`k'_by_y`n_1' == 1)
				
				gen m`mayor'_grad_`k'_in_y`n' = 0
				replace m`mayor'_grad_`k'_in_y`n' = 1 if graduated_`k'_in_y`n' == 1 & major_area_grad_y`n' == `mayor'
				
				replace m`mayor'_grad_`k'_sum = m`mayor'_grad_`k'_sum + m`mayor'_grad_`k'_in_y`n'
				
			}
		}
	}
	
	egen number_degrees_`k'= rowtotal(m*_grad_`k'_sum)
}

*-------------------------------------------------------------------------------
**#------------GENERATE SABBATICAL YEAR BY INSTITUTION -------------------------
*-------------------------------------------------------------------------------
gen type_out = 0 
replace type_out = 1 if type_voc == 1 | type_nonSUA == 1

gen type_any = 0 
replace type_any = 1 if type_voc == 1 | type_nonSUA == 1 | type_SUA == 1

gen sabbatical_year = 0 
replace sabbatical_year = 1 if enrollment_year>(year-2000) & enrollment_year<=(year-2000+5) & enrollment_year!=. // sabbatical in the first five years

foreach k in SUA voc nonSUA out any {
		gen sabbatical_year_`k' = 0 
		replace sabbatical_year_`k' = 1 if sabbatical_year == 1 & type_`k' == 1
		count if enrolled_`k'_in_y1 == 1 & sabbatical_year_`k' == 1 //should be equal to 0.
	}
	
label var sabbatical_year_SUA "Sabbatical year if enrolled in a selective college"
label var sabbatical_year_voc "Sabbatical year if enrolled in a vocational institution"
label var sabbatical_year_nonSUA "Sabbatical year if enrolled in a non-selective college"
label var sabbatical_year_out "Sabbatical year if enrolled in an outside college"
label var sabbatical_year_any "Sabbatical year if enrolled in any higher education institution"


gen graduate_top15=1 if  allyears_GPA_rank >=.85 & allyears_GPA_rank !=.
replace graduate_top15=0 if allyears_GPA_rank<.85

gen mean_PSU_score_uni_major_st=(mean_PSU_score_uni_major-500)/110
lab var mean_PSU_score_uni_major_st "Selectivity of regular entrants in SUA uni-major in which enrolled (std)"
* Generate effort variables
gen pre_univ=1 if P27_2==1
replace pre_univ=0 if pre_univ==. & in_sample==1
label var pre_univ "Attendend prep course (not free)"
gen pre_univ_gratis=1 if P27_3==1
replace pre_univ_gratis =0 if pre_univ_gratis==. & in_sample==1
label var pre_univ_gratis "Attended prep course (free)"
gen pre_univ_online=1 if P27_4==1
replace pre_univ_online =0 if pre_univ_online ==. & in_sample ==1
label var pre_univ_online "Took online course (not free)"
gen pre_univ_online_gratis=1 if P27_5==1
replace pre_univ_online_gratis =0 if pre_univ_online_gratis ==. & in_sample ==1
label var pre_univ_online_gratis "Took online course (free)"  
gen study_for_preuniv=1 if P27_6==1
replace study_for_preuniv=0 if study_for_preuniv ==. & in_sample ==1
label var study_for_preuniv "Studied for PSU at home"
gen PSU_prep=study_for_preuniv+pre_univ +pre_univ_gratis +pre_univ_online_gratis+pre_univ_online if in_sample==1
egen PSU_prep_st=std(PSU_prep) if in_sample ==1
label var PSU_prep_st "PSU preparation score (standardized)"
gen actively_preparing_PSU=1 if PSU_prep>0 & PSU_prep!=. & in_sample==1
replace actively_preparing_PSU =0 if PSU_prep==0 & in_sample==1
label var actively_preparing_PSU "Reports having prepared for PSU exam"
foreach var of varlist  P4-P8 {
   egen std_`var' = std(`var')
}
pca std_P4 std_P5 std_P6  std_P7 std_P8 hours_study_st days_study_test_st actively_preparing_PSU , components(1)
predict effort_latent2
egen st_effort_latent2 = std(effort_latent2)
egen std_GPA_core =std(GPA_general_subjects_4m)
egen std_GPA_specific =std(GPA_differentiated_subjects_4m) 

* ----- DESCRIPTION OF SUBJECTIVE BELIEFS	
gen PSU_st=(PSU_score_if_positive -500)/110
label var PSU_st "PSU entry score, standardized nationally"
gen exp_PSU_st=(exp_PSUscore -500)/110
label var exp_PSU_st "Believed PSU entry score, standardized nationally"
gen PSU_st_bias=exp_PSU_st-PSU_st
label var PSU_st_bias "Believed minus actual PSU score (both standardized nationally)"
gen think_top15=1 if exp_NEM >=NEM_top15 & exp_NEM!=. & NEM_top15!=.
replace think_top15=0 if exp_NEM <NEM_top15 & exp_NEM!=. & NEM_top15!=.
label var think_top15 "Believe is in top 15 percent of school"
gen minus_bias_top15=-bias_top15
sum exp_PSU_st PSU_st_bias bias_own_NEM minus_bias_top15 think_top15  if treatment==0 & in_experimental_schools==1
gen p_admitted_above_050=0 if p_admitted!=.
replace p_admitted_above_050=1 if p_admitted>=0.5 & p_admitted!=.

keep if in_experimental_schools==1
drop _merge
* Merge with data on distance and selectivity of enrolled university
merge 1:1 mrun using "$dataTemp/data_enrollment_distance_selectivity.dta"
drop if _merge==2
drop _merge 
replace distance_enrolled=. if enrolled_SUA_in_18!=1
replace mean_PSU_score_enrolled=. if enrolled_SUA_in_18!=1
* Merge with data on PACE applications criteria
merge 1:1 mrun using "$dataRaw/Postulantes Cupos Regulares/PACEcriterios_mrun_2018.dta", keepusing(criterio_1 criterio_2 criterio_3)
drop if _merge==2
gen eligible_pace=0
replace eligible_pace=1 if criterio_1==1 & criterio_2==1 & criterio_3==1
lab var eligible_pace "Satisfies all three criteria"
drop criterio_1 criterio_2 criterio_3 _merge
* Save clean dataset
save "$dataClean/data_experimental.dta", replace

