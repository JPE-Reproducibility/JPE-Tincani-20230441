{smcl}
{* *! version 1.0.1  15sep2016}{...}
{* *! version 1.0.2  21sep2016}{...}
{cmd:help prodest}{right: ({browse "http://www.stata-journal.com/article.html?article=st0537":SJ18-3: st0537})}
{hline}

{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{cmd:prodest} {hline 2}}Production function estimation{p_end}
{p2colreset}{...}


{title:Syntax}

{phang}
Levinsohn and Petrin (LP 2003) methodology

{p 8 16 2}{cmd:prodest} {it:depvar} {ifin},
{cmdab:met:hod(lp)}
{opt free(varlist)}
{opt proxy(varlist)}
{opt state(varlist)}
[{it:{help prodest##LP_options:LP_options}}]


{phang}
Olley and Pakes (OP 1996) methodology

{p 8 16 2}{cmd:prodest} {it:depvar} {ifin},
{cmdab:met:hod(op)}
{opt free(varlist)}
{opt proxy(varlist)}
{opt state(varlist)}
[{it:{help prodest##OP_options:OP_options}}]


{phang}
Wooldridge (WRDG 2009) methodology

{p 8 16 2}{cmd:prodest} {it:depvar} {ifin},
{cmdab:met:hod(wrdg)}
{opt free(varlist)}
{opt proxy(varlist)}
{opt state(varlist)}
[{it:{help prodest##WRDG_options:WRDG_options}}]


{phang}
Robinson and Wooldridge (ROB 1988 and 2009) methodology

{p 8 16 6}{cmd:prodest} {it:depvar} {ifin},
{cmdab:met:hod(rob)}
{opt free(varlist)}
{opt proxy(varlist)}
{opt state(varlist)}
[{it:{help prodest##ROB_options:ROB_options}}]


{phang}
Mollisi and Rovigatti (MrEst 2017) methodology

{p 8 16 2}{cmd:prodest} {it:depvar} {ifin},
{cmdab:met:hod(mr)}
{opt free(varlist)}
{opt proxy(varlist)}
{opt state(varlist)}
[{it:{help prodest##MrEst_options:MrEst_options}}]


{p 4 6 2}A panel and a time variable must be specified; use {helpb xtset} or
the {opt id(varname)} and {opt t(varname)} options.{p_end}


{marker LP_options}{...}
{synoptset 29 tabbed}{...}
{synopthdr :LP_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opt met:hod(method)}}estimation method; available
{it:method}s are {cmd:lp} (Levinsohn-Petrin, the default),
{cmd:op} (Olley-Pakes), {cmd:wrdg} (Wooldridge),
{cmd:rob} (Robinson-Wooldridge), and {cmd:mr} (Mollisi-Rovigatti){p_end}
{p2coldent:* {opt free(varlist)}}free variables; ln(labor){p_end}
{p2coldent:* {opt proxy(varlist)}}proxy variables; ln(intermediate inputs){p_end}
{p2coldent:* {opt state(varlist)}}state variables; ln(capital){p_end}
{synopt :{opt control(varlist)}}control variables to be included{p_end}
{synopt :{opt endo:genous(varlist)}}endogenous variables to be included{p_end}
{synopt :{opt acf}}apply the Ackerberg, Caves, and Frazer (2015) correction{p_end}
{synopt :{opt va:lueadded}}{it:depvar} is the value added to output; default is gross output{p_end}
{synopt :{opt att:rition}}correct for attrition in the data{p_end}
{synopt :{opt init(string)}}specify the initial starting points for the optimization routine{p_end}
{synopt :{opt trans:log}}use a translog production function for estimation;
available only with {cmd:acf}{p_end}

{syntab:Optimization}
{synopt :{it:{help prodest##optoptions:optoptions}}}control the optimization process{p_end}

{syntab:Other}
{synopt :{opt id(varname)}}{it:panelvar} to {helpb xtset} the data{p_end}
{synopt :{opt t(varname)}}{it:timevar} to {helpb xtset} the data{p_end}
{synopt :{opt reps(#)}}number of bootstrap repetitions with a minimum of 2;
default is {cmd:reps(5)}{p_end}
{synopt :{opt poly(#)}}degree of polynomial approximations with a range of 3
to 6; default is {cmd:poly(3)}{p_end}
{synopt :{opt seed(#)}}seed to be set (integer); default is {cmd:seed(12345)}{p_end}
{synopt :{opt fsres:iduals(newvar)}}save first-stage residuals in {it:newvar}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {cmd:method()}, {cmd:free()}, {cmd:proxy()}, and {cmd:state()} are required.


{marker OP_options}{...}
{synoptset 29 tabbed}{...}
{synopthdr :OP_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opt met:hod(method)}}estimation method; available
{it:method}s are {cmd:lp} (Levinsohn-Petrin, the default),
{cmd:op} (Olley-Pakes), {cmd:wrdg} (Wooldridge),
{cmd:rob} (Robinson-Wooldridge), and {cmd:mr} (Mollisi-Rovigatti){p_end}
{p2coldent:* {opt free(varlist)}}free variables; ln(labor){p_end}
{p2coldent:* {opt proxy(varlist)}}proxy variables; ln(investment){p_end}
{p2coldent:* {opt state(varlist)}}state variables; ln(capital){p_end}
{synopt :{opt control(varlist)}}control variables to be included{p_end}
{synopt :{opt endo:genous(varlist)}}endogenous variables to be included{p_end}
{synopt :{opt acf}}apply the Ackerberg, Caves, and Frazer (2015) correction{p_end}
{synopt :{opt va:lueadded}}{it:depvar} is the value added to output; default is gross output{p_end}
{synopt :{opt att:rition}}correct for attrition in the data{p_end}
{synopt :{opt init(string)}}specify the initial starting points for the optimization routine{p_end}
{synopt :{opt trans:log}}use a translog production function for estimation;
available only with {cmd:acf}{p_end}

{syntab:Optimization}
{synopt :{it:{help prodest##optoptions:optoptions}}}control the optimization process{p_end}

{syntab:Other}
{synopt :{opt id(varname)}}{it:panelvar} to {helpb xtset} the data{p_end}
{synopt :{opt t(varname)}}{it:timevar} to {helpb xtset} the data{p_end}
{synopt :{opt reps(#)}}number of bootstrap repetitions with a minimum of 2;
default is {cmd:reps(5)}{p_end}
{synopt :{opt poly(#)}}degree of polynomial approximations with a range of 3
to 6; default is {cmd:poly(3)}{p_end}
{synopt :{opt seed(#)}}seed to be set (integer); default is {cmd:seed(12345)}{p_end}
{synopt :{opt fsres:iduals(newvar)}}save first-stage residuals in {it:newvar}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {cmd:method()}, {cmd:free()}, {cmd:proxy()}, and {cmd:state()} are required.


{marker WRDG_options}{...}
{synoptset 29 tabbed}{...}
{synopthdr :WRDG_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opt met:hod(method)}}estimation method; available
{it:method}s are {cmd:lp} (Levinsohn-Petrin, the default),
{cmd:op} (Olley-Pakes), {cmd:wrdg} (Wooldridge),
{cmd:rob} (Robinson-Wooldridge), and {cmd:mr} (Mollisi-Rovigatti){p_end}
{p2coldent:* {opt free(varlist)}}free variables; ln(labor){p_end}
{p2coldent:* {opt proxy(varlist)}}proxy variables; ln(intermediate inputs){p_end}
{p2coldent:* {opt state(varlist)}}state variables; ln(capital){p_end}
{synopt :{opt control(varlist)}}control variables to be included{p_end}
{synopt :{opt endo:genous(varlist)}}endogenous variables to be included{p_end}
{synopt :{opt va:lueadded}}{it:depvar} is the value added to output; default is gross output{p_end}
{synopt :{opt init(string)}}specify the initial starting points for the optimization routine{p_end}

{syntab:Optimization}
{synopt :{it:{help prodest##optoptions:optoptions}}}control the optimization process{p_end}

{syntab:Other}
{synopt :{opt over:identification}}include lagged polynomial in {cmd:state()} and {cmd:proxy()} among the instruments{p_end}
{synopt :{opt id(varname)}}{it:panelvar} to {helpb xtset} the data{p_end}
{synopt :{opt t(varname)}}{it:timevar} to {helpb xtset} the data{p_end}
{synopt :{opt poly(#)}}degree of polynomial approximations with a range of 3
to 6; default is {cmd:poly(3)}{p_end}
{synopt :{opt seed(#)}}seed to be set (integer); default is {cmd:seed(12345)}{p_end}
{synopt :{opt gmm}}perform the estimation with the {helpb gmm} command{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {cmd:method()}, {cmd:free()}, {cmd:proxy()}, and {cmd:state()} are required.


{marker ROB_options}{...}
{synoptset 29 tabbed}{...}
{synopthdr :ROB_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opt met:hod(method)}}estimation method; available
{it:method}s are {cmd:lp} (Levinsohn-Petrin, the default),
{cmd:op} (Olley-Pakes), {cmd:wrdg} (Wooldridge),
{cmd:rob} (Robinson-Wooldridge), and {cmd:mr} (Mollisi-Rovigatti){p_end}
{p2coldent:* {opt free(varlist)}}free variables; ln(labor){p_end}
{p2coldent:* {opt proxy(varlist)}}proxy variables; ln(intermediate inputs){p_end}
{p2coldent:* {opt state(varlist)}}state variables; ln(capital){p_end}
{synopt :{opt control(varlist)}}control variables to be included{p_end}
{synopt :{opt endo:genous(varlist)}}endogenous variables to be included{p_end}
{synopt :{opt va:lueadded}}{it:depvar} is the value added to output; default is gross output{p_end}
{synopt :{opt init(string)}}specify the initial starting points for the optimization routine{p_end}

{syntab:Optimization}
{synopt :{it:{help prodest##optoptions:optoptions}}}control the optimization process{p_end}

{syntab:Other}
{synopt :{opt over:identification}}include lagged polynomial in {cmd:state()}
and {cmd:proxy()} among the instruments{p_end}
{synopt :{opt id(varname)}}{it:panelvar} to {helpb xtset} the data{p_end}
{synopt :{opt t(varname)}}{it:timevar} to {helpb xtset} the data{p_end}
{synopt :{opt poly(#)}}degree of polynomial approximations with a range of 3
to 6; default is {cmd:poly(3)}{p_end}
{synopt :{opt seed(#)}}seed to be set (integer); default is {cmd:seed(12345)}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {cmd:method()}, {cmd:free()}, {cmd:proxy()}, and {cmd:state()} are required.


{marker MrEst_options}{...}
{synoptset 29 tabbed}{...}
{synopthdr :MrEst_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opt met:hod(method)}}estimation method; available
{it:method}s are {cmd:lp} (Levinsohn-Petrin, the default),
{cmd:op} (Olley-Pakes), {cmd:wrdg} (Wooldridge),
{cmd:rob} (Robinson-Wooldridge), and {cmd:mr} (Mollisi-Rovigatti){p_end}
{p2coldent:* {opt free(varlist)}}free variables{p_end}
{p2coldent:* {opt proxy(varlist)}}proxy variables{p_end}
{p2coldent:* {opt state(varlist)}}state variables{p_end}
{synopt :{opt control(varlist)}}control variables to be included{p_end}
{synopt :{opt endo:genous(varlist)}}endogenous variables to be included{p_end}
{synopt :{opt va:lueadded}}{it:depvar} is the value added to output; default is gross output{p_end}
{synopt :{opt init(string)}}specify the initial starting points for the optimization routine{p_end}
{synopt :{opt lags(#)}}lags to be used as Blundell-Bond-type instruments{p_end}

{syntab:Optimization}
{synopt :{it:{help prodest##optoptions:optoptions}}}control the optimization process{p_end}

{syntab:Other}
{synopt :{opt over:identification}}include lagged polynomial in state and proxy among the instruments{p_end}
{synopt :{opt id(varname)}}{it:panelvar} to {helpb xtset} the data{p_end}
{synopt :{opt t(varname)}}{it:timevar} to {helpb xtset} the data{p_end}
{synopt :{opt poly(#)}}degree of polynomial approximations with a range of 3
to 6; default is {cmd:poly(3)}{p_end}
{synopt :{opt seed(#)}}seed to be set (integer); default is {cmd:seed(12345)}{p_end}
{synopt :{opt fsres:iduals(newvar)}}save first-stage residuals in {it:newvar}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {cmd:method()}, {cmd:free()}, {cmd:proxy()}, and {cmd:state()} are required.


{marker optoptions}{...}
{synoptset 29}{...}
{synopthdr :optoptions}
{synoptline}
{synopt :{opt opt:imizer(opttype)}}optimization technique; available {it:opttype}s are 
Nelder-Mead ({cmd:nm})*,
modified Newton-Raphson ({cmd:nr}), 
Davidon-Fletcher-Powell ({cmd:dfp}),
Broyden-Fletcher-Goldfarb-Shanno ({cmd:bfgs}),
Gauss-Newton ({cmd:gn})**,
Berndt-Hall-Hall-Hausman ({cmd:bhhh})*,
{p_end}
{synopt :{opt max:iter(#)}}maximum number of iterations; default is
{cmd:maxiter(10000)}{p_end}
{synopt :{opt eval:uator(string)}}Mata {helpb mf_optimize##i_evaluator:optimize_init_evaluatortype()}; default is
{cmd:evaluator(d0)} ({cmd:evaluator(gf0)} if {cmd:optimizer(bhhh)} specified){p_end}
{synopt :{opt tol:erance(#)}}Mata {helpb mf_optimize##i_ptol:optimize_init_conv_nrtol()}; default is
{cmd:tolerance(e-05)}{p_end}
{synoptline}
{p 4 6 2}
*  Available only with {cmd:method(op)} and {cmd:method(lp)}.{p_end}
{p 4 6 2}
** Available only with {cmd:method(wrdg)} and {cmd:method(mr)}.


{title:Description}

{pstd}
{cmd:prodest} estimates production functions using the control function
approach.  It includes Olley-Pakes (OP; 1996), Levinsohn-Petrin (LP; 2003),
Wooldridge (WRDG; 2009), and Ackerberg-Caves-Frazer (ACF; 2015) estimation
methodologies.  A new technique, which we call MrEst, has been added to deal
with short panels.


{title:Remarks}

{pstd}
By default, {cmd:prodest} requires the log gross output (or
value-added) variable (y_it), a set of free variables (typically log labor,
w_it), a set of state variables (typically log capital, k_it), and a set of
proxy variables.

{pstd}
Consider the following Cobb-Douglas (1928) production technology for firm i at
time t:

{phang2}
y_it = alpha + w_it*beta + k_it*gamma + omega_it + epsilon_it

{pstd}
Here y_it is the (log) gross output, w_it is a 1 x J vector of (log) free
variables, k_it is a 1 x K vector of state variables, and epsilon_it is a
normally distributed idiosyncratic error term.  The random component omega_it
is the unobserved technical efficiency parameter.  It evolves according to a
first-order Markov process,

{phang2}
omega_it = E(omega_it | omega_it-1) + u_it = g(omega_it-1) + u_it

{pstd}	
and u_it is a random shock component assumed to be uncorrelated with the
technical efficiency, the state variables in k_it, and the lagged free
variables (w_it-1).  Productivity estimation in the OP and LP methods (and
their ACF corrections) is performed in two steps. 

{phang}
{bf:1)} The OP method relies on the following set of assumptions:{p_end}
{phang2}
	{bf:1a)} inv_it = inv(k_it, omega_it); investments are a
	function of both the state variable and the technical efficiency
	parameter.{p_end}
{phang2}
	{bf:1b)} inv_it is strictly monotone in omega_it.{p_end}
{phang2}
	{bf:1c)} omega_it is scalar unobservable in i_it = i(.).{p_end}
{phang2}
	{bf:1d)} The levels of inv_it and k_it are decided at time t-1; the
	level of the free variable w_it is decided after the shock u_it
	is realized.{p_end}

{pstd}
Assumptions 1a-1d ensure the invertibility of inv_it in omega_it and lead to
the partially identified model

{phang2}
y_it = alpha + w_it*beta + k_it*gamma + h(inv_it, k_it) + epsilon_it = alpha + w_it*beta + psi(inv_it, k_it) + epsilon_it
	
{pstd}
which can be estimated by a nonparametric approach (first stage).  Because of
the Markovian nature of the productivity process, one can exploit assumption
1d as moment conditions to estimate the production function parameters (second
stage).  That is, one can exploit the residual e_it of

{phang2}
y_it - w_it*beta_hat = alpha + k_it*gamma + g(omega_it-1, chi_it) + e_it
	
{pstd}
where g(.) is typically left unspecified and approximated by an nth order
polynomial and chi_it is an indicator function for the attrition in the
market.

{phang}
{bf:2)} The LP method aimed to overcome the empirical issue of zeros in the investment
data by using intermediate inputs as a proxy variable for
omega_it, under the following set of assumptions:{p_end}
{phang2}
	{cmd:2a)} Firms immediately adjust the level of inputs according to
	demand function m(omega_it, k_it) after the technical efficiency
	shock is realized.{p_end}
{phang2}
	{cmd:2b)} m_it is strictly monotone in omega_it.{p_end}
{phang2}
	{cmd:2c)} omega_it is scalar unobservable in m_it = m(.).{p_end}
{phang2}
	{cmd:2d)} The levels of k_it are decided at time t-1; the level of the free variable w_it is decided after the shock u_it is realized.
	
{pstd}
Assumptions 2a-2d ensure the invertibility of m_it in omega_it and lead to the
partially identified model
	
{phang2} y_it = alpha + w_it*beta + psi(m_it, k_it) + v_it

{pstd}
which can be estimated by a nonparametric approach (first stage).  Because of
the Markovian nature of the productivity process, one can exploit assumption 2d
as moment conditions to estimate the production function parameters (second
stage).  That is, one can exploit the residual v_it of

{phang2}
y_it - w_it*beta_hat = alpha + k_it*gamma + g(omega_it-1, chi_it) + v_it

{pstd}
where g(.) is typically left unspecified and approximated by an nth order
polynomial and chi_it is an indicator function for the attrition in the
market.

{phang}
{bf:3)} Labor demand and the control function are partially collinear.  The ACF
estimation algorithm is based on the following
assumptions:{p_end}
{phang2}
	{bf:3a)} p_it = p(k_it, l_it, omega_it) is the proxy variable
	policy function.{p_end}
{phang2}
	{bf:3b)} Strict monotonicity holds for p_it relative to
	omega_it.{p_end}
{phang2}
	{bf:3c)} omega_it is scalar unobservable in p_it = p(.).{p_end}
{phang2}
	{bf:3d)} The state variables are decided at time t-1.  The least
	variable labor input l_it is chosen at t-b, where 0 < b < 1.  The
	free variables, w_it, are chosen in t when the firm productivity
	shock is realized.{p_end}

{pstd}
Under this set of assumptions, the first stage is meant to remove the shock
epsilon_it from the the output y_it.  As before, the policy function, once
inverted, can replace the productivity term omega_it in the production
function, yielding

{phang2}
	y_it = k_it*gamma + w_it*beta + mu*l_it + h(p_it, k_it, w_it, l_it) + epsilon_it

{pstd}
which can be estimated by a nonparametric approach (first stage).  Because of
the Markovian nature of the productivity process, one can exploit assumption 3d
as moment conditions to estimate the production function parameters (second
stage).  That is, one can exploit the residual u_it of

{phang2}
	omega_it = E(omega_it | omega_it-1) + u_it = g(omega_it-1) + u_it
 
{phang}
{bf:4)} The WRDG method is a more efficient approach to implement OP and LP
methodology.  The two stages are jointly estimated, and the estimator does not
suffer from the collinearity issue identified in OP/LP methodology.
The WRDG system GMM is based on the following assumptions:

{phang2}
	{bf:4a)} omega_it = g(x_it, p_it).  That is, productivity is an unknown
	function g(.) of state and a vector of proxy variables p_it.{p_end}
{phang2}
	{bf:4b)} E(omega_it | omega_it-1,...,omega_it-T) =
	E(omega_it | omega_it-1), t = 2,3,...,T.  This assumption restrains the
	productivity's dynamic to a first order Markov chain process.{p_end}
{phang2}
	{bf:4c)} E(omega_it | omega_it-1)=f(omega_it-1).  That is, productivity is an
	unknown function f(.) of lagged productivity omega_it-1.
 
{pstd}Under assumptions 4a-4c, it is possible to construct a system
GMM using the vector of residuals from

                 y_it - alpha - w_it*beta - x_it*gamma - g(x_it, p_it) 
        r_it =
                 y_it - alpha - w_it*beta - x_it*gamma - f{g(x_it-1, p_it-1)}

{pstd}where the unknown function f{.} is approximated by an nth polynomial and
g(x_it, m_it) = lambda_0 + c(x_it, m_it)*lambda.  In particular, g(x_it,
m_it) is a linear combination of functions in (x_it, m_it), where c_it are
the addends of this linear combination.  The residuals r_it are used to set
the moment conditions 

	E(Z_it*r_it) = 0

{pstd}with the following set of instruments:

		 z1_it = (1, w_it, x_it, c_it)
	Z_it =	
		 z2_it = (w_it-1, x_it, c_it-1)

{pstd}Moreover, Wooldridge (2009) shows how it is possible in an ACF setting to
consistently estimate beta and gamma by an instrumental-variables version of
Robinson (1988), using x_it, x_it-1, and m_it as included instruments and
using w_it-1 as an excluded instrument for w_it, with f(.) and g(.) left
unspecified.

{phang}
{bf:5)} Previous lags of free and state variables are potentially valid
instruments in a WRDG-type estimation framework.  However, adding
instruments in such a context would lead to a reduced sample size, and this
could be problematic given the "large N, small T" nature of most datasets used
in the related literature.  Introducing dynamic panel instruments {c a'g} la
Blundell-Bond (1998) is a solution to the issue.  This allows one to exploit the
additional information in the lagged instruments without losing observations
and estimation power.  Defining the residual function matrix as

                 y_i2 - alpha - w_i2*beta - x_i2*gamma - g(x_i2, p_i2)		
                 y_i2 - alpha - w_i2*beta - x_i1*gamma - f[g(x_i1, p_i1)]	
	r_it =				...
					...
                 y_it - alpha - w_it*beta - x_it*gamma - g(x_it, p_it)		
                 y_it - alpha - w_it*beta - x_it*gamma - f[g(x_it-1, p_it-1)]

{pstd}for each panel i, we define t - b, the last available lag (that is, when b = 1
at t = 2, b = 2 at t = 3, etc.).  Then define Z_i as the dynamic panel instrument
matrix for each panel (we suppress the subscript i):

                 z'_2 z'_3 ... z'_T 0    0    0   0   
                 0    0    ... 0    S'_3 0    0   0   
	Z =      0    0    ... 0    0    S'_4 0   0   
                 0    0    ... 0    0    0   ...  S'_T
                 0    0    ... 0    1    1   ...  1   

{pstd}where S_t is a 1 x b vector consisting of [z_t-1, ..., z_t-b].  Usual
moment conditions E[Z_it r_it] = 0 define the MrEst.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. insheet using "https://raw.githubusercontent.com/GabrieleRovigatti/prodest/master/stata/data/prodest.csv", names clear}{p_end}
{phang2}{it:({stata "insheet using https://raw.githubusercontent.com/GabrieleRovigatti/prodest/master/stata/data/prodest.csv, names clear":load data})}

{phang2}{cmd:. xtset id year, y}{space 10}/* not run */

{pstd}LP method{p_end}
{phang2}{cmd:. prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded optimizer(dfp) id(id) t(year) reps(50) fsresiduals(fs_lp)}{p_end}
{phang2}{it:({stata "prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded optimizer(dfp) id(id) t(year) reps(50) fsresiduals(fs_lp)":click to run})}

{pstd}LP method with ACF correction
{p_end}
{phang2}{cmd:. prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded acf id(id) t(year) reps(50)}{p_end}
{phang2}{it:({stata "prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded acf id(id) t(year) reps(50)":click to run})}

{pstd}OP method{p_end}
{phang2}{cmd:. prodest log_y, method(op) free(log_lab1 log_lab2) proxy(log_investment) state(log_k) valueadded  id(id) t(year) reps(40) poly(4)}{p_end}
{phang2}{it:({stata "prodest log_y, method(op) free(log_lab1 log_lab2) proxy(log_investment) state(log_k) valueadded id(id) t(year) reps(40) poly(4)":click to run})}

{pstd}OP method with ACF correction{p_end}
{phang2}{cmd:. prodest log_y, method(op) free(log_lab1 log_lab2) proxy(log_investment) state(log_k) valueadded acf optimizer(nm) id(id) t(year) reps(50) fsresiduals(fs_acf_op)}
{p_end}
{phang2}{it:({stata "prodest log_y, method(op) free(log_lab1 log_lab2) proxy(log_investment) state(log_k) valueadded acf optimizer(nm) id(id) t(year) reps(50) fsresiduals(fs_acf_op)":click to run})}

{pstd}WRDG method{p_end}
{phang2}{cmd:. prodest log_y, method(wrdg) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded id(id) t(year) poly(2)}{p_end}
{phang2}{it:({stata "prodest log_y, method(wrdg) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded id(id) t(year) poly(2)":click to run})}

{pstd}MrEst method{p_end}
{phang2}{cmd:. prodest log_y, method(mr) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded lags(1) id(id) t(year) poly(2)}{p_end}
{phang2}{it:({stata "prodest log_y, method(mr) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded lags(1) id(id) t(year) poly(2)":click to run})}


{title:Stored results}

{pstd}
{cmd:prodest} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of panel IDs{p_end}
{synopt:{cmd:e(tmin)}}minimum number of periods{p_end}
{synopt:{cmd:e(tmean)}}average number of periods{p_end}
{synopt:{cmd:e(tmax)}}maximum number of periods{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:prodest}{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(free)}}free variables{p_end}
{synopt:{cmd:e(state)}}state variables{p_end}
{synopt:{cmd:e(proxy)}}proxy variables{p_end}
{synopt:{cmd:e(control)}}control variables{p_end}
{synopt:{cmd:e(endogenous)}}endogenous variables{p_end}
{synopt:{cmd:e(technique)}}optimization technique{p_end}
{synopt:{cmd:e(idvar)}}ID variable{p_end}
{synopt:{cmd:e(timevar)}}time variable{p_end}
{synopt:{cmd:e(method)}}estimation method{p_end}
{synopt:{cmd:e(model)}}value-added or gross output model{p_end}
{synopt:{cmd:e(correction)}}correction ({cmd:acf}){p_end}
{synopt:{cmd:e(hans_j)}}Hansen's J ({cmd:method(wrdg)}){p_end}
{synopt:{cmd:e(hans_p)}}Hansen's J p-value{p_end}
{synopt:{cmd:e(waldT)}}Wald test on constant returns to scale{p_end}
{synopt:{cmd:e(waldP)}}Wald test p-value{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{title:References}

{phang}
Ackerberg, D. A., K. Caves, and G. Frazer. 2015.  Identification properties of
recent production function estimators.  {it:Econometrica} 83: 2411-2451.

{phang}
Blundell, R., and S. Bond. 1998.  Initial conditions and moment restrictions in dynamic panel data models. {it:Journal of Econometrics} 87: 115-143.

{phang}
Cobb, C. W., and P. H. Douglas. 1928.  A theory of production. 
{it:American Economic Review} 18 (Suppl. 1): 139-165.

{phang}
Levinsohn, J., and A. Petrin. 2003.  Estimating production functions using
inputs to control for unobservables.  {it:Review of Economic Studies} 70:
317-341.

{phang}
Mollisi, V., and G. Rovigatti. 2017.
Theory and practice of TFP estimation: The control function approach using
Stata.
CEIS Working Paper Series, No. 399.
{it:({stata "!cmd /c start https://papers.ssrn.com/sol3/papers2.cfm?abstract_id=2916753":click to download - Windows})}
{it:({stata "!xdg-open https://papers.ssrn.com/sol3/papers2.cfm?abstract_id=2916753":click to download - Unix})}
{it:({stata "!open https://papers.ssrn.com/sol3/papers2.cfm?abstract_id=2916753":click to download - MacOSX})}

{phang}
Olley, G. S., and A. Pakes. 1996.  The dynamics of productivity in the
telecommunications equipment industry.  {it:Econometrica} 64: 1263-1297.

{phang}
Robinson, P. M. 1988.  Root-n-consistent semiparametric regression.
{it:Econometrica} 56: 931-954.

{phang}
Wooldridge, J. M. 2009.  On estimating firm-level production functions using
proxy variables to control for unobservables.  {it:Economics Letters} 104:
112-114.


{title:Bug reporting}

{pstd}
{opt prodest} is part of an ongoing project and thus may contain errors
and malfunctions.  Please submit bugs, comments, and suggestions via email to

        gabriele.rovigatti@gmail.com

{pstd}
Please include steps to reproduce the issue and, if possible, the output of the
Stata command {cmd:creturn list}.


{title:Authors}

{pstd}Gabriele Rovigatti{p_end}
{pstd}University of Rome Tor Vergata{p_end}
{pstd}Einaudi Institute for Economics and Finance{p_end}
{pstd}Rome, Italy{p_end}
{pstd}gabriele.rovigatti@gmail.com{p_end}

{pstd}Vincenzo Mollisi{p_end}
{pstd}University of Rome Tor Vergata{p_end}
{pstd}Rome, Italy{p_end}
{pstd}vincenzo.mollisi@gmail.com{p_end}


{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 18, number 3: {browse "http://www.stata-journal.com/article.html?article=st0537":st0537}{p_end}

{p 7 14 2}
Help:  {helpb acfest}, {helpb opreg}, {helpb levpet},
{helpb prodest_p:prodest predict} (if installed){p_end}
