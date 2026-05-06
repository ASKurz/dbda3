#' Draw a tiny loss-decision table
#'
#' `tt_loss()` is an extension of a few functions from the tinytable package, such as `tt()` and `format_tt()`, with default settings for the loss-decision tables frequently used in *DBDA3*.
#'
#' @param x A data frame, data table, or tibble to be rendered as a table.
#' @param digits Number of significant digits or decimal places for the numeric columns. The value is passed to `format_tt()`. Defaults to `2`.
#' @param height Row height in em units. Single numeric value greater than zero that determines the row height spacing. The value is passed to `tt()`. Defaults to `0.3`.
#' @param placement Character string specifying LaTeX float placement options for the table environment (e.g., `"h"`, `"t"`, `"b"`, `"p"`, `"H"`). Only used when `environment_table = TRUE`. The value is passed to `theme_latex()`. Defaults to `"H"`.
#' @param ... Further arguments passed to `tt()`.
#'
#' @returns An object of class `tt` representing the table.
#'
#' @examples
#' library(tinytable)
#'
#' set.seed(47)
#' rnorm(n = 1e4, mean = 110, sd = 15) |>
#'   loss_decision(rope = c(99, 101)) |>
#'   tt_loss()
#'
#' @import tinytable
#' @export
tt_loss <- function(x,
                    digits = 2,
                    height = 0.3,
                    placement = "H",
                    ...) {
  x |>
    tt(height = height, ...) |>
    format_tt(digits = digits, num_fmt = "decimal", num_zero = TRUE) |>
    format_tt(i = "colnames", escape = TRUE) |>  # To handle the underscores in the column names
    theme_latex(placement = placement)  # Set LaTeX inline placement (defaults to "H")
}

