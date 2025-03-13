#' Simulate heights and weights
#'
#' A minor revision of the `HtWtDataGenerator()` function, as introduced in Chapter 17 of *DBDA2*. The function is based on parameter estimates from Table III in Brainard & Burmaster (1992, p. 271), who showed that adult human height and log(weight) data follow an approximate multivariate normal distribution. More specifically, males are modeled with their own multivariate normal distribution, and females are modeled as a mixture of two multivariate normal distributions. The estimates were based on a sample of noninstitutionalized US adults from 1976 to 1980.
#'
#' @param n A single integer value for the number of simulated observations, with a lower limit of `1`.
#' @param male_prob A single numeric value ranging from `0` to `1` indicating the probability an observation will be of `male == 1`. Defaults to `0.5`.
#' @param seed A single numeric value passed to the `seed` argument in `set.seed()`, to make the results computationally reproducible. Defaults to `47405`.
#'
#' @returns A data frame with rows equal to `n`, and three columns:
#' \describe{
#'   \item{male}{numeric values for which `0` indicates female and `1` indicates male}
#'   \item{height}{numeric values rounded to the first decimal place (in inches)}
#'   \item{weight}{numeric values rounded to the first decimal place (in pounds)}
#' }
#'
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan}.
#' Academic Press.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' Brainard, J., & Burmaster, D. E. (1992).
#' Bivariate distributions for height and weight of men and women in the United States.
#' \emph{Risk Analysis, 12}(2), 267–275
#' <https://doi.org/10.1111/j.1539-6924.1992.tb00674.x>
#'
#' @examples
#'
#' height_weight_generator(n = 1)
#' height_weight_generator(n = 6, male_prob = 0.7, seed = 1)
#'
#' @export
height_weight_generator <- function(n, male_prob = 0.5, seed = 47405) {

  # Checks
  checkmate::assert_int(n, lower = 1)
  checkmate::assert_numeric(male_prob, lower = 0, upper = 1)
  checkmate::assert_numeric(seed)

  # Male MVN distribution parameters
  height_male_mu <- 69.18;    height_male_sd <- 2.87
  log_weight_male_mu <- 5.14; log_weight_male_sd <- 0.17
  male_rho <- 0.42
  male_mean <- c(height_male_mu, log_weight_male_mu)
  male_sigma <- matrix(c(height_male_sd^2, male_rho * height_male_sd * log_weight_male_sd,
                         male_rho * height_male_sd * log_weight_male_sd, log_weight_male_sd^2),
                       nrow = 2)

  # Female cluster 1 MVN distribution parameters
  height_female_mu_1 <- 63.11;    height_female_sd_1 <- 2.76
  log_weight_female_mu_1 <- 5.06; log_weight_female_sd_1 <- 0.24
  female_rho_1 <- 0.41
  female_mean_1 <- c(height_female_mu_1, log_weight_female_mu_1)
  female_sigma_1 <- matrix(c(height_female_sd_1^2, female_rho_1 * height_female_sd_1 * log_weight_female_sd_1,
                             female_rho_1 * height_female_sd_1 * log_weight_female_sd_1, log_weight_female_sd_1^2),
                           nrow = 2)

  # Female cluster 2 MVN distribution parameters
  height_female_mu_2 <- 64.36;    height_female_sd_2 <- 2.49
  log_weight_female_mu_2 <- 4.86; log_weight_female_sd_2 <- 0.14
  female_rho_2 <- 0.44
  female_mean_2 <- c(height_female_mu_2, log_weight_female_mu_2)
  female_sigma_2 <- matrix(c(height_female_sd_2^2, female_rho_2 * height_female_sd_2 * log_weight_female_sd_2,
                             female_rho_2 * height_female_sd_2 * log_weight_female_sd_2, log_weight_female_sd_2^2),
                           nrow = 2)

  # Female cluster probabilities
  female_prob_1 <- 0.46
  female_prob_2 <- 1 - female_prob_1

  # Randomly generate data values from those MVN distributions
  if (!is.null(seed)) set.seed(seed)
  datamatrix <- matrix(0, nrow = n, ncol = 3)
  colnames(datamatrix) <- c("male", "height", "weight")
  male_val <- 1; female_val <- 0  # Arbitrary coding values
  for (i in 1:n) {
    # Generate `sex`
    sex <- sample(c(male_val, female_val), size = 1, replace = TRUE, prob = c(male_prob, 1 - male_prob))
    if (sex == male_val) datum <- MASS::mvrnorm(n = 1, mu = male_mean, Sigma = male_sigma)
    if (sex == female_val) {
      female_cluster <- sample(c(1, 2), size = 1, replace = TRUE, prob = c(female_prob_1, female_prob_2))
      if (female_cluster == 1) datum <- MASS::mvrnorm(n = 1, mu = female_mean_1, Sigma = female_sigma_1)
      if (female_cluster == 2) datum <- MASS::mvrnorm(n = 1, mu = female_mean_2, Sigma = female_sigma_2)
    }
    datamatrix[i, ] <- c(sex, round(c(datum[1], exp(datum[2])), digits = 1))
  }

  data.frame(datamatrix)
}

