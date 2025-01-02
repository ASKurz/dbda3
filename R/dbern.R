#' The Bernoulli likelihood function
#'
#' Density for the Bernoulli likelihood function for a set of trials. The function is parameterized for `n` trials, a probability of \eqn{\frac{z}{n}} for values of \eqn{1}, and probability of \eqn{1 - \frac{z}{n}} for values of \eqn{0}.
#'
#' @param x a numeric vector of success probabilities ranging from `0` to `1`.
#' @param z the number of `1`'s (e.g., heads in coin flips, successes in pass/fail trials).
#' @param n the total number of Bernoulli trials.
#'
#' @returns A numeric vector of size `x` of density values.
#'
#' @examples
#' dbern(x = seq(from = 0, to = 1, by = 0.1), z = 1, n = 2)
#'
#' data.frame(theta = seq(from = 0, to = 1, length.out = 11)) |>
#'   dplyr::mutate(density = dbern(x = theta, z = 4, n = 7))
#'
#' @export
dbern <- function(x, z = NULL, n = NULL) {

  checkmate::assert_numeric(x, lower = 0, upper = 1)
  checkmate::assert_numeric(z, lower = 0)
  checkmate::assert_numeric(n, lower = 1)
  # checkmate::assert_scalar(z)
  # checkmate::assert_scalar(n)

  return(x^z * (1 - x)^(n - z))

}

