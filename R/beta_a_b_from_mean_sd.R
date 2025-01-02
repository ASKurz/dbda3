#' Compute beta a and b parameters from mean and standard deviation
#'
#' For a given mean and standard deviation, compute the a and b parameters for the beta distribution. This is meant to make it easier to assign beta priors to Bayesian models.
#'
#' @param mean A numeric value defining the mean of the beta distribution.
#' @param sd A numeric value defining the standard deviation of the beta distribution.
#'
#' @details
#' In the \{stats\} package, the beta distribution (execute `?Beta`) is parameterized in terms of `shape1` \eqn{= a} and `shape2` \eqn{= b}. We can describe \eqn{x} as beta distributed if it has the density
#'
#' \deqn{f(x; s, r) = \frac{x^{a - 1}(1 - x)^{b - 1}}{B(a, b)}.}
#'
#' Importantly, the beta-distributed variable \eqn{x} has the constraints \eqn{0 \leq x \leq 1}, and its two parameters have the constraints \eqn{a > 0} and \eqn{b > 0}. In the denominator of the equation, \eqn{B()} is the beta function, which acts as a normalizing constant. We can compute the mean of the beta distribution \eqn{\mu} as
#'
#' \deqn{\mu = \frac{a}{a + b},}
#'
#' and we can compute the standard deviation \eqn{\sigma} of the beta distribution as
#'
#' \deqn{\sigma = \sqrt{\frac{\mu(1 - \mu)}{(a + b + 1)}},}
#'
#' where the \eqn{a + b} is also sometimes called the concentration \eqn{\kappa}.
#'
#' Further, for a given \eqn{\mu} and \eqn{\sigma}, we can solve for \eqn{a} with
#'
#' \deqn{a = \mu \left( \frac{\mu(1 - \mu)}{\sigma^2} - 1 \right),}
#'
#' and solve for \eqn{b} with
#'
#' \deqn{b = (1 - \mu) \left( \frac{\mu(1 - \mu)}{\sigma^2} - 1 \right).}
#'
#' However, we can also use the equation for \eqn{\sigma} above to solve for \eqn{\kappa}
#'
#' \deqn{\kappa = \frac{\mu(1 - \mu)}{\sigma^2} - 1,}
#'
#' which will then allow us to solve for \eqn{a} with the simpler
#'
#' \deqn{a = \mu\kappa,}
#'
#' and solve for \eqn{b} with the simpler
#'
#' \deqn{b = (1 - \mu)\kappa,}
#'
#' which is the approach we take for the `beta_a_b_from_mean_sd()` function.
#'
#' @returns A named list with two elements, `a` and `b`, each containing a numeric value for the respective parameters of the beta distribution corresponding to the given `mean` and `sd` values.
#'
#' @seealso [beta_a_b_from_mean_kappa()] for a mean and concentration parameterization, and [beta_a_b_from_mode_kappa()] for a mode and concentration parameterization.
#'
#' @examples
#' beta_a_b_from_mean_sd(mean = 0.5, sd = 0.2)
#' beta_a_b_from_mean_sd(0.25, 0.25)
#'
#' rbind(
#'   beta_a_b_from_mean_sd(0.5, 0.2),
#'   beta_a_b_from_mean_sd(0.25, 0.25))
#' dplyr::bind_rows(
#'   beta_a_b_from_mean_sd(0.5, 0.2),
#'   beta_a_b_from_mean_sd(0.25, 0.25))
#'
#' my_parameters <- beta_a_b_from_mean_sd(mean = 0.5, sd = 0.2)
#' my_parameters$a
#' my_parameters[2]
#'
#' @export
beta_a_b_from_mean_sd <- function(mean, sd) {

  checkmate::assert_numeric(mean)
  checkmate::assert_numeric(sd)

  if (mean <= 0 | mean >= 1) stop("Must have 0 < `mean` < 1.")
  if (sd <= 0) stop("sd must be > 0")
  kappa <- mean * (1 - mean) / sd^2 - 1
  if (kappa <= 0) stop("Invalid combination of `mean` and `sd`.")

  a <- mean * kappa
  b <- (1.0 - mean) * kappa

  return(list(a = a, b = b))

}

