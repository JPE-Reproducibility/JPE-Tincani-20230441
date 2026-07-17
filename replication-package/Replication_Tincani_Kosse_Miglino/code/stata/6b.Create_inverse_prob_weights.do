********************************************************************************
* DO-FILE DESCRIPTION:
* Create inverse probability weights
********************************************************************************

use "$dataTemp/basefinal_merged_all_nw.dta", clear

preserve
*Create inverse probability weights for FOCUS sample based on Matricula data. 
probit in_sample treatment female age i.cod_reg_rbd alumno_prioritario if in_experimental_schools==1 //cod_reg_rbd is the region
predict temp if in_experimental_schools==1 , pr
gen weight_mat=1/temp //This brings back to Matricula population proportions of characteristics: inverse probability of being the sample
lab var weight_mat "Weight to use in regressions with at most matricula regressors" 
drop temp

*Create inverse probability weights for simce data based on Matricula data.
gen in_sample_simce=1 if in_sample==1 & in_simce==1
replace in_sample_simce=0 if in_sample==0 | in_simce==0
probit in_sample_simce treatment female age i.cod_reg_rbd alumno_prioritario if in_experimental_schools==1
predict temp1 if in_experimental_schools==1 , pr
gen weight_simce_score=1/temp
lab var weight_simce_score "Weight to use in regressions with at most simce test scores" 


*Create inverse probability weights for simce cpad based on Matricula data.
gen in_sample_simce_cpad=1 if in_sample==1 & in_simce==1 & in_cpad==1
replace in_sample_simce_cpad=0 if in_simce==1 & (in_sample==0 | in_cpad==0)
probit in_sample_simce_cpad treatment female age i.cod_reg_rbd alumno_prioritario ptje_lect2m_alu ptje_mate2m_alu if in_experimental_schools==1
predict temp2 if in_experimental_schools==1 , pr
gen weight_simce_cpad=1/(temp1*temp2)
lab var weight_simce_cpad "Weight to use in regressions with matricula, simce and cpad regressors" 
drop temp*
keep mrun weight_*
saveold "$dataTemp/probability_weights.dta", replace
restore 

preserve
*Create inverse probability weights for April sample based on Matricula data. 
replace in_April_sample=0 if in_April_sample==.
tab in_April_sample
probit in_April_sample treatment female age i.cod_reg_rbd alumno_prioritario if in_experimental_schools==1
predict temp if in_experimental_schools==1, pr
gen weight_mat_April=1/temp //This brings back to Matricula population proportions of characteristics: inverse probability of being the sample
lab var weight_mat_April "Weight to use in regressions with at most matricula regressors" 
drop temp

*Create inverse probability weights for simce data (April) based on Matricula data.
gen in_April_sample_simce=1 if in_April_sample==1 & in_simce==1
replace in_April_sample_simce=0 if in_April_sample==0 | in_simce==0
probit in_April_sample_simce treatment female age i.cod_reg_rbd alumno_prioritario if in_experimental_schools==1
predict temp1 if in_experimental_schools==1 , pr
gen weight_simce_score_April=1/temp
lab var weight_simce_score_April "Weight to use in regressions with at most simce test scores" 

*Create inverse probability weights for simce cpad data (April) based on Matricula data.
gen in_April_sample_simce_cpad=1 if in_April_sample==1 & in_simce==1 & in_cpad==1
replace in_April_sample_simce_cpad=0 if in_simce==1 & (in_April_sample==0 | in_cpad==0)
probit in_April_sample_simce_cpad treatment female age i.cod_reg_rbd alumno_prioritario ptje_lect2m_alu ptje_mate2m_alu if in_experimental_schools==1
predict temp2 if in_experimental_schools==1 , pr
gen weight_simce_cpad_April=1/(temp1*temp2)
lab var weight_simce_cpad_April "Weight to use in regressions with matricula, simce and cpad regressors" 
drop temp*
keep mrun weight_*
saveold "$dataTemp/probability_weights_april.dta", replace
restore

preserve
*Create inverse probability weights for April sample based on Matricula data. 
gen in_GPAdifferentiated_sample=0 if (GPA_differentiated_subjects_3m==. | GPA_differentiated_subjects_4m==.)
replace in_GPAdifferentiated_sample=1 if (GPA_differentiated_subjects_3m!=. & GPA_differentiated_subjects_4m!=.)
probit in_GPAdifferentiated_sample treatment female age i.cod_reg_rbd alumno_prioritario if in_experimental_schools==1
predict temp if in_experimental_schools==1 , pr
gen weight_GPAdifferentiated=1/temp //This brings back to Matricula population proportions of characteristics: inverse probability of being the sample
lab var weight_GPAdifferentiated "Weight to use in regressions for GPA differentiated" 
drop temp
keep mrun weight_*
saveold "$dataTemp/probability_weights_GPAdifferentiated.dta", replace
restore

preserve
*Create inverse probability weights for April sample based on Matricula data. 
gen in_GPAgeneral_sample=0 if (GPA_general_subjects_3m==. | GPA_general_subjects_4m==.)
replace in_GPAgeneral_sample=1 if (GPA_general_subjects_3m!=. & GPA_general_subjects_4m!=.)
probit in_GPAgeneral_sample treatment female age i.cod_reg_rbd alumno_prioritario if in_experimental_schools==1
predict temp if in_experimental_schools==1 , pr
gen weight_GPAgeneral=1/temp //This brings back to Matricula population proportions of characteristics: inverse probability of being the sample
lab var weight_GPAgeneral "Weight to use in regressions for GPA general" 
drop temp
keep mrun weight_*
saveold "$dataTemp/probability_weights_GPAgeneral.dta", replace
restore

preserve
*Create inverse probability weights for April sample based on Matricula data. 
gen in_GPAdifferentiated_sample=0 if (GPA_differentiated_subjects_3m==. | GPA_differentiated_subjects_4m==.)
replace in_GPAdifferentiated_sample=1 if (GPA_differentiated_subjects_3m!=. & GPA_differentiated_subjects_4m!=.)
probit in_GPAdifferentiated_sample treatment female age i.cod_reg_rbd alumno_prioritario if in_eligible_schools==1
predict temp if in_eligible_schools==1, pr
gen weight_GPAdifferentiated_e=1/temp //This brings back to Matricula population proportions of characteristics: inverse probability of being the sample
lab var weight_GPAdifferentiated_e "Weight to use in regressions for GPA differentiated (all eligible schools)" 
drop temp
keep mrun weight_*
saveold "$dataTemp/probability_weights_GPAdifferentiated_e.dta", replace
restore

preserve
*Create inverse probability weights for April sample based on Matricula data. 
gen in_GPAgeneral_sample=0 if (GPA_general_subjects_3m==. | GPA_general_subjects_4m==.)
replace in_GPAgeneral_sample=1 if (GPA_general_subjects_3m!=. & GPA_general_subjects_4m!=.)
probit in_GPAgeneral_sample treatment female age i.cod_reg_rbd alumno_prioritario if in_eligible_schools==1
predict temp if in_eligible_schools==1, pr
gen weight_GPAgeneral_e=1/temp //This brings back to Matricula population proportions of characteristics: inverse probability of being the sample
lab var weight_GPAgeneral_e "Weight to use in regressions for GPA general (all eligible schools)" 
drop temp
keep mrun weight_*
saveold "$dataTemp/probability_weights_GPAgeneral_e.dta", replace
restore

