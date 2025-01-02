#' Compute beta a and b parameters from mean and kappa
#'
#' For a given mean and concentration (kappa), compute the a and b parameters for the beta distribution. This is meant to make it easier to assign beta priors to Bayesian models.
#'
#' @param mean A numeric value defining the mean of the beta distribution.
#' @param kappa A numeric value defining the concentration (kappa) of the beta distribution.
#'
#' @details
#' In the \{stats\} package, the beta distribution (execute `?Beta`) is parameterized in terms of `shape1` \eqn{= a} and `shape2` \eqn{= b}. We can describe \eqn{x} as beta distributed if it has the density
#'
#' \deqn{f(x; a, b) = \frac{x^{a - 1}(1 - x)^{b - 1}}{B(a, b)}.}
#'
#' Importantly, the beta-distributed variable \eqn{x} has the constraints \eqn{0 \leq x \leq 1}, and its two parameters have the constraints \eqn{a > 0} and \eqn{b > 0}. In the denominator of the equation, \eqn{B()} is the beta function, which acts as a normalizing constant. We can compute the mean of the beta distribution \eqn{\mu} as
#'
#' \deqn{\mu = \frac{a}{a + b},}
#'
#' and we can compute the spread, or *concentration* \eqn{\kappa}, of the beta distribution as
#'
#' \deqn{\kappa = a + b.}
#'
#' Further, for a given \eqn{\mu} and \eqn{\kappa}, we can solve for \eqn{a} with
#'
#' \deqn{a = \mu\kappa,}
#'
#' and solve for \eqn{b} with
#'
#' \deqn{b = (1 - \mu)\kappa.}
#'
#' @returns A named list with two elements, `a` and `b`, each containing a numeric value for the respective parameters of the beta distribution corresponding to the given `mean` and `kappa` values.
#'
#' @seealso [beta_a_b_from_mean_sd()] for a mean and standard deviation parameterization, and [beta_a_b_from_mode_kappa()] for a mode and concentration parameterization.
#'
#' @examples
#' beta_a_b_from_mean_kappa(mean = 0.5, kappa = 2)
#' beta_a_b_from_mean_kappa(0.25, 200)
#'
#' rbind(
#'   beta_a_b_from_mean_kappa(0.5, 2),
#'   beta_a_b_from_mean_kappa(0.25, 200))
#' dplyr::bind_rows(
#'   beta_a_b_from_mean_kappa(0.5, 2),
#'   beta_a_b_from_mean_kappa(0.25, 200))
#'
#' my_parameters <- beta_a_b_from_mean_kappa(mean = 0.5, kappa = 2)
#' my_parameters$a
#' my_parameters[2]
#'
#' @export
beta_a_b_from_mean_kappa <- function(mean, kappa) {

  checkmate::assert_numeric(mean)
  checkmate::assert_numeric(kappa)

  if (mean <= 0 | mean >= 1) stop("Must have 0 < `mean` < 1.")
  if (kappa <= 0) stop("`kappa` must be > 0.")

  a <- mean * kappa
  b <- (1.0 - mean) * kappa
  return(list(a = a, b = b))

}

