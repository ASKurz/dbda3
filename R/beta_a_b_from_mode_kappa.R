#' Compute beta a and b parameters from mode and kappa
#'
#' For a given mode and concentration (kappa), compute the a and b parameters for the beta distribution. This is meant to make it easier to assign beta priors to Bayesian models.
#'
#' @param mode A numeric value defining the mode of the beta distribution.
#' @param kappa A numeric value defining the concentration (kappa) of the beta distribution.
#'
#' @details
#' In the \{stats\} package, the beta distribution (execute `?Beta`) is parameterized in terms of `shape1` \eqn{= a} and `shape2` \eqn{= b}. We can describe \eqn{x} as beta distributed if it has the density
#'
#' \deqn{f(x; a, b) = \frac{x^{a - 1}(1 - x)^{b - 1}}{B(a, b)}.}
#'
#' Importantly, the beta-distributed variable \eqn{x} has the constraints \eqn{0 \leq x \leq 1}, and its two parameters have the constraints \eqn{a > 0} and \eqn{b > 0}. In the denominator of the equation, \eqn{B()} is the beta function, which acts as a normalizing constant. We can compute the mode of the beta distribution \eqn{\omega} as
#'
#' \deqn{\omega = \frac{a - 1}{a + b - 2},}
#'
#' and we can compute the spread, or *concentration* \eqn{\kappa}, of the beta distribution as
#'
#' \deqn{\kappa = a + b.}
#'
#' Further, for a given \eqn{\omega} and \eqn{\kappa}, we can solve for \eqn{a} with
#'
#' \deqn{a = \omega(\kappa - 2) + 1,}
#'
#' and solve for \eqn{b} with
#'
#' \deqn{b = (1 - \omega)(\kappa - 2) + 1,}
#'
#' for \eqn{\kappa \gt 2}.
#'
#' @returns A named list with two elements, `a` and `b`, each containing a numeric value for the respective parameters of the beta distribution corresponding to the given `mode` and `kappa` values.
#'
#' @seealso [beta_a_b_from_mean_kappa()] for a mean and concentration parameterization, and [beta_a_b_from_mean_sd()] for a mean and standard deviation parameterization.
#'
#' @examples
#' beta_a_b_from_mode_kappa(mode = 0.5, kappa = 3)
#' beta_a_b_from_mode_kappa(0.25, 30)
#'
#' rbind(
#'   beta_a_b_from_mode_kappa(0.5, 3),
#'   beta_a_b_from_mode_kappa(0.25, 30))
#' dplyr::bind_rows(
#'   beta_a_b_from_mode_kappa(0.5, 3),
#'   beta_a_b_from_mode_kappa(0.25, 30))
#'
#' my_parameters <- beta_a_b_from_mode_kappa(mode = 0.5, kappa = 3)
#' my_parameters$a
#' my_parameters[2]
#'
#' @export
beta_a_b_from_mode_kappa <- function(mode, kappa) {

  checkmate::assert_numeric(mode)
  checkmate::assert_numeric(kappa)

  if (mode <= 0 | mode >= 1) stop("Must have 0 < `mode` < 1.")
  if (kappa <= 2) stop("`kappa` must be > 2 for mode parameterization.")

  a <- mode * (kappa - 2) + 1
  b <- (1.0 - mode) * (kappa - 2) + 1

  return(list(a = a, b = b))

}

