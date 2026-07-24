# Codebook Note for `experimental_school_list.dta` and `pace221_ucl.xlsx`

This note documents two school-list inputs used in the PACE replication package. Both files identify schools in the experimental PACE sample, but they contain different amounts of school-level information.

## `experimental_school_list.dta`

This dataset contains the core experimental school assignment information. It has one observation per school included in the experimental school list.

### Variables

- `rbd`
- `treatment`

### Variable Summary

- `rbd`: official school identifier.
- `treatment`: treatment assignment indicator for the experiment. This variable identifies whether the school was assigned to the PACE treatment group or to the comparison/control group.

## `pace221_ucl.xlsx`

This Excel file contains the list of 221 experimental schools used by the replication pipeline. 

### Variables

- `rbd`
- `nom_rbd`
- `cod_reg_rbd`
- `cod_com_rbd`
- `nom_com_rbd`
- `grupo_pace`

### Variable Summary

- `rbd`: official school identifier.
- `nom_rbd`: school name.
- `cod_reg_rbd`: region code for the school.
- `cod_com_rbd`: commune code for the school.
- `nom_com_rbd`: commune name for the school.
- `grupo_pace`: PACE group classification for the school.


