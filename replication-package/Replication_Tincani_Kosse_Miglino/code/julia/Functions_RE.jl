# ================================================

# FUNCTIONS WITH RE: ENROLLMENT UTILITY DEPENDS 
#                    ON TRUE DROPOUT PROBABILITY 

# =================================================
#"""
#Note:
#function linspace(a,b,c) recreates the deprecated function linspace in Julia 1.0
#"""
#import Base.linspace
function linspace(a,b,c)
    result=range(a,stop=b,length=c)
  return result
  end
  
  
  #"""
  #Note:
  #function myisna(x) takes the vector x and transforms it into a vector whose
  #elements are "1" when the corresponding elements of x are "NA" and "0" otherwise
  #"""
  
  function myisna(x)
  outcome=NaN.*ones(length(x))
  for i=1:1:length(x)
  if typeof(x[i])==Missings.Missing
     outcome[i]=1.0
  else
     outcome[i]=0.0
  end
  end
  return outcome
  end
  
  
  #"""
  #Note:
  #function achievement(k,GPA_avg_1_2,simce,eff,alpha_0,alpha_1,alpha_2,alpha_3)
  #is the achievement production function. The arguments are:
  #the unobserved type, the vector of student's characteristics,
  #the vector of school/class characteristics, effort realization and
  #the parameters of the achievement production function.
  #"""
  function achievement(k,GPA_avg_1_2,simce,eff,alpha_0,alpha_1,alpha_2,alpha_3)
  y=alpha_0[k]+alpha_1*eff+alpha_2*GPA_avg_1_2+alpha_3*simce;
  return y
  end
  
  
  #"""
  #Note:
  #function ExpGPA is the expected GPA
  #production function. The arguments are: achievement/effort and the parameters of the
  #expected GPA production function.
  #"""
  function ExpGPA(k,GPA_avg_1_2,simce,eff,betaGPA_0,betaGPA_1,betaGPA_2,betaGPA_3)
  xpGPA=betaGPA_0[k]+betaGPA_1*eff+betaGPA_2*GPA_avg_1_2+betaGPA_3*simce;
  return xpGPA
  end
  
  #"""
  #Note:
  #function ExpGPAb is the expected GPA
  #belief production function. The arguments are: effort (y) and the parameters of the
  #expected GPA production function.
  #"""
  function ExpGPAb(GPA_avg_1_2,simce,eff,betaGPAb_0,betaGPAb_1,betaGPAb_2,betaGPAb_3)
  xpGPA=betaGPAb_0+betaGPAb_1*eff+betaGPAb_2*GPA_avg_1_2+betaGPAb_3*simce;
  return xpGPA
  end
  
  
  
  
  #"""
  #Note:
  #function ExpPSU is the expected PSU
  function ExpPSU(k,GPA_avg_1_2,simce,eff,betaPSU_0,betaPSU_1,betaPSU_2, betaPSU_3)
  xpPSU=betaPSU_0[k]+betaPSU_1*eff+betaPSU_2*GPA_avg_1_2+betaPSU_3*simce;
  return xpPSU
  end
  
  #"""
  #Note:
  #function ExpPSUb is the expected PSU
  #belief production function. 
  #"""
  function ExpPSUb(GPA_avg_1_2,simce,eff,PSUb_kink,betaPSUb_0,betaPSUb_1,betaPSUb_2,betaPSUb_3,betaPSUb_4)
    if eff>= PSUb_kink 
      xpPSU=betaPSUb_0+betaPSUb_2*eff+betaPSUb_3*GPA_avg_1_2+betaPSUb_4*simce;
    elseif eff < PSUb_kink
      xpPSU=betaPSUb_0+betaPSUb_1*eff+betaPSUb_3*GPA_avg_1_2+betaPSUb_4*simce;
    end 
    return xpPSU
    end
  #"""
  # Note:
  # function selP is the expected selectivity of the PACE seat, which averages over the shock. If it uses believed GPA as an input, it returns the expected/believed selectivity. 
  # If it uses the actual GPA as an input, it returns the actual expected selectivity.
  
  function selP(lambdaP_0, lambdaP_1, lambdaP_2, lambdaP_3, lambdaP_4, lambdaP_5, lambdaP_6, lambdaP_7, lambdaP_8, lambdaP_9, lambdaP_10, lambdaP_11, lambdaP_12, lambdaP_13, lambdaP_14,GPA_cuarto,simce,academic,r4,r5,r7,r8,r10,r13,r14,r15 )
  selP_output = lambdaP_0 + lambdaP_1.*GPA_cuarto + lambdaP_2.*GPA_cuarto.*GPA_cuarto+lambdaP_3.*simce+lambdaP_4.*simce.*simce+lambdaP_5.*academic.*simce+lambdaP_6.*academic+lambdaP_7.*r4+lambdaP_8.*r5+lambdaP_9.*r7+lambdaP_10.*r8+lambdaP_11.*r10+lambdaP_12.*r13+lambdaP_13.*r14+lambdaP_14.*r15
  return selP_output
  
  end
  
  #"""
  # Note:
  # function selR is the expected selectivity of the regular seat, which averages over the shock. If it uses believed PSU as an input, it returns the expected/believed selectivity. 
  # If it uses the actual PSU as an input, it returns the actual expected selectivity.
  
  function selR(lambdaR_0, lambdaR_1, lambdaR_2, lambdaR_3, lambdaR_4, lambdaR_5, lambdaR_6, lambdaR_7, lambdaR_8, lambdaR_9, lambdaR_10, lambdaR_11, lambdaR_12, lambdaR_13, lambdaR_14,PSU,simce,academic,r4,r5,r7,r8,r10,r13,r14,r15 )
  selR_output = lambdaR_0 + lambdaR_1.*PSU + lambdaR_2.*PSU.*PSU+lambdaR_3.*simce+lambdaR_4.*simce.*simce+lambdaR_5.*academic.*simce+lambdaR_6.*academic+lambdaR_7.*r4+lambdaR_8.*r5+lambdaR_9.*r7+lambdaR_10.*r8+lambdaR_11.*r10+lambdaR_12.*r13+lambdaR_13.*r14+lambdaR_14.*r15
  return selR_output
  
  end
  
  
  
  #"""
  #Note:
  #function PrAdmRb is the subjective probability of regular admissions
  function PrAdmRb(dist_stNormal,gammab_0,gammab_1,expPSUb)
  PrAdmRbres=cdf.(dist_stNormal,gammab_0+gammab_1*expPSUb)[1];
  return PrAdmRbres
  end
  
  #"""
  #Note:
  #function PrPACEslotb is the subjective probability of PACE admissions
  function PrPACEslotb(dist_stNormal,zetabpace_0,zetabpace_1,expGPAb,expCutoff_top15_b)
  PrPACEslotbres=cdf(dist_stNormal,zetabpace_0.+zetabpace_1.*(expGPAb-expCutoff_top15_b))[1] # prob. of PACE admission
  return PrPACEslotbres
  end
  
  #"""
  #Note:
  #function U1 is the flow utility in period 1
  function U1(k,xi_1,xi_2,eff)
  U1res=xi_1[k].*eff+xi_2.*eff.*eff; # flow utility in period 1
  return U1res
  end
  
  #"""
  #Note:
  #function U2 is the expected flow utility in period 2
  function U2(costS,costSTreat,treated)
  U2res=-costS-costSTreat*treated; # expected flow utility in period 2
  return U2res
  end
  
  #"""
  #Note:
  #function expVR is the expected value of regular enrolment
  function expVR(k,lambdaPR_0,lambdaG0,lambdaG1,expselR,p_grad)
  expVRres=lambdaPR_0[k]+p_grad.*(lambdaG0+lambdaG1.*expselR); # expected value of regular enrolment
  return expVRres
  end


  
  
  

  
  #"""
  #Note:
  #function expVP is the expected value of PACE enrolment
  function expVP(k,lambdaPR_0,lambdaG0,lambdaG1,expselP,delta,p_grad)
  expVPres=lambdaPR_0[k]-delta+p_grad.*(lambdaG0+lambdaG1.*expselP);   # expected value of PACE enrolment
  return expVPres
  end
  
  
  #"""
  #Note:
  #function Emax_S_fun is the Emax for the sitting PSU period
  #"""
  function Emax_S_fun(k,treated,expselP,expselR,costS,costSTreat,lambdaPR_0,lambdaG0,lambdaG1,delta,Pr_AdmR_b,Pr_PACEslot_b,p_grad)
    expV_0=0.0+Emax_E_fun(k,expselP,expselR,0.0,0.0,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1];   # value of not sitting the PSU
    expV_S=U2(costS,costSTreat,treated)+(1-Pr_AdmR_b)*(1-Pr_PACEslot_b)*Emax_E_fun(k,expselP,expselR,0.0,0.0,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1]+
           (1-Pr_AdmR_b)*Pr_PACEslot_b*(Emax_E_fun(k,expselP,expselR,0.0,1.0,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1])+
            Pr_AdmR_b*(1-Pr_PACEslot_b)*Emax_E_fun(k,expselP,expselR,1.0,0.0,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1]+
            Pr_AdmR_b*Pr_PACEslot_b*(Emax_E_fun(k,expselP,expselR,1.0,1.0,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)[1]);   # expected value of sitting the PSU
    Emax_S_out=euler+log.(exp.(expV_0)+exp.(expV_S));   # compute Emax for the sitting PSU period
    return Emax_S_out
    end
    
    #"""
  #Note:
  #function Emax_E_fun is the Emax for the enrolment period
  #"""
  
  function Emax_E_fun(k,expselP,expselR,AdmR,AdmP,lambdaPR_0,lambdaG0,lambdaG1,delta,p_grad)  # define type
    expV_0=0.0;   # value of no enrolment (deterministic part)
    
    expV_R=expVR(k,lambdaPR_0,lambdaG0,lambdaG1,expselR,p_grad);   # expected value of regular enrolment
    expV_P=expVP(k,lambdaPR_0,lambdaG0,lambdaG1,expselP,delta,p_grad);   # expected value of PACE enrolment
    
    if AdmR==0.0 && AdmP==0.0   # if no admission
      Emax_E_out=expV_0;   # compute Emax in enrolment period , γ is the mean of the GEV shock on no enrollment
    elseif AdmR==1.0 && AdmP==0.0   # if regular admission only
     Emax_E_out=euler+log.(exp.(expV_0)+exp.(expV_R));   # compute Emax in enrolment period
    elseif AdmR==0.0 && AdmP==1.0   # if PACE admission only
      Emax_E_out=euler+log.(exp.(expV_0)+exp.(expV_P));   # compute Emax in enrolment period
    else   # if both admissions
      Emax_E_out=euler+log.(exp.(expV_0)+exp.(expV_R)+exp.(expV_P));   # compute Emax in enrolment period
    end
    return Emax_E_out
    end
  
    
  
  

  
  #"""
  #Note:
  # function p_persist_actual is an exogenous stochastic process for the actual probability of graduating from a selective college
  # it keeps only the significant regressors from a probit regression of persistence conditional on enrolment on effort, simce, and the standard regressors 
  function p_persist_actual(k,simce,eff,theta_ppersist0,theta_ppersist)
  p_persist_actual_out=cdf(dist_stNormal,theta_ppersist0[k]+theta_ppersist[1].*eff+theta_ppersist[2].*simce)[1]
  return p_persist_actual_out
  end
  
  