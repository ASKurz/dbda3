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
#'
"therapeutic_touch"

#' Retrospective chart review data
#'
#' This is a reformatted version of the t-distributed data used in Figure 16.5 of *DBDA2* (p. 460), originally published in Boyd et al (1998), and further highlighted in Holcomb & Spalsbury (2005).
#'
#' @format A tibble with 178 rows and 8 columns:
#' \describe{
#'   \item{obsno}{Participant number (numeric values ranging from `1` to `178`)}
#'   \item{age}{Years old (numeric values ranging from `1` to `178`)}
#'   \item{sex}{Binary (factor)}
#'   \item{alkphos}{Alkaline phosphatase (numeric values in liters)}
#'   \item{lab}{Lab (factor)}
#'   \item{cammol}{Calcium (numeric values in mmol/L)}
#'   \item{phosmmol}{Inorganic phosphorus (numeric values in mmol/L)}
#'   \item{age_group}{Binned age (factor)}
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
#'
"chart_review"

#' Hair and eye color data
#'
#' This is a reformatted version of the `HairEyeColor.csv` used in *DBDA2*, which were themselves from the `HairEyeColor` data from the {datasets} package (`?datasets::HairEyeColor`).
#'
#' @format A tibble with 16 rows and 3 columns:
#' \describe{
#'   \item{hair}{Hair color (factor with 4 levels)}
#'   \item{eye}{Eye color (factor with 4 levels)}
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
#'
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
#'   \item{treatment}{The experimental groups (ordered factor)}
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
#'
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

#' Example data
#'
#' This is the description of the example `my_pkg_data` data set, created under the direction of the *R Packages (2e)* book, Section 7.1.2.
#'
#' @format A vector of 1000 integers created with the `sample()` function, without reference to a specific seed value.
#'
#' @source <https://r-pkgs.org/data.html#sec-documenting-data>
"my_pkg_data"

#' Height and Weight data for 300 cases
#'
#' This is a reformatted version of the `HtWtData300.csv` used in *DBDA2*. The data were originally made with Kruschke's `HtWtDataGenerator()` function.
#'
#' @format A data frame with 30 rows and 3 columns:
#' \describe{
#'   \item{male}{numeric values coded `0` for women and `1` for  men}
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
#'
"height_weight_300"

#' Height and Weight data for 30 cases
#'
#' This is a reformatted version of the `HtWtData30.csv` used in *DBDA2*. The data were originally made with Kruschke's `HtWtDataGenerator()` function.
#'
#' @format A data frame with 30 rows and 3 columns:
#' \describe{
#'   \item{male}{numeric values coded `0` for women and `1` for  men}
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
#'
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
#'
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
#'
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
#'
"normal_panels"

#' Scholastic Aptitude Test (SAT) data
#'
#' This is a reformatted version of the `Guber1999data.csv` used in *DBDA2*, originally published in Guber (1992). The data are average values for the 50 US states.
#'
#' @format A data frame with 50 rows and 8 columns:
#' \describe{
#'   \item{state}{One of the 50 US states (character values ranging from `"Alabama"` to `"Wyoming"`)}
#'   \item{spend}{The average spending per student (numeric values, in thousands of dolars)}
#'   \item{stutearat}{The student/teacher ratio (numeric values)}
#'   \item{salary}{The average teacher salary (numeric values, in thousands of dolars)}
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
#'
"sat"

#' Kentucky Derby data
#'
#' [To be completed later]
#'
#' @format A data frame with 143 rows and 8 columns:
#' \describe{
#'   \item{year}{ (numeric values)}
#'   \item{winner}{ (character values )}
#'   \item{surface}{ (character values )}
#'   \item{condition}{ (character values )}
#'   \item{starters}{ (numeric values)}
#'   \item{poleposition}{ (numeric values)}
#'   \item{time}{ (numeric values)}
#'   \item{speed}{ (numeric values)}
#' }
#'
#' @source
#' Some source
#'
#' @examples
#' tibble::glimpse(derby)
#'
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
#'
"income"

#' Trivariate-Normal Data
#'
#' Two data sets (`two_x_cor` and `two_x_uncor`) used in Chapter 16 of *DBDA3* to show the consequences of weakly- and strongly-correlated predictors in simple regression models of the form \eqn{y_i = \beta_0 + \beta_1 x1_i + \beta_2 x2_i + \epsilon}.
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
#'
"two_x_cor"

#' @rdname two_x_cor
#' @format NULL
"two_x_uncor"

