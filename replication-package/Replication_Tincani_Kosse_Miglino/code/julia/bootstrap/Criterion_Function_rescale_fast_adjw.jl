############################################################

# This code computes the value of the criterion function
# for the MSM at one candidate value of the parameters

############################################################


# Authors: Enrico Miglino and Michela M. Tincani
# Year: 2024

function obj_func(theta::Vector{Float64}, grad::Vector{Float64})


    start_time=time()
    Random.seed!(060644)                        # set seed
    
    # ================================================================
    
    #                          Parameters initialisation   
    
    # ================================================================
 # * Efficient slicing for type-dependent parameters
lambdaPR_0 = @view theta[1:size_K]

# Objective GPA production function
betaGPA_0 = @view theta[size_K+1:2*size_K]

# Objective PSU production function
betaPSU_0 = @view theta[2*size_K+1:3*size_K]

# Constant in actual p_persist_actual, exogenous stochastic process
theta_ppersist0 = @view theta[3*size_K+1:4*size_K]

# Convex cost of study effort, linear term
xi_1 = @view theta[4*size_K+1:5*size_K]

# * Vectorized `omega_0` to `omega_3` Assignment (Avoids Loop)
if size_K > 1
    k_range = 2:size_K
    omega_0[k_range] .= @view theta[5*size_K .+ (k_range .- 1)]
    omega_1[k_range] .= @view theta[6*size_K .+ (k_range .- 2)]
    omega_2[k_range] .= @view theta[7*size_K .+ (k_range .- 3)]
    omega_3[k_range] .= @view theta[8*size_K .+ (k_range .- 4)]
end

#--------------------------------
# * Type-independent parameters (Batch Assignment for Speed)
#--------------------------------

zetabpace_0, zetabpace_1, xi_2, costSTreat, costS, gammab_0, gammab_1, delta, lambdaG0, sigma_error_eff,
betaGPA_1, betaGPA_2, betaGPA_3, sigma_eGPA,
betaPSU_1, betaPSU_2, betaPSU_3, sigma_ePSU = @view theta[9*size_K-3:9*size_K+14]

# * Actual persistence probability
theta_ppersist = @view theta[9*size_K+15:9*size_K+16]

        
    # ==============================================================================
    
    #                       Initialisations - varying across iterations    
    
    # ==============================================================================
    # NB: "_obs" in the name means that it includes the measurement error or, for the PSU score, that it is generated only for those
    #     simulted to take the PSU
    
        # Reset all simulated outcomes
        Eff_sim[:,:].=0;   
        GPA_sim[:,:].=0.0;
        PSU_sim[:,:].=0.0;
        sit_PSU_sim[:,:].=0.0;
        AdmP_sim[:,:].=0.0;
        AdmR_sim[:,:].=0.0;
        AdmRorP_sim[:,:].=0.0;
        selectivity_P_sim[:,:].=0.0;
        selectivity_R_sim[:,:].=0.0;
        selectivity_sim[:,:].=0.0;
        ER_sim[:,:].=0.0;
        EP_sim[:,:].=0.0;
        EPR_sim[:,:].=0.0;
        Persist_sim[:,:].=0.0;
        k_vec[:,:].=1;
        top15_sim[:,:].=0.0;
        cutoff_top15_sim[:,:].=0.0;
        matrix_simulated_moments[:,:].=0.0;

    # ==============================================================================
    
    #                              Generate shock realisations
    
    # ==============================================================================

    if size_K > 1
      # Compute omegax for all individuals at once (size_N × size_K)
      omegax = (omega_0)' .+ y_data_missing.*(omega_1)' .+ female_data.*(omega_2)' .+ top15baseline_data.*(omega_3)'
  
      # Compute multinomial logit probabilities (vectorized softmax, size_N × size_K)
      exp_omegax = exp.(omegax)  
      p_type = exp_omegax ./ sum(exp_omegax, dims=2)  # Normalize across types (softmax)
  
      # Compute cumulative probabilities (size_N × size_K)
      cump_type = cumsum(p_type, dims=2)
  
@inbounds for m=1:1:size_shocks
              k_vec[:,m].=sum(latent_type_sim[:,m] .>= cump_type, dims=2) .+ 1  
          end
  end


  
    # Productivity shocks on PSU and GPA 
    eGPA=rand(Normal(0.0,sigma_eGPA), size_N, size_shocks)  # shock on GPA
    ePSU=rand(Normal(0.0,sigma_ePSU), size_N, size_shocks)  # shock on PSU
    
    # Measurement errors 
    measurement_err_eff=rand(Normal(0.0,sigma_error_eff), size_N, size_shocks)
  
    
    # ==============================================================================
    #                                Simulate the outcomes                                          
    # ==============================================================================

# Precompute expected GPA and PSU beliefs for all i, m combinations
expGPAb = 0.5 .* ExpGPAb.(GPA_avg_1_2_data, simce_data, eff_grid', betaGPAb_0, GPAb_coeff_eff_data, betaGPAb_2, betaGPAb_3) .+ 
          0.5 .* GPA_avg_1_2_data

expPSUb = ExpPSUb.(GPA_avg_1_2_data, simce_data, eff_grid', PSUb_kink_data, betaPSUb_0, betaPSUb_1_data, betaPSUb_2_data, betaPSUb_3, betaPSUb_4)

expselP = selP.(lambdaP_0, lambdaP_1, lambdaP_2, lambdaP_3, lambdaP_4, lambdaP_5, lambdaP_6, lambdaP_7, lambdaP_8, lambdaP_9, lambdaP_10, 
                lambdaP_11, lambdaP_12, lambdaP_13, lambdaP_14, expGPAb, simce_data, modalidad_data, r4_data, r5_data, r7_data, r8_data, 
                r10_data, r13_data, r14_data, r15_data)

expselR = selR.(lambdaR_0, lambdaR_1, lambdaR_2, lambdaR_3, lambdaR_4, lambdaR_5, lambdaR_6, lambdaR_7, lambdaR_8, lambdaR_9, lambdaR_10, 
                lambdaR_11, lambdaR_12, lambdaR_13, lambdaR_14, expPSUb, simce_data, modalidad_data, r4_data, r5_data, r7_data, r8_data, 
                r10_data, r13_data, r14_data, r15_data)

Pr_AdmR_b = PrAdmRb.(dist_stNormal, gammab_0, gammab_1, expPSUb)
Pr_PACEslot_b = pace_data .* PrPACEslotb.(dist_stNormal, zetabpace_0, zetabpace_1, expGPAb, cutoff_top15b)

# Compute value functions for all i, m simultaneously
@inbounds for m=1:1:size_shocks
   U_1 = U1(k_vec[:,m], xi_1, xi_2, eff_grid')  # Flow utility in period 1
   V1 = U_1 .+ Emax_S_fun(k_vec[:,m], pace_data, expselP, expselR, costS, costSTreat, lambdaPR_0, lambdaG0, lambdaG1, delta, Pr_AdmR_b, Pr_PACEslot_b, Pgradb_data)
   Eff_sim[:,m] .=getindex.(argmax(V1, dims=2), 2) .- 1    # simulated effort choice (bin in eff_grid-1)
end

# Add measurement error
Eff_sim_observed .= Eff_sim .+ measurement_err_eff



# Time period 2: choice of sitting the PSU
# Vectorized computation of expected GPA and PSU belief
expGPAb = 0.5 .* GPA_avg_1_2_data .+ 0.5 .* ExpGPAb.(GPA_avg_1_2_data, simce_data, Eff_sim, betaGPAb_0, GPAb_coeff_eff_data, betaGPAb_2, betaGPAb_3)
Pr_PACEslot_b = pace_data .* PrPACEslotb.(dist_stNormal, zetabpace_0, zetabpace_1, expGPAb, cutoff_top15b)

expPSUb = ExpPSUb.(GPA_avg_1_2_data, simce_data, Eff_sim, PSUb_kink_data, betaPSUb_0, betaPSUb_1_data, betaPSUb_2_data, betaPSUb_3, betaPSUb_4)

# Vectorized computation of expected selectivity
expselP = selP.(lambdaP_0, lambdaP_1, lambdaP_2, lambdaP_3, lambdaP_4, lambdaP_5, lambdaP_6, lambdaP_7, lambdaP_8, lambdaP_9, lambdaP_10, 
                 lambdaP_11, lambdaP_12, lambdaP_13, lambdaP_14, expGPAb, simce_data, modalidad_data, r4_data, r5_data, r7_data, 
                 r8_data, r10_data, r13_data, r14_data, r15_data)

expselR = selR.(lambdaR_0, lambdaR_1, lambdaR_2, lambdaR_3, lambdaR_4, lambdaR_5, lambdaR_6, lambdaR_7, lambdaR_8, lambdaR_9, lambdaR_10, 
                 lambdaR_11, lambdaR_12, lambdaR_13, lambdaR_14, expPSUb, simce_data, modalidad_data, r4_data, r5_data, r7_data, 
                 r8_data, r10_data, r13_data, r14_data, r15_data)

# Vectorized probability of regular admission
Pr_AdmR_b = PrAdmRb.(dist_stNormal, gammab_0, gammab_1, expPSUb)

# Expected GPA and PSU
expGPA = ExpGPA(k_vec, GPA_avg_1_2_data, simce_data, Eff_sim, betaGPA_0, betaGPA_1, betaGPA_2, betaGPA_3)
expPSU = ExpPSU(k_vec, GPA_avg_1_2_data, simce_data, Eff_sim, betaPSU_0, betaPSU_1, betaPSU_2, betaPSU_3)

# Simulated GPA and PSU (truncated)
GPA_sim .= max.(min.(expGPA .+ eGPA, 7.0), 1.0)
PSU_sim .= max.(min.(expPSU .+ ePSU, 3.0), -3.0)

# Value of not sitting the PSU (V_0)
V_0 = Emax_E_fun(k_vec, expselP, expselR, 0, 0, lambdaPR_0, lambdaG0, lambdaG1, delta, Pgradb_data)

# Value of sitting the PSU (V_S)
V_S = U2.(costS, costSTreat, pace_data) .+ ePSUreg .+
      (1 .- Pr_AdmR_b) .* (1 .- Pr_PACEslot_b) .* Emax_E_fun(k_vec, expselP, expselR, 0, 0, lambdaPR_0, lambdaG0, lambdaG1, delta, Pgradb_data) .+
      (1 .- Pr_AdmR_b) .* Pr_PACEslot_b .* Emax_E_fun(k_vec, expselP, expselR, 0, 1, lambdaPR_0, lambdaG0, lambdaG1, delta, Pgradb_data) .+
      Pr_AdmR_b .* (1 .- Pr_PACEslot_b) .* Emax_E_fun(k_vec, expselP, expselR, 1, 0, lambdaPR_0, lambdaG0, lambdaG1, delta, Pgradb_data) .+
      Pr_AdmR_b .* Pr_PACEslot_b .* Emax_E_fun(k_vec, expselP, expselR, 1, 1, lambdaPR_0, lambdaG0, lambdaG1, delta, Pgradb_data)

# Sitting decision: If `V_S >= V_0`, sit the PSU
sit_PSU_sim .= ifelse.(V_S .>= V_0, 1, 0)

    
GPA_all_sim=0.5.*GPA_sim.+0.5.*GPA_avg_1_2_data
# Step 2: Compute the 85th percentile per school across all Shocks
@inbounds for (s, start_idx) in enumerate(school_start_idx)
  end_idx = school_end_idx[s]  # Get end index for school `s`

  # Compute the 85th percentile for all shocks (columns)
  school_cutoff = map(x -> quantile(x, 0.85), eachcol(GPA_all_sim[start_idx:end_idx, :]))

  # Assign the cutoff to ALL students in that school (vectorized)
  cutoff_top15_sim[start_idx:end_idx, :] .= school_cutoff' 
end



# Time period 3A: PACE admission
top15_sim .= (GPA_all_sim .>= cutoff_top15_sim).*1.0; # Assign 1.0 where mask is true, otherwise remains 0.0
AdmP_sim .= top15_sim .* (pace_data .* sit_PSU_sim);  # Assign treated * sit_PSU only where mask is true    
    
## Time period 3B: regular admission
AdmR_sim .= sit_PSU_sim.*(gammat_0 .+ gammat_1 .* PSU_sim .+ gammat_2 .* PSU_sim .^ 2 .+ gammat_3 .* PSU_sim .^ 3 .+ psi.>= 0)
AdmRorP_sim .= max.(AdmR_sim, AdmP_sim)  # Element-wise max operation

## Time period 4: enrolment choice and p_grad
# Precompute selectivity for both admission channels
selectivity_P_sim .= selP(lambdaP_0, lambdaP_1, lambdaP_2, lambdaP_3, lambdaP_4, lambdaP_5, lambdaP_6, 
                           lambdaP_7, lambdaP_8, lambdaP_9, lambdaP_10, lambdaP_11, lambdaP_12, lambdaP_13, 
                           lambdaP_14, GPA_sim, simce_data, modalidad_data, r4_data, r5_data, r7_data, 
                           r8_data, r10_data, r13_data, r14_data, r15_data) .+ shock_selP

selectivity_R_sim .= selR(lambdaR_0, lambdaR_1, lambdaR_2, lambdaR_3, lambdaR_4, lambdaR_5, lambdaR_6, 
                           lambdaR_7, lambdaR_8, lambdaR_9, lambdaR_10, lambdaR_11, lambdaR_12, lambdaR_13, 
                           lambdaR_14, PSU_sim, simce_data, modalidad_data, r4_data, r5_data, r7_data, 
                           r8_data, r10_data, r13_data, r14_data, r15_data) .+ shock_selR
# Compute value functions for both admissions
V_R = expVR(k_vec, lambdaPR_0, lambdaG0, lambdaG1, selectivity_R_sim, Pgradb_data) .+ nuR
V_P = expVP(k_vec, lambdaPR_0, lambdaG0, lambdaG1, selectivity_P_sim, delta, Pgradb_data) .+ nuP

# Masks for different admission scenarios
regular_admission_mask = (AdmR_sim .== 1) .& (AdmP_sim .== 0)
pace_admission_mask = (AdmR_sim .== 0) .& (AdmP_sim .== 1)
both_admissions_mask = (AdmR_sim .== 1) .& (AdmP_sim .== 1)

# Apply conditions using vectorized operations
ER_sim .= ifelse.(regular_admission_mask .& (V_R .>= 0), 1.0, ER_sim)
EP_sim .= ifelse.(pace_admission_mask .& (V_P .>= 0), 1.0, EP_sim)
EPR_sim .= max.(ER_sim, EP_sim)

# Assign selectivity values
selectivity_sim .= ifelse.(ER_sim .== 1, selectivity_R_sim, selectivity_sim)
selectivity_sim .= ifelse.(EP_sim .== 1, selectivity_P_sim, selectivity_sim)

# Handle both admissions case
EP_sim .= ifelse.(both_admissions_mask .& (V_P .>= 0) .& (V_P .>= V_R), 1.0, EP_sim)
ER_sim .= ifelse.(both_admissions_mask .& (V_R .>= 0) .& (V_R .> V_P), 1.0, ER_sim)
EPR_sim .= max.(EP_sim, ER_sim)
selectivity_sim .= ifelse.(both_admissions_mask .& (V_P .>= 0) .& (V_P .>= V_R), selectivity_P_sim, selectivity_sim)
selectivity_sim .= ifelse.(both_admissions_mask .& (V_R .>= 0) .& (V_R .> V_P), selectivity_R_sim, selectivity_sim)

# Time period 5: actual dropout
# Compute persistence probability matrix
p_persist= p_persist_actual(k_vec, simce_data, Eff_sim, theta_ppersist0, theta_ppersist)

# Assign persistence values using the probability matrix
Persist_sim .= ((EPR_sim .> 0.0) .& (latent_dropout_sim .>= 0.0) .& (latent_dropout_sim .<= p_persist)) .* 1.0  # Sets 1 where mask is true, 0 otherwise

    
    
    
    
    
    
# ==============================================================================
#                      Compute the simulated coefficients/moments                                         
# ==============================================================================
# The params from the auxiliary models estimated on the real data using the do files
  
# Preallocate matrix for efficiency
matrix_simulated_moments .= 0.0

#* --------------------------
#* Auxiliary models 1-4 (7)
#* --------------------------
# * Match coeff on female and missing survey (2)
matrix_simulated_moments[1:2, :] .= (data_reg_1_2 \ sit_PSU_sim)[2:3, :]

# * Match coeff on female (1)
matrix_simulated_moments[3, :] .= (data_reg_3 \ Eff_sim_observed[mask_hours_study_missing_0, :])[2, :]

# * Match coeff on simce (1)
matrix_simulated_moments[4, :] .= (data_reg_4 \ Eff_sim_observed[mask_hours_study_missing_0, :])[2, :]

# Match coeff on female and missing_survey and constant  (3)
matrix_simulated_moments[5:7, :] .= (data_reg_5_7 \ EPR_sim[mask_treatment_0, :])[[2, 3, 1], :]

#* -----------------------------------------------------------------
#* Auxiliary models TE on admissions, enrollments, persistence (12)
#* -----------------------------------------------------------------
#* All sample 
matrix_simulated_moments[8, :] .= (data_reg_8_10_12 \ AdmRorP_sim[:, :])[2, :]
matrix_simulated_moments[9, :] .=vec(mean(AdmRorP_sim[mask_treatment_0, :], dims=1))
matrix_simulated_moments[10, :] .= (data_reg_8_10_12 \ EPR_sim[:, :])[2, :]
matrix_simulated_moments[11, :] .=vec(mean(EPR_sim[mask_treatment_0, :], dims=1))
matrix_simulated_moments[12, :] .= (data_reg_8_10_12 \ Persist_sim[:, :])[2, :]
matrix_simulated_moments[13, :] .=vec(mean(Persist_sim[mask_treatment_0, :], dims=1))

#*Top 15% sample
matrix_simulated_moments[14, :] .= (data_reg_14_16_18 \ AdmRorP_sim[mask_top15_1, :])[2, :]
matrix_simulated_moments[15, :] .=vec(mean(AdmRorP_sim[mask_top15_1 .&mask_treatment_0, :], dims=1))
matrix_simulated_moments[16, :] .= (data_reg_14_16_18 \ EPR_sim[mask_top15_1, :])[2, :]
matrix_simulated_moments[17, :] .=vec(mean(EPR_sim[mask_top15_1 .&mask_treatment_0, :], dims=1))
matrix_simulated_moments[18, :] .= (data_reg_14_16_18 \ Persist_sim[mask_top15_1, :])[2, :]
matrix_simulated_moments[19, :] .=vec(mean(Persist_sim[mask_top15_1 .&mask_treatment_0, :], dims=1))

#* ------------------------------------
#* Auxiliary models 5-8 (8)
#* ------------------------------------
#* Match constant and coefficient on expPSUscore_st (2)
matrix_simulated_moments[20:21, :] .= (data_reg_20_21 \ sit_PSU_sim[mask_expPSU_missing_0 .& mask_treatment_0, :])[1:2, :]

#* Match coeff on female and survey_missing  (2)
matrix_simulated_moments[22:23, :] .= (data_reg_22_23 \ AdmRorP_sim[mask_treatment_0, :])[2:3, :]

#* Match coeff on GPA_avg_1_2 and simce  (2)
matrix_simulated_moments[24:25, :] .= (data_reg_24_25 \ AdmRorP_sim[mask_treatment_0, :])[2:3, :]

#* Match coefficient on female and survey_missing (2)
matrix_simulated_moments[26:27, :] .= (data_reg_26_27 \ GPA_sim[mask_GPA_missing_0, :])[2:3, :]

#* ------------------------------------
#* Auxiliary models 9-11 (6)
#* ------------------------------------
# * Match coeff on hours_study, on GPA avg_1_2, on simce (3)
@inbounds for m=1:1:size_shocks
matrix_simulated_moments[28:30, m] .= (hcat(Eff_sim_observed[mask_GPA_missing_0 .& mask_hours_study_missing_0,m],
                                             data_reg_28_30) \ GPA_sim[mask_GPA_missing_0 .& mask_hours_study_missing_0, m])[1:3]
end

#* Match coeff on female and simce (2)  
matrix_simulated_moments[31:32, :] .= (data_reg_31_32 \ Persist_sim)[2:3, :]

#* Match coeff on Pgradb (1)
matrix_simulated_moments[33, :].= (data_reg_33 \ EPR_sim[mask_treatment_0 .& mask_AdmPorR_1, :])[2, :]

#* ---------------------------------------------------------------
#* Auxiliary models TE on effort and sit PSU (5)
#* --------------------------------------------------------------
#* Match TE and outcome mean in C group (2)
matrix_simulated_moments[34, :].= (data_reg_34 \ Eff_sim_observed[mask_hours_study_missing_0, :])[2, :]
matrix_simulated_moments[35, :] .=vec(mean(Eff_sim_observed[mask_hours_study_missing_0.& mask_treatment_0,:], dims=1))

#* Match TE and outcome mean in C group (2)
matrix_simulated_moments[36, :] .= (data_reg_36 \ sit_PSU_sim)[2, :]
matrix_simulated_moments[37, :] .=vec(mean(sit_PSU_sim[mask_treatment_0,:], dims=1))

#* Match coeff on interaction treatment X perceived distance cutoff (1)
matrix_simulated_moments[38, :] .= (data_reg_38 \ Eff_sim_observed[mask_hours_study_missing_0 .& mask_expGPA_missing_0, :])[3, :]

#* --------------------------------------
#* Summary statistics to match (9)
#* --------------------------------------
matrix_simulated_moments[39, :] .= vec(mean(sit_PSU_sim[mask_female_0 .& mask_survey_missing_0, :], dims=1))
matrix_simulated_moments[40, :] .= vec(mean(Eff_sim_observed[mask_female_1 .& mask_hours_study_missing_0, :], dims=1))
matrix_simulated_moments[41, :] .= vec(mean(EP_sim[mask_AdmP_1 .& mask_AdmR_1, :], dims=1))
matrix_simulated_moments[42, :] .= vec(var(PSU_sim[mask_treatment_0 .& mask_sit_PSU_1, :], dims=1))
matrix_simulated_moments[43, :] .= vec(mean(GPA_sim[mask_GPA_missing_0 .& mask_treatment_0, :], dims=1))
matrix_simulated_moments[44, :] .= vec(var(GPA_sim[mask_GPA_missing_0 .& mask_treatment_0, :], dims=1))
matrix_simulated_moments[45, :] .= vec(mean(AdmP_sim[mask_treatment_1, :], dims=1))
matrix_simulated_moments[46, :] .= vec(mean(AdmP_sim[mask_top15_1 .& mask_treatment_1, :], dims=1))
matrix_simulated_moments[47, :] .= vec(var(Eff_sim_observed[mask_hours_study_missing_0 .& mask_treatment_0, :], dims=1))
matrix_simulated_moments[48, :] .= vec(mean(top15_sim[mask_top15_1 .& mask_treatment_0, :], dims=1))
matrix_simulated_moments[49, :] .= vec(mean(top15_sim[mask_top15_1 .& mask_treatment_1, :], dims=1))
matrix_simulated_moments[50, :] .= vec(mean(EPR_sim[mask_top15_1 .& mask_AdmPorR_1 .& mask_treatment_0, :], dims=1))
matrix_simulated_moments[51, :] .= vec(mean(EPR_sim[mask_top15_1 .& mask_AdmPorR_1 .& mask_treatment_1, :], dims=1))


# Match TE on enrolled_SUA_by_y5 if top15baseline ==1 &  enrolled_SUA_by_y1==1
matrix_simulated_moments[52, :].= (data_reg_52 \ Persist_sim[mask_enrolled_SUA_1 .& mask_top15_1, :])[2, :]

# * Compute Objective Function Efficiently
vector_simulated_moments .= mean(matrix_simulated_moments, dims=2)[:, 1]

# Adjust weights 
vector_empirical_moments_weights_adjw .= vector_empirical_moments_weights
vector_empirical_moments_weights_adjw[8] = 10.0* vector_empirical_moments_weights[8] 
vector_empirical_moments_weights_adjw[10] = 10.0* vector_empirical_moments_weights[10] 
vector_empirical_moments_weights_adjw[12] = 10.0* vector_empirical_moments_weights[12] 
vector_empirical_moments_weights_adjw[14] = 10.0*vector_empirical_moments_weights[8]    # weight TEadm_15 = TEadm_all 
vector_empirical_moments_weights_adjw[16] = 10.0*vector_empirical_moments_weights[10]    # weight TEenroll_15 = TEenroll_all 
vector_empirical_moments_weights_adjw[18] = 10.0*vector_empirical_moments_weights[12]    # weight TEpers_15 = TEpers_all 
vector_empirical_moments_weights_adjw[34] = 0.10*vector_empirical_moments_weights[10]    # weight TEhours = 0.10*TEenroll_all
vector_empirical_moments_weights_adjw[36] = 10.0*vector_empirical_moments_weights[10]    # weight TEsitPSU = TEenroll_all
vector_empirical_moments_weights_adjw[52] = 0.10*vector_empirical_moments_weights[10]

vec_diff .= (vector_simulated_moments .- vector_empirical_moments) .* vector_empirical_moments_weights_adjw
Objective_function = dot(vec_diff,vec_diff)
        
end_time = time()
println("Elapsed time: $(end_time - start_time) seconds")
println("Iteration: Parameters = $theta, Objective value = $Objective_function")
    
return Objective_function   # output of the function
end   # end of function
    
