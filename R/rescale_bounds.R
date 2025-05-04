#' Rescale bounded values
#'
#' Transform numeric values with lower and upper boundaries to a scale with different lower and/or upper boundaries.
#'
#' @param x A vector of numeric values in the current range.
#' @param from_low,from_high A vector of numeric values for the current lower and upper limits, respectively. Default to `0` and `1`, respectively.
#' @param to_low,to_high A vector of numeric values for the desired lower and upper limits, respectively. Default to `0` and `1`, respectively.
#'
#' @returns A numeric vector the same length as `x`.
#'
#' @seealso [cor_to_01()] for a special case.
#'
#' @examples
#' x_vec <- -4:4 / 4  # Correlation metric
#' rescale_bounds(x_vec, from_low = -1, from_high = 1)  # [0, 1] metric
#'
#' x_vec <- 0:5 / 5  # [0, 1] metric
#' rescale_bounds(x_vec, to_low = 0, to_high = 100)  # [0, 100] metric
#'
#' @export
rescale_bounds <- function(x, from_low = 0, from_high = 1, to_low = 0, to_high = 1) {

  # Check
  checkmate::assert_numeric(x)
  checkmate::assert_numeric(from_low)
  checkmate::assert_numeric(from_high)
  checkmate::assert_numeric(to_low)
  checkmate::assert_numeric(to_high)

  slope <- (to_high - to_low) / (from_high - from_low)
  intercept <- to_high - slope * from_high
  intercept + slope * x
}

