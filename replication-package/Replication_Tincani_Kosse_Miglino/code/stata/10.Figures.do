*******************************************************************************
* DO-FILE DESCRIPTION:
* This do-file generates all figures and tables of the paper submitted to JPE
********************************************************************************
	
********************************************************************************
********************************************************************************
**# FIGURES
********************************************************************************
********************************************************************************

********************************************************************************
**# Figure 1: Distributions of standardized test scores in 10th grade
******************************************************************************** 
use "$dataClean/data_population_PSU_students.dta", clear
twoway (histogram simce_avg_st_pop if  in_experimental_schools==1 & treatment==0, width(0.2) color(midblue%30) ) || /// 
       (histogram simce_avg_st_pop if via_ingreso==1, width(0.2) color(green%30) ), ///
	   legend(pos(6) row(1) order(1 "Students in" "targeted schools" 2 "Regular entrants in" "selective colleges")) ///
	   xtitle("Standardized test scores in grade 10") xscale(range(-3 3)) xlabel(-3(1)3, nogrid) ylabel(0(0.1)0.5 , nogrid) ///
	   xline(0, lpattern(shortdash) lcolor(emidblue)) ///
	   text(0.54 -0.45 "Average Chile", size(small) color(emidblue)) ///
	   xline(0.49, lpattern(shortdash) lcolor(gray)) ///
	   text(0.54 1.0 "Average OECD", size(small) color(gray)) graphregion(c(white))
graph export "$graphs/histogram_simce_control_all.png", replace
	   
twoway (histogram simce_avg_st_pop if in_experimental_schools==1 & graduate_top15==1 & treatment==0, width(0.2) color(midblue%30)) || /// 
       (histogram simce_avg_st_pop if via_ingreso==1, width(0.2) color(green%30)), ///
	   legend(pos(6) row(1) order(1 "Students graduating in the" "top 15% of targeted schools" 2 "Regular entrants in" "selective colleges")) ///
	   xtitle("Standardized test scores in grade 10") xscale(range(-3 3)) xlabel(-3(1)3, nogrid) ylabel(0(0.1)0.5, nogrid) ///
	   xline(0, lpattern(shortdash) lcolor(emidblue)) ///
	   text(0.54 -0.45 "Average Chile", size(small) color(emidblue)) ///
	   xline(0.49, lpattern(shortdash) lcolor(gray)) ///
	   text(0.54 1.0 "Average OECD", size(small) color(gray)) graphregion(c(white))
graph export "$graphs/histogram_simce_controltop15_all.png", replace



********************************************************************************
**# Figure 2: Effects of PACE on admissions and on enrollment or graduation over time.
********************************************************************************
use "$dataClean/data_experimental.dta", clear
foreach sample in in_experimental_schools top15baseline {
* List of variables for each graph

local varlist1 admitted_SUA_regular_or_pace enrolled_SUA_by_y1 enrolled_SUA_by_y2 enrolled_SUA_by_y3 enrolled_SUA_by_y4 enrolled_SUA_by_y5
local varlist2 enrolled_voc_by_y1 enrolled_voc_by_y2 enrolled_voc_by_y3 enrolled_voc_by_y4 enrolled_voc_by_y5
local varlist3 enrolled_nonSUA_by_y1 enrolled_nonSUA_by_y2 enrolled_nonSUA_by_y3 enrolled_nonSUA_by_y4 enrolled_nonSUA_by_y5
local varlist4 enrolled_out_by_y1 enrolled_out_by_y2 enrolled_out_by_y3 enrolled_out_by_y4 enrolled_out_by_y5
local varlist5 enrolled_any_by_y1 enrolled_any_by_y2 enrolled_any_by_y3 enrolled_any_by_y4 enrolled_any_by_y5

forvalues vl=1(1)5 {
    local count=0
    foreach var of varlist `varlist`vl'' {
        local count=`count'+1
		* LPM regression 
        reg `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools==1 & `sample'==1, ///
		cluster(rbd_basefinal)
		lincom treatment
        local fig_b`count'= r(estimate)
        local fig_se`count'= r(se) 
        local lab_b`count' : display %4.3f `fig_b`count''
        local lab_se`count' : display %4.3f `fig_se`count'' 
		reg `var' treatment simce_avg_st female age alumno_prioritario neverfailed if in_experimental_schools==1 & modalidad==1 & `sample'==1, ///
		cluster(rbd_basefinal)
		lincom treatment
        local fig_b`count'mod1= r(estimate)
        local fig_se`count'mod1= r(se) 
        local lab_b`count'mod1 : display %4.3f `fig_b`count'mod1'
        local lab_se`count'mod1 : display %4.3f `fig_se`count'mod1' 
		reg `var' treatment simce_avg_st female age alumno_prioritario neverfailed if in_experimental_schools==1 & modalidad==0 & `sample'==1, ///
		cluster(rbd_basefinal)
		lincom treatment
        local fig_b`count'mod0= r(estimate)
        local fig_se`count'mod0= r(se) 
        local lab_b`count'mod0 : display %4.3f `fig_b`count'mod0'
        local lab_se`count'mod0 : display %4.3f `fig_se`count'mod0' 
	}
	* Bar chart: TE over time
    preserve 
    clear
    set obs `count'
    cap drop fig* 
    gen fig_b=.
    gen fig_se=.
	gen fig_bmod1=.
    gen fig_semod1=.
    gen fig_bmod0=.
    gen fig_semod0=.

    forvalues num=1(1)`count' {
        replace fig_b=`fig_b`num'' if _n==`num'
        replace fig_se=`fig_se`num'' if _n==`num'
        replace fig_bmod1=`fig_b`num'mod1' if _n==`num'
        replace fig_semod1=`fig_se`num'mod1' if _n==`num'
        replace fig_bmod0=`fig_b`num'mod0' if _n==`num'
        replace fig_semod0=`fig_se`num'mod0' if _n==`num'
    }
    gen fig_upper=fig_b+1.96*fig_se
    gen fig_lower=fig_b-1.96*fig_se
    gen fig_uppermod1=fig_bmod1+1.96*fig_semod1
    gen fig_lowermod1=fig_bmod1-1.96*fig_semod1
    gen fig_uppermod0=fig_bmod0+1.96*fig_semod0
    gen fig_lowermod0=fig_bmod0-1.96*fig_semod0
    local total_periods=`count'
    gen fig_t=_n
if "`sample'"=="top15baseline" {
    if  `vl'==1 { // If varlist1 (enrolled_SUA)
        twoway bar fig_b fig_t, barw(0.6) color(midblue*0.4) || ///
		rcap fig_upper fig_lower fig_t, lcolor(navy) c(l) m(i) , ///
        graphregion(fcolor(white) ) yline(0, lc(gs11) lp(shortdash)) ylab(0(0.05)0.4, nogrid) ///
	    ytitle("Treatment effect")  legend(off) xtitle("") ///
        text(0.41 1 "`lab_b1'", size(small) color(navy)) ///
        text(0.395 1 " (`lab_se1')", size(small) color(navy)) ///
        text(0.41 2 "`lab_b2'", size(small) color(navy)) ///
        text(0.395 2 " (`lab_se2')", size(small) color(navy)) ///	   
        text(0.41 3 "`lab_b3'", size(small) color(navy)) ///
        text(0.395 3 " (`lab_se3')", size(small) color(navy)) ///
        text(0.41 4 "`lab_b4'", size(small) color(navy)) ///
        text(0.395 4 " (`lab_se4')", size(small) color(navy)) ///
        text(0.41 5 "`lab_b5'", size(small) color(navy)) ///
        text(0.395 5 " (`lab_se5')", size(small) color(navy)) ///
     	text(0.41 6 "`lab_b6'", size(small) color(navy)) ///
     	text(0.395 6 " (`lab_se6')", size(small) color(navy)) ///
        xlabel(1 "Admissions" ///
		       2 `" "Enrollments" "in 1{superscript:st} year" "' ///
		       3 `" "Enrollments" "in 2{superscript:nd} year" "' ///
	           4 `" "Enrollments" "in 3{superscript:rd} year" "' ///  
    		   5 `" "Enrollments" "in 4{superscript:th} year" "'  ///
    		   6 `" "Enrollments" "in 5{superscript:th} year" "'  6.3 " ", nogrid) 
        graph export "$graphs/TE_over_time_enrolled_SUA_`sample'.png", replace
}
}
if "`sample'"=="in_experimental_schools" {
    if  `vl'==1 { // If varlist1 (enrolled_SUA)
        twoway bar fig_b fig_t, barw(0.6) color(midblue*0.4) || ///
		rcap fig_upper fig_lower fig_t, lcolor(navy) c(l) m(i) , ///
        graphregion(fcolor(white) ) yline(0, lc(gs11) lp(shortdash)) ylab(0(0.02)0.08, nogrid) ///
	    ytitle("Treatment effect")  legend(off) xtitle("") ///
        text(0.073 1 "`lab_b1'", size(small) color(navy)) ///
        text(0.07 1 " (`lab_se1')", size(small) color(navy)) ///
        text(0.063 2 "`lab_b2'", size(small) color(navy)) ///
        text(0.06 2 " (`lab_se2')", size(small) color(navy)) ///	   
        text(0.053 3 "`lab_b3'", size(small) color(navy)) ///
        text(0.05 3 " (`lab_se3')", size(small) color(navy)) ///
        text(0.047 4 "`lab_b4'", size(small) color(navy)) ///
        text(0.044 4 " (`lab_se4')", size(small) color(navy)) ///
        text(0.043 5 "`lab_b5'", size(small) color(navy)) ///
        text(0.04 5 " (`lab_se5')", size(small) color(navy)) ///
     	text(0.036 6 "`lab_b6'", size(small) color(navy)) ///
     	text(0.033 6 " (`lab_se6')", size(small) color(navy)) ///
        xlabel(1 "Admissions" ///
		       2 `" "Enrollments" "in 1{superscript:st} year" "' ///
		       3 `" "Enrollments" "in 2{superscript:nd} year" "' ///
	           4 `" "Enrollments" "in 3{superscript:rd} year" "' ///  
    		   5 `" "Enrollments" "in 4{superscript:th} year" "'  ///
    		   6 `" "Enrollments" "in 5{superscript:th} year" "'  6.3 " ", nogrid) 
        graph export "$graphs/TE_over_time_enrolled_SUA_`sample'.png", replace
		
	}
	
}
restore

}
}

********************************************************************************
**# Figure 3: Heterogeneity of policy effects on pre-college effort and achievement
********************************************************************************
use "$dataClean/data_experimental.dta", clear
global controls simce_avg_st female age alumno_prioritario neverfailed modalidad
xtile simce_cat5=simce_avg_st, n(5)
* Effect on achievement by within-school rank quintile:
est clear 
label var treatment "Baseline school rank (quintile)"
forval y=0(2)8 {   
   reg  score_all_st   treatment $controls i.id_fieldworker  if GPA_1_2_rank>0.`y' & GPA_1_2_rank<=0.`y'+0.2 [weight=weight_mat], cluster(rbd_basefinal )
   est sto equint`y'
}
coefplot equint0 equint2 equint4 equint6 equint8 ,xlabel(0.67 "Q1" 0.83 "Q2" 1.0 "Q3" 1.17 "Q4" 1.33 "Q5")   keep(treatment) pstyle(p2) mcolor(maroon) ///
         yscale(range(-.4 .2)) ylabel(-.4(0.1).2) yline(0,lcolor(black)) ///
         vertical graphregion(fcolor(white))  ytitle("Treatment effect on achievement (sd)") ///
         color(maroon) ciopts(lcolor(maroon) recast(rcap)) citop legend(off) note("Baseline school rank (quintiles)" , size(small) position(6))  saving("$dataTemp/TE_ach_byrank_fe.gph", replace)
est clear
* Effect on achievement by simce quintile:
label var treatment "Baseline SIMCE test score (quintile)" 
forval y=1(1)5 {
reg score_all_st treatment $controls i.id_fieldworker if simce_cat5==`y'  [weight=weight_mat], cluster(rbd_basefinal )
est sto pquint`y'
}
coefplot pquint1 pquint2 pquint3 pquint4 pquint5 , xlabel(0.67 "Q1" 0.83 "Q2" 1.0 "Q3" 1.17 "Q4" 1.33 "Q5")  keep(treatment) pstyle(p2) mcolor(maroon) yscale(range(-.4 .2)) ylabel(-.4(0.1).2) yline(0,lcolor(black)) vertical graphregion(fcolor(white))  ytitle("Treatment effect on achievement (sd)")  color(maroon) ciopts(lcolor(maroon) recast(rcap)) citop legend(off) note("Baseline SIMCE test score (quintiles)"  , size(small) position(6)) saving("$dataTemp/TE_ach_bysimce_fe.gph", replace)
est clear
* Effect on effort by within-school rank quintile:
label var treatment "Baseline school rank (quintile)"
forval y=0(2)8 {
reg st_effort_latent2 treatment   $controls i.id_fieldworker    if GPA_1_2_rank>0.`y' & GPA_1_2_rank<=0.`y'+0.2 [weight=weight_mat], cluster(rbd_basefinal )
est sto equint`y'
}
coefplot equint0 equint2 equint4 equint6 equint8 , xlabel(0.67 "Q1" 0.83 "Q2" 1.0 "Q3" 1.17 "Q4" 1.33 "Q5") keep(treatment) pstyle(p2) mcolor(maroon) yscale(range(-.4 .2)) ylabel(-.4(0.1).2) yline(0,lcolor(black)) vertical graphregion(fcolor(white)) note("Baseline school rank (quintiles)" , size(small) position(6)) ytitle("Treatment effect on effort (sd)")  color(maroon) ciopts(lcolor(maroon) recast(rcap)) citop legend(off) saving("$dataTemp/TE_effort_byrank_fe", replace)
est clear
* Effect on effort by simce quintile:
label var treatment "Baseline SIMCE test score (quintile)"	  
forval y=1(1)5 {
reg  st_effort_latent2 treatment $controls i.id_fieldworker     if simce_cat5==`y'  [weight=weight_mat], cluster(rbd_basefinal )
est sto pquint`y'
}
coefplot pquint1 pquint2 pquint3 pquint4 pquint5 , xlabel(0.67 "Q1" 0.83 "Q2" 1.0 "Q3" 1.17 "Q4" 1.33 "Q5") keep(treatment) pstyle(p2) mcolor(maroon) yscale(range(-.4 .2)) ylabel(-.4(0.1).2) yline(0,lcolor(black)) vertical graphregion(fcolor(white))  ytitle("Treatment effect on effort (sd)")  note("Baseline SIMCE test score (quintiles)"  , size(small) position(6))  color(maroon) ciopts(lcolor(maroon) recast(rcap)) citop legend(off)  saving("$dataTemp/TE_effort_bysimce_fe", replace)
est clear
gr combine  "$dataTemp/TE_ach_byrank_fe.gph"  "$dataTemp/TE_ach_bysimce_fe.gph" "$dataTemp/TE_effort_byrank_fe.gph"  "$dataTemp/TE_effort_bysimce_fe.gph" , rows(2) 
graph export "$graphs/heterog_effects_effort_score.png", replace



********************************************************************************
**# Figure 4:  Histogram of perceived likelihood of graduating
********************************************************************************
		forval y=0(25)100 {
	use "$dataClean/data_experimental.dta", clear
	gen p_grad_`y'=1 if p_graduate==`y'/100
	replace p_grad_`y'=0 if p_graduate!=`y'/100 & p_graduate!=.
	reg p_grad_`y' treatment, cluster(rbd_basefinal)
	local control`y'=_b[_cons]
	local b`y'=_b[treatment]
	local treatment`y'= `control`y''+_b[treatment]
	local se`y'=_se[treatment]
}

    clear
	local count=5
    set obs `count'
    cap drop fig* 
    gen fig_b=.
	gen fig_coef=.
    gen fig_se=.
    gen fig_bC=.


	replace fig_bC=`control0' if _n== 1
	replace fig_b=`treatment0' if _n==1
	replace fig_coef=`control0' if _n==1
	replace fig_se=`se0' if _n== 1

	replace fig_bC=`control25' if _n==2
	replace fig_b=`treatment25' if _n==2
	replace fig_coef=`control25' if _n==2
	replace fig_se=`se25' if _n==2
	
    replace fig_bC=`control50' if _n==3
	replace fig_b=`treatment50' if _n==3
	replace fig_coef=`control50' if _n==3
	replace fig_se=`se50' if _n==3
	
	replace fig_bC=`control75' if _n==4
	replace fig_b=`treatment75' if _n==4
	replace fig_coef=`control75' if _n==4
	replace fig_se=`se75' if _n==4

	replace fig_bC=`control100' if _n==5
	replace fig_b=`treatment100' if _n==5
	replace fig_coef=`control100' if _n==5
	replace fig_se=`se100' if _n==5
	
    gen outcome=1 if _n==1
    replace outcome=2 if _n==2
    replace outcome=3 if _n==3
    replace outcome=4 if _n==4
    replace outcome=5 if _n==5
    gen fig_upper=fig_b+1.96*fig_se
    gen fig_lower=fig_b-1.96*fig_se

    local total_periods=`count'
    gen fig_t=_n


        twoway (bar fig_b fig_t if outcome==1, color(midblue%30) barw(1)) (rcap fig_upper fig_lower fig_t if outcome==1, color(midblue*1) lwidth(thin))  ///
        (bar fig_bC fig_t if outcome==1, color(red%30) barw(1))   ///
		(bar fig_b fig_t if outcome==2, color(midblue%30) barw(1) bargap(-100)) (rcap fig_upper fig_lower fig_t if outcome==2, color(midblue*1) lwidth(thin) )  ///
		(bar fig_bC fig_t if outcome==2, color(red%30) barw(1) bargap(-100))  ///
		(bar fig_b fig_t if outcome==3, color(midblue%30) barw(1) bargap(-100))   (rcap fig_upper fig_lower fig_t if outcome==3, color(midblue*1) lwidth(thin) )  ///
		(bar fig_bC fig_t if outcome==3, color(red%30) barw(1) bargap(-100)) ///
		(bar fig_b fig_t if outcome==4, color(midblue%30) barw(1) bargap(-100))   (rcap fig_upper fig_lower fig_t if outcome==4, color(midblue*1) lwidth(thin) )  ///
		(bar fig_bC fig_t if outcome==4, color(red%30) barw(1) bargap(-100)) ///
		(bar fig_b fig_t if outcome==5, color(midblue%30) barw(1) bargap(-100))    (rcap fig_upper fig_lower fig_t if outcome==5, color(midblue*1) lwidth(thin) ) ///
		(bar fig_bC fig_t if outcome==5, color(red%30) barw(1) bargap(-100)),  ///
		legend(order(1 "Treated" 3 "Control") pos(6) row(1) nobox  region(lstyle(none))) ///
        ylabel(0(0.2)0.6) ytitle("Fraction") xtitle(" ") ///
		xlabel(1 "Definitely not" 2 "Probably not" 3 "Equally likely" 4 "Probably yes" 5 "Definitely yes", nogrid)

 graph export "$graphs/histogram_p_graduate_T_C.png", replace
 
 
 
******************************************************************************************
**# Figure 5: Distribution of answers to survey questions on perceived returns to effort
******************************************************************************************
use "$dataClean/data_experimental.dta", clear

graph twoway (hist hours_study_PSU350_raw  , discrete frac width(1) color(midblue%40)) (hist hours_study_PSU450_raw  , discrete frac color(midblue%70)  width(1)) (hist hours_study_PSU600_raw  , discrete frac width(1)  color(purple%50)  ) , ///
legend(pos(6) r(1) size(medium) order(1 2 3) label(1 "X=350") label(2 "X=450") label(3 "X=600") ) xtitle("Hours of study per week required to obtain" "a score of at least X on the PSU") saving("$dataTemp/returns_effort_PSU_raw_answers.gph", replace)

graph twoway (hist hours_to_have_NEM55_raw , frac width(1) color(midblue%70)) (hist hours_to_be_top15_raw, frac color(purple%50)  width(1))  , ///
legend(pos(6) r(1) size(medium) order(1 2 3) label(1 "X=5.5") label(2 "X=reported perceived top 15 cutoff")  )  xtitle("Hours of study per week required to obtain" "a GPA of at least X") saving("$dataTemp/returns_effort_GPA_raw_answers.gph", replace)

graph combine "$dataTemp/returns_effort_PSU_raw_answers.gph"  "$dataTemp/returns_effort_GPA_raw_answers.gph", saving("$dataTemp/returns_effort_PSUGPA_raw_answers_comb.gph", replace)
graph export "$graphs/returns_effort_PSUGPA_raw_answers_comb.png", replace 


********************************************************************************
********************************************************************************
**# APPENDIX FIGURES
********************************************************************************
********************************************************************************

********************************************************************************
**# Figure A1: Percentage of 18-19 year-old who are enrolled in college in Chile by family income quintile.
********************************************************************************
clear all
set obs 5
gen quintile=_n
gen enrollment_rate=.
replace enrollment_rate=0.066747633*100 if quintile==1
replace enrollment_rate=0.087960133*100 if quintile==2
replace enrollment_rate=0.107485*100 if quintile==3
replace enrollment_rate=0.160512167*100 if quintile==4
replace enrollment_rate=0.268438767*100 if quintile==5
twoway bar enrollment_rate quintile, xtitle("Family income quintile") ytitle("Enrollment rate (%)") ylabel(0(5)30) ///
       xlabel(1 "I" 2 "II" 3 "III" 4 "IV" 5 "V") color(midblue*0.9) barw(0.5) ///
	   note("Source: CASEN 2009, 2011, 2013")
graph export "$graphs/enrollment_SUA_gradient.png", replace


********************************************************************************
**# Figure A2: Study field distribution of PACE and regular seats in selective colleges.
********************************************************************************
* Following dataset contains all degree programmes, including CTP/IP. Must identify selective colleges.
import delimited "$dataRawPublic/Enrollment/20220719_Matrícula_Ed_Superior_2018_PUBL_MRUN.csv", delimiter(";") clear
gen regular_seat=1 if forma_ingreso=="1- Ingreso Directo (regular)"
gen PACE_seat=1 if forma_ingreso =="7- Ingreso a través de PACE"
* to identify selective universities that admit through SUA, merge the SUA-enrolled dataset 
drop if mrun==.
bysort mrun: gen counter=_n
bysort mrun: egen max_counter=max(counter)
drop if max_counter>1
drop counter max_counter 
merge 1:1 mrun using "$dataTemp/D_MATRICULA_PSU_2018_PRIV_uniqueMRUN.dta"
gen selective_college=1 if _merge==3
drop _merge 
encode cine_f_97_area, generate(study_field_num)
label define num_label 1 "Agriculture" 2 "Natural Sciences" 3 "Social Sciences" 4 "Education" 5 "Arts and Humanities" 6 "Engineering" 7 "Health" 8 "Services"
label values study_field_num
label values study_field_num num_label, nofix
twoway (histogram study_field_num if regular_seat==1 & selective_college==1, discrete fraction color(green)) (histogram study_field_num if PACE_seat==1 & selective_college==1,  discrete fraction fcolor(none) lcolor(black)) ,  legend(order(1    "Regular seats" 2 "PACE seats" )) xtitle("Study field area") 	play($do_files/grec/histogram_majors_pace_regular.grec) saving("$dataTemp/hist_majors_pace_regular_slots.gph", replace)
graph export "$graphs/hist_majors_pace_regular_slots.png", as(png) replace
	
	
********************************************************************************
**# Figure A3: Distribution of selectivity of PACE and regular seats in selective colleges.
********************************************************************************
** Following dataset refers to degree programmes accessed through PSU
import delimited "$dataRaw/PSU/D_MATRICULA_PSU_2018_PRIV_MRUN.csv", clear
duplicates tag mrun, gen(dupli)
drop if dupli>0
drop dupli
save "$dataTemp/D_MATRICULA_PSU_2018_PRIV_uniqueMRUN.dta", replace
** via_ingreso: 1 = regular, 3 = cupo pace
drop if via_ingreso==2
*fix typo
replace sigla_universidad="UACH" if sigla_universidad=="UACh"
merge m:m sigla_universidad codigo_carrera  using "$dataTemp/mean_psu_score_unimajor_level"
drop if _merge==1
drop _merge
label var mean_PSU_score_uni_major "Average PSU score of regular entrants in the degree program"
su mean_PSU_score_uni_major, d
local minim=r(min)
di "`minim'"
twoway (histogram mean_PSU_score_uni_major if via_ingreso ==1,  color(green) start(`minim') w(10) ) (histogram mean_PSU_score_uni_major if via_ingreso ==3,  fcolor(none) lcolor(black) start(`minim') w(10)),  legend(order(1    "Regular seats" 2 "PACE seats"   )) 
graph export "$graphs/hist_quality_pace_regular_slots.png", as(png) replace


********************************************************************************
**# Figure A4: Timeline
********************************************************************************
* It is only text
	

*****************************************************************************************************
**# Figure A5: Decision to take and prepare for PSU entrance exam and objective admission likelihood
*****************************************************************************************************
use "$dataClean/data_experimental.dta", clear
graph twoway (lpoly sit_PSU  GPA_1_2_rank if treatment==0, lcolor(navy)) ///
             (lpoly actively_preparing_PSU  GPA_1_2_rank if treatment==0, lcolor(navy) lpattern(shortdash)) ///
             (lpoly admitted_SUA_regular GPA_1_2_rank if treatment==0, lcolor(green) lpattern(shortdash)), ///
              yscale(range(0 1)) ylabel(0(0.2)1) ytitle("Fraction")  xtitle("Baseline school rank based on GPA in grades 9-10") ///
              legend(order(1 "Sat PSU exam (admin)" 2 "Prepared for PSU exam (survey)" 3 "Admitted (admin)") pos(6) row(2)) 
graph export "$graphs/sit_PSU_prepared_admitted_lpoly_inpaper.png", replace


*****************************************************************************************************
**# Figure A6: Distribution of beliefs and realizations over PSU score intervals.
*****************************************************************************************************
use "$dataClean/data_experimental.dta", clear
gen PSUb_intervals=6 if P39==1 & PSU_score_if_positive!=.
replace PSUb_intervals=5 if P39==2 & PSU_score_if_positive!=. 
replace PSUb_intervals=4 if P39==3 & PSU_score_if_positive!=.
replace PSUb_intervals=3 if P39==4 & PSU_score_if_positive!=.
replace PSUb_intervals=2 if P39==5 & PSU_score_if_positive!=.
replace PSUb_intervals=1 if P39==6 & PSU_score_if_positive!=.
gen PSU_intervals=6 if PSU_score_if_positive>700 & PSU_score_if_positive!=. & PSUb_intervals!=.
replace PSU_intervals=5 if PSU_score_if_positive>=600 & PSU_score_if_positive<700 & PSU_score_if_positive!=. & PSUb_intervals!=.
replace PSU_intervals=4 if PSU_score_if_positive>=450 & PSU_score_if_positive<600 & PSU_score_if_positive!=. & PSUb_intervals!=.
replace PSU_intervals=3 if PSU_score_if_positive>=350 & PSU_score_if_positive<450 & PSU_score_if_positive!=. & PSUb_intervals!=.
replace PSU_intervals=2 if PSU_score_if_positive>=250 & PSU_score_if_positive<350 & PSU_score_if_positive!=. & PSUb_intervals!=.
replace PSU_intervals=1 if PSU_score_if_positive>=150 & PSU_score_if_positive<250 & PSU_score_if_positive!=. & PSUb_intervals!=.
tab PSUb_intervals
tab PSU_intervals
twoway (hist PSUb_intervals, color(midblue%40) discrete fraction) (hist PSU_intervals, color(green%40) discrete fraction),  xlabel(1 "150-250" 2 "250-350" 3 "350-450" 4 "450-600" 5 "600-700" 6 "700-850", nogrid) ylabel(, nogrid) xtitle("PSU score") legend(pos(6) row(1) order(1 "Belief"  2 "Realized")) 
graph export "$graphs/PSU_belief_actual_distribution.png", replace	


*****************************************************************************************************
**# Figure A7: Evidence of grade compression: Histogram of 12th grade GPA.
*****************************************************************************************************
use "$dataClean/data_experimental.dta", clear
hist GPA_cuarto_medio, xtitle("Grade 12 GPA") ytitle("Fraction of students") color(green) lcolor(black)
graph export "$graphs/GPA_hist.png", replace

*****************************************************************************************************
**# Figure A8: Evidence of grade compression: GPA does not discriminate between students as well as the achievement score does.
*****************************************************************************************************
use "$dataClean/data_experimental.dta", clear
graph twoway (lpoly GPA_cuarto_medio simce_avg_st if treatment==0 & simce_avg_st>-2  & simce_avg_st<=2, color(navy)) ///
		(lpoly score_all simce_avg_st if treatment==0 & simce_avg_st>-2  & simce_avg_st<=2, color(maroon) lpattern(longdash) ),  ///
		yscale(range(3 7))  ylabel(3(1)7) xtitle("Baseline SIMCE") legend(order(1 "GPA" 2 "Achievement score") pos(6) row(1))   saving("$graphs/discrimination_simce", replace)
        graph twoway (lpoly GPA_cuarto_medio GPA_1_2_rank  if treatment==0, color(navy)) ///
		(lpoly score_all GPA_1_2_rank  if treatment==0 , color(maroon) lpattern(longdash) ), ///
		yscale(range(3 7))  ylabel(3(1)7) xtitle("Baseline school rank") legend(order(1 "GPA" 2 "Achievement score")  pos(6) row(1))   saving("$graphs/discrimination_rank", replace)
graph combine "$graphs/discrimination_simce.gph" "$graphs/discrimination_rank.gph"
graph export "$graphs/discrimination.png", replace
	    
 
**************************************************************************************************************
**# Figure A9: Heterogeneity of subjective beliefs by baseline within-school rank and by baseline test scores.
**************************************************************************************************************
use "$dataClean/data_experimental.dta", clear
gen actually_in_top15=1 if GPA_cuarto_medio>=actual_top15_cutoff & GPA_cuarto_medio!=. & actual_top15_cutoff!=.
replace actually_in_top15=0 if GPA_cuarto_medio<actual_top15_cutoff & GPA_cuarto_medio!=. & actual_top15_cutoff!=.
label var actually_in_top15 "GPA actually in top 15 percent"
graph twoway (lpoly  exp_PSU_st simce_avg_st if treatment==0  & in_experimental_schools==1 & PSU_score_if_positive_st!=. & simce_avg_st>-1.964595  & simce_avg_st<2.701947, lcolor(navy)) ///
             (lpoly PSU_score_if_positive_st simce_avg_st if treatment==0 & in_experimental_schools==1 & simce_avg_st>-1.964595  & simce_avg_st<2.701947, lcolor(green) lpattern(shortdash)), ///
			 yscale(range(-1 1))  ylabel(-1.2(0.4)0.8) ytitle("PSU score (standardized)") xtitle("Baseline SIMCE test score") ///
			 legend(order(1 "Belief" 2 "Truth") pos(6) row(1)) title("Believed vs. true PSU score")  saving("$dataTemp/belief_PSU_heterog_bysimce.gph", replace)
graph twoway (lpoly  exp_PSU_st GPA_1_2_rank if treatment==0  & in_experimental_schools==1 & PSU_score_if_positive_st!=., lcolor(navy)) ///
	         (lpoly PSU_score_if_positive_st GPA_1_2_rank if treatment==0 & in_experimental_schools==1, lcolor(green) lpattern(shortdash)), ///
			  yscale(range(-1 1))  ylabel(-1.2(0.4)0.8) ytitle("PSU score (standardized)") ///
			  xtitle("Baseline school rank based on GPA in grades 9-10") ///
			  legend(off) title("Believed vs. true PSU score") ///
			  saving("$dataTemp/belief_PSU_heterog_byrank.gph", replace) 
graph twoway (lpoly think_top15 GPA_1_2_rank if treatment==0 & in_experimental_schools==1, lcolor(navy)) ///
	         (lpoly actually_in_top15 GPA_1_2_rank if treatment==0 & in_experimental_schools==1, lcolor(green) lpattern(shortdash)), ///
			 yscale(range(0 1)) ylabel(0(0.2)1) ytitle("In top 15 precent of grade 12 GPA") ///
			 xtitle("Baseline school rank based on GPA in grades 9-10") legend(off) ///
			 title("Believed vs. true school rank") ///
			 saving("$dataTemp/belief_rank_heterog_byrank.gph", replace) 
graph twoway (lpoly think_top15 simce_avg_st if treatment==0 & in_experimental_schools==1 & simce_avg_st>-2.16497   & simce_avg_st<1.168781 , lcolor(navy)) ///
	         (lpoly actually_in_top15 simce_avg_st if treatment==0 & in_experimental_schools==1 & simce_avg_st>-2.16497   & simce_avg_st<1.168781 , lcolor(green) lpattern(shortdash) ), ///
			  yscale(range(0 1)) ylabel(0(0.2)1) ytitle("In top 15 precent of grade 12 GPA") ///
			  xtitle("Baseline SIMCE test score") legend(order(1 "Belief" 2 "Truth") pos(6) row(1)) title("Believed vs. true school rank") ///
			 saving("$dataTemp/belief_rank_heterog_bysimce.gph", replace) 
gr combine "$dataTemp/belief_rank_heterog_byrank.gph" "$dataTemp/belief_PSU_heterog_byrank.gph" "$dataTemp/belief_rank_heterog_bysimce.gph" "$dataTemp/belief_PSU_heterog_bysimce.gph"          
graph export "$graphs/beliefs_hetero_byranksimce_inpaper.png", replace




***********************************************************************************************************************
**# Figure A10: Heterogeneity of the effects of PACE on the perceived likelihood of graduating from selective college
***********************************************************************************************************************

 use "$dataClean/data_experimental.dta", clear
 keep if in_experimental_schools==1
 
 
 ** Generate variables and subsamples
		xtile simce_cat5=simce_avg_st, n(5)
		
		forval y=0(25)100 {
		gen p_grad_`y'=1 if p_graduate==`y'/100
		replace p_grad_`y'=0 if p_graduate!=`y'/100 & p_graduate!=.
		}
		
		gen p_grad_pp=p_graduate*100 
		label var p_grad_pp "Perceived graduation likelihood in percentage points"
		


		gen p_grad_pp_low=0 if p_grad_pp==0
		replace p_grad_pp_low=10 if p_grad_pp==25
		replace p_grad_pp_low=20 if p_grad_pp==50
		replace p_grad_pp_low=50 if p_grad_pp==75
		replace p_grad_pp_low=100 if p_grad_pp==100
	
		gen p_grad_pp_high=0 if p_grad_pp==0
		replace p_grad_pp_high=40 if p_grad_pp==25
		replace p_grad_pp_high=80 if p_grad_pp==50
		replace p_grad_pp_high=100 if p_grad_pp==75
		replace p_grad_pp_high=100 if p_grad_pp==100
		
		
		
		est clear 
		 foreach outcome in p_grad_pp p_grad_pp_low p_grad_pp_high {
		
		label var treatment "Baseline school rank (quintile)"
	forval y=0(2)8 {   
    reg  `outcome'  treatment $controls i.id_fieldworker  if GPA_1_2_rank>0.`y' & GPA_1_2_rank<=0.`y'+0.2 [weight=weight_mat], cluster(rbd_basefinal )
    est sto equint`y'`outcome'
	}
	coefplot equint0`outcome' equint2`outcome' equint4`outcome' equint6`outcome' equint8`outcome' , xlabel(0.67 "Q1" 0.83 "Q2" 1.0 "Q3" 1.17 "Q4" 1.33 "Q5") keep(treatment) pstyle(p2) mcolor(maroon) ///
    yscale(range(-10 10)) ylabel(-10(5)10, labsize(2.5)) yline(0,lcolor(black)) ///
    vertical graphregion(fcolor(white))  ytitle("PACE effect on perceived" "graduation likelihood (p.p.)", size(2.5)) ///
    color(maroon) ciopts(lcolor(maroon) recast(rcap)) citop legend(off) note( "Baseline school rank (quintile)" , size(small) position(6)) saving("$dataTemp/TE_pgrad_byrank_fe`outcome'.gph", replace)
	
	* effect on p_graduate by achievement quintile		label var treatment "Baseline SIMCE test score (quintile)" 
	   est clear 
	   label var treatment "Baseline SIMCE test score (quintile)" 
	  
		forval y=1(1)5 {
		reg  `outcome'  treatment $controls i.id_fieldworker if simce_cat5==`y'  [weight=weight_mat], cluster(rbd_basefinal )
		est sto pquint`y'`outcome'
		}
	   
		coefplot pquint1`outcome'  pquint2`outcome' pquint3`outcome' pquint4`outcome' pquint5`outcome'  , xlabel(0.67 "Q1" 0.83 "Q2" 1.0 "Q3" 1.17 "Q4" 1.33 "Q5") keep(treatment) pstyle(p2) mcolor(maroon) ///
    yscale(range(-10 10)) ylabel(-10(5)10, labsize(2.5)) yline(0,lcolor(black) ) ///
    vertical graphregion(fcolor(white))  ytitle("PACE effect on perceived" "graduation likelihood (p.p.)", size(2.5))  color(maroon) ciopts(lcolor(maroon) recast(rcap)) citop  legend(off) note("Baseline SIMCE test score (quintile)" , size(small) position(6))  saving("$dataTemp/TE_pgrad_bysimce_fe`outcome'.gph", replace)
	
		
	
		}
		
			gr combine "$dataTemp/TE_pgrad_byrank_fep_grad_pp.gph"  "$dataTemp/TE_pgrad_bysimce_fep_grad_pp.gph", title("Numerical scale: [0, 25, 50, 75, 100]", size(2.5))  saving("$dataTemp/heterog_effects_p_grad_pp.gph", replace)
		
		
				gr combine "$dataTemp/TE_pgrad_byrank_fep_grad_pp_low.gph"  "$dataTemp/TE_pgrad_bysimce_fep_grad_pp_low.gph", title("Numerical scale: [0, 10, 20, 50, 100]", size(2.5))  saving("$dataTemp/heterog_effects_p_grad_pp_low.gph", replace)
	
		
		
						gr combine "$dataTemp/TE_pgrad_byrank_fep_grad_pp_high.gph"  "$dataTemp/TE_pgrad_bysimce_fep_grad_pp_high.gph", title("Numerical scale: [0, 40, 80, 100, 100]", size(2.5))  saving("$dataTemp/heterog_effects_p_grad_pp_high.gph", replace)
		
		
		
		

		
		gr combine "$dataTemp/heterog_effects_p_grad_pp_low.gph" "$dataTemp/heterog_effects_p_grad_pp.gph" "$dataTemp/heterog_effects_p_grad_pp_high.gph", r(3)
		graph export "$graphs/heterog_effects_p_grad.png", replace

		


		
		
********************************************************************************
**# Figure A11: Goodness of fit of the regular admission likelihood function
******************************************************************************** 

use "$dataClean/data_experimental.dta", clear
keep if in_experimental_schools==1
merge 1:1 mrun using "$dataTemp/admitted_SUA_pace.dta" , keepusing(quality_adm_uni_major_PACE )
drop if _merge==2 // these are students who were admitted through PACE in 2018 but are not in our experimental sample
drop _merge

gen PSU_score_if_positive_st_sq=PSU_score_if_positive_st*PSU_score_if_positive_st 
gen PSU_score_if_positive_st_cube=PSU_score_if_positive_st_sq*PSU_score_if_positive_st


keep if sit_PSU==1 

*  Estimate regression 
probit admitted_SUA_regular PSU_score_if_positive_st PSU_score_if_positive_st_sq PSU_score_if_positive_st_cube , cluster(rbd_basefinal)


* 3. Graph showing fit
predict admitted_regular_pred if e(sample)==1 
graph twoway (lpoly admitted_regular_pred PSU_score_if_positive_st , lcolor(navy) lpattern(shortdash) xscale(range (-3  3)  ) ) (lpoly admitted_SUA_regular PSU_score_if_positive_st , lcolor(navy) xscale(range (-3  3)  )  ), ytitle("Likelihood of " "regular channel admission", size(medium)) xtitle("PSU score", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual"))   saving("$dataTemp/admission_PSU_regular.gph", replace )

kdensity PSU_score_if_positive_st if e(sample)==1 , lcolor(navy)  ///
graphregion(color(white)) xtitle("PSU score", size(medium)) title("Marginal distribution", size(medium)) xscale(range (-3 3))  ///
saving("$dataTemp/distribution_PSU_applicants.gph", replace)

graph combine "$dataTemp/admission_PSU_regular.gph" "$dataTemp/distribution_PSU_applicants.gph", col(1) ///
	graphregion(color(white)) ///	
	saving("$dataTemp/admission_regular_PSU_fit.gph", replace) 
	graph export "$graphs/admission_regular_PSU_fit.png" , replace
	
	
	
	
	

********************************************************************************
**# Figure A12: Goodness of fit of the admission selectivity functions
******************************************************************************** 
use "$dataClean/data_experimental.dta", clear
keep if in_experimental_schools==1
merge 1:1 mrun using "$dataTemp/admitted_SUA_pace.dta" , keepusing(quality_adm_uni_major_PACE )
drop if _merge==2 // these are students who were admitted through PACE in 2018 but are not in our experimental sample
drop _merge

merge 1:1 mrun using "$dataTemp/regular_applications_uni_quality.dta" , keepusing( quality_adm_uni_major)  

rename quality_adm_uni_major_PACE quality_adm_uni_major_PACE_unst
rename quality_adm_uni_major quality_adm_uni_major_unst
gen quality_adm_uni_major_PACE =(quality_adm_uni_major_PACE_unst-500)/110
gen quality_adm_uni_major=(quality_adm_uni_major_unst-500)/110

drop if _merge==2



label var simce_avg_st "Simce"
label var PSU_score_if_positive_st "PSU"
gen GPA_all_years=( GPA_primero_medio + GPA_segundo_medio + GPA_tercero_medio + GPA_cuarto_medio)/4
label var GPA_all_years "GPA grades 9-12"
gen GPA_all_years_sq=GPA_all_years*GPA_all_years

gen cod_reg_rbd_pred=cod_reg_rbd
replace cod_reg_rbd_pred=10 if cod_reg_rbd==9 // only 1.32% of sample is in region 9, lump together 9 and 10
label var cod_reg_rbd_pred "Region"

gen PSU_score_if_positive_st_sq=PSU_score_if_positive_st*PSU_score_if_positive_st 
gen PSU_score_if_positive_st_cube=PSU_score_if_positive_st_sq*PSU_score_if_positive_st
label var PSU_score_if_positive_st_cube "PSU $\times$ PSU $\times$ PSU"


gen simce_avg_st_sq=simce_avg_st*simce_avg_st
gen modalidadXsimce=modalidad*simce_avg_st 

gen region4=1 if cod_reg_rbd_pred==4
replace region4=0 if cod_reg_rbd_pred!=4
gen region5=1 if cod_reg_rbd_pred==5
replace region5=0 if cod_reg_rbd_pred!=5
gen region7=1 if cod_reg_rbd_pred==7
replace region7=0 if cod_reg_rbd_pred!=7
gen region8=1 if cod_reg_rbd_pred==8
replace region8=0 if cod_reg_rbd_pred!=8
gen region10=1 if cod_reg_rbd_pred==10
replace region10=0 if cod_reg_rbd_pred!=10
gen region13=1 if cod_reg_rbd_pred==13
replace region13=0 if cod_reg_rbd_pred!=13
gen region14=1 if cod_reg_rbd_pred==14
replace region14=0 if cod_reg_rbd_pred!=14
gen region15=1 if cod_reg_rbd_pred==15
replace region15=0 if cod_reg_rbd_pred!=15

gen hours_study_sq = hours_study*hours_study
			 
*-------------------------------------------------------------------------------	

*-- Regressions: Quality/selectivity of PACE and of regular admission ----------

*-------------------------------------------------------------------------------
	  
* Estimate regs

est clear
reg quality_adm_uni_major_PACE GPA_all_years c.GPA_all_years#c.GPA_all_years simce_avg_st c.simce_avg_st#c.simce_avg_st i.modalidad#c.simce_avg_st  i.modalidad   i.cod_reg_rbd_pred  , cluster(rbd_basefinal)
est store m1
* Graph showing fit of selectivity PACE, intermediate
predict sel_PACE_pred if quality_adm_uni_major_PACE!=.
graph twoway (lpoly sel_PACE_pred GPA_all_years , lcolor(navy) lpattern(shortdash)) (lpoly quality_adm_uni_major_PACE GPA_all_years, lcolor(navy) ), ytitle("Selectivity of PACE admission", size(medium)) xtitle("High school GPA", size(medium)) legend(order(1 "Predicted" 2 "Actual")) title("Goodness of fit (PACE)", size(medium))  saving("$dataTemp/selectivity_adm_PACE_rescale.gph", replace )

kdensity GPA_all_years if  quality_adm_uni_major_PACE!=., lcolor(navy)  ///
graphregion(color(white)) xtitle("High school GPA", size(medium))  title("Marginal distribution", size(medium)) ///
saving("$dataTemp/distribution_GPA12.gph", replace)



reg quality_adm_uni_major PSU_score_if_positive_st c.PSU_score_if_positive_st#c.PSU_score_if_positive_st simce_avg_st c.simce_avg_st#c.simce_avg_st i.modalidad#c.simce_avg_st i.modalidad   i.cod_reg_rbd_pred   , cluster(rbd_basefinal)
est store m2
* Graph showing fit of selectivity regular, intermediate
predict sel_regular_pred if quality_adm_uni_major!=.
graph twoway (lpoly sel_regular_pred PSU_score_if_positive_st , lcolor(navy) lpattern(shortdash)) (lpoly quality_adm_uni_major PSU_score_if_positive_st, lcolor(navy) ), ytitle("Selectivity of regular admission", size(medium)) xtitle("PSU score", size(medium)) title("Goodness of fit (Regular)", size(medium)) legend(order(1 "Predicted" 2 "Actual")) saving("$dataTemp/selectivity_adm_regular_rescale.gph", replace )

kdensity PSU_score_if_positive_st if quality_adm_uni_major!=., lcolor(navy)  ///
graphregion(color(white)) xtitle("PSU score", size(medium)) title("Marginal distribution", size(medium)) ///
saving("$dataTemp/distribution_PSU.gph", replace)


* 2. Graph showing fit of selectivity regular and PACE
graph combine "$dataTemp/selectivity_adm_PACE_rescale.gph" "$dataTemp/distribution_GPA12.gph"   "$dataTemp/selectivity_adm_regular_rescale.gph" "$dataTemp/distribution_PSU.gph", colfirst ///
graphregion(color(white)) ///	
saving("$dataTemp/admission_quality_fit_rescale.gph", replace) 
graph export "$graphs/admission_quality_fit_rescale.png" , replace






***************************************************************

** Figures A17-A18-A19-A20-A21-A22 

****************************************************************

* -----------------------------------
*  Commands common to all Figures
* -----------------------------------

use "$dataClean/data_applications_assignments.dta", clear
merge m:1 mrun using "$dataClean/data_experimental.dta"
keep if _merge==3
drop _merge


su distance_preferred if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram distance_preferred if treatment==0 & regular_application==1, fraction color(green%30) start(`minim') w(50) graphregion(color(white))) (histogram distance_preferred if treatment==1 & regular_application==1, fraction color(midblue%30) start(`minim') w(50)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Distance (km) between high school" "and top-listed program") ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("All", size(medsmall)) saving("$dataTemp/histogram_distance_top1_application_regular_T_C.gph", replace) 
*graph export "$graphs/histogram_distance_top1_application_regular_T_C.png", replace

su distance_admitted if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram distance_admitted if treatment==0 & regular_application==1, fraction color(green%30) start(`minim') w(50) graphregion(color(white))) (histogram distance_admitted if treatment==1 & regular_application==1, fraction color(midblue%30) start(`minim') w(50)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Distance (km) between high school" "and program to which admitted") ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("All", size(medsmall)) saving("$dataTemp/histogram_distance_admitted_application_regular_T_C.gph", replace)  
*graph export "$graphs/histogram_distance_admitted_application_regular_T_C.png", replace


su distance_average if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram distance_average if treatment==0 & regular_application==1, fraction color(green%30) start(`minim') w(50) graphregion(color(white))) (histogram distance_average if treatment==1 & regular_application==1, fraction  color(midblue%30) start(`minim') w(50)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Average distance (km) between high school" "and listed programs") ///
	   title("All", size(medsmall)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) saving("$dataTemp/histogram_distance_average_application_regular_T_C.gph", replace)  
*graph export "$graphs/histogram_distance_average_application_regular_T_C.png", replace


* SELECTIVITY REGULAR, TREATMENT VS CONTROL 
su mean_PSU_score_preferred if regular_application==1, d
local minim=r(min)-1
di "`minim'"
twoway (histogram mean_PSU_score_preferred if treatment==0 & regular_application==1, color(green%30) start(`minim') w(0.1) graphregion(color(white))) (histogram mean_PSU_score_preferred if treatment==1 & regular_application==1,  color(midblue%30) start(`minim') w(0.1)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Selectivity of top-listed program" , size(small)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("All", size(medsmall)) saving("$dataTemp/histogram_quality_top1_application_regular_T_C.gph", replace) 
*graph export "$graphs/histogram_quality_top1_application_regular_T_C.png", replace

su mean_PSU_score_admitted if regular_application==1, d
local minim=r(min)-1
di "`minim'"
twoway (histogram mean_PSU_score_admitted if treatment==0 & regular_application==1, color(green%30) start(`minim') w(0.1) graphregion(color(white))) (histogram mean_PSU_score_admitted if treatment==1 & regular_application==1,  color(midblue%30) start(`minim') w(0.1)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Selectivity of" "program to which admitted" , size(small)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("All", size(medsmall)) saving("$dataTemp/histogram_quality_admitted_application_regular_T_C.gph", replace) 
*graph export "$graphs/histogram_quality_admitted_application_regular_T_C.png", replace


su mean_PSU_score_avg if regular_application==1, d
local minim=r(min)-1
di "`minim'"
twoway (histogram mean_PSU_score_avg if treatment==0 & regular_application==1, color(green%30) start(`minim') w(0.1) graphregion(color(white))) (histogram mean_PSU_score_avg if treatment==1 & regular_application==1,  color(midblue%30) start(`minim') w(0.1)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Average selectivity" "of listed programs" , size(small)) ///
	   title("All", size(medsmall)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) saving("$dataTemp/histogram_quality_average_application_regular_T_C.gph", replace) 
*graph export "$graphs/histogram_quality_top1_application_regular_T_C.png", replace



* FIELF OD STUDY REGULAR, TREATMENT VS CONTROL

label define num_label_3 1 "Agriculture" 2 "Nat. Sciences" 3 "Soc. Sciences" 4 "Education" 5 "Arts and Hum." 6 "Engineering" 7 "Health" 8 "Services"
	encode oecd_area_preferred, generate(oecd_area_preferred_num)
	label values oecd_area_preferred_num
    label values oecd_area_preferred_num num_label_3, nofix
	
    twoway (histogram oecd_area_preferred_num if  treatment==0 & regular_application==1, discrete frac color(green%30)) (histogram oecd_area_preferred_num if treatment==1 & regular_application==1,  discrete frac color(midblue%30)),  legend(order(1    "Control" 2 "Treatment"  ) region(lstyle(none)))  xlabel(, labsize(vsmall)) ytitle("Fraction", size(small)) xtitle("Study field of top-listed program" , size(small)) 	play($do_files/grec/histogram_majors_pace_regular.grec) ///
	   title("All") saving("$dataTemp/histogram_field_top1_application_regular_T_C.gph", replace) 
	graph export "$graphs/histogram_field_top1_application_regular_T_C.png", replace
	
    twoway (histogram oecd_area_preferred_num if  treatment==1 & regular_application==1, discrete frac color(green)) (histogram oecd_area_preferred_num if treatment==1 & pace_application==1,  discrete frac  fcolor(none) lcolor(black)),  legend(order(1    "Regular" 2 "PACE"  ) region(lstyle(none)))  xlabel(, labsize(small)) ylabel(, labsize(small)) xtitle("Study field of top-listed program") 	play($do_files/grec/histogram_majors_pace_regular.grec) ///
	   title("All") saving("$dataTemp/histogram_field_top1_application_regular_T_PACE_regular.gph", replace) 
	graph export "$graphs/histogram_field_top1_application_regular_T_PACE_regular.png", replace
	
	encode oecd_area_admitted, generate(oecd_area_admitted_num)
	label values oecd_area_admitted_num
    label values oecd_area_admitted_num num_label_3, nofix
	
    twoway (histogram oecd_area_admitted_num if  treatment==0 & regular_application==1, discrete frac color(green%30)) (histogram oecd_area_admitted_num if treatment==1 & regular_application==1,  discrete frac color(midblue%30)),  legend(order(1    "Control" 2 "Treatment"  ) region(lstyle(none)))  xlabel(, labsize(vsmall)) ytitle("Fraction", size(small)) xtitle("Study field of program to which admitted" , size(small)) 	play($do_files/grec/histogram_majors_pace_regular.grec) ///
	   title("All") saving("$dataTemp/histogram_field_admitted_application_regular_T_C.gph", replace) 
	graph export "$graphs/histogram_field_admitted_application_regular_T_C.png", replace
	
    twoway (histogram oecd_area_admitted_num if  treatment==1 & regular_application==1, discrete frac color(green)) (histogram oecd_area_admitted_num if treatment==1 & pace_application==1,  discrete frac  fcolor(none) lcolor(black)),  legend(order(1    "Regular" 2 "PACE"  ) region(lstyle(none)))  xlabel(, labsize(small)) ylabel(, labsize(small)) xtitle("Study field of program to which admitted") 	play($do_files/grec/histogram_majors_pace_regular.grec) ///
	   title("All") saving("$dataTemp/histogram_field_admitted_application_regular_T_PACE_regular.gph", replace) 
	graph export "$graphs/histogram_field_admitted_application_regular_T_PACE_regular.png", replace	 


	preserve
	egen total_oecd_areas=rowtotal(fraction_oecd_area_*)
	collapse (sum) fraction_oecd_area_* total_oecd_areas, by(treatment regular_application pace_application)
	forvalues n=1(1)8{
	   replace fraction_oecd_area_`n'=round(fraction_oecd_area_`n',1)
	}
	drop total_oecd_areas
	gen groupnum=1 if treatment==1 & regular_application==1
	replace groupnum=2 if treatment==1 & pace_application==1
	replace groupnum=3 if treatment==0 
	reshape long fraction_oecd_area_, i(groupnum) j(oecd_area_num)
   
   	label values oecd_area_num
    label values oecd_area_num num_label_3, nofix
	
    twoway (histogram oecd_area_num [fweight=fraction_oecd_area_] if  treatment==0 & regular_application==1, discrete frac color(green%30)) (histogram oecd_area_num [fweight=fraction_oecd_area_] if treatment==1 & regular_application==1,  discrete frac color(midblue%30)),  legend(order(1    "Control" 2 "Treatment"  )) xtitle("Average study field of listed programs" , size(small)) xlabel(, labsize(vsmall)) ytitle("Fraction", size(small))	play($do_files/grec/histogram_majors_pace_regular.grec) title("All") saving("$dataTemp/histogram_field_average_application_regular_T_C.gph", replace)  
	
	twoway (histogram oecd_area_num [fweight=fraction_oecd_area_] if  treatment==1 & regular_application==1, discrete color(green)) (histogram oecd_area_num [fweight=fraction_oecd_area_] if treatment==1 & pace_application==1,  discrete frac  fcolor(none) lcolor(black)),  legend(order(1    "Regular" 2 "PACE"  )) xtitle("Average study field of listed programs")  xlabel(, labsize(small)) ylabel(, labsize(small))	play($do_files/grec/histogram_majors_pace_regular.grec) title("All") saving("$dataTemp/histogram_field_average_application_regular_T_PACE_regular.gph", replace) 
	restore


su mean_PSU_score_preferred if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram mean_PSU_score_preferred if treatment==0 & regular_application==1, color(green%30) start(`minim') w(0.1) graphregion(color(white)) ) (histogram mean_PSU_score_preferred if treatment==1 & regular_application==1,  color(midblue%30) start(`minim') w(0.1)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Selectivity of top-listed program" , size(small)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("Top 15%", size(medsmall)) saving("$dataTemp/histogram_quality_top1_application_regular_T_C_top15.gph", replace)  
*graph export "$graphs/histogram_quality_top1_application_regular_T_C_top15.png", replace

su mean_PSU_score_avg if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram mean_PSU_score_avg if treatment==0 & regular_application==1, color(green%30) start(`minim') w(0.1) graphregion(color(white))) (histogram mean_PSU_score_avg if treatment==1 & regular_application==1,  color(midblue%30) start(`minim') w(0.1)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Average selectivity" "of listed programs" , size(small)) ///
	   title("Top 15%", size(medsmall)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) saving("$dataTemp/histogram_quality_average_application_regular_T_C_top15.gph", replace) 
	   
su mean_PSU_score_admitted if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram mean_PSU_score_admitted if treatment==0 & regular_application==1, color(green%30) start(`minim') w(0.1) graphregion(color(white))) (histogram mean_PSU_score_admitted if treatment==1 & regular_application==1,  color(midblue%30) start(`minim') w(0.1)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Selectivity of" "program to which admitted" , size(small)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("Top 15%", size(medsmall)) saving("$dataTemp/histogram_quality_admitted_application_regular_T_C_top15.gph", replace)  


su mean_PSU_score_avg, d
local minim=r(min)
di "`minim'"
twoway (histogram mean_PSU_score_avg if treatment==1 & regular_application==1,  color(green) start(`minim') w(0.1) graphregion(color(white)) ) (histogram mean_PSU_score_avg if treatment==1 & pace_application==1,    fcolor(none) lcolor(black) start(`minim') w(0.1)),  legend(order(1 "Regular" 2 "PACE") region(lstyle(none)) size(small)) xtitle("Average selectivity" "of listed programs")	///
	   title("Top 15%", size(medsmall)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) saving("$dataTemp/histogram_average_application_quality_regular_T_PACE_regular_top15.gph", replace) 
	   

su mean_PSU_score_preferred, d
local minim=r(min)
di "`minim'"
twoway (histogram mean_PSU_score_preferred if treatment==1 & regular_application==1,  color(green) start(`minim') w(0.1) graphregion(color(white)) ) (histogram mean_PSU_score_preferred if treatment==1 & pace_application==1,    fcolor(none) lcolor(black) start(`minim') w(0.1)),  legend(order(1 "Regular" 2 "PACE") region(lstyle(none)) size(small)) xtitle("Selectivity of top-listed program")	///
	   title("Top 15%", size(medsmall)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) saving("$dataTemp/histogram_top1_application_quality_regular_T_PACE_regular_top15.gph", replace)  

	   
su mean_PSU_score_admitted, d
local minim=r(min)
di "`minim'"
twoway (histogram mean_PSU_score_admitted if treatment==1 & regular_application==1,  color(green) start(`minim') w(0.1) graphregion(color(white)) ) (histogram mean_PSU_score_admitted if treatment==1 & pace_application==1,    fcolor(none) lcolor(black) start(`minim') w(0.1)),  legend(order(1 "Regular" 2 "PACE") region(lstyle(none)) size(small)) xtitle("Selectivity of" "program to which admitted")	///
	   title("Top 15%", size(medsmall)) ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) saving("$dataTemp/histogram_admitted_application_quality_regular_T_PACE_regular_top15.gph", replace)  
	   
su distance_average if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram distance_average if treatment==0 & regular_application==1, fraction color(green%30) start(`minim') w(50) graphregion(color(white)) ) (histogram distance_average if treatment==1 & regular_application==1, fraction  color(midblue%30) start(`minim') w(50)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Average distance (km) between high school" "and listed programs") ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("Top 15%", size(medsmall)) saving("$dataTemp/histogram_distance_average_application_regular_T_C_top15.gph", replace)  
*graph export "$graphs/histogram_distance_average_application_regular_T_C_top15.png", replace


su distance_admitted if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram distance_admitted if treatment==0 & regular_application==1, fraction color(green%30) start(`minim') w(50) graphregion(color(white)) ) (histogram distance_admitted if treatment==1 & regular_application==1, fraction  color(midblue%30) start(`minim') w(50)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Distance (km) between high school" "and program to which admitted") ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("Top 15%", size(medsmall)) saving("$dataTemp/histogram_distance_admitted_application_regular_T_C_top15.gph", replace)  
*graph export "$graphs/histogram_distance_admitted_application_regular_T_C_top15.png", replace


* LOCATION REGULAR, TREATMENT VS CONTROL
su distance_preferred if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram distance_preferred if treatment==0 & regular_application==1, fraction color(green%30) start(`minim') w(50) graphregion(color(white)) ) (histogram distance_preferred if treatment==1 & regular_application==1, fraction  color(midblue%30) start(`minim') w(50)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Distance (km) between high school" "and top-listed program") ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("Top 15%", size(medsmall)) saving("$dataTemp/histogram_distance_top1_application_regular_T_C_top15.gph", replace)  
*graph export "$graphs/histogram_distance_top1_application_regular_T_C_top15.png", replace


su distance_admitted if regular_application==1, d
local minim=r(min)
di "`minim'"
twoway (histogram distance_admitted if treatment==0 & regular_application==1, fraction color(green%30) start(`minim') w(50) graphregion(color(white)) ) (histogram distance_admitted if treatment==1 & regular_application==1, fraction  color(midblue%30) start(`minim') w(50)), legend(order(1  "Control" 2 "Treatment" ) region(lstyle(none)) size(small)) xtitle("Distance (km) between high school" "and program to which admitted") ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   title("Top 15%", size(medsmall)) saving("$dataTemp/histogram_distance_admitted_application_regular_T_C_top15.gph", replace)  
*graph export "$graphs/histogram_distance_admitted_application_regular_T_C_top15.png", replace


twoway (histogram distance_admitted if regular_application==1 & treatment==1 & distance_admitted<=1000, start(0) fraction width(50) color(green) graphregion(color(white)) ) ///
       (histogram distance_admitted if pace_application==1 & treatment==1 & distance_admitted<=1000, start(0)  fraction width(50)  fcolor(none) lcolor(black)), ///
	   xlabel(0(250)1000) xtitle("Distance (km) between high school" "and program to which admitted") ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   legend(order(1 "Regular" 2 "PACE") pos(6) row(1) nobox  region(lstyle(none)) size(small)) ///
	   title("Top 15%", size(medsmall)) saving("$dataTemp/histogram_distance_assigned_college_top15.gph", replace) 
*graph export "$graphs/histogram_distance_assigned_college_top15.png", replace

twoway (histogram distance_average if regular_application==1 & treatment==1 & abs(distance_average)<=1000, start(0) fraction width(50) color(green) graphregion(color(white)) ) ///
       (histogram distance_average if pace_application==1 & treatment==1 & abs(distance_average)<=1000, start(0)  fraction width(50)  fcolor(none) lcolor(black)), ///
	   xlabel(0(250)1000) xtitle( "Average distance (km) between high school" "and listed programs ") ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small))  ///
	   legend(order(1 "Regular" 2 "PACE") pos(6) row(1) nobox  region(lstyle(none)) size(small)) ///
	   title("Top 15%", size(medsmall)) saving("$dataTemp/histogram_distance_average_top15.gph", replace) 
*graph export "$graphs/histogram_distance_average_top15.png", replace


twoway (histogram distance_preferred if regular_application==1 & treatment==1 & distance_preferred<=1000, start(0) fraction width(50) color(green) graphregion(color(white)) ) ///
       (histogram distance_preferred if pace_application==1 & treatment==1 & distance_preferred<=1000, start(0)  fraction width(50)  fcolor(none) lcolor(black)), ///
	   xlabel(0(250)1000) xtitle("Distance (km) between high school" "and top-listed program") ytitle(, size(small))  xlabel(, labsize(small)) ylabel(, labsize(small)) ///
	   legend(order(1 "Regular" 2 "PACE") pos(6) row(1) nobox  region(lstyle(none)) size(small)) ///
	   title("Top 15%", size(medsmall)) saving("$dataTemp/histogram_distance_preferred_college_top15.gph", replace) 
*graph export "$graphs/histogram_distance_preferred_college_top15.png", replace

preserve
	egen total_oecd_areas=rowtotal(fraction_oecd_area_*)
	collapse (sum) fraction_oecd_area_* total_oecd_areas, by(treatment regular_application pace_application)
	forvalues n=1(1)8{
	   replace fraction_oecd_area_`n'=round(fraction_oecd_area_`n',1)
	}
	drop total_oecd_areas
	gen groupnum=1 if treatment==1 & regular_application==1
	replace groupnum=2 if treatment==1 & pace_application==1
	replace groupnum=3 if treatment==0 
	reshape long fraction_oecd_area_, i(groupnum) j(oecd_area_num)
    label values oecd_area_num
    label values oecd_area_num num_label_3, nofix
	
    twoway (histogram oecd_area_num [fweight=fraction_oecd_area_] if  treatment==0 & regular_application==1, discrete frac color(green%30)) (histogram oecd_area_num [fweight=fraction_oecd_area_] if treatment==1 & regular_application==1,  discrete frac color(midblue%30)),  legend(order(1    "Control" 2 "Treatment"  )) xtitle("Average study field of listed programs" , size(small)) xlabel(, labsize(vsmall)) ytitle("Fraction", size(small))	play($do_files/grec/histogram_majors_pace_regular.grec) title("Top 15%") saving("$dataTemp/histogram_field_average_application_regular_T_C_top15.gph", replace)  
	
	twoway (histogram oecd_area_num [fweight=fraction_oecd_area_] if  treatment==1 & regular_application==1, discrete color(green)) (histogram oecd_area_num [fweight=fraction_oecd_area_] if treatment==1 & pace_application==1,  discrete frac  fcolor(none) lcolor(black)),  legend(order(1    "Regular" 2 "PACE"  )) xtitle("Average study field of listed programs")  xlabel(, labsize(small)) ylabel(, labsize(small))	play($do_files/grec/histogram_majors_pace_regular.grec) title("Top 15%") saving("$dataTemp/histogram_field_average_application_regular_T_PACE_regular_top15.gph", replace) 
	restore
	
	


    twoway (histogram oecd_area_preferred_num if  treatment==0 & regular_application==1, discrete frac color(green%30)) (histogram oecd_area_preferred_num if treatment==1 & regular_application==1,  discrete frac color(midblue%30)),  legend(order(1    "Control" 2 "Treatment"  )) xtitle("Study field of top-listed program" , size(small)) xlabel(, labsize(vsmall)) ytitle("Fraction", size(small))	play($do_files/grec/histogram_majors_pace_regular.grec) title("Top 15%") saving("$dataTemp/histogram_field_top1_application_regular_T_C_top15.gph", replace)  
	
    twoway (histogram oecd_area_preferred_num if  treatment==1 & regular_application==1, discrete color(green)) (histogram oecd_area_preferred_num if treatment==1 & pace_application==1,  discrete frac  fcolor(none) lcolor(black)),  legend(order(1    "Regular" 2 "PACE"  )) xtitle("Study field of top-listed program")  xlabel(, labsize(small)) ylabel(, labsize(small))	play($do_files/grec/histogram_majors_pace_regular.grec) title("Top 15%") saving("$dataTemp/histogram_field_top1_application_regular_T_PACE_regular_top15.gph", replace)  

	 twoway (histogram oecd_area_admitted_num if  treatment==0 & regular_application==1, discrete frac color(green%30)) (histogram oecd_area_admitted_num if treatment==1 & regular_application==1,  discrete frac color(midblue%30)),  legend(order(1    "Control" 2 "Treatment"  )) xtitle("Study field of program to which admitted" , size(small)) xlabel(, labsize(vsmall)) ytitle("Fraction", size(small))	play($do_files/grec/histogram_majors_pace_regular.grec) title("Top 15%") saving("$dataTemp/histogram_field_admitted_application_regular_T_C_top15.gph", replace)  
	
    twoway (histogram oecd_area_admitted_num if  treatment==1 & regular_application==1, discrete color(green)) (histogram oecd_area_admitted_num if treatment==1 & pace_application==1,  discrete frac  fcolor(none) lcolor(black)),  legend(order(1    "Regular" 2 "PACE"  )) xtitle("Study field of program to which admitted")  xlabel(, labsize(small)) ylabel(, labsize(small))	play($do_files/grec/histogram_majors_pace_regular.grec) title("Top 15%") saving("$dataTemp/histogram_field_admitted_application_regular_T_PACE_regular_top15.gph", replace)  

* -----------------------------------
*  Figure-specific commands:
* -----------------------------------

******************************************************************************
**# Figure A17: Selectivity regular across T groups - applications/admissions
******************************************************************************
* SELECTIVITY REGULAR ALL and TOP 15, TREATMENT VS CONTROL
	graph combine  "$dataTemp/histogram_quality_average_application_regular_T_C.gph" "$dataTemp/histogram_quality_average_application_regular_T_C_top15.gph"   "$dataTemp/histogram_quality_top1_application_regular_T_C.gph" "$dataTemp/histogram_quality_top1_application_regular_T_C_top15.gph"  "$dataTemp/histogram_quality_admitted_application_regular_T_C.gph" "$dataTemp/histogram_quality_admitted_application_regular_T_C_top15.gph" , r(3) c(2) ///
	graphregion(color(white)) ///	
	saving("$dataTemp/histogram_quality_regular_T_C_comb.gph", replace) 
	graph export "$graphs/histogram_quality_regular_T_C_comb.png" , replace


***********************************************************************************
**# Figure A18: Selectivity PACE and regular in T group- applications/admissions
***********************************************************************************
	* SELECTIVITY TOP 15 PACE VS REGULAR
		graph combine  "$dataTemp/histogram_average_application_quality_regular_T_PACE_regular_top15.gph"   ///
		"$dataTemp/histogram_top1_application_quality_regular_T_PACE_regular_top15.gph" ///
		 "$dataTemp/histogram_admitted_application_quality_regular_T_PACE_regular_top15.gph" , r(3) c(2) ///
	graphregion(color(white)) ///
	saving("$dataTemp/histogram_quality_T_PACE_regular_top15_comb.gph", replace) 
	graph export "$graphs/histogram_quality_T_PACE_regular_top15_comb.png" , replace
	
	
******************************************************************************
**# Figure A19: Location regular across T groups - applications/admissions
******************************************************************************
* LOCATION REGULAR ALL and TOP 15, TREATMENT VS CONTROL 
	graph combine "$dataTemp/histogram_distance_average_application_regular_T_C.gph" "$dataTemp/histogram_distance_average_application_regular_T_C_top15.gph" ///
	 "$dataTemp/histogram_distance_top1_application_regular_T_C.gph" "$dataTemp/histogram_distance_top1_application_regular_T_C_top15.gph" ///
	"$dataTemp/histogram_distance_admitted_application_regular_T_C.gph" "$dataTemp/histogram_distance_admitted_application_regular_T_C_top15.gph", r(3) c(2) ///
	graphregion(color(white)) ///	
	saving("$dataTemp/histogram_distance_regular_T_C_comb.gph", replace) 
	graph export "$graphs/histogram_distance_regular_T_C_comb.png" , replace
	

***********************************************************************************
**# Figure A20: Location PACE and regular in T group- applications/admissions
***********************************************************************************

* LOCATION TOP 15 PACE VS REGULAR 
	graph combine   "$dataTemp/histogram_distance_average_top15.gph" "$dataTemp/histogram_distance_preferred_college_top15.gph" "$dataTemp/histogram_distance_assigned_college_top15.gph",  ///
	graphregion(color(white)) ///	
	saving("$dataTemp/histogram_distance_top15_comb.gph", replace) 
	graph export "$graphs/histogram_distance_top15_comb.png" , replace
	
	
******************************************************************************
**# Figure A21: Study field regular across T groups - applications/admissions
******************************************************************************
* FIELD REGULAR ALL and TOP 15, TREATMENT VS CONTROL
	graph combine "$dataTemp/histogram_field_average_application_regular_T_C.gph" "$dataTemp/histogram_field_average_application_regular_T_C_top15.gph" ///
	"$dataTemp/histogram_field_top1_application_regular_T_C.gph" "$dataTemp/histogram_field_top1_application_regular_T_C_top15.gph"  "$dataTemp/histogram_field_admitted_application_regular_T_C.gph" "$dataTemp/histogram_field_admitted_application_regular_T_C_top15.gph" , r(3) c(2) ///
	graphregion(color(white)) ///	
	saving("$dataTemp/histogram_field_regular_T_C_comb.gph", replace) 
	graph export "$graphs/histogram_field_regular_T_C_comb.png" , replace
	
***********************************************************************************
**# Figure A22: Study field PACE and regular in T group- applications/admissions
***********************************************************************************
	* FIELD TOP 15 PACE VS REGULAR
		graph combine   "$dataTemp/histogram_field_average_application_regular_T_PACE_regular_top15.gph"   ///
		"$dataTemp/histogram_field_top1_application_regular_T_PACE_regular_top15.gph" ///
		 "$dataTemp/histogram_field_admitted_application_regular_T_PACE_regular_top15.gph" , r(3) c(2) ///
	graphregion(color(white)) ///
	saving("$dataTemp/histogram_field_T_PACE_regular_top15_comb.gph", replace) 
	graph export "$graphs/histogram_field_T_PACE_regular_top15_comb.png" , replace
	


**********************************************************************************************************
**# Figure A23: Goodness of fit of perceived PSU and GPA production functions at exerted effort levels
**********************************************************************************************************
use "$dataClean/data_experimental.dta", clear
keep if in_experimental_schools==1

est clear 
* 1. Estimate regressions for Table 

label var GPA_segundo "GPA in grade 10"
label var GPA_avg_1_2 "GPA in grades 9-10"
label var simce_avg_st "Simce test score in grade 10"


* Generate outcome variables: expected score (GPA, PSU) net of perceived effort impacts
gen GPAb_34=2*(exp_NEM-0.5*GPA_avg_1_2)  // We assume exp_NEM captures the expected GPA in the last 4 high school years 
										  // GPAb_34 is the believed score in years 3 and 4 of high school, from the poingt of view of
										  // the start of year 3, when GPA_1_2 is known 
gen res_GPAb= GPAb_34 - GPAb_coeff_eff *hours_study 
gen res_PSUb=expPSUscore_st- PSUb_coeff_eff_2*hours_study  if exp_PSUscore>=450 & exp_PSUscore!=.
replace res_PSUb=expPSUscore_st- PSUb_coeff_eff_1*hours_study  if exp_PSUscore<450 & exp_PSUscore!=.


label var res_PSUb "Perceived PSU"
label var  res_GPAb "Perceived GPA"


* PSUb
reg res_PSUb  GPA_avg_1_2 simce_avg_st  
est store m1
predict pred_res_PSUb if e(sample)==1 
gen pred_PSUb=pred_res_PSUb + PSUb_coeff_eff_1*hours_study  if exp_PSUscore<450 & exp_PSUscore!=.
replace pred_PSUb=pred_res_PSUb + PSUb_coeff_eff_2*hours_study  if exp_PSUscore>=450 & exp_PSUscore!=.


* GPAb
reg res_GPAb  GPA_avg_1_2 simce_avg_st   , cluster(rbd_basefinal)
est store m2
predict pred_res_GPAb if e(sample)==1 
gen pred_GPAb = pred_res_GPAb + GPAb_coeff_eff * hours_study 

 	graph twoway (lpoly pred_GPAb GPA_avg_1_2  , lcolor(navy) lpattern(shortdash)) (lpoly GPAb_34 GPA_avg_1_2 , lcolor(navy) ) ///
	(kdensity GPA_avg_1_2 , lcolor(gray) lpattern(dash) yaxis(2)), ///
	ytitle("Perceived GPA at chosen effort", size(medium)) ytitle("Baseline GPA density", axis(2) size(medium)) ///
	xtitle("Baseline GPA", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density"))  saving("$dataTemp/GPAb_belief_GoF_nolasso_GPAseg.gph", replace )
	
	 	graph twoway (lpoly pred_GPAb simce_avg_st , lcolor(navy) lpattern(shortdash)) (lpoly GPAb_34 simce_avg_st, lcolor(navy) ) ///
		(kdensity simce_avg_st, lcolor(gray) lpattern(dash) yaxis(2)), ///
		 ytitle("Perceived GPA at chosen effort", size(medium)) ytitle("Simce density", axis(2) size(medium)) ///
		 xtitle("Simce", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density" ))  saving("$dataTemp/GPAb_belief_GoF_nolasso.gph", replace )
		
		graph twoway ///
		(lpoly pred_PSUb simce_avg_st , lcolor(navy) lpattern(shortdash)) ///
		(lpoly expPSUscore_st simce_avg_st, lcolor(navy) ) ///
		(kdensity simce_avg_st, lcolor(gray) lpattern(dash) yaxis(2)), ///
		ytitle("Perceived PSU at chosen effort", size(medium)) ytitle("Simce density", axis(2) size(medium)) ///
		xtitle("Simce", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density"))  saving("$dataTemp/PSUb_belief_GoF_nolasso.gph", replace )
			
		graph twoway (lpoly pred_PSUb GPA_avg_1_2  , lcolor(navy) lpattern(shortdash)) (lpoly expPSUscore_st GPA_avg_1_2 , lcolor(navy) ) ///
		(kdensity GPA_avg_1_2 , lcolor(gray) lpattern(dash) yaxis(2)), ///
		ytitle("Perceived PSU at chosen effort", size(medium))  ytitle("Baseline GPA density", axis(2) size(medium)) ///
		xtitle("Baseline GPA", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density" ))  saving("$dataTemp/PSUb_belief_GoF_nolasso_GPAseg.gph", replace )	
		
			graph combine "$dataTemp/PSUb_belief_GoF_nolasso.gph" "$dataTemp/GPAb_belief_GoF_nolasso.gph" "$dataTemp/PSUb_belief_GoF_nolasso_GPAseg.gph" "$dataTemp/GPAb_belief_GoF_nolasso_GPAseg.gph", saving("$dataTemp/PSUbGPAb_belief_GoF_nolasso.gph", replace)
graph export "$graphs/PSUbGPAb_belief_GoF_nolasso.png", replace 





*************************************************************************************************************************************************
**# Figure A24: Goodness of fit of LASSO regression model used to impute missing data on beliefs that are initial conditions in the model
*************************************************************************************************************************************************

 use "$dataTemp/with_irt_basefinal_merged_all.dta", clear
 
 gen p_graduate=1 if P31==5
replace p_graduate =0.75 if P31==4
replace p_graduate =0.50 if P31==3
replace p_graduate =0.25 if P31==2
replace p_graduate =0 if P31==1

gen NEM_top15_August=P46
replace NEM_top15_August=NEM_top15_August/100 if NEM_top15_August>99 & NEM_top15_August<701 // missing "." for decimals in some answers
replace NEM_top15_August=. if NEM_top15_August<1 | NEM_top15_August>7
*lab var hours_to_be_top15 "expected hours needed to have NEM among the top 15 percent in school"


 gen hours_study_PSU600=P40
gen hours_study_PSU450=P41
gen hours_study_PSU350=P42

rename hours_study_PSU600 h600  // equivalent to standardized PSU .90909091
rename hours_study_PSU450 h450 // equivalent to standardized PSU -.45454545
rename hours_study_PSU350 h350  // equivalente to standardized PSU -1.3636364

gen hours_to_be_top15=P53
gen hours_to_have_NEM55=P54

gen exp_PSUscore=775 if P39==1
replace exp_PSUscore=650 if P39==2
replace exp_PSUscore=525 if P39==3
replace exp_PSUscore=400 if P39==4
replace exp_PSUscore=300 if P39==5
replace exp_PSUscore=200 if P39==6


** generate class code
egen class_code=group(rbd_basefinal let_cur modalidad)
replace class_code=. if let_cur=="" | modalidad==.

gen simce_avg=(ptje_lect2m_alu + ptje_mate2m_alu)/2
label var simce_avg "SIMCE score"
set matsize 800
regress simce_avg GPA_segundo_medio i.class_code i.age 
predict simce_avg_imputed
replace simce_avg=simce_avg_imputed if simce_avg==.
drop simce_avg_imputed
gen simce_avg_st=(simce_avg-258.95715)/52.253445 // standardize simce using data on population enrolled in 11th grade in tercero medio in high school in 2016 (see above)
lab var simce_avg_st "Simce score (standardized)"

*Calculate returns to effort of PSU, standardized score 
gen returns_eff_PSUb_1= (((450-500)/110) - ((350-500)/110))/(h450-h350) if h450!=h350  // returns between 350 and 450 
gen returns_eff_PSUb_2= (((600-500)/110) - ((450-500)/110))/(h600-h450) if h600!=h450 // returns between 450 and 600 

*sum  returns_eff_PSUb_1 returns_eff_PSUb_2

gen returns_eff_PSUb_1_original=returns_eff_PSUb_1
gen returns_eff_PSUb_2_original=returns_eff_PSUb_2 
lab var returns_eff_PSUb_1_original "Perceived returns to effort PSUb, including negative"
lab var returns_eff_PSUb_2_original "Perceived returns to effort PSUb, including negative"

replace  returns_eff_PSUb_1=. if returns_eff_PSUb_1<0
replace returns_eff_PSUb_2=. if returns_eff_PSUb_2<0


label var returns_eff_PSUb_1 "Perceived marginal returns to hrs study/week, PSUb<450"
label var returns_eff_PSUb_2 "Perceived marginal returns to hrs study/week, PSUb>=450"

gen returns_eff_PSUb_i=returns_eff_PSUb_1 if exp_PSUscore <450
replace returns_eff_PSUb_i=returns_eff_PSUb_2 if exp_PSUscore >=450 & exp_PSUscore!=.
label var returns_eff_PSUb_i "Perceived marginal returns to hrs study/week, at expected PSU"



replace h600=. if returns_eff_PSUb_1==. | returns_eff_PSUb_2==.
replace h450=. if returns_eff_PSUb_1==. | returns_eff_PSUb_2==.
replace h350=. if returns_eff_PSUb_1==. | returns_eff_PSUb_2==.



rename h600 hours_study_PSU600
rename h450 hours_study_PSU450
rename h350 hours_study_PSU350





gen returns_effort_top15_55=(NEM_top15_August-5.5)/(hours_to_be_top15-hours_to_have_NEM55)  if hours_to_be_top15!=hours_to_have_NEM55 // using august answer for cutoff as this is the NEM level the survey asks about 

gen returns_effort_top15_55_original=returns_effort_top15_55 
label var returns_effort_top15_55_original "Perceived marginal returns to GPAb, including negative"
replace returns_effort_top15_55=. if returns_effort_top15_55<0

label var returns_effort_top15_55 "Derivative of GPA^b (assumed linear) wrt eff, missing if <0"


replace hours_to_have_NEM55=. if returns_effort_top15_55==.
replace  hours_to_be_top15=. if  returns_effort_top15_55==.


* Predict returns to effort, kink, and p_graduate for those for whom they are missing


	* Rename variables (too long) *
	
	rename alumno_prioritario alumno_prior
	
	rename simce_avg_st simce
	
	* STEP 1: PREPARE DATA SET FOR LASSO. 
	
	global controls "simce female age alumno_prior modalidad simce_pw2 simce_pw3 age_pw2 age_pw3" // Controls for Interaction
	
	global controls2 "simce age" // Controls for Power 
	
	global controls_final "simce female age alumno_prior modalidad simce_pw2 simce_pw3 age_pw2 age_pw3 female_X_simce age_X_simce age_X_female alumno_prior_X_simce alumno_prior_X_female alumno_prior_X_age modalidad_X_simce modalidad_X_female modalidad_X_age modalidad_X_alumno_prior simce_pw2_X_simce simce_pw2_X_female simce_pw2_X_age simce_pw2_X_alumno_prior simce_pw2_X_modalidad simce_pw3_X_simce simce_pw3_X_female simce_pw3_X_age simce_pw3_X_alumno_prior simce_pw3_X_modalidad simce_pw3_X_simce_pw2 age_pw2_X_simce age_pw2_X_female age_pw2_X_age age_pw2_X_alumno_prior age_pw2_X_modalidad age_pw2_X_simce_pw2 age_pw2_X_simce_pw3 age_pw3_X_simce age_pw3_X_female age_pw3_X_age age_pw3_X_alumno_prior age_pw3_X_modalidad age_pw3_X_simce_pw2 age_pw3_X_simce_pw3 age_pw3_X_age_pw2" // Final list of controls

	

	* STEP 2: Add the powers of age and simce

	foreach var of varlist $controls2 {
	
	local label : variable label `var'
	
	di "`var'" // display variable
	gen `var'_pw2 = `var'^(2) // Power 2 
	label var   `var'_pw2  "`label' (Power 2)" 
	
	gen `var'_pw3 = `var'^(3) // Power 3
	label var   `var'_pw3  "`label' (Power 3)"
	}
	
	* STEP 3:  Include two-way interactions of every variable

	unab vars : $controls
	local nvar : word count `vars'
	forval i = 1/`nvar' {
	  forval j = 1/`=`i'-1' {
		local x : word `i' of `vars'
		local y : word `j' of `vars'
		generate `x'_X_`y' = `x' * `y'
	  }
	}
	
	* STEP 5: Drop one from any pair of perfectly collinear variables

	_rmcoll $controls_final
	 display r(varlist)
	global final_covarlist =  r(varlist)
	
	* Insert labels of our outcomes *
	
	*label var enrolled_grad_any_in_y6 "Potential Graduates in 2023"
	
	* Print final list *
	
	di "$final_covarlist"
     
	* Label Covariates before Exporting *
	
	label var simce "SIMCE Score"
	label var female "Female"
	label var age "Age"
	label var alumno_prior "Alumno Prioritario"
	label var modalidad "Modalidad"
	label var simce_pw2 "SIMCE Score Power 2"
	label var simce_pw3 "SIMCE Score Power 3"
	label var age_pw2 "Age Power 2"
	label var age_pw3 "Age Power 3"
	
	label var female_X_simce "Female $\times$ SIMCE"
	
	label var age_X_simce "Age $\times$ SIMCE"
	label var age_X_female "Age $\times$ Female"
	
	label var alumno_prior_X_simce "Alumno $\times$ SIMCE"
	label var alumno_prior_X_female "Alumno $\times$ Female"
	label var alumno_prior_X_age "Alumno $\times$ Age"
	
	label var modalidad_X_simce "Modalidad $\times$ SIMCE"
	label var modalidad_X_female "Modalidad $\times$ Female"
	label var modalidad_X_age  "Modalidad $\times$ Age"
	label var modalidad_X_alumno_prior "Modalidad $\times$ Alumno"
	
	label var simce_pw2_X_simce  "SIMCE (2) $\times$ SIMCE"
	label var simce_pw2_X_female "SIMCE (2) $\times$ Female"
	label var simce_pw2_X_age "SIMCE (2) $\times$ Age"
	label var simce_pw2_X_alumno_prior "SIMCE (2) $\times$ Alumno"
	label var simce_pw2_X_modalidad "SIMCE (2) $\times$ Modalidad"
	
	label var simce_pw3_X_simce "SIMCE (3) $\times$ SIMCE"
	label var simce_pw3_X_female "SIMCE (3) $\times$ Female"
	label var simce_pw3_X_age "SIMCE (3) $\times$ Age"
	label var simce_pw3_X_alumno_prior "SIMCE (3) $\times$ Alumno"
	label var simce_pw3_X_modalidad "SIMCE (3) $\times$ Modalidad"
	label var simce_pw3_X_simce_pw2 "SIMCE (3) $\times$ SIMCE (2)"
	
	label var age_pw2_X_simce "Age (2) $\times$ SIMCE"
	label var age_pw2_X_female "Age (2) $\times$ Female"
	label var age_pw2_X_age "Age (2) $\times$ Age"
	label var age_pw2_X_alumno_prior "Age (2) $\times$ Alumno"
	label var age_pw2_X_modalidad "Age (2) $\times$ Modalidad"
	label var age_pw2_X_simce_pw2 "Age (2) $\times$ SIMCE (2)"
	label var age_pw2_X_simce_pw3 "Age (2) $\times$ SIMCE (3)"
	
	label var age_pw3_X_simce "Age (3) $\times$ SIMCE"
	label var age_pw3_X_female "Age (3) $\times$ Female"
	label var age_pw3_X_age "Age (3) $\times$ Age"
	label var age_pw3_X_alumno_prior "Age (3) $\times$ Alumno"
	label var age_pw3_X_modalidad "Age (3) $\times$ Modalidad"
	label var age_pw3_X_simce_pw2 "Age (3) $\times$ SIMCE (2)"
	label var age_pw3_X_simce_pw3 "Age (3) $\times$ SIMCE (3)"
	label var age_pw3_X_age_pw2 "Age (3) $\times$ Age (2)"
	
	
	
	**********************************************************************************************
	* returns_eff_PSUb_1 ,  returns_eff_PSUb_2, and the location of the kink (hours_study_PSU450)
	**********************************************************************************************
	* PERFORM LASSO *
	
	estimates clear
	
	eststo clear     		
	
	quietly lasso linear returns_eff_PSUb_1  $final_covarlist , rseed(10)
	lassogof
	lassoinfo
	lassoknots

	predict returns_eff_PSUb_1_est if e(sample) == 1
		predict returns_eff_PSUb_1_all // Predict for the whole sample
	
	
	quietly lasso linear returns_eff_PSUb_2  $final_covarlist , rseed(10)
	lassogof
	lassoinfo
	lassoknots
	etable

	predict returns_eff_PSUb_2_est if e(sample) == 1
		predict returns_eff_PSUb_2_all // Predict for the whole sample
		
		
	quietly lasso linear hours_study_PSU450 $final_covarlist , rseed(10)
	lassogof
	lassoinfo
	lassoknots
	
	predict kink_est if e(sample)==1
	predict kink_all // Predict for the whole sample 
	
	
	
	rename simce simce_avg_st 
	rename alumno_prior alumno_prioritario

	
	
******** Use the following 
graph twoway (lpoly returns_eff_PSUb_1_est simce_avg_st  , lcolor(navy) lpattern(shortdash)) (lpoly returns_eff_PSUb_1 simce_avg_st  , lcolor(navy) ) ///
(kdensity simce_avg_st, lcolor(gray) lpattern(dash) yaxis(2)), ///
 ytitle("Coefficient on effort" "in PSU belief, below kink ", size(medium)) ytitle("Simce density", axis(2) size(medium)) /// 
xtitle("Simce", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density"))  saving("$dataTemp/PSU_belief_1_simce.gph", replace )

graph twoway (lpoly returns_eff_PSUb_2_est simce_avg_st  , lcolor(navy) lpattern(shortdash)) (lpoly returns_eff_PSUb_2 simce_avg_st  , lcolor(navy) ) ///
(kdensity simce_avg_st, lcolor(gray) lpattern(dash) yaxis(2)), ///
 ytitle("Coefficient on effort" "in PSU belief, above kink", size(medium)) ytitle("Simce density", axis(2) size(medium)) /// 
 xtitle("Simce", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density"))  saving("$dataTemp/PSU_belief_2_simce.gph", replace )


graph twoway (lpoly kink_est  simce_avg_st  , lcolor(navy) lpattern(shortdash)) (lpoly hours_study_PSU450 simce_avg_st  , lcolor(navy) ) ///
(kdensity simce_avg_st, lcolor(gray) lpattern(dash) yaxis(2)), /// 
ytitle("Kink point in PSU belief" "(hours of study/week)", size(medium)) ytitle("Simce density", axis(2) size(medium)) ///  
xtitle("Simce", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density"))   saving("$dataTemp/PSU_kink_simce.gph", replace )

	********************************************
	* GPAb returns
	*******************************************
	estimates clear 
	eststo clear 
	
	
	rename  simce_avg_st simce
	rename  alumno_prioritario alumno_prior
	
	quietly lasso linear returns_effort_top15_55  $final_covarlist , rseed(10)
	lassogof
	lassoinfo
	lassoknots
	etable
	lassocoef
	
	predict returns_GPA_est if e(sample) == 1
		predict returns_GPA_est_all // Predict for the whole sample

	
	** Use the following:
	graph twoway (lpoly returns_GPA_est simce , lcolor(navy) lpattern(shortdash)) (lpoly returns_effort_top15_55 simce, lcolor(navy) ) ///
(kdensity simce, lcolor(gray) lpattern(dash) yaxis(2)), /// 
 ytitle("Coefficient of effort" "in GPA belief", size(medium))  ytitle("Simce density", axis(2) size(medium)) /// 
 xtitle("Simce", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density"))  saving("$dataTemp/GPA_belief_GoF.gph", replace )
	

	****************************************************************************
	* P_graduate
	****************************************************************************
	estimates clear
	
	eststo clear     		
	
	
	
	quietly lasso linear p_graduate  $final_covarlist , rseed(10)
	lassogof
	lassocoef
	etable
	est store lasso_p_grad

	predict p_graduate_est if e(sample) == 1
		predict p_graduate_all // Predict for the whole sample
	
	
	
	
	** Use the following:
	graph twoway (lpoly p_graduate_est simce , lcolor(navy) lpattern(shortdash)) (lpoly p_graduate simce, lcolor(navy) ) ///
(kdensity simce, lcolor(gray) lpattern(dash) yaxis(2)), ///
 ytitle("Perceived selective" "college persistence", size(medium))  ytitle("Simce density", axis(2) size(medium)) ///  
 xtitle("Simce", size(medium)) title("Goodness of fit", size(medium)) legend(order(1 "Predicted" 2 "Actual" 3 "Density")) saving("$dataTemp/Ppersist_belief_GoF.gph", replace )
	
	
*** To put in paper's apprendix 
		graph combine "$dataTemp/PSU_belief_1_simce.gph"  "$dataTemp/PSU_belief_2_simce.gph" "$dataTemp/PSU_kink_simce.gph" "$dataTemp/GPA_belief_GoF.gph" "$dataTemp/Ppersist_belief_GoF.gph", r(3) c(2) saving("$dataTemp/PSU_belief_GoF.gph", replace)
graph export "$graphs/PSU_GPA_ppersist_belief_GoF.png", replace 



********************************************************************************
**# Erase unnecessary files
********************************************************************************
local path "$dataClean"

cd "`path'"
local files : dir . files "count*.dta"
foreach f of local files {
    erase "`f'"
}

cd "$root"
