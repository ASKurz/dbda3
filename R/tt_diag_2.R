#' Draw a tiny diagnostic table
#'
#' `tt_diag_2()` is a light-weight wrapper around the `tt()` function from the tinytable package, with default settings frequently used in the HMC diagnostic tables frequently used in *DBDA3*.
#'
#' @param x A data frame, data table, or tibble to be rendered as a table.
#' @param digits_q Number of significant digits or decimal places for the quantile columns. The value is passed to `format_tt(j = "^q")`. Defaults to `1`.
#' @param digits_rhat Number of significant digits or decimal places for the `rhat` column. The value is passed to `format_tt(j = "rhat")`. Defaults to `3`.
#' @param digits_ess Number of significant digits or decimal places for the ESS columns. The value is passed to `format_tt(j = "^[ess]")`. Defaults to `0`.
#' @param height Row height in em units. Single numeric value greater than zero that determines the row height spacing. The value is passed to `tt()`. Defaults to `0.3`.
#' @param placement Character string specifying LaTeX float placement options for the table environment (e.g., `"h"`, `"t"`, `"b"`, `"p"`, `"H"`). Only used when `environment_table = TRUE`. The value is passed to `theme_latex()`. Defaults to `"H"`.
#'
#' @returns An object of class `tt` representing the table.
#'
#' @examples
#' library(tinytable)
#'
#' # Extract, summarize, and subset example HMC draws
#' example_draws_diag <- posterior::example_draws() |>
#'   dbda3::summarize_draws_dbda3_2()
#'
#' # Default behavior
#' example_draws_diag |>
#'   tt_diag_2()
#'
#' # Adjust digits and `height`
#' example_draws_diag |>
#'   tt_diag_2(digits_q = 2, digits_rhat = 1, height = 0.2)
#'
#' @import tinytable
#' @export
tt_diag_2 <- function(x,
                      digits_q    = 1,
                      digits_rhat = 3,
                      digits_ess  = 0,
                      height = 0.3,
                      placement = "H",
                      ...) {
  # n_col <- ncol(x)
  n_row <- nrow(x)

  x |>
    tt(height = height, ...) |>
    format_tt(i = "colnames", escape = TRUE) |>  # To handle the underscores in the column names
    format_tt(j = 1, escape = TRUE) |>           # To handle the underscores in column 1
    # Quantile columns
    format_tt(j = "^q", digits = digits_q, num_fmt = "decimal", num_zero = TRUE) |>
    # Rhat column
    format_tt(j = "rhat", digits = digits_rhat, num_fmt = "decimal", num_zero = TRUE) |>
    # ESS columns
    format_tt(j = "^[ess]", digits = digits_ess, num_fmt = "decimal", num_zero = TRUE, num_mark_big = ",") |>
    style_tt(align = "l") |>
    style_tt(j = "^q", align = "r") |>
    style_tt(j = "rhat", align = "r") |>
    style_tt(j = "^[ess]", align = "r") |>
    style_tt(i = 1:n_row, j = 1, alignv = "m", monospace = TRUE) |>
    theme_latex(placement = placement)  # Set LaTeX inline placement (defaults to "H")
}

