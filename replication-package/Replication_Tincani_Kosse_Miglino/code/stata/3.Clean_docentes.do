********************************************************************************
* DO-FILE DESCRIPTION:
* Clean data on high-school teachers
********************************************************************************

use "$dataRaw/Teachers_and_principals/Docentes 29-12_rp.dta", clear

rename Q44_1_0 rbd_basefinal
rename Q1 teaching_subject

keep rbd_basefinal teaching_subject Q51 Q52 Q53 ///
    Q4_1 Q4_2 Q4_3 Q4_4 Q4_5 Q4_6 Q4_7 Q4_8 Q4_9 Q4_10 Q4_11 ///
    Q6_1 Q6_2 Q6_3 Q6_4 Q6_5 Q6_6 Q6_7 Q6_8 Q6_9 Q6_15 ///
    Q71 Q74 Q76 ///
    Q105_1 Q105_2 Q105_3 Q105_4 Q105_5 Q105_8 Q105_9 Q105_10 ///
    Q106_x1 Q106_x2 Q106_x3 Q106_x4 Q106_x5 Q106_x8 Q106_x9 Q106_x10 ///
    Q107_1 Q108_x1 Q109_1 Q109_4 Q110_x1 Q110_x4 ///
    Q111_1 Q111_2 Q112_x1 Q112_x2 ///
    Q120_1 Q120_2 Q121_x1 Q121_x2 ///
    Q122_1 Q123_x1 ///
    Q124_1 Q124_2 Q125_x1 Q125_x2 ///
    Q126_1 Q126_2 Q127_x1 Q127_x2 ///
    Q128_3 Q128_4 Q128_5 Q128_6 Q129_x3 Q129_x4 Q129_x5 Q129_x6

keep if Q53 != 7

gen modalidad = .
replace modalidad = 1 if Q51 == 1 | Q52 == 1
replace modalidad = 0 if Q51 == 2 | Q52 == 2

gen hours_teach_outside = 0 if Q74 == 1
replace hours_teach_outside = 2 if Q74 == 2
replace hours_teach_outside = 5 if Q74 == 3
replace hours_teach_outside = 8.5 if Q74 == 4
replace hours_teach_outside = 12 if Q74 == 5
lab var hours_teach_outside "Hours taught outside classes for students that asked for additional help"

gen hours_teach_prep = 0.5 if Q76 == 1
replace hours_teach_prep = 1.5 if Q76 == 2
replace hours_teach_prep = 3.5 if Q76 == 3
replace hours_teach_prep = 5.5 if Q76 == 4
replace hours_teach_prep = 6.5 if Q76 == 5
lab var hours_teach_prep "Hours spent by teacher to prepare classes"

forvalues n = 1(1)5 {
    gen Q105_`n'_p = 0 if Q105_`n' == 1
    replace Q105_`n'_p = 0.25 if Q105_`n' == 2
    replace Q105_`n'_p = 0.5 if Q105_`n' == 3
    replace Q105_`n'_p = 0.75 if Q105_`n' == 4
    replace Q105_`n'_p = 1 if Q105_`n' == 5
}
forvalues n = 8(1)10 {
    gen Q105_`n'_p = 0 if Q105_`n' == 1
    replace Q105_`n'_p = 0.25 if Q105_`n' == 2
    replace Q105_`n'_p = 0.5 if Q105_`n' == 3
    replace Q105_`n'_p = 0.75 if Q105_`n' == 4
    replace Q105_`n'_p = 1 if Q105_`n' == 5
}

forvalues n = 1(1)5 {
    gen Q106_x`n'_p = 0 if Q106_x`n' == 1
    replace Q106_x`n'_p = 0.25 if Q106_x`n' == 2
    replace Q106_x`n'_p = 0.5 if Q106_x`n' == 3
    replace Q106_x`n'_p = 0.75 if Q106_x`n' == 4
    replace Q106_x`n'_p = 1 if Q106_x`n' == 5
}
forvalues n = 8(1)10 {
    gen Q106_x`n'_p = 0 if Q106_x`n' == 1
    replace Q106_x`n'_p = 0.25 if Q106_x`n' == 2
    replace Q106_x`n'_p = 0.5 if Q106_x`n' == 3
    replace Q106_x`n'_p = 0.75 if Q106_x`n' == 4
    replace Q106_x`n'_p = 1 if Q106_x`n' == 5
}

forvalues n = 1(1)5 {
    gen Q105XQ106_x`n'_p = Q105_`n'_p * Q106_x`n'_p
}
forvalues n = 8(1)10 {
    gen Q105XQ106_x`n'_p = Q105_`n'_p * Q106_x`n'_p
}
egen algebra_prog_focus = rowmean(Q105XQ106_x1_p Q105XQ106_x2_p Q105XQ106_x3_p ///
    Q105XQ106_x4_p Q105XQ106_x5_p Q105XQ106_x8_p Q105XQ106_x9_p Q105XQ106_x10_p)

gen geom_prog_cover = 0 if Q107_1 == 1
replace geom_prog_cover = 0.25 if Q107_1 == 2
replace geom_prog_cover = 0.5 if Q107_1 == 3
replace geom_prog_cover = 0.75 if Q107_1 == 4
replace geom_prog_cover = 1 if Q107_1 == 5

gen geom_prog_difficulty = 0 if Q108_x1 == 1
replace geom_prog_difficulty = 0.25 if Q108_x1 == 2
replace geom_prog_difficulty = 0.5 if Q108_x1 == 3
replace geom_prog_difficulty = 0.75 if Q108_x1 == 4
replace geom_prog_difficulty = 1 if Q108_x1 == 5
gen geom_prog_focus = geom_prog_cover * geom_prog_difficulty

foreach n of numlist 1 4 {
    gen Q109_`n'_p = 0 if Q109_`n' == 1
    replace Q109_`n'_p = 0.25 if Q109_`n' == 2
    replace Q109_`n'_p = 0.5 if Q109_`n' == 3
    replace Q109_`n'_p = 0.75 if Q109_`n' == 4
    replace Q109_`n'_p = 1 if Q109_`n' == 5
    gen Q110_x`n'_p = 0 if Q110_x`n' == 1
    replace Q110_x`n'_p = 0.25 if Q110_x`n' == 2
    replace Q110_x`n'_p = 0.5 if Q110_x`n' == 3
    replace Q110_x`n'_p = 0.75 if Q110_x`n' == 4
    replace Q110_x`n'_p = 1 if Q110_x`n' == 5
    gen Q109XQ110_x`n'_p = Q109_`n'_p * Q110_x`n'_p
}
egen stat_prog_focus = rowmean(Q109XQ110_x1_p Q109XQ110_x4_p)

foreach n of numlist 1 2 {
    gen Q111_`n'_p = 0 if Q111_`n' == 1
    replace Q111_`n'_p = 0.25 if Q111_`n' == 2
    replace Q111_`n'_p = 0.5 if Q111_`n' == 3
    replace Q111_`n'_p = 0.75 if Q111_`n' == 4
    replace Q111_`n'_p = 1 if Q111_`n' == 5
    gen Q112_x`n'_p = 0 if Q112_x`n' == 1
    replace Q112_x`n'_p = 0.25 if Q112_x`n' == 2
    replace Q112_x`n'_p = 0.5 if Q112_x`n' == 3
    replace Q112_x`n'_p = 0.75 if Q112_x`n' == 4
    replace Q112_x`n'_p = 1 if Q112_x`n' == 5
    gen Q111XQ112_x`n'_p = Q111_`n'_p * Q112_x`n'_p
}
egen trigon_prog_focus = rowmean(Q111XQ112_x1_p Q111XQ112_x2_p)

egen math_prog_focus = rowmean(algebra_prog_focus geom_prog_focus stat_prog_focus trigon_prog_focus)
lab var math_prog_focus "Percentage of Mathematics program focus of instruction"

foreach n of numlist 1 2 {
    gen Q120_`n'_p = 0 if Q120_`n' == 1
    replace Q120_`n'_p = 0.25 if Q120_`n' == 2
    replace Q120_`n'_p = 0.5 if Q120_`n' == 3
    replace Q120_`n'_p = 0.75 if Q120_`n' == 4
    replace Q120_`n'_p = 1 if Q120_`n' == 5
    gen Q121_x`n'_p = 0 if Q121_x`n' == 1
    replace Q121_x`n'_p = 0.25 if Q121_x`n' == 2
    replace Q121_x`n'_p = 0.5 if Q121_x`n' == 3
    replace Q121_x`n'_p = 0.75 if Q121_x`n' == 4
    replace Q121_x`n'_p = 1 if Q121_x`n' == 5
    gen Q120XQ121_x`n'_p = Q120_`n'_p * Q121_x`n'_p
}
egen oralcom_prog_focus = rowmean(Q120XQ121_x1_p Q120XQ121_x2_p)

gen writcom_prog_cover = 0 if Q122_1 == 1
replace writcom_prog_cover = 0.25 if Q122_1 == 2
replace writcom_prog_cover = 0.5 if Q122_1 == 3
replace writcom_prog_cover = 0.75 if Q122_1 == 4
replace writcom_prog_cover = 1 if Q122_1 == 5
gen writcom_prog_difficulty = 0 if Q123_x1 == 1
replace writcom_prog_difficulty = 0.25 if Q123_x1 == 2
replace writcom_prog_difficulty = 0.5 if Q123_x1 == 3
replace writcom_prog_difficulty = 0.75 if Q123_x1 == 4
replace writcom_prog_difficulty = 1 if Q123_x1 == 5
gen writcom_prog_focus = writcom_prog_cover * writcom_prog_difficulty

foreach n of numlist 1 2 {
    gen Q124_`n'_p = 0 if Q124_`n' == 1
    replace Q124_`n'_p = 0.25 if Q124_`n' == 2
    replace Q124_`n'_p = 0.5 if Q124_`n' == 3
    replace Q124_`n'_p = 0.75 if Q124_`n' == 4
    replace Q124_`n'_p = 1 if Q124_`n' == 5
    gen Q125_x`n'_p = 0 if Q125_x`n' == 1
    replace Q125_x`n'_p = 0.25 if Q125_x`n' == 2
    replace Q125_x`n'_p = 0.5 if Q125_x`n' == 3
    replace Q125_x`n'_p = 0.75 if Q125_x`n' == 4
    replace Q125_x`n'_p = 1 if Q125_x`n' == 5
    gen Q124XQ125_x`n'_p = Q124_`n'_p * Q125_x`n'_p
}
egen literat_prog_focus = rowmean(Q124XQ125_x1_p Q124XQ125_x2_p)

foreach n of numlist 1 2 {
    gen Q126_`n'_p = 0 if Q126_`n' == 1
    replace Q126_`n'_p = 0.25 if Q126_`n' == 2
    replace Q126_`n'_p = 0.5 if Q126_`n' == 3
    replace Q126_`n'_p = 0.75 if Q126_`n' == 4
    replace Q126_`n'_p = 1 if Q126_`n' == 5
    gen Q127_x`n'_p = 0 if Q127_x`n' == 1
    replace Q127_x`n'_p = 0.25 if Q127_x`n' == 2
    replace Q127_x`n'_p = 0.5 if Q127_x`n' == 3
    replace Q127_x`n'_p = 0.75 if Q127_x`n' == 4
    replace Q127_x`n'_p = 1 if Q127_x`n' == 5
    gen Q126XQ127_x`n'_p = Q126_`n'_p * Q127_x`n'_p
}
egen massmed_prog_focus = rowmean(Q126XQ127_x1_p Q126XQ127_x2_p)

foreach n of numlist 3 4 5 6 {
    gen Q128_`n'_p = 0 if Q128_`n' == 1
    replace Q128_`n'_p = 0.25 if Q128_`n' == 2
    replace Q128_`n'_p = 0.5 if Q128_`n' == 3
    replace Q128_`n'_p = 0.75 if Q128_`n' == 4
    replace Q128_`n'_p = 1 if Q128_`n' == 5
    gen Q129_x`n'_p = 0 if Q129_x`n' == 1
    replace Q129_x`n'_p = 0.25 if Q129_x`n' == 2
    replace Q129_x`n'_p = 0.5 if Q129_x`n' == 3
    replace Q129_x`n'_p = 0.75 if Q129_x`n' == 4
    replace Q129_x`n'_p = 1 if Q129_x`n' == 5
    gen Q128XQ129_x`n'_p = Q128_`n'_p * Q129_x`n'_p
}
egen litworks_prog_focus = rowmean(Q128XQ129_x3_p Q128XQ129_x4_p Q128XQ129_x5_p Q128XQ129_x6_p)

egen language_prog_focus = rowmean(oralcom_prog_focus writcom_prog_focus literat_prog_focus ///
    massmed_prog_focus litworks_prog_focus)
lab var language_prog_focus "Percentage of Language program focus of instruction"

gen days_miss_class = 0 if Q71 == 1
replace days_miss_class = 1.5 if Q71 == 2
replace days_miss_class = 7 if Q71 == 3
replace days_miss_class = 12 if Q71 == 4
replace days_miss_class = 17 if Q71 == 5
replace days_miss_class = 22 if Q71 == 6
lab var days_miss_class "Number of day the teacher missed classes in this semester"

drop Q51 Q52 Q53 Q71 Q74 Q76
drop Q105_*_p Q106_x*_p Q105XQ106_x*_p
drop Q109_*_p Q110_x*_p Q109XQ110_x*_p
drop Q111_*_p Q112_x*_p Q111XQ112_x*_p
drop Q120_*_p Q121_x*_p Q120XQ121_x*_p
drop Q124_*_p Q125_x*_p Q124XQ125_x*_p
drop Q126_*_p Q127_x*_p Q126XQ127_x*_p
drop Q128_*_p Q129_x*_p Q128XQ129_x*_p
drop algebra_prog_focus geom_prog_cover geom_prog_difficulty geom_prog_focus stat_prog_focus ///
    trigon_prog_focus oralcom_prog_focus writcom_prog_cover writcom_prog_difficulty ///
    writcom_prog_focus literat_prog_focus massmed_prog_focus litworks_prog_focus

keep rbd_basefinal teaching_subject modalidad Q4_* Q6_* ///
    hours_teach_outside hours_teach_prep days_miss_class math_prog_focus language_prog_focus

saveold "$dataTemp/docentes_clean.dta", replace

local math_letters "A B C D E F G H I J K"
local math_indexes "1 2 3 4 5 6 7 8 9 10 11"

use "$dataTemp/docentes_clean.dta", clear
keep if teaching_subject == 1
keep rbd_basefinal modalidad Q4_* hours_teach_outside hours_teach_prep days_miss_class math_prog_focus
rename (hours_teach_outside hours_teach_prep days_miss_class math_prog_focus) ///
    (MT_hours_teach_outside MT_hours_teach_prep MT_days_miss_class MT_math_prog_focus)

local n = 1
foreach class_letter of local math_letters {
    local idx : word `n' of `math_indexes'
    preserve
    gen let_cur = "`class_letter'" if Q4_`idx' == 1
    keep if let_cur != ""
    keep rbd_basefinal modalidad let_cur MT_*
    saveold "$dataTemp/docentes_math`class_letter'.dta", replace
    restore
    local ++n
}

forvalues mod = 0(1)1 {
    use "$dataTemp/docentes_clean.dta", clear
    keep if teaching_subject == 1
    keep if modalidad == `mod'
    keep rbd_basefinal Q4_* hours_teach_outside hours_teach_prep days_miss_class math_prog_focus
    rename (hours_teach_outside hours_teach_prep days_miss_class math_prog_focus) ///
        (MT_hours_teach_outside MT_hours_teach_prep MT_days_miss_class MT_math_prog_focus)
    local n = 1
    foreach class_letter of local math_letters {
        local idx : word `n' of `math_indexes'
        preserve
        gen let_cur = "`class_letter'" if Q4_`idx' == 1
        keep if let_cur != ""
        keep rbd_basefinal MT_*
        saveold "$dataTemp/docentes_math`class_letter'_mod`mod'.dta", replace
        restore
        local ++n
    }
}

local language_letters "A B C D E F G H I O"
local language_indexes "1 2 3 4 5 6 7 8 9 15"

use "$dataTemp/docentes_clean.dta", clear
keep if teaching_subject == 2
keep rbd_basefinal modalidad Q6_* hours_teach_outside hours_teach_prep days_miss_class language_prog_focus
rename (hours_teach_outside hours_teach_prep days_miss_class language_prog_focus) ///
    (LT_hours_teach_outside LT_hours_teach_prep LT_days_miss_class LT_language_prog_focus)

local n = 1
foreach class_letter of local language_letters {
    local idx : word `n' of `language_indexes'
    preserve
    gen let_cur = "`class_letter'" if Q6_`idx' == 1
    keep if let_cur != ""
    keep rbd_basefinal modalidad let_cur LT_*
    saveold "$dataTemp/docentes_language`class_letter'.dta", replace
    restore
    local ++n
}

forvalues mod = 0(1)1 {
    use "$dataTemp/docentes_clean.dta", clear
    keep if teaching_subject == 2
    keep if modalidad == `mod'
    keep rbd_basefinal Q6_* hours_teach_outside hours_teach_prep days_miss_class language_prog_focus
    rename (hours_teach_outside hours_teach_prep days_miss_class language_prog_focus) ///
        (LT_hours_teach_outside LT_hours_teach_prep LT_days_miss_class LT_language_prog_focus)
    local n = 1
    foreach class_letter of local language_letters {
        local idx : word `n' of `language_indexes'
        preserve
        gen let_cur = "`class_letter'" if Q6_`idx' == 1
        keep if let_cur != ""
        keep rbd_basefinal LT_*
        saveold "$dataTemp/docentes_language`class_letter'_mod`mod'.dta", replace
        restore
        local ++n
    }
}
