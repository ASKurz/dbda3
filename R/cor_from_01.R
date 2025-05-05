#' Rescale to correlations
#'
#' Transform values from the \eqn{[0, 1]} range to the correlation metric. This is the inverse of the `cor_to_01()` function.
#'
#' @param x A vector of numeric values in the \eqn{[0, 1]} range.
#'
#' @returns A numeric vector the same length as `x`.
#'
#' @seealso [cor_to_01()] for the inverse function.
#' @seealso [rescale_bounds()] for a more general application.
#'
#' @examples
#' x_vec <- 0:4 / 4
#' cor_from_01(x_vec)
#'
#' @export
cor_from_01 <- function(x) {

  # Check
  checkmate::assert_numeric(x, lower = 0, upper = 1)

  (x * 2) - 1
}

