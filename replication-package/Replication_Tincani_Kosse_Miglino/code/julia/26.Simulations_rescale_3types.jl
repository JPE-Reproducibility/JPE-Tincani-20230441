################################################
# This code simulates the data from the model
################################################


# Authors: Enrico Miglino (Bank of italy) and Michela M. Tincani (University College London)
# Year: 2026



############################################################

#          Load packages, set paths, import functions      #

############################################################


import Pkg
Pkg.activate(@__DIR__)

using Juniper
using Zygote
using DualNumbers
using MvNormalCDF
using StatFiles, DataFrames, CSV, Distributions,  Random, Statistics #use packages
using LinearAlgebra
using DelimitedFiles

const path_codes = abspath(@__DIR__)
const package_root = abspath(joinpath(path_codes, "..", ".."))
const path_processed = joinpath(
    package_root,
    "confidential-data-not-for-publication",
    "processed",
)

mkpath(path_processed)


# import functions from same directory
include(joinpath(path_codes, "Functions_rescale.jl"))     




################################################################################

#         Parameters estimated outside the model and fixed parameters          #

################################################################################
 

const param_outside_matrix = DataFrame(load(joinpath(path_processed, "parameters_estimated_outside_rescale.dta")))  


const param_outside_vector=Array{Real}(param_outside_matrix[:, "param_values"]);

# Obj. prob of a regular admission
const gammat_0=param_outside_vector[1]; # constant
const gammat_1=param_outside_vector[2]; # PSU
const gammat_2=param_outside_vector[3]; # PSU_squared
const gammat_3=param_outside_vector[4]; # PSU_cube

# Selectivity of a PACE admission
const lambdaP_0=param_outside_vector[5]; # constant
const lambdaP_1=param_outside_vector[6]; # GPA cuarto medio
const lambdaP_2=param_outside_vector[7]; # GPA cuarto medio squared
const lambdaP_3=param_outside_vector[8]; # simce
const lambdaP_4=param_outside_vector[9]; # simce squared
const lambdaP_5=param_outside_vector[10]; # academicXsimce
const lambdaP_6=param_outside_vector[11]; # academic
const lambdaP_7=param_outside_vector[12]; # region 4
const lambdaP_8=param_outside_vector[13]; # region 5
const lambdaP_9=param_outside_vector[14]; # region 7
const lambdaP_10=param_outside_vector[15]; # region 8
const lambdaP_11=param_outside_vector[16]; # region 10
const lambdaP_12=param_outside_vector[17]; # region 13
const lambdaP_13=param_outside_vector[18]; # region 14
const lambdaP_14=param_outside_vector[19]; # region 15
const sigma_selP=param_outside_vector[20]; # s.d. of shock

# Selectivity of regular admission
const lambdaR_0=param_outside_vector[21]; # constant
const lambdaR_1=param_outside_vector[22]; # PSU score if positive 
const lambdaR_2=param_outside_vector[23]; # PSU score if positive squared
const lambdaR_3=param_outside_vector[24]; # simce
const lambdaR_4=param_outside_vector[25]; # simce squared 
const lambdaR_5=param_outside_vector[26]; # academicXsimce
const lambdaR_6=param_outside_vector[27]; # academic
const lambdaR_7=param_outside_vector[28]; # region 4
const lambdaR_8=param_outside_vector[29]; # region 5
const lambdaR_9=param_outside_vector[30]; # region 7
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
const euler=0.57721566490153286060651209008240243104215933593992
const lambdaG1=1.0  # normalize coefficient on selectivity from utility from graduating to 1, sets scale for utilities
  



################################################################################

#                            Import and clean data                             #

################################################################################

# Import data

  const data = DataFrame(load(joinpath(path_processed, "initial_conditions_TC_rescale.dta")))




# Create a vector of data for each variable
const size_N=nrow(data);   #number of students in the sample
const rbd=Array{Float64}(data[:, "rbd_basefinal"]);   
const age_data=Array{Real}(data[:, "age"]);
const female_data=Array{Real}(data[:, "female"]);
const alumno_prioritario_data=Array{Real}(data[:, "alumno_prioritario"]);
const neverfailed_data=Array{Real}(data[:, "neverfailed"]);
const modalidad_data=Array{Real}(data[:, "modalidad"]);
const GPA_1_2_rank_data=data[:,"GPA_1_2_rank"];
const GPA_avg_1_2_data=Array{Real}(data[:, "GPA_avg_1_2"]); # baseline GPA
const X=hcat(age_data, female_data, alumno_prioritario_data,neverfailed_data,modalidad_data);
const pace_data=Array{Real}(data[:, "treatment"]);
const GPA_segundo_data=Array{Real}(data[:, "GPA_segundo_medio"]);
const cutoff_top15_data=Array{Real}(data[:, "actual_top15_cutoff"]);
const cutoff_top15b_data_raw=data[:, "perceived_top15_cutoff"];
const cutoff_top15b_data_missing=myisna(cutoff_top15b_data_raw);   #vector of elements equal to 1 if obs is missing, 0 otherwise
const cutoff_top15b=convert(Array{Real}, fill(-99.0, size_N));     #initialize vector of perceived cutoff (this is taken from data when non-missing and imputed when missing)
for i=1:1:size_N
    if cutoff_top15b_data_missing[i]==0       #if not missing
       cutoff_top15b[i]=cutoff_top15b_data_raw[i];
    else
       cutoff_top15b[i]=cutoff_top15_data[i]  # if missing we assume the student correctly predicts the cutoff - delivers lower bound on role of belief biases
    end
end


const GPA_avg_school_1_2_data=Array{Real}(data[:, "GPA_avg_school_1_2"]);   # GPA school average in primero and segundo medio
const simce_data=Array{Real}(data[:, "simce_avg_st"]);
const r4_data=Array{Real}(data[:, "region4"]);
const r5_data=Array{Real}(data[:, "region5"]);
const r7_data=Array{Real}(data[:, "region7"]);
const r8_data=Array{Real}(data[:, "region8"]);
const r10_data=Array{Real}(data[:, "region10"]);
const r13_data=Array{Real}(data[:, "region13"]);
const r14_data=Array{Real}(data[:, "region14"]);
const r15_data=Array{Real}(data[:, "region15"]);
const n_obs_school=Array{Float64}(data[:, "num_obs_school"]);   # number of students in school
const y_data_missing=data[:, "y_data_missing"];
const Pgradb_data = data[:, "Pgradb"];
const GPAb_coeff_eff_data = data[:, "GPAb_coeff_eff"];
const PSUb_coeff_eff_1_data = data[:, "PSUb_coeff_eff_1"];
const PSUb_coeff_eff_2_data = data[:, "PSUb_coeff_eff_2"];
const PSUb_kink_data = data[:, "PSUb_kink"];
const top15baseline_data = data[:, "top15baseline"];




################################################################################

#                               Solving model                                  #

################################################################################


# ==============================================================================
#                               Variables Space                                
# ==============================================================================

# Set number of unobserved types, shocks and effort grid points; set seed
const size_K=3;                          # number of unobserved heter. grid points
const size_shocks=2;                    # number of shock realizations
const size_Eff=11;                       # number of grid points for effort
const size_sim_eff=20;                   # simulations to smooth effort
const eff_grid=[0;1;2;3;4;5;6;7;8;9;10]; # grid for effort
Random.seed!(060644)                     # set seed


# ==============================================================================
#                                Draw shocks                                                   
# ==============================================================================


# One shock per person. Shocks are different between T and C here
const psi=rand(Normal(0.0,1.0), size_N, size_shocks); # shocks in regular admission
const ePSUreg=rand(Logistic(0.0,1.0), size_N, size_shocks);   # preference shocks on PSU registration
const nuR=rand(Logistic(0.0,1.0), size_N, size_shocks);   # preference shocks in regular enrolment
const nuP=rand(Logistic(0.0,1.0), size_N, size_shocks);   # preference shocks in PACE enrolment.

const dist_stNormal=Normal(0,1.0);   # standard normal distribution
k_vec=ones(Int64,size_N, size_shocks);  # type, initialize as vector of 1s
const latent_type_sim=rand(Uniform(0,1),size_N, size_shocks);
const latent_dropout_sim=rand(Uniform(0,1),size_N, size_shocks);



# ==============================================================================
#                           Read in vector of estimated parameters                                                   
# ==============================================================================


# Type-dependent parameters listed first 
# To change the number of types, adjust size_K and the indexing of the theta elements happens automatically.

  
#NLOPT 3 types, 2 shocks, adjusted weights tolerance 10^-5 
#theta=[-0.39504983869964433, -1.495155563200128, -0.4460002752705829, 4.238572124669247, 3.862968368290951, 2.131630793236246, -0.7148572234197386, -1.1609338841827763, -6.480407651592333, 0.005435368778840147, -0.19246201089707615, 2.4841002133663515, 0.022271896997265467, -0.22530184279404328, 0.13395505763669763, 1.4038772749569643, -0.6539872934449443, 0.6978158567762968, -0.8264413652648581, -0.21077387292735297, -1.736577754188924, -1.6270941733922402, -3.9269723263565712, -4.9839775688599515, 0.985220275784541, -0.007293505715661345, 0.14105410451508438, 0.19606915056863652, 0.4390171527286303, 5.186329471329255, 0.9479266783907317, 2.0230692650292967, 0.1608008859584798, 0.01748846584343151, 0.32713363533546264, 0.04023231162274618, 0.3227199199338218, 0.0037405455345805526, 0.1387586665555873, 0.2437647479021046, 0.07356492423376924, 0.0334472417087555, 0.578437128236742]

# Change this - read from file 
# Enrico's laptop, 10/03/2026
# theta=[-0.2470347428229738, -1.0154565423282476, -1.1886662243623716, 1.896711508573402, 1.8989927554563473, 1.6320621853628494, 0.36758868024834834, -1.2187782932237874, -0.831782044205469, -0.020721583734585935, 0.045166554726830364, -2.8894557386764586, 0.010734175871924675, -0.32309108789123575, -0.11332607200666911, 1.4952752494093995, 2.0633582094398877, 0.710449265585884, -0.8273953601851863, -0.09318884805391167, 0.21806812027064265, -1.8082592158514874, -4.182916957319104, -4.783627489155299, 3.080852495540359, -0.005845422128710195, 0.1927723986716081, 0.5429632962121854, -0.19512683570080286, 12.675790363305154, 1.2476106489906966, 2.363148997278384, 0.20629778125966128, 0.023973612237237596, 0.7124144528072316, 0.07050503776035619, 0.3916444286476835, 0.018066113436938133, -0.008071784875959567, 0.0783119470936532, 0.021195245847778366, 0.02942179076056602, 0.4085830936761068]

function read_theta_from_structured_file(path)
    theta = vec(readdlm(path, ',', Float64))
    return theta
end

estimation_output_path = joinpath(path_processed, "estimation_theta_rescale_fast_3types.csv")
theta = read_theta_from_structured_file(estimation_output_path)

expected_len = 9*size_K + 16
if length(theta) != expected_len
    error("Expected $expected_len parameters, got $(length(theta))")
end


println("Parameters values are $theta.")   



# ==============================================================================
#           Assign estimated parameters values to model parameters                                                   
# ==============================================================================
# Listing type-dependent parameters first, followed by type-independent parameters.
# Indeces of elements within parameter vector are automatically updated when we change
# the number of types (size_K).


    #---------------------------
    # Type-dependent parameters
    #---------------------------
        # Utility from enrolling in SUA
        lambdaPR_0=theta[1:size_K]
    
        # Objective GPA production function
        betaGPA_0=theta[size_K+1:2*size_K]
    
        # Objective PSU production function
        betaPSU_0=theta[2*size_K+1:3*size_K]
    
        # Constant in actual p_persist_actual, exogenous stochastic process
        theta_ppersist0=theta[3*size_K+1:4*size_K]
    
        # Convex cost of study effort, linear term
        xi_1=theta[4*size_K+1:5*size_K]
    
        if size_K>1
           # Probability of unobserved types
           omega_0=Vector{Real}(undef,size_K); # constant 
           omega_1=Vector{Real}(undef,size_K); # missing survey
           omega_2=Vector{Real}(undef,size_K); # female
           omega_3=Vector{Real}(undef,size_K); # top15 at baseline
           omega_0[1]=0.00 # Normalisation for type 1 in multinomial logit function
           omega_1[1]=0.00
           omega_2[1]=0.00
           omega_3[1]=0.00
           for k=2:1:size_K
               omega_0[k]=theta[5*size_K+k-1]
               omega_1[k]=theta[6*size_K+k-2]
               omega_2[k]=theta[7*size_K+k-3]
               omega_3[k]=theta[8*size_K+k-4]
           end # for k
        end # if size_K>1
    #--------------------------------
    # Type-independent parameters 
    #--------------------------------

        # Subjective probability of a PACE slot
        zetabpace_0=theta[9*size_K-3]
        zetabpace_1=theta[9*size_K-2]  # coeff on difference between GPAb expected GPA and expected cutoff
      
        # Convex cost of study effort
        xi_2=theta[9*size_K-1];   # quadratic term
       
        # Reduction in value from taking the PSU if in treatment group
        costSTreat=theta[9*size_K];   # treated, linear term NB eliminate if get rid of high school only
   
        # Cost of sitting PSU
        costS=theta[9*size_K+1]; # constant 
       
        # Subjective probability of regular admission
        gammab_0=theta[9*size_K+2]; # constant
        gammab_1=theta[9*size_K+3]; # coeff on PSUb
       
        # Utility from enrolling in SUA
        delta=theta[9*size_K+4];        # stigma for PACE enrollment (coeff on PACE)
        lambdaG0=theta[9*size_K+5];      # constant, if graduating 
       
        # Standard deviations
        sigma_error_eff=theta[9*size_K+6];   # standard deviation of measurement error for effort (truncated!)
      
      
        # Objective GPA production function
        betaGPA_1=theta[9*size_K+7] # coeff on effort 
        betaGPA_2=theta[9*size_K+8] # coeff on GPA segundo medio 
        betaGPA_3=theta[9*size_K+9] # coeff on simce
        sigma_eGPA=theta[9*size_K+10] # standard deviation of GPA shock
       
        # Objective PSU production function
        betaPSU_1=theta[9*size_K+11] # coefficient of eff
        betaPSU_2=theta[9*size_K+12] # coeff of GPA segundo
        betaPSU_3=theta[9*size_K+13] # coeff of simce
        sigma_ePSU=theta[9*size_K+14] # standard deviation of PSU shock
       
      
        # actual persistence probability
        theta_ppersist=theta[9*size_K+15:9*size_K+16]; #  coefficient on hours study and on the only 2 significant probit regressors: simce, female

# ==============================================================================
#                              Generate shock realisations                                          
# ==============================================================================

# Permanent types: 
k_vec=ones(Real,size_N, size_shocks);  # type
# Permanent types:
if size_K>1
   p_type_i=zeros(Real,size_K,size_N)
   cump_type_i=zeros(Real,size_K,size_N)
 

     for m=1:1:size_shocks 
      p_type_i=zeros(Real,size_K,size_N) #Vector{Real}(undef, size_N)
      cump_type_i=zeros(Real,size_K,size_N)

     for i=1:1:size_N
        omegax = omega_0 .+ omega_1 .* y_data_missing[i] .+ omega_2 .*female_data[i] + omega_3 .* top15baseline_data[i]  
        denom=0.0
      for k=1:1:size_K 
         denom=denom+exp(omegax[k])
      end 
      for k=1:1:size_K
         p_type_i[k,i]= exp(omegax[k])/denom       # probability of type k - multinomial logit
         cump_type_i[k,i]=p_type_i[k,i]
      end 
      if (latent_type_sim[i,m]>=0.0 && latent_type_sim[i,m]<p_type_i[1,i])
         k_vec[i,m]=1
      end 
      for k=2:1:size_K
         cump_type_i[k,i]= cump_type_i[k-1,i]+ p_type_i[k,i]
         if (k < size_K && latent_type_sim[i,m] >= cump_type_i[k-1,i] && latent_type_sim[i,m] < cump_type_i[k,i])
            k_vec[i,m]=k
         elseif (k==size_K && latent_type_sim[i,m]>=cump_type_i[k-1,i] )
             k_vec[i,m]=size_K
         end 
      end 
     end # for i
   end # for m
   end # if size_K>1


# Shocks on PSU and GPA
const eGPA=rand(Normal(0.0,sigma_eGPA), size_N, size_shocks)  # shock on GPA
const ePSU=rand(Normal(0.0,sigma_ePSU), size_N, size_shocks)  # shock on PSU




# Measurement errors and shocks
shock_selP=rand(Normal(0.0,sigma_selP), size_N, size_shocks);
shock_selR=rand(Normal(0.0,sigma_selR), size_N, size_shocks);
measurement_err_eff=rand(Normal(0.0,sigma_error_eff), size_N, size_shocks)





# ==============================================================================
#               Simulate choices and outcomes from time period 1 forward                                          
# ==============================================================================
# Start from time period 1 and simulate students' choices using Emax functions 
# The vectors below simulate one choice/outcome per person, assuming a single shock.


# Time period 1: choice of effort 

V_1=zeros(size_Eff);            # initialize value functions in period 1
Eff_sim=zeros(size_N, size_shocks);          # initialize matrix of simulated effort level for each student 
Eff_cost_sim=zeros(size_N, size_shocks);
Ut_1_sim=zeros(size_N, size_shocks);         # current utility, time 1
Pr_adm_eff=zeros(size_Eff);     # admission likelihood at each effort level
Pr_adm_eff_der=zeros(size_Eff); # backward derivative, calculated at each level of effort 
Ret_eff_pr_adm=convert(Array{Real}, fill(-99.0, size_N, size_Eff, size_shocks));
eff=Vector{Int64}(undef, 1);
PDV_1_eff=Array{Union{Missing, Float64}}(missing, size_N, size_Eff, size_shocks);  # present discounted value at time  1 from each level of effort
Ut_1_eff=Array{Union{Missing, Float64}}(missing, size_N, size_Eff, size_shocks);  # flow utility at time  1 from each level of effort
Emax_1_eff=Array{Union{Missing, Float64}}(missing, size_N, size_Eff, size_shocks);  # future value at time  1 from each level of effort


for i=1:1:size_N   # for each student i
    
    GPA_avg_1_2=GPA_avg_1_2_data[i];
    simce=simce_data[i];
    treated=pace_data[i]
    GPA_1_2_rank=GPA_1_2_rank_data[i];
    r4=r4_data[i];
    r5=r5_data[i];
    r7=r7_data[i];
    r8=r8_data[i];
    r10=r10_data[i];
    r13=r13_data[i];
    r14=r14_data[i];
    r15=r15_data[i];
    academic=modalidad_data[i];
    expCutoff_top15_b=cutoff_top15b[i][1];   # perceived expected cut-off
    p_grad= Pgradb_data[i] #p_graduate(k,simce,alumno_prioritario,GPA_1_2_rank,female,theta_pgrad0,theta_pgrad); #perceived graduation likelihood
    betaPSUb_1=PSUb_coeff_eff_1_data[i]
    betaPSUb_2=PSUb_coeff_eff_2_data[i]
    PSUb_kink=PSUb_kink_data[i]
    betaGPAb_1=GPAb_coeff_eff_data[i]

   for m=1:1:size_shocks 
    k=k_vec[i,m];    # assign type


    for e=1:1:size_Eff   # for each level of effort
        eff=eff_grid[e];   # level of effort
        expGPAb=ExpGPAb(GPA_avg_1_2,simce,eff,betaGPAb_0,betaGPAb_1,betaGPAb_2,betaGPAb_3);  # (expected) GPA
        expGPAb_912=0.5*GPA_avg_1_2+0.5*expGPAb
        expPSUb=ExpPSUb(GPA_avg_1_2,simce,eff,PSUb_kink,betaPSUb_0,betaPSUb_1,betaPSUb_2,betaPSUb_3,betaPSUb_4); # PSU belief
        expselP=selP(lambdaP_0, lambdaP_1, lambdaP_2, lambdaP_3, lambdaP_4, lambdaP_5, lambdaP_6, lambdaP_7, lambdaP_8, lambdaP_9, lambdaP_10, lambdaP_11, lambdaP_12, lambdaP_13, lambdaP_14,expGPAb_912,simce,academic,r4,r5,r7,r8,r10,r13,r14,r15 )
        expselR=selR(lambdaR_0, lambdaR_1, lambdaR_2, lambdaR_3, lambdaR_4, lambdaR_5, lambdaR_6, lambdaR_7, lambdaR_8, lambdaR_9, lambdaR_10, lambdaR_11, lambdaR_12, lambdaR_13, lambdaR_14,expPSUb,simce,academic,r4,r5,r7,r8,r10,r13,r14,r15 )
        Pr_AdmR_b=PrAdmRb(dist_stNormal,gammab_0,gammab_1,expPSUb) # max.(min.(gammab_0+gammab_1*expPSUb,1.0),0.0);#   # subjective prob. of regular admission 
        Pr_PACEslot_b=treated*PrPACEslotb(dist_stNormal,zetabpace_0,zetabpace_1,expGPAb_912,expCutoff_top15_b) # prob. of PACE admission
        Pr_adm_eff[e]=(1.0-treated)*Pr_AdmR_b+treated*(Pr_AdmR_b+Pr_PACEslot_b-Pr_PACEslot_b*Pr_AdmR_b)
     

           U_1=U1(k,xi_1,xi_2,eff); # flow utility in period 1
           V_1[e]=U_1[1]+ Emax_S_fun(k,treated,expselP,expselR,costS,costSTreat,lambdaPR_0,lambdaG0,lambdaG1,delta,Pr_AdmR_b,Pr_PACEslot_b,p_grad); # value function in period 1 (flow utility+Emax for sitting the PSU period) 
           PDV_1_eff[i,e,m]=V_1[e]
           Ut_1_eff[i,e,m]=U_1
           Emax_1_eff[i,e,m]=Emax_S_fun(k,treated,expselP,expselR,costS,costSTreat,lambdaPR_0,lambdaG0,lambdaG1,delta,Pr_AdmR_b,Pr_PACEslot_b,p_grad)
           
           # Calculate returns of an additional hour of study, starting from 0 and ending at 9 hours (index=hours+1)
           if e>1
            Ret_eff_pr_adm[i,e,m]=Pr_adm_eff[e]-Pr_adm_eff[e-1] 
           end 
         end   # for e


    Eff_bin=argmax(V_1[:]);   # simulated effort bin choice
    Eff_sim[i,m]=Eff_bin-1.0;   # simulated effort choice

    
    #compute utility from time 1 at the chosen effort level
       Ut_1_sim[i,m]=U1(k,xi_1,xi_2,Eff_sim[i,m])
      end # for m
end   # for i 


# Time period 2: choice of sitting the PSU

PDV_2_nosit_sim=Array{Union{Missing, Float64}}(missing, size_N, size_shocks); # present discounted value at time 2 from not taking the PSU
PDV_2_sit_sim=Array{Union{Missing, Float64}}(missing, size_N, size_shocks);  # present discounted value at time 2 from taking the PSU
Ut_2_sim=zeros(size_N, size_shocks);
GPA_sim=zeros(size_N, size_shocks);   # initialize vector of own GPA
Pr_PACEslot_b_sim=zeros(size_N, size_shocks);
Pr_PACEslot_b_obs_sim=zeros(size_N, size_shocks);
Pr_Admitted_R_b_sim=zeros(size_N, size_shocks);  #subjective probability of being admitted through the regular channel, calculated using expPSU
sit_PSU_sim=zeros(size_N, size_shocks);  # initialize vector of sitting PSU dummy
PSU_sim=Array{Union{Missing, Float64}}(missing, size_N, size_shocks);   # initialize vector of simulated PSU
expPSUb_sim=Array{Union{Missing, Float64}}(missing, size_N, size_shocks); # initialize vector of simulated expected PSU belief
expGPAb_sim=Array{Union{Missing, Float64}}(missing, size_N, size_shocks); # initialize vector of simulated expected GPA belief



for i=1:1:size_N   # for each student i
  
   simce=simce_data[i];
   GPA_1_2_rank=GPA_1_2_rank_data[i];
   female=female_data[i];
   r4=r4_data[i];
   r5=r5_data[i];
   r7=r7_data[i];
   r8=r8_data[i];
   r10=r10_data[i];
   r13=r13_data[i];
   r14=r14_data[i];
   r15=r15_data[i];
   academic=modalidad_data[i];
   
   GPA_avg_1_2=GPA_avg_1_2_data[i][1];
   treated=pace_data[i][1];   # treatment
   p_grad= Pgradb_data[i]  #perceived graduation likelihood
   betaPSUb_1=PSUb_coeff_eff_1_data[i]
   betaPSUb_2=PSUb_coeff_eff_2_data[i]
   PSUb_kink=PSUb_kink_data[i]
   betaGPAb_1=GPAb_coeff_eff_data[i]

   for m=1:1:size_shocks 
    eff=Eff_sim[i,m];
   k=k_vec[i,m]   # define type
   expGPAb=ExpGPAb(GPA_avg_1_2,simce,eff,betaGPAb_0,betaGPAb_1,betaGPAb_2,betaGPAb_3);   # (expected) GPA 
   expGPAb_912=0.5*GPA_avg_1_2+0.5*expGPAb
   expGPAb_sim[i,m]=expGPAb
   expCutoff_top15_b=cutoff_top15b[i][1];   # perceived cut-off
   Pr_PACEslot_b_sim[i,m]=treated*PrPACEslotb(dist_stNormal,zetabpace_0,zetabpace_1,expGPAb_912,expCutoff_top15_b); # subjective prob. of PACE admission
   Pr_PACEslot_b_obs_sim[i,m]=PrPACEslotb(dist_stNormal,zetabpace_0,zetabpace_1,expGPAb_912,expCutoff_top15_b)
   Pr_PACEslot_b=Pr_PACEslot_b_sim[i,m];
   expPSUb=ExpPSUb(GPA_avg_1_2,simce,eff,PSUb_kink,betaPSUb_0,betaPSUb_1,betaPSUb_2,betaPSUb_3,betaPSUb_4);    
   expPSUb_sim[i,m]=expPSUb;    
   expselP=selP(lambdaP_0, lambdaP_1, lambdaP_2, lambdaP_3, lambdaP_4, lambdaP_5, lambdaP_6, lambdaP_7, lambdaP_8, lambdaP_9, lambdaP_10, lambdaP_11, lambdaP_12, lambdaP_13, lambdaP_14,expGPAb_912,simce,academic,r4,r5,r7,r8,r10,r13,r14,r15 ); # exp. selectivity PACE
   expselR=selR(lambdaR_0, lambdaR_1, lambdaR_2, lambdaR_3, lambdaR_4, lambdaR_5, lambdaR_6, lambdaR_7, lambdaR_8, lambdaR_9, lambdaR_10, lambdaR_11, lambdaR_12, lambdaR_13, lambdaR_14,expPSUb,simce,academic,r4,r5,r7,r8,r10,r13,r14,r15 ); # exp selectivity Regular 
   female=female_data[i][1];   # female
   alumno_prioritario=alumno_prioritario_data[i][1];   # alumno prioritario
   Pr_Admitted_R_b_sim[i,m]=PrAdmRb(dist_stNormal,gammab_0,gammab_1,expPSUb);
   Pr_AdmR_b=Pr_Admitted_R_b_sim[i,m];
   expGPA=ExpGPA(k,GPA_avg_1_2,simce,eff,betaGPA_0,betaGPA_1,betaGPA_2,betaGPA_3);
   expPSU=ExpPSU(k,GPA_avg_1_2,simce,eff,betaPSU_0,betaPSU_1,betaPSU_2,betaPSU_3) ;  # (expectation = mean) GPA actual
   GPA_sim[i,m]=max.(min.(expGPA+eGPA[i,m],7.0),1.0)[1];   # realization of GPA (truncated)
   PSU_sim[i,m]=max.(min.(expPSU+ePSU[i,m],3),-3); # simulated PSU

   
      V_0=0.0+Emax_E_fun(k,expselP,expselR,0,0,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1];   # value of not sitting the PSU
      V_S=U2(costS,costSTreat,treated)+ePSUreg[i,m]+(1-Pr_AdmR_b)*(1-Pr_PACEslot_b)*Emax_E_fun(k,expselP,expselR,0,0,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1]+
                  (1-Pr_AdmR_b)*Pr_PACEslot_b*(Emax_E_fun(k,expselP,expselR,0,1,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1])+
                   Pr_AdmR_b*(1-Pr_PACEslot_b)*Emax_E_fun(k,expselP,expselR,1,0,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1]+
                   Pr_AdmR_b*Pr_PACEslot_b*(Emax_E_fun(k,expselP,expselR,1,1,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1]);   # value of sitting the PSU
      
      PDV_2_nosit_sim[i,m]=V_0
      PDV_2_sit_sim[i,m]=V_S
      
      if V_S>=V_0 # if value of sitting PSU is higher than 0, sit the PSU
         sit_PSU_sim[i,m]=1  # sit PSU simulation
         Ut_2_sim[i,m]=U2(costS,costSTreat,treated)+ePSUreg[i,m]
      else
         sit_PSU_sim[i,m]=0  # sit PSU simulation
      end #if utility comparison
   end # for m
end # for i


cutoff_top15_sim=zeros(size_N, size_shocks);   # initialize matrix of simulated top 15 cutoff
element_pos=Vector{Int64}(undef,1)
GPA_all_sim=zeros(size_N,size_shocks);
for i=1:1:size_N 
   for m=1:1:size_shocks 
      GPA_all_sim[i,m]=0.5.*GPA_sim[i,m]+0.5*GPA_avg_1_2_data[i]
   end  # for m 
end # for i

for m=1:1:size_shocks 
element_pos[1]=1
for i=1:1:(size_N-1)
   cutoff_top15_sim[i,m]=quantile!(GPA_all_sim[element_pos[1]:(element_pos[1]-1+Int(n_obs_school[i])),m],0.85)
   if rbd[i]==rbd[i+1]
      else
   element_pos[1]=element_pos[1]+Int(n_obs_school[i])
   end
end # for i 
cutoff_top15_sim[size_N,m]=cutoff_top15_sim[size_N-1,m]
end # for m 


# Time period 3A: PACE admission
PACEslot_sim=zeros(size_N, size_shocks);   # initialize matrix of simulated PACE slot
AdmP_sim=zeros(size_N, size_shocks);   # initialize matrix of admission
top15_sim=zeros(size_N, size_shocks);

for i=1:1:size_N   # for each student i
    
    treated=pace_data[i]

    for m=1:1:size_shocks 
    sit_PSU=sit_PSU_sim[i,m]
    if GPA_all_sim[i,m]>=cutoff_top15_sim[i,m]
       PACEslot_sim[i,m]=treated*sit_PSU;
       top15_sim[i,m]=1.0;
    else
       PACEslot_sim[i,m]=0.0;
    end
    AdmP_sim[i,m]=PACEslot_sim[i,m]

   end #for m
end   # for i



# Time period 3B: regular admission
AdmR_sim=zeros(size_N, size_shocks);   # initialize matrix of admission
for i=1:1:size_N
   for m=1:1:size_shocks
    if sit_PSU_sim[i,m]==1 # if sat the PSU
       # to assign admissions, we must use the TRUE admission process probabilities and the observed simulat
       AdmR_sim[i,m]=(gammat_0+gammat_1*PSU_sim[i,m]+gammat_2*PSU_sim[i,m]*PSU_sim[i,m]+gammat_3*PSU_sim[i,m]*PSU_sim[i,m]*PSU_sim[i,m]+psi[i,m]>=0 ? 1 : 0)
    end
   end #for m
end


# Time period 4: enrollment choice

E0_sim=zeros(size_N, size_shocks);   # initialize matrix of simulated no enrolment choice
ER_sim=zeros(size_N, size_shocks);   # initialize matrix of simulated regular enrolment choice
EP_sim=zeros(size_N, size_shocks);   # initialize matrix of simulated PACE enrolment choice
Ut_5_sim=zeros(size_N, size_shocks);
Utility_sim_expected=zeros(size_N, size_shocks);      # overall utility
selectivity_P_sim=zeros(size_N, size_shocks); # initialize matrix of selectivity regular
selectivity_R_sim=zeros(size_N, size_shocks); # initialize matrix of selectivity PACE


PDV_4_ER=zeros(size_N, size_shocks);      # PDV at time 4 from the choice of enrolling regular 
PDV_4_EP=zeros(size_N, size_shocks);      # PDV at time 4 from the choice of enrolling pace 
PDV_4_ERdropout=zeros(size_N, size_shocks); # PDV at time 4 from enrolling regular and dropping out 
PDV_4_EPdropout=zeros(size_N, size_shocks); # PDV at time 4 from enrolling PACE and dropping out 
PDV_4_GradP=zeros(size_N, size_shocks); # Additional PDV at time 4 from graduating PACE 
PDV_4_GradR=zeros(size_N, size_shocks); # Additional PDV at time 4 from graduating regular 



for i=1:1:size_N  
    
    simce=simce_data[i];
    female=female_data[i];
    r4=r4_data[i];
    r5=r5_data[i];
    r7=r7_data[i];
    r8=r8_data[i];
    r10=r10_data[i];
    r13=r13_data[i];
    r14=r14_data[i];
    r15=r15_data[i];
    academic=modalidad_data[i];
    GPA_1_2_rank=GPA_1_2_rank_data[i];
    p_grad= Pgradb_data[i]  #perceived graduation likelihood
   for m=1:1:size_shocks 
    k=k_vec[i,m];
    GPA_cuarto=GPA_sim[i,m];
    PSU=PSU_sim[i,m];
    selectivity_P_sim[i,m]=selP(lambdaP_0, lambdaP_1, lambdaP_2, lambdaP_3, lambdaP_4, lambdaP_5, lambdaP_6, lambdaP_7, lambdaP_8, lambdaP_9, lambdaP_10, lambdaP_11, lambdaP_12, lambdaP_13, lambdaP_14,GPA_cuarto,simce,academic,r4,r5,r7,r8,r10,r13,r14,r15)+shock_selP[i,m] ;
    selectivity_R_sim[i,m]=selR(lambdaR_0, lambdaR_1, lambdaR_2, lambdaR_3, lambdaR_4, lambdaR_5, lambdaR_6, lambdaR_7, lambdaR_8, lambdaR_9, lambdaR_10, lambdaR_11, lambdaR_12, lambdaR_13, lambdaR_14,PSU,simce,academic,r4,r5,r7,r8,r10,r13,r14,r15 )+shock_selR[i,m];
    admr=AdmR_sim[i,m];   # simulated regular admission
    admp=AdmP_sim[i,m];   # simulated PACE admission = having a PACE slot
    V_0=0.0;   # value of no enrolment
    
    V_R=expVR(k,lambdaPR_0,lambdaG0,lambdaG1,selectivity_R_sim[i,m],p_grad)+nuR[i,m];         # value of regular enrolment
    V_P=expVP(k,lambdaPR_0,lambdaG0,lambdaG1,selectivity_P_sim[i,m],delta,p_grad)+nuP[i,m];   # value of PACE enrolment
    
    PDV_4_ER[i,m]=V_R 
    PDV_4_EP[i,m]=V_P


    PDV_4_ERdropout[i,m]=lambdaPR_0[k]
    PDV_4_EPdropout[i,m]=lambdaPR_0[k]-delta
    PDV_4_GradR[i,m]=lambdaG0+lambdaG1.*selectivity_R_sim[i,m]
    PDV_4_GradP[i,m]=lambdaG0+lambdaG1.*selectivity_P_sim[i,m]

    if (admr==0 && admp==0)   # if no admission
       E0_sim[i,m]=1.0
       ER_sim[i,m]=0.0
       EP_sim[i,m]=0.0
    elseif (admr==1 && admp==0)   # if regular admission only
        if V_R>=V_0
           E0_sim[i,m]=0.0
           ER_sim[i,m]=1.0
           EP_sim[i,m]=0.0
           Ut_5_sim[i,m]=V_R
        else
           E0_sim[i,m]=1.0
           ER_sim[i,m]=0.0
           EP_sim[i,m]=0.0
        end
     elseif (admr==0 && admp==1)   # if PACE admission only
         if V_P>=V_0
            E0_sim[i,m]=0.0
            ER_sim[i,m]=0.0
            EP_sim[i,m]=1.0
            Ut_5_sim[i,m]=V_P
         else
            E0_sim[i,m]=1.0
            ER_sim[i,m]=0.0
            EP_sim[i,m]=0.0
         end
      else   # if both admissions
         if (V_P>=V_0 && V_P>=V_R)
            E0_sim[i,m]=0.0
            ER_sim[i,m]=0.0
            EP_sim[i,m]=1.0
            Ut_5_sim[i,m]=V_P
         elseif (V_R>=V_0 && V_R>V_P)
            E0_sim[i,m]=0.0
            ER_sim[i,m]=1.0
            EP_sim[i,m]=0.0
            Ut_5_sim[i,m]=V_R
         else
            E0_sim[i,m]=1.0
            ER_sim[i,m]=0.0
            EP_sim[i,m]=0.0
         end
     end

     ##calculate overall utility by summing up utilities in all time periods
     Utility_sim_expected[i,m]=Ut_1_sim[i,m]+Ut_2_sim[i,m]+Ut_5_sim[i,m]
   end # for m
end   # for i

# Time period 5: actual dropout
# Simulate actual persistence/dropout, as a function of their simce, effort, and baseline characteristics (same as Tablle A16 regressors + type)

Persist_sim=zeros(size_N, size_shocks);   # initialize "enroll and persist" vector (=0 if not enrolled)

for i=1:1:size_N  
   for m=1:1:size_shocks  
   enrolled=ER_sim[i,m]+EP_sim[i,m] 
   if (enrolled==0.0) # no enrollment
       Persist_sim[i,m]=0.0;
   elseif (enrolled>0.0) #
      k=k_vec[i,m];
      simce=simce_data[i];
      eff=Eff_sim[i,m];
      p_persist=p_persist_actual(k,simce,eff,theta_ppersist0,theta_ppersist)
      if (latent_dropout_sim[i,m]>=0.0 && latent_dropout_sim[i,m]<=p_persist)
         Persist_sim[i,m]=1.0;
      else 
         Persist_sim[i,m]=0.0;
      end 
   end 
end #for m   
end # for i

Utility_sim_actual=zeros(size_N, size_shocks);
# Ex-post utility at realised enrollment and persistence 
for i=1:1:size_N
   for m=1:1:size_shocks 
   enrolled_pace=EP_sim[i,m]
   enrolled_regular=ER_sim[i,m]
   persist=Persist_sim[i,m]
   k=k_vec[i,m]
   if (enrolled_pace==1.0 && persist==1)
      Utility_sim_actual[i,m]=Ut_1_sim[i,m]+Ut_2_sim[i,m]+lambdaPR_0[k]-delta+(lambdaG0+lambdaG1.*selectivity_P_sim[i,m])+nuP[i,m]
   elseif (enrolled_pace==1 && persist==0)
      Utility_sim_actual[i,m]=Ut_1_sim[i,m]+Ut_2_sim[i,m]+lambdaPR_0[k]-delta+nuP[i,m]
   elseif (enrolled_regular==1 && persist==1)
      Utility_sim_actual[i,m]=Ut_1_sim[i,m]+Ut_2_sim[i,m]+lambdaPR_0[k]+(lambdaG0+lambdaG1.*selectivity_R_sim[i,m])+nuR[i,m]
   elseif (enrolled_regular==1 && persist==0)
      Utility_sim_actual[i,m]=Ut_1_sim[i,m]+Ut_2_sim[i,m]+lambdaPR_0[k]+nuR[i,m]
   elseif (enrolled_pace==0 && enrolled_regular==0)
      Utility_sim_actual[i,m]=Ut_1_sim[i,m]+Ut_2_sim[i,m]
   end #if
end # for m
end # for i



# Print the dataset with mrun and simulated data
## print dataset
Simulation_Output=Array{Union{Missing, Float64},3}(undef,size_N,size_shocks,80)
for m=1:1:size_shocks 
   for i=1:1:size_N
   # identifiers
    Simulation_Output[i,m,1]=data[i,2]    # X mrun
    Simulation_Output[i,m,2]=data[i,1]    # X rbd_basefinal
    Simulation_Output[i,m,3]=pace_data[i] # X treatment

    #latent outcomes and choices
    Simulation_Output[i,m,4]=0.0 #y_sim[i]+measurement_err[i]              # X simulated score, observed
    Simulation_Output[i,m,5]=min.(max.(Eff_sim[i,m]+measurement_err_eff[i,m],0.0),10.0)[1] #Eff_sim[i]+measurement_err_eff[i]        # X simulated effort, observed
    Simulation_Output[i,m,6]=ER_sim[i,m]         # X sim_enrolled_SUA_regular
    Simulation_Output[i,m,7]=EP_sim[i,m]         # X sim_enrolled_SUA_PACE
    Simulation_Output[i,m,8]=Persist_sim[i,m]    # X sim enroll and persist SUA
    Simulation_Output[i,m,9]=AdmR_sim[i,m]       # X sim_admitted_SUA_regular
    Simulation_Output[i,m,10]=AdmP_sim[i,m]       # X sim_admitted_SUA_pace (= in top 15% and take PSU)
    Simulation_Output[i,m,11]=sit_PSU_sim[i,m]   # X sim_sit_PSU
    Simulation_Output[i,m,12]=PSU_sim[i,m]       # X sim_PSU, latent (i.e. nonmissing even for those who do not take PSU)
    Simulation_Output[i,m,13]=GPA_sim[i,m]       # X sim_GPA

    #beliefs
    Simulation_Output[i,m,14]=expPSUb_sim[i,m]                  # X sim_exp_PSUscore, latent
    Simulation_Output[i,m,15]=Pr_PACEslot_b_sim[i,m]            # X simulated subjective probability of being in top 15 percent of school, latent
    Simulation_Output[i,m,16]=Pr_Admitted_R_b_sim[i,m]          # X sim subj. prob. reg. admission, latent
    Simulation_Output[i,m,17]=expGPAb_sim[i,m]                  # X 
    Simulation_Output[i,m,18]=PSUb_coeff_eff_1_data[i]          # X 
    Simulation_Output[i,m,19]=PSUb_coeff_eff_2_data[i]          # X
    Simulation_Output[i,m,20]=GPAb_coeff_eff_data[i]            # X
    for e=2:1:size_Eff 
      Simulation_Output[i,m,21-2+e]=Ret_eff_pr_adm[i,e,m]               # X, =-999 if missing/undefined
    end 
    Simulation_Output[i,m,31]=Eff_sim[i,m]                   # effort without m.e.

    #types and utilities
    Simulation_Output[i,m,32]=k_vec[i,m]                   # X sim type
    Simulation_Output[i,m,33]=Utility_sim_expected[i,m]    # X ex ante overall utility
    Simulation_Output[i,m,34]=Utility_sim_actual[i,m]      # X ex post overall utility, once true dropout realized 

    #simulated being in the top 15
    Simulation_Output[i,m,35]=top15_sim[i,m]

    # selectivities
    Simulation_Output[i,m,36]=selectivity_R_sim[i,m]   # X
    Simulation_Output[i,m,37]=selectivity_P_sim[i,m]   # X

    # Present discunted values at time 2
    Simulation_Output[i,m,38]=PDV_2_nosit_sim[i,m] # PDV from not taking the PSU 
    Simulation_Output[i,m,39]=PDV_2_sit_sim[i,m] # PDV from taking the PSU 

    # Present discounted values at time 4, simulated also for those without admissions 
    Simulation_Output[i,m,40]=PDV_4_ER[i,m]
    Simulation_Output[i,m,41]=PDV_4_EP[i,m]
    Simulation_Output[i,m,42]=PDV_4_ERdropout[i,m] # PDV at time 4 from enrolling regular and dropping out 
    Simulation_Output[i,m,43]=PDV_4_EPdropout[i,m] # PDV at time 4 from enrolling PACE and dropping out 
    Simulation_Output[i,m,44]=PDV_4_GradP[i,m] # Additional PDV at time 4 from graduating PACE 
    Simulation_Output[i,m,45]=PDV_4_GradR[i,m] # Additional PDV at time 4 from graduating regular 

    Simulation_Output[i,m,46]=GPA_all_sim[i,m] # GPA all, which is the average of GPA in all 4 years 

    # PDV of effort levels at time 1
    for e=1:1:size_Eff
    Simulation_Output[i,m,46+e]=PDV_1_eff[i,e,m]
    end

    # Flow utility at time 1 from each level of effort 
    for e=1:1:size_Eff
    Simulation_Output[i,m,57+e]=Ut_1_eff[i,e,m]
    end 

    # Future value at time 1 from each level of effort 
    for e=1:1:size_Eff
    Simulation_Output[i,m,68+e]=Emax_1_eff[i,e,m]
    end 

    Simulation_Output[i,m,80]=m
  
   end #for i
end # for m


df = DataFrame(reshape(Simulation_Output, :, size(Simulation_Output, 3)), :auto)


if size_K == 1
    CSV.write(joinpath(path_processed, "baseline_TC_1type_rescale.csv"), df)
elseif size_K == 2
    CSV.write(joinpath(path_processed, "baseline_TC_2types_rescale.csv"), df)
elseif size_K == 3
    CSV.write(joinpath(path_processed, "baseline_TC_3types_rescale.csv"), df)
end



