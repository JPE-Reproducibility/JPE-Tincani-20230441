## Potential Personal Identifiable Information (PII)

⚠️ We found the following instances of potentially personally identifying information. This may be completely legitimate but might be worth checking. *As a reminder, privacy legislation in many countries (e.g. GDPR in EU) prohibits the dissemination of personal identifiable information without prior (and documented) consent of individuals.* If indeed you want to publish such information with your replication package, you should probably have obtained IRB approval for this - please check!

**Summary:**

- Data files with PII indicators: 0
- Variables flagged in data: 0
- Code files with PII references: 351
- PII references in code: 32406

### Summary of Flagged Files

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
| Code | `0.Main.do` | 12 | son, loc, school |
| Code | `00.setup.do` | 8 | loc, son |
| Code | `01.run_1_8_data_construction.do` | 20 | loc, school, second, minute |
| Code | `02.run_9_11_submission_tables_figures.do` | 9 | loc, second, minute |
| Code | `1.Clean_GPA.do` | 96 | school, name, loc, lon, lat |
| Code | `10.Figures.do` | 133 | lat, school, loc, degree, social, lon, name, location |
| Code | `11.Data_for_model_estimation_rescale.do` | 136 | school, name, loc, lat, degree, location, lon |
| Code | `12.Empirical_coefficients_rescale.do` | 115 | name, loc |
| Code | `13.Create_bootstrap.do` | 134 | son, loc, school, name, lat |
| Code | `14.Estimation_rescale_fast_adjw_20shocks.jl` | 16 | lat, school, son, loc |
| Code | `15.Simulations_rescale.jl` | 80 | lon, lat, school, son |
| Code | `16.Simulations_rescale_CC.jl` | 82 | lon, lat, school, son |
| Code | `17.Simulations_RE_and_PACE.jl` | 125 | school, lat, son, lon |
| Code | `18.Simulations_effpers_and_PACE_revision2round_baseline.jl` | 85 | lat, lon, school, son |
| Code | `19.Calculate_bias_RE_cutoff.do` | 7 | lat, son, loc, name |
| Code | `2.Clean_simce.do` | 62 | father, house, name, gender, school, lon, mother, loc, child, second |
| Code | `20.Simulations_top5.jl` | 195 | school, lat, son, lon, lname, name |
| Code | `21.Simulations_top10.jl` | 195 | school, lat, son, lon, lname, name |
| Code | `22.Simulations_top15.jl` | 195 | school, lat, son, lon, lname, name |
| Code | `23.Simulations_top20.jl` | 195 | school, lat, son, lon, lname, name |

*See [Appendix](report-pii-appendix.md) for detailed listing of all flagged instances.*
