#' Compute gamma s and r parameters from mean and standard deviation
#'
#' For a given mean and standard deviation, compute the shape (s) and rate (r) parameters for the gamma distribution. This is meant to make it easier to assign gamma priors to Bayesian models.
#'
#' @param mean A numeric value defining the mean of the gamma distribution.
#' @param sd A numeric value defining the standard deviation of the gamma distribution.
#'
#' @details
#' In the \{stats\} package, the gamma distribution (execute `?GammaDist`) is parameterized in terms of `shape` and `rate`. It can also be parameterized in terms of `shape` and `scale`, the later of which is the same as `1/rate`. Here we focus on the first `shape` and `rate` parameterization. We can describe \eqn{x} as gamma distributed if it has the density
#'
#' \deqn{f(x; s, r) = \frac{x^{s - 1}\ e^{-rx}\ r^s} {\Gamma(s)}.}
#'
#' Importantly, the gamma-distributed variable \eqn{x} has the constraint \eqn{x \gt 0}, and its two parameters have the constraints \eqn{s > 0} and \eqn{r > 0}. In the denominator of the equation, \eqn{\Gamma()} is the gamma function (execute `?gamma`). We can compute the mean of the gamma distribution \eqn{\mu} as
#'
#' \deqn{\mu = \frac{s}{r},}
#'
#' and we can compute the standard deviation \eqn{\sigma} of the gamma distribution as
#'
#' \deqn{\sigma = \frac{\sqrt{s}}{r}.}
#'
#' Further, for a given \eqn{\mu} and \eqn{\sigma}, we can solve for \eqn{s} with
#'
#' \deqn{s = \frac{\mu^2}{\sigma^2},}
#'
#' and solve for \eqn{r} with
#'
#' \deqn{r = \frac{\mu}{\sigma^2},}
#'
#' for \eqn{\mu \gt 0} and \eqn{\sigma \gt 0}.
#'
#' @returns A named list with two elements, `shape` and `rate`, each containing a numeric value for the respective parameters of the gamma distribution corresponding to the given `mean` and `sd` values.
#'
#' @examples
#' gamma_s_r_from_mean_sd(mean = 10, sd = 10)
#' gamma_s_r_from_mean_sd(10, 2)
#'
#' rbind(
#'   gamma_s_r_from_mean_sd(10, 10),
#'   gamma_s_r_from_mean_sd(10, 2))
#' dplyr::bind_rows(
#'   gamma_s_r_from_mean_sd(10, 10),
#'   gamma_s_r_from_mean_sd(10, 2))
#'
#' my_parameters <- gamma_s_r_from_mean_sd(mean = 10, sd = 10)
#' my_parameters$shape
#' my_parameters[2]
#'
#' @seealso [gamma_s_r_from_mode_sd()] for a mode and standard deviation parameterization.
#'
#' @export
gamma_s_r_from_mean_sd <- function(mean, sd) {
  # Checks
  checkmate::assert_numeric(mean)
  checkmate::assert_numeric(sd)
  if (mean <= 0) stop("`mean` must be > 0")
  if (sd   <= 0) stop("`sd` must be > 0")

  shape <- mean^2 / sd^2
  rate  <- mean   / sd^2
  return(list(shape = shape, rate = rate))
}

