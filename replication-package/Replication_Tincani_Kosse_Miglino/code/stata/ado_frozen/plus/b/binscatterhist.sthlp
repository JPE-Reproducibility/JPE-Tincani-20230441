{smcl}
{* *! version 2.3  16nov2021}{...}
{viewerjumpto "Title" "binscatterhist##title"}{...}
{viewerjumpto "Syntax" "binscatterhist##syntax"}{...}
{viewerjumpto "Description" "binscatterhist##description"}{...}
{viewerjumpto "Options" "binscatterhist##options"}{...}
{viewerjumpto "Examples of main features (Stepner 2013)" "binscatterhist##examples1"}{...}
{viewerjumpto "Examples of histogram features" "binscatterhist##examples2"}{...}
{viewerjumpto "Examples of further features" "binscatterhist##examples3"}{...}
{viewerjumpto "Stored results" "binscatterhist##stored_results"}{...}
{viewerjumpto "Acknowledgments" "binscatterhist##acknowledgments"}{...}
{viewerjumpto "References" "binscatterhist##refs"}{...}
{viewerjumpto "Author" "binscatterhist##author"}{...}
{viewerjumpto "Also see" "binscatterhist##alsosee"}{...}
{cmd:help binscatterhist}{right: ({browse "https://doi.org/10.1177/1536867X221106418":SJ22-2: gr0091})}
{hline}

{marker title}{...}
{title:Title}

{p2colset 5 23 25 2}{...}
{p2col :{cmd:binscatterhist} {hline 2}}Binned scatterplots with variables
distribution{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
{cmd:binscatterhist}
{varlist} {ifin}
{help binscatterhist##weight:{it:weight}}
[{cmd:,} {it:options}]

{pstd}
{it:varlist} is {it:y_1} [{it:y_2} [...]] {it:x}

{synoptset 32 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opth by(varname)}}plot a separate series for by-value (see 
{help binscatterhist##by_notes:important notes below}){p_end}
{synopt :{opt med:ians}}create the binned scatterplot using the median {it:x}
and {it:y} values within each bin rather than the mean{p_end}

{syntab :Bins}
{synopt :{opt n:quantiles(#)}}specify the number of equal-sized bins to be
created; default is {cmd: nquantiles(20)}; may not be
combined with {opt discrete} or {opt xq()}{p_end}
{synopt :{opth gen:xq(varname)}}create a categorical variable containing the
computed bins; may not be combined with {opt discrete} or 
{opt xq()}{p_end}
{synopt :{opt discrete}}specify that the {it:x} variable is discrete and that
each {it:x} value is to be treated as a separate bin; may not be
combined with {opt nquantiles()}, {opt genxq()}, or {opt xq()}{p_end}
{synopt :{opth xq(varname)}}specify a categorical variable that contains the
bins to be used instead of having {cmd:binscatterhist} generate them; 
may not be combined with 
{opt nquantiles()}, {opt genxq()}, or {opt discrete}{p_end}

{syntab :Residuals computation}
{synopt :{opt reg:type(string)}}specify the type of regression to use to
compute residuals; {it:string} may be {cmd:reghdfe} or {cmd:areg}; requires
{cmd:absorb()} to be specified; default is {cmd:regtype(reghdfe)}{p_end}

{syntab :Standard errors/robust}
{synopt :{opth clust:er(varname)}}specify the variable that identifies
clusters{p_end}
{synopt :{cmd:vce(robust)}}specify to calculate robust standard errors{p_end}

{syntab :Controls}
{synopt :{opth control:s(varlist)}}residualize the {it:x} and {it:y} variables
on the specified controls before binning and plotting{p_end}
{synopt :{opth absorb(varlist)}}absorb fixed effects in the categorical
variable from the {it:x} and {it:y} variables before binning and
plotting{p_end}
{synopt :{opt noa:ddmean}}prevent the sample mean of each variable from being
added back to its residuals when combined with {opt controls()} or 
{opt absorb()}{p_end}

{syntab :Fit line}
{synopt :{opth line:type(binscatterhist##linetype:string)}}specify the type of
line plotted on each series; default is {cmd:linetype(lfit)}{p_end}
{synopt :{opth rd(numlist)}}draw a dashed vertical line at the specified {it:x}
values and generate regression discontinuities when combined with
{cmd:linetype(lfit)} or {cmd:linetype(qfit)}{p_end}
{synopt :{opt reportreg}}display in the Results window the regressions used to
estimate the fit lines{p_end}

{syntab :Coefficient and sample reporting}
{synopt :{opt coef:ficient(#)}}report the slope of the fitted line with its
standard error, rounded at {it:#} using {cmd:round(coefficient,} {it:#}{cmd:)};
see {helpb f_round:round()}{p_end}
{synopt :{opt ci(#)}}report the {it:#}% confidence interval, rounded as the
{opt coefficient()}{p_end}
{synopt :{opt p:value}}report the {it:p}-value of the regression on
residualized variables{p_end}
{synopt :{opt sample}}report the sample size of the regression on residualized
variables{p_end}
{synopt :{opt stars(string)}}report the {it:p}-value using stars; {it:string}
may be {cmd:nostars}, {cmd:1}, {cmd:2}, {cmd:3}, or {cmd:4}; default is
{cmd:stars(1)}{p_end}

{syntab :Graph style}
{synopt :{cmdab:col:ors(}{it:{help colorstyle}}{cmd:)}}specify an ordered
list of colors for each series{p_end}
{synopt :{cmdab:mc:olors(}{it:{help colorstyle}}{cmd:)}}specify an ordered
list of colors for the markers of each series; overrides any list
provided in {opt colors()}{p_end}
{synopt :{cmdab:lc:olors(}{it:{help colorstyle}}{cmd:)}}specify an ordered
list of colors for the lines of each series; overrides any list provided
in {opt colors()}{p_end}
{synopt :{cmdab:m:symbols(}{it:{help symbolstyle}}{cmd:)}}specify an
ordered list of symbols for each series{p_end}
{synopt :{it:{help twoway_options}}}control the graph 
{help title options:titles}, {help legend option:legends}, 
{help axis options:axes}, added {help added line options:lines} and 
{help added text options:text}, {help region options:regions}, 
{help name option:name}, {help aspect option:aspect ratio}, etc.{p_end}

{syntab :Histogram}
{synopt :{opth hist:ogram(varlist)}}plot a histogram for each of the selected
variables (max = 2){p_end}
{synopt :{opt xm:in(value)}}set the base position of the {it:y} histogram in
terms of the {it:x} axis; only
allowed with {opt histogram()}{p_end}
{synopt :{opt ym:in(value)}}set the base position of the {it:x} histogram in
terms of the {it:y} axis; only
allowed with {opt histogram()}{p_end}
{synopt :{opt xhistbarheight(value)}}set the height of the {it:x} histogram as
a percentage; default is {cmd:xhistbarheight(10)}{p_end}
{synopt :{opt yhistbarheight(value)}}set the height of the {it:y} histogram as
a percentage; default is {cmd:yhistbarheight(10)}{p_end}
{synopt :{opt xhistbarwidth(value)}}set the width of the {it:x} histogram as a
percentage; default is {cmd:xhistbarwidth(100)}{p_end}
{synopt :{opt yhistbarwidth(value)}}set the width of the {it:y} histogram as a
percentage; default is {cmd:yhistbarwidth(100)}{p_end}
{synopt :{opt xhistbins(#)}}set the number of bins to be created; default
is {cmd:xhistbins(20)}{p_end}
{synopt :{opt yhistbins(#)}}set the number of bins to be created; default
is {cmd:yhistbins(20)}{p_end}

{phang}
The following options require the {it:axis} to be specified as {cmd:x} or
{cmd:y}, for example, {cmd:xcolor()} or {cmd:ylpattern()}.

{synopt :{it:axis}{opth color(colorstyle)}}set the outline and fill color and
opacity; defaults are {cmd:xcolor(teal%50)} and
{cmd:ycolor(maroon%50)}{p_end}
{synopt :{it:axis}{opth fcolor(colorstyle)}}set the fill color and
opacity{p_end}
{synopt :{it:axis}{opth fintensity(intensitystyle)}}set the fill
intensity{p_end}
{synopt :{it:axis}{opth lcolor(colorstyle)}}set the outline color and
opacity{p_end}
{synopt :{it:axis}{opth lwidth(linewidthstyle)}}set the thickness of
outline{p_end}
{synopt :{it:axis}{opth lpattern(linepatternstyle)}}set the outline pattern
(solid, dashed, etc.){p_end}
{synopt :{it:axis}{opth lalign(linealignmentstyle)}}set the outline alignment
(inside, outside, or center){p_end}
{synopt :{it:axis}{opth lstyle(linestyle)}}set the overall look of
the outline{p_end}
{synopt :{it:axis}{opth bstyle(areastyle)}}set the overall look of the bars,
all settings above{p_end}
{synopt :{it:axis}{opth pstyle(pstyle)}}set the overall plot style, including
area style{p_end}

{syntab :Save output}
{synopt :{opt savegraph(filename)}}save the graph to a file; the format is
automatically detected from the extension and either {cmd: graph save} or
{cmd:graph export} is run; by default, {cmd:.gph} is assumed{p_end}
{synopt :{opt savedata(filename)}}save {it:filename}{cmd:.csv} containing
scatter point data and {it:filename}{cmd:.do} to process the data into a
graph{p_end}
{synopt :{opt replace}}specify that files be overwritten if they already
exist{p_end}

{syntab :fastxtile options}
{synopt :{opt nofastxtile}}force the use of {cmd:xtile} instead of
{cmd:fastxtile} to compute bins{p_end}
{synopt :{opth randvar(varname)}}request that {it:varname} be used to select a
sample of observations when computing the quantile boundaries{p_end}
{synopt :{opt randcut(#)}}specify the upper bound on the variable contained in
{cmd:randvar()}; default is {cmd:randcut(1)}; may not
be combined with {opt randn()}{p_end}
{synopt :{opt randn(#)}}specify an approximate number of observations to sample
when computing the quantile boundaries; may not be combined with
{opt randcut()}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed; see {help weight}.
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:binscatterhist} generates binned scatterplots, with the option to plot the
variables' underlying distribution and report estimation results.

{pstd}
Binned scatterplots provide a nonparametric way of visualizing the
relationship between two variables.  {cmd:binscatterhist} adds several
features to the popular community-contributed command used to produce such
scatterplots, {cmd:binscatter} (Stepner 2013).  {cmd:binscatterhist} uses, by
default, {cmd:reghdfe} (Correia 2014) to calculate residuals, therefore
allowing for multiple fixed effects, but keeps {cmd:areg} as an alternative
option.  {cmd:binscatterhist} additionally allows the creation of histograms
of the scattered variables to include them in the graph for a more complete
representation of the data.  Finally, it allows for automatic reporting of the
slope and standard error of the fitted line, with options for robust and
clustered standard errors.  As with {cmd:binscatter}, {cmd:binscatterhist}
solves the problem of scatterplots with a large number of observations: it
groups the {it:x}-axis variable into equal-sized bins, computes the mean of
the {it:x}-axis and {it:y}-axis variables within each bin, and then creates a
scatterplot of these data points.

{pstd}
{opt binscatterhist} keeps, as a base, the same options as {cmd:binscatter}.
It provides built-in options to control for covariates before plotting the
relationship (see {help binscatterhist##controls:{it:Controls}}), will plot fit
lines based on the underlying data, and can automatically handle regression
discontinuities (see {help binscatterhist##fit_line:{it:Fit line}}).


{marker options}{...}
{title:Options}

{dlgtab:Main}

{marker by_notes}{...}
{phang}
{opth by(varname)} plots a separate series for each by-value.  Both numeric
and string by-variables are supported, but numeric by-variables will have
faster run times.

{pmore}
There are two ways in which {cmd:binscatterhist} does not
condition on by-values:

{p 8 11 2}
1. When combined with {opt controls()} or {opt absorb()}, the command
residualizes using the restricted model in which each covariate has the same
coefficient in each by-value sample.  It does not run separate regressions for
each by-value.  If you wish to control for covariates by using a different
model, you can residualize your {it:x} and {it:y} variables beforehand with
your desired model and then run {cmd:binscatterhist} on the residuals you
constructed.

{p 8 11 2}
2. When not combined with {opt discrete} or {opt xq()}, the command constructs
a single set of bins using the unconditional quantiles of the {it:x} variable.
It does not bin the {it:x} variable separately for each by-value.  If you wish
to use a different binning procedure (such as constructing equal-sized bins
separately for each by-value), you can construct a variable containing your
desired bins beforehand and then run {cmd:binscatterhist} with {opt xq()}.

{phang}
{opt medians} creates the binned scatterplot using the median {it:x} and
{it:y} values within each bin rather than the mean.  This option only affects
the scatter points; it does not, for instance, cause {cmd:linetype(lfit)} to
use quantile regression instead of ordinary least squares when drawing a fit
line.

{dlgtab:Bins}

{phang}
{opt nquantiles(#)} specifies the number of equal-sized bins to be created.
This is equivalent to the number of points in each series.  The default is
{cmd: nquantiles(20)}.  If the {it:x} variable has fewer unique values than
the number of bins specified, then {opt discrete} will be automatically
invoked, and no binning will be performed.  {opt nquantiles()} may not be
combined with {opt discrete} or {opt xq()}.

{pmore}
Binning is performed after residualization when combined with {opt controls()}
or {opt absorb()}.  Note that the binning procedure is equivalent to running
Stata's {cmd:xtile} command, which in certain cases will generate fewer
quantile categories than specified.  (For example, {bf:{stata sysuse auto}};
{bf:{stata xtile temp = mpg, nq(20)}}; and {bf:{stata tab temp}}.)

{phang}
{opth genxq(varname)} creates a categorical variable containing the computed
bins.  {opt genxq()} may not be combined with {opt discrete} or {opt xq()}.

{phang}
{opt discrete} specifies that the {it:x} variable is discrete and that each
{it:x} value be treated as a separate bin.  {cmd:binscatterhist} will
therefore plot the mean {it:y} value associated with each {it:x} value.
{cmd:discrete} may not be combined with {opt nquantiles()}, {opt genxq()}, or
{opt xq()}.

{pmore}
In most cases, {opt discrete} should not be combined with {opt controls()} or
{opt absorb()}, because residualization occurs before binning and, in general,
the residual of a discrete variable will not be discrete.

{phang}
{opth xq(varname)} specifies a categorical variable that contains the bins to
be used instead of having {cmd:binscatterhist} generate them.  This option is
typically used to avoid recomputing the bins needlessly when
{cmd:binscatterhist} is being run repeatedly on the same sample and with the
same {it:x} variable.  It may be convenient to use {cmd:genxq()} in the first
iteration and specify {cmd:xq()} in subsequent iterations.  Computing
quantiles is computationally intensive in large datasets, so avoiding
repetition can reduce run times considerably.  {opt xq()} may not be combined
with {opt nquantiles()}, {opt genxq()}, or {opt discrete}.

{pmore}
Take care when combining {opt xq()} with {opt controls()} or {opt absorb()}.
Binning takes place after residualization, so if the sample or the control
variables change, the bins should be recomputed as well.

{marker residuals}{...}
{dlgtab:Residuals computation}

{phang}
{opt regtype(string)} specifies the type of regression to use to compute the
residuals.  {it:string} may be {cmd:regtype(reghdfe)} or {cmd:regtype(areg)}.
{cmd:regtype()} requires {cmd:absorb()} to be specified.  When {cmd:reghdfe}
is specified, {cmd:absorb()} allows for more than one {it:varname}; however,
interactions are not allowed, including tricks like, for example,
{cmd:one##control}, to include controls in the absorb.  Such controls must be
included in the {opt controls()} option.  {cmd:reghdfe} drops singleton
observations with regard to the included fixed effects; therefore, sample size
might differ between {cmd:reghdfe} and {cmd:areg}.  The default is
{cmd:regtype(reghdfe)}.

{marker se/robust}{...}
{dlgtab:Standard errors/robust}

{phang}
{opth cluster(varname)} specifies the variable that identifies clusters.
Clustered standard errors affect both the sample for residualization and the
computation of standard errors for slope reporting.

{phang}
{cmd:vce(robust)} specifies to calculate robust standard errors, which affect
both the sample for residualization and the computation of standard errors for
slope reporting.

{marker controls}{...}
{dlgtab:Controls}

{phang}
{opth controls(varlist)} residualizes the {it:x} and {it:y} variables on the
specified controls before binning and plotting.  To do so,
{cmd:binscatterhist} runs a regression of each variable on the controls,
generates the residuals, and adds the sample mean of each variable back to its
residuals.

{phang}
{opth absorb(varlist)} absorbs fixed effects in the categorical variable from
the {it:x} and {it:y} variables before binning and plotting.  To do so,
{cmd:binscatterhist} runs an {helpb areg} of each variable with {opt absorb()}
and any {opt controls()} specified.  It then generates the residuals and adds
the sample mean of each variable back to its residuals.

{phang}
{opt noaddmean} prevents the sample mean of each variable from being added
back to its residuals when combined with {opt controls()} or {opt absorb()}.

{marker fit_line}{...}
{dlgtab:Fit line}

{marker linetype}{...}
{phang}
{opt linetype(string)} specifies the type of line plotted on each series.  The
default is {cmd:linetype(lfit)}, which plots a linear fit line.  Other options
are {cmd:linetype(qfit)} for a quadratic fit line, {cmd:linetype(connect)} for
connected points, and {cmd:linetype(none)} for no line.

{pmore}
Linear or quadratic fit lines are estimated using the underlying data, not the
binned scatter points.  When combined with {opt controls()} or {opt absorb()},
the fit line is estimated after the variables have been residualized.

{phang}
{opth rd(numlist)} draws a dashed vertical line at the specified {it:x} values
and generates regression discontinuities when combined with
{cmd:linetype(lfit)} or {cmd:linetype(qfit)}.  Separate fit lines will be
estimated below and above each discontinuity.  These estimations are performed
using the underlying data, not the binned scatter points.

{pmore}
The regression discontinuities do not affect the binned scatter points in any
way.  Specifically, a bin may contain a discontinuity within its range and,
therefore, may include data from both sides of the discontinuity.

{phang}
{opt reportreg} displays in the Results window the regressions used to
estimate the fit lines.

{marker chef}{...}
{dlgtab:Coefficient and sample reporting}

{phang}
{opt coefficient(#)} reports the slope of the fitted line with its standard
error, rounded at {it:#} using {cmd:round(coefficient,} {it:#}{cmd:)}.  See
{helpb f_round:round()}.

{phang}
{opt ci(#)} reports the {it:#}% confidence interval, rounded as the
{cmd:coefficient()}.

{phang}
{opt pvalue} reports the {it:p}-value of the regression on residualized
variables.

{phang}
{opt sample} reports the sample size of the regression on residualized
variables.

{phang}
{opt stars(string)} reports the {it:p}-value using stars.  {it:string} may be
{cmd:nostars}, {cmd:1} (*5% **1%), {cmd:2} (+10% *5% **1%), {cmd:3} (+10% *5%
**1% ***0.1%), or {cmd:4} (*5% **1% ***0.1%).  The default is {cmd:stars(1)}.


{dlgtab:Graph style}

{phang}
{cmdab:colors(}{it:{help colorstyle}}{cmd:)} specifies an ordered list of
colors for each series.

{phang}
{cmdab:mcolors(}{it:{help colorstyle}}{cmd:)} specifies an ordered list of
colors for the markers of each series, which overrides any list provided in
{opt colors()}.

{phang}
{cmdab:lcolors(}{it:{help colorstyle}}{cmd:)} specifies an ordered list of
colors for the lines of each series, which overrides any list provided in 
{opt colors()}.

{phang}
{cmdab:msymbols(}{it:{help symbolstyle}}{cmd:)} specifies an ordered list of
symbols for each series.

{phang}
{it:{help twoway_options}} controls the graph 
{help title options:titles}, {help legend option:legends}, 
{help axis options:axes}, added {help added line options:lines} and 
{help added text options:text}, {help region options:regions}, 
{help name option:name}, {help aspect option:aspect ratio}, etc.

{dlgtab:Histogram}

{phang}
{opt histogram(varlist)} plots a histogram for each of the selected variables
(max = 2).  Selected variables have to be the scattered ones.

{phang}
{opt xmin(value)} sets the base position of the {it:y} histogram in terms of
the {it:x} axis.  Option {opt xmin()} is only allowed with {opt histogram()}.

{phang}
{opt ymin(value)} sets the base position of the {it:x} histogram in terms of
the {it:y} axis.  Option {opt ymin()} is only allowed with {opt histogram()}.

{phang}
{opt xhistbarheight(value)} sets the height of the {it:x} histogram as a
percentage.  The default is {cmd:xhistbarheight(10)}.

{phang}
{opt yhistbarheight(value)} sets the height of the {it:y} histogram as a
percentage.  The default is {cmd:yhistbarheight(10)}.

{phang}
{opt xhistbarwidth(value)} sets the width of the {it:x} histogram as a
percentage.  The default is {cmd:xhistbarwidth(100)}.

{phang}
{opt yhistbarwidth(value)} sets the width of the {it:y} histogram as a
percentage.  The default is {cmd:yhistbarwidth(100)}.

{phang}
{opt xhistbins(#)} sets the number of bins to be created in the {it:x}
histogram.  The default is {cmd:xhistbins(20)}.

{phang}
{opt yhistbins(#)} sets the number of bins to be created in the {it:y}
histogram.  The default is {cmd:yhistbins(20)}.


{phang}
The following options require the {it:axis} to be specified as {cmd:x} or
{cmd:y}, for example, {cmd:xcolor()} or {cmd:ylpattern()}.

{phang}
{it:axis}{opth color(colorstyle)} sets the outline and fill color and opacity.
The defaults are {cmd:xcolor(teal%50)} and {cmd:ycolor(maroon%50)}.{p_end}

{phang}
{it:axis}{opth fcolor(colorstyle)} sets the fill color and opacity.

{phang}
{it:axis}{opth fintensity(intensitystyle)} sets the fill intensity.

{phang}
{it:axis}{opth lcolor(colorstyle)} sets the outline color and opacity.

{phang}
{it:axis}{opth lwidth(linewidthstyle)} sets the thickness of the outline.

{phang}
{it:axis}{opth lpattern(linepatternstyle)} sets the outline pattern (solid,
dashed, etc.).

{phang}
{it:axis}{opth lalign(linealignmentstyle)} sets the outline alignment (inside,
outside, or center).

{phang}
{it:axis}{opth lstyle(linestyle)} sets the overall look of the outline.

{phang}
{it:axis}{opth bstyle(areastyle)} sets the overall look of the bars, all
settings above.

{phang}
{it:axis}{opth pstyle(pstyle)} sets the overall plot style, including
area style.


{dlgtab:Save output}

{phang}
{opt savegraph(filename)} saves the graph to a file.  The format is
automatically detected from the extension (for example, {cmd:.gph},
{cmd:.jpg}, or {cmd:.png}), and either {cmd:graph save} or {cmd:graph export}
is run.  By default, {cmd:.gph} is assumed.

{phang}
{opt savedata(filename)} saves {it:filename}{cmd:.csv} containing scatter
point data and {it:filename}{cmd:.do} to process the data into a graph.

{phang}
{opt replace} specifies that files be overwritten if they already exist.

{dlgtab:fastxtile options}

{phang}
{opt nofastxtile} forces the use of {cmd:xtile} instead of {cmd:fastxtile} to
compute bins.  There is no situation where this should be necessary or useful.
The {cmd:fastxtile} command generates identical results to {cmd:xtile} but
runs faster on large datasets and has additional options for random sampling
that may be useful to increase speed.

{pmore}
{cmd:fastxtile} is built into the {cmd:binscatterhist} code but may also be
installed separately for use outside of {cmd:binscatterhist}.  It is available from the Statistical Software Components Archive
({stata ssc install fastxtile:click here to install}). 

{phang}
{opth randvar(varname)} requests that {it:varname} be used to select a sample
of observations when computing the quantile boundaries.  Sampling increases
the speed of the binning procedure but generates bins that, because of
sampling error, are only approximately equal sized.  It is possible to omit
this option and still perform random sampling from {it:U}[0,1], as described
below in {opt randcut()} and {opt randn()}.

{phang}
{opt randcut(#)} specifies the upper bound on the variable contained in
{cmd:randvar()}.  Quantile boundaries are approximated using observations for
which {opt randvar()} <= {it:#}.  If no variable is specified in
{cmd:randvar()}, a standard uniform random variable is generated.  The default
is {cmd:randcut(1)}.  {opt randcut()} may not be combined with {opt randn()}.

{phang}
{opt randn(#)} specifies an approximate number of observations to sample when
computing the quantile boundaries.  Quantile boundaries are approximated using
observations for which a uniform random variable is <= {it:#}/{it:N}.  The
exact number of observations sampled may therefore differ from {it:#}, but it
equals {it:#} in expectation.  When this option is combined with
{cmd:randvar()}, {it:{help varname}} should be distributed {it:U}[0,1].
Otherwise, a standard uniform random variable is generated.  {opt randn()} may
not be combined with {opt randcut()}.


{marker examples1}{...}
{title:Examples of main features (Stepner 2013)}

{pstd}
Load the 1988 extract of the National Longitudinal Survey of Young Women and
Mature Women{p_end}
{phang2} {cmd:. sysuse nlsw88}{p_end}
{phang2} {cmd:. keep if inrange(age, 35, 44) & inrange(race, 1, 2)}{p_end}

{pstd}
What is the relationship between job tenure and wages?{p_end}
{phang2} {cmd:. scatter wage tenure}{p_end}
{phang2} {cmd:. binscatterhist wage tenure}{p_end}

{pstd}
The scatter was too crowded to be easily interpretable.  {cmd:binscatterhist}
is cleaner, but a linear fit looks unreasonable.{p_end}

{pstd}
Try a quadratic fit{p_end}
{phang2} {cmd:. binscatterhist wage tenure, linetype(qfit)}{p_end}

{pstd}
We can also plot a linear regression discontinuity{p_end}
{phang2} {cmd:. binscatterhist wage tenure, rd(2.5)}{p_end}

{pstd}
What is the relationship between age and wages?{p_end}
{phang2} {cmd:. scatter wage age}{p_end}
{phang2} {cmd:. binscatterhist wage age}{p_end}

{pstd}
{cmd:binscatterhist} is again much easier to interpret.  (Note that, because
there are fewer than 20 unique values, {cmd:binscatterhist} automatically used
each age as a discrete bin.){p_end}

{pstd}
How does the relationship vary by race?{p_end}
{phang2} {cmd:. binscatterhist wage age, by(race)}{p_end}

{pstd}
The relationship between age and wages is very different for Whites and
Blacks; but what if we control for occupation?{p_end}
{phang2} {cmd:. binscatterhist wage age, by(race) absorb(occupation)}{p_end}

{pstd}
A very different picture emerges, and we can label this graph nicely{p_end}
{phang2}{cmd:. binscatterhist wage age, by(race) absorb(occupation) msymbols(O T) xtitle(Age) ytitle(Hourly Wage) legend(lab(1 White) lab(2 Black))}{p_end}


{marker examples2}{...}
{title:Examples of histogram features}

{pstd}
Load the National Longitudinal Survey of Women 1988{p_end}
{phang2} {cmd:. webuse nlsw88, clear}{p_end}

{pstd}
The basic {cmd:binscatterhist} works exactly like {cmd:binscatter}{p_end}
{phang2} {cmd:. binscatterhist wage tenure}{p_end}

{pstd}
Let's add the distribution of the {it:x} variable tenure{p_end}
{phang2} {cmd:. binscatterhist wage tenure, histogram(tenure)}{p_end}

{pstd}
The default position of the {it:x} graph is not pleasant; let's fix that
and add both variables' distribution this time{p_end}
{phang2} {cmd:. binscatterhist wage tenure, histogram(wage tenure) ymin(4)}{p_end}

{pstd}
Let's try a simpler look and a smaller width{p_end}
{phang2} {cmd:. binscatterhist wage tenure, histogram(wage tenure) ymin(4) yhistbarwidth(50) xhistbarwidth(50) ybstyle(outline) xbstyle(outline)}{p_end}

{pstd}
Let's now try some further options: increasing number of bins and height of
the {it:x} and {it:y} distribution{p_end}
{phang2} {cmd:. binscatterhist wage tenure, histogram(wage tenure) ymin(4) xhistbarheight(15) yhistbarheight(15) xhistbins(40) yhistbins(40)}{p_end}


{marker examples3}{...}
{title:Examples of further features}

{pstd}
Let's report the estimation results using robust standard errors and with
grade fixed effects{p_end}
{phang2} {cmd:. binscatterhist wage tenure, absorb(grade) vce(robust) coefficient(0.01) sample xmin(-2.2) ymin(5) histogram(wage tenure)  xhistbarheight(15) yhistbarheight(15) xhistbins(40) yhistbins(40)}{p_end}

{pstd}
Let's use now {opt areg}, therefore keeping singleton fixed effects.  With a
negative slope, the reported coefficient and sample automatically adjust their
position.  We further report 95% confidence interval and {it:p}-value.{p_end}
{phang2} {cmd:. replace tenure = -abs(tenure)}{p_end}
{phang2} {cmd:. binscatterhist wage tenure, regtype(areg) absorb(grade) vce(robust) coefficient(0.01) ci(95) pvalue sample xmin(-22) ymin(5) histogram(wage tenure)  xhistbarheight(15) yhistbarheight(15) xhistbins(40) yhistbins(40)}{p_end}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:binscatterhist} stores in {cmd:e()} the results from {opt reg} and
{cmd:areg}.  {cmd:binscatterhist} stores the following results in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(graphcmd)}}{cmd:twoway} command used to generate graph, which
does not depend on loaded data (note: reference this
result using {cmd:e(graphcmd)} rather than {cmd:r(graphcmd)} to avoid
truncation due to Stata's character limit for strings)

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(byvalues)}}ordered list of by-values (if numeric by-variable
specified){p_end}
{synopt:{cmd:r(rdintervals)}}ordered list of {opt rd()} intervals (if 
{opt rd()} specified){p_end}
{synopt:{cmd:r(y}{it:#}{cmd:_coefs)}}fit line coefficients for {it:#}th {it:y}
variable (if {cmd:linetype(lfit)} or {cmd:linetype(qfit)} specified){p_end}
{p2colreset}{...}


{marker acknowledgments}{...}
{title:Acknowledgments}

{pstd}
The author would like to thank Elliott Ash, Christopher Baum, Suresh Naidu,
Sergio Galletta, Malka Guillot, and an anonymous referee for useful feedback
on the command.

{pstd}
The present version of {cmd:binscatterhist} is based on a command in Stepner
(2013) and Jann (2014).


{marker refs}{...}
{title:References}

{phang}
Correia, S.  2014.
reghdfe: Stata module to perform linear or instrumental-variable regression absorbing any number of high-dimensional fixed effects.
Statistical Software Components S457874,
Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s457874.html"}.{p_end}

{phang}
Jann, B.  2014.
addplot: Stata module to add twoway plot objects to an existing twoway graph.
Statistical Software Components S457917,
Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s457917.html"}.{p_end}

{phang}
Stepner, M.  2013.
binscatter: Stata module to generate binned scatterplots.
Statistical Software Components S457709, 
Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s457709.html"}.{p_end}


{marker author}{...}
{title:Author}

{pstd}Matteo Pinna{p_end}
{pstd}Center for Law and Economics{p_end}
{pstd}ETH Zurich{p_end}
{pstd}Zurich, Switzerland{p_end}
{pstd}matteo.pinna@gess.ethz.ch{p_end}


{marker alsosee}{...}
{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 22, number 2: {browse "https://doi.org/10.1177/1536867X221106418":gr0091}{p_end}

{p 7 14 2}
Help:  
{helpb addplot},
{helpb reghdfe} (if installed){p_end}
