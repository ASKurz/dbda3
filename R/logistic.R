#' The logistic function
#'
#' Transform numeric values with the standard logistic function.
#'
#' @param x A vector of numeric values.
#'
#' @returns A vector of numeric values the same length of `x`, in the domain of \eqn{\begin{bmatrix} 0, 1\end{bmatrix}}.
#'
#' @details
#' The standard logistic function follows the form
#'
#' \deqn{f(x) = \frac{1}{1 + \exp(-x)},}
#'
#' for real values of \eqn{x}. This is a special case of the logistic function,
#'
#' \deqn{f(x) = \frac{1}{1 + \exp(-(x - \mu) / \sigma)},}
#'
#' where \eqn{\mu} is the location parameter, and \eqn{\sigma} is the scale. The logistic function is available as the `plogis()` function from the [stats] package. When using its default settings the output from `plogis()` is equivalent to the output from the `logistic()` function.
#'
#' @seealso [logit()] for the inverse function.
#'
#' @examples
#' # Load
#' library(dplyr, warn.conflicts = FALSE)
#' library(ggplot2)
#'
#' # Single value
#' logistic(0)
#'
#' # Compare with `plogis()`
#' x <- runif(n = 1, min = -10, max = 10)
#' logistic(x) == plogis(x)
#'
#' # Plot the logistic function
#' data.frame(x = seq(from = -5.5, to = 5.5, by = 0.1)) |>
#'   mutate(logistic = logistic(x)) |>
#'   ggplot(aes(x = x, y = logistic)) +
#'   geom_point() +
#'   coord_cartesian(xlim = c(-5, 5))
#'
#' @export
logistic <- function(x) {

  # Check
  checkmate::assert_numeric(x)

  1 / (1 + exp(-x))
}

