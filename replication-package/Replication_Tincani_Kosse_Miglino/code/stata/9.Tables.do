

*******************************************************************************
* DO-FILE DESCRIPTION:
* This do-file generates all figures and tables of the paper submitted to JPE
********************************************************************************

********************************************************************************
********************************************************************************
**# TABLES
********************************************************************************
********************************************************************************

********************************************************************************
**# Table 1: Sample balance across treatment and control groups 
******************************************************************************** 
use "$dataClean/data_experimental.dta", clear
local variables female age alumno_prioritario meduc peduc hh_income simce_avg neverfailed santiago modalidad GPA_avg_1_2
cap matrix A
lab var female "Female"
lab var age "Age (years)"
lab var alumno_prioritario "Very-low-SES student"
lab var meduc "Mother's education (years) "
lab var peduc "Father's education (years) "
lab var hh_income "Family income (1,000 CLP)"
lab var simce_avg "SIMCE score (points)"
lab var neverfailed "Never failed a year"
lab var santiago "Santiago resident"
lab var modalidad "Academic high-school track"
label var GPA_avg_1_2 "GPA in grades 9 and 10 (GPA points)"
* Loop over each variable and add its statistics to the matrix
local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==0, detail
    local mean: display %9.3f round(r(mean),0.001)
    reg `var' treatment, cluster(rbd_basefinal)
    local b: display %9.3f round(_b[treatment],0.001)
    local se: display %9.3f round(_se[treatment],0.001)
	local pval:  display %9.3f r(table)[4,1]
    local N: display %9.3f e(N)
	if `k'==1 {
    matrix A = (`mean', `b', `pval', `N')
    matrix A = A \ (.,`se',.,. )
	}
	else {
    matrix A = A \ (`mean', `b',  `pval', `N')
    matrix A = A \ (.,`se',.,. )
	}
	local k=`k'+1
}
cap gen nolabel=1
lab var nolabel " "
* Label the rows and columns of the matrix
matrix rownames A = female  nolabel age nolabel alumno_prioritario nolabel meduc nolabel peduc nolabel hh_income nolabel simce_avg nolabel neverfailed nolabel santiago nolabel modalidad nolabel GPA_avg_1_2 nolabel


* Display the table
esttab matrix(A) using "$tables/sample_balance.tex", nogap label replace nomtitles fragment nolines collabels(none)  nonumbers ///
prehead(`"\begin{table}[H] \centering"' `"\footnotesize"'  `"\begin{threeparttable}"' `"\centering "'   ///
        `"\caption{\label{tab:balancing} \textsc{Sample Balance Across Treatment and Control Groups}}"' ///
            `"\begin{tabular}{lcccc} \hline"' ///
			`"			&            & Difference between    &  \$p\$-Value    & \\"' ///
			`"			&  Control    &  Treatment and Control  &  (Difference equals zero)  & N  \\"' ///
			 `"  			& (1)       & (2)                     &   (3)       & (4)    \\ "' ///
			 `" \hline"' ) ///
postfoot(`"\hline"'  `"\end{tabular}"'  `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"	\item	\scriptsize \noindent \textsc{ Note.--} Standard errors clustered at the school level are shown in parentheses. Very-low-SES student is  a student that the government classified as very socioeconomically vulnerable ({\itshape Alumno Prioritario}). SIMCE is a standardized achievement test taken in $10^{th}$ grade. GPA is measured on a scale from 1 to 7. "' ///
		 `"\end{tablenotes}"' `"\end{threeparttable}"'  `"\end{table}"') 
		 
		 
		 

		 
		 
	
		 
		 
* For structural model estimation sample, effect in sample with non-missing p_graduate
est clear 
use "$dataClean/data_experimental.dta", clear
keep if p_graduate!=.
local variables female age alumno_prioritario meduc peduc hh_income simce_avg neverfailed santiago modalidad
cap matrix A
lab var female "Female"
lab var age "Age (years)"
lab var alumno_prioritario "Very-low-SES student"
lab var meduc "Mother's education (years) "
lab var peduc "Father's education (years) "
lab var hh_income "Family income (1,000 CLP)"
lab var simce_avg "SIMCE score (points)"
lab var neverfailed "Never failed a year"
lab var santiago "Santiago resident"
lab var modalidad "Academic high-school track"
* Loop over each variable and add its statistics to the matrix
local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==0, detail
    local mean: display %9.3f round(r(mean),0.001)
    reg `var' treatment, cluster(rbd_basefinal)
    local b: display %9.3f round(_b[treatment],0.001)
    local se: display %9.3f round(_se[treatment],0.001)
	local pval:  display %9.3f r(table)[4,1]
    local N: display %9.3f e(N)
	if `k'==1 {
    matrix A = (`mean', `b', `pval', `N')
    matrix A = A \ (.,`se',.,. )
	}
	else {
    matrix A = A \ (`mean', `b',  `pval', `N')
    matrix A = A \ (.,`se',.,. )
	}
	local k=`k'+1
}
cap gen nolabel=1
lab var nolabel " "
* Label the rows and columns of the matrix
matrix rownames A = female  nolabel age nolabel alumno_prioritario nolabel meduc nolabel peduc nolabel hh_income nolabel simce_avg nolabel neverfailed nolabel santiago nolabel modalidad nolabel


* Display the table
esttab matrix(A) using "$tables/sample_balance_version_sm.tex", nogap label replace nomtitles fragment nolines collabels(none)  nonumbers ///
prehead(`"\begin{table}[H]\centering"' `"%\resizebox{\textwidth}{!}{ "'  ///
        `"\caption{\label{tab:balancingvsm} \textsc{Sample Balance Across Treatment and Control Groups, Structural Model Sample}}"' ///
            `"\renewcommand{\arraystretch}{1} "' ///
            `"\begin{tabular}{lcccc} \hline"' ///
			`"  &            &                        &    & \\"' ///
			`"			&            & Difference between    &  \$p\$-Value    & \\"' ///
			`"			&  Control    &  Treatment and Control  &  (Difference equals zero)  & N  \\"' ///
			 `"  			& (1)       & (2)                     &   (3)       & (4)    \\ "' ///
			 `" \hline"' ) ///
postfoot(`"\hline"'  `"\end{tabular}"'  `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"	\item	\scriptsize \noindent \textsc{ Note.--} This Table is based on the sample used to estimate the structural model, characterized by non-missing data on the perceived likelihood of graduating from college. Standard errors clustered at the school level are shown in parentheses. Very-low-SES student is  a student that the government classified as very socioeconomically vulnerable ({\itshape Prioritario}). SIMCE is a standardized achievement test taken in $10^{th}$ grade. "' ///
		 `"\end{tablenotes}"' `"\end{table}"') 



********************************************************************************
**# Table 2: Overview of Data
******************************************************************************** 
* It is only text

********************************************************************************
**# Table 3: Description of Choices and Outcomes in Control Schools 
********************************************************************************
use "$dataClean/data_experimental.dta", clear
est clear
* List your variables here
local variables hours_study  sit_PSU PSU_score_if_positive_st applied_SUA_regular_or_pace admitted_SUA_regular_or_pace ///
                 enrolled_SUA_by_y1 STEM_enrolled_SUA_by_y1 No_STEM_enrolled_SUA_by_y1 mean_PSU_score_uni_major_st distance_enrolled ///
				 enrolled_SUA_by_y5 STEM_enrolled_SUA_by_y5 No_STEM_enrolled_SUA_by_y5 enrolled_voc_by_y1 enrolled_nonSUA_by_y1 
cap matrix A
lab var hours_study "Weekly study hours"
lab var sit_PSU "Took college entrance exam"
lab var PSU_score_if_positive_st "College entrance exam score $|$ took exam"
lab var applied_SUA_regular_or_pace "Applied to selective college"
lab var admitted_SUA_regular_or_pace "Admitted to selective college"
lab var enrolled_SUA_by_y1 "Enrolled in selective college"
lab var STEM_enrolled_SUA_by_y1 "Enrolled in selective college, STEM"
lab var No_STEM_enrolled_SUA_by_y1 "Enrolled in selective college, non-STEM"
*lab var mean_PSU_score_uni_major_st "Avg entrance exam score in selective college-major"
lab var mean_PSU_score_uni_major_st "Selectivity of program (college-major pair)"
label var distance_enrolled "Distance in km from program (college-major pair)"
*lab var enrolled_SUA_by_y5 "Enrolled-graduated in selective college 5 years later"
lab var enrolled_SUA_by_y5  "Enrolled and persisted in selective college, year 5"
*lab var STEM_enrolled_SUA_by_y5 "Enrolled-graduated STEM selective 5 years later"
lab var STEM_enrolled_SUA_by_y5 "Enrolled and persisted in selective college STEM, year 5"
*lab var No_STEM_enrolled_SUA_by_y5 "Enrolled-graduated non-STEM selective 5 years later"
lab var No_STEM_enrolled_SUA_by_y5 "Enrolled and persisted in selective college non-STEM, year 5"
lab var enrolled_voc_by_y1 "Enrolled in vocational institution"
lab var enrolled_nonSUA_by_y1 "Enrolled in off-platform college"
* Loop over each variable and add its statistics to the matrix
local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==0, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    local N: display %9.0g r(N)
	if `k'==1 {
    matrix A = (`mean', `sd', `N')
	}
	else {
    matrix A = A \ (`mean', `sd', `N')
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames A = `variables'
matrix colnames A = Mean SD N 

* Display the table
esttab matrix(A) using "$tables/summary_stats_outcomes.tex", nogap label replace  fragment nomtitles nolines collabels(none)  nonumbers nolines ///
prehead(`"\begin{table}[h!]\centering"' ///
        `"\footnotesize"' `"\begin{threeparttable}"' ///
            `"\caption{\label{tab:summaryoutcomesbeliefs} \textsc{Description of Choices and Outcomes in Control Schools}}"' ///			
            `"\begin{tabular}{l*{1}{ccc}}"' `"\hline"' ///
			`"    &        Mean&          St.dev.  & N \\ "' ///
			 `"   & (1) & (2) & (3)  \\ "' ///
			`"		    \multicolumn{4}{l}{\textsc{A. All Students}}\\"'   `"\cline{1-1}"' ) 

local k=1
foreach var in `variables' {
    quietly summarize  `var' if treatment==0 & top15baseline==1, detail // *previously using graduate_top15==1
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    local N: display %9.0g r(N)
	if `k'==1 {
    matrix B=(`mean', `sd', `N')
	}
	else {
    matrix B= B \ (`mean', `sd', `N')
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames B = `variables'
matrix colnames B = Mean SD N

* Display the table
esttab matrix(B) using "$tables/summary_stats_outcomes.tex", nogap label append nomtitles fragment nolines collabels(none)  nonumbers nolines ///
prehead(`" & & &  \\"' `" \multicolumn{4}{l}{\textsc{B. Students in Top $15\%$ at baseline}}\\"'   `"\cline{1-1}"' ) ///
postfoot(`"\hline"'  `"\end{tabular}"' `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"\item	\scriptsize \textsc{ Note. --} Sample of students enrolled in control schools. The college entrance exam score is designed to have mean 500 and standard deviation 110 among all exam takers, we report the standardized score. The selectivity of the program is the average entrance exam score among all regular entrants in the selective college and major the student enrolled in. As a measure of distance we use the length (km) of the shortest path between the coordinates of the program and of the high school the student attended, implementing Vincenty formula to calculate distances on a reference ellipsoid. A student is coded as persisting in the fifth year if he/she enrolled in the first year after high school and stayed continuously enrolled in selective college every year up until and including year $5$, or if he/she enrolled in the first year after high school and graduated from a selective college in a year prior to year $5$.  If a student transfers to a different selective college program without taking a break in their studies, they are still considered continuously enrolled in a selective college. "' ///
		 `"\end{tablenotes}"' `"\end{threeparttable}"'  `"\end{table}"') 



********************************************************************************
**# Table 4: Effect of PACE on Pre-College Outcomes
********************************************************************************
use "$dataClean/data_experimental.dta", clear
est clear 
reg score_all_st treatment simce_avg_st female age alumno_prioritario neverfailed modalidad i.id_fieldworker  [weight=weight_mat] ,  cluster(rbd_basefinal)
su score_all_st if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m1
reg st_effort_latent2 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad i.id_fieldworker  [weight=weight_mat] ,  cluster(rbd_basefinal)
su st_effort_latent2 if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m2
reg  std_GPA_core treatment  age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_sample == 1  [pweight=weight_mat] , cluster(rbd_basefinal)
su std_GPA_core if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m3
reg  std_GPA_specific treatment  age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_sample == 1  [pweight=weight_mat]  , cluster(rbd_basefinal)
su std_GPA_specific if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m4

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {regress std_GPA_core treatment simce_avg_st female age alumno_prioritario neverfailed modalidad  if in_sample == 1 [pweight=weight_mat], vce(cluster rbd_basefinal)} {regress std_GPA_specific treatment simce_avg_st female age alumno_prioritario neverfailed modalidad  if in_sample == 1 [pweight=weight_mat], vce(cluster rbd_basefinal)} // put treatment variable immediately after dependent variable in each regression
local q_std_GPA_core:  display %9.3g  round(e(q_std_GPA_core_treatment), 0.001)
local q_std_GPA_specific:  display %9.3g  round(e(q_std_GPA_specific_treatment), 0.001)

rwolf2  ///
(regress std_GPA_core treatment simce_avg_st female age alumno_prioritario neverfailed modalidad  if in_sample == 1 [pweight=weight_mat], vce(cluster rbd_basefinal)) ///
(regress std_GPA_specific treatment simce_avg_st female age alumno_prioritario neverfailed modalidad  if in_sample == 1 [pweight=weight_mat] , vce(cluster rbd_basefinal)) ///
,  indepvars(treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newclusterid)
local pw_std_GPA_core:  display %9.3g  round(e(rw_std_GPA_core_treatment), 0.001)
local pw_std_GPA_specific:  display %9.3g  round(e(rw_std_GPA_specific_treatment), 0.001)


esttab m1 m2 m3 m4 using "$tables/TE_pre_college_outcomes.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN r2 N, fmt(3 3 0) labels("Control mean" "R-squared" "Observations" )) ///
    prehead(`"\begin{table}[h]\centering %htbp"' `"\footnotesize "' `"\begin{threeparttable}  "' ///
	`"\setlength\tabcolsep{0pt} "' 	`"\setlength\extrarowheight{2pt}"' 	`"\caption{\label{tabreducedform} \textsc{Effect of PACE on Pre-College Outcomes}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{4}{c}}"' `"\hline"' `"\noalign{\vskip 4pt}"' ///
		`"&  \multicolumn{1}{c}{Test Score} & \multicolumn{1}{c}{\shortstack{Study Effort\\Index (std.)}} & \multicolumn{2}{c}{$12^{th}$ grade GPA}  \\  "' ///
	 `"\cline{4-5}"'    `"&   &   & \multicolumn{1}{c}{Tested subjects} & \multicolumn{1}{c}{Untested subjects} \\"' ///
		`"& (1)             & (2)   &  (3) & (4) \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  The coefficients are OLS estimates. Standard errors were clustered at the school level. The standard set of controls (see notes under Figure \ref{fig:TEovertime}) and Inverse Probability Weights were used. Field-worker fixed effects were used for columns (1) and (2). {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. The outcome variable in column (1) is the number of correct answers on the achievement test, standardized. The outcome variable in column (2) is the standardized study effort score predicted from the principal component analysis of the eight survey instruments reported in Appendix Table \ref{tab:effortappendix}. The outcome variables in columns (3) and (4) are the GPA in subjects tested and untested on the PSU exam, standardized. The smaller number of observations in column (4) compared to column (3) reflects different grade-reporting rules across mandatory and optional courses. Romano-Wolf adjusted p-values (based on 1000 bootstrap replications for the family of $12^{th}$ grade GPA) in columns (3) and (4) are `pw_std_GPA_core' and `pw_std_GPA_specific'. Q-values for the family of $12^{th}$ grade GPA) in columns (3) and (4) are `q_std_GPA_core' and `q_std_GPA_specific'. * p$<$0.10; ** p$<$0.05; *** p$<$0.01" "\end{tablenotes}" `"\end{threeparttable}  "' "\end{table}") 
 
 
  

  
********************************************************************************
**# Table 5: Description of Subjective Beliefs
********************************************************************************
est clear 
use "$dataClean/data_experimental.dta", clear
* List your variables here
local variables exp_PSU_st PSU_st_bias bias_own_NEM NEM_top15 minus_bias_top15 think_top15 
cap matrix A

lab var exp_PSU_st "Believed entrance exam score (\$\sigma\$)"
lab var PSU_st_bias "Believed minus actual entrance exam score \$|\$ took exam (\$\sigma\$)"
lab var p_admitted_above_050 "Believes regular admission probability \$\geq 0.50\$"
lab var bias_own_NEM "Believed minus actual \$12^{th}\$ grade GPA (GPA points)"
lab var NEM_top15  "Expected top 15\% cutoff"
lab var minus_bias_top15 "Actual minus believed top \$15\%\$ cutoff in school (GPA points)"
lab var think_top15 "Believes is in top \$15\%\$ of school"

* Loop over each variable and add its statistics to the matrix
local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==0, detail
    local mean: display %9.3g round(r(mean), 0.001)
    local sd: display %9.3g round(r(sd),0.001)
    local N: display %9.0g r(N)
	if `k'==1 {
    matrix A = (`mean', `sd', `N')
	}
	else {
    matrix A = A \ (`mean', `sd', `N')
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames A = `variables'
matrix colnames A = Mean SD N

* Display the table
esttab matrix(A) using "$tables/summary_beliefs.tex", nogap label replace  fragment nomtitles nolines collabels(none)  nonumbers nolines ///
prehead(`"\begin{table}[H]\centering"' `"\begin{threeparttable}"' ///
	`"\footnotesize"' 	`"%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
	`"\caption{\label{tab:summarybeliefs} \textsc{Description of Subjective Beliefs}}"' ///
	`"\begin{tabular}{l*{1}{ccc}}"' `"	\hline"'  `"	&        Mean&          Std. Deviation    & N\\"' `"	& (1)        & (2)   & (3) \\ "' ///
	`"	\hline"' ) ///
postfoot(`"\hline"'  `"\end{tabular}"' `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"\item	\scriptsize \textsc{ Note. --}"' ///
		  `"Sample of students enrolled in the \$64\$ control schools. This table is based on linked survey-administrative data: we elicited students \textquotesingle beliefs and linked their survey answers to actual outcomes. \$\sigma\$ is the standard deviation of PSU entrance exam scores among the population of exam takers. GPA is a number between 1.0 and 7.0. We define a student as believing she is in the top \$15\%\$ of her school if her perceived GPA is above her perceived top \$15\%\$ cutoff. Appendix Table \ref{tab:beliefelicitation} contains an English translation of the survey instruments we used to elicit the beliefs reported in this Table.   \\ "' ///
		 `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"') 


********************************************************************************
**# Table 6:  Effect of PACE on Pre-College Outcomes, heterogeneity by perceived distance from cutoff
********************************************************************************
use "$dataClean/data_experimental.dta", clear
replace NEM_top15_April=NEM_top15 if NEM_top15_April==.
gen believed_distance_from_cutoff=abs(exp_NEM-NEM_top15_April) // if exp_NEM>NEM_top15_April
su exp_PSUscore, d
gen above_med_exp_PSU=exp_PSUscore>r(p50) if exp_PSUscore!=.
lab var above_med_exp_PSU "Above median belief on PSU"
gen within_med_exp_PSU=1-above_med_exp_PSU
lab var within_med_exp_PSU "PSU belief $\leq$ median"

* All students
reg score_all_st treatment##c.believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff   [weight=weight_mat] ,  cluster(rbd_basefinal)
su score_all_st if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m1
reg st_effort_latent2 i.treatment##c.believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff [weight=weight_mat],  cluster(rbd_basefinal)
su st_effort_latent2 if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m2
reg  std_GPA_core i.treatment##c.believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat] , cluster(rbd_basefinal)
su std_GPA_core if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m3
reg  std_GPA_specific i.treatment##c.believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat]  , cluster(rbd_basefinal)
su std_GPA_specific if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m4

gen T_bdist=treatment*believed_distance_from_cutoff

reg  std_GPA_core T_bdist treatment believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat], vce(cluster rbd_basefinal)

reg  std_GPA_specific T_bdist treatment believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat]  , cluster(rbd_basefinal)

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {reg  std_GPA_core T_bdist treatment believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat], vce(cluster rbd_basefinal)} {reg  std_GPA_specific T_bdist treatment believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat]  , cluster(rbd_basefinal)}
local q_std_GPA_core_all:  display %9.3g  round(e(q_std_GPA_core_T_bdist), 0.001)
local q_std_GPA_specific_all:  display %9.3g  round(e(q_std_GPA_specific_T_bdist), 0.001)

rwolf2  ///
(reg  std_GPA_core T_bdist treatment believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat], vce(cluster rbd_basefinal)) ///
(reg  std_GPA_specific T_bdist treatment believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat]  , cluster(rbd_basefinal)) ///
,  indepvars(T_bdist, T_bdist)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newclusterid)

local pw_std_GPA_core_all:  display %9.3g  round(e(rw_std_GPA_core_T_bdist), 0.001)
local pw_std_GPA_specific_all:  display %9.3g  round(e(rw_std_GPA_specific_T_bdist), 0.001)


esttab m1 m2 m3 m4 using "$tables/TE_pre_college_outcomes_perceived_dist_cutoff_f.tex", replace ///
    booktabs label unstack noobs keep(1.treatment 1.treatment#c.believed_distance_from_cutoff believed_distance_from_cutoff) ///
	coeflabels(1.treatment  "Treatment" 1.treatment#c.believed_distance_from_cutoff "Treatment $\times$ Perceived distance" believed_distance_from_cutoff "Perceived distance") ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN r2 N, fmt(3 3 0) labels("Control mean" "R-squared" "Observations" )) ///
    prehead(`"\begin{table}[h!]\centering"' `"\footnotesize "' `"\begin{threeparttable} "' ///
	`"\setlength\tabcolsep{0pt} "' 	`"\setlength\extrarowheight{2pt}"' 	`"\caption{\label{TEprecollegeoutcomesperceiveddistcutoff} \textsc{Effect of PACE on Pre-College Outcomes by Perceived Distance from Cutoff}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{4}{c}}"' `"\hline"' `"\noalign{\vskip 4pt}"' ///
		`"&  \multicolumn{1}{c}{Test Score} & \multicolumn{1}{c}{\shortstack{Study Effort\\Index (std.)}} & \multicolumn{2}{c}{$12^{th}$ grade GPA}  \\  "' ///
	 `"\cline{4-5}"'    `"&   &   & \multicolumn{1}{c}{Tested subjects} & \multicolumn{1}{c}{Untested subjects} \\"' ///
		`"& (1)             & (2)   &  (3) & (4) \\"' 	`"\hline"'  `" \multicolumn{5}{c}{A. All students} \\"' ) 
	

preserve 
* Students that believe to be in the top 15% and below median PSU
keep if exp_NEM>NEM_top15_April & exp_NEM!=.
keep if within_med_exp_PSU==1 
reg score_all_st treatment##c.believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if within_med_exp_PSU==1 [weight=weight_mat] ,  cluster(rbd_basefinal)
su score_all_st if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m1
reg st_effort_latent2 i.treatment##c.believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if within_med_exp_PSU==1 [weight=weight_mat],  cluster(rbd_basefinal)
su st_effort_latent2 if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m2
reg  std_GPA_core i.treatment##c.believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1 & within_med_exp_PSU==1  [pweight=weight_mat] , cluster(rbd_basefinal)
su std_GPA_core if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m3
reg  std_GPA_specific i.treatment##c.believed_distance_from_cutoff  c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1 & within_med_exp_PSU==1 [pweight=weight_mat]  , cluster(rbd_basefinal)
su std_GPA_specific if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m4

fdr_sharpened_qvalues_adj {reg  std_GPA_core T_bdist treatment believed_distance_from_cutoff c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat], vce(cluster rbd_basefinal)} {reg  std_GPA_specific T_bdist treatment believed_distance_from_cutoff c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat]  , cluster(rbd_basefinal)}
local q_std_GPA_core_top:  display %9.3g  round(e(q_std_GPA_core_T_bdist), 0.001)
local q_std_GPA_specific_top:  display %9.3g  round(e(q_std_GPA_specific_T_bdist), 0.001)

rwolf2  ///
(reg  std_GPA_core T_bdist treatment believed_distance_from_cutoff c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat], vce(cluster rbd_basefinal)) ///
(reg  std_GPA_specific T_bdist treatment believed_distance_from_cutoff c.simce_avg_st##c.believed_distance_from_cutoff i.female##c.believed_distance_from_cutoff  c.age##c.believed_distance_from_cutoff  i.alumno_prioritario##c.believed_distance_from_cutoff  i.neverfailed##c.believed_distance_from_cutoff  i.modalidad##c.believed_distance_from_cutoff  i.id_fieldworker##c.believed_distance_from_cutoff if in_sample == 1  [pweight=weight_mat]  , cluster(rbd_basefinal)) ///
,  indepvars(T_bdist, T_bdist)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newclusterid)

local pw_std_GPA_core_top:  display %9.3g  round(e(rw_std_GPA_core_T_bdist), 0.001)
local pw_std_GPA_specific_top:  display %9.3g  round(e(rw_std_GPA_specific_T_bdist), 0.001)




esttab m1 m2 m3 m4 using "$tables/TE_pre_college_outcomes_perceived_dist_cutoff_f.tex", append ///
    booktabs label unstack noobs keep(1.treatment 1.treatment#c.believed_distance_from_cutoff believed_distance_from_cutoff) ///
	coeflabels(1.treatment  "Treatment" 1.treatment#c.believed_distance_from_cutoff "Treatment $\times$ Perceived distance" believed_distance_from_cutoff "Perceived distance") ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN r2 N, fmt(3 3 0) labels("Control mean" "R-squared" "Observations" )) ///
    prehead(`"\\"'  `"\multicolumn{5}{c}{B. Students with perceived GPA $>$ perceived cutoff, perceived PSU $\leq$ median} \\"' ) ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  The coefficients are OLS estimates. Standard errors were clustered at the school level. {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. {\itshape Perceived distance} is the absolute value of the difference between perceived own GPA and the perceived $85^{th}$ percentile of the GPA distribution in the school. In all regressions we include the standard set of controls (see notes under Figure \ref{fig:TEovertime}), {\itshape Treatment}, {\itshape Perceived distance} and the interaction of {\itshape Perceived distance} with {\itshape Treatment} and with all controls. Inverse Probability Weights were used. Field-worker fixed effects, and field-worker fixed effects interacted with {\itshape Perceived distance}, were used for columns (1) and (2). See Appendix \ref{sec:appendixrobustness} for the survey questions used to elicit beliefs. Panel A is based on the sample of all survey respondents. Panel B is based on the sample of sample respondents who perceive themselves to have a higher GPA than the $85^{th}$ percentile in the school and a PSU score lower than or equal to the median perceived PSU. The PSU score ranges from 150 to 850 and the median perceived PSU score lies in the interval 450-600. The outcome variables are the same ones used in Table \ref{tabreducedform}. The Romano-Wolf adjusted p-values (based on 1000 bootstrap replications) for the coefficient on {\itshape Treatment} $\times$ {\itshape Perceived distance}  for the family of $12^{th}$ grade GPA) in columns (3) and (4) are `pw_std_GPA_core_all' and `pw_std_GPA_specific_all' for Panel A and `pw_std_GPA_core_top' and `pw_std_GPA_specific_top' for panel B. Sharpened q-values for the coefficient on {\itshape Treatment} $\times$ {\itshape Perceived distance}  for the family of $12^{th}$ grade GPA) in columns (3) and (4) are `q_std_GPA_core_all' and `q_std_GPA_specific_all' for Panel A and `q_std_GPA_core_top' and `q_std_GPA_specific_top' for panel B. * p$<$0.10; ** p$<$0.05; *** p$<$0.01" "\end{tablenotes}" "\end{threeparttable}" "\end{table}") 
restore 





	
********************************************************************************
********************************************************************************
**# APPENDIX TABLES
********************************************************************************
********************************************************************************

*************************************************************************************************
**# Table A1: Geographic Location of Regular and PACE Seats
*************************************************************************************************
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
	
	******************************
	** Distance 
	******************************
	preserve 
	import delimited "$dataRaw/PSU/A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN.csv", clear
		duplicates tag mrun, gen(dupli)
		drop if dupli>0
		drop dupli
		save "$dataTemp/A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN_uniqueMRUN.dta", replace
	restore 
	
	
	merge 1:1 mrun using "$dataTemp/A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN_uniqueMRUN.dta" , keepusing(cod_sexo codigo_region nombre_region codigo_provincia nombre_provincia codigo_comuna nombre_comuna rbd)
	rename codigo_region codigo_region_rbd 
	rename nombre_region nombre_region_rbd
	rename codigo_provincia codigo_provincia_rbd 
	rename codigo_comuna codigo_comuna_rbd 
	rename nombre_comuna nombre_comuna_rbd
	rename nombre_provincia nombre_provincia_rbd 
	
	gen nombre_region_uni="REGION DE ANTOFAGASTA" if region_sede=="Antofagasta"
	replace nombre_region_uni="REGION DE ARICA Y PARINACOTA" if region_sede=="Arica y Parinacota"
	replace nombre_region_uni="REGION DE ATACAMA" if region_sede=="Atacama"
	replace nombre_region_uni="REGION DE COQUIMBO" if region_sede=="Coquimbo"
	replace nombre_region_uni="REGION DE LA ARAUCANIA" if region_sede=="La Araucanía"
	replace nombre_region_uni="REGION DE LOS LAGOS" if region_sede=="Los Lagos"
	replace nombre_region_uni="REGION DE LOS RIOS" if region_sede=="Los Ríos"
	replace nombre_region_uni="REGION DE MAGALLANES Y DE LA ANTARTICA CHILENA" if region_sede=="Magallanes"
	replace nombre_region_uni="REGION DE TARAPACA" if region_sede=="Tarapacá"
	replace nombre_region_uni="REGION DE VALPARAISO" if region_sede=="Valparaíso"
	replace nombre_region_uni="REGION DEL BIOBIO" if region_sede=="Biobío"
	replace nombre_region_uni="REGION DEL LIBERTADOR GENERAL BERNARDO O'HIGGINS" if region_sede=="Lib. Gral B. O'Higgins"
	replace nombre_region_uni="REGION DEL MAULE" if region_sede=="Maule"
	replace nombre_region_uni="REGION METROPOLITANA DE SANTIAGO" if region_sede=="Metropolitana"
	replace nombre_region_uni="REGION AISEN DEL GENERAL CARLOS IBAÑEZ DEL CAMPO" if region_sede=="Aysén"
	
	gen same_reg_rbd_uni=1 if nombre_region_uni==nombre_region_rbd & nombre_region_uni!=""  & nombre_region_rbd!=""
	replace same_reg_rbd_uni=0  if nombre_region_uni!=nombre_region_rbd & nombre_region_uni!="" & nombre_region_rbd!=""
	
	
	replace provincia_sede="COIHAIQUE" if provincia_sede=="COYHAIQUE"
	gen same_prov_rbd_uni=1 if provincia_sede==nombre_provincia_rbd & provincia_sede!="" & nombre_provincia_rbd!=""
	replace same_prov_rbd=0 if provincia_sede!=nombre_provincia_rbd & provincia_sede!="" & nombre_provincia_rbd!=""
	
	
sum same_prov_rbd_uni same_reg_rbd_uni if regular_seat ==1 & selective_college ==1 & same_prov_rbd!=. & same_reg_rbd!=.
sum same_prov_rbd_uni same_reg_rbd_uni if PACE_seat ==1 & selective_college ==1 & same_prov_rbd!=. & same_reg_rbd!=.


	
	* List your variables here
local variables same_prov_rbd_uni same_reg_rbd_uni
cap matrix A
lab var same_prov_rbd_uni "Within high school province"
lab var same_reg_rbd_uni "Within high school region"

* Loop over each variable and add its statistics to the matrix
local k=1
foreach var in `variables' {
    quietly summarize `var' if regular_seat == 1 & selective_college == 1 & same_prov_rbd != . & same_reg_rbd != . , detail
    local mean: display %9.3f r(mean)
    local sd: display %9.3f r(sd)
    local N: display %9.0g r(N)
    quietly summarize `var' if PACE_seat == 1 & selective_college == 1 & same_prov_rbd != . & same_reg_rbd != . , detail
    local meanT: display %9.3f r(mean)
    local sdT: display %9.3f r(sd)
    local NT: display %9.0g r(N)	
	if `k'==1 {
    matrix A = (`mean', `sd', `N', `meanT', `sdT', `NT')
	}
	else {
    matrix A = A \ (`mean', `sd', `N',  `meanT', `sdT', `NT')
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames A = `variables'
matrix colnames A = Mean SD N Mean SD N

* Display the table		 
		 esttab matrix(A) using "$tables/summary_stats_geog_regular_PACE.tex", nogap label replace  fragment nomtitles nolines collabels(none)  nonumbers nolines ///
		   prehead(`"\begin{table}[H]\centering"' `"\footnotesize"' `"\begin{threeparttable}"' ///
            `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{\textsc{Geographic Location of Regular and PACE Seats}}"' ///
            `"\label{tab:summarygeogregularpace}"' `"\begin{tabular}{l*{6}{c}}"' `"\toprule"' ///
			`"	  &  &  \textsc{Regular seats} & &  &  \textsc{PACE seats} & \\"' ///
			`"    &        Mean&          St.dev.  & N  &        Mean&          St.dev.  & N  \\ "' ///
			 `"   & (1) & (2) & (3) & (4)  & (5) & (6)  \\  "' ) ///
    postfoot(`"\bottomrule"' `"\end{tabular}"' `"\begin{tablenotes}\singlespacing"' `"\item"' ///
             `"\setlength{\baselineskip}{0.8\baselineskip}"' `"\scriptsize"' ///
             `"\textsc{ Note.--} Geographic distribution of regular and PACE seats in selective colleges relative to the locations of applicants' high schools. Source: Administrative data for the 2018 centralized admission process."' ///
             `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"')
		    

*************************************************************************************************
**# Table A2: List of STEM majors
*************************************************************************************************
* Only text


*************************************************************************************************
**# Table A3: Baseline characteristics of all students and of those targeted by the PACE policy
*************************************************************************************************
* Generate summary statistics for both groups
use "$dataClean/data_population.dta", clear 
lab var alumno_prioritario "Very low SES"
lab var meduc "Mother's education (years)"
lab var peduc "Father's education (years)"
lab var hh_income "Family income (1,000 CLP)"
lab var simce_avg_st_pop "SIMCE score (standardized)"
lab var rural_rbd "Rural resident"
lab var santiago "Santiago resident"

local varlist alumno_prioritario meduc peduc hh_income simce_avg_st_pop rural_rbd santiago
estpost summarize `varlist', detail
est store allstudents
estpost summarize `varlist' if in_experimental_schools==1, detail
est store targetedstudents

* Export the table to a LaTeX file
esttab allstudents targetedstudents using "$tables/summary_statistics_target_population.tex", ///
cells(mean(fmt(2))) label fragment  replace booktabs collabels(none)  ///
starlevels(* 0.1 ** 0.05 *** 0.01) nonotes nomtitles nolines nonumbers noobs ///
prehead(`"\begin{table}[H]\centering"' ///
        `"\footnotesize"'  ///
            `"\caption{\label{tab:targetpopulation} \textsc{Baseline characteristics of all students and of those targeted by the PACE policy}}"' ///
              `"\renewcommand{\arraystretch}{1}"'  ///
			`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}} \hline"' ///
			`" &\multicolumn{1}{c}{ All students}&\multicolumn{1}{c}{ Targeted students} \\"' ///
			 `" & (1)  & (2) \\ "'   `"\hline"') ///
postfoot(`"\hline"'  `"\end{tabular*}"'  `"\begin{threeparttable}"' `"\begin{tablenotes}[para,flushleft]\singlespacing"'  ///
  `"\item\scriptsize \textsc{Source.--} SIMCE and SEP administrative data on $10^{th}$ graders in 2015."' ///
	     `" \textsc{ Note. --} Very low SES indicates a student that the government classified as socioeconomically vulnerable ({\itshape Alumno Pioritario}). SIMCE is a standardized achievement test taken in $10^{th}$ grade. Sample restriction in column (1): all students enrolled in Chilean high schools in $11^{th}$ grade.  Sample restriction in column (2): students in the 128 experimental schools. All characteristics were collected before the start of the intervention. "' ///
		 `"\end{tablenotes}"'  `"\end{threeparttable}"' `"\end{table}"') 



********************************************************************************	 
**# Table A4: Effects of PACE on College Applications and Admissions
********************************************************************************
use "$dataClean/data_experimental.dta", clear

rename applied_SUA_regular_or_pace applied_SUA
rename admitted_SUA_regular_or_pace admitted_SUA

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)} {reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)} // put treatment variable immediately after the dependent variable in each regression
local q_applied_SUA_all = round(e(q_applied_SUA_treatment), 0.001)
local q_admitted_SUA_all = round(e(q_admitted_SUA_treatment), 0.001)
rwolf2  ///
(reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)) ///
(reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)) ///
,  indepvars(treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
local rw_applied_SUA_all = round(e(rw_applied_SUA_treatment), 0.001)
local rw_admitted_SUA_all = round(e(rw_admitted_SUA_treatment), 0.001)

fdr_sharpened_qvalues_adj {reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)} {reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)} // put treatment variable immediately after the dependent variable in each regression
local q_applied_SUA_bottom = round(e(q_applied_SUA_treatment), 0.001)
local q_admitted_SUA_bottom = round(e(q_admitted_SUA_treatment), 0.001)
rwolf2  ///
(reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)) ///
(reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)) ///
,  indepvars(treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
local rw_applied_SUA_bottom = round(e(rw_applied_SUA_treatment), 0.001)
local rw_admitted_SUA_bottom = round(e(rw_admitted_SUA_treatment), 0.001)

fdr_sharpened_qvalues_adj {reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)} {reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)} // put treatment variable immediately after the dependent variable in each regression
local q_applied_SUA_top = round(e(q_applied_SUA_treatment), 0.001)
local q_admitted_SUA_top = round(e(q_admitted_SUA_treatment), 0.001)
rwolf2  ///
(reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)) ///
(reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)) ///
,  indepvars(treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
local rw_applied_SUA_top = round(e(rw_applied_SUA_treatment), 0.001)
local rw_admitted_SUA_top = round(e(rw_admitted_SUA_treatment), 0.001)


reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)
su applied_SUA if treatment==0
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_applied_SUA_all'
estadd scalar QV=`q_applied_SUA_all'
est store m1
reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)
su admitted_SUA if treatment==0
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_admitted_SUA_all'
estadd scalar QV=`q_admitted_SUA_all'

est store m2
reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0,  cluster(rbd_basefinal)
su applied_SUA if treatment==0 & top15baseline==0
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_applied_SUA_bottom'
estadd scalar QV=`q_applied_SUA_bottom'
est store m3
reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0,  cluster(rbd_basefinal)
su admitted_SUA if treatment==0 & top15baseline==0
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_admitted_SUA_bottom'
estadd scalar QV=`q_admitted_SUA_bottom'
est store m4
reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1,  cluster(rbd_basefinal)
su applied_SUA if treatment==0  & top15baseline==1
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_applied_SUA_top'
estadd scalar QV=`q_applied_SUA_top'
est store m5
reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1,  cluster(rbd_basefinal)
su admitted_SUA if treatment==0  & top15baseline==1
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_admitted_SUA_top'
estadd scalar QV=`q_admitted_SUA_top'
est store m6
esttab m1 m2 m3 m4 m5 m6 using "$tables/TE_applications_admissions.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(RW QV control_mean  r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val" "Control mean"  "R-squared" "Observations")) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\centering "' ///
	 		`"\caption{\label{tab: TEapplicationsadmissions} \textsc{Effects of PACE on Selective College Applications and Admissions}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{6}{c}}"' `"\hline"' ///
		`"&  \multicolumn{2}{c}{All sample} & \multicolumn{2}{c}{Bottom 85\%}  & \multicolumn{2}{c}{Top 15\%}\\  "'  ///
		`"&  \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Admissions} &  \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Admissions} &  \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Admissions}   \\  "' ///
		`"& (1)  & (2) &  (3)  & (4) &  (5)  & (6)     \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  Columns (1) and (2) use the sample of all students in the experiment. Columns (3) and (4) use the sample of students who at the end of $10^{th}$ grade, before the experiment started, were in the bottom $85\%$ of their school according to GPA in the first two high school years. Columns (5) and (6) use the sample of students who at the end of $10^{th}$ grade, before the experiment started, were in the top $15\%$ of their school according to GPA in the first two high school years. The share of students in the top $15\%$ at baseline is slightly larger than $15\%$ because there are students with the same GPA average at baseline. \textit{Control group mean} is the mean of the dependent variable in the control group. Results from OLS regressions. Treatment is a dummy equal to 1 if a school was randomly assigned to be in the PACE treatment, to 0 otherwise. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). Standard errors clustered at the school level in parenthesis. \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering each sample as one family. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01.\\" "\end{tablenotes}" "\end{table}") 
    

* For structural model estimation sample, effect in sample with non-missing p_graduate
keep if p_graduate!=.
est clear
reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad [weight=weight_mat],  cluster(rbd_basefinal)
su applied_SUA if treatment==0
estadd scalar control_mean=`r(mean)'
est store m1
reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad [weight=weight_mat],  cluster(rbd_basefinal)
su admitted_SUA if treatment==0
estadd scalar control_mean=`r(mean)'
est store m2
reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad [weight=weight_mat] if top15baseline==0,  cluster(rbd_basefinal)
su applied_SUA if treatment==0 & top15baseline==0
estadd scalar control_mean=`r(mean)'
est store m3
reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad [weight=weight_mat] if top15baseline==0,  cluster(rbd_basefinal)
su admitted_SUA if treatment==0 & top15baseline==0
estadd scalar control_mean=`r(mean)'
est store m4
reg applied_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad [weight=weight_mat] if top15baseline==1,  cluster(rbd_basefinal)
su applied_SUA if treatment==0  & top15baseline==1
estadd scalar control_mean=`r(mean)'
est store m5
reg admitted_SUA treatment simce_avg_st female age alumno_prioritario neverfailed modalidad [weight=weight_mat] if top15baseline==1,  cluster(rbd_basefinal)
su admitted_SUA if treatment==0  & top15baseline==1
estadd scalar control_mean=`r(mean)'
est store m6
esttab m1 m2 m3 m4 m5 m6 using "$tables/TE_applications_admissions_version_sm.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(control_mean  r2 N, fmt(3 3 0) labels("Control mean"  "R-squared" "Observations")) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\centering "' ///
	 		`"\caption{\label{tab: TEapplicationsadmissionsvsm} \textsc{Effects of PACE on Selective College Applications and Admissions, Structural Model Sample}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{6}{c}}"' `"\hline"' ///
		`"&  \multicolumn{2}{c}{All sample} & \multicolumn{2}{c}{Bottom 85\%}  & \multicolumn{2}{c}{Top 15\%}\\  "'  ///
		`"&  \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Admissions} &  \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Admissions} &  \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Admissions}   \\  "' ///
		`"& (1)  & (2) &  (3)  & (4) &  (5)  & (6)     \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--} This Table is based on the sample used to estimate the structural model, characterized by non-missing data on the perceived likelihood of graduating from college. Columns (1) and (2) use the sample of all students in the experiment. Columns (3) and (4) use the sample of students who at the end of $10^{th}$ grade, before the experiment started, were in the bottom $85\%$ of their school according to GPA in the first two high school years. Columns (5) and (6) use the sample of students who at the end of $10^{th}$ grade, before the experiment started, were in the top $15\%$ of their school according to GPA in the first two high school years. The share of students in the top $15\%$ at baseline is slightly larger than $15\%$ because there are students with the same GPA average at baseline. \textit{Control group mean} is the mean of the dependent variable in the control group. Results from OLS regressions. Treatment is a dummy equal to 1 if a school was randomly assigned to be in the PACE treatment, to 0 otherwise. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}) and Inverse Probability Weights. Standard errors clustered at the school level in parenthesis. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01.\\" "\end{tablenotes}" "\end{table}") 


********************************************************************************
**# TABLES A5, A6: Effects of PACE on Continuous Enrollment or Graduation Over Time
********************************************************************************
use "$dataClean/data_experimental.dta", clear 
rename treatment treat
est clear
lab var enrolled_SUA_by_y1 "A. Continuous enrollment in or graduation from selective college"
lab var enrolled_voc_by_y1 "B. Continuous enrollment in or graduation from vocational HE institute"
lab var enrolled_nonSUA_by_y1 "C. Continuous enrollment in or graduation from off-platform college"
lab var enrolled_out_by_y1 "D. Continuous enrollment in or graduation from non-SUA HE institute"
lab var enrolled_any_by_y1 "E. Continuous enrollment in or graduation from any HE institute"

* FULL SAMPLE
local var_names enrolled_SUA_ enrolled_voc_ enrolled_nonSUA_ enrolled_out_  enrolled_any_
foreach var in `var_names' {
	eststo clear

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {regress `var'by_y1 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 , vce(cluster rbd_basefinal)} {regress `var'by_y2 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1, vce(cluster rbd_basefinal)} {regress `var'by_y3 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1, vce(cluster rbd_basefinal)} {regress `var'by_y4 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1, vce(cluster rbd_basefinal)} {regress `var'by_y5 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1, vce(cluster rbd_basefinal)}   // put treatment variable immediately after dependent variable in each regression
foreach num of numlist 1(1)5 {
		local q_`var'by_y`num' = round(e(q_`var'by_y`num'_treat), 0.001)
}

rwolf2  ///
(regress `var'by_y1 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 , vce(cluster rbd_basefinal)) ///
(regress `var'by_y2 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1, vce(cluster rbd_basefinal)) ///
(regress `var'by_y3 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1, vce(cluster rbd_basefinal)) ///
(regress `var'by_y4 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1, vce(cluster rbd_basefinal)) ///
(regress `var'by_y5 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1, vce(cluster rbd_basefinal)) ///
,  indepvars(treat, treat, treat, treat, treat)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newclusterid)
foreach num of numlist 1(1)5 {
		local rw_`var'by_y`num' = round(e(rw_`var'by_y`num'_treat), 0.001)
}

	
	local lab_var: variable label `var'by_y1
	forvalues t=1(1)5 {
	    reg `var'by_y`t' treat simce_avg_st female age alumno_prioritario neverfailed modalidad ///
		if in_experimental_schools==1, cluster(rbd_basefinal)
		su `var'by_y`t' if in_experimental_schools==1  & treat==0
	    estadd scalar MEAN=`r(mean)'
	    estadd scalar RW=`rw_`var'by_y`t''
	    estadd scalar QV=`q_`var'by_y`t''
		est store m`var'by_y`t'
	}
if "`var'"=="enrolled_SUA_" {
    esttab m`var'* using "$tables/TE_enrolled_over_time.tex", keep(treat) replace booktabs b(3) se(3)  r2 ///
	       star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N, labels("RW-adj p-val" "q-val"  "Control mean" "Observations") fmt(%9.3f %9.3f %9.3f %9s)) label fragment nolines collabels(none) mlabels(none)  nonumbers nolines  ///
		     prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\centering "' ///
		`"\caption{\label{tab: TEenrolledovertime} \textsc{Effects of PACE on Continuous Enrollment or Graduation Over Time, All Sample}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{5}{c}}"' `"\hline"' `"\\"' ///
		`"&  Year 1 &  Year 2 & Year 3 & Year 4 & Year 5  \\  "' ///
	`" \multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 
    
}
else {
if "`var'"=="enrolled_any_" {
    esttab m`var'* using "$tables/TE_enrolled_over_time.tex", keep(treat) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N, labels("RW-adj p-val" "q-val" "Control mean" "Observations") fmt(%9.3f %9.3f %9.3f %9s)) label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"  \multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot(`"\hline"'  `"\end{tabular*}"' `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"\item	\scriptsize \textsc{ Note. --}"' ///
		 "Sample of all students in the experiment. Results from OLS regressions. treat is a dummy equal to 1 if a school was randomly assigned to be in the treat treat, to 0 otherwise. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). Standard errors clustered at the school level in parenthesis. HE stands for higher education. Non-SUA HE refers to institutes that do not participate in the centralized admission system, that is, vocational HE institutes and off-platform colleges. The notes under Figure \ref{fig:TEovertime} explain how the outcome variables are constructed. \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering the respective outcome variable in all years as one family. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01." 	 `"\end{tablenotes}"' `"\end{table}"')      
}
else{
    esttab m`var'* using "$tables/TE_enrolled_over_time.tex", keep(treat) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N, labels("RW-adj p-val" "q-val" "Control mean" "Observations") fmt(%9.3f %9.3f %9.3f %9s)) label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"\multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 
}
}
}

* Test of difference between TE for enrollment SUA at year 1 and enrollment SUA at year 5
local var_names enrolled_SUA_ 
foreach var in `var_names' {
   reg `var'by_y1 treat simce_avg_st female age alumno_prioritario neverfailed modalidad ///
   if in_experimental_schools==1
   est store enrolled1
   reg `var'by_y5 treat simce_avg_st female age alumno_prioritario neverfailed modalidad ///
   if in_experimental_schools==1
   est store enrolled5
   suest enrolled1 enrolled5, cluster(rbd_basefinal)
   test [enrolled1_mean]treat=[enrolled5_mean]treat
   lincom [enrolled1_mean]:treat - [enrolled5_mean]:treat
}

* TOP 15%
local var_names enrolled_SUA_ enrolled_voc_ enrolled_nonSUA_ enrolled_out_  enrolled_any_
foreach var in `var_names' {
	eststo clear


qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {regress `var'by_y1 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)} {regress `var'by_y2 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)} {regress `var'by_y3 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)} {regress `var'by_y4 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)} {regress `var'by_y5 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)}   // put treatment variable immediately after dependent variable in each regression
foreach num of numlist 1(1)5 {
		local q_`var'by_y`num' = round(e(q_`var'by_y`num'_treat), 0.001)
}

rwolf2  ///
(regress `var'by_y1 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)) ///
(regress `var'by_y2 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)) ///
(regress `var'by_y3 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)) ///
(regress `var'by_y4 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)) ///
(regress `var'by_y5 treat simce_avg_st female age alumno_prioritario neverfailed modalidad if in_experimental_schools == 1 & top15baseline==1, vce(cluster rbd_basefinal)) ///
,  indepvars(treat, treat, treat, treat, treat)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
foreach num of numlist 1(1)5 {
		local rw_`var'by_y`num' = round(e(rw_`var'by_y`num'_treat), 0.001)
}
	
	local lab_var: variable label `var'by_y1
	forvalues t=1(1)5 {
	    reg `var'by_y`t' treat simce_avg_st female age alumno_prioritario neverfailed modalidad ///
	    if in_experimental_schools==1 & top15baseline==1, cluster(rbd_basefinal) 
		su `var'by_y`t' if in_experimental_schools==1 & top15baseline==1  & treat==0
	    estadd scalar MEAN=`r(mean)'
	    estadd scalar RW=`rw_`var'by_y`t''
	    estadd scalar QV=`q_`var'by_y`t''
		est store m`var'by_y`t'
	}
if "`var'"=="enrolled_SUA_" {
    esttab m`var'* using "$tables/TE_enrolled_over_time_top15.tex", keep(treat) replace booktabs b(3) se(3) r2 ///
	       star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N, labels("RW-adj p-val" "q-val" "Control mean" "Observations") fmt(%9.3f %9.3f %9.3f %9s)) label fragment nolines collabels(none) mlabels(none)  nonumbers nolines  ///
		     prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\centering "' ///
		`"\caption{\label{tab: TEenrolledovertimetop15} \textsc{Effects of PACE on Continuous Enrollment or Graduation Over Time,  Sample of Those in the Top 15\% of Their School at Baseline}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{5}{c}}"' `"\hline"' `"\\"' ///
		`"&  Year 1 &  Year 2 & Year 3 & Year 4 & Year 5  \\  "' ///
	`"\multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 
    
}
else {
if "`var'"=="enrolled_any_" {
    esttab m`var'* using "$tables/TE_enrolled_over_time_top15.tex", keep(treat) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N, labels("RW-adj p-val" "q-val" "Control mean" "Observations") fmt(%9.3f %9.3f %9.3f %9s)) label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"  \multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot(`"\hline"'  `"\end{tabular*}"' `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"\item	\scriptsize \textsc{ Note. --}"' ///
		 "Sample of all students who at the end of $10^{th}$ grade, before the experiment started, were in the top $15\%$ of their school according to GPA in the first two high school years. Results from OLS regressions. treat is a dummy equal to 1 if a school was randomly assigned to be in the PACE treat, to 0 otherwise. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). Standard errors clustered at the school level in parenthesis. HE stands for higher education. Non-SUA HE refers to institutes that do not participate in the centralized admission system, that is, vocational HE institutes and off-platform colleges. The notes under Figure \ref{fig:TEovertime} explain how the outcome variables are constructed.  \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering the respective outcome variable in all years as one family. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01." 	 `"\end{tablenotes}"' `"\end{table}"')      
}
else{
    esttab m`var'* using "$tables/TE_enrolled_over_time_top15.tex", keep(treat) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N, labels("RW-adj p-val" "q-val" "Control mean" "Observations") fmt(%9.3f %9.3f %9.3f %9s)) label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"\multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 
}
}
}

* Test of difference between TE for enrollment SUA at year 1 and enrollment SUA at year 5
local var_names enrolled_SUA_ 
foreach var in `var_names' {
   reg `var'by_y1 treat simce_avg_st female age alumno_prioritario neverfailed modalidad ///
   if in_experimental_schools==1 & top15baseline==1
   est store enrolled1
   reg `var'by_y5 treat simce_avg_st female age alumno_prioritario neverfailed modalidad ///
   if in_experimental_schools==1 & top15baseline==1
   est store enrolled5
   suest enrolled1 enrolled5, cluster(rbd_basefinal)
   test [enrolled1_mean]treat=[enrolled5_mean]treat
   lincom [enrolled1_mean]:treat - [enrolled5_mean]:treat
}


********************************************************************************************
**# Table A7: Description of choices and outcomes in the control and treatment groups 
********************************************************************************************
use "$dataClean/data_experimental.dta", clear
est clear 
* List your variables here
local variables hours_study sit_PSU PSU_score_if_positive_st applied_SUA_regular_or_pace admitted_SUA_regular_or_pace ///
                 enrolled_SUA_by_y1 STEM_enrolled_SUA_by_y1 No_STEM_enrolled_SUA_by_y1 mean_PSU_score_uni_major_st distance_enrolled ///
				 enrolled_SUA_by_y5 STEM_enrolled_SUA_by_y5 No_STEM_enrolled_SUA_by_y5 enrolled_voc_by_y1 enrolled_nonSUA_by_y1 
cap matrix A
lab var hours_study "Weekly study hours"
lab var sit_PSU "Took college entrance exam"
lab var PSU_score_if_positive_st "College entrance exam score $|$ took exam"
lab var applied_SUA_regular_or_pace "Applied to selective college"
lab var admitted_SUA_regular_or_pace "Admitted to selective college"
lab var enrolled_SUA_by_y1 "Enrolled in selective college"
lab var STEM_enrolled_SUA_by_y1 "Enrolled in selective college, STEM"
lab var No_STEM_enrolled_SUA_by_y1 "Enrolled in selective college, non-STEM"
lab var mean_PSU_score_uni_major_st "Selectivity of program (college-major pair)"
label var distance_enrolled "Distance in km from program (college-major pair)"
lab var enrolled_SUA_by_y5  "Enrolled and persisted in selective college, year 5"
lab var STEM_enrolled_SUA_by_y5 "Enrolled and persisted in selective college STEM, year 5"
lab var No_STEM_enrolled_SUA_by_y5 "Enrolled and persisted in selective college non-STEM, year 5"
lab var enrolled_voc_by_y1 "Enrolled in vocational institution"
lab var enrolled_nonSUA_by_y1 "Enrolled in off-platform college"
* Loop over each variable and add its statistics to the matrix
local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==0, detail
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    local N: display %9.0g r(N)
	quietly summarize `var' if treatment==1, detail
    local meanT: display %9.3g r(mean)
    local sdT: display %9.3g r(sd)
    local NT: display %9.0g r(N)
	if `k'==1 {
    matrix A = (`mean', `sd', `N', `meanT', `sdT', `NT')
	}
	else {
    matrix A = A \ (`mean', `sd', `N', `meanT', `sdT', `NT')
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames A = `variables'
matrix colnames A = Mean SD N Mean SD N

* Display the table
esttab matrix(A) using "$tables/summary_stats_outcomes_TC.tex", nogap label replace  fragment nomtitles nolines collabels(none)  nonumbers nolines ///
prehead(`"\begin{table}[H]\centering"' ///
        `"\footnotesize"' `"\begin{threeparttable}"' ///
            `"\caption{\label{tab:summaryoutcomesbeliefsTC} \textsc{Description of Choices and Outcomes in Control and Treated Schools}}"' ///	
            `"\begin{tabular}{l*{1}{cccccc}}"' `"\hline"' ///
			`"	  &  &  \textsc{Control} & &  &  \textsc{Treated} & \\"' `"\cmidrule(lr{.75em}){2-4} \cmidrule(lr{.75em}){5-7}"' ///
			`"    &        Mean&          St.dev.  & N & Mean&           St.dev.    & N\\ "' ///
			 `"   & (1) & (2) & (3) & (4)  & (5) & (6)  \\ "' ///
			`"		    \multicolumn{7}{l}{\textsc{A. All Students}}\\"'   `"\cline{1-1}"' ) 

local k=1
foreach var in `variables' {
    quietly summarize  `var' if treatment==0 & top15baseline==1, detail // *previously using graduate_top15==1
    local mean: display %9.3g r(mean)
    local sd: display %9.3g r(sd)
    local N: display %9.0g r(N)
	quietly summarize `var' if treatment==1 & top15baseline==1, detail
    local meanT: display %9.3g r(mean)
    local sdT: display %9.3g r(sd)
    local NT: display %9.0g r(N)
	if `k'==1 {
    matrix B=(`mean', `sd', `N', `meanT', `sdT', `NT')
	}
	else {
    matrix B= B \ (`mean', `sd', `N', `meanT', `sdT', `NT')
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames B = `variables'
matrix colnames B = Mean SD N

* Display the table
esttab matrix(B) using "$tables/summary_stats_outcomes_TC.tex", nogap label append nomtitles fragment nolines collabels(none)  nonumbers nolines ///
prehead(`" & & & & & & \\"' `" \multicolumn{7}{l}{\textsc{B. Students in Top $15\%$ at baseline}}\\"'   `"\cline{1-1}"' ) ///
postfoot(`"\hline"'  `"\end{tabular}"' `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"\item	\scriptsize \textsc{ Note. --} Sample of students enrolled in control and treated schools. The college entrance exam score is designed to have mean 500 and standard deviation 110 among all exam takers, we report the standardized score. The selectivity of the program is the average entrance exam score among all regular entrants in the selective college and major the student enrolled in. As a measure of distance we use the length (km) of the shortest path between the coordinates of the program and of the high school the student attended, implementing Vincenty formula to calculate distances on a reference ellipsoid.  A student is coded as persisting in the fifth year if he/she enrolled in the first year after high school and stayed continuously enrolled in selective college every year up until and including year $5$, or if he/she enrolled in the first year after high school and graduated from a selective college in a year prior to year $5$. If a student transfers to a different selective college program without taking a break in their studies, they are still considered continuously enrolled in a selective college. "' ///
		 `"\end{tablenotes}"' `"\end{threeparttable}"'  `"\end{table}"')

		 
********************************************************************************
**# Table A8: Average Treatment Effect on Pre-College Study Effort - Items
********************************************************************************
use "$dataClean/data_experimental.dta", clear
rename homework_in_time_st homework

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {regress hours_study_st treatment age female alumno_prioritari simce_avg_st neverfailed modalidad if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)} {regress days_study_test_st treatment age female alumno_prioritari simce_avg_st neverfailed modalidad if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)} {regress homework treatment age female alumno_prioritari simce_avg_st neverfailed modalidad if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)}  // put treatment variable immediately after dependent variable in each regression
local variables hours_study_st days_study_test_st homework
foreach var in  `variables' {
local QV`var'=`e(q_`var'_treatment)'
}

rwolf2  ///
(regress hours_study_st treatment age female alumno_prioritari simce_avg_st neverfailed modalidad if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)) ///
(regress days_study_test_st treatment age female alumno_prioritari simce_avg_st neverfailed modalidad if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)) ///
(regress homework treatment age female alumno_prioritari simce_avg_st neverfailed modalidad if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)),  ///
indepvars(treatment, treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newclusterid) 
local variables hours_study_st days_study_test_st homework
foreach var in  `variables' {
local RW`var'=`e(rw_`var'_treatment)'
}
local k=1
foreach var in  `variables' {
   reg `var' treatment age female alumno_prioritari simce_avg_st neverfailed modalidad if in_experimental_schools == 1 [pweight=weight_mat] , cluster(rbd_basefinal) 
   estadd scalar RW=`RW`var''
   estadd scalar QV=`QV`var''
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 m3 using "$tables/TE_effort_items.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(RW QV, fmt(3 3) labels("R-W adjusted p" "q-val")) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\centering "' ///
	 		`"\caption{\label{tab:effortappendix} \textsc{Average Treatment Effect on Pre-College Study Effort - Items}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{4}{c}}"' `"\hline"' `"\noalign{\vskip 4pt}"' `"\\"' ///
		`"\textit{Panel A: At home} & \shortstack{Study hours/week\\(std.)} & Study days test & Assignm on time &  \\"' 	`"\hline"' `"\\"') 

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {regress std_P4 treatment age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)} {regress std_P5 treatment age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)} {regress std_P7 treatment age female alumno_prioritari simce_avg_st neverfailed modalidad if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)} {regress std_P8 treatment age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)}  // put treatment variable immediately after dependent variable in each regression
local variables std_P4 std_P5  std_P7 std_P8
foreach var in  `variables' {
local QV`var'=`e(q_`var'_treatment)'
}

rwolf2  ///
(regress std_P4 treatment age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)) ///
(regress std_P5 treatment age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)) ///
(regress std_P7 treatment age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal))  ///
(regress std_P8 treatment age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_experimental_schools==1 [pweight=weight_mat], vce(cluster rbd_basefinal)),  ///
indepvars(treatment, treatment, treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)

local variables std_P4 std_P5  std_P7 std_P8
foreach var in  `variables' {
local RW`var'=`e(rw_`var'_treatment)'
}		
local k=1
foreach var in `variables'   {
   reg `var' treatment age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_experimental_schools == 1 [pweight=weight_mat] , cluster(rbd_basefinal) 
   estadd scalar RW=`RW`var''
   estadd scalar QV=`QV`var''
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 m3 m4 using "$tables/TE_effort_items.tex", append ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(RW QV, fmt(3 3) labels("R-W adjusted p" "q-val")) ///
    prehead(`"\\"' `"\hline"' `"\\"' `"\textit{Panel B: In class} & Take notes  & Participate  & Pay attention  &  Ask questions \\"' 	`"\hline"' `"\\"') 

lab var actively_preparing_PSU " "
probit actively_preparing_PSU treatment age female alumno_prioritari simce_avg_st neverfailed modalidad  if in_experimental_schools == 1 [pweight=weight_mat] , cluster(rbd_basefinal) 
margins, dydx(treatment) post
est store m1
esttab m1 using "$tables/TE_effort_items.tex", append ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    prehead(`"\\"' `"\hline"' `"\\"'	`"\textit{Panel C: PSU preparation } & Prepare for PSU  &   &   &   \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--} Dependent variabels in Panel A and B are standardized. The depenent variable in Panel C is binary. Panels A and B report OLS estimates, panel C reports the average marginal effect from a probit model. Standard errors are clustered at the school level (for panel C, the delta method is used). We use the standard set of controls (see Figure \ref{fig:TEovertime}) and Inverse Probability Weights. Fieldworker fixed effects are excluded, as they absorb variation that the cluster-bootstrap procedure needs to compute reliable Romano-Wolf adjusted p-values. {\itshape Treatment} is a dummy variable indicating whether a student is in a school that was randomly assigned to be in the PACE program. The family of survey instruments in Panel A asked students the number of hours of study per week outside of class time, how many days before a test they start preparing, and how often they hand in homework on time. The family of survey instruments in Panel B asked students how often, when in class, they take notes, actively participate, pay attention, and ask questions. We report Romano-Wolf adjusted p-values calculated within family (as per the pre-analysis plan). Q-val indicate q-values of the treatment effect, calculated within family. The dependent variable in Panel C is a dummy indicating whether the student does at least one of the following PSU exam preparation activities: attending a PSU preparation course ({\itshape Preuniversitario}) for a fee, attending a free {\itshape Preuniversitario}, using an online {\itshape Preuniversitario} for a fee, using an online free {\itshape Preuniversitario}, preparing on his/her own. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01.\\" "\end{tablenotes}" "\end{table}") 

   


********************************************************************************
**# Table A9: Effect of PACE on College Entrance Exam
********************************************************************************
use "$dataClean/data_experimental.dta", clear
rename PSU_score_if_positive_st PSU_score_st

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {reg sit_PSU treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)} {reg simce_avg_st treatment female age alumno_prioritario neverfailed modalidad if sit_PSU==1,  cluster(rbd_basefinal)} {reg PSU_score_st treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)}
local q_sit_PSU = round(e(q_sit_PSU_treatment), 0.001)
local q_simce_avg_st = round(e(q_simce_avg_st_treatment), 0.001)
local q_PSU_score_st = round(e(q_PSU_score_st_treatment), 0.001)

rwolf2  ///
(reg sit_PSU treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)) ///
(reg simce_avg_st treatment female age alumno_prioritario neverfailed modalidad if sit_PSU==1,  cluster(rbd_basefinal)) ///
(reg PSU_score_st treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)),  ///
indepvars(treatment, treatment,treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newclusterid)
local rw_sit_PSU = round(e(rw_sit_PSU_treatment), 0.001)
local rw_simce_avg_st = round(e(rw_simce_avg_st_treatment), 0.001)
local rw_PSU_score_st = round(e(rw_PSU_score_st_treatment), 0.001)

reg sit_PSU treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)
su sit_PSU if treatment==0
estadd scalar MEAN=`r(mean)'
estadd scalar RW=`rw_sit_PSU'
estadd scalar QV=`q_sit_PSU'
est store m1
reg simce_avg_st treatment female age alumno_prioritario neverfailed modalidad if sit_PSU==1,  cluster(rbd_basefinal)
su simce_avg_st if treatment==0 & sit_PSU==1
estadd scalar MEAN=`r(mean)'
estadd scalar RW=`rw_simce_avg_st'
estadd scalar QV=`q_simce_avg_st'
est store m2
reg PSU_score_st treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)
su PSU_score_st if treatment==0
estadd scalar MEAN=`r(mean)'
estadd scalar RW=`rw_PSU_score_st'
estadd scalar QV=`q_PSU_score_st'
est store m3
esttab m1 m2 m3 using "$tables/TE_psu.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(RW QV MEAN r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val" "Control mean"  "R-squared" "Observations")) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\centering "' `"\begin{threeparttable}[H]"' ///
	 		`"\caption{\label{tab: TEpsu} \textsc{Effect of PACE on College Entrance Exam}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{3}{c}}"' `"\hline"' ///
		`"&  \multicolumn{1}{c}{Sat exam} & \multicolumn{1}{c}{Baseline ability} & \multicolumn{1}{c}{Exam score}  \\  "' ///
				`"&    & \multicolumn{1}{c}{exam takers} &        \\  "' ///
		`"& (1)  & (2) &  (3)     \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  The coefficients are OLS estimates. Standard errors were clustered at the school level. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. The outcome variable in column (1) is a dummy equal to 1 if the student took the college entrance exam, and 0 otherwise. The outcome variable in column (2) is the test score in $10^{th}$ grade (standardized in the population of $10^{th}$ graders). The outcome variable in column (3) is the standardized college entrance score. Columns (2) and (3) restrict the estimation sample to those who took the entrance exam. \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering the outcomes in the table as one family.  * p$<$0.10; ** p$<$0.05; *** p$<$0.01. " "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 

	
********************************************************************************
**# Tables A10, A11: Effects of PACE on Continuous Enrollment or Graduation Over Time in STEM and non-STEM majors
********************************************************************************
use "$dataClean/data_experimental.dta", clear 
lab var STEM_enrolled_SUA_by_y1 "A. Continuous enrollment in or graduation in STEM major in selective college"
lab var No_STEM_enrolled_SUA_by_y1 "B. Continuous enrollment in or graduation in non-STEM major in selective college"
local var_names STEM_enrolled_SUA_by_y No_STEM_enrolled_SUA_by_y 
foreach var in `var_names' {
	eststo clear

gen tr = treatment

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {regress `var'1 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)} {regress `var'2 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)} {regress `var'3 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)} {regress `var'4 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)} {regress `var'5 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)}
foreach num of numlist 1(1)5 {
		local q_`var'`num' = round(e(q_`var'`num'_tr), 0.001)
}
	rwolf2  ///
(regress `var'1 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)) ///
(regress `var'2 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)) ///
(regress `var'3 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)) ///
(regress `var'4 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)) ///
(regress `var'5 tr simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)) ///
,  indepvars(tr, tr, tr, tr, tr)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)

foreach num of numlist 1(1)5 {
		local rw_`var'`num' = round(e(rw_`var'`num'_tr), 0.001)
}
drop tr

			local lab_var: variable label `var'1
	forvalues t=1(1)5{
	   if regexm("`var'`t'", "No_STEM")==1 {
          local othvar=substr("`var'", 4, .)
	      reg `var'`t' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad 
          estimate store cNoSTEM
	      reg `othvar'`t' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad 
          estimate store cSTEM
          suest cNoSTEM cSTEM, cluster(rbd_basefinal) 
          test [cNoSTEM_mean]treatment -  [cSTEM_mean]treatment = 0
	      local pvald=round(r(p),0.001)
	   }
	   reg `var'`t' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad , cluster(rbd_basefinal) 
	   su `var'`t' if treatment==0
	   estadd scalar MEAN=`r(mean)'
	   estadd scalar RW=`rw_`var'`t''
	   estadd scalar QV=`q_`var'`t''
	   if regexm("`var'`t'", "No_STEM")==1 {
	        estadd scalar pvaldiff=`pvald'
	   }
		est store m`var'`t'
	}
if "`var'"=="STEM_enrolled_SUA_by_y" {
    esttab m`var'* using "$tables/TE_enrolled_over_time_STEM.tex", keep(treatment) replace booktabs b(3) se(3) r2 ///
	       star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N, labels("RW-adj p-val" "q-val" "Control mean" "Observations") fmt(%9.3f %9.3f %9.3f %9s)) label fragment nolines collabels(none) mlabels(none)  nonumbers nolines  ///
		     prehead(`"\begin{table}[H]\centering %htbp"' `"\scriptsize "' `"\centering "' ///
	 		`"\caption{\label{tab: TEenrolledovertimeSTEM} \textsc{Effects of PACE on Continuous Enrollment or Graduation Over Time in STEM and non-STEM majors, All Sample}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{5}{c}}"' `"\hline"' `"\\"' ///
		`"&  Year 1 &  Year 2 & Year 3 & Year 4 & Year 5  \\  "' ///
	`" \multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 
}
else {
if "`var'"=="No_STEM_enrolled_SUA_by_y" {
    esttab m`var'* using "$tables/TE_enrolled_over_time_STEM.tex", keep(treatment) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N pvaldiff, labels("RW-adj p-val" "q-val" "Control mean" "Observations" "p-value difference") fmt(%9.3f %9.3f %9.3f %9s  %9.3f)) label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"  \multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot(`"\hline"'  `"\end{tabular*}"'  `"\begin{tablenotes}\singlespacing"' ///
	     `"\item	\scriptsize \textsc{ Note. --}"' ///
		 "Sample of all students in the experiment. Results from OLS regressions. Treatment is a dummy equal to 1 if a school was randomly assigned to be in the Treatment treatment, to 0 otherwise. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). Standard errors clustered at the school level in parenthesis. The list of STEM majors is reported in Table \ref{tab: listSTEMmajors}. The notes under Figure \ref{fig:TEovertime} explain how the outcome variables are constructed.  \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering the respective outcome variable in all years as one family. \textit{p-value difference} is the p-value of the difference of the STEM and non-STEM treatment effects. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01." 	 `"\end{tablenotes}"' `"\end{table}"')      
}
else{
if regexm("`var'", "No_STEM")!=1  {
    esttab m`var'* using "$tables/TE_enrolled_over_time_STEM.tex", keep(treatment) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N, labels("RW-adj p-val" "q-val" "Control mean" "Observations") fmt(%9.3f  %9.3f %9.3f %9s)) label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"\multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 
}
if regexm("`var'", "No_STEM")==1  {
    esttab m`var'* using "$tables/TE_enrolled_over_time_STEM.tex", keep(treatment) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01)stats(RW QV MEAN N pvaldiff, labels("RW-adj p-val" "q-val" "Control mean" "Observations" "p-value difference") fmt(%9.3f %9.3f %9.3f %9s  %9.3f)) label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"\multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 	
}
}
}
}

local var_names STEM_enrolled_SUA_by_y No_STEM_enrolled_SUA_by_y 
foreach var in `var_names' {
	eststo clear
	
	gen tr = treatment
	
qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {regress `var'1 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)} {regress `var'2 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)} {regress `var'3 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)} {regress `var'4 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)} {regress `var'5 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)}
foreach num of numlist 1(1)5 {
		local q_`var'`num' = round(e(q_`var'`num'_tr), 0.001)
}
	rwolf2  ///
(regress `var'1 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)) ///
(regress `var'2 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)) ///
(regress `var'3 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)) ///
(regress `var'4 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)) ///
(regress `var'5 tr simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)) ///
,  indepvars(tr, tr, tr, tr, tr)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)

foreach num of numlist 1(1)5 {
		local rw_`var'`num' = round(e(rw_`var'`num'_tr), 0.001)
}
drop tr
	
	local lab_var: variable label `var'1
	forvalues t=1(1)5{
	   if regexm("`var'`t'", "No_STEM")==1 {
          local othvar=substr("`var'", 4, .)
	      reg `var'`t' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1
          estimate store cNoSTEM
	      reg `othvar'`t' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1 
          estimate store cSTEM
          suest cNoSTEM cSTEM, cluster(rbd_basefinal) 
          test [cNoSTEM_mean]treatment -  [cSTEM_mean]treatment = 0
	      local pvald=round(r(p),0.001)
	   }
	   reg `var'`t' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, cluster(rbd_basefinal) 
	   su `var'`t' if treatment==0 & top15baseline==1
	   estadd scalar MEAN=`r(mean)'
	   estadd scalar RW=`rw_`var'`t''
	   estadd scalar QV=`q_`var'`t''
	   if regexm("`var'`t'", "No_STEM")==1 {
	        estadd scalar pvaldiff=`pvald'
	   }
		est store m`var'`t'
	}
if "`var'"=="STEM_enrolled_SUA_by_y" {
    esttab m`var'* using "$tables/TE_enrolled_over_time_top15_STEM.tex", keep(treatment) replace booktabs b(3) se(3) r2 ///
	       star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N, labels("RW-adj p-val" "q-val" "Control mean" "Observations") fmt(%9.3f %9.3f %9.3f %9s)) label fragment nolines collabels(none) mlabels(none)  nonumbers nolines  ///
		     prehead(`"\begin{table}[H]\centering %htbp"' `"\scriptsize "' `"\centering "' ///
	 		`"\caption{\label{tab: TEenrolledovertimetop15STEM} \textsc{Effects of PACE on Continuous Enrollment or Graduation Over Time in STEM and non-STEM majors,  Sample of Those in the Top 15\% of Their School at Baseline}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{5}{c}}"' `"\hline"' `"\\"' ///
		`"&  Year 1 &  Year 2 & Year 3 & Year 4 & Year 5  \\  "' ///
	`"\multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 
    
}
else {
if "`var'"=="No_STEM_enrolled_SUA_by_y" {
    esttab m`var'* using "$tables/TE_enrolled_over_time_top15_STEM.tex", keep(treatment) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01) stats(RW QV MEAN N pvaldiff, labels("RW-adj p-val" "q-val" "Control mean" "Observations" "p-value difference") fmt(%9.3f %9.3f %9.3f %9s %9.3f)) label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"  \multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot(`"\hline"'  `"\end{tabular*}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"\item	\scriptsize \textsc{ Note. --}"' ///
		 "Sample of all students in the experiment who were in the top 15\% of their high school GPA ranking at baseline. Results from OLS regressions. Treatment is a dummy equal to 1 if a school was randomly assigned to be in the Treatment treatment, to 0 otherwise. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). Standard errors clustered at the school level in parenthesis. The list of STEM majors is reported in Table \ref{tab: listSTEMmajors}. The notes under Figure \ref{fig:TEovertime} explain how the outcome variables are constructed. \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering the respective outcome variable in all years as one family. \textit{p-value difference} is the p-value of the difference of the STEM and non-STEM treatment effects. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01." 	 `"\end{tablenotes}"' `"\end{table}"')      
}
else  {
if regexm("`var'", "No_STEM")!=1  {
    esttab m`var'* using "$tables/TE_enrolled_over_time_top15_STEM.tex", keep(treatment) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01) stats(RW MEAN N, labels("RW-adj p-val" "Control mean" "Observations") fmt(%9.3f %9.3f %9s)) label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"\multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 
}
if regexm("`var'", "No_STEM")==1  {
    esttab m`var'* using "$tables/TE_enrolled_over_time_top15_STEM.tex", keep(treatment) append booktabs b(3) se(3) r2 ///
		   star(* 0.10 ** 0.05 *** 0.01)  stats(RW MEAN N pvaldiff, labels("RW-adj p-val" "Control mean" "Observations" "p-value difference") fmt(%9.3f %9.3f %9s %9.3f))  label fragment nomtitles nolines collabels(none) mlabels(none)  nonumbers nolines ///
		     prehead(`"\multicolumn{6}{c}{`lab_var'} \\"'	`"\hline"') ///
    postfoot("\\") 
}
}
}
}

 
********************************************************************************
* Table A12: Comparison between selective college programs in which treated and control students enroll
********************************************************************************
* Only selective colleges
use "$dataClean/data_experimental.dta", clear
keep if enrolled_SUA_18==1
lab var all "all"
lab var top15baseline "top 15\%"
global controls simce_avg_st female age alumno_prioritario neverfailed modalidad

rename mean_PSU_score_enrolled mean_PSU_score_en
eststo clear
estimates clear
local k=1
foreach subsample in all top15baseline {
	preserve
	keep if `subsample'==1
    local lab_`subsample': variable label `subsample'
	
qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {reg mean_PSU_score_en treatment $controls if `subsample'==1, cluster(rbd)} {reg distance_enrolled treatment $controls if `subsample'==1, cluster(rbd)}
local q_mean_PSU_score_en= round(e(q_mean_PSU_score_en_treatment), 0.001)
local q_distance_enrolled = round(e(q_distance_enrolled_treatment), 0.001)

	rwolf2  (reg mean_PSU_score_en treatment $controls if `subsample'==1, cluster(rbd)) ///
(reg distance_enrolled treatment $controls if `subsample'==1, cluster(rbd)),  ///
indepvars(treatment, treatment) seed(28052016) reps(1000) cluster(rbd_basefinal) idcluster(newclusterid)
local rw_mean_PSU_score_en= round(e(rw_mean_PSU_score_en_treatment), 0.001)
local rw_distance_enrolled = round(e(rw_distance_enrolled_treatment), 0.001)

    local outcomes mean_PSU_score_en distance_enrolled 
	foreach var of varlist `outcomes'{
	    regress `var' treatment $controls if `subsample'==1, cluster(rbd)
		estimates store m`k'
		su `var'`t' if treatment == 0
		estadd scalar Mean = `r(mean)'
		estadd scalar RW=`rw_`var''
		estadd scalar QV=`q_`var''
		local k=`k'+1
	}
	restore
}
    esttab * using "$tables/RCT_selectivity_distance_only_selective.tex",   f legend label replace booktabs collabels(none) ///
	         cells(b(star fmt(3) vacant({--})) se(par fmt(3))) keep(treatment) nomtitles ///
     stats(RW QV Mean r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val"  "Control mean"  "R-squared" "Observations")) ///
 unstack star(* 0.10 ** 0.05 *** 0.01)  nonumbers nolines ///
prehead(`"\begin{table}[H]\centering "'  ///
        `"\footnotesize"'  ///
            `"\begin{threeparttable}"' ///
			`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
            `"\caption{\textsc{Comparison between selective college programs in which treated and control students enroll}}"' ///
			`"\label{tab: RCTselectivitydistanceselective}"' ///			
            `"\begin{tabular}{l*{4}{c}}"' `"\toprule"' ///
			`"&  \multicolumn{2}{c}{All students} & \multicolumn{2}{c}{Top 15\%} \\  "'   ///
		`"& Selectivity  & Distance &  Selectivity &  Distance     \\"'   ///
		`"& (1)  & (2) &  (3) &  (4)      \\"' 	`"\hline"') ///) ///
postfoot(`"\bottomrule"'  `"\end{tabular}"' `"\begin{tablenotes}\singlespacing"' `"\item"' `"\scriptsize"' `"\textsc{ Note.--}  The coefficients are OLS estimates. Standard errors were clustered at the school level. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. The regressions are estimated on the sample of students from treated and control schools who enrolled in selective college. The outcome variables are the characteristics of the program they enrolled in the first year after high school. Panel A uses data from all students in the school, Panel B from those in the top 15\% of their high school GPA ranking at baseline. As a measure of distance we use the length (km) of the shortest path between the coordinates of the program and the coordinates of the high school the student attended, implementing Vincenty formula to calculate distances on a reference ellipsoid. Selectivity is the average PSU score of all regular entrants in the program in 2018 (standardized). \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering selectivity and distance in each sample as one family. * p$<$0.10; ** p$<$0.05; *** p$<$0.01"' `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"') 


********************************************************************************
**# Table A13: Lee bounds for effects of PACE on selectivity and location of selective college program
********************************************************************************
* Lee bounds, only selective colleges
use "$dataClean/data_experimental.dta", clear
*keep if enrolled_SUA_18==1
foreach subsample in all top15baseline {
	eststo clear
    estimates clear
    preserve
	keep if `subsample'==1
    reg mean_PSU_score_enrolled simce_avg_st female age alumno_prioritario neverfailed modalidad 
    predict mean_PSU_lb, res
    eststo Residuals1: leebounds mean_PSU_lb treatment,  cieffect 
    local obs1=e(N)
    local obssel1=e(Nsel)
    eststo Raw1: leebounds  mean_PSU_score_enrolled treatment,  cieffect 
    esttab, se nostar
    matrix C1 = r(coefs)
    eststo clear
    estimates clear
    cap drop mean_PSU_lb
    eststo clear
    estimates clear
    mat C=C1'

    eststo clear 
    estimates clear
    reg distance_enrolled simce_avg_st female age alumno_prioritario neverfailed modalidad 
    predict distance_lb, res
    eststo Residuals2: leebounds distance_lb treatment,  cieffect 
    local obs2=e(N)
    local obssel2=e(Nsel)
    eststo Raw2: leebounds distance_enrolled treatment,  cieffect 
    esttab, se nostar
    matrix C2 = r(coefs)
    eststo clear
    estimates clear
    cap drop distance_lb
    mat C=C1',C2'
    forvalues i=1(1)4{
        matrix b=C[1, `i'],C[3,`i']
        matrix se=C[2,`i'],C[4,`i']
        ereturn post b
        quietly estadd matrix se
	    if (`i'==1 | `i'==2)  {
            estadd scalar N=`obs1'
            estadd scalar Nsel=`obssel1'
	    }
	    if (`i'==3 | `i'==4) {
            estadd scalar N=`obs2'
            estadd scalar Nsel=`obssel2'		
	    }
        eststo m`i'
    }
    if "`subsample'"=="all"{
        esttab m1 m2 m3 m4   using "$tables/leebounds_selectivity_distance_only_selective.tex",   ///
        f legend label replace booktabs collabels(none) ///
        unstack nostar  mgroups("Selectivity" "Distance" , pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
		mtitles("Lower bound" "Upper bound" "Lower bound" "Upper bound")  nonumbers nolines varlabels(c1 "Residuals" c2 "Raw") ///
        stats(N Nsel, fmt(0 0)  labels( `"Total obs."' `"Selected obs."')) cells(b(fmt(3) vacant({--})) se(par fmt(3))) ///
        prehead(`"\begin{table}[H]\centering"'  ///
        `"\footnotesize"'  ///
        `"\begin{threeparttable}"' ///
		`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
        `"\caption{\textsc{Lee bounds for effects of PACE on selectivity and location of selective college program}}"' ///
		`"\label{tab: leeboundsselectivitydistanceonlyselective}"' ///			
        `"\begin{tabular}{l*{4}{c}}"' `"\toprule"' `"& \multicolumn{4}{c}{\textsc{A. All students}} \\"' )
	}
    if "`subsample'"=="top15baseline"{
        esttab m1 m2 m3 m4    using "$tables/leebounds_selectivity_distance_only_selective.tex",   ///
        f legend label append booktabs collabels(none) ///
        unstack nostar mgroups("Selectivity" "Distance" , pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
		mtitles("Lower bound" "Upper bound" "Lower bound" "Upper bound")  nonumbers nolines varlabels(c1 "Residuals" c2 "Raw") ///
        stats(N Nsel, fmt(0 0)  labels( `"Total obs."' `"Selected obs."')) cells(b(fmt(3) vacant({--})) se(par fmt(3))) ///
        prehead(`"& \multicolumn{4}{c}{\textsc{B. Top 15\%}} \\"' ) ///
        postfoot(`"\bottomrule"'  `"\end{tabular}"' `"\begin{tablenotes}\singlespacing"' `"\item"' `"\scriptsize"' `"\textsc{ Note.--} This table presents Lee (2009) bounds for the effects of PACE on the selectivity and location of the selective college programs in which students enroll. Numbers in parenthesis are the analytic standard errors provided by Lee (2009). As a measure of distance we use the length (km) of the shortest path between the coordinates of the program and the coordinates of the high school the student attended, implementing Vincenty formula to calculate distances on a reference ellipsoid. Selectivity is the average PSU score of all regular entrants in the program in 2018 (standardized). In the first and second rows we use residuals from a regression of the outcomes on the standard set of controls (see notes under Figure \ref{fig:TEovertime}) as the dependent variables. In the third and fourth rows we use the raw outcome variables. \textit{Total obs.} is the number of observations before the trimming procedure. \textit{Selected obs.} is the number of observations after the trimming procedure and in the regression samples used for residualizing the outcomes."' `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"') 
	}
    restore
}	


*******************************************************************************
**# Table A14: Change in Selection of College Entrants
*******************************************************************************
est clear
use "$dataClean/data_experimental.dta", clear

label var simce_avg_st "SIMCE test score (grade 10)"

  reg simce_avg_st treatment     if enrolled_SUA_18 == 1 & top15baseline ==1 , cluster(rbd_basefinal )
  su simce_avg_st if e(sample)==1 & treatment==0
estadd scalar MEAN=`r(mean)'
est store m1 
reg simce_avg_st treatment  age alumno_prioritario modalidad female neverfailed   if enrolled_SUA_18 == 1 & top15baseline ==1 , cluster(rbd_basefinal )
 su simce_avg_st if e(sample)==1 & treatment==0
 estadd scalar MEAN=`r(mean)'
est store m2 

esttab m1 m2 using "$tables/TE_college_entrants.tex", replace ///
 booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(MEAN r2 N, fmt(3 3 0) labels("Control mean" "R-squared" "Observations" )) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\begin{threeparttable}  "' ///
	`"\setlength\tabcolsep{0pt} "' 	`"\setlength\extrarowheight{2pt}"' 	`"\caption{\label{tabcollegeentrants} \textsc{Change in Selection of College Entrants}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\hline"' ///
		`"&  \multicolumn{1}{c}{SIMCE} & \multicolumn{1}{c}{SIMCE}  \\  "' ///
		`"& (1)             & (2)   \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--} This Table is based on the sample of students who, at the experiment's baseline, were in the top 15\% of their school based on the GPA in grades 9 and 10. The sample is further restricted to college entrants. The coefficients are OLS estimates. Standard errors were clustered at the school level. The standard set of controls (see notes under Figure \ref{fig:TEovertime}) is used in column (2). {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. The outcome variable is the SIMCE test score in grade 10. * p$<$0.10; ** p$<$0.05; *** p$<$0.01" "\end{tablenotes}" `"\end{threeparttable}  "' "\end{table}") 
 

 *******************************************************************************
**# Table A15: Pre-college Outcomes and Persistence in Selective Colleges
*******************************************************************************
use "$dataClean/data_experimental.dta", clear

* Label variables 
gen STEM=1 if STEM_enrolled_SUA_by_y1==1
replace STEM=0 if No_STEM_enrolled_SUA_by_y1==1

* Generate interactions to include in table for R1
gen GPA_cuartoXSTEM=STEM*GPA_cuarto_medio_st
label var GPA_cuartoXSTEM "GPA in $12^{th}$ grade (std) $\times$ STEM"
label var GPA_cuarto_medio_st "GPA in $12^{th}$ grade (std)"

gen std_GPA_coreXSTEM=STEM*std_GPA_core
label var std_GPA_coreXSTEM "GPA in $12^{th}$ grade tested subjects (std) $\times$ STEM"
label var std_GPA_core "GPA in $12^{th}$ grade tested subjects (std)"

gen std_GPA_specificXSTEM=STEM*std_GPA_specific
label var std_GPA_specificXSTEM "GPA in $12^{th}$ grade untested subjects (std) $\times$ STEM"
label var std_GPA_specific "GPA in $12^{th}$ grade untested subjects (std)"

gen PSU_score_if_positive_stXSTEM=STEM*PSU_score_if_positive_st
label var PSU_score_if_positive_stXSTEM "PSU score (std) $\times$ STEM"
label var PSU_score_if_positive_st "PSU score (std)"

gen st_effortXSTEM=STEM*st_effort_latent2
label var st_effortXSTEM "Study effort in last high school year (std) $\times$ STEM"
label var st_effort_latent2 "Study effort in last high school year (std)"

gen hours_studyXSTEM=STEM*hours_study 
label var hours_studyXSTEM "Hours of study per week in last high school year $\times$ STEM"
label var hours_study "Hours of study per week in last high school year"

gen simce_avg_stXSTEM=STEM*simce_avg_st  
label var simce_avg_stXSTEM "Baseline test score in $10^{th}$ grade (std) $\times$ STEM"
label var simce_avg_st  "Baseline test score in $10^{th}$ grade (std)"

egen std_GPA_avg_1_2=std(GPA_avg_1_2)
gen std_GPA_avg_1_2XSTEM=STEM*std_GPA_avg_1_2   
label var std_GPA_avg_1_2XSTEM "Baseline GPA in $9^{th}$ and $10^{th}$ grade (std) $\times$ STEM"
label var std_GPA_avg_1_2 "Baseline GPA in $9^{th}$ and $10^{th}$ grade (std)"

* Enrolled in any field 
est clear
reg enrolled_SUA_by_y5 GPA_cuarto_medio_st PSU_score_if_positive_st simce_avg_st   modalidad age female alumno_prioritario neverfailed if enrolled_SUA_by_y1==1, cluster(rbd_basefinal)
est store m1
reg enrolled_SUA_by_y5 std_GPA_core std_GPA_specific PSU_score_if_positive_st simce_avg_st  modalidad age female alumno_prioritario neverfailed if enrolled_SUA_by_y1==1, cluster(rbd_basefinal)
est store m2
reg enrolled_SUA_by_y5 st_effort_latent2 simce_avg_st  modalidad age female alumno_prioritario neverfailed if enrolled_SUA_by_y1==1 [pweight=weight_mat], cluster(rbd_basefinal)
est store m3
reg enrolled_SUA_by_y5 hours_study simce_avg_st  modalidad age female alumno_prioritario neverfailed if enrolled_SUA_by_y1==1 [pweight=weight_mat], cluster(rbd_basefinal)
est store m4
esttab m1 m2 m3 m4  using "$tables/persistence_SUA.tex", replace nonumbers label booktabs b(3) se(3) r2 star(* 0.10 ** 0.05  *** 0.01)  nodepvars nomtitles keep(GPA_cuarto_medio_st std_GPA_core std_GPA_specific  PSU_score_if_positive_st  st_effort_latent2 hours_study simce_avg_st) order(GPA_cuarto_medio_st std_GPA_core std_GPA_specific  PSU_score_if_positive_st  st_effort_latent2 hours_study simce_avg_st) ///
prehead(`"\begin{table}[H]\centering"' ///
        `"\footnotesize"'  ///
            `"\caption{\label{tab:persistenceSUA} \textsc{Pre-college Outcomes and Persistence in Selective Colleges}}"' ///
              `"\renewcommand{\arraystretch}{1}"'  ///
			`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{4}{c}} \hline"' ///
			 `"&\multicolumn{4}{c}{ College persistence or graduation} \\"' `"&  \multicolumn{4}{c}{five years after high school graduation} \\"'  `" & (1)  & (2) & (3) & (4) \\ "') ///
postfoot(`"\hline"'  `"\end{tabular*}"' `"\scriptsize"' `"\begin{threeparttable}"' `"\begin{tablenotes}[para,flushleft]\singlespacing"'  ///
	     `" \textsc{ Note. --}  Sample of students who enrolled in a selective college in the first year. The outcome variable is a dummy equal to one if five years later they are either still continuously enrolled or they have graduated, and zero otherwise. Results from OLS regressions. Inverse Probability Weights are used in columns (3) and (4). All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). The PSU score is standardized in the population of exam takers. Standard errors in parentheses, clustered at school level. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01.\\"' ///
		 `"\end{tablenotes}"'  `"\end{threeparttable}"' `"\end{table}"') 
		 

********************************************************************************
**# Table A16: Belief elicitation
********************************************************************************
* Only text


********************************************************************************
**# Table A17: Socioeconomic correlates of belief biases
********************************************************************************
use "$dataClean/data_experimental.dta", clear
gen bias_cutoff= -1 * bias_top15
label var bias_cutoff "Actual - expected 85th percentule rank GPA (in grades)"
drop PSU_st exp_PSU_st PSU_st_bias
gen PSU_st=(PSU_score_if_positive -500)/110
		label var PSU_st "PSU entry score, standardized nationally"
		gen exp_PSU_st=( exp_PSUscore -500)/110
		label var exp_PSU_st "Believed PSU entry score, standardized nationally"
		gen PSU_st_bias=exp_PSU_st-PSU_st
        label var PSU_st_bias "Believed minus actual PSU score (both standardized nationally)"
		
		gen log_hhincome=log(hh_income)
		label var log_hhincome "Household log-income"
		label var alumno_prioritario "Very low SES"
		label var meduc "Mother education (years)"
		label var peduc "Father education (years)"
reg bias_cutoff alumno_prioritario log_hhincome meduc peduc [weight=weight_mat], cluster(rbd_basefinal) 
eststo rank_belief
reg PSU_st alumno_prioritario log_hhincome meduc peduc [weight=weight_mat], cluster(rbd_basefinal)
eststo psu_belief
esttab rank_belief psu_belief using "$tables/correlates_belief_biases.tex", nomtitles collabel(none) nonumbers ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label replace nocons nolines ///
prehead(`"\begin{table}[H] "' `"\footnotesize "' `"\begin{threeparttable} "' ///
	 		`"\caption{\label{tab:correlatesbelieferrors} \textsc{Socioeconomic correlates of belief biases}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\hline"' ///
		`"& Rank belief bias  & PSU belief bias \\  "'  `"& (1)  & (2)  \\ "' ) ///
postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\item		\scriptsize \textsc{ Note.--}  Estimates stem from ordinary least square regressions. Very low SES is a dummy variable identifying students the government classified as particularly vulnerable based on socioeconomic status. Rank belief bias is the difference between actual and expected $85^{th}$ GPA percentile in the school, it is measured in GPA points (GPA ranges from 1 to 7). Positive values indicate overoptimism. PSU belief bias is the difference between expected and actual PSU entrance exam score, it is measured in standard deviations. Positive values indicate overoptimism. Standard errors in parenthesis clustered at the school level. Inverse Probability Weights used. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. " "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 
    
	
********************************************************************************
**# Table A18: Effect of PACE on perceived graduation likelihood
********************************************************************************
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
		
est clear 
reg p_graduate treatment     , cluster(rbd_basefinal)
estadd local Controls "No"
estadd local FE "No"
estadd local IPW "No"
su p_graduate if e(sample) == 1 & treatment == 0 
estadd scalar Mean = `r(mean)'
eststo m1
reg p_graduate treatment    [pweight=weight_mat] , cluster(rbd_basefinal) 
estadd local Controls "No"
estadd local FE "No"
estadd local IPW "Yes"
su p_graduate if e(sample) == 1 & treatment == 0 
estadd scalar Mean = `r(mean)'
eststo m2
reg p_graduate treatment $controls i.id_fieldworker   [pweight=weight_mat] , cluster(rbd_basefinal) 
estadd local Controls "Yes"
estadd local FE "Yes"
estadd local IPW "Yes"
su p_graduate if e(sample) == 1 & treatment == 0 
estadd scalar Mean = `r(mean)'
eststo m3

* esttab command 
esttab m1 m2 m3 using "$tables/p_graduate_reg_whole_sample.tex", replace label booktabs ///
    b(3) se(3) r2 star(* 0.10 ** 0.05 *** 0.01) keep(treatment ) ///
    mtitles("(1)" "(2)" "(3)") nonum collabels(none) ///
    prehead(`"\begin{table}[H]\centering"' `"\footnotesize"' `"\begin{threeparttable}"' ///
            `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{\textsc{Effect of PACE on perceived graduation likelihood}}"' ///
            `"\label{tab:pgradreg}"' `"\begin{tabular}{l*{3}{c}}"' `"\toprule"') ///
    stats(Mean N Controls FE IPW, labels("Outcome mean in the control group" "Observations" "Controls" "Fieldworker fixed effects" "Inverse Probability Weights") fmt(%9.3f %9s %9s %9s)) ///
    postfoot(`"\bottomrule"' `"\end{tabular}"' `"\begin{tablenotes}"' `"\singlespacing"' `"\item"' ///
             `"\setlength{\baselineskip}{0.8\baselineskip}"' `"\scriptsize"' ///
             `"\textsc{ Note.--} The coefficients are OLS estimates. Controls are the standard set. Standard errors are clustered at the school level. The outcome variable is the student's perceived chance of graduating from selective college if they enroll. Perceived chances were elicited on a 5-point Likert scale and were assigned values of 0, 0.25, 0.50, 0.75 and 1 to construct this table. *** p$<$0.01, ** p$<$0.05, * p$<$0.10."' ///
             `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"')
		
		
*****************************************************
**# Table A19: Perceived Marginal Returns to Effort
*****************************************************
use "$dataTemp/basefinal_merged_all_clean.dta", clear
keep if in_experimental_schools==1
est clear 
local variables returns_effort_top15_55_original returns_effort_top15_55 GPAb_coeff_eff  returns_eff_PSUb_1_original returns_eff_PSUb_1 PSUb_coeff_eff_1   returns_eff_PSUb_2_original returns_eff_PSUb_2  PSUb_coeff_eff_2
cap matrix A

lab var returns_effort_top15_55_original "GPA, all survey answers"
lab var returns_effort_top15_55 "GPA, excluding negative values"
lab var GPAb_coeff_eff "GPA, imputed when survey answer missing"
lab var returns_eff_PSUb_1_original "PSU below kink, all survey answers"
lab var returns_eff_PSUb_1 "PSU below kink, excluding negative values"
lab var PSUb_coeff_eff_1 "PSU below kink, imputed when survey answer missing"
lab var returns_eff_PSUb_2_original "PSU above kink, all survey answers"
lab var returns_eff_PSUb_2 "PSU above kink, excluding negative values"
lab var PSUb_coeff_eff_2 "PSU above kink, imputed when survey answer missing" 

* Loop over each variable and add its statistics to the matrix
local k=1
foreach var in `variables' {
    quietly summarize `var', detail
    local mean: display %9.3g round(r(mean), 0.001)
    local sd: display %9.3g round(r(sd),0.001)
	local min: display %9.3g round(r(min),0.001)
	local max: display %9.3g round(r(max),0.001)
    local N: display %9.0g r(N)
	if `k'==1 {
    matrix A = (`mean', `min', `max', `N')
	}
	else {
    matrix A = A \ (`mean', `min', `max', `N')
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames A = `variables'
matrix colnames A = Mean Min Max N

* Display the table
esttab matrix(A) using "$tables/summary_perceived_returns_construction.tex", nogap label replace  fragment nomtitles nolines collabels(none)  nonumbers nolines ///
prehead(`"\begin{table}[H]\centering"' `"\begin{threeparttable}"' ///
	`"\footnotesize"' 	`"%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
	`"\caption{\label{tab:summaryperceivereturns} \textsc{Perceived Marginal Returns to Effort}}"' ///
	`"\begin{tabular}{l*{1}{cccc}}"' `"	\hline"'  `" Perceived marginal return to effort in:	&        Mean&          Min & Max    & N\\"' `"	& (1)        & (2)   & (3)  & (4)\\ "' ///
	`"	\hline"' ) ///
postfoot(`"\hline"'  `"\end{tabular}"' `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"\item	\scriptsize \textsc{ Note. --}"' ///
		  `"This table presents descriptive statistics for the perceived returns to effort, constructed using the transformations in equations \eqref{eq:PSUbreturns} and \eqref{eq:GPAbreturns}. Variables labeled  as including all survey answers apply these transformations directly to the raw survey responses. The number of observations for GPA is lower because we exclude cases where the perceived top 15\% cutoff equals the hypothetical value of 5.5—this would lead to division by zero in equation \eqref{eq:GPAbreturns}. Variables labeled  as excluding negative values further omit observations where the calculated returns are negative. Imputations are performed only after removing survey responses that yield negative returns. Details on the imputation process for missing values are provided in Appendix \ref{ref:imputation}. In model estimation, we use perceived returns with imputed values where survey responses are missing.   \\ "' ///
		 `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"') 
		 
		 * Editor's question: are these negative values small?
		 local variables returns_effort_top15_55_original returns_effort_top15_55 GPAb_coeff_eff  returns_eff_PSUb_1_original returns_eff_PSUb_1 PSUb_coeff_eff_1   returns_eff_PSUb_2_original returns_eff_PSUb_2  PSUb_coeff_eff_2
		 foreach var in `variables' {
     summarize `var' if `var'<0
		 }
		 

		 
********************************************************************************
**# Table A20-21: Parameters estimated outside of the model
********************************************************************************
use "$dataClean/data_experimental.dta", clear
keep if in_experimental_schools==1
merge 1:1 mrun using "$dataTemp/admitted_SUA_pace.dta" , keepusing(quality_adm_uni_major_PACE )
drop if _merge==2 // these are students who were admitted through PACE in 2018 but are not in our experimental sample
drop _merge

merge 1:1 mrun using "$dataTemp/regular_applications_uni_quality.dta" , keepusing( quality_adm_uni_major)  // The do file that generate the selectivity variables is: "generate_applic_adm_uni_selectivity.do"

** standardize the measures of selectivity so that they are measured in terms of standard deviations of the PSU in the test-taking population 
** This rescaleing avoids the issue of exp(.)=Inf in the Julia code
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

preserve
keep if sit_PSU==1 
* Estimating same regression twice (for printing table and for saving parameters) as workaround to table labelling issue. Make sure you use the same specification both times.
* 1. Estimate regression for Table and print table
est clear
probit admitted_SUA_regular PSU_score_if_positive_st c.PSU_score_if_positive_st#c.PSU_score_if_positive_st c.PSU_score_if_positive_st#c.PSU_score_if_positive_st#c.PSU_score_if_positive_st , cluster(rbd_basefinal)
est store m3
esttab  m3 using "$tables/params_outside_model_regularadm.tex", replace ///  Problem: it prints the label of the outcome variable in first column
    booktabs label ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)   ///
     collabels(none) mlabels(none)  nonumbers nodepvars  ///
    stats(r2_p N, fmt(3 0) labels("Pseudo R-squared" "Observations" )) ///
    prehead(`"\begin{table}[H]\centering "' `"\setlength\extrarowheight{-3pt}"' `"\footnotesize "' `"\begin{threeparttable}"' ///
		 `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{\label{tab:outsidev2admreg} \textsc{Parameters estimated outside of the model, regular admission likelihood}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{1}{c}}"' `"\hline"' ///
		`"&   \multicolumn{1}{c}{Likelihood of Regular Admission }  \\  "' ///
		`"& (1)                                \\"' 	 ) ///
    postfoot("\hline" "\end{tabular*}" 	"\begin{tablenotes}" `"\singlespacing"' "\item" ///
             `"\setlength{\baselineskip}{0.8\baselineskip}"' `"\scriptsize"'  `"\noindent"' ///
             `"\textsc{ Note.--} The Table reports estimates from a Probit regression model. Standard errors were clustered at the school level. The estimation sample includes all entrance-exam takers in our study sample. * p$<$0.10; ** p$<$0.05; *** p$<$0.01"' "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 
	
est clear
reg quality_adm_uni_major_PACE GPA_all_years c.GPA_all_years#c.GPA_all_years simce_avg_st c.simce_avg_st#c.simce_avg_st i.modalidad#c.simce_avg_st  i.modalidad   i.cod_reg_rbd_pred  , cluster(rbd_basefinal)
est store m1
reg quality_adm_uni_major PSU_score_if_positive_st c.PSU_score_if_positive_st#c.PSU_score_if_positive_st simce_avg_st c.simce_avg_st#c.simce_avg_st i.modalidad#c.simce_avg_st i.modalidad   i.cod_reg_rbd_pred   , cluster(rbd_basefinal)
est store m2
esttab m1 m2 using "$tables/params_outside_model_rescale.tex", replace ///
    booktabs label  ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) /// *drop(*.cod_reg_rbd_pred) 
     collabels(none) mlabels(none)  nonumbers nobase /// *nolines nomtitles nodep noomitted ///
    stats(r2  N, fmt(3  0) labels("R-squared" "Observations" )) ///
    prehead(`"\begin{table}[H]\centering"'  `"\setlength\extrarowheight{-3pt}"'  `"\footnotesize "'  ///
	`"\begin{threeparttable}"' ///
	 `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{\label{tab:outsidev2sel} \textsc{Parameters estimated outside of the model, program selectivity}}"' ///
     `"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\hline"' `"\\"' ///
		`"&  \multicolumn{1}{c}{Selectivity PACE} & \multicolumn{1}{c}{Selectivity Regular}   \\  "' ///
		`"& (1)                                   &           (2)                             \\"' ) ///
    postfoot("\hline" "\end{tabular*}" `"\begin{tablenotes}"' `"\singlespacing"' `"\item"' ///
             `"\setlength{\baselineskip}{0.8\baselineskip}"' `"\scriptsize"' `"\noindent"' ///
             `"\textsc{ Note.--} The Table reports OLS estimates. Standard errors were clustered at the school level. Selectivity is measured as the average PSU score among all regular entrants into the degree program, defined as a selective college and major pair. The reference categories are the vocational track and the third region. The region refers to the location of the high school. The ninth and nearby tenth regions are lumped together, since only 1.32\% of the sample went to school in the ninth region, and none of these students was admitted to college through PACE. The samples are: all those admitted through the PACE channel in column (1), all those admitted through the regular channel in column (2). * p$<$0.10; ** p$<$0.05; *** p$<$0.01"' "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 			 

restore 

********************************************************************************
**# Table A27: Analysis of school transitions
********************************************************************************			 
use "$dataClean/data_movers.dta", clear 
xtset mrun year

*excluding non-random early pace
gen early_PACE = 0
replace early_PACE = 1 if (pace_year < 2016)
replace early_PACE = 1 if (pace_year == 2016  & treatment ==.)
replace early_PACE =. if year == 2015
replace early_PACE = F.early_PACE if year == 2015

* treatment2016: actually treated in 2016
gen treatment2016 = 1 if pace_year == 2016 & year == 2016
replace treatment2016 = 0 if (pace_year == 9998 | pace_year == 2018) & year == 2016
replace treatment2016 = . if early_PACE & year == 2016
replace treatment2016 = F.treatment2016 if  year == 2015

* treatment2015: Being in a school in 2015, that introduced pace in 2016
* being in a school in 2015: In which year did or will this schoolm introduce PACE 
gen treatment2015 = 1 if pace_year == 2016 & year == 2015
replace treatment2015 = 0 if (pace_year == 9998 | pace_year == 2018) & year == 2015
replace treatment2015 = . if early_PACE & year == 2016

gen inflow_PACE2016 = 1 if treatment2015 == 0 & treatment2016 == 1
replace inflow_PACE2016 = 0 if treatment2015 == 1 & treatment2016 == 1
gen outflow_PACE2016 = 1 if treatment2015 == 1 & treatment2016 == 0
replace outflow_PACE2016 = 0 if treatment2015 == 1 & treatment2016 == 1
tab outflow_PACE2016
gen mover = 1 if rbd != F.rbd & year == 2015
replace mover = 0 if rbd == F.rbd & year == 2015

foreach var of varlist ptje_lect2m_alu ptje_mate2m_alu ptje_soc2m_alu {
egen st_`var' = std(`var')
}
gen simce_avg=(ptje_lect2m_alu + ptje_mate2m_alu)/2
egen st_simce = std(simce_avg)
label var st_simce "SIMCE score in $10^{th}$ grade (std)"

reg inflow_PACE2016 st_simce if  year == 2015  , cluster(rbd)
eststo m1
reg outflow_PACE2016 st_simce if  year == 2015  , cluster(rbd)
eststo m2
esttab m1 m2 using "$tables/in_out_flow.tex", nomtitles collabel(none) nonumbers  ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label replace nolines  stats(N, labels("Observations") fmt(%9.0f))  ///
prehead(`"\begin{table}[H] "' `"\centering "' `"\begin{threeparttable} "' ///
			`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
	 		`"\caption{\label{inoutflow} \textsc{Analysis of school transitions }}"' ///
	`"\begin{tabular}{l cc}"' `"\toprule"' ///
		`"	&\multicolumn{1}{c}{In-flow into } &\multicolumn{1}{c}{Out-flow from} \\"' ///
				`"	&\multicolumn{1}{c}{ treated schools} &\multicolumn{1}{c}{ treated schools} \\	"'  ) posthead(`"\midrule"') ///
postfoot("\bottomrule" "\end{tabular}" "	\begin{tablenotes}[flushleft]\singlespacing" "\item		\scriptsize \textsc{ Note.--}  Probability to transition into or out of a school which was randomly assigned to be treated in 2016, in the experimental cohort under study. Coefficients are OLS estimates. Standard errors (clustered at school level) are displayed in parentheses. In column (1) the sample consists of all students who were enrolled in a treated school in 2016, the dependent variable is a dummy equal to one if, in 2015, the student was not enrolled in a school that was randomized to be treated in 2016. In column (2) the sample consists of all students who, in 2015, were enrolled in a school which was randomized to be treated in 2016. The dependent variable is a dummy equal to one if the student was not enrolled in a treated school in 2016. Both samples exclude students who in 2015 or in 2016 were enrolled in schools which participated in the PACE program but not as part of the randomized experiment. * p $<$ 0.1, ** p $<$ 0.05, *** p $<$ 0.01. " "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 
    

********************************************************************************
**# Table A28: Participation in the survey
********************************************************************************
use "$dataClean/data_experimental.dta", clear
keep if in_experimental_schools==1

* a) Is there any sample attrition for the longitudinal sample of 9,006 students? And what about the sub-set of PACE-targeted students (top 15 %)?

* Text shown in Appendix C
* Response rate
tab in_sample if treatment == 0
* Share is 
dis (4231 - 1295) / 4231

* Table \ref{attritionboth1}
reg in_sample treatment, vce(cluster rbd_basefinal)
est store m1
reg in_sample treatment if top15baseline==1, vce(cluster rbd_basefinal)
est store m2

esttab m1 m2 using "$tables/attrition_both.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(N r2, fmt(0 3) labels("Observations" "R-squared")) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\begin{threeparttable}"' ///
	        `"\caption{\textsc{Participation in the survey}}"' ///
			`"\label{attritionboth1}"' ///		
	`"\begin{tabular*}{0.6\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\hline"' ///
		`"&  \multicolumn{2}{c}{Participated in the survey}"' \\ ///
		`"&  \multicolumn{1}{c}{Full sample} & \multicolumn{1}{c}{Top $15\%$ Sample}  \\  "' ///
		`"& (1)  & (2)     \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft] \singlespacing"       `"\item	\footnotesize \textsc{ Note. --}  Column (1) uses the sample of all students in the experiment. Column (2) uses the sample of all students who at the end of $10^{th}$ grade, before the experiment started, were in the top $15\%$ of their school according to GPA in the first two high school years. The share of students in the top $15\%$ at baseline is not exactly $15\%$ because there are students with the same GPA average at baseline and missings in the dependent variable. Results from OLS regressions. Treatment is a dummy equal to 1 if a school was randomly assigned to be in the PACE treatment, to 0 otherwise. Standard errors clustered at the school level in parenthesis. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01."'		 `"\end{tablenotes}"' `"\end{threeparttable}"'  `"\end{table}"') 
	
	
********************************************************************************
* Table A29: Lee bounds for effects of PACE on achievement and effort
********************************************************************************
use "$dataClean/data_experimental.dta", clear
eststo clear
estimates clear
reg score_all_st simce_avg_st 
predict score_res_lb, res
reg st_effort_latent2 simce_avg_st  
predict st_effort_latent2_res_lb, res
qui: reg  applied_SUA_regular_or_pace treatment  age female alumno_prioritari simce_avg_st neverfailed modalidad i.id_fieldworker , cluster(rbd_basefinal)
eststo Residuals1: leebounds score_res_lb treatment if in_experimental_schools == 1  & e(sample) == 1,  cieffect 
local obs1=e(N)
local obssel1=e(Nsel)
eststo Raw1: leebounds score_all_st treatment if in_experimental_schools == 1  & e(sample) == 1,  cieffect 
esttab, se nostar
matrix C1 = r(coefs)
eststo clear
estimates clear
eststo Residuals2: leebounds st_effort_latent2_res_lb treatment if in_experimental_schools == 1  & e(sample) == 1,  cieffect 
local obs2=e(N)
local obssel2=e(Nsel)
eststo Raw2: leebounds st_effort_latent2 treatment if in_experimental_schools == 1  & e(sample) == 1,  cieffect 
esttab, se nostar
matrix C2 = r(coefs)
mat C=C1',C2'

forvalues i=1(1)4{
    matrix b=C[1, `i'],C[3,`i']
    matrix se=C[2,`i'],C[4,`i']
    ereturn post b
    quietly estadd matrix se
	if `i'<3 {
    estadd scalar N=`obs1'
    estadd scalar Nsel=`obssel1'
	}
	else {
    estadd scalar N=`obs2'
    estadd scalar Nsel=`obssel2'		
	}
    eststo m`i'
}
esttab m1 m2 m3 m4 using "$tables/leebounds_effort_achievement.tex",   ///
		  f legend label replace booktabs collabels(none) ///
unstack nostar mgroups("Standardized achievement score" "Standardized study effort", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) mtitles("Lower bound" "Upper bound" "Lower bound" "Upper bound")  nonumbers nolines varlabels(c1 "Residuals" c2 "Raw") ///
stats(N Nsel, fmt(0 0)  labels( `"Total obs."' `"Selected obs."')) cells(b(fmt(3) vacant({--})) se(par fmt(3))) ///
prehead(`"\begin{table}[H]\centering"'  ///
        `"\scriptsize"'  ///
            `"\begin{threeparttable}"' ///
			`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
            `"\caption{\textsc{Lee bounds for effects of PACE on achievement and effort}}"' ///
			`"\label{tab: tableebounds}"' ///			
            `"\begin{tabular}{l*{4}{c}}"' `"\toprule"') ///
postfoot(`"\bottomrule"'  `"\end{tabular}"' `"\begin{tablenotes}\singlespacing"' `"\item"' `"\footnotesize"' `"\textsc{ Note.--} This table presents Lee (2009) bounds for the effects of PACE on pre-college achievement and effort. Numbers in parenthesis are the analytic standard errors provided by Lee (2009). In the first and second rows we use residuals from a regression of the outcomes on baseline test scores as the dependent variable. In the third and fourth rows we use the raw outcome variables. In all rows we scale the outcomes as in Table \ref{tabreducedform}, to keep our analysis of bounds analogous to the main average treatment effects. \textit{Total obs.} is the number of observations before the trimming procedure. \textit{Selected obs.} is the number of observations after the trimming procedure and in the regression samples used for residualizing the outcomes."' `"\end{tablenotes}"' `"\end{threeparttable}"' `"\end{table}"') 


********************************************************************************
**# Table A30: Validating Achievement and Effort Measures
********************************************************************************
use "$dataClean/data_experimental.dta", clear

lab var score_all_st "Achievement"
* Panel A
local k=1
foreach var in sit_PSU applied_SUA_regular admitted_SUA_regular enrolled_SUA_by_y1 enrolled_SUA_by_y2 enrolled_SUA_by_y3 enrolled_SUA_by_y4 enrolled_SUA_by_y5 {
   probit `var' score_all_st  simce_avg_st i.modalidad age alumno_prioritario neverfailed female  [pweight=weight_mat] if treatment==0 , cluster(rbd_basefinal)
   local pR2=`e(r2_p)'
   margins, dydx(score_all_st) post
   sum `var' if score_all_st !=. & simce_avg_st!=. & modalidad!=. & age!=. & alumno_prioritario!=. & neverfailed!=. & female!=. & treatment==0 [weight=weight_mat]
   estadd scalar control_mean=`r(mean)'
   estadd scalar pseudoR2=`pR2'
   estadd local psuscore "No"
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 m3 m4 m5 m6 m7 m8 using "$tables/validate_achievement_effort.tex", replace ///
    booktabs label unstack noobs keep(score_all_st) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
 stats(psuscore control_mean pseudoR2 N, fmt(0 3 3 0) labels("PSU score"  "Control mean" "Pseudo-R\textsuperscript{2}" "Observations")) ///
 prehead(`"\begin{table}[H]\centering"' `"\footnotesize "' `"\begin{threeparttable} "' ///
	 		`"\caption{\label{tabvalidateachievementeffort} \textsc{Validating Achievement and Effort Measures}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{8}{c}}"' `"\hline"' `"\\"' ///
		`"   &  Sit PSU & Apply & Admitted & Enroll & Enroll  & Enroll  & Enroll  & Enroll \\ "' ///
    `" &   &  &  & year 1 & year 2 & year 3 & year 4 & year 5 \\"' ///
    `" & (1) & (2) & (3) & (4) & (5) & (6)  & (7)  & (8)\\"' 	`"\hline"' ///
	`"& \multicolumn{8}{c}{\textsc{A. Achievement}}\\"'  `"\cline{3-8}"') 

* Panel B 
areg applied_SUA_regular score_all_st, absorb(mrun) // column (1) will be empty in the table
estadd scalar N = ., replace 
est store m1
local k=2
foreach var in applied_SUA_regular admitted_SUA_regular enrolled_SUA_by_y1 enrolled_SUA_by_y2 enrolled_SUA_by_y3 enrolled_SUA_by_y4 enrolled_SUA_by_y5 {
   probit `var' score_all_st  PSU_score_if_positive  female simce_avg_st i.modalidad age alumno_prioritario neverfailed  [pweight=weight_mat] if treatment==0 , cluster(rbd_basefinal)
   local pR2=`e(r2_p)'
   margins, dydx(score_all_st) post
   sum  `var' if PSU_score_if_positive!=. & score_all_st !=. & simce_avg_st!=. & female!=. & modalidad!=. & age!=. & alumno_prioritario!=. & neverfailed!=.  & treatment==0 [weight=weight_mat]
   estadd scalar control_mean=`r(mean)'
   estadd scalar pseudoR2=`pR2'
   estadd local psuscore "Yes"
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 m3 m4 m5 m6 m7 m8 using "$tables/validate_achievement_effort.tex", append ///
    booktabs label unstack noobs keep(score_all_st) substitute("(.)" " " "0.000" " " ) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
 stats(psuscore control_mean pseudoR2 N, fmt(0 3 3 0 ) labels("PSU score"  "Control mean" "Pseudo-R\textsuperscript{2}" "Observations" )) ///
 prehead(`"& \multicolumn{8}{c}{\textsc{B. Achievement, controlling for PSU score}}\\"'  `"\cline{3-8}"') 
	
lab var st_effort_latent2 "Study effort index (std.)"
* Panel C
local k=1
foreach var in sit_PSU applied_SUA_regular admitted_SUA_regular enrolled_SUA_by_y1 enrolled_SUA_by_y2 enrolled_SUA_by_y3 enrolled_SUA_by_y4 enrolled_SUA_by_y5 {
   probit `var' st_effort_latent2 simce_avg_st i.modalidad age alumno_prioritario neverfailed female  [pweight=weight_mat] if treatment==0 , cluster(rbd_basefinal)
   local pR2=`e(r2_p)'
   margins, dydx(st_effort_latent2) post
   sum `var' if st_effort_latent2 !=. & simce_avg_st!=. & modalidad!=. & age!=. & alumno_prioritario!=. & neverfailed!=. & female!=. & treatment==0 [weight=weight_mat]
   estadd scalar control_mean=`r(mean)'
   estadd scalar pseudoR2=`pR2'
   estadd local psuscore "No"
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 m3 m4 m5 m6 m7 m8 using "$tables/validate_achievement_effort.tex", append ///
    booktabs label unstack noobs keep(st_effort_latent2) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
 stats(psuscore control_mean pseudoR2 N, fmt(0 3 3 0 ) labels("PSU score"  "Control mean" "Pseudo-R\textsuperscript{2}" "Observations" )) ///
 prehead(`"& \multicolumn{8}{c}{\textsc{C. Study effort}}\\"'  `"\cline{3-8}"') 


* Panel D
areg applied_SUA_regular st_effort_latent2, absorb(mrun) // column (1) will be empty in the table
estadd scalar N = ., replace 
est store m1
local k=2
foreach var in applied_SUA_regular admitted_SUA_regular enrolled_SUA_by_y1 enrolled_SUA_by_y2 enrolled_SUA_by_y3 enrolled_SUA_by_y4 enrolled_SUA_by_y5 {
   probit `var' st_effort_latent2  PSU_score_if_positive  female simce_avg_st i.modalidad age alumno_prioritario neverfailed  [pweight=weight_mat] if treatment==0 , cluster(rbd_basefinal)
   local pR2=`e(r2_p)'
   margins, dydx(st_effort_latent2) post
   sum  `var' if PSU_score_if_positive!=. & st_effort_latent2 !=. & simce_avg_st!=. & female!=. & modalidad!=. & age!=. & alumno_prioritario!=. & neverfailed!=.  & treatment==0 [weight=weight_mat]
   estadd scalar control_mean=`r(mean)'
   estadd scalar pseudoR2=`pR2'
   estadd local psuscore "Yes"
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 m3 m4 m5 m6 m7 m8 using "$tables/validate_achievement_effort.tex", append ///
    booktabs label unstack noobs keep(st_effort_latent2) substitute("(.)" " " "0.000" " " ) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
 stats(psuscore control_mean pseudoR2 N, fmt(0 3 3 0 ) labels("PSU score"  "Control mean" "Pseudo-R\textsuperscript{2}" "Observations" )) ///
 prehead(`"& \multicolumn{8}{c}{\textsc{D. Study effort, controlling for PSU score}}\\"'  `"\cline{3-8}"') ///
postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing"  "\item		\scriptsize \textsc{ Note.--} The Panels differ in the measure of achievement or of effort used as an explanatory variable and in whether the PSU score is used as a control, both highlighted in the title of each Panel. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}) and Inverse Probability Weights. Sample restriction: students in control schools. Average marginal effects from probit models reported. Delta-method standard errors clustered at school level in parenthesis. The study effort score is the standardized score predicted from the principal component analysis of the eight survey instruments reported in Appendix Table \ref{tab:effortappendix}.  *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01.\\ " "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 
    
	
********************************************************************************
**# Table A31: Average Treatment Effect on Pre-College Achievement Score using IRT
********************************************************************************
use "$dataClean/data_experimental.dta", clear
reg  score_irt_1p   treatment simce_avg_st female age alumno_prioritario neverfailed modalidad i.id_fieldworker   if in_experimental_schools==1,  cluster(rbd_basefinal)
estadd local invweights "NO"
eststo m1
reg  score_irt_1p   treatment simce_avg_st female age alumno_prioritario neverfailed modalidad i.id_fieldworker  [weight=weight_mat]  if in_experimental_schools==1,  cluster(rbd_basefinal)
estadd local invweights "YES"
eststo m2
esttab m1 m2 using "$tables/tab_reduced_form_irt.tex", nomtitles collabel(none) nonumbers ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label replace nocons nolines keep(treatment) stats(invweights N r2, labels("Inverse probability weights" "Observations"  "$ R^{2}$" "Observations") fmt(%9.3f %9.0f %9.3f))  ///
prehead(`"\begin{table}[H] "' `"\centering "' `"\begin{threeparttable} "' ///
			`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
	 		`"\caption{\label{tabreducedformirt} \textsc{Average Treatment Effect on Pre-College Achievement Score using IRT}}"' ///
	`"\begin{tabular}{l cc}"' `"\toprule"' ///
		`"& \multicolumn{2}{c}{\textsc{Standardized Achievement Score (IRT)}}  \\"'  ) posthead(`"\midrule"') ///
postfoot("\bottomrule" "\end{tabular}" "	\begin{tablenotes}[flushleft]\singlespacing" "\item		\scriptsize \textsc{ Note.--}  Coefficients are OLS estimates. Standard errors are clustered at the school level. Standard set of controls and with fieldworker fixed effects. Treatment is a dummy variable indicating whether a student is in a school that was randomly assigned to be in the PACE program. Scores are scaled using Item Response Theory models, and standardized to have mean zero and variance one. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. " "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 
    

********************************************************************************
**# Table A32: Treatment effects on subjective expectations measured in 12th grade
********************************************************************************

use "$dataClean/data_experimental.dta", clear
replace NEM_top15_April=NEM_top15 if NEM_top15_April==.
gen believed_distance_from_cutoff=abs(exp_NEM-NEM_top15_April) // if exp_NEM>NEM_top15_April
lab var believed_distance_from_cutoff "Perceived distance from cutoff"
su exp_PSUscore, d
gen above_med_exp_PSU=exp_PSUscore>r(p50) if exp_PSUscore!=.
lab var above_med_exp_PSU "Above median belief on PSU"
gen within_med_exp_PSU=1-above_med_exp_PSU
lab var within_med_exp_PSU "PSU belief $\leq$ median"
gen T_bdist=treatment*believed_distance_from_cutoff
gen perceived_t15=NEM_top15_April // this is the april perceived cutoff and when missing the august perceived cutoff
replace perceived_t15 = actual_top15_cutoff if NEM_top15_April==. 
gen dist_cutoff_rob=abs(exp_NEM-perceived_t15) // if exp_NEM>NEM_top15_April
* Treatment effect on subjective expecations for the entire sample and those with (exp_NEM>NEM_top15_April & within_med_exp_PSU==1)
lab var treatment "Treatment"
rename believed_distance_from_cutoff believed_distance
eststo clear
estimates clear
local variables believed_distance within_med_exp_PSU
qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {reg believed_distance treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)} {reg within_med_exp_PSU treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)}
local q_believed_distance= round(e(q_believed_distance_treatment), 0.001)
local q_within_med_exp_PSU = round(e(q_within_med_exp_PSU_treatment), 0.001)

rwolf2  ///
(reg believed_distance treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)) ///
(reg within_med_exp_PSU treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)),  ///
indepvars(treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newclusterid)
local rw_believed_distance= round(e(rw_believed_distance_treatment), 0.001)
local rw_within_med_exp_PSU = round(e(rw_within_med_exp_PSU_treatment), 0.001)

foreach var in `variables' {
eststo: reg  `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad , cluster(rbd_basefinal)
	su `var' if treatment==0 
	estadd scalar MEAN=`r(mean)'
    estadd scalar RW=`rw_`var''
    estadd scalar QV=`q_`var''
}

esttab * using "$tables/TE_subjective_expectations_michela.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none) nolines ///
    stats(RW QV MEAN r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val" "Control mean" "R-squared" "Observations"   )) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\begin{threeparttable} "' ///
	 		`"\caption{\label{tab: TEsubjectiveexpectations} \textsc{Treatment effects on subjective expectations measured in $12^{th}$ grade}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' 	`"\hline \\"' ///
`" &  \multicolumn{1}{c}{Perceived distance from cutoff}&          \multicolumn{1}{c}{Perceived PSU $\leq$ median} \\ "' ///
`"\hline"'  `" \multicolumn{3}{c}{A. All students} \\"' ) 

est clear 

reg  believed_distance treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if exp_NEM>NEM_top15_April & within_med_exp_PSU==1 , cluster(rbd_basefinal)
	su believed_distance if treatment==0 &  exp_NEM>NEM_top15_April & within_med_exp_PSU==1 
	estadd scalar MEAN=`r(mean)'
    est store m3

esttab * using "$tables/TE_subjective_expectations_michela.tex", append ///
      booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none) nolines ///
    stats(MEAN r2 N, fmt(3 3 0) labels("Control mean" "R-squared" "Observations"   )) ///
    prehead(`"\\"'  `"\multicolumn{3}{c}{B. Students with perceived GPA $>$ perceived cutoff, perceived PSU $\leq$ median} \\"' ) ///
	postfoot("\hline" "\end{tabular*}" "\vspace{-10pt}"  "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  The coefficients are OLS estimates. Standard errors were clustered at the school level. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program. Panel A is based on the sample of all survey respondents. Panel B is based on the sample of sample respondents who perceive themselves to have a higher GPA than the $85^{th}$ percentile in the school and a PSU score lower than or equal to the median perceived PSU. \textit{Perceived distance from cutoff} is the absolute value of the difference between a student's perceived own GPA and the perceived GPA of the $85^{th} $ percentile in their school. \textit{Perceived PSU} $\leq$ {\itshape median} is a dummy variable equal to 1 if the student expected a PSU score lower than or equal to the median interval (150-600) and 0 otherwise (600-850). \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect , considering both variables as one family. * p$<$0.10; ** p$<$0.05; *** p$<$0.01" "\end{tablenotes}" `"\end{threeparttable} "' "\end{table}") 

	
********************************************************************************
**# TABLE A33: Sample Balance Across Treatment and Control Groups, Students with Perceived GPA above the Perceived Cutoff and Perceived PSU Smaller than or Equal to the Median
********************************************************************************


		 
*Sample balance across treatment and control groups among students with expected PSU <= median expectation, and with exp_NEM>NEM_top15_April 
keep if within_med_exp_PSU==1 & exp_NEM>NEM_top15_April 
local variables female age alumno_prioritario meduc peduc hh_income simce_avg neverfailed santiago modalidad
cap matrix A
lab var female "Female"
lab var age "Age (years)"
lab var alumno_prioritario "Very-low-SES student"
lab var meduc "Mother's education (years) "
lab var peduc "Father's education (years) "
lab var hh_income "Family income (1,000 CLP)"
lab var simce_avg "SIMCE score (points)"
lab var neverfailed "Never failed a year"
lab var santiago "Santiago resident"
lab var modalidad "Academic high school track"
* Loop over each variable and add its statistics to the matrix
local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==0, detail
    local mean: display %9.3f round(r(mean),0.001)
    reg `var' treatment, cluster(rbd_basefinal)
    local b: display %9.3f round(_b[treatment],0.001)
    local se: display %9.3f round(_se[treatment],0.001)
	local pval:  display %9.3f r(table)[4,1]
    local N: display %9.3f e(N)
	if `k'==1 {
    matrix A = (`mean', `b', `pval', `N')
    matrix A = A \ (.,(`se'),.,. )
	}
	else {
    matrix A = A \ (`mean', `b',  `pval', `N')
    matrix A = A \ (.,(`se'),., .)
	}
	local k=`k'+1
}
cap gen nolabel=1
lab var nolabel " "
* Label the rows and columns of the matrix
matrix rownames A = female  nolabel age nolabel alumno_prioritario nolabel meduc nolabel peduc nolabel hh_income nolabel simce_avg nolabel neverfailed nolabel santiago nolabel modalidad nolabel


* Display the table
esttab matrix(A) using "$tables/sample_balance_within_med_exp_PSU.tex", nogap label replace nomtitles fragment nolines collabels(none)  nonumbers ///
prehead(`"\begin{table}[H]\centering"' `"\footnotesize"' `"%\resizebox{\textwidth}{!}{ "'  ///
        `"\caption{\label{tab:balancingwithinmedexpPSU} \textsc{Sample Balance Across Treatment and Control Groups, Students with Perceived GPA above the Perceived Cutoff and Perceived PSU Smaller than or Equal to the Median}}"' ///
            `"\renewcommand{\arraystretch}{1} "' ///
            `"\begin{tabular}{lcccc} \hline"' ///
			`"  &            &                        &    & \\"' ///
			`"			&            & Difference between    &  \$p\$-value    & \\"' ///
			`"			&  Control    &  Treatment and Control  &  (difference equals zero)  & N  \\"' ///
			 `"  			& (1)       & (2)                     &   (3)       & (4)    \\ "' ///
			 `" \hline"' ) ///
postfoot(`"\hline"'  `"\end{tabular}"'  `"\vspace{-10pt}"' `"\begin{tablenotes}\singlespacing"' ///
	     `"	\item	\scriptsize \noindent \textsc{ Note.--} Standard errors clustered at the school level are shown in even rows. Very-low-SES student is  a student that the government classified as very socioeconomically vulnerable ({\itshape Prioritario}). SIMCE is a standardized achievement test taken in $10^{th}$ grade. The sample is restricted to students who believe to rank in the top $15\%$ and expect a PSU score equal to or lower than the median of the belief distribution (150-600).  "' ///
		 `"\end{tablenotes}"' `"\end{table}"') 
		 
		 
		 
		 
**************************

* Validate beliefs

***********************
use "$dataClean/data_experimental.dta", clear
est clear 
lab var exp_PSU_st "Perceived PSU score"
gen exp_PSU_stXT=exp_PSU_st*treatment 
label var exp_PSU_stXT  "Perceived PSU score $\times$ Treatment"
gen GPAb_minus_c15b=exp_NEM -NEM_top15 if exp_NEM!=.
lab var GPAb_minus_c15b "Perceived GPA minus cutoff"
gen GPAb_minus_c15bXT=GPAb_minus_c15b*treatment 
egen GPA_14=rowmean( GPA_primero_medio GPA_segundo_medio GPA_tercero_medio GPA_cuarto_medio)
gen GPA_minus_c15= GPA_avg_1_2-actual_top15_cutoff
label var GPA_minus_c15 "Actual GPA minus cutoff"
label var GPAb_minus_c15bXT  "Perceived GPA minus cutoff $\times$ Treatment"

local outcomeslong PSU_score_if_positive_st sit_PSU
* Panel A
local k=1
foreach var in `outcomeslong' {  
   reg `var' exp_PSU_st exp_PSU_stXT i.treatment##c.(simce_avg_st age) i.treatment##i.(modalidad  alumno_prioritario neverfailed female) [pweight=weight_mat], cluster(rbd_basefinal)
   lincom exp_PSU_st + exp_PSU_stXT
   estadd scalar pvalinT=round(`r(p)', 0.001)
   sum `var' if   e(sample)==1 [weight=weight_mat]  
   estadd scalar sample_mean=`r(mean)'
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 using "$tables/validate_beliefs.tex", replace ///
    booktabs label unstack noobs keep(exp_PSU_st exp_PSU_stXT) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
 stats(sample_mean N r2 pvalinT, fmt(3 0 3 3) labels("Sample mean" "Observations" "R\textsuperscript{2}" "P-val: Var + Var $\times$  Treat")) ///
 prehead(`"\begin{table}[H] "' `"\scriptsize "' `"\begin{threeparttable}"' ///
	 		`"\caption{\label{tabvalidateallbeliefs} \textsc{Validating Belief Measures}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\toprule"' ///
	`"& \multicolumn{2}{c}{\textsc{A. Validity of PSU belief}}\\"'  `"\cline{2-3}"' 		`"   & PSU score &  Sit PSU \\ "' ) 


* Panel B
est clear 
local k=1
local outcomeslong GPA_minus_c15 sit_PSU
foreach var in `outcomeslong' {
   reg `var' GPAb_minus_c15b GPAb_minus_c15bXT i.treatment##c.(simce_avg_st age) i.treatment##i.(female modalidad alumno_prioritario neverfailed)  [pweight=weight_mat], cluster(rbd_basefinal)
   lincom GPAb_minus_c15b + GPAb_minus_c15bXT
   estadd scalar pvalinT=round(`r(p)', 0.001)
   sum  `var' if  e(sample)==1 [weight=weight_mat]
   estadd scalar sample_mean=`r(mean)'
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 using "$tables/validate_beliefs.tex", append ///
    booktabs label unstack noobs keep(GPAb_minus_c15b GPAb_minus_c15bXT) /// 
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
 stats(sample_mean N r2 pvalinT, fmt(3 0 3 3) labels("Sample mean" "Observations" "R\textsuperscript{2}" "P-val: Var + Var $\times$  Treat")) ///
prehead(`"\\"' `"& \multicolumn{2}{c}{\textsc{B. Validity of GPA belief}}\\"' `"\cline{2-3}"'  `"  & GPA minus cutoff &  Sit PSU \\ "'  ) ///
postfoot("\bottomrule" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing"  "\item		\scriptsize \textsc{ Note.--} The outcome variable is indicated at the top of the column. Panels A studies the explanatory role of perceived PSU, Panels B studies the explanatory role of the perceived distance in terms of GPA points from the within-school cutoff. The perceived PSU score is standardized using the distribution of PSU scores among all exam-takers in the country. Perceive GPA minus cutoff is the difference between the perceived own GPA and the perceived top 15\% cutoff. Within each panel, the belief variable is included uninteracted and interacted with treatment, to examine differences across treatment groups in the relationship between beliefs and outcomes. All regressions include as regressors the treatment dummy, and the standard set of controls (see notes under Figure \ref{fig:TEovertime}) uninteracted and interacted with the treatment dummy. All regressions use Inverse Probability Weights. The last row of each panel reports the p-value for the effect of the belief variable on the outcome in the treatment group, obtained as the sum of the effect of the belief variable uninteracted and interacted with the treatment dummy. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01.\\" "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 


**********************************************************************************
**# Table A34: Validating Belief Measures
**********************************************************************************
use "$dataClean/data_experimental.dta", clear
est clear 
lab var exp_PSU_st "Perceived PSU score"
gen exp_PSU_stXT=exp_PSU_st*treatment 
label var exp_PSU_stXT  "Perceived PSU score $\times$ Treatment"
gen GPAb_minus_c15b=exp_NEM -NEM_top15 if exp_NEM!=.
lab var GPAb_minus_c15b "Perceived GPA minus cutoff"
gen GPAb_minus_c15bXT=GPAb_minus_c15b*treatment 
egen GPA_14=rowmean( GPA_primero_medio GPA_segundo_medio GPA_tercero_medio GPA_cuarto_medio)
gen GPA_minus_c15= GPA_avg_1_2-actual_top15_cutoff
label var GPA_minus_c15 "Actual GPA minus cutoff"
label var GPAb_minus_c15bXT  "Perceived GPA minus cutoff $\times$ Treatment"

local outcomeslong PSU_score_if_positive_st sit_PSU
* Panel A
local k=1
foreach var in `outcomeslong' {  
   reg `var' exp_PSU_st exp_PSU_stXT i.treatment##c.(simce_avg_st age) i.treatment##i.(modalidad  alumno_prioritario neverfailed female) [pweight=weight_mat], cluster(rbd_basefinal)
   lincom exp_PSU_st + exp_PSU_stXT
   estadd scalar pvalinT=round(`r(p)', 0.001)
   sum `var' if   e(sample)==1 [weight=weight_mat]  
   estadd scalar sample_mean=`r(mean)'
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 using "$tables/validate_beliefs.tex", replace ///
    booktabs label unstack noobs keep(exp_PSU_st exp_PSU_stXT) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
 stats(sample_mean N r2 pvalinT, fmt(3 0 3 3) labels("Sample mean" "Observations" "R\textsuperscript{2}" "P-val: Var + Var $\times$  Treat")) ///
 prehead(`"\begin{table}[H] "' `"\scriptsize "' `"\begin{threeparttable}"' ///
	 		`"\caption{\label{tabvalidateallbeliefs} \textsc{Validating Belief Measures}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\toprule"' ///
	`"& \multicolumn{2}{c}{\textsc{A. Validity of PSU belief}}\\"'  `"\cline{2-3}"' 		`"   & PSU score &  Sit PSU \\ "' ) 


* Panel B
est clear 
local k=1
local outcomeslong GPA_minus_c15 sit_PSU
foreach var in `outcomeslong' {
   reg `var' GPAb_minus_c15b GPAb_minus_c15bXT i.treatment##c.(simce_avg_st age) i.treatment##i.(female modalidad alumno_prioritario neverfailed)  [pweight=weight_mat], cluster(rbd_basefinal)
   lincom GPAb_minus_c15b + GPAb_minus_c15bXT
   estadd scalar pvalinT=round(`r(p)', 0.001)
   sum  `var' if  e(sample)==1 [weight=weight_mat]
   estadd scalar sample_mean=`r(mean)'
   est store m`k'
   local k=`k'+1
}
esttab m1 m2 using "$tables/validate_beliefs.tex", append ///
    booktabs label unstack noobs keep(GPAb_minus_c15b GPAb_minus_c15bXT) /// 
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
 stats(sample_mean N r2 pvalinT, fmt(3 0 3 3) labels("Sample mean" "Observations" "R\textsuperscript{2}" "P-val: Var + Var $\times$  Treat")) ///
prehead(`"\\"' `"& \multicolumn{2}{c}{\textsc{B. Validity of GPA belief}}\\"' `"\cline{2-3}"'  `"  & GPA minus cutoff &  Sit PSU \\ "'  ) ///
postfoot("\bottomrule" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing"  "\item		\scriptsize \textsc{ Note.--} The outcome variable is indicated at the top of the column. Panels A studies the explanatory role of perceived PSU, Panels B studies the explanatory role of the perceived distance in terms of GPA points from the within-school cutoff. The perceived PSU score is standardized using the distribution of PSU scores among all exam-takers in the country. Perceive GPA minus cutoff is the difference between the perceived own GPA and the perceived top 15\% cutoff. Within each panel, the belief variable is included uninteracted and interacted with treatment, to examine differences across treatment groups in the relationship between beliefs and outcomes. All regressions include as regressors the treatment dummy, and the standard set of controls (see notes under Figure \ref{fig:TEovertime}) uninteracted and interacted with the treatment dummy. All regressions use Inverse Probability Weights. The last row of each panel reports the p-value for the effect of the belief variable on the outcome in the treatment group, obtained as the sum of the effect of the belief variable uninteracted and interacted with the treatment dummy. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01.\\" "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 



************************************
**# Table A38: Teacher grading
************************************
use "$dataClean/data_experimental.dta", clear
lab var score_all_st "Achievement Score"
gen scoreXT=score_all_st*treatment
lab var scoreXT "Achievement Score × Treatment"
reg std_GPA_core score_all_st scoreXT treatment alumno_prioritario neverfailed i.modalidad female age [weight=weight_mat], cluster(rbd_basefinal )
estadd local simce "NO"
eststo m1
reg std_GPA_core score_all_st scoreXT treatment simce_avg_st alumno_prioritario neverfailed i.modalidad female age [weight=weight_mat], cluster(rbd_basefinal )
estadd local simce "YES"
eststo m2
esttab m1 m2 using "$tables/tab_grading.tex", nomtitles collabel(none) nonumbers ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label replace nocons nolines keep(score_all_st scoreXT) stats(simce N r2, labels("Baseline SIMCE test score " "Observations"  "$ R^{2}$" "Observations") fmt(%9.3f %9.0f %9.3f))  ///
prehead(`"\begin{table}[H] "' `"\centering "' `"\begin{threeparttable} "' ///
			`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
	 		`"\caption{\label{tabgrading} \textsc{Teacher Grading}}"' ///
	`"\begin{tabular}{l  cc  }"' `"\toprule"' ///
		`"& \multicolumn{2}{c}{$12^{th}$ grade core GPA (standardized)} \\"'  ) posthead(`"\midrule"') ///
postfoot("\bottomrule" "\end{tabular}" "	\begin{tablenotes}[flushleft]\singlespacing" "\item		\scriptsize \textsc{ Note.--} Coefficients are OLS estimates. Standard errors are clustered at the school level. Standard set of controls except for baseline SIMCE test score. Inverse Probability Weights used. {\itshape Core GPA} is the GPA in the core subjects, which are those tested on the PSU entrance exam.  {\itshape Treatment} is a dummy variable indicating whether a student is in a school that was randomly assigned to be in the PACE program. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01. " "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 
    


*******************************************************************************************
**# Table A39: Survey of school principals: grading methods and support classes
*******************************************************************************************
use "$dataTemp/jefes_clean.dta", clear 
lab var treatment "Treatment"
reg teachers_meet  treatment 
eststo m1
reg teachers_adjust treatment 
eststo m2
reg remedial_classes treatment 
eststo m3
reg class_for_PSU treatment 
eststo m4
reg freq_remedial treatment  
eststo m5
esttab m1 m2 m3 m4 m5 using "$tables/tab_principal.tex", nomtitles collabel(none) nonumbers ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label replace nocons nolines keep(treatment) stats(N, labels("Observations") fmt(%9.0f))  ///
prehead(`"\begin{table}[H] "' `"\centering "' `"\footnotesize "'  `"\begin{threeparttable} "' ///
			`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
	 		`"\caption{\label{tabprincipal} \textsc{Survey of School Principals: Grading Methods and Support Classes}}"' ///
	`"\begin{tabular}{l  cc c cc}"' `"\toprule"' `"& (1) & (2) & (3) & (4) & (5) \\"' ///
		`"& Teachers discuss & Teachers adjust & Support (general) & Support PSU & Frequency support \\"') posthead(`"\midrule"') ///
postfoot(`"\bottomrule"' "\end{tabular}" "	\begin{tablenotes}[flushleft]\singlespacing" "\item		\scriptsize \textsc{ Note.--} Coefficients are OLS estimates. Treatment is a dummy variable indicating whether a student is in a school that was randomly assigned to be in the PACE program. Outcome variables: dummy variables indicating whether teachers meet at the end of the year to discuss the grades of each student (column 1), whether teachers adjusts grades based on students' motivation, effort or other reason (column 2), whether the school offered support classes in any subject (column 3) and support classes for PSU entrance exam preparation (column 4) to the cohort of students under study. The outcome in the last column is the number of support classes per week. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01. " "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 



	
********************************************************************************
**# Table A40: Treatment Effects on Teachers' Effort and Focus of Instruction
********************************************************************************
use "$dataClean/data_experimental.dta", clear
bysort rbd_basefinal let_cur: gen class_index=1 if _n==1
bysort rbd_basefinal let_cur: egen mean_class_simce=mean(simce_avg_st)
gen MT_teacher_hours=MT_hours_teach_outside+MT_hours_teach_prep
gen LT_teacher_hours=LT_hours_teach_outside+LT_hours_teach_prep
rename LT_language_prog_focus LT_lang_prog_focus
* Teacher variables are constant within classroom but missing for some students.
  * Fill them with the classroom value so results do not depend on which row
  * bysort picks as class_index==1 (sort tie-breaks differ across Stata setups).
  foreach var in MT_teacher_hours LT_teacher_hours MT_days_miss_class LT_days_miss_class MT_math_prog_focus LT_lang_prog_focus {
      bysort rbd_basefinal let_cur: egen double __fill=min(`var')
      replace `var'=__fill
      drop __fill
  }
qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {regress MT_teacher_hours treatment  if class_index==1, vce(cluster rbd_basefinal)} {regress LT_teacher_hours treatment  if class_index==1, vce(cluster rbd_basefinal)} {regress MT_days_miss_class treatment  if class_index==1, vce(cluster rbd_basefinal)} {regress LT_days_miss_class treatment  if class_index==1, vce(cluster rbd_basefinal)} {regress MT_math_prog_focus treatment  if class_index==1, vce(cluster rbd_basefinal)} {regress LT_lang_prog_focus treatment  if class_index==1, vce(cluster rbd_basefinal)}  // put treatment variable immediately after dependent variable in each regression
foreach var in MT_teacher_hours LT_teacher_hours MT_days_miss_class LT_days_miss_class MT_math_prog_focus LT_lang_prog_focus {
   local q_`var' = round(e(q_`var'_treatment), 0.001)
}

rwolf2  ///
(regress MT_teacher_hours treatment  if class_index==1, vce(cluster rbd_basefinal)) ///
(regress LT_teacher_hours treatment  if class_index==1, vce(cluster rbd_basefinal)) ///
(regress MT_days_miss_class treatment  if class_index==1, vce(cluster rbd_basefinal))  ///
(regress LT_days_miss_class treatment  if class_index==1, vce(cluster rbd_basefinal))  ///
(regress MT_math_prog_focus treatment  if class_index==1, vce(cluster rbd_basefinal))  ///
(regress LT_lang_prog_focus treatment  if class_index==1, vce(cluster rbd_basefinal)),  ///
indepvars(treatment, treatment, treatment, treatment, treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
foreach var in MT_teacher_hours LT_teacher_hours MT_days_miss_class LT_days_miss_class MT_math_prog_focus LT_lang_prog_focus {
   local rw_`var' = round(e(rw_`var'_treatment), 0.001)
}
foreach var in MT_teacher_hours LT_teacher_hours MT_days_miss_class LT_days_miss_class MT_math_prog_focus LT_lang_prog_focus {
   reg `var' treatment if class_index==1, cluster(rbd_basefinal)
   sum `var' if e(sample)==1 & treatment==0
   estadd scalar control_mean=`r(mean)'
   estadd scalar RW=`rw_`var''
   estadd scalar QV=`q_`var''
   est store m`var'
}
esttab mMT_teacher_hours mLT_teacher_hours mMT_days_miss_class mLT_days_miss_class mMT_math_prog_focus mLT_lang_prog_focus ///
       using "$tables/teachers_effort.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(RW QV control_mean  r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val" "Control mean"  "R-squared" "Observations")) ///
prehead(`"	\begin{table}[H]\centering"'  `"\footnotesize"' ///
        `"\caption{\label{tab:teachereff}\textsc{Treatment Effects on Teachers Effort and Focus of Instruction}}"' ///
		`"\begin{tabular}{l*{6}{c}}"' `"\hline"'  ///
		`"&\multicolumn{2}{c}{Effort (Prep Hours)} &\multicolumn{2}{c}{Effort (Absences)}  &\multicolumn{2}{c}{Focus of Instruction} \\"' ///
		`"&      Mathematics        &      Language       &  Mathematics        &  Language         &    Mathematics         &    Language        \\"'  ///
		`"&\multicolumn{1}{c}{(1)}         &\multicolumn{1}{c}{(2)}         &\multicolumn{1}{c}{(3)}         &\multicolumn{1}{c}{(4)}         &\multicolumn{1}{c}{(5)}         &\multicolumn{1}{c}{(6)}         \\"' `"\hline \\"') ///
postfoot("\hline" "\end{tabular}" "\begin{threeparttable}" "\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--} Results from OLS regressions. The unit of observations are classrooms (there are one Mathematics and one Language teacher per classroom). The construction of the focus of instruction variable is described in section \ref{sec:teachervar} below. It ranges from 0 to 1 and higher values indicate targeting higher-ability students. Absences from work are measured in days per year. Standard errors in parentheses. Treatment is a dummy equal to 1 if a school is randomly allocated to have PACE, and equal to 0 otherwise. \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering all the outcomes in the table as one family. $*<0.10$; $**<0.05$; $***<0.01$. \\" "\end{tablenotes}" ///
 "\end{threeparttable}"  "\end{table}") 

	
*******************************************************************************************
**# Table A41: Survey of school principals: assignmen of students to classrooms
*******************************************************************************************
use "$dataTemp/jefes_clean.dta", clear 
lab var treatment "Treatment"
reg stay_same_class treatment 
eststo m1
reg assignclass_byskill treatment 
eststo m2
reg assignclass_random treatment 
eststo m3
reg assignclass_alphabet treatment
eststo m4
esttab m1 m2 m3 m4 using "$tables/tab_principal2.tex", nomtitles collabel(none) nonumbers ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) label replace nocons nolines keep(treatment) stats(N, labels("Observations") fmt(%9.0f))  ///
prehead(`"\begin{table}[H] "' `"\centering "' `"\footnotesize "'  `"\begin{threeparttable} "' ///
			`"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' ///
	 		`"\caption{\label{tabprincipal2} \textsc{Survey of School Principals: Assignment of Students to Classrooms}}"' ///
	`"\begin{tabular}{l  cc c c}"' `"\toprule"' `"& (1) & (2) & (3) & (4) \\"' ///
		`"& Assignment Fixed & Ability Tracking & Random Assignment & Alphabetical Assignment \\"') posthead(`"\midrule"') ///
postfoot(`"\bottomrule"' "\end{tabular}" "	\begin{tablenotes}[flushleft]\singlespacing" "\item		\scriptsize \textsc{ Note.--} Coefficients are OLS estimates. {\itshape Treatment} is a dummy variable indicating whether a student is in a school that was randomly assigned to be in the PACE program. The outcome variables are dummy variables indicating whether: a student must stay in the same class throughout high school (column (1)), the school allocate students to classrooms based on ability (column (2)), the school allocates students to classrooms at random (column (3)), the student allocates students to classrooms alphabetically (column (4)). *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01. " "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 



********************************************************************************
**# Table A42: Effect of PACE on the Mean and the Variance of the Subjective Distribution of Earnings at age 30, with and without a College Degree.
******************************************************************************** 
use "$dataClean/data_experimental.dta", clear

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {regress expearn_nouni treatment modalidad age female alumno_prioritario simce_avg_st neverfailed [pweight=weight_mat_April], vce(cluster rbd_basefinal)} {regress expearn_uni treatment modalidad age female alumno_prioritario simce_avg_st neverfailed [pweight=weight_mat_April], vce(cluster rbd_basefinal)} {regress expearn_nouni_est treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, vce(cluster rbd_basefinal)} {regress expearn_uni_est treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, vce(cluster rbd_basefinal)} {qreg2 exp_var_nouni treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, cluster(rbd_basefinal) quantile(.5)} {qreg2 exp_var_uni treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, cluster(rbd_basefinal) quantile(.5)}  // put treatment variable immediately after dependent variable in each regression
foreach var in expearn_nouni expearn_uni expearn_nouni_est expearn_uni_est exp_var_nouni exp_var_uni {
   local q_`var' = round(e(q_`var'_treatment), 0.001)
}

rwolf2  ///
(regress expearn_nouni treatment modalidad age female alumno_prioritario simce_avg_st neverfailed [pweight=weight_mat_April], vce(cluster rbd_basefinal)) ///
(regress expearn_uni treatment modalidad age female alumno_prioritario simce_avg_st neverfailed [pweight=weight_mat_April], vce(cluster rbd_basefinal)) ///
(regress expearn_nouni_est treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, vce(cluster rbd_basefinal))  ///
(regress expearn_uni_est treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, vce(cluster rbd_basefinal))  ///
(qreg2 exp_var_nouni treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, cluster(rbd_basefinal) quantile(.5))  ///
(qreg2 exp_var_uni treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, cluster(rbd_basefinal) quantile(.5)),  ///
indepvars(treatment, treatment, treatment, treatment, treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
foreach var in expearn_nouni expearn_uni expearn_nouni_est expearn_uni_est exp_var_nouni exp_var_uni {
   local rw_`var' = round(e(rw_`var'_treatment), 0.001)
}

foreach var in expearn_nouni expearn_uni expearn_nouni_est expearn_uni_est exp_var_nouni exp_var_uni {
   if "`var'"=="expearn_nouni" | "`var'"=="expearn_uni" {
   	  reg `var' treatment modalidad age female alumno_prioritario simce_avg_st neverfailed [pweight=weight_mat_April], cluster(rbd_basefinal)
   }
   if "`var'"=="expearn_nouni_est" | "`var'"=="expearn_uni_est" {
      reg `var' treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, cluster(rbd_basefinal)
   }
   if "`var'"=="exp_var_nouni" | "`var'"=="exp_var_uni" {
      qreg2 `var' treatment modalidad age female alumno_prioritario simce_avg_st neverfailed, cluster(rbd_basefinal) quantile(.5)
   }
   sum `var' if e(sample)==1 & treatment==0
   estadd scalar control_mean=`r(mean)'
   estadd scalar RW=`rw_`var''
   estadd scalar QV=`q_`var''
   est store m`var'
}
esttab mexpearn_nouni mexpearn_uni mexpearn_nouni_est mexpearn_uni_est mexp_var_nouni mexp_var_uni using "$tables/exp_earnings.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(RW QV r2 N, fmt(3 3 3 0) labels("RW-adj p-val" "q-val"  "R-squared" "Observations")) ///
 prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\centering "' ///
	 		`"\caption{\label{expearnings}\textsc{Effect of PACE on the Mean and the Variance of the Subjective Distribution of Earnings at age 30, with and without a College Degree.}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{6}{c}}"' `"\hline"' ///
		`"   &  \multicolumn{2}{c}{Expected Earnings} & \multicolumn{2}{c}{Expected Earnings} & \multicolumn{2}{c}{Variance of Earnings}  \\ "' ///
		`"   &  \multicolumn{2}{c}{(Elicited)} & \multicolumn{2}{c}{(Estimated)} & \multicolumn{2}{c}{(Estimated)}  \\ "' ///
    `" &  Without & With &  Without & With & Without & With \\"' ///
    `" & (1) & (2) & (3) & (4) & (5) & (6)  \\"' 	`"\hline"') ///
postfoot("\hline" "\end{tabular*}" "\begin{threeparttable}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--} Standard errors clustered at school level. Inverse probability weights used. Expected earnings measured in million CLP. Variance measured in million CLP squared. Variance regressions are median regressions. \textit{Without} means without a college degree. \textit{With} means with a college degree. {\itshape Treatment} is a dummy variable indicating whether a student is in a school that was randomly assigned to be in the PACE program. Standard set of controls (gender, age, {\itshape Prioritario} student, SIMCE, never failed a year, school track). \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering all the outcomes in the table as one family.  Significance: *p $< 0.10$; **p $< 0.05$; ***p $< 0.01$.\\" "\end{tablenotes}" "\end{threeparttable}" "\end{table}") 
		   


*******************************************************************************************
**# Table A43: Effects of PACE on selectice college applications and admissions 
*              through the regular channel 
*******************************************************************************************

use "$dataClean/data_experimental.dta", clear
rename *_regular *_r
 


* Treatment effects on regular applications and admissions (dummies)
use "$dataClean/data_experimental.dta", clear
rename *_regular *_r

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {reg applied_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)} {reg admitted_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)}
local q_applied_SUA_all = round(e(q_applied_SUA_r_treatment), 0.001)
local q_admitted_SUA_all = round(e(q_admitted_SUA_r_treatment), 0.001)
rwolf2  ///
(reg applied_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)) ///
(reg admitted_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad, vce(cluster rbd_basefinal)) ///
,  indepvars(treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
local rw_applied_SUA_all = round(e(rw_applied_SUA_r_treatment), 0.001)
local rw_admitted_SUA_all = round(e(rw_admitted_SUA_r_treatment), 0.001)

fdr_sharpened_qvalues_adj {reg applied_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)} {reg admitted_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)}
local q_applied_SUA_bottom = round(e(q_applied_SUA_r_treatment), 0.001)
local q_admitted_SUA_bottom = round(e(q_admitted_SUA_r_treatment), 0.001)
rwolf2  ///
(reg applied_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)) ///
(reg admitted_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)) ///
,  indepvars(treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
local rw_applied_SUA_bottom = round(e(rw_applied_SUA_r_treatment), 0.001)
local rw_admitted_SUA_bottom = round(e(rw_admitted_SUA_r_treatment), 0.001)

fdr_sharpened_qvalues_adj {reg applied_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)} {reg admitted_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)}
local q_applied_SUA_top = round(e(q_applied_SUA_r_treatment), 0.001)
local q_admitted_SUA_top = round(e(q_admitted_SUA_r_treatment), 0.001)
rwolf2  ///
(reg applied_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)) ///
(reg admitted_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)) ///
,  indepvars(treatment, treatment)  seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
local rw_applied_SUA_top = round(e(rw_applied_SUA_r_treatment), 0.001)
local rw_admitted_SUA_top = round(e(rw_admitted_SUA_r_treatment), 0.001)

* family: outcome
gen applied_SUA_1 = applied_SUA_r
gen applied_SUA_2 = applied_SUA_r
fdr_sharpened_qvalues_adj {reg applied_SUA_1 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)} {reg applied_SUA_2 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)}  // put treatment variable immediately after the dependent variable in each regression
local q_applied_SUA_1 = round(e(q_applied_SUA_1_treatment), 0.001)
local q_applied_SUA_2 = round(e(q_applied_SUA_2_treatment), 0.001)
* family: outcome2
gen admitted_SUA_1 = admitted_SUA_r
gen admitted_SUA_2 = admitted_SUA_r
fdr_sharpened_qvalues_adj {reg admitted_SUA_1 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0, vce(cluster rbd_basefinal)} {reg admitted_SUA_2 treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1, vce(cluster rbd_basefinal)}  // put treatment variable immediately after the dependent variable in each regression
local q_admitted_SUA_1 = round(e(q_admitted_SUA_1_treatment), 0.001)
local q_admitted_SUA_2 = round(e(q_admitted_SUA_2_treatment), 0.001)


reg applied_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)
su applied_SUA_r if treatment==0
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_applied_SUA_all'
estadd scalar QV=`q_applied_SUA_all'
est store m1
reg admitted_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad,  cluster(rbd_basefinal)
su admitted_SUA_r if treatment==0
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_admitted_SUA_all'
estadd scalar QV=`q_admitted_SUA_all'
est store m2
reg applied_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0,  cluster(rbd_basefinal)
su applied_SUA_r if treatment==0 & top15baseline==0
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_applied_SUA_bottom'
estadd scalar QV=`q_applied_SUA_bottom'
estadd scalar QV2=`q_applied_SUA_1'
est store m3
reg admitted_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==0,  cluster(rbd_basefinal)
su admitted_SUA_r if treatment==0 & top15baseline==0
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_admitted_SUA_bottom'
estadd scalar QV=`q_admitted_SUA_bottom'
estadd scalar QV2=`q_admitted_SUA_1'
est store m4
reg applied_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1,  cluster(rbd_basefinal)
su applied_SUA_r if treatment==0  & top15baseline==1
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_applied_SUA_top'
estadd scalar QV=`q_applied_SUA_top'
estadd scalar QV2=`q_applied_SUA_2'
est store m5
reg admitted_SUA_r treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if top15baseline==1,  cluster(rbd_basefinal)
su admitted_SUA_r if treatment==0  & top15baseline==1
estadd scalar control_mean=`r(mean)'
estadd scalar RW=`rw_admitted_SUA_top'
estadd scalar QV=`q_admitted_SUA_top'
estadd scalar QV2=`q_admitted_SUA_2'
est store m6
esttab m1 m2 m3 m4 m5 m6 using "$tables/TE_regular_admissions_enrollments_f.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none)  nonumbers nolines nomtitles ///
    stats(RW QV QV2 control_mean N, fmt(3 3 3 3 3 0) labels("p-val(family: sample)" "q-val(family: sample)" "q-val(family: outcome)" "Control mean"  "Observations")) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\centering "' ///
	 		`"\caption{\label{tab: TEapplicationsadmissionsregular} \textsc{Effects of PACE on Selective College Applications and Admissions through the Regular Channel}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{6}{c}}"' `"\hline"' ///
		`"&  \multicolumn{2}{c}{All sample} & \multicolumn{2}{c}{Bottom 85\%}  & \multicolumn{2}{c}{Top 15\%}\\  "'  ///
		`"&  \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Admissions} &  \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Admissions} &  \multicolumn{1}{c}{Applications} & \multicolumn{1}{c}{Admissions}   \\  "' ///
		`"& (1)  & (2) &  (3)  & (4) &  (5)  & (6)     \\"' 	`"\hline"') ///
    postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  Columns (1) and (2) use the sample of all students in the experiment. Columns (3) and (4) use the sample of students who at the end of $10^{th}$ grade, before the experiment started, were in the bottom $85\%$ of their school according to GPA in the first two high school years. Columns (5) and (6) use the sample of students who at the end of $10^{th}$ grade, before the experiment started, were in the top $15\%$ of their school according to GPA in the first two high school years. The share of students in the top $15\%$ at baseline is slightly larger than $15\%$ because there are students with the same GPA average at baseline. \textit{Control group mean} is the mean of the dependent variable in the control group. Results from OLS regressions. Treatment is a dummy equal to 1 if a school was randomly assigned to be in the PACE treatment, to 0 otherwise. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). Standard errors clustered at the school level in parenthesis. \textit{p-val(family: sample)} and \textit{q-val(family: outcome)} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and sharpened  q-values of the treatment effect, considering each sample as one family. \textit{q-val(family: sample)} indicate sharpened q-values of the treatment effect, considering the same outcome variable across sub-samples as one family. *p $<$ 0.10; **p $<$ 0.05; ***p $<$ 0.01.\\" "\end{tablenotes}" "\end{table}") 


	
	


********************************************************************************************************
**# Table A44: Description of application lists and admissions to selective colleges 
// ** NB I eliminated space between panels and brought notes closer to table - check no running issues
********************************************************************************************************

use "$dataClean/data_applications_assignments.dta", replace
merge m:1 mrun using "$dataClean/data_experimental.dta"
keep if _merge==3
drop _merge 
		 
* Stacking top15% and all
* List your variables here
local variables distance_average fraction_STEM mean_PSU_score_avg ///
distance_preferred  STEM_preferred mean_PSU_score_preferred ///
distance_admitted STEM_admitted mean_PSU_score_admitted 
cap matrix A
lab var distance_average "Average distance (km) from listed programs"
lab var fraction_STEM "Fraction of STEM among listed programs"
lab var mean_PSU_score_avg "Average selectivity of listed programs"
lab var distance_preferred "Distance (km) from top-listed program"
lab var STEM_preferred "Top-listed program is STEM"
lab var mean_PSU_score_preferred "Selectivity of top-listed program"
lab var distance_admitted "Distance (km) from program to which admitted"
lab var mean_PSU_score_admitted "Selectivity of program to which admitted"
lab var STEM_admitted "Program to which admitted is STEM"
* Loop over each variable and add its statistics to the matrix
local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==1 & regular_application==1 & top15baseline==1, detail
    local meantop15r: display %9.3g r(mean)
    local sdtop15r: display %9.3g r(sd)
    local Ntop15r: display %9.0g r(N)
	quietly summarize `var' if treatment==1 & pace_application==1 & top15baseline==1, detail
    local meantop15p: display %9.3g r(mean)
    local sdtop15p: display %9.3g r(sd)
    local Ntop15p: display %9.0g r(N)
	if `k'==1 {
    matrix A = (`meantop15r', `sdtop15r', `Ntop15r', `meantop15p', `sdtop15p', `Ntop15p')
	}
	else {
    matrix A = A \ (`meantop15r', `sdtop15r', `Ntop15r', `meantop15p', `sdtop15p', `Ntop15p')
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames A = `variables'
matrix colnames A = Mean SD N Mean SD N
* Display the table
esttab matrix(A) using "$tables/summary_stats_applications_assignments_top15_all.tex", nogap label replace  fragment nomtitles nolines collabels(none)  nonumbers nolines ///
prehead(`"\begin{table}[H]\centering"' ///
        `"\footnotesize"'  ///
            `"\caption{\label{tab:summaryapplications} \textsc{Description of application lists and admissions to selective colleges.}}"' ///
            `"\begin{tabular}{l*{1}{cccccc}}"' `"\hline"' ///
			`"	  &  \multicolumn{3}{l}{\textsc{Regular applications}} &  \multicolumn{3}{l}{\textsc{PACE applications}}  \\"' ///
			`"    &        Mean&          St.dev.  & N & Mean&           St.dev.    & N\\ "' ///
			 `"   & (1) & (2) & (3) & (4)  & (5) & (6)  \\ "' ///
			`"		    \multicolumn{7}{l}{\textsc{A. Top 15\%, Treated Students}}\\"'   `"\cline{1-1}"' ) 
local k=1
foreach var in `variables' {
    summarize  `var' if treatment==0 & regular_application==1 & top15baseline==1, detail
    local meantop15: display %9.3g r(mean)
    local sdtop15: display %9.3g r(sd)
    local Ntop15: display %9.0g r(N)
	if `k'==1 {
    matrix B=(`meantop15', `sdtop15',`Ntop15',.,.,.)
	}
	else {
    matrix B= B \ (`meantop15', `sdtop15', `Ntop15',.,.,.)
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames B = `variables'
matrix colnames B = Mean SD N Mean SD N
* Display the table
esttab matrix(B) using "$tables/summary_stats_applications_assignments_top15_all.tex", nogap label append nomtitles fragment nolines collabels(none)  nonumbers nolines ///
prehead( `" \multicolumn{7}{l}{\textsc{B. Top 15\%, Control students}}\\"'   `"\cline{1-1}"' ) 

local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==1 & regular_application==1 , detail
    local meanallT: display %9.3g r(mean)
    local sdallT: display %9.3g r(sd)
    local NallT: display %9.0g r(N)
	if `k'==1 {
    matrix C = (`meanallT', `sdallT', `NallT', .,.,.)
	}
	else {
    matrix C = C \ (`meanallT', `sdallT', `NallT', .,.,.)
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames C = `variables'
matrix colnames C = Mean SD N Mean SD N
* Display the table
esttab matrix(C) using "$tables/summary_stats_applications_assignments_top15_all.tex", nogap label append nomtitles fragment nolines collabels(none)  nonumbers nolines ///
prehead( `" \multicolumn{7}{l}{\textsc{C. All, Treated students}}\\"'   `"\cline{1-1}"' ) 

local k=1
foreach var in `variables' {
    quietly summarize `var' if treatment==0 & regular_application==1 , detail
    local meanallC: display %9.3g r(mean)
    local sdallC: display %9.3g r(sd)
    local NallC: display %9.0g r(N)
	if `k'==1 {
    matrix D = (`meanallC', `sdallC', `NallC', .,.,.)
	}
	else {
    matrix D = D \ (`meanallC', `sdallC', `NallC', .,.,.)
	}
	local k=`k'+1
}
* Label the rows and columns of the matrix
matrix rownames D = `variables'
matrix colnames D = Mean SD N Mean SD N
* Display the table
esttab matrix(D) using "$tables/summary_stats_applications_assignments_top15_all.tex", nogap label append nomtitles fragment nolines collabels(none)  nonumbers nolines ///
prehead( `" \multicolumn{7}{l}{\textsc{D. All, Control students}}\\"'   `"\cline{1-1}"' ) ///
postfoot(`"\hline"'  `"\end{tabular}"' `"\begin{threeparttable}"'  `"\vspace{-0.4cm}"'  `"\begin{tablenotes}\singlespacing"' ///
	     `"\item	\scriptsize \textsc{ Note. --} This Table provides summary statistics on the programs to which students apply and are admitted through the regular and the PACE channels. Within each channel, students submit ranked preference lists, and can apply to a maximum of ten programs. Panels A and B restrict the sample to students who were in the top 15\% of their high school GPA ranking at baseline. Panels C and D consider all students, regardless of their within-school rank. Treated students are those who attended schools randomly allocated to PACE, control students are those who attended schools randomly allocated to the control group. Columns (1) to (3) describe applications and admissions through the regular channel; columns (4) to (6) through the PACE channel. As a measure of distance we use the length (km) of the shortest path between the coordinates of the program and of the high school the student attended, implementing Vincenty formula to calculate distances on a reference ellipsoid. Selectivity is the average PSU score of all regular entrants in the program in 2018 (standardized). "' ///
		 `"\end{tablenotes}"' `"\end{threeparttable}"'  `"\end{table}"') 
		 



*******************************************************************************************
**# Table A45: Comparison between regular application lists and admisisons to selective //
*              colleges in the treatment and control groups 
* NB: I added \vspace{-0.4} to bring table notes closer to tabel -- check no running issues
*******************************************************************************************
use "$dataClean/data_applications_assignments.dta", replace
merge m:1 mrun using "$dataClean/data_experimental.dta"
keep if _merge==3
drop _merge
rename *_preferred *_pref
rename *_admitted *_adm
rename top15baseline top15
lab var treatment "Treatment"
eststo clear
estimates clear
global controls simce_avg_st female age alumno_prioritario neverfailed modalidad
local allvars distance_average fraction_STEM mean_PSU_score_avg  distance_pref  STEM_pref mean_PSU_score_pref distance_adm STEM_adm mean_PSU_score_adm

qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
foreach subsample in all top15 {
   fdr_sharpened_qvalues_adj {regress distance_average treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)} {regress fraction_STEM treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)} {regress mean_PSU_score_avg treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)} {regress distance_pref treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)} {regress STEM_pref treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)} {regress mean_PSU_score_pref treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)} {regress distance_adm treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)} {regress STEM_adm treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)} {regress mean_PSU_score_adm treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)} // put treatment variable immediately after dependent variable in each regression
   foreach var in `allvars' {
      local q_`var'_`subsample'= round(e(q_`var'_treatment), 0.001)
   }
   rwolf2  ///
   (regress distance_average treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)) ///
   (regress fraction_STEM treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)) ///
   (regress mean_PSU_score_avg treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)) ///
   (regress distance_pref treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)) ///
   (regress STEM_pref treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)) ///
   (regress mean_PSU_score_pref treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)) ///
   (regress distance_adm treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)) ///
   (regress STEM_adm treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)) ///
   (regress mean_PSU_score_adm treatment $controls if regular_application==1 & `subsample'==1, cluster(rbd_basefinal)), ///
   indepvars(treatment, treatment, treatment, treatment, treatment, treatment, treatment, treatment, treatment)  seed(28052016) ///
   reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
   foreach var in `allvars' {
      local rw_`var'_`subsample'= round(e(rw_`var'_treatment), 0.001)
   }
}

local variables distance_average fraction_STEM mean_PSU_score_avg 
foreach var in `variables' {
   reg  `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if regular_application==1 & top15==1, cluster(rbd_basefinal)
   su `var' if treatment==0 & e(sample)==1
   estadd scalar MEAN=`r(mean)'
   estadd scalar RW=`rw_`var'_top15'
   estadd scalar QV=`q_`var'_top15'
   est store t15`var'
}
foreach var in `variables' {
   reg  `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if regular_application==1, cluster(rbd_basefinal)
   su `var' if treatment==0 & e(sample)==1
   estadd scalar MEAN=`r(mean)'
   estadd scalar RW=`rw_`var'_all'
   estadd scalar QV=`q_`var'_all'
   est store all`var'
}
esttab all* t15*  using "$tables/TE_applications_assignments_top15.tex", replace ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none) nolines ///
    stats(RW QV MEAN r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val"  "Control mean" "R-squared" "Observations")) ///
    prehead(`"\begin{table}[H]\centering %htbp"' `"\footnotesize "' `"\centering "' ///
	 		`"\caption{\label{tab: TEapplicationsassignmentstop15} \textsc{Comparison between regular application lists and admissions to selective colleges in the treatment and control groups.}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{6}{c}}"' 	`"\hline \\"' `"& \multicolumn{6}{c}{\textsc{A. All listed programs}} \\"' ///
	`"& \multicolumn{3}{c}{All students} & \multicolumn{3}{c}{Top 15\%} \\"' `"\cmidrule(lr){2-4} \cmidrule(lr){5-7}"' /// 
`" &  \multicolumn{1}{c}{Average}&          \multicolumn{1}{c}{Fraction}&          \multicolumn{1}{c}{Average} &  \multicolumn{1}{c}{Average}&          \multicolumn{1}{c}{Fraction}&          \multicolumn{1}{c}{Average}  \\ "' /// 
`" &   \multicolumn{1}{c}{distance}&          \multicolumn{1}{c}{STEM}&          \multicolumn{1}{c}{selectivity} &   \multicolumn{1}{c}{distance}&          \multicolumn{1}{c}{STEM}&          \multicolumn{1}{c}{selectivity}\\ "' /// 
`"&\multicolumn{1}{c}{}&\multicolumn{1}{c}{}&\multicolumn{1}{c}{} &\multicolumn{1}{c}{}&\multicolumn{1}{c}{}&\multicolumn{1}{c}{}\\ "'  )  

local variables distance_pref  STEM_pref mean_PSU_score_pref 
eststo clear
estimates clear
foreach var in `variables' {
   reg  `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if regular_application==1 & top15==1, cluster(rbd_basefinal)
   su `var' if treatment==0 & e(sample)==1
   estadd scalar MEAN=`r(mean)'
   estadd scalar RW=`rw_`var'_top15'
   estadd scalar QV=`q_`var'_top15'
   est store t15`var'
}
foreach var in `variables' {
   reg  `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if regular_application==1, cluster(rbd_basefinal)
   su `var' if treatment==0 & e(sample)==1
   estadd scalar MEAN=`r(mean)'
   estadd scalar RW=`rw_`var'_all'
   estadd scalar QV=`q_`var'_all'
   est store all`var'
}

esttab  all* t15*  using "$tables/TE_applications_assignments_top15.tex", append ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none) nolines ///
    stats(RW QV MEAN r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val" "Control mean" "R-squared" "Observations")) ///
    prehead(`"\\"' `"& \multicolumn{6}{c}{\textsc{B. Top-listed program}} \\"' `"& \multicolumn{3}{c}{All students} & \multicolumn{3}{c}{Top 15\%} \\"' `"\cmidrule{2-4} \cmidrule{5-7}"' /// 
`" & \multicolumn{1}{c}{Distance}& \multicolumn{1}{c}{STEM}& \multicolumn{1}{c}{Selectivity} & \multicolumn{1}{c}{Distance}& \multicolumn{1}{c}{STEM}& \multicolumn{1}{c}{Selectivity} \\ "' ) 

local variables distance_adm STEM_adm mean_PSU_score_adm
eststo clear
estimates clear
foreach var in `variables' {
   reg  `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if regular_application==1 & top15==1, cluster(rbd_basefinal)
   su `var' if treatment==0 & e(sample)==1
   estadd scalar MEAN=`r(mean)'
   estadd scalar RW=`rw_`var'_top15'
   estadd scalar QV=`q_`var'_top15'
   est store t15`var'
}
foreach var in `variables' {
   reg  `var' treatment simce_avg_st female age alumno_prioritario neverfailed modalidad if regular_application==1, cluster(rbd_basefinal)
   su `var' if treatment==0 & e(sample)==1
   estadd scalar MEAN=`r(mean)'
   estadd scalar RW=`rw_`var'_all'
   estadd scalar QV=`q_`var'_all'
   est store all`var'
}

esttab  all* t15*  using "$tables/TE_applications_assignments_top15.tex", append ///
    booktabs label unstack noobs keep(treatment) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none) nolines ///
    stats(RW QV MEAN r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val" "Control mean" "R-squared" "Observations")) ///
    prehead(`"\\"'  `"& \multicolumn{6}{c}{\textsc{C. Program to which admitted}} \\"' `"& \multicolumn{3}{c}{All students} & \multicolumn{3}{c}{Top 15\%} \\"' `"\cmidrule{2-4} \cmidrule{5-7}"' ///
	 		`" & \multicolumn{1}{c}{Distance}& \multicolumn{1}{c}{STEM}& \multicolumn{1}{c}{Selectivity} & \multicolumn{1}{c}{Distance}& \multicolumn{1}{c}{STEM}& \multicolumn{1}{c}{Selectivity}  \\ "') ///
    postfoot("\hline" "\end{tabular*}"  "\vspace{-0.4cm}"  "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  The coefficients are OLS estimates. Standard errors were clustered at the school level. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). {\itshape Treatment} is a dummy variable indicating whether a student is in a school randomly assigned to be in the PACE program.  The regressions use data on regular application lists to selective colleges submitted by all treated and control students (columns 1-3)  or by students in the top 15\% of their high school GPA ranking at baseline (columns 4-6). The application preference lists are the lists of programs for which the student expressed their ranked preference, up to a maximum of ten. As a measure of distance we use the length (km) of the shortest path between the coordinates of the program and the coordinates of the high school the student attended, implementing Vincenty formula to calculate distances on a reference ellipsoid. Selectivity is the average PSU score of all regular entrants in the program in 2018 (standardized).  \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the treatment effect, considering all outcomes in each sample as one family. * p$<$0.10; ** p$<$0.05; *** p$<$0.01" "\end{tablenotes}" "\end{table}") 



*******************************************************************************************
**# Table A46: Comparison between PACE and regular application lists and admissions //
*              to selective colleges for treated students in top 15% 
*******************************************************************************************
use "$dataClean/data_applications_assignments.dta", replace
merge m:1 mrun using "$dataClean/data_experimental.dta"
keep if _merge==3
drop _merge
keep if top15baseline==1
rename pace_application paceap
rename *_preferred *_pref
rename *_admitted *_adm
local allvars distance_average fraction_STEM mean_PSU_score_avg  distance_pref  STEM_pref mean_PSU_score_pref distance_adm STEM_adm mean_PSU_score_adm
local variables distance_average fraction_STEM mean_PSU_score_avg 
lab var paceap "PACE channel"
eststo clear
estimates clear
qui do "$do_files/9.fdr_sharpened_qvalues_adj.do" 
fdr_sharpened_qvalues_adj {reg distance_average paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)} {reg fraction_STEM paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)} {reg mean_PSU_score_avg paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)} {reg distance_pref paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)} {reg STEM_pref paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)} {reg mean_PSU_score_pref paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)} {reg distance_adm paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)} {reg STEM_adm paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)} {reg mean_PSU_score_adm paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)}
foreach var in `allvars' {
   local q_`var'= round(e(q_`var'_paceap), 0.001)
}
  
  rwolf2  ///
   (reg  distance_average paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)) ///
   (reg  fraction_STEM paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)) ///
   (reg  mean_PSU_score_avg paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)) ///
   (reg  distance_pref paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)) ///
   (reg  STEM_pref paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)) ///
   (reg  mean_PSU_score_pref paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)) ///
   (reg  distance_adm paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)) ///
   (reg  STEM_adm paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)) ///
   (reg  mean_PSU_score_adm paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, vce(cluster rbd_basefinal)), ///
   indepvars(paceap,paceap,paceap,paceap,paceap,paceap,paceap,paceap,paceap) ///
   seed(28052016) reps(1000)  cluster(rbd_basefinal) idcluster(newidcluster)
   foreach var in `allvars' {
      local rw_`var'= round(e(rw_`var'_paceap), 0.001)
   }

foreach var in `variables' {
   eststo: reg  `var' paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, cluster(rbd_basefinal)
   su `var' if treatment==1
   estadd scalar MEAN=`r(mean)'
   estadd scalar RW=`rw_`var''
   estadd scalar QV=`q_`var''
 *  eststo: areg `var' paceap simce_avg_st female age alumno_prioritario neverfailed modalidad  if treatment==1, cluster(rbd_basefinal) absorb(mrun)
  * su `var' if treatment==1
   *estadd scalar MEAN=`r(mean)'
}
esttab * using "$tables/differences_pace_regular_for_treated_top15.tex", replace ///
    booktabs label unstack noobs keep(paceap) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none) nolines ///
    stats(RW QV MEAN r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val" "Control mean" "R-squared" "Observations")) ///
    prehead(`"\begin{table}[H]\centering"' `"\footnotesize "' `"\centering "' ///
	 		`"\caption{\label{tab: diffapplicationsassignmentstreatedtop15} \textsc{Comparison between PACE and regular application lists and admissions to selective colleges for treated student in Top 15\%}}"' ///
	`"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{3}{c}}"' 	`"\hline \\"' `"& \multicolumn{3}{c}{\textsc{A. All listed programs}} \\"' `"\cline{2-4}"' ///
`" &   \multicolumn{1}{c}{Average}&          \multicolumn{1}{c}{Fraction}&          \multicolumn{1}{c}{Average} \\ "' /// 
`" &   \multicolumn{1}{c}{distance}&          \multicolumn{1}{c}{STEM}&                 \multicolumn{1}{c}{selectivity}\\ "' /// 
`"&\multicolumn{1}{c}{}&\multicolumn{1}{c}{}&\multicolumn{1}{c}{}\\ "'  ) 
eststo clear
estimates clear
local variables distance_pref  STEM_pref mean_PSU_score_pref 
foreach var in `variables' {
   eststo: reg  `var' paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, cluster(rbd_basefinal)
   su `var' if treatment==1
   estadd scalar MEAN=`r(mean)'
   estadd scalar RW=`rw_`var''
   estadd scalar QV=`q_`var''
 *  eststo: areg `var' paceap simce_avg_st female age alumno_prioritario neverfailed modalidad  if treatment==1, cluster(rbd_basefinal) absorb(mrun)
  * su `var' if treatment==1
   *estadd scalar MEAN=`r(mean)'
}
esttab * using "$tables/differences_pace_regular_for_treated_top15.tex", append ///
    booktabs label unstack noobs keep(paceap) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none) nolines ///
    stats(RW QV MEAN r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val" "Control mean" "R-squared" "Observations")) ///
    prehead(`"\\"' `"& \multicolumn{3}{c}{\textsc{B. Top-listed program}} \\"' `"\cline{2-4}"' /// 
`" & \multicolumn{1}{c}{Distance}& \multicolumn{1}{c}{STEM}& \multicolumn{1}{c}{Selectivity}  \\ "' ) 

eststo clear
estimates clear
local variables distance_adm STEM_adm mean_PSU_score_adm   
foreach var in `variables' {
   eststo: reg  `var' paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, cluster(rbd_basefinal)
   su `var' if treatment==1
   estadd scalar MEAN=`r(mean)'
   estadd scalar RW=`rw_`var''
   estadd scalar QV=`q_`var''
  * eststo: areg `var' paceap simce_avg_st female age alumno_prioritario neverfailed modalidad if treatment==1, cluster(rbd_basefinal) absorb(mrun)
  * su `var' if treatment==1
  * estadd scalar MEAN=`r(mean)'
}
esttab * using "$tables/differences_pace_regular_for_treated_top15.tex", append ///
    booktabs label unstack noobs keep(paceap) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    fragment nolines collabels(none) mlabels(none) nolines ///
    stats(RW QV MEAN r2 N, fmt(3 3 3 3 0) labels("RW-adj p-val" "q-val" "Control mean" "R-squared" "Observations")) ///
    prehead(`"\\"'  `"& \multicolumn{3}{c}{\textsc{C. Program to which admitted}} \\"' `"\cline{2-4}"' ///
	 		`" & \multicolumn{1}{c}{Distance}& \multicolumn{1}{c}{STEM}& \multicolumn{1}{c}{Selectivity}  \\ "') ///
	 postfoot("\hline" "\end{tabular*}" "	\begin{tablenotes}[flushleft]\singlespacing" "\small" "\item		\scriptsize \textsc{ Note.--}  The coefficients are OLS estimates. Standard errors were clustered at the school level. All regressions use the standard set of controls (see notes under Figure \ref{fig:TEovertime}). {\itshape PACE channel} is a dummy variable equal to 1 if the application (Panels A and B) or admission (Panel C) is through the PACE channel, 0 if it is through the regular channel. Within each channel, students submit ranked preference lists, and can apply to a maximum of ten programs. The regressions use data on regular and PACE selective college admissions and application lists to selective colleges, restricting the sample to students from treated schools who were in the top 15\% of their high school GPA ranking at baseline. As a measure of distance we use the length (km) of the shortest path between the coordinates of the program and of the high school the student attended, implementing Vincenty formula to calculate distances on a reference ellipsoid. Selectivity is the average PSU score of all regular entrants in the  program in 2018 (standardized).  \textit{RW-adj p-val} and \textit{q-val} indicate Romano-Wolf adjusted p-values using 1000 bootstrap replications and q-values of the pace application coefficient, considering all outcomes in the table as one family. * p$<$0.10; ** p$<$0.05; *** p$<$0.01" "\end{tablenotes}" "\end{table}") 




*******************************************************************************************
**# Table A47: Parameters estimated outside of the model, perceived PSU and GPA production 
*******************************************************************************************

use "$dataClean/data_experimental.dta", clear
keep if in_experimental_schools==1

est clear 
* 1. Estimate regressions for Table 

label var GPA_segundo "GPA in grade 10"
label var GPA_avg_1_2 "GPA in grades 9-10"
label var simce_avg_st "Simce test score in grade 10"


* Generate outcome variables: expected score (GPA, PSU) net of perceived effort impacts
gen GPAb_34=2*(exp_NEM-0.5*GPA_avg_1_2)  // We assume exp_NEM captures the expected GPA in the last 4 high school years 
										  // GPAb_34 is the believed score in years 3 and 4 of high school, from the point of view of
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





* Print Table with estimates related to PSUb and GPAb
esttab m1 m2 using "$tables/params_outside_model_PSUbGPAb.tex", replace ///
    booktabs label  ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) /// 
     collabels(none) mlabels(none)  nonumbers nobase /// * nomtitles nodep noomitted /// 
    stats( N, fmt(0) labels( "Observations" )) /// * do not show R2 because we do not care of R2 of perceived achievemends net of effort
    prehead(`"\begin{table}[H]\centering"'  `"\setlength\extrarowheight{-3pt}"'  `"\footnotesize "'  ///
	`"\begin{threeparttable}"' ///
	 `"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"' `"\caption{\label{tab:outsidePSUbGPAb} \textsc{Parameters estimated outside of the model, perceived PSU and GPA production}}"' ///
     `"\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}*{1}{l}*{2}{c}}"' `"\hline"' `"\\"' ///
		`"&  \multicolumn{1}{c}{\$PSU^{b,net}\$} & \multicolumn{1}{c}{\$GPA^{b,net}\$}   \\  "' ///
		`"& (1)                                   &           (2)                             \\"' ) ///
    postfoot("\hline" "\end{tabular*}" `"\begin{tablenotes}"' `"\singlespacing"' `"\item"' ///
             `"\setlength{\baselineskip}{0.8\baselineskip}"' `"\scriptsize"' `"\noindent"' ///
             `"\textsc{ Note.--} The Table reports OLS estimates of equations \eqref{eq:PSUboutside} and \eqref{eq:GPAboutside}. Standard errors were clustered at the school level. The outcome variables are perceived achievement outcomes, net of the measured perceived impact of effort.  * p$<$0.10; ** p$<$0.05; *** p$<$0.01"' "\end{tablenotes}" `"\end{threeparttable}"' "\end{table}") 			 
