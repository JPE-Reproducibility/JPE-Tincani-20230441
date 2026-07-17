##############################################################################
# Model estimation code 
# Authors: Enrico Miglino and Michela M. Tincani
# Year: 2026
##############################################################################


# DESCRIPTION:

# This code performs the model estimation. It comprises the following steps:

# 1. Read in initial conditions and parameters estimated outside of the model

# 2. Initialise matrices that are fixed across iterations

# 3. Estimation by indirect inference (II):
#    3a) Import auxiliary model parameters estimated from the data ("empirical moments")
#    3b) Call the Criterion_function.jl function, which calculates the value of the
#        criterion function for II at a specific value of the parameters
#    3c) Use an optimiser to minimise the criterion function

################################################################################


# ==============================================================================

#          Load packages, set paths, import functions                          

# ==============================================================================

VERSION == v"1.10.5" || error("This script must be run with Julia 1.10.5. Current version: $(VERSION)")

import Pkg
Pkg.activate(@__DIR__)


using StatFiles, DataFrames, Distributions, Random, Statistics
using LinearAlgebra
using DelimitedFiles
using StatsBase


### Set package-relative paths
const path_codes = abspath(@__DIR__)
const package_root = abspath(joinpath(path_codes, "..", ".."))
const path_processed = joinpath(
    package_root,
    "confidential-data-not-for-publication",
    "processed",
)

mkpath(path_processed)



# import functions from same directory
include(joinpath(path_codes, "Functions_rescale_fast.jl"))  


# ==============================================================================

#         Parameters estimated outside the model and fixed parameters          

# ==============================================================================
 

const param_outside_matrix = DataFrame(load(joinpath(path_processed, "parameters_estimated_outside_rescale.dta")))



const param_outside_vector=Array{Real}(param_outside_matrix[:, "param_values"]);

# Obj. prob of a regular admission
const gammat_0=param_outside_vector[1];    # constant
const gammat_1=param_outside_vector[2];    # PSU
const gammat_2=param_outside_vector[3];    # PSU_squared
const gammat_3=param_outside_vector[4];    # PSU_cube

# Selectivity of a PACE admission
const lambdaP_0=param_outside_vector[5];   # constant
const lambdaP_1=param_outside_vector[6];   # GPA cuarto medio
const lambdaP_2=param_outside_vector[7];   # GPA cuarto medio squared
const lambdaP_3=param_outside_vector[8];   # simce
const lambdaP_4=param_outside_vector[9];   # simce squared
const lambdaP_5=param_outside_vector[10];  # academicXsimce
const lambdaP_6=param_outside_vector[11];  # academic
const lambdaP_7=param_outside_vector[12];  # region 4
const lambdaP_8=param_outside_vector[13];  # region 5
const lambdaP_9=param_outside_vector[14];  # region 7
const lambdaP_10=param_outside_vector[15]; # region 8
const lambdaP_11=param_outside_vector[16]; # region 10
const lambdaP_12=param_outside_vector[17]; # region 13
const lambdaP_13=param_outside_vector[18]; # region 14
const lambdaP_14=param_outside_vector[19]; # region 15
const sigma_selP=param_outside_vector[20]; # s.d. of shock

# Selectivity of regular admission
const lambdaR_0=param_outside_vector[21];  # constant
const lambdaR_1=param_outside_vector[22];  # PSU score if positive 
const lambdaR_2=param_outside_vector[23];  # PSU score if positive squared
const lambdaR_3=param_outside_vector[24];  # simce
const lambdaR_4=param_outside_vector[25];  # simce squared 
const lambdaR_5=param_outside_vector[26];  # academicXsimce
const lambdaR_6=param_outside_vector[27];  # academic
const lambdaR_7=param_outside_vector[28];  # region 4
const lambdaR_8=param_outside_vector[29];  # region 5
const lambdaR_9=param_outside_vector[30];  # region 7
const lambdaR_10=param_outside_vector[31]; # region 8
const lambdaR_11=param_outside_vector[32]; # region 10
const lambdaR_12=param_outside_vector[33]; # region 13
const lambdaR_13=param_outside_vector[34]; # region 14
const lambdaR_14=param_outside_vector[35]; # region 15
const sigma_selR=param_outside_vector[36]; # s.d. of shock

# GPAb and PSUb functions
const betaPSUb_0=param_outside_vector[37]; # constant in PSUb
const betaPSUb_3=param_outside_vector[38]; # coeff GPA_avg_1_2 in PSUb
const betaPSUb_4=param_outside_vector[39]; # coeff simce in PSUb
const betaGPAb_0=param_outside_vector[40]; # constant in GPAb
const betaGPAb_2=param_outside_vector[41]; # coeff GPA_avg_1_2 in GPAb
const betaGPAb_3=param_outside_vector[42]; # coeff simce in GPAb


# Fixed parameters
const lambdaG1=1.0  # normalize coefficient on selectivity from utility from graduating to 1, sets scale for utilities
const euler=0.57721566490153286060651209008240243104215933593992
const size_K=3;                                             # number of unobserved types
const size_shocks=2;                                        # number of shock draws
const size_type_indep_param=20;                             # number of type independent parameters to estimate 
const size_type_dep_param=9*size_K-4;           # number of type dependent parmaterers to estimate 
const size_theta=size_type_indep_param+size_type_dep_param; # number of parameters to estimate 
const size_MCdraw=100                                       # number of MonteCarlo draws to simulate prob being in top 15%, for smoothed ProbAdmP



# ==============================================================================

#                            Import and clean data                             

# ==============================================================================

# Import data

const data = DataFrame(load(joinpath(path_processed, "initial_conditions_TC_rescale.dta")))


# Create a vector of data for each variable
const size_N=nrow(data);   #number of students in the sample
const rbd=Array{Float64}(data[:, "rbd_basefinal"]);   
const school_start_idx = [findfirst(x -> x == s, rbd) for s in unique(rbd)]
const school_end_idx = [findlast(x -> x == s, rbd) for s in unique(rbd)]
const age_data=Array{Real}(data[:, "age"]);
const female_data=Array{Real}(data[:, "female"]);
const alumno_prioritario_data=Array{Real}(data[:, "alumno_prioritario"]);
const neverfailed_data=Array{Real}(data[:, "neverfailed"]);
const modalidad_data=Array{Real}(data[:, "modalidad"]);
const GPA_1_2_rank_data=Array{Real}(data[:,"GPA_1_2_rank"]);
const GPA_avg_1_2_data=Array{Real}(data[:, "GPA_avg_1_2"]); # baseline GPA
const GPA_avg_school_1_2_data=Array{Real}(data[:, "GPA_avg_school_1_2"]);   # GPA school average in primero and segundo medio
const X=hcat(age_data, female_data, alumno_prioritario_data,neverfailed_data,modalidad_data);
const pace_data=Array{Real}(data[:, "treatment"]);
const cutoff_top15_data=Array{Real}(data[:, "actual_top15_cutoff"]);
const cutoff_top15b_data_raw=data[:, "perceived_top15_cutoff"];
const cutoff_top15b_data_missing=convert(Array{Real}, myisna(cutoff_top15b_data_raw));   #vector of elements equal to 1 if obs is missing, 0 otherwise
const cutoff_top15b=convert(Array{Real}, fill(-99.0, size_N));     #initialize vector of perceived cutoff (this is taken from data when non-missing and imputed when missing)
for i=1:1:size_N
    if cutoff_top15b_data_missing[i]==0       #if not missing
       cutoff_top15b[i]=cutoff_top15b_data_raw[i];
    else
       cutoff_top15b[i]=cutoff_top15_data[i]  # if missing we assume the student correctly predicts the cutoff - delivers lower bound on role of belief biases
    end
end
const class_code_data=Array{Real}(data[:, "class_code"]);
const simce_data=Array{Real}(data[:, "simce_avg_st"]);
const r4_data=Array{Real}(data[:, "region4"]);
const r5_data=Array{Real}(data[:, "region5"]);
const r7_data=Array{Real}(data[:, "region7"]);
const r8_data=Array{Real}(data[:, "region8"]);
const r10_data=Array{Real}(data[:, "region10"]);
const r13_data=Array{Real}(data[:, "region13"]);
const r14_data=Array{Real}(data[:, "region14"]);
const r15_data=Array{Real}(data[:, "region15"]);
const n_obs_school=Array{Int}(data[:, "num_obs_school"]);   # number of students in school
const y_data_missing=Array{Real}(data[:, "y_data_missing"]);
const eff_data_missing=Array{Real}(data[:,"hours_study_data_missing"]);
const GPA_data_missing=Array{Real}(data[:,"GPA_cuarto_medio_missing"]);
const GPA_all_years_missing=Array{Real}(data[:,"GPA_all_years_missing"]);
const mean_PSU_score_uni_major_missing=Array{Real}(data[:,"mean_PSU_score_uni_major_missing"]);
const minus_bias_top15_missing=Array{Real}(data[:,"minus_bias_top15_missing"]);
const GPAb_data_missing=Array{Real}(data[:, "exp_NEM_missing"]);
const PSUb_data_missing=Array{Real}(data[:, "exp_PSUscore_missing"]);
const exp_PSU_st=data[:, "exp_PSU_st"];
const sample_het_by_belief=Array{Real}(data[:, "sample_het_by_belief"]);  # identifies the sample with nonmissing survey answers used to estimate regression for TE by beleifs
const sit_PSU_data=Array{Real}(data[:,"sit_PSU"]);
const enrolled_SUA_data=Array{Real}(data[:, "enrolled_SUA_by_y1"]);
const enrolled_SUA_P_data=Array{Real}(data[:, "enrolled_SUA_pace"]);
const Persist_data=Array{Real}(data[:, "enrolled_SUA_by_y5"]);
const p_admR_missing=Array{Real}(data[:, "p_admitted_missing"]);
const simce_cat5_data=Array{Real}(data[:, "simce_cat5"]);
const GPA_1_2_rank_cat5_data=Array{Real}(data[:, "GPA_1_2_rank_cat5"]);
const top15baseline_data=data[:, "top15baseline"];
const think_top15_data=data[:, "think_top15"];
const think_top15April_data=data[:, "think_top15April"];
const within_med_exp_PSU_data=replace(data[:, "within_med_exp_PSU"], missing => 0.0f0);
const Pgradb_data = data[:, "Pgradb"];
const GPAb_coeff_eff_data = data[:, "GPAb_coeff_eff"];
const betaPSUb_1_data = data[:, "PSUb_coeff_eff_1"];
const betaPSUb_2_data = data[:, "PSUb_coeff_eff_2"];
const PSUb_kink_data=data[:, "PSUb_kink"]
const admitted_SUA_R=data[:, "admitted_SUA_regular"];
const admitted_SUA_P=data[:, "admitted_SUA_pace"];
const admitted_SUA_PorR=admitted_SUA_R.+admitted_SUA_P;
const exp_NEM=data[:, "exp_NEM"];
const believed_distance_from_cutoff=abs.(exp_NEM-cutoff_top15b)

const TXbelieved_distance_from_cutoff=pace_data.*believed_distance_from_cutoff;
const simceXbelieved_distance_from_cutoff=simce_data.*believed_distance_from_cutoff;
const femaleXbelieved_distance_from_cutoff=female_data.*believed_distance_from_cutoff;
const modalidadXbelieved_distance_from_cutoff=modalidad_data.*believed_distance_from_cutoff;
const GPA_avg_1_2Xbelieved_distance_from_cutoff=GPA_avg_1_2_data.*believed_distance_from_cutoff;
const PgradbXbelieved_distance_from_cutoff=Pgradb_data.*believed_distance_from_cutoff;
const GPAb_coeff_effXbelieved_distance_from_cutoff=GPAb_coeff_eff_data.*believed_distance_from_cutoff;
const betaPSUb_1Xbelieved_distance_from_cutoff=betaPSUb_1_data.*believed_distance_from_cutoff;
const betaPSUb_2Xbelieved_distance_from_cutoff=betaPSUb_2_data.*believed_distance_from_cutoff;
const PSUb_kinkXbelieved_distance_from_cutoff=PSUb_kink_data.*believed_distance_from_cutoff;
const cutoff_top15bXbelieved_distance_from_cutoff=cutoff_top15b.*believed_distance_from_cutoff;

# ==============================================================================

#                               Variables Space          

# ==============================================================================

# Set number of effort grid points; set seed
const size_Eff=11;                          # number of grid points for effort
const size_sim_eff=20;                      # simulations to smooth effort
const eff_grid=[0;1;2;3;4;5;6;7;8;9;10];    # grid for effort
Random.seed!(123456)                        # set seed





# ==============================================================================

#                      Initialisations - fixed across iterations  

# ==============================================================================

# size_shocks shocks per person 
# Standardised RVs - parameter independent, initialised outside Criterion_Function.jl
const psi=rand(Normal(0.0,1.0), size_N, size_shocks); # shocks in regular admission
const ePSUreg=rand(Logistic(0.0,1.0), size_N, size_shocks);   # preference shocks on PSU registration
const nuR=rand(Logistic(0.0,1.0), size_N, size_shocks);     # preference shocks in regular enrolment
const nuP=rand(Logistic(0.0,1.0), size_N, size_shocks);     # preference shocks in PACE enrolment.
const dist_stNormal=Normal(0,1.0);                          # standard normal distribution
const latent_type_sim=rand(Uniform(0,1),size_N, size_shocks);
const latent_dropout_sim=rand(Uniform(0,1),size_N, size_shocks);


# Matrices of choices that are fully updated at each iteration --> no need to re-initialise at each iteration
const Eff_sim=Array{Real,2}(undef,size_N,size_shocks)                #  matrix of simulated (latent) effort levels
const Eff_sim_observed=Array{Real,2}(undef,size_N,size_shocks)

const GPA_sim=zeros(Real,size_N, size_shocks);                      #  own GPA

const PSU_sim=zeros(Real,size_N, size_shocks);                      #  PSU score 

const sit_PSU_sim=zeros(Real,size_N, size_shocks);                  #  choice of taking the PSU

const AdmP_sim=zeros(Real,size_N, size_shocks);                     #  PACE admission

const AdmR_sim=zeros(Real,size_N, size_shocks);                     #  regular admission

const AdmRorP_sim=zeros(Real,size_N, size_shocks); 


const selectivity_P_sim=zeros(Real,size_N, size_shocks);            #  selectivity PACE admission

const selectivity_R_sim=zeros(Real,size_N, size_shocks);            #  selectivity regular admission




# Enrollments 
const ER_sim=zeros(Real,size_N, size_shocks);                       #  regular enrollment 

const EP_sim=zeros(Real,size_N, size_shocks);                       #  PACE enrollment 

const EPR_sim=zeros(Real,size_N,size_shocks);                       #  enrollment (PACE or regular) # convert(Array{Real}, fill(0.0, size_N,size_shocks))



# Persistence 
const Persist_sim=zeros(Real,size_N,size_shocks);                   #  enroll and persist in SUA 

# Shocks to selectivity of selective college programme
const shock_selP=rand(Normal(0.0,sigma_selP), size_N, size_shocks);
const shock_selR=rand(Normal(0.0,sigma_selR), size_N, size_shocks);

const omega_0=Vector{Real}(undef,size_K); # constant 
const omega_1=Vector{Real}(undef,size_K); # missing survey
const omega_2=Vector{Real}(undef,size_K); # female
const omega_3=Vector{Real}(undef,size_K); # top15 at baseline
const omega_0[1]=0.00 # Normalisation for type 1 in multinomial logit function
const omega_1[1]=0.00
const omega_2[1]=0.00
const omega_3[1]=0.00

const k_vec=ones(Real,size_N, size_shocks);  # type
const p_type_i=zeros(Real,size_K,size_N)
const cump_type_i=zeros(Real,size_K,size_N)

# Top 15 actual 
const cutoff_top15_sim=zeros(Real,size_N, size_shocks);             #  actual top 15 cutoff
const element_pos=Vector{Real}(undef,1)
const top15_sim=zeros(Real,size_N,size_shocks);                     #  being in the top 15
const prob_top15=zeros(Real,size_N,size_shocks);                     #  prob of being in the top 15    

# Perceived achievement and admission likelihoods at chosen effort levels
const expGPAb_sim=zeros(Real,size_N, size_shocks);                  #  expected GPA belief
const expPSUb_sim=zeros(Real,size_N, size_shocks);                  #  expected PSU belief


const Pr_PACEslot_b_sim=zeros(Real,size_N,size_shocks);             #  subjective probability of PACE admission 
const Pr_Admitted_R_b_sim=zeros(Real,size_N,size_shocks);           #  subjective probability of regular admission 


# Selectivity of enrollment
const selectivity_sim=zeros(Real,size_N, size_shocks);            #  selectivity enrollment (R or P)




# ==============================================================================

#             Estimation: Generalized indirect inference                              
     
# ==============================================================================

# Import parameters of auxiliary models obtained from the data ("empirical moments")

 
const matrix_empirical_moments = DataFrame(load(joinpath(path_processed, "empirical_coefficients_rescale.dta")))
const vector_empirical_moments=Array{Real}(matrix_empirical_moments[:, "coefficient_value"]);
const vector_empirical_moments_weights=Array{Real}(matrix_empirical_moments[:, "weight"]);

const num_moments=length(vector_empirical_moments)
const vector_empirical_moments_weights_adjw=convert(Array{Real,1}, fill(0.0, num_moments));
const matrix_simulated_moments=convert(Array{Real,2}, fill(0.0, num_moments,size_shocks));
const vector_simulated_moments=convert(Array{Real,1}, fill(0.0, num_moments));
const vec_diff=convert(Array{Real,1}, fill(0.0, num_moments));
const unit_vec=convert(Vector{Real},fill(1.0,size_N))

# * Precompute constant DataFrame components for regressions
const outcomes_sim = DataFrame(
      unit_vec_S = unit_vec,
      treatment_S = pace_data,
      GPA_avg_1_2_S = GPA_avg_1_2_data,
      female_S = female_data,
      modalidad_S = modalidad_data,
      simce_avg_st_S = simce_data,
      survey_missing_S = y_data_missing,
      Pgradb_S = Pgradb_data,
      GPAb_coeff_eff_S = GPAb_coeff_eff_data,
      betaPSUb_1_S = betaPSUb_1_data,
      betaPSUb_2_S = betaPSUb_2_data,
      PSUb_kink_S = PSUb_kink_data,
      cutoff_top15b_S = cutoff_top15b,
      hours_study_missing_S = eff_data_missing,
      exp_PSUscore_S = exp_PSU_st,
      expPSUb_data_missing_S = PSUb_data_missing,
      GPA_data_missing_S = GPA_data_missing,
      believed_distance_from_cutoff_S = believed_distance_from_cutoff,
      TXbelieved_distance_from_cutoff_S = TXbelieved_distance_from_cutoff,
      femaleXbelieved_distance_from_cutoff_S = femaleXbelieved_distance_from_cutoff,
      simceXbelieved_distance_from_cutoff_S = simceXbelieved_distance_from_cutoff,
      modalidadXbelieved_distance_from_cutoff_S = modalidadXbelieved_distance_from_cutoff,
      GPA_avg_1_2Xbelieved_distance_from_cutoff_S = GPA_avg_1_2Xbelieved_distance_from_cutoff,
      PgradbXbelieved_distance_from_cutoff_S = PgradbXbelieved_distance_from_cutoff,
      GPAb_coeff_effXbelieved_distance_from_cutoff_S = GPAb_coeff_effXbelieved_distance_from_cutoff,
      betaPSUb_1Xbelieved_distance_from_cutoff_S = betaPSUb_1Xbelieved_distance_from_cutoff,
      betaPSUb_2Xbelieved_distance_from_cutoff_S = betaPSUb_2Xbelieved_distance_from_cutoff,
      PSUb_kinkXbelieved_distance_from_cutoff_S = PSUb_kinkXbelieved_distance_from_cutoff,
      cutoff_top15bXbelieved_distance_from_cutoff_S = cutoff_top15bXbelieved_distance_from_cutoff,
      cutoff_top15b_data_missing_S = cutoff_top15b_data_missing,
      expGPAb_data_missing_S = GPAb_data_missing,
      AdmRorP_data_S = admitted_SUA_PorR,
      In_top15_data_S = top15baseline_data,
      AdmR_data_S = admitted_SUA_R,
      AdmP_data_S = admitted_SUA_P,
      sit_PSU_data_S = sit_PSU_data,
      In_top15_S = top15baseline_data
  )
# * Precompute conditions that are used in mean calculations
mask_female_0 = (female_data .== 0.0)
mask_female_1 = (female_data .== 1.0)
mask_treatment_0 = (pace_data .== 0.0)
mask_treatment_1 = (pace_data .== 1.0)
mask_top15_1 = (top15baseline_data .== 1.0)
mask_hours_study_missing_0 = (eff_data_missing .== 0.0)
mask_GPA_missing_0 = (GPA_data_missing .== 0.0)
mask_expPSU_missing_0 = (PSUb_data_missing .== 0.0)
mask_expGPA_missing_0 = (GPAb_data_missing .== 0.0)
mask_survey_missing_0 = (y_data_missing .== 0.0)
mask_AdmP_1 = (admitted_SUA_P .== 1.0)  # Students admitted via P
mask_AdmR_1 = (admitted_SUA_R .== 1.0)  # Students admitted via R
mask_AdmPorR_1 = (admitted_SUA_R .== 1.0).|  (admitted_SUA_P .== 1.0) # Students admitted via R
mask_sit_PSU_1=(sit_PSU_data .== 1.0)
mask_enrolled_SUA_1=(enrolled_SUA_data .== 1.0)
# * Dependent variables for each regression
const data_reg_1_2 = Matrix(outcomes_sim[:, 
  ["unit_vec_S", "female_S", "survey_missing_S",
  "GPA_avg_1_2_S", "simce_avg_st_S", 
  "Pgradb_S", "GPAb_coeff_eff_S", "betaPSUb_1_S", "betaPSUb_2_S", "PSUb_kink_S",
  "cutoff_top15b_S", "modalidad_S"]])
const data_reg_3 = Matrix(outcomes_sim[mask_hours_study_missing_0, 
  ["unit_vec_S", "female_S", "survey_missing_S",
  "GPA_avg_1_2_S", "simce_avg_st_S", 
  "Pgradb_S", "GPAb_coeff_eff_S", "betaPSUb_1_S", "betaPSUb_2_S", "PSUb_kink_S", 
  "cutoff_top15b_S", "modalidad_S"]])
const data_reg_4 = Matrix(outcomes_sim[mask_hours_study_missing_0, 
  ["unit_vec_S", "simce_avg_st_S"]])
const data_reg_5_7 = Matrix(outcomes_sim[mask_treatment_0,
  ["unit_vec_S", "female_S", "survey_missing_S"]]) 
const data_reg_8_10_12 = Matrix(outcomes_sim[:, ["unit_vec_S", "treatment_S", 
  "GPA_avg_1_2_S", "simce_avg_st_S", 
  "Pgradb_S", "GPAb_coeff_eff_S", "betaPSUb_1_S", "betaPSUb_2_S", "PSUb_kink_S", 
  "cutoff_top15b_S", "modalidad_S","female_S"]])
const data_reg_14_16_18 = Matrix(outcomes_sim[mask_top15_1, ["unit_vec_S", "treatment_S", 
  "GPA_avg_1_2_S", "simce_avg_st_S", 
  "Pgradb_S", "GPAb_coeff_eff_S", "betaPSUb_1_S", "betaPSUb_2_S", "PSUb_kink_S", 
  "cutoff_top15b_S", "modalidad_S","female_S"]])
const data_reg_20_21 = Matrix(outcomes_sim[mask_expPSU_missing_0.&mask_treatment_0, 
  [ "exp_PSUscore_S","unit_vec_S"]])
const data_reg_22_23 = Matrix(outcomes_sim[mask_treatment_0, 
  ["unit_vec_S", "female_S", "survey_missing_S"]])
const data_reg_24_25 = Matrix(outcomes_sim[mask_treatment_0, 
["unit_vec_S","GPA_avg_1_2_S", "simce_avg_st_S", 
 "survey_missing_S", "female_S"]])
const data_reg_26_27 = Matrix(outcomes_sim[mask_GPA_missing_0,
["unit_vec_S", "female_S", "survey_missing_S",
  "GPA_avg_1_2_S", "simce_avg_st_S", 
  "Pgradb_S", "GPAb_coeff_eff_S", "betaPSUb_1_S", "betaPSUb_2_S", "PSUb_kink_S", 
  "cutoff_top15b_S", "modalidad_S"]])
const data_reg_28_30 = Matrix(outcomes_sim[mask_GPA_missing_0 .& mask_hours_study_missing_0,
  ["GPA_avg_1_2_S", "simce_avg_st_S", "unit_vec_S",  
   "Pgradb_S", "GPAb_coeff_eff_S", "betaPSUb_1_S", "betaPSUb_2_S", "PSUb_kink_S", 
   "cutoff_top15b_S", "modalidad_S"]])
const data_reg_31_32 = Matrix(outcomes_sim[:, 
    ["unit_vec_S", "female_S", "simce_avg_st_S", "survey_missing_S"]])
const data_reg_33 = Matrix(outcomes_sim[mask_treatment_0.&mask_AdmPorR_1,
    ["unit_vec_S", "Pgradb_S"]])
const data_reg_34 = Matrix(outcomes_sim[mask_hours_study_missing_0,
    ["unit_vec_S", "treatment_S", "GPA_avg_1_2_S", "simce_avg_st_S", 
      "Pgradb_S", "GPAb_coeff_eff_S", "betaPSUb_1_S", "betaPSUb_2_S", "PSUb_kink_S", 
      "cutoff_top15b_S", "modalidad_S", "female_S"]]) 
const data_reg_36 = Matrix(outcomes_sim[:,
    ["unit_vec_S", "treatment_S", "GPA_avg_1_2_S", "simce_avg_st_S", 
      "Pgradb_S", "GPAb_coeff_eff_S", "betaPSUb_1_S", "betaPSUb_2_S", "PSUb_kink_S", 
      "cutoff_top15b_S", "modalidad_S", "female_S"]])
const data_reg_38 = Matrix(outcomes_sim[mask_hours_study_missing_0.& mask_expGPA_missing_0, 
      ["unit_vec_S", "believed_distance_from_cutoff_S", 
      "TXbelieved_distance_from_cutoff_S", "treatment_S",
      "femaleXbelieved_distance_from_cutoff_S","female_S", 
      "simceXbelieved_distance_from_cutoff_S","simce_avg_st_S",
      "modalidadXbelieved_distance_from_cutoff_S", "modalidad_S",
      "GPA_avg_1_2Xbelieved_distance_from_cutoff_S","GPA_avg_1_2_S",  
      "PgradbXbelieved_distance_from_cutoff_S", "Pgradb_S", 
      "GPAb_coeff_effXbelieved_distance_from_cutoff_S","GPAb_coeff_eff_S",
      "betaPSUb_1Xbelieved_distance_from_cutoff_S","betaPSUb_1_S", 
      "betaPSUb_2Xbelieved_distance_from_cutoff_S","betaPSUb_2_S", 
      "PSUb_kinkXbelieved_distance_from_cutoff_S","PSUb_kink_S", 
      "cutoff_top15bXbelieved_distance_from_cutoff_S","cutoff_top15b_S"]])

const data_reg_52 = Matrix(outcomes_sim[mask_enrolled_SUA_1 .&mask_top15_1, ["unit_vec_S", "treatment_S"]]) 

println("Starting optimization")


include(joinpath(path_codes, "Criterion_Function_rescale_fast_3types.jl"));


## The following starting value was obtained from an optmization  with the bounds specified in lines 500-511, and with the following tolerances:
#     NLopt.xtol_rel!(opt, 1e-5)
#     NLopt.ftol_rel!(opt, 1e-5)

theta0=[-0.39504983869964433, -1.495155563200128, -0.4460002752705829, 4.238572124669247, 3.862968368290951, 2.131630793236246, -0.7148572234197386, -1.1609338841827763, -6.480407651592333, 0.005435368778840147, -0.19246201089707615, 2.4841002133663515, 0.022271896997265467, -0.22530184279404328, 0.13395505763669763, 1.4038772749569643, -0.6539872934449443, 0.6978158567762968, -0.8264413652648581, -0.21077387292735297, -1.736577754188924, -1.6270941733922402, -3.9269723263565712, -4.9839775688599515, 0.985220275784541, -0.007293505715661345, 0.14105410451508438, 0.19606915056863652, 0.4390171527286303, 5.186329471329255, 0.9479266783907317, 2.0230692650292967, 0.1608008859584798, 0.01748846584343151, 0.32713363533546264, 0.04023231162274618, 0.3227199199338218, 0.0037405455345805526, 0.1387586665555873, 0.2437647479021046, 0.07356492423376924, 0.0334472417087555, 0.578437128236742]


  
      using NLopt
      # Create the NLopt optimizer with ISRES (global optimization)
      # Define bounds for all variables. Local search to speed up convergence. 
      lower_bounds = theta0 .- 0.01 .* abs.(theta0)
      upper_bounds = theta0 .+ 0.01 .* abs.(theta0)


      # Bounds used in the initial estimation, whose output is used as initial value for the estimation in this script.
     # lower_bounds[9*size_K-2] = max(lower_bounds[9*size_K-2], 1e-5)  # Constraint on difference between expGPAb-expCutoff_top15_b
     # lower_bounds[9*size_K+7] = max(lower_bounds[9*size_K+7], 1e-5)  # Constraint on linear coef of effort in GPA 
     # lower_bounds[9*size_K+11] = max(lower_bounds[9*size_K+11], 1e-5)  # Constraint on linear coef of effort in PSU 
     # lower_bounds[9*size_K+4] = max(lower_bounds[9*size_K+4], 1e-5) # stigma on pace enrollment
     # lower_bounds[9*size_K] = max(lower_bounds[9*size_K], 1e-5) # cost of sitting PSU in treatment
     # lower_bounds[9*size_K+1] = max(lower_bounds[9*size_K+1], 1e-5) # cost of sitting PSU
     # lower_bounds[9*size_K+6] = max(lower_bounds[9*size_K+6], 1e-5)  # Constraint on measurement error for effort
     # lower_bounds[9*size_K+10] = max(lower_bounds[9*size_K+10], 1e-5)  # Constraint on GPA shock
     # lower_bounds[9*size_K+14] = max(lower_bounds[9*size_K+14], 1e-5)  # Constraint on PSU shock
      # lower_bounds[9*size_K+15] = 1e-5  # Constraint on coeff on effort in peristence
      # lower_bounds[9*size_K-2] = 1e-5  # Constraint on GPAb-cutoffb coefficient in subj prob pace admission
      # lower_bounds[9*size_K+3] = 1e-5   # Constraint on PSU coefficient in subj prob reg admission
      
      # Define the optimizer
      opt = NLopt.Opt(:GN_ISRES, size_theta)
      NLopt.srand(123456)

      # Set bounds for the optimization
      NLopt.lower_bounds!(opt, lower_bounds)
      NLopt.upper_bounds!(opt, upper_bounds)

      # Set optimization parameters
      NLopt.xtol_rel!(opt, 1e-4)
      NLopt.ftol_rel!(opt, 1e-4)
      #NLopt.maxeval!(opt, 100000)

      # Set the objective function for optimization
      NLopt.min_objective!(opt,  obj_func)

open(joinpath(path_processed, "estimation_output_rescale_fast_3types.txt"), "w") do io
    redirect_stdout(io)

    min_f, min_x, ret = NLopt.optimize(opt, theta0)

    println("\nOptimal solution: ", min_x)
    println("Optimal objective value: ", min_f)
    println("Exit status: ", ret)

    writedlm(joinpath(path_processed, "estimation_theta_rescale_fast_3types.csv"), min_x, ',')
end
      
  






