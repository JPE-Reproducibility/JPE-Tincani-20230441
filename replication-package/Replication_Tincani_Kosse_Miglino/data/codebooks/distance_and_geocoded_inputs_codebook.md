# Codebook Note for Distance and Geocoded Input Datasets

This note documents a set of raw input datasets used to measure distances between PACE schools and higher education institutions, and to provide geocoded locations for schools, applications, and university campuses. These files should be treated as confidential input data where indicated below.

## Distance Dataset

### `distance_pace_ucl.dta`

Variables included:

- `rbd_basefinal`
- `grupo_pace`
- `distance_pace`
- `distance_any_pace`
- `distance_cruch_pace`
- `distance_vocational_pace`

This dataset was created by professionals at CEM for the research team. It contains distance measures between each PACE school, identified by `rbd_basefinal`, and different types of higher education institutions participating in the PACE program. The distance variables distinguish between PACE institutions overall, any PACE institution, CRUCH PACE institutions, and vocational PACE institutions.

## Geocoded Input Datasets

The following datasets are provided as raw geocoded inputs. The research team geocoded longitude and latitude from town information using `8.Geolocalize.do` and the `opencagegeo` tool. Because this process requires a paid OpenCage API key, a replicator must independently obtain a valid key to rerun `8.Geolocalize.do`.

For this reason, the geocoded outputs are provided directly as confidential input data. 

### `enrollment_university_feocoded.dta`

Variables included:

- `nomb_inst`
- `nomb_sede`
- `comuna_sede`
- `latitude_university`
- `longitude_university`
- `region_university`
- `town_university`

This dataset contains geocoded location information for higher education enrollment records or university campuses, including institution and campus names, commune information, latitude and longitude, and standardized region and town fields.

### `high_school_geocoded`

Variables included:

- `rbd_basefinal`
- `nom_com_rbd`
- `nom_deprov_rbd`
- `latitude_high_school`
- `longitude_high_school`
- `region_high_school`
- `town_high_school`

This dataset contains geocoded location information for high schools, including school identifiers, commune and provincial department names, latitude and longitude, and standardized region and town fields.

### `ranking_applications_high_school_geocoded`

Variables included:

- `nom_com_rbd`
- `nom_deprov_rbd`
- `latitude_high_school`
- `longitude_high_school`
- `region_high_school`
- `town_high_school`

This dataset contains geocoded high school location information used in the ranking applications data, including commune and provincial department names, latitude and longitude, and standardized region and town fields.

### `ranking_applications_university_geocoded`

Variables included:

- `sede_carrera`
- `sigla_universidad`
- `nombre_universidad`
- `latitude_university`
- `longitude_university`
- `region_university`
- `town_university`

This dataset contains geocoded university or campus location information used in the ranking applications data, including campus or program-campus identifiers, university abbreviations and names, latitude and longitude, and standardized region and town fields.
