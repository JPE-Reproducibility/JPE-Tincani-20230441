# Codebook Note for `Cuestionario+-+Jefe_December+18%252C+2017_13.56_rp.dta`

This note documents the confidential school-principal questionnaire dataset `Cuestionario+-+Jefe_December+18%252C+2017_13.56_rp.dta`. The dataset is stored in:

`confidential-data-not-for-publication/raw/Teachers_and_principals/Cuestionario+-+Jefe_December+18%252C+2017_13.56_rp.dta`

The auxiliary file `Jefes UTP 23-11_rp.dta` contains identifier information and is used only to support data cleaning and merges.


## General Description

This dataset contains survey responses from school principals in the schools in the study. The questionnaire records school identifiers and administrative practices related to course assignment, grouping of students into classes, grade-review practices, remedial or reinforcement classes, PSU preparation, and preparation activities for transition to higher education.

The variables are mostly survey-question fields named with question numbers, such as `Q6`, `Q11_1`, and `Q31`. The labels in the source file provide the original Spanish survey-question text; the descriptions below summarize blocks of variables.

## Variable Names

- `ResponseId`
- `Q55_1_0`
- `Q6`
- `Q8`
- `Q10`
- `Q11_1`
- `Q11_2`
- `Q11_3`
- `Q11_4`
- `Q11_4_TEXT`
- `Q14`
- `Q15`
- `Q16`
- `Q19`
- `Q20`
- `Q30`
- `Q31`

## Approximate Variable Blocks

- `ResponseId` identifies the survey response record.
- `Q55_1_0` records the school RBD identifier.
- `Q6`, `Q8`, `Q10`, and `Q11_*` describe school practices for assigning students to class groups or tracks, including whether assignments remain stable over time and whether specific assignment rules are used.
- `Q11_4_TEXT` contains open-text detail associated with one of the student-assignment response options.
- `Q14` and `Q15` describe school practices related to end-of-year teacher meetings and possible adjustments to student grades.
- `Q16`, `Q19`, and `Q20` describe remedial, reinforcement, or PSU-preparation classes offered to fourth-year high school students.
- `Q30` and `Q31` describe when preparation activities for higher education begin and how much time students spend on those activities.




