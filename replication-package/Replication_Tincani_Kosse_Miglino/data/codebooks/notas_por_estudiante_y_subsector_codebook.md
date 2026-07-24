# Codebook Note for `Notas_por_estudiante_y_subsector` Datasets

This note documents the `Notas_por_estudiante_y_subsector` datasets used in the active Stata pipeline. These datasets contain student-level high school grades by subject. In the replication code, they are used to construct GPA measures by subject category for students.

## Source Files

The active pipeline uses the following files from the GPA raw-data folder:

- `20150316_Notas_por_estudiante_y_subsector_2014_20150218_PUBL.csv`
- `20160226_Notas_por_estudiante_y_subsector_2015_20160131_PUBL.csv`
- `20170315_Notas_por_estudiante_y_subsector_2016_20170131_PUBL.csv`
- `20180220_Notas_por_estudiante_y_subsector_2017_20180131_PUBL.csv`


## Variables Used From These Datasets

The active pipeline does not use every column in the raw files. The variables used from the `Notas_por_estudiante_y_subsector` files are:

- `mrun`
- `rbd`
- `cod_ense`
- `cod_ense2`
- `cod_grado`
- `nota_num`
- `tipo_subsector`
- `nom_subsector`

## Variable Summary

- `mrun`: masked student identifier used to aggregate subject-level records to the student level.
- `rbd`: school identifier used to merge the GPA-by-subject records.
- `cod_ense`: education-type code used in the 2014, 2015, and 2016 files to keep non-adult humanistic-scientific or technical-professional high school students.
- `cod_ense2`: education-type code used in the 2017 file to keep non-adult humanistic-scientific or technical-professional high school students.
- `cod_grado`: grade code used to select the relevant high school year in each dataset.
- `nota_num`: numeric grade by subject; this is converted from comma-decimal format and averaged across subjects within each constructed category.
- `tipo_subsector`: subject-type code used to distinguish general subjects from track-specific subjects.
- `nom_subsector`: subject name used to identify mathematics and language subjects.



