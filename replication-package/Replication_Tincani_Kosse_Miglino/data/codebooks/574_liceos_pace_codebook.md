# Codebook Note for `574 liceos PACE.dta`

This note documents the dataset `574 liceos PACE.dta`. The dataset contains 574 observations and 13 variables, with one record per PACE high school. 

## General Description

This dataset lists PACE high schools and includes school identifiers, school names, location information, the year in which the school entered PACE, indicators related to 2018 higher education institutions or sites, administrative and school-type classifications, survey participation information, and indicators for specific school groups such as Bicentenario schools and the 2016 randomization sample.

## Variable Names

- `rbd`
- `nombredelestablecimiento`
- `region`
- `comuna`
- `AñoPACE`
- `ies2018`
- `sle`
- `y4M`
- `mod`
- `encuesta`
- `sedes`
- `bicentenario`
- `aleatorio2016`

## Variable Summary

| Variable | Stata type | Stata label | Suggested English meaning |
|---|---:|---|---|
| `rbd` | `long` | `RBD` | Official school identifier. |
| `nombredelestablecimiento` | `str73` | `NOMBRE DEL ESTABLECIMIENTO` | Name of the educational establishment. |
| `region` | `str43` | `REGION` | Region where the school is located. |
| `comuna` | `str20` | `COMUNA` | Commune where the school is located. |
| `AñoPACE` | `int` | `Año PACE` | Year in which the school entered or was associated with the PACE program. |
| `ies2018` | `str6` | `IES 2018` | Indicator or classification |
| `sle` | `str5` | `SLE` | Indicator or classification related to Local Education Services. |
| `y4M` | `int` | `3y4°M` | Count or indicator related to students in third and fourth year of high school. |
| `mod` | `str11` | `Mod.` | School modality or education track classification. |
| `encuesta` | `str1` | `Encuesta` | Survey participation or survey-related indicator. |
| `sedes` | `str1` |  | Indicator related to sites or campuses. |
| `bicentenario` | `str1` | `Bicentenario` | Indicator for Bicentenario school status. |
| `aleatorio2016` | `byte` | `Aleatorio 2016` | Indicator for inclusion in the 2016 randomized sample or randomization group. |

## Notes

The variable meanings above are based on the variable names and Stata labels. For variables with compact labels, such as `ies2018`, `sle`, `y4M`, `mod`, `encuesta`, and `sedes`, the suggested English meanings should be treated as draft metadata unless confirmed against the original data documentation.
