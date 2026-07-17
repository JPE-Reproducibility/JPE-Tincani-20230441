
* Geolocalize universities and high schools to compute distance
* Install relevant packages
*ssc install insheetjson
*ssc install libjson
*ssc install opencagegeo
*ssc install geodist
* The package opencagegeo geolocalize cities and addresses. It requires an OpenCage Data API key 
* To obtain this, sign up at https://geocoder.opencagedata.com/users
* Create an API key and copy-paste it in the key option of the command opencage geo. The free lan allows 2.500 API requests per day.
* Save list of universities and their sigla universidad
* Geolocalize universities of enrollment in 2018
global keycode [insert_key_code_here] // INSERT KEY CODE HERE
import delimited "$dataRawPublic/Enrollment/20220719_Matrícula_Ed_Superior_2018_PUBL_MRUN.csv", delimiter(";") clear
keep nomb_inst nomb_sede comuna_sede
duplicates drop
gen COUNTRY = "CHILE"
egen ADDRESS=concat(comuna_sede nomb_inst COUNTRY), punct(, )
opencagegeo, key($keycode) fulladdress(ADDRESS)  // geocode universities 
egen ADDRESS2=concat(comuna_sede COUNTRY), punct(, )
opencagegeo if g_city=="", key($keycode) fulladdress(ADDRESS2)   replace  // geocode universities using only city and country if missing
egen ADDRESS3=concat(nomb_inst  COUNTRY), punct(, )
opencagegeo if g_city=="", key($keycode) fulladdress(ADDRESS3)   replace  // geocode universities using only university and country if missing
rename g_lat latitude_university
rename g_lon longitude_university
destring latitude_university, replace
destring longitude_university, replace
rename g_state region_university
rename g_city town_university
keep comuna_sede nomb_sede nomb_inst latitude_university longitude_university region_university town_university
isid comuna_sede nomb_sede nomb_inst 
save "$dataRaw/Distance_and_transfers_to_universities/enrollment_university_geocoded.dta", replace
* Geolocalize universities of all experimental students' application preference list
use "$dataTemp/ranking_applications_university_municipality_PACE.dta", clear
merge 1:1 sede_carrera sigla_universidad using "$dataTemp/ranking_applications_university_municipality_regular.dta", nogen
merge m:1 sigla_universidad using  "$dataRaw/List_selective_colleges/universidades.dta"
drop if _merge==2
drop _merge
replace nombre_universidad="Universidad Autónoma de Chile" if sigla_universidad=="UA"
replace nombre_universidad="Universidad Austral de Chile" if sigla_universidad=="UACh"
replace nombre_universidad="Universidad de Antofagasta" if sigla_universidad=="UANT"
replace nombre_universidad="Universidad de Aysén" if sigla_universidad=="UAYSEN"
replace nombre_universidad="Pontificia Universidad Católica de Chile" if sigla_universidad=="UC"
replace nombre_universidad="Universidad Central de Chile" if sigla_universidad=="UCENTRAL"
replace nombre_universidad="Universidad de Los Lagos" if sigla_universidad=="ULAG"
replace nombre_universidad="Universidad de Magallanes" if sigla_universidad=="UMAG"
replace nombre_universidad="Universidad Mayor" if sigla_universidad=="UMAYOR"
replace nombre_universidad="Universidad de O'Higgins" if sigla_universidad=="UOH"
replace nombre_universidad="Universidad Federíco Santa María" if sigla_universidad=="USM"
gen sede_carrera_correct=sede_carrera
replace sede_carrera_correct = "" if regexm(sede_carrera, "FACULTAD")
replace sede_carrera_correct = "" if regexm(sede_carrera, "VICERRECTORÍA ACADÉMICA")
replace sede_carrera_correct = regexr(sede_carrera, "SEDE CENTRAL - ", "")
replace sede_carrera_correct = regexr(sede_carrera, "SEDE", "")
replace sede_carrera_correct = regexr(sede_carrera, "CAMPUS", "")
gen COUNTRY = "CHILE"
egen ADDRESS=concat(sede_carrera_correct nombre_universidad  COUNTRY), punct(, )
opencagegeo, key($keycode) fulladdress(ADDRESS)  // geocode universities 
opencagegeo if g_city=="", key($keycode) city(sede_carrera_correct)  country(COUNTRY) replace  // geocode universities using only city if university is still missing 
egen ADDRESS2=concat( nombre_universidad  COUNTRY), punct(, )
opencagegeo if g_city=="", key($keycode) fulladdress(ADDRESS2)   replace  // geocode universities using only university if city is still missing 
drop sede_carrera_correct
rename g_lat latitude_university
rename g_lon longitude_university
destring latitude_university, replace
destring longitude_university, replace
rename g_state region_university
rename g_city town_university
keep sede_carrera sigla_universidad nombre_universidad latitude_university longitude_university region_university town_university
save "$dataRaw/Distance_and_transfers_to_universities/ranking_applications_university_geocoded.dta", replace
* Geolocalize high schools of all experimental students
use "$dataTemp/basefinal_merged_all_clean.dta", clear
keep rbd_basefinal nom_com_rbd nom_deprov_rbd
duplicates drop 
gen COUNTRY = "CHILE"
opencagegeo, key($keycode)  city(nom_com_rbd) county(nom_deprov_rbd)  country(COUNTRY) // geocode students' municipalities using provinces and towns
opencagegeo if g_city=="", key($keycode)  city(nom_com_rbd)  country(COUNTRY) replace // geocode students' municipalities using towns 
rename g_lat latitude_high_school
rename g_lon longitude_high_school
destring latitude_high_school, replace
destring longitude_high_school, replace
rename g_state region_high_school
rename g_city town_high_school
keep rbd_basefinal nom_com_rbd nom_deprov_rbd latitude_high_school longitude_high_school region_high_school town_high_school
save "$dataRaw/Distance_and_transfers_to_universities/high_school_geocoded.dta", replace
* Geolocalize high schools of all experimental students that applied
use "$dataTemp/ranking_applications_high_school_PACE.dta", clear
merge 1:1 nom_com_rbd nom_deprov_rbd using "$dataTemp/ranking_applications_high_school_regular.dta", nogen
gen COUNTRY = "CHILE"
opencagegeo, key($keycode)  city(nom_com_rbd) county(nom_deprov_rbd)  country(COUNTRY) // geocode students' municipalities using provinces and towns
opencagegeo if g_city=="", key($keycode)  city(nom_com_rbd)  country(COUNTRY) replace // geocode students' municipalities using towns 
rename g_lat latitude_high_school
rename g_lon longitude_high_school
rename g_state region_high_school
rename g_city town_high_school
destring latitude_high_school, replace
destring longitude_high_school, replace
keep nom_com_rbd nom_deprov_rbd latitude_high_school longitude_high_school region_high_school town_high_school
save "$dataRaw/Distance_and_transfers_to_universities/ranking_applications_high_school_geocoded.dta", replace

