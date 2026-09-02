#' Compute highest density intervals of a grid from an inverse cumulative density function
#'
#' Given the name of an R function for an inverse cumulative density function (ICDF), compute the highest density interval (HDI) of interest.
#'
#' @param name An R function name for the ICDF of the distribution of interest (e.g., `qbeta` for the beta distribution, `qnorm` for the normal distribution).
#' @param prob A single numeric value in the range \eqn{[0, 1]} for the desired probability mass of the HDI region. Defaults to `0.95`.
#' @param tol A positive finite numeric value passed to the `tol` argument in the `stats::optimize()` function. Defaults to `1e-8`.
#' @param ... Additional named arguments passed on to the ICDF identified in `name`.
#'
#' @returns A numeric vector of the HDI limits.
#'
#' @seealso [in_hdi_grid()] to compute highest density intervals from a grid.
#'
#' @examples
#' hdi_of_icdf(qbeta, shape1 = 30, shape2 = 12)
#' hdi_of_icdf(qnorm)
#'
#' @importFrom stats optimize
#' @export
hdi_of_icdf <- function(name, prob = 0.95, tol = 1e-8, ...) {
  # Checks
  checkmate::assert_numeric(prob, lower = 0, upper = 1)
  checkmate::assert_numeric(tol, lower = 0, finite = TRUE)

  incredible_mass <- 1.0 - prob
  interval_width <- function(low_tail_prob, name, prob, ...) {
    name(prob + low_tail_prob, ...) - name(low_tail_prob, ...)
  }
  opt_info <- optimize(
    f = interval_width,
    interval = c(0, incredible_mass),
    name = name, prob = prob,
    tol = tol,
    ...)
  hdi_lower_tail_prob <- opt_info$minimum

  return(c(name(hdi_lower_tail_prob, ...),
           name(prob + hdi_lower_tail_prob, ...)))
}

