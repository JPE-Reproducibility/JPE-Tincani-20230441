## Potential Personal Identifiable Information (PII)

⚠️ We found the following instances of potentially personally identifying information. This may be completely legitimate but might be worth checking. *As a reminder, privacy legislation in many countries (e.g. GDPR in EU) prohibits the dissemination of personal identifiable information without prior (and documented) consent of individuals.* If indeed you want to publish such information with your replication package, you should probably have obtained IRB approval for this - please check!

**Summary:**

- Data files with PII indicators: 13
- Variables flagged in data: 34
- Code files with PII references: 351
- PII references in code: 32406

### Summary of Flagged Files

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
| Data | `A_INSCRITOS_PUNTAJES_PSU_2018_PRIV_MRUN.csv` | 2 | sex, loc |
| Data | `Cuestionario+-+Jefe_December+18%252C+2017_13.56_rp.dta` | 1 | son |
| Data | `archivo_E_PACE_2018_MRUN.csv` | 2 | sex, loc |
| Data | `basefinal_rp.dta` | 4 | sex, dob, son |
| Data | `distance_pace_ucl.dta` | 1 | school |
| Data | `enrollment_university_geocoded.csv` | 2 | lat, lon |
| Data | `enrollment_university_geocoded.dta` | 2 | lat, lon |
| Data | `high_school_geocoded.csv` | 4 | lat, school, lon |
| Data | `high_school_geocoded.dta` | 4 | lat, school, lon |
| Data | `ranking_applications_high_school_geocoded.csv` | 4 | lat, school, lon |
| Data | `ranking_applications_high_school_geocoded.dta` | 4 | lat, school, lon |
| Data | `ranking_applications_university_geocoded.csv` | 2 | lat, lon |
| Data | `ranking_applications_university_geocoded.dta` | 2 | lat, lon |
| Code | `0.Main.do` | 12 | son, loc, school |
| Code | `00.setup.do` | 8 | loc, son |
| Code | `01.run_1_8_data_construction.do` | 20 | loc, school, second, minute |
| Code | `02.run_9_11_submission_tables_figures.do` | 9 | loc, second, minute |
| Code | `1.Clean_GPA.do` | 96 | school, name, loc, lon, lat |
| Code | `10.Figures.do` | 133 | lat, school, loc, degree, social, lon, name, location |
| Code | `11.Data_for_model_estimation_rescale.do` | 136 | school, name, loc, lat, degree, location, lon |

*See [Appendix](report-pii-appendix.md) for detailed listing of all flagged instances.*
