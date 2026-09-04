#' Therapeutic Touch data
#'
#' This is a reformatted version of the `TherapeuticTouchData.csv` used in *DBDA2*, originally published in Rosa et al (1998, Figure 2). Each of the 28 participants has ten trials, one per row.
#'
#' @format A tibble with 280 rows and 2 columns:
#' \describe{
#'   \item{participant}{Participant number (character values ranging from `"S01"` to `"S28"`)}
#'   \item{response}{Bernoulli trial results (character values `"wrong"` and `"correct"`)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' Rosa, L., Rosa, E., Sarner, L., & Barrett, S. (1998).
#' A close look at therapeutic touch.
#' \emph{JAMA}, 279(13), 1005–1010.
#' <https://doi.org/10.1001/jama.279.13.1005>
#'
#' @examples
#' tibble::glimpse(therapeutic_touch)
"therapeutic_touch"

#' Retrospective chart review data
#'
#' This is a reformatted version of the t-distributed data used in Figure 16.5 of *DBDA2* (p. 460), originally published in Boyd et al (1998), and further highlighted in Holcomb & Spalsbury (2005).
#'
#' @format A tibble with 178 rows and 8 columns:
#' \describe{
#'   \item{obsno}{Participant number (numeric values ranging from `1` to `178`)}
#'   \item{age}{Years old (numeric values)}
#'   \item{sex}{Binary (factor with two levels: `"male"` and `"female"`)}
#'   \item{alkphos}{Alkaline phosphatase (numeric values in liters)}
#'   \item{lab}{Lab (factor with six levels: `"Metpath"`, `"Deyor"`, `"St. Elizabeth's"`, `"CB Rouche"`, `"YOH"`, and `"Horizon"`)}
#'   \item{cammol}{Calcium (numeric values in mmol/L)}
#'   \item{phosmmol}{Inorganic phosphorus (numeric values in mmol/L)}
#'   \item{age_group}{Binned age (factor with five levels: `"65-69"`, `"70-74"`, `"75-79"`, `"80-84"`, and `"85-89"`)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' Boyd, J. L., Delost, M. E., & Holcomb, J. P. (1998).
#' Calcium, phosphorus, and alkaline phosphatase values of elderly subjects.
#' \emph{Clinical Laboratory Science, 11}(4), 223.
#'
#' Holcomb, J., & Spalsbury, A. (2005).
#' Teaching Students to Use Summary Statistics and Graphics to Clean and Analyze Data.
#' \emph{Journal of Statistics Education, 13}(3).
#' <https://doi.org/10.1080/10691898.2005.11910567>
#'
#' @examples
#' tibble::glimpse(chart_review)
"chart_review"

#' Hair and eye color data
#'
#' This is a reformatted version of the `HairEyeColor.csv` used in *DBDA2*, which were themselves from the `HairEyeColor` data from the \pkg{datasets} package (`?datasets::HairEyeColor`).
#'
#' @format A tibble with 16 rows and 3 columns:
#' \describe{
#'   \item{hair}{Hair color (factor with four levels: `"Black"`, `"Brunette"`, `"Red"`, and `"Blond"`)}
#'   \item{eye}{Eye color (factor with four levels: `"Brown"`, `"Blue"`, `"Hazel"`, and `"Green"`)}
#'   \item{count}{The number of each combination of `hair` and `eye` (numeric)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' R Core Team (2024).
#' \emph{R: A Language and Environment for Statistical Computing}.
#' R Foundation for Statistical Computing, Vienna, Austria.
#' <https://www.R-project.org/>
#'
#' @examples
#' tibble::glimpse(hair_eye_color)
"hair_eye_color"

#' Weight loss data based on Horan & Johnson (1971)
#'
#' This is an adjusted and simplified version of the primary outcome data presented in Table 2 of Horan & Johnson (1971, p. 246). The original data were pre- and post-treatment weights (lbs.) for participants in four weight loss groups. For the purposes of the example in Chapter 11 of *DBDA3*, we:
#'  * simplified the outcomes to whether each participants lost weight,
#'  * computed the proportion of weight loss in each condition, and then
#'  * adjusted those proportions and the sample size for each group.
#'
#' @format A tibble with 4 rows and 3 columns:
#' \describe{
#'   \item{treatment}{The experimental groups (ordered factor with four levels: `"delayed"` < `"placebo"` < `"scheduled"` < `"experimental"`)}
#'   \item{z}{The number who lost weight in each group (numeric)}
#'   \item{n}{Total number per group (numeric)}
#' }
#'
#' @source
#' Horan, J. J., & Johnson, R. G. (1971).
#' Coverant conditioning through a self-management application of the Premack principle: Its effect on weight reduction.
#' \emph{Journal of Behavior Therapy and Experimental Psychiatry, 2}(4), 243–249.
#' <https://doi.org/10.1016/0005-7916(71)90040-1>
#'
#' @examples
#' tibble::glimpse(weight_loss)
"weight_loss"

#' Individual Bernoulli trials
#'
#' Three data sets (`set_a`, `set_b`, and `set_c`) used in Chapter 9 of *DBDA3* to showcase how shrinkage in hierarchical models is influenced by different numbers of Bernoulli trials \eqn{(N_s)}, and different success proportions \eqn{(z_s / N_s)} per subject \eqn{(s)}.
#'
#' @format Each data set is a data frame with 200 rows and 2 columns:
#' \describe{
#'   \item{s}{Subject number (integer starting at `1`)}
#'   \item{y}{Bernoulli trials (integer with values `0` and `1`)}
#' }
#'
#' @examples
#' tibble::glimpse(set_a)
#'
#' tibble::glimpse(set_b)
#'
#' tibble::glimpse(set_c)
#'
"set_a"

#' @rdname set_a
#' @format NULL
"set_b"

#' @rdname set_a
#' @format NULL
"set_c"

#' Height and Weight data for 300 cases
#'
#' This is a reformatted version of the `HtWtData300.csv` used in *DBDA2*. The data were originally made with Kruschke's `HtWtDataGenerator()` function.
#'
#' @format A data frame with 300 rows and 3 columns:
#' \describe{
#'   \item{male}{numeric values coded `0` for women and `1` for men}
#'   \item{height}{numeric values (in inches)}
#'   \item{weight}{numeric values (in pounds)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' @examples
#' tibble::glimpse(height_weight_300)
"height_weight_300"

#' Height and Weight data for 110 cases
#'
#' This is a reformatted version of the `HtWtData110.csv` used in *DBDA2*. The data were originally made with Kruschke's `HtWtDataGenerator()` function.
#'
#' @format A data frame with 110 rows and 3 columns:
#' \describe{
#'   \item{male}{numeric values coded `0` for women and `1` for men}
#'   \item{height}{numeric values (in inches)}
#'   \item{weight}{numeric values (in pounds)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' @examples
#' tibble::glimpse(height_weight_110)
"height_weight_110"

#' Height and Weight data for 30 cases
#'
#' This is a reformatted version of the `HtWtData30.csv` used in *DBDA2*. The data were originally made with Kruschke's `HtWtDataGenerator()` function.
#'
#' @format A data frame with 30 rows and 3 columns:
#' \describe{
#'   \item{male}{numeric values coded `0` for women and `1` for men}
#'   \item{height}{numeric values (in inches)}
#'   \item{weight}{numeric values (in pounds)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' @examples
#' tibble::glimpse(height_weight_30)
"height_weight_30"

#' Height and Weight data for 40 cases
#'
#' A data set of 40 height and weight values simulated with the `height_weight_generator()` function. The final two rows have been altered to make them outliers relative to the rest. To streamline the data set for the purposes of the book, we removed the `male` column.
#'
#' @format A tibble with 40 rows and 2 columns:
#' \describe{
#'   \item{height}{numeric values (in inches)}
#'   \item{weight}{numeric values (in pounds)}
#' }
#'
#' @examples
#' tibble::glimpse(height_weight_40)
"height_weight_40"

#' Gaussian data for multiple linear regression
#'
#' A synthetic data set of a single Gaussian predicted variable `y`, and two continuous predictor variables `x1` and `x2`, made originally for Chapter 13 of *DBDA3*.
#'
#' @format A data frame with 400 rows and 3 columns:
#' \describe{
#'   \item{x1}{A numeric variable uniformly distributed between -4 and 2.}
#'   \item{x2}{A numeric variable uniformly distributed between -4 and 2, simulated independently from `x1`.}
#'   \item{y}{A numeric variable simulated to be Gaussian with a mean conditional on `x1` and `x2`.}
#' }
#'
#' @examples
#' tibble::glimpse(linear_data)
"linear_data"

#' Multilevel Gaussian data with a single metric predictor
#'
#' A data set used in Chapter 15 of *DBDA3* to showcase a Gaussian multilevel model with random intercepts and slopes for a predictor `x` and predicted variable `y`.
#'
#' @format A data frame with 146 rows and 5 columns:
#' \describe{
#'   \item{panel}{Panel index (character values ranging from `"1"` to `"28"`, saved as a factor)}
#'   \item{x}{numeric values}
#'   \item{y}{numeric values}
#'   \item{z_x}{numeric values (standardized `x`)}
#'   \item{z_y}{numeric values (standardized `y`)}
#' }
#'
#' @examples
#' tibble::glimpse(normal_panels)
"normal_panels"

#' Scholastic Aptitude Test (SAT) data
#'
#' This is a reformatted version of the `Guber1999data.csv` used in *DBDA2*, originally published in Guber (1992). The data are average values for the 50 US states.
#'
#' @format A data frame with 50 rows and 8 columns:
#' \describe{
#'   \item{state}{One of the 50 US states (character values ranging from `"Alabama"` to `"Wyoming"`)}
#'   \item{spend}{The average spending per student (numeric values, in thousands of dollars)}
#'   \item{stutearat}{The student/teacher ratio (numeric values)}
#'   \item{salary}{The average teacher salary (numeric values, in thousands of dollars)}
#'   \item{prcnttake}{The percentage of students who take the SAT (numeric values)}
#'   \item{satv}{The verbal subscore of the SAT (numeric values)}
#'   \item{satm}{The math subscore of the SAT (numeric values)}
#'   \item{satt}{The average total SAT score (numeric values)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' Guber, D. L. (1999).
#' Getting what you pay for: The debate over equity in public school expenditures.
#' \emph{Journal of Statistics Education}, 2(7).
#' <https://doi.org/10.1080/10691898.1999.12131274>
#'
#' @examples
#' tibble::glimpse(sat)
"sat"

#' Kentucky Derby data
#'
#' This is a reformatted version of the Kentucky-Derby data introduced by Chance & Reynolds (2019). As they wrote in their introduction: "The Kentucky Derby is an annual horse race run at Churchill Downs in Louisville, KY, USA, on the first Saturday in May" (p. 120).
#'
#' @format A data frame with 143 rows and 8 columns:
#' \describe{
#'   \item{year}{Year of the race (numeric values; 1875--2017)}
#'   \item{winner}{Name of the winning horse (character values)}
#'   \item{surface}{The surface of track (character values; currently always `dirt`)}
#'   \item{condition}{The rating of condition of track at start of race (character values)}
#'   \item{starters}{The number of horses lined up at the start of the race (numeric values)}
#'   \item{poleposition}{The starting gate of the winning horse (numeric values)}
#'   \item{time}{Winning time of the race (numeric values; seconds)}
#'   \item{speed}{The speed of the winning horse (numeric values; miles per hour)}
#' }
#'
#' @source
#' Chance, B., & Reynolds, S. (2019).
#' Predicting the Kentucky derby winner! Sort of.
#' \emph{Journal of Statistics Education, 27}(2), 120–127.
#' <https://doi.org/10.1080/10691898.2019.1623137>
#'
#' @examples
#' tibble::glimpse(derby)
"derby"

#' US Family Income
#'
#' This is a reformatted version of the `IncomeFamszState3yr.csv` used in *DBDA2*. The data were from the American Community Survey and Puerto Rico Community Survey, and downloaded on December 11, 2013, from the Census Bureau at [http://www.census.gov/hhes/www/income/data/Fam_Inc_SizeofFam1.xls](http://www.census.gov/hhes/www/income/data/Fam_Inc_SizeofFam1.xls). In addition to the 50 states, they also contain information about Puerto Rico and the District of Columbia
#'
#' @format A data frame with 312 rows and 4 columns:
#' \describe{
#'   \item{state}{One of the 50 US states, plus Puerto Rico and the District of Columbia (character values ranging from `"Alabama"` to `"Wyoming"`)}
#'   \item{family_size}{Number of persons per family (integer values, ranging from `2` to `7`)}
#'   \item{income}{Median family income (numeric values, in dollars)}
#'   \item{income_se}{The margin of error (standard error) for the median family income (numeric values)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' The US Census Bureau.
#' <https://www.census.gov/>
#'
#' @examples
#' tibble::glimpse(income)
"income"

#' Data with a continuous predicted, and two continuous predictor variables
#'
#' Two data sets (`two_x_cor` and `two_x_uncor`) used in Chapter 16 of *DBDA3* to show the consequences of weakly- and strongly-correlated predictors in simple regression models of the form \eqn{y_i = \beta_0 + \beta_1 x1_i + \beta_2 x2_i + \epsilon_i}.
#'
#' @format Each data set is a data frame with 200 rows and 3 columns:
#' \describe{
#'   \item{x1}{The first continuous predictor.}
#'   \item{x2}{The second continuous predictor.}
#'   \item{y}{The dependent variable, also continuous.}
#' }
#'
#' @examples
#' tibble::glimpse(two_x_cor)
#'
#' tibble::glimpse(two_x_uncor)
"two_x_cor"

#' @rdname two_x_cor
#' @format NULL
"two_x_uncor"

#' IPIP 300 Data
#'
#' Three data sets (`big5_12`, `big5_mexico`, and `big5_usa`) containing subsets of the IPIP 300 data from Johnson (2014).
#'
#' @format `big5_mexico` and `big5_usa` contain 100 rows each, and `big5_12` contains 1200 rows. All three data sets contain 9 columns:
#' \describe{
#'   \item{id}{Participant identifier (integers)}
#'   \item{sex}{Binary (factor with two levels: `"male"` and `"female"`)}
#'   \item{age}{Years old (integer values)}
#'   \item{country}{The country from which the data were collected (character values)}
#'   \item{a}{The sum score for the Agreeableness scale (numeric values)}
#'   \item{c}{The sum score for the Conscientiousness scale (numeric values)}
#'   \item{e}{The sum score for the Extraversion scale (numeric values)}
#'   \item{n}{The sum score for the Neuroticism scale (numeric values)}
#'   \item{o}{The sum score for the Openness to Experience scale (numeric values)}
#' }
#'
#' @source
#' Johnson, J. A. (2014).
#' Measuring thirty facets of the Five Factor Model with a 120-item public domain inventory: Development of the IPIP-NEO-120.
#' \emph{Journal of Research in Personality}, 51, 78-89.
#' <https://doi.org/10.1016/j.jrp.2014.05.003>
#'
#' Johnson, J. A. (2023, December 6).
#' Data from Johnson, J. A. (2014). Measuring thirty facets of the five factor model with a 120-item public domain inventory: Development of the IPIP-NEO-120.
#' \emph{Journal of Research in Personality}, 51, 78-89.
#' <https://osf.io/wxvth/>
#'
#' Johnson, J. A. (2024, April 4).
#' Scoring Key for the IPIP-NEO-300 and IPIP-NEO-120.
#' <https://osf.io/ycvdk>
#'
#' @examples
#' tibble::glimpse(big5_12)
#'
#' tibble::glimpse(big5_mexico)
#'
#' tibble::glimpse(big5_usa)
"big5_12"

#' @rdname big5_12
#' @format NULL
"big5_mexico"

#' @rdname big5_12
#' @format NULL
"big5_usa"

#' Two group IQ data
#'
#' This is a reformatted version of the `TwoGroupIQ.csv` used in *DBDA2*. The data are synthetic, and follow a basic two-group design where each person received one of the two levels of the intervention.
#'
#' @format A tibble with 120 rows and 2 columns:
#' \describe{
#'   \item{group}{Experimental group (factor with two levels: `"Placebo"` and `"Smart drug"`)}
#'   \item{score}{IQ test score (integer values)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' @examples
#' tibble::glimpse(iq_two)
"iq_two"

#' Sexual Activity and the Lifespan of Male Fruit flies
#'
#' This is a reformatted version of the `FruitflyDataReduced.csv` used in *DBDA2*, as published in James and Stanley (1994). In the original experiment, `longevity` was the primary outcome variable, and `thorax` was one of the baseline covariates.
#'
#' @format A data frame with 125 rows and 3 columns:
#' \describe{
#'   \item{group}{Experimental group (factor with five levels: `"none_0"`, `"pregnant_1"`, `"pregnant_8"`, `"virgin_1"`, and `"virgin_8"`)}
#'   \item{thorax}{Length of thorax in millimeters (numeric values)}
#'   \item{longevity}{Lifespan in days (integer values)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' James, A. H., & Stanley, H. S. (1994).
#' Sexual activity and the lifespan of male fruitflies: A dataset that gets attention.
#' \emph{Journal of Statistics Education}, 2(1).
#' <https://doi.org/10.1080/10691898.1994.11910467>
#'
#' @examples
#' tibble::glimpse(fruit_fly)
"fruit_fly"

#' Synthetic data of a 3 X 4 factorial experiment
#'
#' This is an adjusted version of the `Boik` data set from the \pkg{phia} package (`?phia::Boik`). The `Boik` data frame was based on a hypothetical example in Boik (1979). Similar to Boik (1979) and `Boik`, our `boik` data are designed to mirror a balanced 3 X 4 factorial experimental design wherein 72 persons complaining of hemophobia were randomly assigned to receive a combination of behavioral therapies (`therapy`) and antianxiety medication (`medication`). The outcome variable is electrodermal response (`edr`), which is a physiological correlate of fear.
#'
#' @format A data frame with 72 rows and 3 columns:
#' \describe{
#'   \item{therapy}{Therapy group (factor with three levels: `"control"`, `"a"`, `"b"`)}
#'   \item{medication}{Medication group (factor with four levels: `"placebo"`, `"low"`, `"medium"`, `"high"`)}
#'   \item{edr}{Electrodermal response (numeric values)}
#' }
#'
#' @source
#' Boik, R. J. (1979).
#' Interactions, Partial Interactions, and Interaction Contrasts in the Analysis of Variance.
#' \emph{Psychological Bulletin}, 86(5), 1084–1089.
#' <https://doi.org/10.1037/0033-2909.86.5.1084>
#'
#' De Rosario-Martinez, H. (2025).
#' \emph{phia: Post-hoc interaction analysis} \[Manual\].
#' <https://CRAN.R-project.org/package=phia>
#'
#' @examples
#' tibble::glimpse(boik)
"boik"

#' Four-group heteroscedastic data
#'
#' A synthetic data set of a single Gaussian predicted variable `y`, and a grouping factor variable, made originally for Chapter 18 of *DBDA3*. The means and variances of `y` can vary by `group`.
#'
#' @format A data frame with 100 rows and 2 columns:
#' \describe{
#'   \item{group}{Experimental group (factor with four levels: `"A"`, `"B"`, `"C"`, `"D"`)}
#'   \item{y}{Metric predicted variable, on an IQ-score like metric (numeric values)}
#' }
#'
#' @examples
#' tibble::glimpse(het_dat)
"het_dat"

#' Grouped Gaussian data
#'
#' A synthetic data set of a single Gaussian predicted variable `y`, and two factor variables `group_orig` and `group_perm`, made originally for Chapter 17 of *DBDA3*.
#'
#' @format A data frame with 25 rows and 3 columns:
#' \describe{
#'   \item{y}{A numeric variable simulated to be Gaussian with a mean varying by group.}
#'   \item{group_orig}{A factor with five levels: `"A"`, `"B"`, `"C"`, `"D"`, `"E"`.}
#'   \item{group_perm}{A factor with five levels: `"A"`, `"B"`, `"C"`, `"D"`, `"E"`.}
#' }
#'
#' @examples
#' tibble::glimpse(group_ae)
"group_ae"

#' Two group IQ data with a covariate
#'
#' Simulated data based loosely on the `TwoGroupIQ.csv` used in *DBDA2*. The data follow a basic two-group design where each person received one of the two levels of the intervention. The outcome variable is full-scale IQ (`iq`), and SAT total scores (`sat`) are a baseline covariate. The SAT population mean and standard deviation come from National Center for Education Statistics, and its correlation with IQ is based on Frey & Detterman (2004).
#'
#' @format A data frame with 100 rows and 4 columns:
#' \describe{
#'   \item{group}{Experimental group (factor with two levels: `"Placebo"` and `"Smart Drug"`)}
#'   \item{tx}{Experimental group as an integer of `0` (`"Placebo"`) and `1` (`"Smart Drug"`)}
#'   \item{iq}{A numeric variable of full-scale IQ scores simulated to be Gaussian, conditional on `group`.}
#'   \item{sat}{A numeric variable of SAT total scores simulated to be Gaussian.}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' Frey, M. C., & Detterman, D. K. (2004).
#' Scholastic Assessment or g?: The Relationship Between the Scholastic Assessment Test and General Cognitive Ability.
#' \emph{Psychological Science}, 15(6), 373–378.
#' <https://doi.org/10.1111/j.0956-7976.2004.00687.x>
#'
#' National Center for Education Statistics (2025, October 10).
#' \emph{Table 226.40. SAT mean scores, standard deviations, and score ranges for high school seniors, and percentage of the graduating class taking the SAT, by state: 2017.}
#' <https://nces.ed.gov/programs/digest/d17/tables/dt17_226.40.asp>
#'
#' @examples
#' tibble::glimpse(iq_sat)
"iq_sat"

#' Experimental corn production data
#'
#' This is a reformatted and modified version of the `SplitPlotAgriData.csv` used in *DBDA2*. They are designed to resemble an experiment in agronomy that measured corn production (in bushels per acre) as a function of how the fields were tilled and how fertilizer was applied.
#'
#' @format A data frame with 99 rows and 4 columns:
#' \describe{
#'   \item{field}{Corn field (factor with 33 levels): `1` through `33`}
#'   \item{till}{Tilling method (factor with 3 levels: `"chisel"`, `"moldboard"`, `"ridge"`)}
#'   \item{fert}{Fertilization method (factor with 3 levels: `"broad"`, `"deep"`, `"surface"`)}
#'   \item{yield}{Number of corn bushels per acre (integer)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' @examples
#' tibble::glimpse(split_plot)
"split_plot"

#' Grouped nominal data
#'
#' Synthetic grouped nominal data unique to *DBDA3*, for use in Chapter 21. This version of the data set is formatted long with respect to the four levels of `y`.
#'
#' @format A data frame with 264 rows and 2 columns:
#' \describe{
#'   \item{group}{The nominal groups (factor with 11 levels `A` through `K`)}
#'   \item{y}{The nominal predicted variable (factor with 4 levels `1` through `4`)}
#' }
#'
#' @seealso [nom_nom_wide] for the wide formatted version of the data.
#'
#' @examples
#' tibble::glimpse(nom_nom_long)
"nom_nom_long"

#' Grouped nominal data
#'
#' Synthetic grouped nominal data unique to *DBDA3*, for use in Chapter 21. This version of the data set is formatted wide with respect to the four levels of `y`.
#'
#' @format A data frame with 11 rows and 6 columns:
#' \describe{
#'   \item{group}{The nominal groups (factor with 11 levels `A` through `K`)}
#'   \item{y1}{The counts for the first level of the nominal predicted variable (integer)}
#'   \item{y2}{The counts for the second level of the nominal predicted variable (integer)}
#'   \item{y3}{The counts for the third level of the nominal predicted variable (integer)}
#'   \item{y4}{The counts for the fourth level of the nominal predicted variable (integer)}
#'   \item{n}{The total number of counts, per row (integer)}
#' }
#'
#' @seealso [nom_nom_long] for the long formatted version of the data.
#'
#' @examples
#' tibble::glimpse(nom_nom_wide)
"nom_nom_wide"

#' Nominal data with metric predictors
#'
#' Synthetic nominal data with two metric predictors. These are unique to *DBDA3*, and highlighted in Chapter 21.
#'
#' @format A data frame with 500 rows and 3 columns:
#' \describe{
#'   \item{x1}{The first metric predictor (numeric)}
#'   \item{x2}{The second metric predictor (numeric)}
#'   \item{y}{The nominal predicted variable (factor with 4 levels `1` through `4`)}
#' }
#'
#' @examples
#' tibble::glimpse(nom_met)
"nom_met"

#' Bernoulli trials with two strongly correlated metric predictors
#'
#' Synthetic data unique to *DBDA3*, for use in Chapter 20. The binary predicted variable `y` has two strongly correlated metric predictors, `x1` and `x2`.
#'
#' @format A data frame with 100 rows and 3 columns:
#' \describe{
#'   \item{x1}{The first metric predictor (numeric)}
#'   \item{x2}{The second metric predictor (numeric)}
#'   \item{y}{Bernoulli trials (integer with values `0` and `1`)}
#' }
#'
#' @examples
#' tibble::glimpse(cor_pred_dichot)
"cor_pred_dichot"

#' Bernoulli trials with strong separation
#'
#' Synthetic data unique to *DBDA3*, for use in Chapter 20. The binary predicted variable `y` has two correlated metric predictors, `x1` and `x2`, and the trials show strong separation by the predictors.
#'
#' @format A data frame with 100 rows and 3 columns:
#' \describe{
#'   \item{x1}{The first metric predictor (numeric)}
#'   \item{x2}{The second metric predictor (numeric)}
#'   \item{y}{Bernoulli trials (integer with values `0` and `1`)}
#' }
#'
#' @examples
#' tibble::glimpse(sep_zone)
"sep_zone"

#' Bernoulli trials with few 1's
#'
#' Synthetic data unique to *DBDA3*, for use in Chapter 20. Both versions of the binary predicted variables, `y` and `y_few`, have two weakly correlated metric predictors, `x1` and `x2`. Whereas the variable `y` has a roughly even number of 0's and 1's, `y_few` has very few 1's.
#'
#' @format A data frame with 100 rows and 4 columns:
#' \describe{
#'   \item{x1}{The first metric predictor (numeric)}
#'   \item{x2}{The second metric predictor (numeric)}
#'   \item{y}{Bernoulli trials (integer with values `0` and `1`)}
#'   \item{y_few}{Bernoulli trials (integer with values `0` and `1`)}
#' }
#'
#' @examples
#' tibble::glimpse(few_ones)
"few_ones"

#' Bernoulli headache data
#'
#' Synthetic data unique to *DBDA3*, for use in Chapter 20. The data are based on a hypothetical study in which participants were randomly assigned to different dosages of a drug (`dosage` measured in milligrams; with 0 used as a placebo). Each participant was asked if they experienced a headache within 24 hours of taking the drug, with yes coded as `1` and no coded as `0`.
#'
#' @format A data frame with 350 rows and 2 columns:
#' \describe{
#'   \item{dosage}{The dosages of a drug (milligrams; numeric)}
#'   \item{headache}{Bernoulli trials (integer with values `0` and `1`) indicating whether participants had a headache}
#' }
#'
#' @examples
#' tibble::glimpse(headache)
"headache"

#' Bernoulli headache data with two interacting predictors
#'
#' Synthetic data unique to *DBDA3*, for use in Chapter 20. The data are based on a hypothetical study in which participants were randomly assigned to different dosages of a drug (`dosage` measured in milligrams; with 0 used as a placebo). Each participant was asked if they experienced a headache within 24 hours of taking the drug, with yes coded as `1` and no coded as `0`. Participant `age` at baseline was also recorded.
#'
#' @format A data frame with 250 rows and 3 columns:
#' \describe{
#'   \item{age}{Years old at baseline (numeric)}
#'   \item{dosage}{The dosages of a drug (milligrams; numeric)}
#'   \item{headache}{Bernoulli trials (integer with values `0` and `1`) indicating whether participants had a headache}
#' }
#'
#' @examples
#' tibble::glimpse(headache_inter)
"headache_inter"

#' Bernoulli trials with outliers
#'
#' Synthetic data unique to *DBDA3*, for use in Chapter 20. The binary predicted variable `y` has one metric predictor, `x`.
#'
#' @format A data frame with 107 rows and 2 columns:
#' \describe{
#'   \item{x}{The metric predictor (numeric)}
#'   \item{y}{Bernoulli trials (integer with values `0` and `1`)}
#' }
#'
#' @examples
#' tibble::glimpse(logis_out)
"logis_out"

#' Synthetic bimodal ordinal data
#'
#' This is a reformatted version of the `OrdinalProbitData-1grp-2.csv` data used in *DBDA2*. The data are synthetic, and designed to follow a bimodal distribution.
#'
#' @format A data frame with 70 rows and 1 column:
#' \describe{
#'   \item{y}{Ordinal predicted variable (ordered factor with seven levels: `"1"` to `"7"`)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' @examples
#' tibble::glimpse(ord_bimod)
"ord_bimod"

#' Extremely skewed ordinal data
#'
#' This is a reformatted version of the `OrdinalProbitData-1grp-1.csv` data used in *DBDA2*. The data are synthetic, and designed to follow an extremely skewed distribution.
#'
#' @format A data frame with 100 rows and 1 column:
#' \describe{
#'   \item{y}{Ordinal predicted variable (ordered factor with seven levels: `"1"` to `"7"`)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' @examples
#' tibble::glimpse(ord_skew)
"ord_skew"

#' Grouped aggregated ordinal data
#'
#' Synthetic data unique to *DBDA3*, for use in Chapter 22. There are three groups, and each group has about 500 total count.
#'
#' @format A data frame with 21 rows and 3 columns:
#' \describe{
#'   \item{group}{Grouping variable (character values`"A"`, `"B"`, and `"C"`)}
#'   \item{rating}{Ordinal predicted variable (ordered factor with seven levels: `"1"` to `"7"`)}
#'   \item{count}{The number of occasions for each level of `rating` per `group` (numeric)}
#' }
#'
#' @examples
#' tibble::glimpse(ord_abc)
"ord_abc"

#' Movie ratings
#'
#' This is a reformatted version of the movies data from Liddell & Kruschke (2018). They contain star ratings of movies, collected from Amazon.com in the Movies and TV category, sorted by relevance, and the first 36 entries with at least 500 reviews.
#'
#' @format A data frame with 180 rows and 5 columns:
#' \describe{
#'   \item{id}{Unique row identifier for each movie (ordered factor with levels `1` to `36`)}
#'   \item{title}{Movie title (character)}
#'   \item{rating}{Ordinal star rating level (ordered factor with five levels: `"1"` to `"5"`)}
#'   \item{count}{The number of occasions for each level of `rating` per `id` (numeric)}
#'   \item{prop}{The proportions of counts within level of `id` (numeric)}
#' }
#'
#' @source
#' Liddell, T. M., & Kruschke, J. K. (2018).
#' Analyzing ordinal data with metric models: What could possibly go wrong?
#' \emph{Journal of Experimental Social Psychology, 79}, 328–348.
#' <https://doi.org/10.1016/j.jesp.2018.08.009>
#'
#' @examples
#' tibble::glimpse(movies)
"movies"

#' Joke ratings
#'
#' This is a reformatted version of the joke rating data from Kruschke & Vollmer (2014).
#'
#' @format A data frame with 4,425 rows and 8 columns:
#' \describe{
#'   \item{subj}{Unique participant identifier (factor with levels `1` to `177`)}
#'   \item{joke_id}{Unique joke identifier (factor with 25 levels)}
#'   \item{found}{The moral foundation targeted by the joke; (factor with five levels: `Auth`, `Care`, `Fair`, `Loya`, and `Puri`)}
#'   \item{joke}{Unique joke identifier, the label of which begins with the targeted foundation (factor with 25 levels)}
#'   \item{moral}{The score from the Moral Foundations Questionnaire (MFQ; Graham et al., 2011) of that participant on that foundation (numeric)}
#'   \item{z_moral}{Standardized version of `moral` (numeric)}
#'   \item{z_moral_wf}{Version of `moral` standardized within `found` (numeric)}
#'   \item{funny}{Ordinal funniness rating (ordered factor with seven levels: `"1"` to `"7"`)}
#' }
#'
#' @source
#' Graham, J., Nosek, B. A., Haidt, J., Iyer, R., Koleva, S., & Ditto, P. H. (2011).
#' Mapping the moral domain.
#' \emph{Journal of Personality and Social Psychology, 101}(2), 366–385.
#' <https://doi.org/10.1037/a0021847>
#'
#' Kruschke, J. K., & Vollmer, A. (2014).
#' Moral foundation sensitivity and perceived humor.
#' \emph{Available at SSRN}.
#' <https://doi.org/10.2139/ssrn.2519218>
#'
#' @examples
#' tibble::glimpse(humor)
"humor"

#' Alcohol Preferences of Sexually Deprived Male Fruit flies
#'
#' This is a reformatted version of the `ShohatOphirKAMH2012dataReduced.csv` used in *DBDA2*, as published in Shohat-Ophir et al (2012). The data are more fully explained in an exercise at the end of Chapter 18 of *DBDA3*.
#'
#' @format A data frame with 20 rows and 6 columns:
#' \describe{
#'   \item{group}{Experimental group (factor with two levels: `"mated"` and `"rejected"`)}
#'   \item{id_in_group}{Subject identification number, within each experimental group (factor with ten levels: `"1"` to `"10"`)}
#'   \item{non_ethanol_3_day}{Summary preference score of non-ethanol across days 6–8 (numeric values)}
#'   \item{ethanol_3_day}{Summary preference score of ethanol across days 6–8 (numeric values)}
#'   \item{total}{The sum of `non_ethanol_3_day` and `ethanol_3_day` (numeric values)}
#'   \item{pref}{Summary preference score, which is `(ethanol_3_day - non_ethanol_3_day) / total`, rounded to three digits (numeric values)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' Shohat-Ophir, G., Kaun, K. R., Azanchi, R., Mohammed, H., & Heberlein, U. (2012).
#' Sexual deprivation increases ethanol intake in drosophila.
#' \emph{Science}, 335, 1351–1355.
#' <https://doi.org/10.1126/science.1215932>
#'
#' @examples
#' tibble::glimpse(depriv)
"depriv"

#' Fish data
#'
#' These data are originally from a zero-inflated regression tutorial by UCLA Statistical Methods and Data Analytics (n.d.). They are results from a survey of 250 groups at a state park. The researchers wanted to know what factors influenced how many fish each group caught.
#'
#' @format A data frame with 250 rows and 5 columns:
#' \describe{
#'   \item{count}{The number of fish caught (integer values)}
#'   \item{child}{The number of children per group (integer values)}
#'   \item{persons}{The total number of people per group (integer values)}
#'   \item{livebait}{Whether the group used live bait (factor with two levels: `"0"` and `"1"`)}
#'   \item{camper}{Whether the group brought a camper (factor with two levels: `"0"` and `"1"`)}
#' }
#'
#' @source
#' UCLA Statistical Methods and Data Analytics. (n.d.).
#' Fish dataset \[Data set\].
#' <https://stats.idre.ucla.edu/stat/data/fish.csv>
#'
#' UCLA Statistical Methods and Data Analytics. (n.d.).
#' \emph{Zero-inflated Poisson regression | R data analysis examples}.
#' Office of Advanced Research Computing.
#' Retrieved September 4, 2026, from
#' <https://stats.oarc.ucla.edu/r/dae/zip/>
#'
#' @examples
#' tibble::glimpse(fish)
"fish"

#' Negative-binomial data for unbounded count regression
#'
#' A synthetic data set of a single unbounded count predicted variable `y`, and two continuous predictor variables `x`, made originally for Chapter 23 of *DBDA3*.
#'
#' @format A data frame with 1000 rows and 3 columns:
#' \describe{
#'   \item{x}{A numeric variable uniformly distributed between -1 and 3.}
#'   \item{y}{A count variable (integer values)}
#'   \item{y_m}{The `mu` parameter underlying the `y` count (numeric values).}
#' }
#'
#' @examples
#' tibble::glimpse(negbin_1met)
"negbin_1met"
