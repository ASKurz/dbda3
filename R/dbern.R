#' The Bernoulli likelihood function
#'
#' Density for the Bernoulli likelihood function for a set of trials. The function is parameterized for `n` trials, a probability of \eqn{\frac{z}{n}} for values of \eqn{1}, and probability of \eqn{1 - \frac{z}{n}} for values of \eqn{0}.
#'
#' @param x a numeric vector of success probabilities ranging from `0` to `1`.
#' @param z the number of `1`'s (e.g., heads in coin flips, successes in pass/fail trials).
#' @param n the total number of Bernoulli trials.
#'
#' @details
#' If we let the outcome of the \eqn{i^{th}} trial be \eqn{y_i}, and let the set of outcomes be \eqn{\{y_i\}}, we can summarize the total number of \eqn{1}'s or \emph{successful} trials as \eqn{z}, and the total number of trials as \eqn{N}. We can compute likelihood of an entire set of multiple independent flips as
#'
#' \deqn{p(\{y_i\} \mid \theta) = \theta^z \, (1 - \theta)^{(N - z)},}
#'
#' where \eqn{\theta} is the overall success probability for the set of outcomes.
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
  # Checks
  checkmate::assert_numeric(x, lower = 0, upper = 1)
  checkmate::assert_numeric(z, lower = 0)
  checkmate::assert_numeric(n, lower = 1)

  return(x^z * (1 - x)^(n - z))
}

