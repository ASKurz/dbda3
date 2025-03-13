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
#' @format A tibble with 300 rows and 4 columns:
#' \describe{
#'   \item{height}{numeric values (in inches)}
#'   \item{weight}{numeric values (in pounds)}
#'   \item{height_z}{numeric values (standardized version of `height`)}
#'   \item{weight_z}{numeric values (standardized version of `weight`)}
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










