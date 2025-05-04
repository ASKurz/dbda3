#' Rescale correlations
#'
#' Transform correlation values to the \eqn{[0, 1]} range.
#'
#' @param x A vector of numeric values in the \eqn{[-1, 1]} range.
#'
#' @returns A numeric vector the same length as `x`.
#'
#' @seealso [rescale_bounds()] for a more general application.
#'
#' @examples
#' cor_vec <- -4:4 / 4
#' cor_to_01(cor_vec)
#'
#' @export
cor_to_01 <- function(x) {

  # Check
  checkmate::assert_numeric(x, lower = -1, upper = 1)

  (x + 1) / 2
}

