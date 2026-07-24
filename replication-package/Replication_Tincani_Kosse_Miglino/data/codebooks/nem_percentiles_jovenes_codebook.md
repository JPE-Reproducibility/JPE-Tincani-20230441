# Codebook Note for `NEM_PERCENTILES_JOVENES`

This note documents the `NEM_PERCENTILES_JOVENES` dataset. The dataset includes student-level high school GPA information and within-school ranking measures calculated by MinEduc.

## Variable Names

- `RBD`
- `COD_DEPE`
- `AGNO_EGRESO`
- `MRUN`
- `NEM`
- `PERCENTIL`
- `PUESTO_10`
- `PUESTO_30`

## Variable Summary

- `RBD`: school identifier.
- `COD_DEPE`: school administrative dependency code.
- `AGNO_EGRESO`: high school graduation year.
- `MRUN`: masked student identifier.
- `NEM`: high school GPA score, based on `Notas de Ensenanza Media`.
- `PERCENTIL`: student's within-school percentile rank calculated by MinEduc.
- `PUESTO_10`: yes/no indicator for whether the student is in the relevant top-10 ranking group within the school, coded with text values `SI` and `NO`.
- `PUESTO_30`: yes/no indicator for whether the student is in the relevant top-30 ranking group within the school, coded with text values `SI` and `NO`.

## General Description

This dataset provides MinEduc-calculated measures of students' high school academic performance and their relative position within their school cohort. It identifies students and schools, records the high school graduation year, reports the NEM measure, and includes MinEduc's within-school percentile and top-ranking indicators.
