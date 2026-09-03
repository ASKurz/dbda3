#' Standardize vectors
#'
#' Standardize a numeric vector such that the mean is zero and the standard deviation is one. This is done by first subtracting the mean of the vector from each value, and then dividing the result by the standard deviation of the vector.
#'
#' @param x A numeric vector.
#' @param na.rm A logical value indicating whether missing values should be removed, which is passed to the `mean()` and `sd()` functions. As with `mean()` and `sd()`, defaults to `FALSE`.
#'
#' @returns An numeric vector the same length of `x`.
#'
#' @examples
#'
#' # Load
#' library(dplyr)
#' library(tidyr)
#'
#' # No missing values
#' df <- data.frame(x = 1:6) |>
#'   mutate(z = standardize(x))
#'
#' glimpse(df)
#'
#' df |>
#'   pivot_longer(cols = everything()) |>
#'   group_by(name) |>
#'   summarise(mean = mean(value),
#'             sd = sd(value))
#'
#' # Missing value, default `na.rm = FALSE`
#' df <- data.frame(x = c(1:5, NA)) |>
#'   mutate(z = standardize(x))
#'
#' glimpse(df)
#'
#' df |>
#'   pivot_longer(cols = everything()) |>
#'   group_by(name) |>
#'   summarise(mean = mean(value),
#'             sd = sd(value))
#'
#' # Missing value, `na.rm = TRUE`
#' df <- data.frame(x = c(1:5, NA)) |>
#'   mutate(z = standardize(x, na.rm = TRUE))
#'
#' glimpse(df)
#'
#' df |>
#'   pivot_longer(cols = everything()) |>
#'   group_by(name) |>
#'   summarise(mean = mean(value, na.rm = TRUE),
#'             sd = sd(value, na.rm = TRUE))
#'
#' @export
standardize <- function(x, na.rm = FALSE) {

  # Check
  checkmate::assert_numeric(x)
  checkmate::assert_flag(na.rm)

  (x - mean(x, na.rm = na.rm)) / sd(x, na.rm = na.rm)
}

