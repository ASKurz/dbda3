#' Helper function for `mass_in_rope_beta_plot()`
#'
#' This helper function streamlines some of the annotation code for the `mass_in_rope_beta_plot()` function. It is not meant for regular use.
#'
#' @param x A vector of numeric values in the domain of \eqn{\begin{bmatrix} 0, 1 \end{bmatrix}}.
#' @param digits Non-negative numeric value for the number of significant digits or decimal places. The value is passed to the `digits` argument in the `formatC()` function. Defaults to `3`.
#' @param plotmath A logical value indicating whether one intends to express the output with plotmath mathematical annotation. Defaults to `TRUE`.
#'
#' @returns A character vector of length `x`.
#'
#' @examples
#' format_pval(c(0.5, 0.0005))
#' format_pval(0.1, digits = 2, plotmath = FALSE)
#'
#' @keywords internal
#' @importFrom dplyr case_when
#' @importFrom stringr str_c
#' @export
format_pval <- function(x, digits = 3, plotmath = TRUE) {

  # Checks
  checkmate::assert_numeric(x, lower = 0, upper = 1)
  checkmate::assert_numeric(digits, lower = 0)
  checkmate::assert_logical(plotmath)

  # Wrangle
  case_when(
    # 10^(-3) = 0.001
    x < 10^(-digits) ~ str_c(
      "< '",
      formatC(x = 10^(-digits),
              format = "f",     # "f" for fixed decimal places
              digits = digits,  # Number of decimal places
              drop0trailing = FALSE),
      "'"),
    # 1 - 10^(-3) = 0.999
    x > 1 - 10^(-digits) ~ str_c(
      "> '",
      formatC(x = 1 - 10^(-digits),
              format = "f",
              digits = digits,
              drop0trailing = FALSE),
      "'"),
    # Between the first two extremes
    .default = str_c(
      ifelse(plotmath, "== '", "= '"),
      formatC(x = x,
              format = "f",
              digits = digits,
              drop0trailing = FALSE),
      "'")
  )
}

