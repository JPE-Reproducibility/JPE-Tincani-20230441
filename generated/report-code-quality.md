## Code Quality

### Stata

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (ftab.ado, line 173)
  → net install ftools, from("C:/git/ftools/src")

[CRITICAL] `merge m:m` uses positional row-matching within key groups, not relational join semantics. Use `joinby` for a true many-to-many join, or identify the correct unique key and use `1:m`/`m:1`. (matchit.ado, line 217)
  → qui merge m:m grams using `diagfile1'

[CRITICAL] `merge m:m` uses positional row-matching within key groups, not relational join semantics. Use `joinby` for a true many-to-many join, or identify the correct unique key and use `1:m`/`m:1`. (10.Figures.do, line 369)
  → merge m:m sigla_universidad codigo_carrera  using "$dataTemp/mean_psu_score_unimajor_level"

[CRITICAL] `merge m:m` uses positional row-matching within key groups, not relational join semantics. Use `joinby` for a true many-to-many join, or identify the correct unique key and use `1:m`/`m:1`. (5.Generate_applic_admi_uni_selectivity.do, line 497)
  → * merge m:m sigla_universidad  using "$datamean_psu_score_unimajor_level.dta"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (a2reg.ado, line 48)
  → drop if `group' != `largest_group';

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (a2reg.ado, line 85)
  → keep if `touse';

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (cdfplot.ado, line 50)
  → keep if `touse'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ciares.ado, line 64)
  → keep if `running' < `band_r' & `running' > `band_l' & `touse'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 282)
  → drop if `var'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 400)
  → drop if mean_d_XX==.|mean_y_XX==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 559)
  → drop if ever_strict_increase_XX==1 & ever_strict_decrease_XX==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 607)
  → drop if var_F_g_XX==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 632)
  → drop if controls_time_XX==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 719)
  → drop if time_XX==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 789)
  → drop if avg_post_switch_treat_XX==d_sq_XX_orig&F_g_XX!=T_g_XX+1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 3633)
  → drop if F_g_XX > T_max_XX

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 4044)
  → keep if time_to_treat!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_dyn.ado, line 4087)
  → keep if time_to_treat!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 97)
  → drop if `weight'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 100)
  → drop if `2'==.|`3'==.|`4'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 103)
  → drop if `var'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 107)
  → drop if `cluster'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 110)
  → drop if `recat_treatment'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 113)
  → drop if `weight'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 202)
  → drop if ever_strict_increase_XX==1 & ever_strict_decrease_XX==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 793)
  → keep if _n<=3+`placebo'+`dynamic'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 796)
  → keep if _n<=2+`placebo'+`dynamic'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 806)
  → drop if time_to_treatment==-1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 970)
  → drop if `1'==.|`2'==.|`3'==.|`4'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 973)
  → drop if `var'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 977)
  → drop if `cluster'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 980)
  → drop if `recat_treatment'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 983)
  → drop if `weight'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 1299)
  → drop if lag_d_cat_group_XX==`d'&`group_incl'==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_old.ado, line 1738)
  → drop if lag_d_cat_group_XX==`d'&`group_incl'==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 792)
  → drop if to_use_XX==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 828)
  → drop if to_use_XX==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 2673)
  → keep if unique_label

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 2775)
  → keep if unique_label

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 2855)
  → drop if by_vars_XX==. //To prevent reshape from craching.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 3080)
  → keep if inlist(T_XX,  `pairwise'-`placebo' -1, `pairwise'-`placebo', `pairwise'-1, `pairwise')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 3252)
  → drop if !used_in_IV`pairwise'_XX

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 3268)
  → drop if S_XX==-1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 3271)
  → drop if S_XX==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 3280)
  → drop if SI_XX==-1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 3283)
  → drop if SI_XX==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 3403)
  → drop if outOfBounds_XX==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 3414)
  → drop if outOfBoundsiV_XX==1 //|outOfBounds_XX==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 4813)
  → drop if tag_XX != 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 4824)
  → drop if tag_XX != 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (did_multiplegt_stat.ado, line 4836)
  → drop if tag_XX != 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (felsdv_group.ado, line 99)
  → keep if `mnum'>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (felsdvreg.ado, line 214)
  → keep if `mnum'>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (leebounds.ado, line 194)
  → keep if `__esamp' == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (leebounds.ado, line 355)
  → keep if `__esamp' == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (leebounds.ado, line 956)
  → keep if `__repl' == 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (missings.ado, line 457)
  → drop if `nmissing' == `nvars' & `touse'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (spmap.ado, line 269)
  → keep if `TOUSE'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (spmap.ado, line 310)
  → keep if _merge == 3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (spmap.ado, line 332)
  → keep if _merge == 3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (spmap.ado, line 346)
  → keep if _merge == 3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (spmap.ado, line 1098)
  → keep if _merge == 3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (spmap.ado, line 1117)
  → keep if _merge == 3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (spmap_color.ado, line 38)
  → keep if palette == "`PALETTE'"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (spmap_color.ado, line 45)
  → keep if levels == `NC'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (upsetplot.ado, line 53)
  → keep if `touse'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (upsetplot.ado, line 183)
  → keep if `tokeep'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (vennbar.ado, line 56)
  → keep if `touse'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 21)
  → keep if cod_grado==1 // keep only students that were in primero medio in 2014

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 24)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 29)
  → keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | cod_ense==710 | cod_ense==810 | cod_ense==910 //keep only non-adult students in HC or TP high schools

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 30)
  → keep if cod_grado==2 // keep only students that were in segundo medio in 2015

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 33)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 38)
  → keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | cod_ense==710 | cod_ense==810 | cod_ense==910 //keep only non-adult students in HC or TP high schools

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 39)
  → keep if cod_grado==3 // keep only students that were in tercero medio in 2016

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 42)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 47)
  → keep if cod_ense2==5 | cod_ense2==7 //keep only non-adult students in HC or TP high schools

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 48)
  → keep if cod_grado==4 // keep only students that were in cuarto medio in 2017

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 51)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 62)
  → keep if stem==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 71)
  → keep if stem==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 87)
  → keep if tipo_subsector==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 96)
  → keep if nom_subsector=="MATEMÁTICA"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 104)
  → keep if nom_subsector=="LENGUA CASTELLANA Y COMUNICACIÓN" | nom_subsector=="LENGUAJE Y COMUNICACIÓN"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 207)
  → keep if cod_ense==310 | cod_ense==410 | cod_ense==510 | cod_ense==610 | ///

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 209)
  → keep if cod_grado==`g' // keep only students that were in grade `g'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 220)
  → keep if GPA_`grade_name'_medio!=0 //GPA==0 means missing

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 224)
  → drop if dup==1 & sit_fin_r=="T" /*drop the duplicate of student that transferred to another school*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 243)
  → keep if cod_grado==4 // keep only students that were in cuarto medio in 2017

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 260)
  → keep if _merge==3 //keep only students of experimental schools

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 264)
  → drop if transferred_cuarto_medio==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 273)
  → keep if cod_ense2==5 | cod_ense2==7 //keep only non-adult students in HC or TP high schools

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 274)
  → keep if cod_grado==3 // keep only students that were in tercero medio in 2016

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 290)
  → keep if _merge==3 //keep only students of experimental schools

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 294)
  → drop if transferred_tercero_medio==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 303)
  → keep if cod_grado==2 // keep only students that were in segundo medio in 2015

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 307)
  → keep if GPA_segundo_medio!=0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 309)
  → drop if dup==1 & sit_fin_r=="T" /*drop the duplicate of student that transferred to another school*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 318)
  → keep if cod_grado==2 // keep only students that were in segundo medio in 2014

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 322)
  → keep if GPA_segundo_medio!=0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 324)
  → drop if dup==1 & sit_final_r=="T" /*drop the duplicate of student that transferred to another school*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 333)
  → keep if cod_grado==2 // keep only students that were in segundo medio in 2013

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 337)
  → keep if GPA_segundo_medio!=0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 339)
  → drop if dup==1 & sit_fin_r=="T" /*drop the duplicate of student that transferred to another school*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 348)
  → keep if cod_grado==1 // keep only students that were in primero medio in 2014

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 352)
  → keep if GPA_primero_medio!=0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 354)
  → drop if dup==1 & sit_final_r=="T" /*drop the duplicate of student that transferred to another school*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 363)
  → keep if cod_grado==1 // keep only students that were in primero medio in 2013

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 367)
  → keep if GPA_primero_medio!=0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 369)
  → drop if dup==1 & sit_fin_r=="T" /*drop the duplicate of student that transferred to another school*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 439)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 514)
  → keep if cod_grado==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 515)
  → keep if cod_ense2==5 | cod_ense2==7

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 517)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.Clean_GPA.do, line 521)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 343)
  → drop if max_counter>1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 362)
  → drop if dupli>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 370)
  → drop if _merge==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 480)
  → keep if in_experimental_schools==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 567)
  → keep if in_experimental_schools==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 569)
  → drop if _merge==2 // these are students who were admitted through PACE in 2018 but are not in our experimental sample

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 576)
  → keep if sit_PSU==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 606)
  → drop if _merge==2 // these are students who were admitted through PACE in 2018 but are not in our experimental sample

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 616)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (10.Figures.do, line 712)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 17)
  → keep if in_experimental_schools==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 58)
  → drop if _merge==2 // these are the students who were admitted through PACE in 2018 but they are not in the our experimental sample

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 150)
  → keep if treatment==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 155)
  → keep if treatment==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 212)
  → drop if _merge==2 // these are students who were admitted through PACE in 2018 but are not in our experimental sample

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 224)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 273)
  → keep if sit_PSU==1 //Change applied_SUA_regular==1 to sit_PSU==1 if we do not model application decision

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 724)
  → keep if in_experimental_schools==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 730)
  → drop if `var'==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 818)
  → keep if treatment==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (11.Data_for_model_estimation_rescale.do, line 824)
  → keep if treatment==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (13.Create_bootstrap.do, line 118)
  → drop if _merge==2 // these are the students who were admitted through PACE in 2018 but they are not in the our experimental sample

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 79)
  → drop if _merge==2 /*drop fathers without students*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 409)
  → drop if mrun==25011365 /*Since this mrun is not present in Matricula, we drop it*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 431)
  → drop if ptje_lect2m_alu==. & ptje_mate2m_alu==. & ptje_nat2m_alu==. /*50662 deleted*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 435)
  → drop if mrun==25011365 /*Since this mrun is not present in Matricula, we drop it*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 441)
  → drop if _merge!=3 /*We drop the duplicates that have not matched with matricula mrun*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 445)
  → drop if num_duplicates>0 /*drop all duplicates*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 471)
  → drop if ptje_lect2m_alu==. & ptje_mate2m_alu==.  /*52780 deleted*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 475)
  → drop if mrun==25011365 /*Since this mrun is not present in Matricula, we drop it*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 481)
  → drop if _merge!=3 /*We drop the duplicates that have not matched with matricula mrun*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 485)
  → drop if num_duplicates>0 /*drop all duplicates*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 511)
  → drop if ptje_lect2m_alu==. & ptje_mate2m_alu==.  /*37378 deleted*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 515)
  → drop if mrun==25011365 /*Since this mrun is not present in Matricula, we drop it */

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 516)
  → drop if mrun==25037651 /*Since this mrun is not present in Matricula, we drop it */

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 525)
  → drop if _merge!=3 /*We drop the duplicates that have not matched with matricula mrun*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 529)
  → drop if num_duplicates>0 /*drop all duplicates*/

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 815)
  → keep if cod_ense2 == 5 | cod_ense2 == 7 // drop adults and children

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 816)
  → keep if cod_grado == 2 // keep only students in their segundo medio to merge with simce data

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 819)
  → drop if mrun==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 836)
  → drop if mrun==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 854)
  → drop if dup>0 & (noptje_lect2m_alu!=0 & noptje_mate2m_alu!=0) // drop if duplicates and have both scores missing

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 857)
  → keep if dup>0 // keep only duplicates

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 862)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 863)
  → keep if rbd==rbd_simce & gen_alu==gen_alu_simce // keep duplicates with the correct high school and gender

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 865)
  → drop if dup2>0 & letra_curso_simce!=let_cur // among the remaining duplicates, drop those in the wrong class

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 874)
  → drop if dup>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1048)
  → keep if cod_ense2 == 5 | cod_ense2 == 7 // drop adults and children

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1049)
  → keep if cod_grado == 2 // keep only students in their segundo medio to merge with simce data

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1074)
  → drop if dup>0 & (noptje_lect2m_alu!=0 & noptje_mate2m_alu!=0) // drop if duplicates and have both scores missing

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1077)
  → keep if dup>0 // keep only duplicates

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1082)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1083)
  → keep if rbd==rbd_simce & gen_alu==gen_alu_simce // keep duplicates with the correct high school and gender

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1085)
  → drop if dup2>0 & letra_curso_simce!=let_cur // among the remaining duplicates, drop those in the wrong class

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1094)
  → drop if dup>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1111)
  → drop if simce_avg_st==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.Clean_simce.do, line 1147)
  → drop if simce_avg_st==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 190)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 371)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 608)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 1313)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 1518)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 2064)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 2739)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 2844)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 2914)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 3243)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 3481)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 3716)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 4057)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 4361)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 4799)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27.Tables_Figures_model_numbers.do, line 4996)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27b.In_text_numbers.do, line 131)
  → keep if MAT_2018=="Si"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27b.In_text_numbers.do, line 136)
  → keep if anio_ing_carr_ori==2018 // keep only first-year students

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (27b.In_text_numbers.do, line 150)
  → keep if MAT_2018=="Si"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 25)
  → keep if Q53 != 7

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 235)
  → keep if teaching_subject == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 245)
  → keep if let_cur != ""

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 254)
  → keep if teaching_subject == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 255)
  → keep if modalidad == `mod'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 264)
  → keep if let_cur != ""

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 276)
  → keep if teaching_subject == 2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 286)
  → keep if let_cur != ""

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 295)
  → keep if teaching_subject == 2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 296)
  → keep if modalidad == `mod'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.Clean_docentes.do, line 305)
  → keep if let_cur != ""

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.Clean_jefes.do, line 12)
  → drop if Q55_1_0 == "1234" | Q55_1_0 == "654" | Q55_1_0 == "7789" | Q55_1_0 == " "

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.Clean_jefes.do, line 19)
  → drop if _merge == 2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.Clean_jefes.do, line 97)
  → drop if rbd == .

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 18)
  → drop if dupli>0 & via_ingreso!=3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 25)
  → drop if dupli>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 44)
  → drop if dup>0  // We drop observations for which we don't have info about their true enrollment

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 91)
  → drop if mrun=="7035251" | mrun=="16573091" | mrun=="9955622"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 92)
  → drop if sem_mat_pri_anio =="2"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 97)
  → drop if mrun=="7035251" | mrun=="16573091" | mrun=="9955622" // three foreign students

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 105)
  → drop if mrun==" "

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 149)
  → keep if anio_mat_pri_anio ==2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 152)
  → drop if mrun==" "

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 176)
  → drop if _merge==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 177)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 178)
  → keep if via_ingreso==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 207)
  → drop if _merge==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 208)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 209)
  → keep if via_ingreso==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 295)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 454)
  → keep if anio_mat_pri_anio ==2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.Generate_applic_admi_uni_selectivity.do, line 457)
  → drop if mrun==" "

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 32)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 33)
  → keep if cod_ense2==5 | cod_ense2==7 //keep only if non-adult student

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 34)
  → keep if cod_grado==3                //keep only if in tercero grado

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 53)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 64)
  → drop if movers==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 85)
  → keep if _merge2015==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 89)
  → keep if _merge2015==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 92)
  → keep if _merge2014==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 95)
  → keep if _merge2014==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 97)
  → keep if _merge2013==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 129)
  → drop if _merge2014==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 131)
  → drop if _merge2015==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 144)
  → drop if _merge2014==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 163)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 180)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 189)
  → drop if _merge==2 //drop the fieldworkers in the missing school

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 304)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 307)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 310)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 313)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 316)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 319)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 337)
  → keep if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 341)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 345)
  → keep if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 349)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 352)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 361)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 369)
  → keep if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 373)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 377)
  → keep if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 381)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 384)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 393)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 400)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 405)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 413)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.Merge_basefinal.do, line 418)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6a.April_cleaning.do, line 115)
  → drop if incoherent_answers_no_uni==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6a.April_cleaning.do, line 127)
  → drop if incoherent_answers_uni==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 512)
  → keep if simce_avg!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 764)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 780)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 812)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 827)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 925)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1365)
  → keep if cod_grado==3                //keep only if in tercero medio

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1371)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1384)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1430)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1438)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1479)
  → drop if cod_grado != 2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1482)
  → drop if cod_grado != 3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1486)
  → keep if cod_ense2 == 5 | cod_ense2 == 7

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1500)
  → drop if tag > 0 & (ptje_lect2m_alu == . & ptje_mate2m_alu == . & ptje_soc2m_alu == .)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1501)
  → drop if tag > 10

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.Clean_basefinal.do, line 1550)
  → drop if treatment == .

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 26)
  → keep if in_experimental_schools==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 58)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 63)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 103)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 119)
  → drop if codigo_carrera==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 192)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 197)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 209)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 230)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 254)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 267)
  → drop if codigo_carrera==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 359)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 380)
  → drop if sigla_universidad==""

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 382)
  → drop if dup>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 401)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 404)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 407)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 411)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 426)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 429)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 534)
  → keep if in_experimental_schools==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 567)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 568)
  → drop if sit_PSU==0 & _merge==3 // you shouldn't be able to apply if you didn't sit the PSU

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 578)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 579)
  → drop if applied_SUA_pace==0 & _merge==3 // eliminate invalid applications

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 602)
  → drop if mrun==7035251 | mrun==16573091 | mrun==9955622

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 603)
  → drop if mrun==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 605)
  → drop if dup_num>1 & dup_num!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 661)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 805)
  → drop if cod_carrera == .

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 832)
  → drop if mrun==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 834)
  → drop if dup_num>1 & dup_num!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 858)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 920)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 1029)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Clean_academic_data.do, line 2195)
  → keep if in_experimental_schools==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.Geolocalize.do, line 37)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 81)
  → keep if p_graduate!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 461)
  → drop if max_counter>1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 480)
  → drop if dupli>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 1324)
  → keep if `subsample'==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 1377)
  → keep if `subsample'==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 1700)
  → drop if _merge==2 // these are students who were admitted through PACE in 2018 but are not in our experimental sample

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 1712)
  → drop if _merge==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 1749)
  → keep if sit_PSU==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 2623)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 2749)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 2878)
  → keep if _merge==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 2880)
  → keep if top15baseline==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.Tables.do, line 2983)
  → keep if in_experimental_schools==1

