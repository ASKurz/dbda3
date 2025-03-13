#' The logit function
#'
#' Transform numeric values with the logit function.
#'
#' @param x A vector of numeric values in the domain of \eqn{\begin{bmatrix} 0, 1 \end{bmatrix}}.
#'
#' @returns A vector of real numeric values the same length of `x`.
#'
#' @details
#' The logit function follows the form
#'
#' \deqn{f(x) = \frac{x}{1 - x},}
#'
#' for \eqn{x} in the domain of \eqn{\begin{bmatrix} 0, 1 \end{bmatrix}}, and returns real values. When \eqn{x} is a probability value, the logit is also called the "log-odds," as it is the same as the logarithm of the odds, \eqn{x / (1 - x)}. The output of the `logit()` function is the same as the output from the `qlogis()` function from the [stats] package, given the default settings for `qlogis()`.
#'
#' @seealso [logistic()] for the inverse function.
#'
#' @examples
#' # Load
#' library(dplyr, warn.conflicts = FALSE)
#' library(ggplot2)
#'
#' # Single value
#' logit(0.5)
#'
#' # Compare with `qlogis()`
#' x <- runif(n = 1, min = 0.001, max = 0.999)
#' logit(x) == qlogis(x)
#'
#' # Plot the logit function
#' data.frame(x = seq(from = 0, to = 1, by = 0.01)) |>
#'   mutate(logit = logit(x)) |>
#'   ggplot(aes(x = x, y = logit)) +
#'   geom_point()
#'
#' @export
logit <- function(x) {

  # Check
  checkmate::assert_numeric(x, lower = 0, upper = 1)

  log(x / (1 - x))
}

