{smcl}
{* *! version 1 26jul2016}{...}
{cmd:help kssur}{right: ({browse "http://www.stata-journal.com/article.html?article=st0493":SJ17-3: st0493})}
{hline}

{title:Title}

{p2colset 5 14 16 2}{...}
{p2col :{cmd:kssur} {hline 2}}Calculate Kapetanios, Shin, and Snell unit-root test statistic along with 1, 5, and 10% finite-sample critical values and associated p-values{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 17 2}
{cmd:kssur} {varname} {ifin}{cmd:,} 
[{cmd:noprint}
{cmdab:maxl:ag(}{it:integer}{cmd:)} {cmdab:noconstant} {cmdab:trend}]

{p 4 6 2}
{cmd:by} is not allowed.  The routine can be applied to a single unit of a
panel.{p_end}
{p 4 6 2}
You must {cmd:tsset} your data before using {cmd:kssur}; see {manhelp tsset TS}.{p_end}
{p 4 6 2}
{it:varname} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
Sample may not contain gaps.{p_end}


{title:Description}

{pstd}
{cmd:kssur} computes Kapetanios, Shin, and Snell (2003) ordinary least squares
(OLS) detrending-based unit-root tests against	the alternative of a globally
stationary exponential smooth transition autoregressive (ESTAR) process.  The
command accommodates {it:varname} with nonzero mean and nonzero
trend.  It also allows the lag length to be either fixed or determined
endogenously using information criteria such as Akaike and Schwarz, denoted
AIC and SIC, respectively.  A data-dependent procedure often known as the
general-to-specific (GTS) algorithm is also permitted, using significance
levels of 5 and 10%, denoted GTS05 and GTS10, respectively; see, for example,
Hall (1994).  Approximate p-values are also calculated.

{pstd}
Both the finite-sample critical values and the p-values are estimated
based on an extensive set of Monte Carlo simulations, summarized by means of
response surface regressions; for more details, see Otero and Smith (2017).


{title:Options}

{phang}
{opt noprint} specifies that the results be returned but not printed.

{phang}
{opt maxlag(integer)} sets the number of lags to be included in the test
regression to account for residual serial correlation.  The default is that
{cmd:kssur} sets the number of lags following Schwert (1989) with the formula
{cmd:maxlag()}={it:integer}{12*(T/100)^0.25}, where T is the total number of
observations.

{phang}
{opt noconstant} specifies that the test will be applied to the raw data.  Use
{hi:noconstant} when {it:varname} is a zero mean stochastic process.

{phang}
{opt trend} specifies to apply OLS detrending.  Use {hi:trend} when
{it:varname} is a nonzero trend stochastic process, in which case Kapetanios,
Shin, and Snell (2003) recommend detrending the data using OLS.  By default,
{it:varname} is assumed to be a nonzero mean stochastic process.


{title:Examples}

{pstd}
We test whether coffee price differentials contain a unit root.  For this, we
use monthly price series of the four best known types of coffee, namely,
unwashed Arabicas (mainly coffee from Brazil), Colombian mild Arabicas (mainly
coffee from Colombia), other mild Arabicas (mainly coffee from other Latin
American countries), and Robusta coffee (mainly coffee grown in African
countries and Southeast Asia).  The coffee prices, denoted {cmd:br}, {cmd:co},
{cmd:om}, and {cmd:ro}, respectively, are considered after applying the
logarithmic transformation.  The sample period runs from 1990m1 to 2004m1,
that is, a total of 169 time observations for each series, and the data were
downloaded from the website of the International Coffee Organisation at
{browse "http://www.ico.org"}.

{pstd}
We begin by downloading the data and verifying that they have a time-series
format:

{phang2}{bf:. {stata "use coffeedata.dta"}}{p_end}
{phang2}{bf:. {stata "tsset date":tsset date}}{p_end}

{pstd}
Then, suppose we want to test whether the price differential between Brazilian
coffee ({cmd:br}) and Colombia coffee ({cmd:co}), that is, {cmd:brco},
contains a unit root, against the alternative that it is a globally stationary
ESTAR process.  Given that {cmd:brco} has a nonzero mean, the relevant KSS
statistic is that based on OLS demeaned data, which are implemented by
default.  Initially, the number of lags is set by the user as p=3:

{phang2}{bf:. {stata "kssur brco, maxlag(3)":kssur brco, maxlag(3)}}{p_end}

{pstd}
This second illustration is the same as above, but using a subsample of the
data that starts in January 1992:

{phang2}{bf:. {stata "kssur brco if tin(1992m1,), maxlag(3)":kssur brco if tin(1992m1,), maxlag(3)}}{p_end}

{pstd}
Lastly, we perform the KS test using all the available observations, but with
the number of lags determined based on Schwert's formula:

{phang2}{bf:. {stata "kssur brco":kssur brco}}{p_end}


{title:Stored results}

{pstd}
{opt kssur} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(minp)}}first period used in the test regression{p_end}
{synopt:{cmd:r(maxp)}}last period used in the test regression{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(varname)}}variable name{p_end}
{synopt:{cmd:r(treat)}}either {cmd:rawdata}, {cmd:demeaned}, or {cmd:detrended}{p_end}
{synopt:{cmd:r(tsfmt)}}time series format of the time variable{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(results)}}results statistics table{p_end}
{p2colreset}{...}

{pstd}
The rows of the results matrix indicate which method of lag length was used:
FIX (lag selected by user, or using Schwert's formula); AIC; SIC; GTS05; or
GTS10.{p_end}

{pstd}
The columns of the results matrix contain, for each method: the number of
lags used;
the KSS statistic; its p-value; and the critical values at 1%, 5%, and 10%,
respectively.{p_end}


{title:References}

{phang}
Hall, A. 1994. Testing for a unit root in time series with pretest data-based
model selection. {it:Journal of Business and Economic Statistics} 12: 461-470.

{phang}
Kapetanios, G., Y. Shin, and A. Snell. 2003. Testing for a unit root in the
nonlinear STAR framework. {it:Journal of Econometrics} 112: 359-379.

{phang}
Otero, J., and J. Smith. 2017. 
{browse "http://www.stata-journal.com/article.html?article=st0493":Response surface models for OLS and GLS detrending-based unit-root tests in nonlinear ESTAR models}.
{it:Stata Journal} 17: 704-722.

{phang}
Schwert, G. W. 1989. Tests for unit roots: A Monte Carlo investigation.
{it:Journal of Business and Economic Statistics} 7: 147-159.


{title:Authors}

{pstd}
Jes{c u'}s Otero{break}
Facultad de Econom{c i'}a{break}
Universidad del Rosario{break}
Bogot{c a'}, Colombia{break}
jesus.otero@urosario.edu.co{p_end}

{pstd}
Jeremy Smith{break}
Department of Economics{break}
Warwick University{break}
Coventry, UK{break}
jeremy.smith@warwick.ac.uk{p_end}


{title:Also see}

{p 4 14 2}Article:  {it:Stata Journal}, volume 17, number 3: {browse "http://www.stata-journal.com/article.html?article=st0493":st0493}{p_end}

{p 7 14 2}Help:  {helpb ksur} (if installed){p_end}
