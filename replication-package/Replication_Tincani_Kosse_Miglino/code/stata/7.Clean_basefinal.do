********************************************************************************
* DO-FILE DESCRIPTION:
* Clean all high-school data
********************************************************************************

********************************************************************************
* Clean data on experimental population 
********************************************************************************


use "$dataTemp/basefinal_merged_all.dta", clear

***Generate variables from FOCUS questions
 *** Question 1 *****

 
 generate q1=1 if (FORMA=="A1" | FORMA=="B1") & PP6==1
 replace q1=0 if (FORMA=="A1" | FORMA=="B1") & PP6!=1 & PP6!=.
 
 replace q1=1 if (FORMA=="A2" | FORMA=="B2") & PP5==1
 replace q1=0 if (FORMA=="A2" | FORMA=="B2") & PP5!=1 & PP5!=.
 
 replace q1=1 if (FORMA=="A3" | FORMA=="B3") & PP5==1
 replace q1=0 if (FORMA=="A3" | FORMA=="B3") & PP5!=1 & PP5!=.
  
 replace q1=1 if (FORMA=="A4" | FORMA=="B4") & PP6==1
 replace q1=0 if (FORMA=="A4" | FORMA=="B4") & PP6!=1 & PP6!=.
  
 replace q1=1 if (FORMA=="A5" | FORMA=="B5") & PP4==1
 replace q1=0 if (FORMA=="A5" | FORMA=="B5") & PP4!=1 & PP4!=.
  
 replace q1=1 if (FORMA=="A6" | FORMA=="B6") & PP4==1
 replace q1=0 if (FORMA=="A6" | FORMA=="B6") & PP4!=1 & PP4!=.
 
 label var q1 "which option shows graph of f(x)=x^2 (Aptus)"
 
 
 **** Question 2 *********
 
 generate q2=1 if (FORMA=="A1" | FORMA=="B1") & PP1==3
 replace q2=0 if  (FORMA=="A1" | FORMA=="B1") & PP1!=3 & PP1!=.
 
 replace q2=1 if  (FORMA=="A2" | FORMA=="B2") & PP1==3
 replace q2=0 if  (FORMA=="A2" | FORMA=="B2") & PP1!=3 & PP1!=.
 
 replace q2=1 if  (FORMA=="A3" | FORMA=="B3") & PP3==3
 replace q2=0 if  (FORMA=="A3" | FORMA=="B3") & PP3!=3 & PP3!=.
 
 replace q2=1 if  (FORMA=="A4" | FORMA=="B4") & PP2==3
 replace q2=0 if  (FORMA=="A4" | FORMA=="B4") & PP2!=3 & PP2!=.
 
 replace q2=1 if  (FORMA=="A5" | FORMA=="B5") & PP3==3
 replace q2=0 if  (FORMA=="A5" | FORMA=="B5") & PP3!=3 & PP3!=.
 
 replace q2=1 if  (FORMA=="A6" | FORMA=="B6") & PP2==3
 replace q2=0 if  (FORMA=="A6" | FORMA=="B6") & PP2!=3 & PP2!=.
 
 label var q2 "where do the two lines cross? (Aptus)"
 
 
 ******* Question 3 *******
 gen q3=1 if (FORMA=="A1" | FORMA=="B1") & PP4==2
 replace q3=0 if (FORMA=="A1" | FORMA=="B1") & PP4!=2 & PP4!=.
 
 replace q3=1 if (FORMA=="A2" | FORMA=="B2") & PP4==2
 replace q3=0 if (FORMA=="A2" | FORMA=="B2") & PP4!=2 & PP4!=.
 
 replace q3=1 if (FORMA=="A3" | FORMA=="B3") & PP6==2
 replace q3=0 if (FORMA=="A3" | FORMA=="B3") & PP6!=2 & PP6!=.
 
 replace q3=1 if (FORMA=="A4" | FORMA=="B4") & PP5==2
 replace q3=0 if (FORMA=="A4" | FORMA=="B4") & PP5!=2 & PP5!=.
 
 replace q3=1 if (FORMA=="A5" | FORMA=="B5") & PP5==2
 replace q3=0 if (FORMA=="A5" | FORMA=="B5") & PP5!=2 & PP5!=.
 
 replace q3=1 if (FORMA=="A6" | FORMA=="B6") & PP6==2
 replace q3=0 if (FORMA=="A6" | FORMA=="B6") & PP6!=2 & PP6!=.

 label var q3 "Un kg de limones (PN)"
 
 
 ******* Question 4 *******
 gen q4=1 if (FORMA=="A1" | FORMA=="B1") & PP2==4
 replace q4=0 if (FORMA=="A1" | FORMA=="B1") & PP2!=4 & PP2!=.
 
 replace q4=1 if (FORMA=="A2" | FORMA=="B2") & PP3==4
 replace q4=0 if (FORMA=="A2" | FORMA=="B2") & PP3!=4 & PP3!=.
 
 replace q4=1 if (FORMA=="A3" | FORMA=="B3") & PP1==4
 replace q4=0 if (FORMA=="A3" | FORMA=="B3") & PP1!=4 & PP1!=.
 
 replace q4=1 if (FORMA=="A4" | FORMA=="B4") & PP1==4
 replace q4=0 if (FORMA=="A4" | FORMA=="B4") & PP1!=4 & PP1!=.
 
 replace q4=1 if (FORMA=="A5" | FORMA=="B5") & PP2==4
 replace q4=0 if (FORMA=="A5" | FORMA=="B5") & PP2!=4 & PP2!=.
 
 replace q4=1 if (FORMA=="A6" | FORMA=="B6") & PP3==4
 replace q4=0 if (FORMA=="A6" | FORMA=="B6") & PP3!=4 & PP3!=.
 
 label var q4 "Un numero aumentado en 7 unidades (PN)"
 
 
 ******* Question 5 *******
 gen q5=1 if (FORMA=="A1" | FORMA=="B1") & PP3==1
 replace q5=0 if (FORMA=="A1" | FORMA=="B1") & PP3!=1 & PP3!=.
 
 replace q5=1 if (FORMA=="A2" | FORMA=="B2") & PP2==1
 replace q5=0 if (FORMA=="A2" | FORMA=="B2") & PP2!=1 & PP2!=.
 
 replace q5=1 if (FORMA=="A3" | FORMA=="B3") & PP2==1
 replace q5=0 if (FORMA=="A3" | FORMA=="B3") & PP2!=1 & PP2!=.
 
 replace q5=1 if (FORMA=="A4" | FORMA=="B4") & PP3==1
 replace q5=0 if (FORMA=="A4" | FORMA=="B4") & PP3!=1 & PP3!=.
 
 replace q5=1 if (FORMA=="A5" | FORMA=="B5") & PP1==1
 replace q5=0 if (FORMA=="A5" | FORMA=="B5") & PP1!=1 & PP1!=.
 
 replace q5=1 if (FORMA=="A6" | FORMA=="B6") & PP1==1
 replace q5=0 if (FORMA=="A6" | FORMA=="B6") & PP1!=1 & PP1!=.
 
 label var q5 "De los resultados (topic: complex numbers) (Aptus)"
 
 
 ******* Question 6 (order was not ra domised, it is always the last question = pp9) *******
 gen q6=1 if PP9==5
 replace q6=0 if PP9!=5 & PP9!=.
 label var q6 "Se reparte un premio entre 4 mujeres (PN)"
 
 
 ******* Question 7 (order was not randomised, it is always question pp7) *******
 gen q7=1 if PP7==5
 replace q7=0 if PP7!=5 & PP7!=.
 label var q7 "Bernadita compra un televisor (PN)"
 
 
 ******* Question 8 *******
 gen q8=1 if (FORMA=="A1" | FORMA=="B1") & PP5==4
 replace q8=0 if (FORMA=="A1" | FORMA=="B1") & PP5!=4 & PP5!=.
 
 replace q8=1 if (FORMA=="A2" | FORMA=="B2") & PP6==4
 replace q8=0 if (FORMA=="A2" | FORMA=="B2") & PP6!=4 & PP6!=.
 
 replace q8=1 if (FORMA=="A3" | FORMA=="B3") & PP4==4
 replace q8=0 if (FORMA=="A3" | FORMA=="B3") & PP4!=4 & PP4!=.
 
 replace q8=1 if (FORMA=="A4" | FORMA=="B4") & PP4==4
 replace q8=0 if (FORMA=="A4" | FORMA=="B4") & PP4!=4 & PP4!=.
 
 replace q8=1 if (FORMA=="A5" | FORMA=="B5") & PP6==4
 replace q8=0 if (FORMA=="A5" | FORMA=="B5") & PP6!=4 & PP6!=.
 
 replace q8=1 if (FORMA=="A6" | FORMA=="B6") & PP5==4
 replace q8=0 if (FORMA=="A6" | FORMA=="B6") & PP5!=4 & PP5!=.
 
 label var q8 "En una fiesta de cupleanos (topic = probability) (PN)"
 
 
 ******* Question 9 (order was not ra domised, it is always question pp8) *******
 gen q9=1 if PP8==2
 replace q9=0 if PP8!=2 & PP8!=.
 label var q9 "Dada la siguiente ecaucion (topic: second degree equations) (Aptus)"
 
 
 *** generate overall raw score
 gen score_nonmissing=q1+q2+q3+q4+q5+q6+q7+q8+q9
 label var score_nonmissing "tot score, if at least one missing answer, tot score is missing"
 egen score=rowtotal(q1 q2 q3 q4 q5 q6 q7 q8 q9), missing 
 * gives a missing score only if someone does not reply to ANY question, otherwise it treats missing answers as a 0
 label var score "tot score, missing values counted as 0s unless all missing"
 egen score_st=std(score)
 lab var score_st "FOCUS Score (standardized, counting missing as 0 unless all missing)"
 
 gen score_all=score
 replace score_all=0 if score==. & in_sample==1 & rbd_basefinal!=9986 // the surveys of this school went lost
 *score_all gives zero to a missing score if the student was in the August sample  
 label var score_all "tot score, all missing values counted as 0s"
 egen score_all_st=std(score_all)
 lab var score_all_st "FOCUS Score (standardized, counting missing as 0)"

 
 
 *** Now we assign a 0 to missing values
 *** Question 1 *****
 
 generate qq1=1 if (FORMA=="A1" | FORMA=="B1") & PP6==1
 replace qq1=0 if (FORMA=="A1" | FORMA=="B1") & PP6!=1 & in_sample==1 & rbd_basefinal!=9986 
 
 replace qq1=1 if (FORMA=="A2" | FORMA=="B2") & PP5==1
 replace qq1=0 if (FORMA=="A2" | FORMA=="B2") & PP5!=1 & in_sample==1 & rbd_basefinal!=9986 
 
 replace qq1=1 if (FORMA=="A3" | FORMA=="B3") & PP5==1
 replace qq1=0 if (FORMA=="A3" | FORMA=="B3") & PP5!=1 & in_sample==1 & rbd_basefinal!=9986
  
 replace qq1=1 if (FORMA=="A4" | FORMA=="B4") & PP6==1
 replace qq1=0 if (FORMA=="A4" | FORMA=="B4") & PP6!=1 & in_sample==1 & rbd_basefinal!=9986
  
 replace qq1=1 if (FORMA=="A5" | FORMA=="B5") & PP4==1
 replace qq1=0 if (FORMA=="A5" | FORMA=="B5") & PP4!=1 & in_sample==1 & rbd_basefinal!=9986
  
 replace qq1=1 if (FORMA=="A6" | FORMA=="B6") & PP4==1
 replace qq1=0 if (FORMA=="A6" | FORMA=="B6") & PP4!=1 & in_sample==1 & rbd_basefinal!=9986
 
 label var qq1 "which option shows graph of f(x)=x^2 (Aptus)"

 
 **** QUestion 2 *********
 
 generate qq2=1 if (FORMA=="A1" | FORMA=="B1") & PP1==3
 replace qq2=0 if  (FORMA=="A1" | FORMA=="B1") & PP1!=3 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq2=1 if  (FORMA=="A2" | FORMA=="B2") & PP1==3
 replace qq2=0 if  (FORMA=="A2" | FORMA=="B2") & PP1!=3 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq2=1 if  (FORMA=="A3" | FORMA=="B3") & PP3==3
 replace qq2=0 if  (FORMA=="A3" | FORMA=="B3") & PP3!=3 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq2=1 if  (FORMA=="A4" | FORMA=="B4") & PP2==3
 replace qq2=0 if  (FORMA=="A4" | FORMA=="B4") & PP2!=3 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq2=1 if  (FORMA=="A5" | FORMA=="B5") & PP3==3
 replace qq2=0 if  (FORMA=="A5" | FORMA=="B5") & PP3!=3 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq2=1 if  (FORMA=="A6" | FORMA=="B6") & PP2==3
 replace qq2=0 if  (FORMA=="A6" | FORMA=="B6") & PP2!=3 & in_sample==1 & rbd_basefinal!=9986
 
 label var qq2 "where do the two lines cross? (Aptus)"
 
 
 ******* Question 3 *******
 gen qq3=1 if (FORMA=="A1" | FORMA=="B1") & PP4==2
 replace qq3=0 if (FORMA=="A1" | FORMA=="B1") & PP4!=2 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq3=1 if (FORMA=="A2" | FORMA=="B2") & PP4==2
 replace qq3=0 if (FORMA=="A2" | FORMA=="B2") & PP4!=2 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq3=1 if (FORMA=="A3" | FORMA=="B3") & PP6==2
 replace qq3=0 if (FORMA=="A3" | FORMA=="B3") & PP6!=2 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq3=1 if (FORMA=="A4" | FORMA=="B4") & PP5==2
 replace qq3=0 if (FORMA=="A4" | FORMA=="B4") & PP5!=2 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq3=1 if (FORMA=="A5" | FORMA=="B5") & PP5==2
 replace qq3=0 if (FORMA=="A5" | FORMA=="B5") & PP5!=2 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq3=1 if (FORMA=="A6" | FORMA=="B6") & PP6==2
 replace qq3=0 if (FORMA=="A6" | FORMA=="B6") & PP6!=2 & in_sample==1 & rbd_basefinal!=9986
 
 label var qq3 "Un kg de limones (PN)"
 
 
 
 ******* Question 4 *******
 gen qq4=1 if (FORMA=="A1" | FORMA=="B1") & PP2==4
 replace qq4=0 if (FORMA=="A1" | FORMA=="B1") & PP2!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq4=1 if (FORMA=="A2" | FORMA=="B2") & PP3==4
 replace qq4=0 if (FORMA=="A2" | FORMA=="B2") & PP3!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq4=1 if (FORMA=="A3" | FORMA=="B3") & PP1==4
 replace qq4=0 if (FORMA=="A3" | FORMA=="B3") & PP1!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq4=1 if (FORMA=="A4" | FORMA=="B4") & PP1==4
 replace qq4=0 if (FORMA=="A4" | FORMA=="B4") & PP1!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq4=1 if (FORMA=="A5" | FORMA=="B5") & PP2==4
 replace qq4=0 if (FORMA=="A5" | FORMA=="B5") & PP2!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq4=1 if (FORMA=="A6" | FORMA=="B6") & PP3==4
 replace qq4=0 if (FORMA=="A6" | FORMA=="B6") & PP3!=4 & in_sample==1 & rbd_basefinal!=9986
 
 label var qq4 "Un numero aumentado en 7 unidades (PN)"
  
 
 ******* Question 5 *******
 gen qq5=1 if (FORMA=="A1" | FORMA=="B1") & PP3==1
 replace qq5=0 if (FORMA=="A1" | FORMA=="B1") & PP3!=1 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq5=1 if (FORMA=="A2" | FORMA=="B2") & PP2==1
 replace qq5=0 if (FORMA=="A2" | FORMA=="B2") & PP2!=1 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq5=1 if (FORMA=="A3" | FORMA=="B3") & PP2==1
 replace qq5=0 if (FORMA=="A3" | FORMA=="B3") & PP2!=1 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq5=1 if (FORMA=="A4" | FORMA=="B4") & PP3==1
 replace qq5=0 if (FORMA=="A4" | FORMA=="B4") & PP3!=1 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq5=1 if (FORMA=="A5" | FORMA=="B5") & PP1==1
 replace qq5=0 if (FORMA=="A5" | FORMA=="B5") & PP1!=1 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq5=1 if (FORMA=="A6" | FORMA=="B6") & PP1==1
 replace qq5=0 if (FORMA=="A6" | FORMA=="B6") & PP1!=1 & in_sample==1 & rbd_basefinal!=9986
 
 label var qq5 "De los resultados (topic: complex numbers) (Aptus)"
 
 
 ******* Question 6 (order was not randomised, it is always the last question = pp9) *******
 gen qq6=1 if PP9==5
 replace qq6=0 if PP9!=5 & in_sample==1 & rbd_basefinal!=9986
 label var qq6 "Se reparte un premio entre 4 mujeres (PN)"
 
 
 ******* Question 7 (order was not ra domised, it is always question pp7) *******
 gen qq7=1 if PP7==5
 replace qq7=0 if PP7!=5 & in_sample==1 & rbd_basefinal!=9986
 label var qq7 "Bernadita compra un televisor (PN)"
 
 
 ******* Question 8 *******
 gen qq8=1 if (FORMA=="A1" | FORMA=="B1") & PP5==4
 replace qq8=0 if (FORMA=="A1" | FORMA=="B1") & PP5!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq8=1 if (FORMA=="A2" | FORMA=="B2") & PP6==4
 replace qq8=0 if (FORMA=="A2" | FORMA=="B2") & PP6!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq8=1 if (FORMA=="A3" | FORMA=="B3") & PP4==4
 replace qq8=0 if (FORMA=="A3" | FORMA=="B3") & PP4!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq8=1 if (FORMA=="A4" | FORMA=="B4") & PP4==4
 replace qq8=0 if (FORMA=="A4" | FORMA=="B4") & PP4!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq8=1 if (FORMA=="A5" | FORMA=="B5") & PP6==4
 replace qq8=0 if (FORMA=="A5" | FORMA=="B5") & PP6!=4 & in_sample==1 & rbd_basefinal!=9986
 
 replace qq8=1 if (FORMA=="A6" | FORMA=="B6") & PP5==4
 replace qq8=0 if (FORMA=="A6" | FORMA=="B6") & PP5!=4 & in_sample==1 & rbd_basefinal!=9986
 
 label var qq8 "En una fiesta de cupleanos (topic = probability) (PN)"
 
 
 ******* Question 9 (order was not randomised, it is always question pp8) *******
 gen qq9=1 if PP8==2
 replace qq9=0 if PP8!=2 & in_sample==1 & rbd_basefinal!=9986
 label var qq9 "Dada la siguiente ecaucion (topic: second degree equations) (Aptus)"
 
 alpha qq1 qq2 qq3 qq4 qq5 qq6 qq7 qq8 qq9, asis detail
 
 
 ** generate IRT score
 irt 1pl qq1-qq9 
  * to predict latent trait
 predict score_irt_1p if in_sample==1 & rbd_basefinal!=9986, latent
 label var score_irt_1p "Predicted math achievement using 1parameter IRT model"

 
 *to plot the ICCs for all items and visualze the item locations on the difficulty spectrum:
 * irtgraph icc, blocation legend(off) xlabel(,alt)
 * to plot sum of probabilities of correct answer as a function of ability: 
*  irtgraph tcc


 
 estimates store onep
 
 ** now fit a two parameter model
 irt 2pl qq1-qq9 
 predict score_irt_2p if in_sample==1 & rbd_basefinal!=9986, latent
 label var score_irt_2p "Predicted math achievement using 2parameter IRT model (preferred to 1pl)"
 estimates store twop
 * now do a likelihood ratio test to see which one of the two models fits better
 lrtest onep .
 
 *The near-zero significance level favors the model that allows for a separate discrimination parameter for each item.
 * therefore, we will use predictions from this model as our measure of the latent mathematics achievement
 
 * plot an item information function, which plots ampunt of information an item provides for estimating a latent trait as a function o the latent trait
 irtgraph iif, legend(pos(1) col(1) ring(0))
 * then sum up all tjhe separate item information functions to obtain a test information function (TIF):
 irtgraph tif, se
 * the test provides maximum information for the persons locates approximately at theta=0.5. As we move away from that point in either direction, the standard error of the TIFincreases, and the instrument provides less information about theta

 
 ** three parameter logisitc model: items are assumed to vary in discrimination and difficulty, like in a 2pl model, but additionally, the model accomopdates the possibility of guessing on a test
 irt 3pl qq1-qq9 
 predict score_irt_3p if in_sample==1 & rbd_basefinal!=9986, latent
 label var score_irt_3p "Predicted math achievement using 2parameter IRT model (preferred)"
 estimates store threep
 
 lrtest twop .
  
 * likelihood ratio test favours the three parameter model

 egen score_irt_st=std(score_irt_3p)
 lab var score_irt_st "FOCUS Score graded with IRT 3pl (standardized, counting missing as 0)"
 
 *Generate percentiles in math simce score
 sort rbd_basefinal LETRA ptje_mate2m_alu 
 by rbd_basefinal LETRA: gen order=_n
 by rbd_basefinal LETRA: gen tot_size=_N
 gen math_percentile=_n/_N
 
 gen top_third_math=1 if math_percentile>=0.66 & math_percentile!=.
 replace top_third_math=0 if math_percentile<0.66
 
 gen bottom_third_math=1 if math_percentile<=0.33 
 replace bottom_third_math=0 if math_percentile>0.33 & math_percentile!=.
 
 gen middle_third_math=1
 replace middle_third_math=0 if bottom_third_math==1 | top_third_math==1
 replace middle_third_math=. if top_third_math==.
 
 egen mate_st=std(ptje_mate2m_alu)
 egen lect_st=std(ptje_lect2m_alu)
 label var mate_st "baseline math (standardised, SIMCE)"
 label var lect_st "baseline spanish (standardised, SIMCE)"

 saveold "$dataTemp/with_irt_basefinal_merged_all.dta", replace
 use "$dataTemp/with_irt_basefinal_merged_all.dta", clear

 ********************************************************************
 
***Generate other variables for a clearer interpretation 

gen hours_study=P9
gen days_study_test=P10

gen aware_waiver=1 if P72==1
replace aware_waiver=0 if P72==2
drop P72


gen p_admitted=1 if P29==5
replace p_admitted=0.75 if P30==4
replace p_admitted=0.5 if P30==3
replace p_admitted=0.25 if P30==2
replace p_admitted=0 if P30==1
gen p_graduate=1 if P31==5
replace p_graduate =0.75 if P31==4
replace p_graduate =0.50 if P31==3
replace p_graduate =0.25 if P31==2
replace p_graduate =0 if P31==1



egen p_admitted_st=std(P30)

gen exp_PSUscore=775 if P39==1
replace exp_PSUscore=650 if P39==2
replace exp_PSUscore=525 if P39==3
replace exp_PSUscore=400 if P39==4
replace exp_PSUscore=300 if P39==5
replace exp_PSUscore=200 if P39==6

sum exp_PSU*

gen hours_study_PSU600=P40
gen hours_study_PSU450=P41
gen hours_study_PSU350=P42

gen NEM_top15_August=P46
replace NEM_top15_August=NEM_top15_August/100 if NEM_top15_August>99 & NEM_top15_August<701 // missing "." for decimals in some answers
replace NEM_top15_August=. if NEM_top15_August<1 | NEM_top15_August>7
replace NEM_top15_April=NEM_top15_April/100 if NEM_top15_April>99 & NEM_top15_April<701
replace NEM_top15_April=. if NEM_top15_April<1 | NEM_top15_April>7
gen NEM_top15=NEM_top15_August
replace NEM_top15=NEM_top15_April if NEM_top15_August==. // if expected NEM is missing in August questionnaire, use expected NEM in April questionnaire

gen exp_NEM=P52
replace exp_NEM=exp_NEM/100 if exp_NEM>99 & exp_NEM<701
replace exp_NEM=. if exp_NEM<1 | exp_NEM>7
gen hours_to_be_top15=P53
gen hours_to_have_NEM55=P54



bysort rbd_basefinal (score_st) : egen school_size_focus=count(score_st) //generate size of school, excluding students with missing score
bysort rbd_basefinal (score_st) : gen actual_rank_focus=40*((school_size_focus-_n)/school_size_focus)+1 if score_st!=.



*Generate variables for types of school and classes
gen M=1 if cod_depe2==1 | cod_depe2==4
replace M=0 if M==. & cod_depe2!=.
gen V=1 if cod_depe2==2
replace V=0 if cod_depe2!=2 & cod_depe2!=.
gen U=1 if cod_depe2==3
label var U "Unsubsidized from matricula 2017"
label var M "Municipal from matricula 2017"
label var V "Voucher from matricula 2017"
count if V==.
drop V //drop V as always missing or 0
drop  cod_depe2

*label var modalidad "=1 if HC, =0 if TP, from basefinal"
label var modalidad "Academic"
label define modalidad 0 "Vocational" 1 "Academic"
label values modalidad modalidad

*Generate variable for schools with both TP and HC classes
egen modalidad_average=mean(modalidad), by(rbd_basefinal)
gen both_modalidad=0 if modalidad_average==1 | modalidad_average==0
replace both_modalidad=1 if modalidad_average>0 & modalidad_average<1 
gen HConly=0 if (modalidad!=. & both_modalidad!=.)
replace HConly=1 if (modalidad==1 & both_modalidad==0)
lab var HConly "Academic in academic only schools"
gen HCmixed=0 if (modalidad!=. & both_modalidad!=.)
replace HCmixed=1 if (modalidad==1 & both_modalidad==1)
lab var HCmixed "Academic in mixed schools"
gen TPonly=0 if (modalidad!=. & both_modalidad!=.)
replace TPonly=1 if (modalidad==0 & both_modalidad==0)
lab var TPonly "Vocational in vocational only schools"
gen TPmixed=0 if (modalidad!=. & both_modalidad!=.)
replace TPmixed=1 if (modalidad==0 & both_modalidad==1)
lab var TPmixed "Vocational in mixed schools"

*Generate school ranking by simce (not imputed)
preserve
gen simce_avg=(ptje_lect2m_alu + ptje_mate2m_alu)/2
label var simce_avg "SIMCE score"
keep if simce_avg!=.
bysort rbd_basefinal (simce_avg): gen order_simce=_n
bysort rbd_basefinal: gen tot_size_school=_N 
gen temp_rank=order_simce/tot_size_school
bysort rbd_basefinal simce_avg: egen ranking_school_simce=max(temp_rank)
drop temp_rank
label var ranking_school_simce "ranking in school based on simce data"
keep mrun ranking_school_simce
saveold "$dataTemp/temp.dta", replace
restore
merge 1:1 mrun using "$dataTemp/temp.dta", nogen

capture erase "$dataTemp/temp.dta"


*Generate average school GPA in primero and segundo medio
egen GPA_avg_1_2= rowmean(GPA_primero_medio GPA_segundo_medio)
lab var GPA_avg_1_2 "Student's average GPA in primero and segundo medio"
bys rbd_basefinal: egen GPA_avg_school_1_2=mean(GPA_avg_1_2)
lab var GPA_avg_school_1_2 "School average GPA in primero and segundo medio"

*Generate school ranking by GPA_segundo_medio
preserve
keep if GPA_segundo_medio!=.
bysort rbd_basefinal (GPA_segundo_medio) : gen order_GPA_segundo_medio=_n 
bysort rbd_basefinal: gen tot_size_school=_N 
label var tot_size_school "Number of students in school in 2017 with nonmissing GPA in segundo medio"
gen temp=order_GPA_segundo_medio/tot_size_school
bysort rbd_basefinal GPA_segundo_medio: egen ranking_school_GPA_segundo_medio=max(temp) // if there are multiple students with the same GPA set the highest percentile among them for all
label var ranking_school_GPA_segundo_medio "ranking in school based on GPA in segundo medio"
drop tot_size_school temp
drop order_GPA_segundo_medio
saveold "$dataTemp/temp.dta", replace
restore
merge 1:1 mrun using "$dataTemp/temp.dta", nogen

capture erase  "$dataTemp/temp.dta"

*Generate school ranking by GPA_avg_1_2
preserve
keep if GPA_avg_1_2!=.
bysort rbd_basefinal (GPA_avg_1_2) : gen order_GPA_avg_1_2=_n 
bysort rbd_basefinal: gen tot_size_school=_N 
label var tot_size_school "Number of students in school in 2017 with nonmissing GPA in segundo or primero medio"
gen temp=order_GPA_avg_1_2/tot_size_school
bysort rbd_basefinal GPA_avg_1_2: egen ranking_school_GPA_avg_1_2=max(temp) // if there are multiple students with the same GPA set the highest percentile among them for all
label var ranking_school_GPA_avg_1_2 "ranking in school based on avg GPA in primero and segundo medio"
drop tot_size_school temp
drop order_GPA_avg_1_2
saveold "$dataTemp/temp.dta", replace
restore
merge 1:1 mrun using "$dataTemp/temp.dta", nogen

capture erase  "$dataTemp/temp.dta"



*Generate school ranking by GPA_cuarto_medio
preserve
keep if GPA_cuarto_medio!=.
bysort rbd_basefinal (GPA_cuarto_medio) : gen order_GPA_cuarto_medio=_n 
bysort rbd_basefinal: gen tot_size_school=_N 
label var tot_size_school "Number of students in school in 2017 with nonmissing GPA in cuarto medio"
gen temp=order_GPA_cuarto_medio/tot_size_school
bysort rbd_basefinal GPA_cuarto_medio: egen ranking_school_GPA_cuarto_medio=max(temp) // if there are multiple students with the same GPA set the highest percentile among them for all
label var ranking_school_GPA_cuarto_medio "ranking in school based on GPA in cuarto medio"
drop tot_size_school temp
drop order_GPA_cuarto_medio
saveold "$dataTemp/temp.dta", replace
restore
merge 1:1 mrun using "$dataTemp/temp.dta", nogen

capture erase  "$dataTemp/temp.dta"

*Generate school size
bysort rbd_basefinal: gen tot_size_school=_N 
label var tot_size_school "School size according to matricula 2017"

*Generate variable for failing segundo medio
gen neverfailed=1 if year_secundo_medio==2015
replace neverfailed=0 if year_secundo_medio<2015 & year_secundo_medio!=.
lab var neverfailed "Never failed a year"

*Generate GPA_segundo_medio in school quintiles
xtile GPArank_quintile= ranking_school_GPA_segundo_medio, n(5)
tab GPArank_quintile, gen(GPArank_quint_)
forvalues n=1(1)5 {
lab var GPArank_quint_`n' "GPA quintile `n'"
gen TxGPArank_quint_`n'=treatment*GPArank_quint_`n'
lab var TxGPArank_quint_`n' "PACE*GPA quintile `n'"
}

** generate class code
egen class_code=group(rbd_basefinal let_cur modalidad)
replace class_code=. if let_cur=="" | modalidad==.

*Generate simce, imputing using GPA
gen simce_avg=(ptje_lect2m_alu + ptje_mate2m_alu)/2
label var simce_avg "SIMCE score"
set matsize 800
regress simce_avg GPA_segundo_medio i.class_code i.age 
predict simce_avg_imputed
replace simce_avg=simce_avg_imputed if simce_avg==.
drop simce_avg_imputed
gen simce_avg_st=(simce_avg-258.95715)/52.253445 // standardize simce using data on population enrolled in 11th grade in tercero medio in high school in 2016 (see above)
lab var simce_avg_st "Simce score (standardized)"
*Generate GPA cuarto medio variables (from Rendimiento 2017 dataset)
lab var GPA_cuarto_medio "GPA in cuarto medio"
lab var GPA_tercero_medio "GPA in tercero medio"
corr GPA_cuarto score_irt_st if treatment==0 //33% correlation between FOCUS score and final GPA in control schools
egen GPA_cuarto_medio_st=std(GPA_cuarto_medio)
lab var GPA_cuarto_medio_st "GPA in cuarto medio (std)"
regress GPA_cuarto_medio_st score_irt_st if in_experimental_schools==1
predict res_GPA_score if in_experimental_schools==1 , residuals 
lab var res_GPA_score "Residual GPA on FOCUS score"


*Label variables with short labels for the regression tables
lab var female "Female"
lab var age "Age (years)"
label var fec_nac_alu "Date of birth"
lab var alumno_prioritario "Alumno prioritario"
lab var meduc "Mother education (years)"
lab var peduc "Father education (years)"
lab var hh_income "Household income"
lab var hours_study "hours of study per week (outside classes) in the first semester"
lab var days_study_test "number of days start studying before a test"
lab var p_graduate "probability of graduating if admitted to university"
lab var expearn_nouni "Expected earnings at 30 if not graduated (million CLP)"
lab var expearn_uni "Expected earnings at 30 if graduated (million CLP)"
lab var expearn_nouni_est "Estimated expected earnings at 30 if not graduated (million pesos)"
lab var expearn_uni_est "Estimated expected earnings at 30 if graduated (million pesos)"
lab var exp_var_nouni "Variance of earnings if not graduated (million CLP)"
lab var exp_var_uni "Variance of earnings if graduated (million CLP)"
lab var exp_PSUscore "Expected PSU score"
lab var hours_study_PSU600 "expected hours of study needed to obtain 600 points or more in the PSU"
lab var hours_study_PSU450 "expected hours of study needed to obtain 450 points or more in the PSU"
lab var hours_study_PSU350 "expected hours of study needed to obtain 350 points or more in the PSU"
lab var NEM_top15 "expected 15th percentile NEM in school"
lab var exp_NEM "expected own NEM"
lab var hours_to_be_top15 "expected hours needed to have NEM among the top 15 percent in school"
lab var hours_to_have_NEM55 "expected hours needed to have NEM of at least 5.5"
lab var both_modalidad "Schools with both TP and HC classes"
lab var GPA_segundo_medio "GPA in segundo medio"


* keep original variables for all, including inconsistent ones
gen hours_study_PSU600_raw=hours_study_PSU600
label var hours_study_PSU600_raw "Keeps inconsistent survey answers"
gen hours_study_PSU450_raw=hours_study_PSU450
label var hours_study_PSU450_raw "Keeps inconsistent survey answers"
gen hours_study_PSU350_raw=hours_study_PSU350
label var hours_study_PSU350_raw "Keeps inconsistent survey answers"
gen hours_to_be_top15_raw=hours_to_be_top15
label var hours_to_be_top15_raw "Keeps inconsistent survey answers"
gen hours_to_have_NEM55_raw=hours_to_have_NEM55
label var hours_to_have_NEM55_raw "Keeps inconsistent survey answers"

*create distance from PACE universities variables
su distance_cruch_pace,d
gen short_dist_cruch=1 if distance_cruch_pace!=. & distance_cruch_pace <r(p50) /*below median distance from PACE Academic HEI*/ 
replace short_dist_cruch =0 if distance_cruch_pace!=. & distance_cruch_pace >=r(p50) /*above median distance from PACE Academic HEI*/ 
label var short_dist_cruch "Close to PACE academic HEI"
label define short_dist_cruch 0 "Far from PACE academic HEI" 1 "Close to PACE academic HEI"
gen Txshort_dist_cruch=treatment *short_dist_cruch
lab var Txshort_dist_cruch "PACE*Close to PACE academic HEI"
su distance_vocational_pace,d
gen short_dist_vocational=1 if distance_vocational_pace!=. & distance_vocational_pace <r(p50) /*below median distance from PACE vocational HEI*/ 
replace short_dist_vocational =0 if distance_vocational_pace!=. & distance_vocational_pace >=r(p50) /*above median distance from PACE vocational HEI*/
label var short_dist_vocational "Close to PACE vocational HEI"
label define short_dist_vocational 0 "Far from PACE vocational HEI" 1 "Close to PACE vocational HEI"
gen Txshort_dist_vocational=treatment *short_dist_vocational
lab var Txshort_dist_vocational "PACE*Close to PACE vocational HEI"
su distance_any_pace,d
gen short_dist_any=1 if distance_any_pace!=. & distance_any_pace <r(p50) /*below median distance from any PACE HEI*/
replace short_dist_any =0 if distance_any_pace!=. & distance_any_pace >=r(p50) /*above median distance from any PACE HEI*/
label var short_dist_any "Close to PACE HEI"
label define short_dist_any 0 "Far from PACE HEI" 1 "Close to PACE HEI"
gen Txshort_dist_any=treatment *short_dist_any 
lab var Txshort_dist_any "PACE*Close to PACE HEI"

***Biases on cutoff GPA and own GPA
 
gen bias_top15=NEM_top15-actual_top15_cutoff
 
label var bias_top15 "Expected minus actual GPA top 15 in cuarto medio"
 
gen bias_own_NEM=exp_NEM-GPA_cuarto_medio
label var bias_own_NEM "Expected minus actual own GPA in cuarto medio"


bysort rbd_basefinal (GPA_cuarto_medio) : egen school_size_GPA_cuarto=count(GPA_cuarto_medio)
bysort rbd_basefinal (GPA_cuarto_medio) : gen percentile_GPA_cuarto=100*((school_size_GPA_cuarto-_n)/school_size_GPA_cuarto)+1 if GPA_cuarto_medio!=.


*Variables on effort
egen hours_study_st=std(hours_study)
egen days_study_test_st=std(days_study_test)
egen take_notes_st=std(P4)
lab var take_notes_st "Take notes in class (std)"
egen participate_st=std(P5)
lab var participate_st "Participate in class (std)"
egen homework_in_time_st=std(P6)
lab var homework_in_time_st "Homework in time (std)"
egen attention_st=std(P7)
lab var attention_st "Paying attention in class (std)"
egen questions_st=std(P8)
lab var questions_st "Asking questions in class (std)"
lab var rural "Rural"

* Generate santiago variable
gen santiago=1 if cod_reg_rbd==13
replace santiago=0 if cod_reg_rbd!=. & cod_reg_rbd!=13
lab var santiago "School in Santiago region"



merge 1:1 mrun using "$dataTemp/D_MATRICULA_PSU_2018_PRIV_uniqueMRUN.dta"  
* dataset of enrollments to SUA universities
* D_MATRICULA_PSU_2018_PRIV_uniqueMRUN is generated in the do-file "Generate_applic_admi_uni_selectivity" from D_MATRICULA_PSU_2018_PRIV_MRUN.csv 
* We dropped 5 observations who enrolled both through PACE and through regular channel and kept their pace enrollment to obtain a dataset with unique mrun
drop if _merge == 2
gen enrolled=1 if _merge==3
replace enrolled = 0 if _merge==1
drop _merge

rename enrolled enrolled_SUA
label var enrolled_SUA "Enrolled in selective uni (SUA) via any channel"

rename preferencia preferencia_anychannel
label var preferencia_anychannel "Preferential order of SUA uni to which enrolled through regular or PACE channel, 1=top choice"



gen enrolled_SUA_pace=1 if via_ingreso==3
replace enrolled_SUA_pace=0 if enrolled_SUA_pace==.
label var enrolled_SUA_pace "Enrolled in SUA through PACE"

gen enrolled_SUA_regular=1 if enrolled_SUA==1 & (via_ingreso==1 | via_ingreso==2)
replace enrolled_SUA_regular=0 if enrolled_SUA==0 | (enrolled_SUA==1 & via_ingreso==3)

 



label var enrolled_SUA_regular "Enrolled in selective uni (SUA) via regular channel"

*** merge in quality of university/major in which enrolled

replace sigla_universidad="UACH" if sigla_universidad=="UACh"
replace sigla_universidad="UPA" if sigla_universidad=="UPLA"
merge m:1 sigla_universidad codigo_carrera using "$dataTemp/mean_psu_score_unimajor_level.dta"
drop if _merge==2
drop _merge

label var mean_PSU_score_uni "average PSU score of regular entrants in SUA uni in which enrolled, regardless of channel"
label var min_PSU_score_uni "min PSU score of regular entrants in SUA uni in which enrolled, regardless of channel"
label var mean_PSU_score_uni_major "average PSU score of regular entrants in SUA uni-major in which enrolled, regardless of channel"
label var min_PSU_score_uni_major "min PSU score of regular entrants in SUA uni-major in which enrolled, regardless of channel"





*** merge in PSU scores
merge 1:1 mrun using "$dataTemp/A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN.dta", keepusing (lyc_actual mate_actual hycs_actual ciencias_actual promlm_actual ptje_ranking)
gen enrolled_to_take_PSU=1 if _merge==3
replace enrolled_to_take_PSU=0 if _merge==1
drop if _merge==2
drop _merge
label var enrolled_to_take_PSU "Registered to take PSU"

destring promlm_actual, replace dpcomma
destring lyc_actual, replace dpcomma
destring mate_actual, replace dpcomma
destring hycs_actual, replace dpcomma
destring ciencias_actual, replace dpcomma
replace ptje_ranking=. if ptje_ranking==0    // It is 0 "by default", so set to missing

gen sit_PSU=1 if enrolled_to_take_PSU ==1 & promlm_actual!=0
replace sit_PSU=0 if enrolled_to_take_PSU==0 | promlm_actual==0
label var sit_PSU "Registered and sat PSU exam"

gen PSU_score_if_positive=promlm_actual if promlm_actual!=0
replace enrolled_to_take_PSU=0 if promlm_actual==0   
label var PSU_score_if_positive "PSU score conditional on sitting exam"



gen PSU_math_score_if_positive=mate_actual if mate_actual!=0
label var PSU_math_score_if_positive "PSU Math score conditional on doing this part of exam"


gen PSU_span_score_if_positive=lyc_actual if lyc_actual!=0
label var PSU_span_score_if_positive "PSU Span score conditional on doing this part of exam"


 ** merge in whether they were offered a cupo pace
 merge 1:1 mrun using "$dataTemp/archivio_E_PACE_MRUN.dta", keepusing(habilitado)
 tab _merge
 drop if _merge==2
 destring habilitado, dpcomma replace
 gen offered_pace=1 if habilitado==1
 replace offered_pace=0 if offered_pace==.
 
 
 
 drop _merge habilitado
 
 ** merge in whether they got at least one admission through the regular channel
 merge 1:1 mrun using "$dataTemp/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_uniqueMRUN_admitted.dta", keepusing(admitted admitted_waiting_list)
 gen applied_SUA_regular=0 if _merge==1
 replace applied_SUA_regular=1 if _merge==3
 replace applied_SUA_regular=0 if sit_PSU==0    // we replace for only 9 observations: students cannot apply if they haven't sat the PSU
 label var applied_SUA_regular "Applied to SUA through regular channel"
 drop if _merge==2
 drop _merge
 
 rename admitted admitted_SUA
 replace admitted_SUA=1 if via_ingreso==2 // only 2 changes made

 * for those who are not in the list of applicants through the regular channel, they can't be admitted through regular channel
 replace admitted_SUA=0 if applied_SUA_regular==0
 replace admitted_waiting_list=0 if applied_SUA_regular==0
 
 gen admitted_regular_or_pace=1 if admitted_SUA==1 | offered_pace==1
 replace admitted_regular_or_pace=0 if admitted_SUA==0 & offered_pace==0
 
 label var admitted_regular_or_pace "Admitted to SUA  via regular channel or via PACE channel"
 
 rename admitted_SUA admitted_SUA_regular
 rename admitted_regular_or_pace admitted_SUA_regular_or_pace
 
 replace enrolled_SUA=0 if admitted_SUA_regular==0 & admitted_waiting_list==0 & enrolled_SUA_regular==1 & enrolled_SUA_pace==0
 replace enrolled_SUA_regular=0 if admitted_SUA_regular==0 & admitted_waiting_list==0 & enrolled_SUA_regular==1
 replace admitted_SUA_regular=1 if admitted_SUA_regular==0 & admitted_waiting_list==1 & enrolled_SUA_regular==1
 replace admitted_SUA_regular_or_pace=1 if admitted_SUA_regular==1

 
 
 
 
 ** merge in admissions and applications through PACE
 merge 1:1 mrun using "$dataTemp/admitted_SUA_pace.dta"
 * this dataset contains these variables admitted_SUA_pace select_top_adm_uni_major_PACE highest_pref_order_PACE
 drop if _merge==2
 gen applied_pace=1 if _merge==3
 replace applied_pace=0 if applied_pace==.
 replace applied_pace=0 if offered_pace==0 
 replace admitted_SUA_pace=0 if admitted_SUA_pace==. 
 
 rename applied_pace applied_SUA_pace
 label var applied_SUA_pace "applied (to SUA) through pace channel"
 label var admitted_SUA_pace "admitted (to SUA) through pace channel"
 drop _merge
 
 
 
 gen applied_SUA_regular_or_pace=1 if applied_SUA_pace ==1 | applied_SUA_regular ==1
 replace applied_SUA_regular_or_pace =0 if applied_SUA_pace ==0 & applied_SUA_regular ==0
 label var applied_SUA_regular_or_pace "applied to a SUA university through regular or PACE channels"
 
 


** merge in enrollments in all kinds of higher education institution
merge 1:1 mrun using "$dataTemp/20180829_Matricula_Ed_Superior_2018_PRIV_MRUN_UNIQUEMRUN.dta"
* this dataset contains only variables mrun tipo_inst_3 forma_de_ingreso
drop if _merge==2
gen enrolled_HE=0 if _merge==1
replace enrolled_HE=1 if _merge==3

replace enrolled_HE=1 if enrolled_SUA==1 & enrolled_HE==0
label var enrolled_HE "Enrolled in a Higher Education institution"

* consider this a mistake in the matricula dataset, these students appear as enrolled in the PSU dataset

gen enrolled_technical=1 if tipo_inst_3=="Centros de FormaciÃ³n TÃ©cnica" | tipo_inst_3=="Centros de FormaciÃ³n TÃ©cnica Estatal" | tipo_inst_3=="Institutos Profesionales"

replace enrolled_technical=0 if enrolled_HE==0
replace enrolled_technical=0 if enrolled_technical==.

label var enrolled_technical "Enrolled in a technical HEI"

gen enrolled_uni=1 if enrolled_HE==1 & enrolled_technical==0
replace enrolled_uni=0 if enrolled_uni==.

label var enrolled_uni "Enrolled in a university"

gen enrolled_uni_cruch=1 if enrolled_HE==1 & tipo_inst_3 =="Universidades Estatales CRUCH" | tipo_inst_3 =="Universidades Privadas CRUCH"
replace enrolled_uni_cruch=0 if enrolled_uni_cruch==.

label var enrolled_uni_cruch "Enrolled in a CRUCH university"

gen enrolled_HE_pace=1 if forma_de_ingreso =="7- Ingreso a travÃ©s de PACE"
replace enrolled_HE_pace=0 if enrolled_HE_pace==.

label var enrolled_HE_pace "Enrolled in a HEI via PACE"

gen enrolled_HE_regular=1 if forma_de_ingreso =="1- Ingreso Directo (regular)"
replace enrolled_HE_regular=0 if enrolled_HE_regular==.

label var enrolled_HE_regular "Enrolled in a HEI via normal channel (= PSU only if SUA)"

gen enrolled_HE_special_non_pace=1 if enrolled_HE==1 & enrolled_HE_regular==0 & enrolled_HE_pace==0
replace enrolled_HE_special_non_pace=0 if enrolled_HE_special_non_pace==.
label var enrolled_HE_special_non_pace "Enrolled in a HEI via a special channel but not PACE"


drop _merge


merge 1:1 mrun using "$dataTemp/20180604_NEM_PERCENTILES_JOVENES_2018_20180524_PUBL.dta", keepusing(nem percentil puesto_10 puesto_30)
drop if _merge==2
destring nem, replace dpcomma
drop _merge

label var nem "Avg GPA in high-school from admin data"
label var percentil "Percentile in school from admin data"
label var puesto_10 "Belongs to top 10 percent in school from admin data"
label var puesto_30 "Belongs to top 30 percent in school from admin data"
** nem info missing for some students (around 1000)#



** merge in quality of universities they apply to

merge 1:1 mrun using "$dataTemp/regular_applications_uni_quality.dta"
* this dataset contains these variables: mrun top_choice_mean_PSU top_3_choice_mean_PSU top_all_choice_mean_PSU top_choice_min_PSU top_3_choice_min_PSU top_all_choice_min_PSU select_top_adm_uni_major highest_pref_order_regular
** in particular: quality of university thye apply to throughthe regular channel and quality of uni they are admitted to thorough the regular channel

drop if _merge==2
drop _merge

* Generate biases and standardized PSU and PSU belief
gen expGPAcutoff_bias=NEM_top15-actual_top15_cutoff
label var expGPAcutoff_bias "Expected NEM_top15 minus actual"

gen expPSUscore_bias=exp_PSUscore-PSU_score_if_positive
label var expPSUscore_bias "Expected PSU score minus actual"

gen PSU_score_if_positive_st=(PSU_score_if_positive-500)/110 // By construction, the mean of PSU is 500 and the standard deviation is 110.
lab var PSU_score_if_positive_st "PSU score (standardized)"
gen expPSUscore_st=(exp_PSUscore-500)/110 // By construction, the mean of PSU is 500 and the standard deviation is 110.
lab var expPSUscore_st "Belief on PSU score (standardized)"

 
* Generate "Want to go to high school only" dummy, using students' SIMCE survey question
** similar question from parental questionnaire:  cpad_p15>0 & cpad_p15<=3 means only expect high-school education, cpad_p15>3 & cpad_p15<90
** means expect higher education
gen high_school_only=1 if cest_p06==1 | cest_p06==2
replace high_school_only=0 if cest_p06==3 | cest_p06==4
* if high_school_only is missing, assume that high_school_only==0, validate this choice by showing high consistency with actual college enrollment
replace high_school_only=0 if high_school_only==.

* Generate "Optimist in top-20%" dummy
gen optimist_top20=1 if GPA_1_2_rank>0.8 & GPA_1_2_rank<=1  & bias_top15<=0
replace optimist_top20=0 if GPA_1_2_rank<=0.8 | bias_top15>0 & bias_top15!=.
lab var optimist_top20 "Baseline rank in top 20% and underestimate top-15 cutoff"




* --------------------------------------
* Returns to effort in GPAb and PSUb
* --------------------------------------
 
* Generate derivative of effort in believed PSU production:

** Compute returns on effort
rename hours_study_PSU600 h600  // equivalent to standardized PSU .90909091
rename hours_study_PSU450 h450 // equivalent to standardized PSU -.45454545
rename hours_study_PSU350 h350  // equivalente to standardized PSU -1.3636364

*Calculate returns to effort of PSU, standardized score 
gen returns_eff_PSUb_1= (((450-500)/110) - ((350-500)/110))/(h450-h350) if h450!=h350  // returns between 350 and 450 
gen returns_eff_PSUb_2= (((600-500)/110) - ((450-500)/110))/(h600-h450) if h600!=h450 // returns between 450 and 600 

sum  returns_eff_PSUb_1 returns_eff_PSUb_2

gen returns_eff_PSUb_1_original=returns_eff_PSUb_1
gen returns_eff_PSUb_2_original=returns_eff_PSUb_2 
lab var returns_eff_PSUb_1_original "Perceived returns to effort PSUb, including negative"
lab var returns_eff_PSUb_2_original "Perceived returns to effort PSUb, including negative"

* Eliminate negative answers
replace  returns_eff_PSUb_1=. if returns_eff_PSUb_1<0
replace returns_eff_PSUb_2=. if returns_eff_PSUb_2<0


label var returns_eff_PSUb_1 "Perceived marginal returns to hrs study/week, PSUb<450"
label var returns_eff_PSUb_2 "Perceived marginal returns to hrs study/week, PSUb>=450"

gen returns_eff_PSUb_i=returns_eff_PSUb_1 if exp_PSUscore <450
replace returns_eff_PSUb_i=returns_eff_PSUb_2 if exp_PSUscore >=450 & exp_PSUscore!=.
label var returns_eff_PSUb_i "Perceived marginal returns to hrs study/week, at expected PSU"

gen concave_PSU_returns=1 if returns_eff_PSUb_2<returns_eff_PSUb_1 & returns_eff_PSUb_1!=. & returns_eff_PSUb_2!=.
replace concave_PSU_returns=0 if returns_eff_PSUb_2>returns_eff_PSUb_1 & returns_eff_PSUb_1!=. & returns_eff_PSUb_2!=.
gen linear_PSU_returns=1 if returns_eff_PSUb_2==returns_eff_PSUb_1 & returns_eff_PSUb_1!=. & returns_eff_PSUb_2!=.
replace linear_PSU_returns=0 if returns_eff_PSUb_2!=returns_eff_PSUb_1 & returns_eff_PSUb_1!=. & returns_eff_PSUb_2!=.

gen curvature="Linear" if linear_PSU_returns==1
replace curvature="Concave" if concave_PSU_returns==1
replace curvature="Convex" if concave_PSU_returns==0

label var curvature "Shape of perceived PSU production function"

tab curvature

gen nonlinearity_degree=abs(returns_eff_PSUb_2-returns_eff_PSUb_1)
gen nonlinearity_degree_percent=nonlinearity_degree/returns_eff_PSUb_1

label var nonlinearity_degree "Absolute difference in marginal returns"

bysort curvature: sum nonlinearity_degree


replace h600=. if returns_eff_PSUb_1==. | returns_eff_PSUb_2==.
replace h450=. if returns_eff_PSUb_1==. | returns_eff_PSUb_2==.
replace h350=. if returns_eff_PSUb_1==. | returns_eff_PSUb_2==.



rename h600 hours_study_PSU600
rename h450 hours_study_PSU450
rename h350 hours_study_PSU350

drop concave_PSU_returns linear_PSU_returns

/*


gen linear_PSU_returns=1 if c==0
replace linear_PSU_returns=0 if c!=. & c!=.

sum concave_PSU_returns linear_PSU_returns

drop concave_PSU_returns linear_PSU_returns 


	
	gen gradient_actualeff_PSU=2*c*hours_study+b 
	sum gradient_actualeff_PSU if  gradient_actualeff_PSU>=0, de
	hist  gradient_actualeff_PSU if  gradient_actualeff_PSU>=0 & gradient_actualeff_PSU< 8.863636, frac  xtitle("Perceived marginal returns to hrs study/week") title("PSU score production") saving("$dataTemp/returns_PSU_quadratic_hist.gph", replace)
	graph export "$graphs/returns_PSU_quadratic_hist.png", replace //
	
	drop a
	replace c=. if gradient_actualeff_PSU<0
	replace b=. if gradient_actualeff_PSU<0 
	rename c PSU_returns_quadratic_term 
	rename b PSU_returns_linear_term 
	
	label var PSU_returns_quadratic_term "Coeff of eff^2 in PSU^b, missing if returns_actual_eff<0"
	label var PSU_returns_linear_term "Coeff of eff in PSU^b, missing if returns_actual_eff<0"
	label var gradient_actualeff_PSU "Derivative of PSU^b wrt eff at actual effort level"
	

drop gradient_eff*_PSU



rename h600 hours_study_PSU600
rename h450 hours_study_PSU450
rename h350 hours_study_PSU350

replace hours_study_PSU600=. if PSU_returns_quadratic_term==.
replace hours_study_PSU450=. if PSU_returns_quadratic_term==.
replace hours_study_PSU350=. if PSU_returns_quadratic_term==.


*/




* Generate derivative of effort in believed GPA production:

sum exp_NEM NEM_top15_August // we get exp_NEM< NEM_top15_August on average, 5.65 vs. 5.85
sum hours_to_have_NEM55 hours_study hours_to_be_top15 // reveals nonlinearity
* ==> Do not use actual hours and expected NEM at actual hours to build returns 


gen returns_effort_top15_55=(NEM_top15_August-5.5)/(hours_to_be_top15-hours_to_have_NEM55)  if hours_to_be_top15!=hours_to_have_NEM55 // using august answer for cutoff as this is the NEM level the survey asks about 
gen returns_effort_top15_55_original=returns_effort_top15_55 
label var returns_effort_top15_55_original "Perceived marginal returns to GPAb, including negative"
replace returns_effort_top15_55=. if returns_effort_top15_55<0




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
	sort mrun
*	cap drop returns_eff_PSUb_1_*
	qui lasso linear returns_eff_PSUb_1  $final_covarlist if in_experimental_school==1, rseed(10) lambda(.008695815) 
	lassogof
	lassoinfo
	lassoknots
	predict returns_eff_PSUb_1_est if e(sample) == 1
	predict returns_eff_PSUb_1_all // Predict for the whole sample

    estimates clear
	eststo clear 
	sort mrun
	* cap drop returns_eff_PSUb_2_*
	quietly lasso linear returns_eff_PSUb_2  $final_covarlist , rseed(10) lambda( .0101306647)
	lassogof
	lassoinfo
	lassoknots
	etable
	predict returns_eff_PSUb_2_est if e(sample) == 1
	predict returns_eff_PSUb_2_all // Predict for the whole sample
	
    estimates clear
	eststo clear 
	sort mrun
	quietly lasso linear hours_study_PSU450 $final_covarlist , rseed(10) lambda(.03017429)
	lassogof
	lassoinfo
	lassoknots
	predict kink_est if e(sample)==1
	predict kink_all // Predict for the whole sample 
	
	
	
	rename simce simce_avg_st 
	rename alumno_prior alumno_prioritario



	
	
	********************************************
	* GPAb returns
	*******************************************

	
	
	rename  simce_avg_st simce
	rename  alumno_prioritario alumno_prior

	estimates clear 
	eststo clear 
	sort mrun
	quietly lasso linear returns_effort_top15_55  $final_covarlist , rseed(10) lambda(.007830793)
	lassogof
	lassoinfo
	lassoknots
	etable
	lassocoef
	
	predict returns_GPA_est if e(sample) == 1
		predict returns_GPA_est_all // Predict for the whole sample
		

	
	
	
	

	****************************************************************************
	* P_graduate
	****************************************************************************
	estimates clear
	
	eststo clear     		
	
	
	
	sort mrun
	quietly lasso linear p_graduate  $final_covarlist , rseed(10)
	lassogof
	lassocoef
	etable
	est store lasso_p_grad

	predict p_graduate_est if e(sample) == 1
		predict p_graduate_all // Predict for the whole sample
	

	
	rename simce simce_avg_st 
	rename alumno_prior alumno_prioritario
	
	
	


* Prepare baseline belief data, fixed over time, by imputing missing from LASSO 
gen GPAb_coeff_eff = returns_effort_top15_55
replace GPAb_coeff_eff = returns_GPA_est_all if GPAb_coeff_eff==. 

gen PSUb_coeff_eff_1 = returns_eff_PSUb_1
replace PSUb_coeff_eff_1 = returns_eff_PSUb_1_all if PSUb_coeff_eff_1 == .

gen PSUb_coeff_eff_2 = returns_eff_PSUb_2
replace PSUb_coeff_eff_2 = returns_eff_PSUb_2_all if PSUb_coeff_eff_2 == .

gen Pgradb = p_graduate 
replace Pgradb = p_graduate_all if Pgradb==.

gen PSUb_kink = hours_study_PSU450
replace PSUb_kink = kink_all if PSUb_kink==.




** add info on criteria for PACE seat
merge 1:1 mrun using "$dataRaw/Admission/criterios_2018.dta"
drop if _merge==2
drop _merge


saveold "$dataTemp/basefinal_merged_all_clean.dta", replace 




********************************************************************************
* Clean data on population of Chilean students enrolled in 11th grade in high school
********************************************************************************
use "$dataTemp/matricula_unica_2016.dta", clear
keep if cod_ense2==5 | cod_ense2==7 //keep only if non-adult student
keep if cod_grado==3                //keep only if in tercero medio
* Generate santiago variable
gen santiago=1 if cod_reg_rbd==13
replace santiago=0 if cod_reg_rbd!=. & cod_reg_rbd!=13
lab var santiago "School in Santiago region"
merge 1:1 mrun using "$dataTemp/simce_unique_alucpad_2015.dta", keepusing(ptje_lect2m_alu ptje_mate2m_alu meduc peduc hh_income) update replace 
drop if _merge==2
drop _merge
gen simce_avg=(ptje_lect2m_alu + ptje_mate2m_alu)/2
label var simce_avg "SIMCE score"
su simce_avg // obtain mean and standard deviation of the population of simce in 2015
local mean_simce=r(mean)
local sd_simce=r(sd)
di `mean_simce' // 258.95715
di `sd_simce' // 52.253445
gen double simce_avg_st_pop=(simce_avg-`mean_simce')/`sd_simce' // standardize simce in 2015
merge 1:1 mrun using "$dataTemp/20151116_Prioritarios_y_Beneficiarios_2015_20151001_PUBL.dta", keepusing(ben_sep) 
gen alumno_prioritario=1 if _merge==3
replace alumno_prioritario=0 if _merge!=3
drop if _merge==2
drop _merge
merge 1:1 mrun using "$dataTemp/basefinal_merged_all_clean.dta", update replace nogen
lab var alumno_prioritario "Very low SES"
lab var meduc "Mother's education (years)"
lab var peduc "Father's education (years)"
lab var hh_income "Family income (1,000 CLP)"
lab var simce_avg_st_pop "SIMCE score (standardized)"
lab var rural_rbd "Rural resident"
lab var santiago "Santiago resident"
save "$dataClean/data_population.dta", replace // save data on population of Chilean students in 2018


********************************************************************************
* Clean data on population of students registered for PSU in 2018
********************************************************************************
* Upload data on PSU for all students who sit the entry exam in 2018
use "$dataTemp/A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN.dta", clear
destring promlm_actual, replace dpcomma
gen PSU_score_if_positive=promlm_actual if promlm_actual!=0
label var PSU_score_if_positive "PSU score conditional on sitting exam"
su PSU_score_if_positive // obtain mean and standard deviation of the population of PSU scores
local mean_PSU=500 // r(mean)
local sd_PSU=110 // r(sd)
di `mean_PSU' // 506.0497
di `sd_PSU' // 97.469566
gen PSU_score_st_pop=(PSU_score_if_positive-`mean_PSU')/`sd_PSU'
su PSU_score_st_pop
gen sit_PSU=1 if promlm_actual!=0 & promlm_actual!=.
replace sit_PSU=0 if promlm_actual==0  & promlm_actual!=.
label var sit_PSU "Registered and sat PSU exam"
* Merge with data on simce for all students in 2015
merge 1:1 mrun using "$dataTemp/simce_unique_alucpad_2015.dta", update replace 
drop if _merge==2
drop _merge
gen simce_avg=(ptje_lect2m_alu + ptje_mate2m_alu)/2
label var simce_avg "SIMCE score"
gen simce_avg_st_pop=(simce_avg-258.95715)/52.253445 // standardize simce using data on population enrolled in 11th grade in tercero medio in high school in 2016 (see above)
* Merge with data on enrolled students in 2018
merge 1:1 mrun using "$dataTemp/matricula2018.dta", update replace 
drop if _merge==2
drop _merge
* Merge with with alumno prioritario dataset
merge 1:1 mrun using "$dataTemp/20151116_Prioritarios_y_Beneficiarios_2015_20151001_PUBL.dta", keepusing(ben_sep) 
gen alumno_prioritario=1 if _merge==3
replace alumno_prioritario=0 if _merge!=3
drop if _merge==2
drop _merge
* Merge with with application dataset
merge 1:1 mrun using "$dataTemp/C_POSTULACIONES_SELECCION_PSU_2018_PRIV_uniqueMRUN_admitted.dta", keepusing(admitted admitted_waiting_list)
gen applied_SUA_regular=0 if _merge==1
replace applied_SUA_regular=1 if _merge==3
replace applied_SUA_regular=0 if sit_PSU==0    // students cannot apply if they haven't sat the PSU
label var applied_SUA_regular "Applied to SUA through regular channel"
drop if _merge==2
drop _merge
* Merge with experimental data
merge 1:1 mrun using "$dataTemp/basefinal_merged_all_clean.dta", update replace nogen
gen graduate_top15=1 if  allyears_GPA_rank >=.85 & allyears_GPA_rank !=.
replace graduate_top15=0 if allyears_GPA_rank<.85
* Classify schools in quartiles of simce_avg
preserve
keep if in_experimental_schools==1
keep rbd_basefinal simce_avg_st_pop
collapse (mean) simce_avg_st_pop, by(rbd_basefinal)
xtile quart_simce_avg_st_pop = simce_avg_st_pop, nq(4)
lab var quart_simce_avg_st_pop "Quartile of experimental school in terms of simce (bottom=1)"
keep rbd_basefinal quart_simce_avg_st_pop
saveold "$dataTemp/quart_simce.dta", replace
restore
merge m:1 rbd_basefinal using  "$dataTemp/quart_simce.dta", nogen // merge with quartiles of experimental schools in terms of simce
capture erase  "$dataTemp/quart_simce.dta"
save "$dataClean/data_population_PSU_students.dta", replace // save data on population of Chilean students in 2018



********************************************************************************
***                    Generate data on school transitions                   ***
********************************************************************************

import delimited "$dataRawPublic/High_school_registration/20150923_Matricula_unica_2015_20150430_PUBL.csv", delimiter(";") clear
save "$dataTemp/2015.dta", replace

import delimited "$dataRawPublic/High_school_registration/20160926_Matricula_unica_2016_20160430_PUBL.csv", delimiter(";") clear
save "$dataTemp/2016.dta", replace

forvalues y = 2015(1)2016 {
	use "$dataRaw/High_school_registration/574 liceos PACE.dta", clear
	keep rbd AñoPACE
	rename AñoPACE pace_year
	merge 1:m rbd using "$dataTemp/`=`y''.dta"
	*I have renamed files and folders so that looping through them is easier
	*201x.dta refers to the highschool matricula of that year.
	keep mrun rbd cod_ense2 cod_grado pace_year _merge
	if `y' == 2015 {
		drop if cod_grado != 2
		}
	if `y' == 2016 {
		drop if cod_grado != 3
		rename rbd rbd_2016
		rename pace_year pace_year_2016
		}
	keep if cod_ense2 == 5 | cod_ense2 == 7
	*The above only keeps those in 2ndo and 3ro medio
	*replace pace_year = 0 if pace_year > 2016
	replace pace_year = 9998 if _merge == 2 
	drop if mrun == .
	gen year = `y'
	drop cod_ense2 cod_grado _merge
	save "$dataTemp/`=`y''_temp.dta", replace
	}

use "$dataTemp/simce2m2015_alu.dta", clear
keep mrun ptje*

duplicates tag mrun, gen(tag)
drop if tag > 0 & (ptje_lect2m_alu == . & ptje_mate2m_alu == . & ptje_soc2m_alu == .)
drop if tag > 10
drop tag
*The above drops duplicates carrying no information & mistakes

merge 1:1 mrun using "$dataTemp/2015_temp.dta"
*After this merge, roughly 97% of students are matched, while 1.5% are only in SIMCE
*and 1.5% only in highschool enrollment. The fact that 1.5% are only in highschool
*enrollment is not suspicious as SIMCE coverage is not universal. However, 
*1.5% of students being only in SIMCE and not in HS enrollment is strange. Assuming it is a 
*mistake, we drop them
drop if _merge == 1
drop _merge

merge 1:1 mrun using "$dataTemp/2016_temp.dta", keepusing (rbd_2016 pace_year_2016)

expand 2
bysort mrun: gen tag2 = _n
replace year = 2016 if tag2 == 2
replace year = 2015 if tag2 == 1
replace rbd = rbd_2016 if tag2 == 2 & _merge == 3
replace pace_year = pace_year_2016 if tag2 == 2 & _merge == 3
*The above encompasses the "normal case", i.e. mrun which are present in both years
*However, around 9% of observations are not matched via mrun. They probably represent
*those that have dropped out (i.e. present in 2015 but not in 2016, 6.5%) or that have
*joined school again (i.e. present in 2016 but not in 2015, 2.5%)

*If this holds true, then we will make a dummy explaining why data is missing
*status is 0 if everything is okay, 1 if the student dropped out in 2015,
*2 if the student joined school again in 2016
gen status = 0

replace rbd = . if tag2 == 2 & _merge == 1 
replace status = 1 if _merge == 1
replace pace_year = 9999 if _merge == 1 & tag2 == 2
*rbd unknown for 2016 as they dropped out

replace rbd = . if tag2 == 1 & _merge == 2
replace status = 2 if _merge == 2
replace pace_year = 9999 if _merge == 2 & tag2 == 1
replace rbd = rbd_2016 if tag2 == 2 & _merge == 2
*rbd unknown for 2015 as they rejoined school in 2016

drop tag2 _merge rbd_2016 pace_year_2016

save "$dataTemp/pre_output.dta", replace

use "$dataTemp/pace221_ucl.dta", clear
keep rbd grupo_pace
rename grupo_pace treatment
drop if treatment == .
save "$dataTemp/treatment_temp.dta", replace

use "$dataTemp/pre_output.dta", clear
merge m:1 rbd using "$dataTemp/treatment_temp.dta"
replace treatment = . if year == 2015
drop _merge

lab var mrun "Student ID"
lab var ptje_lect2m_alu "Spanish SIMCE score(2015)"
lab var ptje_mate2m_alu "Maths SIMCE score(2015)"
lab var ptje_soc2m_alu "Social Sciences SIMCE score(2015)"
lab var rbd "School ID"
lab var pace_year "Introduction year of PACE"
lab var year "Year"
lab var status "Status of student over two years"
lab var treatment "Treatment"

sort mrun
save "$dataClean/data_movers.dta", replace
