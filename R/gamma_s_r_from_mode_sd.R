#' Compute gamma s and r parameters from mode and standard deviation
#'
#' For a given mode and standard deviation, compute the shape (s) and rate (r) parameters for the gamma distribution. This is meant to make it easier to assign gamma priors to Bayesian models.
#'
#' @param mode A numeric value defining the mode of the gamma distribution.
#' @param sd A numeric value defining the standard deviation of the gamma distribution.
#'
#' @details
#' In the \{stats\} package, the gamma distribution (execute `?GammaDist`) is parameterized in terms of `shape` and `rate`. It can also be parameterized in terms of `shape` and `scale`, the later of which is the same as `1/rate`. Here we focus on the first `shape` and `rate` parameterization. We can describe \eqn{x} as gamma distributed if it has the density
#'
#' \deqn{f(x; s, r) = \frac{x^{s - 1}\ e^{-rx}\ r^s} {\Gamma(s)}.}
#'
#' Importantly, the gamma-distributed variable \eqn{x} has the constraint \eqn{x \gt 0}, and its two parameters have the constraints \eqn{s > 0} and \eqn{r > 0}. In the denominator of the equation, \eqn{\Gamma()} is the gamma function (execute `?gamma`). We can compute the mode of the gamma distribution \eqn{\omega} as
#'
#' \deqn{\omega = \frac{s - 1}{r},}
#'
#' for \eqn{s \gt 1}. We can compute the standard deviation \eqn{\sigma} of the gamma distribution as
#'
#' \deqn{\sigma = \frac{\sqrt{s}}{r}.}
#'
#' Further, for a given \eqn{\omega} and \eqn{\sigma}, we can solve for \eqn{s} with
#'
#' \deqn{s = 1 + \omega r,}
#'
#' and solve for \eqn{r} with
#'
#' \deqn{r = \frac{\omega + \sqrt{\omega^2 + 4 \sigma^2}}{2 \sigma^2},}
#'
#' for \eqn{\omega \gt 0} and \eqn{\sigma \gt 0}.
#'
#' @returns A named list with two elements, `shape` and `rate`, each containing a numeric value for the respective parameters of the gamma distribution corresponding to the given `mode` and `sd` values.
#'
#' @examples
#' gamma_s_r_from_mode_sd(mode = 10, sd = 10)
#' gamma_s_r_from_mode_sd(10, 2)
#'
#' rbind(
#'   gamma_s_r_from_mode_sd(10, 10),
#'   gamma_s_r_from_mode_sd(10, 2))
#' dplyr::bind_rows(
#'   gamma_s_r_from_mode_sd(10, 10),
#'   gamma_s_r_from_mode_sd(10, 2))
#'
#' my_parameters <- gamma_s_r_from_mode_sd(mode = 10, sd = 10)
#' my_parameters$shape
#' my_parameters[2]
#'
#' @seealso [gamma_s_r_from_mean_sd()] for a mean and standard deviation parameterization.
#'
#' @export
gamma_s_r_from_mode_sd <- function(mode, sd) {

  checkmate::assert_numeric(mode)
  checkmate::assert_numeric(sd)

  if (mode <= 0) stop("`mode` must be > 0")
  if (sd   <= 0) stop("`sd` must be > 0")

  rate  <- (mode + sqrt(mode^2 + 4 * sd^2)) / (2 * sd^2)
  shape <- 1 + mode * rate

  return(list(shape = shape, rate = rate))

}

