
*******************************************************************************
* DO-FILE DESCRIPTION:
* This do-file generates in-text numbers that are not reported in any table
********************************************************************************
capture log close
log using "$output/in_text_numbers/in_text_numbers.log", replace

use "$dataClean/data_population_PSU_students.dta", clear
su simce_avg_st_pop if in_experimental_schools==1 & treatment==0
local mean_simce_target=r(mean)
su simce_avg_st_pop if via_ingreso==1
local mean_simce_regular=r(mean)
local diff=round(`mean_simce_regular'-`mean_simce_target', 0.01)
di "Students in targeted schools score `diff' standard deviations below regular entrants on average."

use "$dataClean/data_experimental.dta", clear
reg enrolled_SUA_by_y5 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad
local effect=round(100*_b[treatment],0.1)
di "effect: `effect'%"
su enrolled_SUA_by_y5 if treatment==0
local mean_control=round(100*r(mean),1)
local pc_change=round(100*`effect'/`mean_control', 1)
di "change: `pc_change'%"
reg enrolled_SUA_by_y5 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad
est store y5
reg enrolled_SUA_by_y1 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad
est store y1
suest y5 y1, cluster(rbd_basefinal)
lincom [y5_mean]treatment - [y1_mean]treatment
local p_val=round(r(p),0.001)
di  "p-value:`p_val'"
di "The effect on continuous enrollment in the fifth year or graduation by such time (which is an upper bound for the effect on on-time graduation) is `effect' p.p., corresponding to a `pc_change'% increase compared to the control group, and it is significantly different (p=`p_val') from the treatment effect on first-year enrollments."

use "$dataClean/data_experimental.dta", clear
reg enrolled_SUA_by_y1 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1
est store y1
local effect_top15_y1 : display %6.1f 100*_b[treatment] 
di "effect year 1: `effect_top15_y1'%"
reg enrolled_SUA_by_y5 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1
est store y5
local effect_top15_y5 : display %6.1f 100*_b[treatment] 
di "effect year 5: `effect_top15_y5'%"
suest y5 y1, cluster(rbd_basefinal)
lincom [y5_mean]treatment - [y1_mean]treatment
local p_val_top15: display %6.3f r(p)
di  "p-value top 15:`p_val_top15'"
su enrolled_SUA_by_y1 if treatment==0 & top15baseline==1
local mean_control_top15=r(mean)
local pc_change_top15_y1=round(`effect_top15_y1'/`mean_control_top15', 1)
di "change year 1, top 15: `pc_change_top15_y1'%"
su enrolled_SUA_by_y5 if treatment==0 & top15baseline==1
local mean_control_top15=r(mean)
local pc_change_top15_y5=round(`effect_top15_y5'/`mean_control_top15', 1)
di "change year 5, top 15: `pc_change_top15_y5'%"
di "Although selective college enrollment effects remained significant and positive five years after high school, they were smaller and significantly different (p = `p_val_top15') from first-year effects: first-year enrollments increased by `effect_top15_y1' p.p., `pc_change_top15_y1'% relative to the control group mean, while fifth-year enrollments showed an `effect_top15_y5' p.p., or `pc_change_top15_y5'%, increase (Table A6)."

insheet using "$dataClean/baseline_TC_2types_rescale.csv", clear
rename x32 sim_type
gen alltypes=1
gen type1=1 if sim_type==1
gen type2=1 if sim_type==2
collapse (sum) alltypes type1 type2
gen double type1_pc=round(100*type1/alltypes,0.1)
su type1_pc
gen double type2_pc=round(100*type2/alltypes,0.1)
su type2_pc
di "We estimate that " type1_pc "% of the sample belongs to type 1, while " type2_pc "% belongs to type 2."

insheet using "$dataClean/baseline_TC_3types_rescale.csv", clear
rename x32 sim_type
gen alltypes=1
gen type3=1 if sim_type==3
collapse (sum) alltypes type3
gen type3_pc=round(100*type3/alltypes,1)
su type3_pc
di "In the latter model, only " type3_pc " percent of students are assigned to the third type."

use "$dataClean/data_experimental.dta", clear
su p_graduate
local p_graduate_b: display %5.0f 100*r(mean)
di "Belief on persistence probability: `p_graduate_b'%"
insheet using "$dataClean/baseline_CC_2types_rescale.csv", clear
rename x1 mrun
rename x2 rbd_basefinal
rename x3 treatment
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
rename x8 sim_persist_SUA
rename x9 sim_admitted_SUA_regular
rename x10 sim_admitted_SUA_pace 
gen sim_admitted=1 if sim_admitted_SUA_regular==1 | sim_admitted_SUA_pace==1
replace sim_admitted=0 if sim_admitted==.
su sim_persist_SUA if sim_admitted==1
local p_graduate_o: display %5.0f 100*r(mean)
di "Actual persistence probability: `p_graduate_o'%"
di "While students, on average, expect a `p_graduate_b'% likelihood of persistence, their actual persistence probability is only `p_graduate_o'%."

use "$dataClean/data_experimental.dta", clear
su expearn_uni, d
local mean_expearn_uni=r(mean)
su expearn_nouni, d
local mean_expearn_nouni=r(mean)
local uni_premium: display %5.0f 100*(`mean_expearn_uni'-`mean_expearn_nouni')/`mean_expearn_nouni'
di "We find that the policy had no impact on students' beliefs about the monetary returns to college (Section E.2.1), which are large at `uni_premium'% of age 30 earnings."
di "We find that students think that, on average, the return to a college degree is `uni_premium' percent."

use "$dataClean/data_experimental.dta", clear
su aware_waiver
local mean_aware: display %5.1f 100*r(mean)
reg aware_waiver treatment simce_avg_st female age alumno_prioritario neverfailed modalidad, cluster(rbd_basefinal)
local t = _b[treatment] / _se[treatment]
local p_val_aware : display %5.3f 2*ttail(e(df_r), abs(`t'))
di "The policy had no effect on students' awareness of financial aid (`mean_aware'% of surveyed students are aware they are eligible for a tuition fee waiver, and there is no statistically significant difference between the treatment and control groups (p=`p_val_aware'))."

use "$dataClean/data_experimental.dta", clear
corr nem ptje_ranking
local corr_GPA_PRN: display %5.2f 100*r(rho) 
di "The Pearson's correlation coefficient between the unadjusted four-year grade point average and the PRN is `corr_GPA_PRN'%" 
 
use "$dataClean/data_experimental.dta", clear
su in_sample
local pc_in_survey: display %5.0f 100*round(r(mean),0.1)
count if in_sample==1
local N_in_survey: display %5.0f r(N)
di "We surveyed `N_in_survey' students, approximately `pc_in_survey'% of those enrolled in the 128 sample schools."

import excel "$dataRaw/List_selective_colleges/Sistema de Acceso y SUA desde 2016 100423.xlsx", sheet("Hoja2 (2)") firstrow clear
keep if MAT_2018=="Si"
rename NOMBREINSTITUCIÓN nomb_inst
keep nomb_inst MAT_2018
save "$dataTemp/SUA_uni_2018.dta", replace
import delimited "$dataRawPublic/Enrollment/20220719_Matrícula_Ed_Superior_2018_PUBL_MRUN.csv", delimiter(";") clear // upload all enrolled
keep if anio_ing_carr_ori==2018 // keep only first-year students
merge m:1 nomb_inst using "$dataTemp/SUA_uni_2018.dta"
gen enrolled_SUA=0
replace enrolled_SUA=1  if MAT_2018=="Si"
gen enrolled_voc=0
replace enrolled_voc=1 if tipo_inst_3=="Centros de Formación Técnica" | tipo_inst_3=="Centros de Formación Técnica Estatal" | tipo_inst_3=="Institutos Profesionales"
gen enrolled_off_platform=0
replace enrolled_off_platform=1 if enrolled_SUA==0 & enrolled_voc==0
su enrolled_SUA
local pc_enrolled_SUA: display %5.0f round(100*r(mean),1)
su enrolled_voc
local pc_enrolled_voc: display %5.0f round(100*r(mean),1)
su enrolled_off_platform
local pc_enrolled_off_platform: display %5.0f round(100*r(mean),1)
keep if MAT_2018=="Si"
keep nomb_inst tipo_inst_3
duplicates drop
count if tipo_inst_3=="Universidades Estatales CRUCH" | tipo_inst_3=="Universidades Privadas CRUCH"
local N_SUA_CRUCH=r(N)
count if tipo_inst_3=="Universidades Privadas"
local N_SUA_other=r(N)
di "They include the `N_SUA_CRUCH' public and private not-for-profit colleges...and `N_SUA_other' additional private colleges..."
di "In 2018, the shares of tertiary enrollments were `pc_enrolled_SUA'% for selective colleges, `pc_enrolled_off_platform'% for off-platform colleges, and `pc_enrolled_voc'% for vocational institutes."  

use "$dataClean/data_experimental.dta", clear
summ hh_income, detail
scalar avg_hh_income_target = round(r(mean), 0.001)
use "$dataClean/data_population_PSU_students.dta", clear
summ hh_income if via_ingreso == 1, detail
scalar avg_hh_income_regular = round(r(mean), 0.001)
* Source: https://observatorio.ministeriodesarrollosocial.gob.cl/storage/docs/casen/2015/CASEN_2015_Ingresos_de_los_hogares.pdf
scalar average_hh_income_chile = 579.307 // V decile, Evolución del ingreso monetario promedio del hogar por decil de ingreso autónomo per cápita del hogar (2006-2015)
local pc_hh_inc_target_chile = round(100 * scalar(avg_hh_income_target) / scalar(average_hh_income_chile), 1)
local pc_hh_inc_target_reg   = round(100 * scalar(avg_hh_income_target) / scalar(avg_hh_income_regular), 1)
local pc_hh_inc_reg_chile    = round(100 * (scalar(avg_hh_income_regular)-scalar(average_hh_income_chile)) / scalar(average_hh_income_chile), 1)
local avg_hh_income_regular_fmt : display %5.3f scalar(avg_hh_income_regular)
display "Family income in this group is `pc_hh_inc_target_chile'% of the median household income in Chile, and `pc_hh_inc_target_reg'% of the family income of regular entrants, whose average family income of CLP `avg_hh_income_regular_fmt' per month is `pc_hh_inc_reg_chile'% above the median Chilean income."

use "$dataClean/data_population_PSU_students.dta", clear
su simce_avg_st_pop if in_experimental_schools==1 & graduate_top15==1 & treatment==0
local mean_simce_target_top15=r(mean)
su simce_avg_st_pop if via_ingreso==1
local mean_simce_regular=r(mean)
local diff_top15=round(`mean_simce_regular'-`mean_simce_target_top15', 0.01)
xtile percentile_simce=simce_avg_st_pop if via_ingreso == 1, nquantiles(100)
su simce_avg_st_pop if in_experimental_schools==1, d
local median_simce=r(p50)
di `median_simce'
su simce_avg_st_pop if graduate_top15==1  & in_experimental_schools==1, d
local median_simce_top15=r(p50)
su percentile_simce  if (via_ingreso == 1 & (simce_avg_st_pop>=`median_simce'+0.01*`median_simce') & (simce_avg_st_pop<=`median_simce'-0.01*`median_simce'))
local ptile_simce=r(mean)
su percentile_simce  if (via_ingreso == 1 & (simce_avg_st_pop>=`median_simce_top15'-0.01*`median_simce_top15') & (simce_avg_st_pop<=`median_simce_top15'+0.01*`median_simce_top15'))
local ptile_simce_top15=r(mean)  
di "Their median score corresponds to the `ptile_simce'th percentile of scores among regular entrants. Even those who graduate in the top 15% of targeted schools score substantially worse than regular college entrants, 0`diff_top15' standard deviations below on average. Their median score corresponds to the `ptile_simce_top15'th percentile of scores among regular entrants." 

use "$dataClean/data_experimental.dta", clear
su actively_preparing_PSU if in_experimental_school==1 & treatment==0
local pc_preparing_PSU: display %5.0f round(100*r(mean),1)
di "Two thirds of students take the college entrance exam (second row of Table 3), which aligns nicely with our survey data, where `pc_preparing_PSU'% report preparing for it."

use "$dataClean/data_experimental.dta", clear
gen at_most_secondary_m=0 if meduc!=.
replace at_most_secondary_m=1 if meduc<=12 & meduc!=.
su at_most_secondary_m
local pc_at_most_secondary_m=round(100*r(mean), 1)
di "`pc_at_most_secondary_m'% of mothers did not study beyond secondary education"
gen at_post_secondary_p=0 if peduc!=.
replace at_post_secondary_p=1 if peduc<=12 & peduc!=.
su at_post_secondary_p
local pc_at_post_secondary_p=round(100*r(mean), 1)
di "`pc_at_post_secondary_p'% of fathers did not study beyond secondary education"
local pc_at_post_secondary=round(min(`pc_at_most_secondary_m', `pc_at_post_secondary_p'),10)
di "These belief biases are consistent with the limited college experience of students' parents (over `pc_at_post_secondary'% did not study beyond secondary education)"

use "$dataClean/data_experimental.dta", clear
su select_adm_uni_major
local min_PSU: display %5.0f r(mean)
di "The minimum PSU required for regular admission varies by program, averaging `min_PSU'."  
su exp_PSUscore, d
local median_exp_PSU: display %5.0f r(p50)
di "The median subjective expectation  [`median_exp_PSU'] for PSU scores falls within the 450-600 range. "

insheet using "$dataClean/baseline_TC_2types_rescale.csv", clear
rename x3 treatment
rename x32 sim_type
rename x6 sim_enrolled_SUA_regular
rename x7 sim_enrolled_SUA_pace 
gen sim_enrolled_SUA=1 if sim_enrolled_SUA_regular==1 | sim_enrolled_SUA_pace==1
replace sim_enrolled_SUA=0 if sim_enrolled_SUA==.
gen type2=0
replace type2=1 if sim_type==2
su type2 if treatment==1 & sim_enrolled_SUA==1
local pc_type2_treated_enr=round(100*r(mean), 1)
su type2 if treatment==0 & sim_enrolled_SUA==1
local pc_type2_control_enr=round(100*r(mean), 1)
local diff_pc_type2_enr=`pc_type2_treated_enr'-`pc_type2_control_enr'
di "In fact, the model indicates that the share of type 2 students (those least likely to persist) is `diff_pc_type2_enr' p.p. higher among college entrants from treated schools."

log close

