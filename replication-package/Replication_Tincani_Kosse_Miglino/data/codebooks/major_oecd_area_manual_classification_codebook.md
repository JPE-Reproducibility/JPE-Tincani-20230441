# Codebook Note for Manually Coded OECD Area Files

This note documents the datasets used to add OECD study-field classifications to degree programs in the regular and PACE application data. The OECD area fields in these files were coded manually by the research team.

## File Location

These datasets are stored in:

`confidential-data-not-for-publication/raw/major_class`

## Dataset Files

The Stata input files are:

- `regular_major_apps_with_missing_oecd_area_manually_added_area.dta`
- `PACE_major_apps_with_missing_oecd_area_manually_added_area.dta`
- `majors_regular_with_oecd_area.dta`

The corresponding CSV files are named:

- `regular_major_apps_with_missing_oecd_area.csv`
- `PACE_major_apps_with_missing_oecd_area.csv`
- `majors_regular_with_oecd_area.csv`

## Variables

The files contain program identifiers and manually assigned OECD study-field areas. Variables include:

- `nombre_carrera_regular`
- `codigo_carrera_regular`
- `oecd_area_regular`
- `codigo_carrera_PACE`
- `oecd_area_PACE`

## Variable Summary

- `nombre_carrera_regular`: program or degree name in the regular admissions data.
- `codigo_carrera_regular`: program or degree code in the regular admissions data.
- `oecd_area_regular`: OECD study-field area manually assigned by the research team for regular admissions programs.
- `codigo_carrera_PACE`: program or degree code in the PACE admissions data.
- `oecd_area_PACE`: OECD study-field area manually assigned by the research team for PACE admissions programs.
