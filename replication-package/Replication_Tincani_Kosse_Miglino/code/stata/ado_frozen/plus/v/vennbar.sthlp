{smcl}
{* 30nov2022/10dec2022/30dec2022/3jan2023/9jan2023/2apr2023/16jul2023/28aug2023/3sep2023/30nov2023}{...}
{cmd:help vennbar}{right: ({browse "https://doi.org/10.1177/1536867X241258010":SJ24-2: gr0095})}
{hline}

{marker title}{...}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{cmd:vennbar} {hline 2}}Euler or Venn diagrams mapped to bar or dot
charts{p_end}


{title:Syntax}

{p 8 15 2}
{cmd:vennbar}
{it:varlist}
{ifin}
{weight}
[{cmd:,}
{opt fillin}
{opt percent}
{opt frformat(str)}
{opt pcformat(str)}
{opt varlabels}
{opt vallabels}
{opt sep:arator(str)}
{opt recast(subcmd)}
{it:graph_options}
{opt savedata(filespec)}]

{p 4 4 2}{cmd:fweight}s and {cmd:aweight}s are allowed; see {help weight}.


{title:Description}

{p 4 4 2}
{cmd:vennbar} produces bar or dot chart alternatives to Euler or Venn diagrams
showing the frequencies (meaning generally, abundances) of subsets of
observations as defined jointly by a bundle of numeric indicator variables.

{p 4 4 2}
The order of variables presented to {cmd:vennbar} does not determine the order
in which they are shown in a plot.  By default, bars or dotted lines are shown
in order of subset frequency, but choosing a more suitable order is the user's
prerogative.  There is considerable scope to change that sort order using
other criteria.

{p 4 4 2}
Commonly, but not necessarily, subset frequencies (abundances) are already in
a variable in the dataset.  If so, that variable should be specified as
frequency or analytic weights.  If no weights are specified, {cmd:vennbar}
counts observations for you.  Either way, note that the focus of this command
is on displaying frequencies and not on the particular values in each subset.

{p 4 4 2}
The display by default uses {helpb graph hbar} but may optionally be recast as
using {helpb graph bar} (which is not usually advised) or as using
{helpb graph dot} (which may appeal).  The choice is a matter of personal
taste, although horizontal displays generally make it easier to show and read
values or labels of subsets.

{p 4 4 2}
The reduced dataset used by {cmd:vennbar} may be saved for future work using
the {cmd:savedata()} option.  This dataset may be as useful as or more useful
than the plot.  Saving results allows greater flexibility in plotting.
Tabulation or other reporting is also made easier.  Results often need to be
scaled in some way, for example, by looking at conditional proportions or
percents.  (Optionally, percents can be saved too.)

{p 4 4 2}
The variables in such a reduced dataset are the original indicator variables
and as follows.  The names here may thus not be used as names for the
indicator variables specified.

{phang2}
{cmd:_binary} is a string variable containing a binary code such as
{cmd:"00"}, {cmd:"01"}, {cmd:"10"}, or {cmd:"11"}.

{phang2}
{cmd:_decimal} is a numeric variable containing a decimal equivalent such as
{cmd:0}, {cmd:1}, {cmd:2}, or {cmd:3}.

{phang2}
{cmd:_text} is a string variable containing a description of each subset using
variable names, variable labels, or value labels.  The text {cmd:"<none>"} is
reported for any subset that would otherwise have empty text.

{phang2}
{cmd:_freq} is a numeric variable containing the frequency of occurrence of
each subset.  If analytic weights were specified, values may have fractional
parts.  Otherwise values will be integer counts.

{phang2}
(Optionally) {cmd:_percent} is a numeric variable containing the percent
occurrence of each subset.

{phang2}
{cmd:_degree} is a numeric variable indicating the degree of each subset
(number of participating sets) counted as true (1) according to each indicator
variable.

{phang2}
{cmd:_set} is a string variable that indicates each set using its variable
name or optionally its variable label.

{phang2}
{cmd:_setfreq} is a numeric variable that indicates the frequency of each set.

{phang2}
{cmd:_set} and {cmd:_setfreq} are physically but not logically aligned with
the other variables mentioned above.

{pmore}
Allenby and Slomson (2011, 14) comment: "There is, unfortunately, no standard
notation for the number of elements in a set."  They could have added "and no
standard term either."  Terms encountered (other than "number of elements")
include "cardinality", "order", "potency", "power", and the homely "size".
See annotations of several references.

{p 4 4 2}
More detailed remarks, including many further references, follow later in this
help.


{title:Options}

{dlgtab:What to show}

{phang}
{cmd:fillin} insists on showing subsets that do not occur with their frequency
zero.  This can be helpful if there are only a few such subsets, but it is not
usually helpful otherwise.

{phang}
{cmd:percent} specifies listing and plotting of percents rather than
frequencies.

{phang}
{opt frformat(str)} specifies a display format for frequencies in listings.
This option may be appropriate if any frequencies include fractional parts.
If you wish to specify a format to {cmd:blabel()}, you should do so directly;
see {it:{help blabel_option}}

{phang}
{opt pcformat(str)} specifies a display format for percents in listings.  The
default is {cmd:pcformat(%2.1f)}.  This option has no effect without
{cmd:percent}.  If you wish to specify a format to {cmd:blabel()}, you should
do so directly: see {it:{help blabel_option}}.


{dlgtab:Detail of display}

{phang}
{cmd:varlabels} specifies use of variable labels to describe each subset.  The
default is to use variable names.  In either case, only variables taking on
value 1 in each subset are named or labeled.  If a variable label has not been
defined, the variable name is used instead.

{phang}
{cmd:vallabels} specifies use of value labels to describe each subset.  If
value labels are not defined, values 0 or 1 will be used instead.  With this
option, subsets defined by values 0 or 1 will always be labeled somehow.  This
option may be useful when 0 and 1 represent values that are both of direct
interest, such as alive and dead, wet and dry, or female and male.

{phang}
{opt separator(str)} specifies a string to separate variable names or, as
above, variable or value labels in display of subsets.  The default is
{cmd:", "}, a comma followed by a space.  Hint: The intersection symbol  can be
obtained using SMCL's {cmd:"{c -(}&cap{c )-}"} or Unicode character (U+2229)
through {cmd:uchar(2229)}.  The SMCL notation will be interpreted on graphs
but will appear uninterpreted in data listings.  The Unicode character should
be interpreted in both.

{phang}
{opt recast(subcmd)} specifies a subcommand of {helpb graph}, either {cmd:bar}
or {cmd:dot}, as an alternative to the default {cmd:hbar}.  Note: This option
name is inspired by the {cmd:recast()} option of {helpb twoway} but is not
that option.  If you wish to use {cmd:twoway} instead, specify the
{cmd:savedata()} option, and fire up {cmd:twoway} directly on the results
dataset.

{phang}
{it:graph_options} refer to other options of {helpb graph hbar},
{helpb graph bar}, or {helpb graph dot}.  Because the plot here has table
flavor, some of the ideas covered by Cox (2008, 2012) may be helpful.  Note
that {cmd:graph} may not be especially smart about any space needed above the
highest bar label, so you may need two passes and a call to {cmd:yscale()} to
extend the axis.

{pmore}
The default is {cmd:over(_text, sort(_freq) descending) blabel(bar)}.
Otherwise, options may refer to variables included in the reduced dataset as
defined above, which could be any of the following:

{pmore}
{cmd:_binary}{break}
{cmd:_decimal}{break}
{cmd:_text}{break}
{cmd:_freq}{break}
{cmd:_percent} (if specified){break}
{cmd:_degree}

{pmore}
Note that any other {cmd:over()} option overrides this default.  Thus, if you
want that default and other choices too, you must spell out all your choices.

{pmore}
Using one or more {cmd:over()} options is often the key to a successful plot.
If these options are unfamiliar to you, do study the examples, and check out
{helpb graph hbar} for its syntax, its suboptions, and the linked {cmd:nofill}
option.


{dlgtab:Saving results as new dataset}

{phang}
{opt savedata(filespec)} specifies a (filepath and) filename for saving
results to a new dataset.  The specification may include {cmd:, replace} --
which is needed to replace any existing dataset with the same path and name.


{title:Examples}

{p 4 8 2}{cmd:. local bcolor bar(1, fcolor(blue*0.3) lcolor(blue))}{p_end}
{p 4 8 2}{cmd:. set more off}{p_end}
{p 4 8 2}{cmd:. set scheme s1color}{p_end}

{p 4 8 2}{cmd:. * Example 1}{p_end}
{p 4 8 2}{cmd:. * Schnable et al. (2009) counts of gene families}{p_end}

{p 4 8 2}{cmd:. clear}{p_end}
{p 4 8 2}{cmd:. input Rice Maize Sorghum Arabidopsis freq}{p_end}
{p 4 8 2}{cmd:1 0 0 0 1110}{p_end}
{p 4 8 2}{cmd:1 1 0 0 229}{p_end}
{p 4 8 2}{cmd:0 1 0 0 465}{p_end}
{p 4 8 2}{cmd:1 0 1 0 661}{p_end}
{p 4 8 2}{cmd:1 1 1 0 2077}{p_end}
{p 4 8 2}{cmd:0 1 1 0 405}{p_end}
{p 4 8 2}{cmd:0 0 1 0 265}{p_end}
{p 4 8 2}{cmd:1 0 1 1 304}{p_end}
{p 4 8 2}{cmd:1 1 1 1 8494}{p_end}
{p 4 8 2}{cmd:0 1 1 1 112}{p_end}
{p 4 8 2}{cmd:0 0 1 1 34}{p_end}
{p 4 8 2}{cmd:1 0 0 1 81}{p_end}
{p 4 8 2}{cmd:1 1 0 1 96}{p_end}
{p 4 8 2}{cmd:0 1 0 1 11}{p_end}
{p 4 8 2}{cmd:0 0 0 1 1058}{p_end}
{p 4 8 2}{cmd:end}{p_end}

{p 4 8 2}{cmd:. label variable Arabidopsis "{c -(}it:Arabidopsis{c )-}"}{p_end}
{p 4 8 2}{cmd:. local toptitle  "t1title(Number of gene families)"}{p_end}

{p 4 8 2}{cmd:. tempfile schnable}{p_end}

{p 4 8 2}{cmd:. vennbar Arabidopsis Rice Maize Sorghum [fw=freq], `bcolor' `toptitle' varlabels ysc(alt) ysc(r(. 9200)) savedata("`schnable'", replace) name(VB1, replace)}{p_end}

{p 4 8 2}{cmd:. vennbar Arabidopsis Rice Maize Sorghum [fw=freq], `bcolor' `toptitle' varlabels over(_text, sort(_decimal) descending) over(_degree) nofill ysc(alt) ysc(r(. 9200)) name(VB2, replace)}{p_end}

{p 4 8 2}{cmd:. vennbar Arabidopsis Rice Maize Sorghum [fw=freq], `toptitle'  varlabels sep("; ") marker(1, mcolor(blue)) ysc(r(0 10000)) recast(dot) linetype(line) lines(lc(gs8) lw(thin)) name(VB3, replace)}{p_end}

{p 4 8 2}{cmd:. vennbar Arabidopsis Rice Maize Sorghum [fw=freq], over(_degree, descending) over(_text, sort(_freq) descending) nofill `bcolor' `toptitle' ysc(alt) name(VB4, replace)}{p_end}

{p 4 8 2}{cmd:. vennbar Arabidopsis Rice Maize Sorghum [fw=freq],  over(_text, sort(_freq) descending) over(_degree, descending) nofill `bcolor' `toptitle' ysc(alt range(. 9200)) name(VB5, replace)}{p_end}

{p 4 8 2}{cmd:. use "`schnable'", clear}{p_end}

{p 4 8 2}{cmd:. graph hbar (asis) _setfreq, over(_set, sort(1)) bar(1, lcolor(blue) fcolor(blue*0.3)) blabel(bar) ysc(off) `toptitle' name(VB6, replace)}{p_end}

{p 4 8 2}{cmd:. summarize _freq, meanonly}{p_end}
{p 4 8 2}{cmd:. local N = r(sum)}{p_end}

{p 4 8 2}{cmd:. * null model, with observed probabilities of being A R M S}{p_end}
{p 4 8 2}{cmd:. generate double _expected = `N'}{p_end}

{p 4 8 2}{cmd:. quietly {c -(}}{p_end}

{p 4 8 2}{cmd:. foreach v in Arabidopsis Rice Maize Sorghum {c -(}}{p_end}
{p 4 8 2}{cmd:. 	* the mean of an indicator is a probability}{p_end}
{p 4 8 2}{cmd:. 	summarize `v' [fw=_freq], meanonly}{p_end}
{p 4 8 2}{cmd:. 	replace _expected = _expected * cond(`v' == 1, r(mean), 1 - r(mean))}{p_end}
{p 4 8 2}{cmd:. {c )-}}{p_end}

{p 4 8 2}{cmd:. * adjust for data not including any 0 0 0 0}{p_end}
{p 4 8 2}{cmd:. summarize _expected, meanonly}{p_end}
{p 4 8 2}{cmd:. replace _expected = `N' * _expected / r(sum)}{p_end}

{p 4 8 2}{cmd:. {c )-}}{p_end}

{p 4 8 2}{cmd:. * Pearson residuals for null model}{p_end}
{p 4 8 2}{cmd:. generate _Pearson = (_freq - _expected) / sqrt(_expected)}{p_end}

{p 4 8 2}{cmd:. graph hbar (asis) _Pearson, over(_text, sort(decimal)) `bcolor' ysc(alt) ytitle(Pearson residuals from null model) name(VB7, replace)}{p_end}

{p 4 8 2}{cmd:. * Example 2}{p_end}
{p 4 8 2}{cmd:. * incidence of missing values in nlswork.dta}{p_end}

{p 4 8 2}{cmd:. webuse nlswork, clear}{p_end}

{p 4 8 2}{cmd:. * missings from Stata Journal: search dm0085, entry}{p_end}
{p 4 8 2}{cmd:. capture noisily missings report}{p_end}

{p 4 8 2}{cmd:. foreach v in ind_code union wks_ue tenure wks_work {c -(}}{p_end}
{p 4 8 2}{cmd:. generate M`v' = missing(`v')}{p_end}
{p 4 8 2}{cmd:. label variable M`v' "`v'"}{p_end}
{p 4 8 2}{cmd:. {c )-}}{p_end}

{p 4 8 2}{cmd:. local toptitle  "t1title(Number of missing values)"}{p_end}

{p 4 8 2}{cmd:. vennbar M*, `toptitle' `bcolor' varlabels name(VB8, replace)}{p_end}

{p 4 8 2}{cmd:. vennbar M* if missing(ind_code, union, wks_ue, tenure, wks_work), `toptitle' `bcolor' varlabels over(_text, sort(_freq) descending) over(_degree) nofill ysc(r(. 9200)) name(VB9, replace)}{p_end}

{p 4 8 2}{cmd:. * Example 3}{p_end}
{p 4 8 2}{cmd:. * various indicators in nlswork.dta}{p_end}

{p 4 8 2}{cmd:. webuse nlswork, clear}{p_end}
{p 4 8 2}{cmd:. local bcolor bar(1, fcolor(blue*0.3) lcolor(blue))}{p_end}
{p 4 8 2}{cmd:. local toptitle "t1title(Number of people)"}{p_end}

{p 4 8 2}{cmd:. vennbar nev_mar c_city collgrad south, `toptitle' `bcolor' name(VB10, replace)}{p_end}

{p 4 8 2}{cmd:. label variable nev_mar "never married"}{p_end}
{p 4 8 2}{cmd:. label variable c_city "central city"}{p_end}
{p 4 8 2}{cmd:. label variable collgrad "college graduate"}{p_end}
{p 4 8 2}{cmd:. label variable south "South"}{p_end}

{p 4 8 2}{cmd:. vennbar nev_mar c_city collgrad south , `toptitle' `bcolor' varlabels name(VB11, replace)}{p_end}

{p 4 8 2}{cmd:. vennbar nev_mar c_city collgrad south, varlabels sep("; ") `toptitle' `bcolor' name(VB12, replace)}{p_end}

{p 4 8 2}{cmd:. label def nev_mar 0 ever 1 never}{p_end}
{p 4 8 2}{cmd:. label def c_city 0 "non-central" 1 central}{p_end}
{p 4 8 2}{cmd:. label def collgrad 0 "non-graduate" 1 graduate}{p_end}
{p 4 8 2}{cmd:. label def south 0 elsewhere 1 South}{p_end}

{p 4 8 2}{cmd:. foreach v in nev_mar c_city collgrad south {c -(}}{p_end}
{p 4 8 2}{cmd:. 	label val `v' `v'}{p_end}
{p 4 8 2}{cmd:. {c )-}}{p_end}

{p 4 8 2}{cmd:. vennbar nev_mar c_city collgrad south, vallabels sep("; ") `toptitle' `bcolor' name(VB13, replace)}{p_end}


{title:Remarks}

    {title:Explanation and advice}

{p 4 4 2}
{cmd:vennbar} requires a bundle of numeric variables with values 0 or 1.  Such
variables are variously called indicator, dummy, binary, dichotomous,
zero-one, one-hot, Boolean, logical, or quantal.  Missing values will be
ignored.  Otherwise, presenting values other than 0 or 1 is considered an
error.  Observations used will thus have all values 0 or 1 in all variables
specified.  Differently put, {cmd:vennbar} is not for string variables or
categorical variables that have three or more distinct values.

{p 4 4 2}
If your dataset is already aggregated to frequencies or other measures of
abundance, specify those as weights multiplying the indicator variables.

{p 4 4 2}
Consider two such indicators.  The concatenations 00, 01, 10, and 11 define
the four possible subsets defined by those variables, distinct binary codes
for binary numbers 00 to 11, and distinct decimal equivalents 0 to 3.
Otherwise put, concatenation is here a simple and natural way to define
composite categorical variables (Cox 2007).  00 is of degree 0, 01 and 10 are
of degree 1, and 11 is of degree 2.  Here, and indeed generally, leading zeros
are retained as helpful reminders even though they might be considered
redundant or ornamental.

{p 4 4 2}
Similarly, three such variables have eight possible binary concatenations
(000, 001, 010, 011, 100, 101, 110, and 111) and decimal equivalents (0 to 7).
More generally, {it:k} such variables define 2^{it:k} possible subsets.


    {title:Preprocessing}

{p 4 4 2}
The order of variables presented determines the order in which they are shown
in the key.  Choosing a suitable order is considered to be the user's
responsibility.  For example, if the data were medical symptoms exhibited by
patients, a substantive grouping (say, cardiovascular symptoms all together)
could make analytical sense.  Otherwise, ordering variables by their means
(equivalently, the frequency or abundance of states coded as 1) may be
helpful.  A utility, {helpb sortmean}, is distributed as ancillary with this
package.  See also {helpb vorter} (Klein 2012) from Statistical Software
Components Archive.

{p 4 4 2}
Variables that are identically 0 or identically 1, at least in the data being
shown, are not always useful and so might be omitted.  {helpb findname} (Cox
[2010]; {cmd:search findname, sj} for updates) can be used to find such
variables through option {cmd:all(@ == 0)} or {cmd:all(@ == 1)}.  Such calls
can be extended to check for missing values, which this command will ignore
anyway.

{p 4 4 2}
Various {helpb egen} functions can be useful in selecting observations of
particular interest.  Thus, {cmd:rowtotal()} yielding totals of two or more
would identify occurrence of two or more conditions simultaneously.


    {title:Historical remarks and literature survey}

{p 4 4 2}
The elementary but fundamental idea of representing true (or present) as 1 and
false (or absent) as 0 has a splendid history.  Although it has yet longer
roots, the idea was strongly developed by George Boole (1815–1864): Boole
(1854) was his major work in this territory, on which see particularly
Grattan-Guinness (2005).  Boole has been given a full-length biography
(MacHale 2014) and an even longer sequel (MacHale and Cohen 2018).  For
shorter accounts, see Gardner (1969a,b), Broadbent (1970), MacHale (2000,
2008), Heath and Seneta (2001), or Grattan-Guinness (2004).  See (for example)
Dewdney (1993) or Gregg (1998) for samples of how such Boolean algebra
features in computing.  See Knuth (1998, chap. 4.1) for an excellent
historical summary of positional number systems and Knuth (2011) for a
masterly synopsis, including historical material, of related combinatorial
algorithms.  See Strickland and Lewis (2022) for a focus on binary arithmetic
and logic in the work of Gottfried Wilhelm Leibniz (1646–1716).  The leading
biography of Leibniz is by Antognazza (2009), although the earlier biography
by Aiton (1985) is still very helpful.  Leibniz's projects feature in many
subplots in Stephenson (2003) and its sequels.  Cox (2016) makes further
Stata-related comments on truth, falsity, and indication.  Cox and Schechter
(2019) survey the creation of indicator variables in Stata.

{p 4 4 2}
Various commentators, from Leibniz onward, have seen anticipations of binary
arithmetic in the divination manual {it:I Ching} ({it:Yijing}, {it:Yi Jing},
{it:Yi King}, etc.).  That seems exaggerated.  See Gardner (1974) for a brisk
discussion and Knuth (2011) and Strickland and Lewis (2022) for further
comments.

{p 4 4 2}
For two or three variables, Euler or Venn diagrams annotated with subset
frequencies (or other information) are relatively easy to draw and sometimes
to understand, but even for four or five variables, they are harder to draw
and even harder to understand.  For, say, {it:k} = 5, 2^5 = 32, which poses a
challenge to show data intelligibly.  For, say, {it:k} = 10, 2^10 = 1024,
which is often far too many subsets to work with simultaneously.  However, the
problem will be eased in practice if many of the possible subsets do not occur
or occur so rarely that they can be ignored.  For modest values of {it:k}, bar
or dot charts may be a competitive alternative, which is the idea implemented
here.

{p 4 4 2}
This {cmd:vennbar} command is in part a reaction to what have been called
UpSetPlots.  See Lex (2021), Lex and Gehlenberg (2014), Lex et al.  (2014),
Conway, Lex, and Gehlenborg (2017), and Ballarini et al. (2020).  Lex (2022)
explains the origin of the name as a play on "set" and because he was "upset"
by Venn diagram alternatives in the literature (for example, D'Hont et al.
[2012]).  The idea that Venn diagrams are better replaced by bar chart
alternatives is older (for example, Kosara [2007]) and indeed implicit in any
decision to use bar charts when researchers are aware of Venn diagrams.  The
assertion "I would argue that Venn diagrams are a great tool for learning
about sets, but useless as a visualization" (Kosara 2007) is unfortunately
supported by many examples in various literature.

{p 4 4 2}
Hamming (1991, 16–17) commended Venn diagrams for simple cases yet continued:
"But if you try to go to very many subsets then the problem of drawing a
diagram which will show clearly what you are doing is often difficult.
Circles are not, of course, necessary but when you are forced to draw very
snake-like regions then the diagram is of little help in visualizing the
situation."

{p 4 4 2}
Gleason (1991, 33) commented that Venn diagrams become unwieldy for a number
of sets "exceeding 4 or 5".

{p 4 4 2}
Venn diagrams are widely familiar in mathematics and science and indeed as a
cultural meme echoed in cartoons, t-shirt or mug designs, and much else.
Christianson (2012) mentioned Venn diagrams as one of
{it:100 Diagrams That Changed the World}.  Friendly and Wainer's (2021)
introductions to set theory featuring Venn diagrams include Stewart (1975) and
Gullberg (1997).  Conversely, compare Hamming (1985, 367): "Set theory has
been taught until the typical student is weary of it, so we will assume that
it is familiar." Beyond their original and continuing use in logic, Venn
diagrams are commonly used in introductions to probability: see (for example)
Pitman (1993), Whittle (2000), Dekking et al. (2005), Miller (2017), or
Blitzstein and Hwang (2019).  Historically and to the present, set theory is
linked to much fundamental work in logic, number theory, and other parts of
mathematics (Bagaria [2008]; various chapters in Grattan-Guinness [1994];
Stillwell [2010]).

{p 4 4 2}
For the history of Venn and related diagrams, see Baron (1969), Gardner
(1982), Edwards (2004), Moktefi and Shin (2012), and Bennett (2015).  Friendly
and Wainer (2021, 102–103) flag the use of an area-proportional Venn-like
diagram by Playfair (1801, opp. p. 48).  Wilkinson (2012) covers some more
recent work on drawing area-proportional plots from a statistical point of
view.  Macfarlane (1885, 1891) referred to composite categories laid out in
sequence as the logical spectrum.

{p 4 4 2}
Venn (1880a,b,c, 1881, 1894) made explicit that the diagrams later named after
him grew out of earlier work.  Indeed, few logicians were as fully aware of
previous contributions.  Thus, the name exemplifies Stigler's Law (1980, 1999)
that "No scientific discovery is named after its original discoverer".  The
injustice is partially corrected by crediting Euler's earlier work (1768), on
which see conveniently Sandifer (2007) or Bennett (2015).  A distinction is
often drawn (for example, Mollerup [2015, 166]) that Venn diagrams show all
possible combinations, while Euler diagrams only show actual combinations.
However, Euler's contribution in turn was preceded by yet earlier work by
Leibniz and several other scholars.  Nevertheless, crediting Euler or Venn is
fair, and there is no point to suggesting yet another term when both terms are
so well established.

{p 4 4 2}
John Venn (1834–1923) now benefits from a full-length biography (Verburgt
2022).  For shorter appreciations, see Broadbent (1976), Grattan-Guinness
(2001), or Gibbins (2004).  Grattan-Guinness (2011) places the work of Boole
and Venn in context, surveying the development of logic in 19th century
Britain.  Venn's interest in probability and statistics was profound: see
especially his first book {it:The Logic of Chance} (1866, 1876, 1888) and a
still useful review article on averages (Venn 1891).

{p 4 4 2}
Leonhard Euler (1707–1783) is also well served by a full-length biography
(Calinger 2016).  See also Calinger, Denisova, and Polyakhova (2019) on what
in English is known as {it:Letters to a German Princess}.  For a concise
overview of some of his mathematical achievements, see Dunham (1999).  For a
shorter, although still detailed, account, see Youschkevitch (1971).  For a
very concise account, see Sandifer (2008).

{p 4 4 2}
For implementations of Venn diagrams in Stata, see (for example) Lauritsen
(1999a,b,c,d, 2009), Gong and Ostermann (2011), and Over (2022).


{title:References}

{p 4 8 2}
Aiton, E. J. 1985.
{it:Leibniz: A Biography}.
Bristol, U.K.: Adam Hilger.

{p 4 8 2}
Allenby, R. B. J. T., and A. Slomson. 2011.
{it:How to Count: An Introduction to Combinatorics}.
Boca Raton, FL: CRC Press.

{p 4 8 2}
Antognazza, M. R. 2009.
{it:Leibniz: An Intellectual Biography}.
Cambridge: Cambridge University Press.

{p 4 8 2}
Bagaria, J. 2008.
Set theory. In {it:The Princeton Companion to Mathematics}, ed.
T. Gowers, 615–634.
Princeton, NJ: Princeton University Press.

{p 4 8 2}
Ballarini, N. M., Y.-D. Chiu, F. K{c o:}nig, M. Posch, and T. Jaki.
2020.
A critical review of graphics for subgroup analyses in clinical trials.
{it:Pharmaceutical Statistics} 19: 541–560.
{browse "https://doi.org/10.1002/pst.2012"}.

{p 4 8 2}
Baron, M. E. 1969.
A note on the historical development of logic diagrams: Leibniz, Euler
and Venn. {it:Mathematical Gazette} 53: 113–125.
{browse "https://doi.org/10.2307/3614533"}.

{p 4 8 2}
Bennett, D. 2015.
Origins of the Venn diagram.
In {it:Research in History and Philosophy of Mathematics},
ed. M. Zack and E. Landry, 105–119.
Cham, Switzerland: Springer.
{browse "https://doi.org/10.1007/978-3-319-22258-5_8"}.

{p 4 8 2}
Biggs, N. L. 2002.
{it:Discrete Mathematics}. 2nd ed.
Oxford: Oxford University Press.

{p 4 8 2}
Blitzstein, J. K., and J. Hwang. 2019.
{it:Introduction to Probability}. 2nd ed.
Boca Raton, FL: CRC Press.

{p 4 8 2}
Boole, G. 1854.
{it:An Investigation of the Laws of Thought, on Which are Founded the Mathematical Theories of Logic and Probabilities}.
London: Walton and Maberley.

{p 4 8 2}
Broadbent, T. A. A. 1970.
Boole, George.
In Vol. 2 of {it:Dictionary of Scientific Biography}, ed.
C. C. Gillispie, 293–298. New York: Charles Scribner's Sons.

{p 4 8 2}
------. 1976.
Venn, John. In Vol. 13 of {it:Dictionary of Scientific Biography}, ed.
C. C. Gillispie, 611–613.
New York: Charles Scribner's Sons.

{p 4 8 2}
Calinger, R. S. 2016.
{it:Leonhard Euler: Mathematical Genius in the Enlightenment}.
Princeton, NJ: Princeton University Press.
{browse "https://doi.org/10.1515/9781400866632"}.

{p 4 8 2}
Calinger, R. S., E. Denisova, and E. N. Polyakhova. 2019.
{it:Leonhard Euler's Letters to a German Princess: A Milestone in the History of Physics Textbooks and More}.
San Rafael, CA: Morgan and Claypool Publishers.
{browse "https://doi.org/10.1088/2053-2571/aae6d2"}.

{p 4 8 2}
Cameron, P. J. 1994.
{it:Combinatorics: Topics, Techniques, Algorithms}.
Cambridge: Cambridge University Press.
{browse "https://doi.org/10.1017/CBO9780511803888"}.

{p 4 8 2}
Christianson, S. 2012.
{it:100 Diagrams That Changed the World: From the Earliest Cave Paintings to the Innovation of the iPod}.
New York: Penguin.

{p 4 8 2}
Conway, J. R., A. Lex, and N. Gehlenborg. 2017.
UpSetR: An R package for the
visualization of intersecting sets and their properties.
{it:Bioinformatics} 33: 2938–2940. 
{browse "https://doi.org/10.1093/bioinformatics/btx364"}.

{p 4 8 2}
Cox, N. J. 2007.
Stata tip 52: Generating composite categorical variables.
{it:Stata Journal} 7: 582–583.
{browse "https://doi.org/10.1177/1536867X0800700407"}.

{p 4 8 2}
------. 2008.
Speaking Stata: Between tables and graphs. 
{it:Stata Journal} 8: 269–289.
{browse "https://doi.org/10.1177/1536867X0800800208"}.

{p 4 8 2}
------. 2010. 
Speaking Stata: Finding variables. 
{it:Stata Journal} 10: 281–296.  
{browse "https://doi.org/10.1177/1536867X1001000208"}.

{p 4 8 2}
------. 2012. 
Speaking Stata: Axis practice, or what goes where on a graph. 
{it:Stata Journal} 12: 549–561.  
{browse "https://doi.org/10.1177/1536867X1201200314"}.

{p 4 8 2}
------. 2016. 
Speaking Stata: Truth, falsity, indication, and negation. 
{it:Stata Journal} 16: 229–236. 
{browse "https://doi.org/10.1177/1536867X1601600117"}.

{p 4 8 2}
------. 2017.
Speaking Stata: Tables as lists: The groups command.
{it:Stata Journal} 17: 760–773.
{browse "https://doi.org/10.1177/1536867X1701700314"}.

{p 4 8 2}
------. 2018.
Software Updates: Tables as lists: The groups command.
{it:Stata Journal} 18: 291. 
{browse "https://doi.org/10.1177/1536867X1801800118"}.

{p 4 8 2}
Cox, N. J., and C. B. Schechter. 2019.
Speaking Stata: How best to generate indicator or dummy variables.
{it:Stata Journal} 19: 246–259.
{browse "https://doi.org/10.1177/1536867X19830921"}.

{p 4 8 2}
Crossley, J. N., C. J. Ash, C. J. Brickhill, J. C. Stillwell, and N. H.
Williams. 1972.
{it:What is Mathematical Logic?}
London: Oxford University Press.

{p 4 8 2}
Dekking, F. M., C. Kraikamp, H. P. Lopuha{c a:}, and L. E. Meester. 2005.
{it:A Modern Introduction to Probability and Statistics: Understanding Why}
{it:and How}.
London: Springer. {browse "https://doi.org/10.1007/1-84628-168-7"}.

{p 4 8 2}
Dewdney, A. K. 1993.
{it:The New Turing Omnibus: 66 Excursions in Computer Science}.
New York: Henry Holt.

{p 4 8 2}
D'Hont, A., F. Denoeud, J.-M. Aury, F.-C. Baurens, F. Carreel, O. Garsmeur, 
B. Noel, et al. 2012. The banana ({it:Musa acuminata}) genome and the
evolution of monocotyledonous plants.  {it:Nature} 488: 213–217.
{browse "https://doi.org/10.1038/nature11241"}.

{p 4 8 2}
Dunham, W. 1999.
{it:Euler: The Master of Us All}.
Washington, DC: Mathematical Association of America.

{p 4 8 2}
Edwards, A. W. F. 2004.
{it:Cogwheels of the Mind: The Story of Venn Diagrams}.
Baltimore: Johns Hopkins University Press.

{p 4 8 2}
Euler, L. 1768.
Vol. 2 of {it:Lettres {c a'g} Une Princesse d'Allemagne sur Divers Sujets de Physique et de Philosophie}. 
Paris: Saint Petersbourg: L'Acad{c e'}mie Imp{c e'}riale des Sciences.
{browse "https://doi.org/10.5962/bhl.title.16687"}.

{p 4 8 2}
Friendly, M., and H. Wainer. 2021.
{it:A History of Data Visualization and Graphic Communication}.
Cambridge, MA: Harvard University Press.

{phang}
Gardner, M. 1969a. {it:Mathematical Circus}. New York: Alfred A. Knopf.

{phang}
------. 1969b. Mathematical games: Boolean algebra, Venn diagrams and the
propositional calculus. {it:Scientific American} 220: 110–117.
{browse "https://doi.org/10.1038/scientificamerican0269-110"}.

{p 4 8 2}
------. 1974. Mathematical games: The combinatorial basis of the "I Ching," the
Chinese book of divination and wisdom. {it:Scientific American} 230: 108–113.
{browse "https://doi.org/10.1038/scientificamerican0174-108"}.

{p 4 8 2}
------. 1982.
{it:Logic Machines and Diagrams}. 2nd ed.
Chicago: University of Chicago Press.

{p 4 8 2}
Gibbins, J. R. 2004.
Venn, John.
In Vol. 56 of {it:Oxford Dictionary of National Biography}, ed.
H. C. G. Matthew and B. Harrison, 259–260.
Oxford: Oxford University Press.
{browse "https://doi.org/10.1093/ref:odnb/36639"}.

{p 4 8 2}
Gleason, A. M. 1991.
{it:Fundamentals of Abstract Analysis}.
Boston: Jones and Bartlett.

{p 4 8 2}
Gong, W., and J. Ostermann. 2011.
pvenn: Stata module to create proportional Venn diagram. Statistical Software
Components S457368, Department of Economics, Boston
College. {browse "https://ideas.repec.org/c/boc/bocode/s457368.html"}.

{p 4 8 2}
Graham, R. L., D. E. Knuth, and O. Patashnik. 1994.
{it:Concrete Mathematics: A Foundation for Computer Science}. 2nd ed.
Reading, MA: Addison–Wesley.

{p 4 8 2}
Grattan-Guinness, I., ed. 1994.
{it:Companion Encyclopedia of the History and Philosophy of the Mathematical Sciences}.
London: Routledge.

{p 4 8 2}
Grattan-Guinness, I. 2001.
John Venn.
In {it:Statisticians of the Centuries}, ed.
C. C. Heyde, E. Seneta, P. Cr{c e'}pel, S. E. Fienberg, and J. Gani, 194–196.
New York: Springer. {browse "https://doi.org/10.1007/978-1-4613-0179-0_40"}.

{p 4 8 2}
------. 2004.
Boole, George.
In Vol. 6 of {it:Oxford Dictionary of National Biography}, ed.
H. C. G. Matthew, and B. Harrison, 582–585.
Oxford: Oxford University Press.
{browse "https://doi.org/10.1093/ref:odnb/2868"}.

{p 4 8 2}
------. 2005.
George Boole,
{it:An investigation of the laws of thought on which are founded the mathematical theory of logic and probabilities} (1854).
In  {it:Landmark Writings in Western Mathematics 1640–1940}, ed.
I. Grattan-Guinness, R. Cooke,
L. Corry, P. Cr{c e'}pel, and N. Guicciardini, 470–479.
Amsterdam: Elsevier. 
{browse "https://doi.org/10.1016/B978-044450871-3/50117-0"}.

{p 4 8 2}
------. 2011.
Victorian logic: From Whately to Russell.
In {it:Mathematics in Victorian Britain}, ed.
R. Flood, A. Rice, and R. Wilson, 359–374.
Oxford: Oxford University Press.

{p 4 8 2}
Green, J. A. 1965.
{it:Sets and Groups}.
London: Routledge and Kegan Paul.

{p 4 8 2}
------. 1988.
{it:Sets and Groups: A First Course in Algebra}.
London: Chapman and Hall.

{p 4 8 2}
Gregg, J. R. 1998.
{it:Ones and Zeros: Understanding Boolean Algebra, Digital Circuits, and the}
{it:Logic of Sets}.
Piscataway, NJ: IEEE.

{p 4 8 2}
Grimmett, G. R., and D. R. Stirzaker. 2020.
{it:Probability and Random Processes}. 4th ed.
Oxford: Oxford University Press.

{p 4 8 2}
Gullberg, J. 1997.
{it:Mathematics: From the Birth of Numbers}.
New York: W. W. Norton.

{p 4 8 2}
Hamming, R. W. 1985.
{it:Methods of Mathematics Applied to Calculus, Probability, and Statistics}.
Englewood Cliffs, NJ: Prentice-Hall.

{p 4 8 2}
------. 1991.
{it:The Art of Probability for Scientists and Engineers}.
Reading, MA: Addison–Wesley.

{p 4 8 2}
Heath, P., and E. Seneta. 2001.
George Boole.
In {it:Statisticians of the Centuries}, ed.
C. C. Heyde, E. Seneta, P. Cr{c e'}pel, S. E. Fienberg, and J. Gani, 
167–170.
New York: Springer. {browse "https://doi.org/10.1007/978-1-4613-0179-0_34"}.

{p 4 8 2}
It{c o^}, K., ed. 1987.
{it:Encyclopedic Dictionary of Mathematics}. 2nd ed.
Cambridge, MA: MIT Press.

{p 4 8 2}
James, G., and R. C. James. 1992. 
{it:Mathematics Dictionary}. 5th ed.
New York: Van Nostrand Reinhold.

{phang}
Klein, D. 2012. vorter: Stata module to reorder variables in dataset based on
sorted values. Statistical Software
Components S457572, Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s457572.html"}.

{p 4 8 2}
Knuth, D. E. 1997.
{it:The Art of Computer Programming}. Vol. 1, {it:Fundamental Algorithms}. 3rd
ed. Reading, MA: Addison–Wesley.

{p 4 8 2}
------. 1998.
{it:The Art of Computer Programming}. Vol. 2, {it:Seminumerical Algorithms}.
3rd ed. Reading, MA: Addison–Wesley. 

{p 4 8 2}
------. 2011. {it:The Art of Computer Programming}. Vol. 4A,
{it:Combinatorial Algorithms, Part 1}. 
Upper Saddle River, NJ: Addison–Wesley.

{p 4 8 2}
Kosara, R. 2007.
Autism diagnosis accuracy -- Visualization redesign.
{browse "https://eagereyes.org/criticism/autism-diagnosis-accuracy":https://eagereyes.org/criticism/autism-diagnosis-accuracy}.

{p 4 8 2}
Lauritsen, J. M. 1999a. gr34: Drawing Venn diagrams. {it:Stata Technical}
{it:Bulletin} 47: 3–8. Reprinted in {it:Stata Technical Bulletin}
{it:Reprints}. Vol. 8, pp.  65–71. College Station, TX: Stata Press.

{p 4 8 2}
------. 1999b. gr34.1: Drawing Venn diagrams. {it:Stata Technical Bulletin}
48: 2. Reprinted in {it:Stata Technical Bulletin Reprints}. Vol. 8, pp. 71–72.
College Station, TX: Stata Press.

{p 4 8 2}
------. 1999c. gr34.2: Drawing Venn diagrams. {it:Stata Technical Bulletin}
49: 8.  Reprinted in {it:Stata Technical Bulletin Reprints}. Vol. 9, p.
89. College Station, TX:  Stata Press.

{p 4 8 2}
------. 1999d. gr34.3: An update to drawing Venn diagrams. 
{it:Stata Technical Bulletin} 54: 17–19. 
Reprinted in {it:Stata Technical Bulletin Reprints}. 
Vol. 9, pp. 89–92. College Station, TX: Stata Press.

{p 4 8 2}
------. 2009.
venndiag: Stata module to generate Venn diagrams. Statistical Software
Components S361502, Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s361502.html"}.

{p 4 8 2}
Lex, A. 2021. UpSet: Visualizing intersecting sets.
{browse "https://upset.app/":https://upset.app/}.

{p 4 8 2}
------. 2022. "Ah, I missed that. It's not all that meaningful. It comes from
me being `upset' when I saw this chart... And then upset has `set' in it...".
Twitter, September 13, 2022, 12:34 p.m. 
{browse "https://mobile.twitter.com/alexander_lex/status/1569741352417787905"}.

{p 4 8 2}
Lex, A., and N. Gehlenborg. 2014. Sets and intersections.
{it:Nature Methods} 11: 779.
{browse "https://doi.org/10.1038/nmeth.3033"}.

{p 4 8 2}
Lex, A., N. Gehlenborg, H. Strobelt, R. Vuillemot, and H. Pfister. 2014. UpSet:
Visualization of intersecting sets. 
{it:IEEE Transactions on Visualization and Computer Graphics} 20: 1983–1992.
{browse "https://doi.org/10.1109/TVCG.2014.2346248"}.

{p 4 8 2}
Liebeck, M. 2016.
{it:A Concise Introduction to Pure Mathematics}. 4th ed.
Boca Raton, FL: CRC Press.

{p 4 8 2}
Macfarlane, A. 1885. The logical spectrum. {it:Philosophical Magazine},
5th ser., 19: 286–290.
{browse "https://doi.org/10.1080/14786448508627677"}. 

{p 4 8 2}
------. 1891.
Adaption of the method of the logical spectrum to Boole's problem.
In Vol. 39 of {it:Proceedings of the American Association of the Advancement}
{it:of Science}, ed. F. W. Putnam, 57–60. Salem, MA: Salem Press Publishing
and Printing.

{p 4 8 2}
MacHale, D. 2000.
George Boole 1815–1864. In
{it:Creators of Mathematics: The Irish Connection},
ed. K. Houston, 27–32. Dublin: University College Dublin Press.

{p 4 8 2}
------. 2008.
George Boole (1815–1864).
In {it:The Princeton Companion to Mathematics},
ed. T. Gowers, 769–770.
Princeton, NJ: Princeton University Press.

{p 4 8 2}
------. 2014.
{it:The Life and Work of George Boole: A Prelude to the Digital Age}.
Cork, Ireland: Cork University Press.

{p 4 8 2}
MacHale, D. and Y. Cohen. 2018.
{it:New Light on George Boole}.
Cork, Ireland: Cork University Press.

{p 4 8 2}
Miller, S. J. 2017.
{it:The Probability Lifesaver: All the Tools You Need to Understand Chance}.
Princeton, NJ: Princeton University Press.
{browse "https://doi.org/10.2307/j.ctvc7767n"}.

{p 4 8 2}
Moktefi, A., and S.-J. Shin. 2012.
A history of logic diagrams.
In {it:Handbook of the History of Logic}. Vol. 11, {it:Logic: A History of Its Central Concepts},
ed. D. M. Gabbay, F. J. Pelletier, and J. Woods,
611–682. Amsterdam: North-Holland.

{p 4 8 2}
Mollerup, P.
2015.
{it:Data Design: Visualizing Quantities, Locations, Connections}.
London: Bloomsbury.

{p 4 8 2}
Over, M. 2022.
pvenn2: Proportional Venn diagram, enhanced version of pvenn.
{browse "http://digital.cgdev.org/doc/stata/MO/Misc":http://digital.cgdev.org/doc/stata/MO/Misc}.

{p 4 8 2}
Pitman, J. 1993.
{it:Probability}.
New York: Springer.
{browse "https://doi.org/10.1007/978-1-4612-4374-8"}.

{p 4 8 2}
Playfair, W. 1801.
{it:The Statistical Breviary; Shewing, on a Principle Entirely New, the}
{it:Resources of Every State and Kingdom in Europe}.
London: Wallis.

{p 4 8 2}
Sandifer, C. E. 2007.
{it:How Euler Did It}.
Washington, DC: Mathematical Association of America.

{p 4 8 2}
------. 2008.
Leonhard Euler (1707–1783). In {it:The Princeton Companion to Mathematics},
ed. T. Gowers, 747–749.
Princeton, NJ: Princeton University Press.

{p 4 8 2}
Schnable, P. S., D. Ware, R. S. Fulton, J. C. Stein, F. Wei, S. Pasternak, C.
Liang, et al. 2009.
The B73 maize genome: Complexity, diversity, and dynamics.
{it:Science} 326: 1112–1115.
{browse "https://doi.org/10.1126/science.1178534"}.

{p 4 8 2}
Stephenson, N. 2003.
{it:Quicksilver}. Vol. 1, {it:The Baroque Cycle}.
New York: William Morrow.

{p 4 8 2}
Stewart, I. 1975.
{it:Concepts of Modern Mathematics}.
Harmondsworth: Penguin.

{p 4 8 2}
Stigler, S. M. 1980.
Stigler's law of eponymy.
{it:Transactions of the New York Academy of Sciences}
39: 147–158. {browse "https://doi.org/10.1111/j.2164-0947.1980.tb02775.x"}.

{p 4 8 2}
------. 1999.
{it:Statistics on the Table: The History of Statistical Concepts and Methods}.
Cambridge, MA: Harvard University Press.
{browse "https://doi.org/10.2307/j.ctv1pdrpsj"}.

{p 4 8 2}
Stillwell, J. 2010.
{it:Mathematics and Its History}. 3rd ed.
New York: Springer.  {browse "https://doi.org/10.1007/978-1-4419-6053-5"}.

{p 4 8 2}
Strickland, L., and H. R. Lewis. 2022.
{it:Leibniz on Binary: The Invention of Computer Arithmetic}.
Cambridge, MA: MIT Press.

{p 4 8 2}
Venn, J. 1866.
{it:The Logic of Chance}.
London: Macmillan.

{p 4 8 2}
------. 1876. {it:The Logic of Chance}. 2nd ed.
London: Macmillan.

{p 4 8 2}
------. 1880a.
On the diagrammatic and mechanical representation of propositions and
reasonings.
{it:Philosophical Magazine}, 5th ser., 10(59): 1–18.
{browse "https://doi.org/10.1080/14786448008626877"}. 

{p 4 8 2}
------. 1880b.
On the employment of geometrical diagrams for the sensible
representation of logical propositions.
{it:Transactions of the Cambridge Philosophical Society}
4: 47–59.

{p 4 8 2}
------. 1880c.
On the forms of logical proposition.
{it:Mind} 5: 336–349. 
{browse "https://doi.org/10.1093/mind/os-V.19.336"}.

{p 4 8 2}
------. 1881. 
{it:Symbolic Logic}.
London: Macmillan.

{p 4 8 2}
------. 1888.
{it:The Logic of Chance: An Essay on the Foundations and Province of the}
{it:Theory of Probability, with Especial Reference to its Logical Bearings and its}
{it:Application to Moral and Social Science and to Statistics}.
3rd ed. London: Macmillan.

{p 4 8 2}
------. 1891.
On the nature and uses of averages.
{it:Journal of the Royal Statistical Society}
54: 429–456. {browse "https://doi.org/10.2307/2979569"}.

{p 4 8 2}
------. 1894.
{it:Symbolic Logic}. 2nd ed.
London: Macmillan.

{p 4 8 2}
Verburgt, L. M. 2022.
{it:John Venn: A Life in Logic}.
Chicago: University of Chicago Press.

{p 4 8 2}
Whittle, P. 2000.
{it:Probability via Expectation}. 4th ed.
New York: Springer. {browse "https://doi.org/10.1007/978-1-4612-0509-8"}.

{p 4 8 2}
Wilkinson, L. 2012.
Exact and approximate area-proportional circular Venn and Euler
diagrams.
{it:IEEE Transactions on Visualization and Computer Graphics}
18: 321–331. {browse "https://doi.org/10.1109/TVCG.2011.56"}.

{p 4 8 2}
Youschkevitch, A. P. 1971. Euler, Leonhard.
In Vol. 4 of {it:Dictionary of Scientific Biography}, ed. C. C. Gillispie,
467–484. New York: Charles Scribner's Sons.

{p 4 8 2}
Zeitz, P. 2007.
{it:The Art and Craft of Problem Solving}. 2nd ed.
Hoboken, NJ: Wiley.


{title:Bibliographic note on Martin Gardner's columns}

{p 4 4 2}
Martin Gardner's columns on "Mathematical Games" over many years in
{it:Scientific American} covered much more than games and puzzles and
included many splendid expositions of topics with mathematical content.
They present a variety of small bibliographical challenges.  The original
articles will be accessible to many readers at {browse "https://www.jstor.org"} but typically
under the titles "Mathematical Games".  A further tiny detail is that
pagination starts afresh in each issue of {it:Scientific American}, so
volume and issue number together are needed for an exact citation.  The
columns were collected later in book form, often revised or
retitled, in books that themselves often varied in publisher and even
title over various reprints and reissues.  A project to publish further
revised editions, under yet other titles, from Cambridge University
Press and the Mathematical Association of America, released its first
four volumes between 2008 and 2014 but appears to have stalled.  At the
time of writing, it had not reached the books mentioned here.

{p 4 4 2}
{browse "https://en.wikipedia.org/wiki/List_of_Martin_Gardner_Mathematical_Games_columns":https://en.wikipedia.org/wiki/List_of_Martin_Gardner_Mathematical_Games_columns}
and
{browse "https://ansible.uk/misc/mgardner.html":https://ansible.uk/misc/mgardner.html}
will help you find what you are looking for or indeed to determine
whether a relevant column was ever written.


{title:Authors}

{p 4 4 2}Nicholas J. Cox{break}
Department of Geography{break}
Durham University{break}
Durham, U.K.{break}
n.j.cox@durham.ac.uk

{p 4 4 2}Tim P. Morris{break}
MRC Clinical Trials Unit{break}
University College London{break}
London, U.K.{break}
tim.morris@ucl.ac.uk


{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 24, number 2: {browse "https://doi.org/10.1177/1536867X241258010":gr0095}{p_end}

{p 7 14 2}
Help:  {manhelp misstable R},
{helpb sortmean},
{helpb groups},
{helpb upsetplot},
{helpb jaccard},
{helpb findname},
{helpb vorter} (if installed){p_end}
