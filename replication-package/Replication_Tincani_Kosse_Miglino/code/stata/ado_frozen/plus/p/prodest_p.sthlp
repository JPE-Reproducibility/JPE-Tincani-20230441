{smcl}
{* *! version 1.0.1  06Jun2017}{...}
{cmd:help prodest_p}{right: ({browse "http://www.stata-journal.com/article.html?article=st0537":SJ18-3: st0537})}
{hline}

{title:Title}

{p 4 16 2}
{cmd:prodest predict} {hline 2} Postestimation tool for prodest{p_end}


{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} [{newvar}] {ifin} [, {it:statistics}]

{synoptset 18}{...}
{synopthdr :statistics}
{synoptline}
{synopt :{opt resid:uals}}residuals (y_it - hat{y}_it){p_end}
{synopt :{opt exp:onential}}exponentiated residuals{p_end}
{synopt :{opt par:ameters}}parameters for free, state, and control variables{p_end}
{synopt :{opt omega}}omega {log(TFP) (phi_it - hat{y})}; available only after {cmd:prodest,} {opt fsresiduals(newvar)}{p_end}
{synoptline}
{p2colreset}{...}


{title:Options for predict}

{dlgtab:Cobb-Douglas production function}

{phang}
{opt residuals} calculates log(residuals) values from the log production
function as omega_it + epsilon_it = y_it - beta_{l} * l - beta_{k} * k.

{phang}
{opt exponential} calculates the exponential of the residuals from the log
production function as exp(omega_it + epsilon_it) = exp(y_it - beta_{l} * l -
beta_{k} * k).

{phang}
{opt parameters} calculates the estimated parameters for free, state, and
control variables.

{phang}
{opt omega} calculates omega as in De Loecker and Warzynski (2012):
omega_it = phi_it - hat{y}.  Available only after
{cmd:prodest,} {opt fsresiduals(newvar)}.


{dlgtab:Translog production function}

{phang}
{opt residuals} calculates log(TFP) values from the log production function as
omega_it = y_it - beta_{l} * l - beta_{k} * k - beta_{ll} * l^2 - beta_{kk} *
k^2 - beta_{lk} * (l * k).

{phang}
{opt exponential} calculates the exponential of the residuals from the log
production function as exp(omega_it) = exp{y_it - beta_{l} * l - beta_{k} * k
- beta_{ll} * l^2 - beta_{kk} * k^2 - beta_{lk} * (l * k)}.

{phang}
{opt parameters} calculates the estimated elasticities for free and state
variables.  With translog PF, the elasticities (beta) are defined as
hat(beta)_{l} = E(beta_{l} + 2 beta_{ll} * l + beta_{lk} * k)
hat(beta)_{k} = E(beta_{k} + 2 beta_{kk} * k + beta_{lk} * l).

{phang}
{opt omega} calculates omega as in De Loecker and Warzynski (2012):
omega_it = phi_it - f(l,k,beta).  Available only after
{cmd:prodest,} {opt fsresiduals(newvar)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. insheet using "https://raw.githubusercontent.com/GabrieleRovigatti/prodest/master/stata/data/prodest.csv", names clear}{p_end}
{phang2}{it:({stata "insheet using https://raw.githubusercontent.com/GabrieleRovigatti/prodest/master/stata/data/prodest.csv, names clear":load data})}

{phang2}{cmd:. xtset id year, y}{space 10}/* not run */

{pstd}Levinsohn and Petrin method{p_end}
{phang2}{cmd:. prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded optimizer(dfp) id(id) t(year) reps(50) fsresiduals(fs_lp)}{p_end}
{phang2}{it:({stata "prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded optimizer(dfp) id(id) t(year) reps(50) fsresiduals(fs_lp)":click to run})}

{pstd}Obtain predicted values{p_end}
{phang2}{cmd:. predict lpfit, residuals}{p_end}
{phang2}{it:({stata "predict lpfit, residuals":click to run})}

{pstd}Levinsohn and Petrin method with Ackerberg, Caves, and Frazer correction
with translog production function{p_end}
{phang2}{cmd:. prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded acf id(id) t(year) reps(20) translog}{p_end}
{phang2}{it:({stata "prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded acf id(id) t(year) reps(20) translog":click to run})}

{pstd}Obtain predicted values{p_end}
{phang2}{cmd:. predict, parameters}{p_end}
{phang2}{it:({stata "predict, parameters":click to run})}


{title:Reference}

{phang}
De Loecker, J., and F. Warzynski. 2012. Markups and firm-level export status.
{it:American Economic Review} 102: 2437-2471.


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
{helpb prodest} (if installed){p_end}
