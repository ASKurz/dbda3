#' Draw a tiny diagnostic table
#'
#' `tt_diag()` is a light-weight wrapper around the `tt()` function from the tinytable package, with default settings frequently used in the HMC diagnostic tables frequently used in *DBDA3*.
#'
#' @param x A data frame, data table, or tibble to be rendered as a table.
#' @param digits_q Number of significant digits or decimal places for the quantile columns. The value is passed to the `digits` argument in `format_tt(j = "^q")`. Defaults to `2`.
#' @param digits_rhat Number of significant digits or decimal places for the `rhat` column. The value is passed to the `digits` argument in `format_tt(j = "rhat")`. Defaults to `3`.
#' @param digits_ess Number of significant digits or decimal places for the ESS columns. The value is passed to the `digits` argument in `format_tt(j = "^[ess]")`. Defaults to `0`.
#' @param digits_mcse Number of significant digits or decimal places for the MCSE columns. The value is passed to the `digits` argument in `format_tt(j = "^[mcse]")`. Defaults to `digits_q`.
#' @param height Row height in em units. Single numeric value greater than zero that determines the row height spacing. The value is passed to the `height` argument in `tt()`. Defaults to `0.3`.
#' @param placement Character string specifying LaTeX float placement options for the table environment (e.g., `"h"`, `"t"`, `"b"`, `"p"`, `"H"`). Only used when `environment_table = TRUE`. The value is passed to `theme_latex()`. Defaults to `"H"`.
#' @param monospace_j Which columns are given monospace font. The value is passed to the `j` argument in `style_tt(alignv = "m", monospace = TRUE)`. Can take a numeric vector, and defaults to `1`. For no monospace, set to `NULL`.
#' @param variable_name The name for the first column, which is typically `"variable"` in a `summarize_draws()` output. Defaults to `"Parameter"`, and `NULL` retains the original name.
#'
#' @returns An object of class `tt` representing the table.
#'
#' @examples
#' library(tinytable)
#'
#' # Extract, summarize, and subset example HMC draws
#' example_draws_diag <- posterior::example_draws() |>
#'   dbda3::summarize_draws_dbda3()
#'
#' # Default behavior
#' example_draws_diag |>
#'   tt_diag()
#'
#' # Adjust digits and `height`
#' example_draws_diag |>
#'   tt_diag(digits_q = 2, digits_rhat = 1, height = 0.2)
#'
#' @importFrom stringr str_detect str_starts
#' @import tinytable
#' @export
tt_diag <- function(x,
                    digits_q    = 2,
                    digits_rhat = 3,
                    digits_ess  = 0,
                    digits_mcse = digits_q,
                    height = 0.3,
                    placement = "H",
                    monospace_j = 1,
                    variable_name = "Parameter",
                    ...) {
  n_row <- nrow(x)

  t <- x |>
    tt(height = height, ...) |>
    format_tt(escape = TRUE) |>  # To handle any underscores
    style_tt(align = "l") |>
    theme_latex(placement = placement)  # Set LaTeX inline placement (defaults to "H")

  # Quantile columns
  if (sum(str_starts(colnames(x), pattern = "q")) > 0) {
    t <- t |>
      format_tt(j = "^q", digits = digits_q, num_fmt = "decimal", num_zero = TRUE) |>
      style_tt(j = "^q", align = "r")
  }
  # ESS columns
  if (sum(str_starts(colnames(x), pattern = "ess")) > 0) {
    t <- t |>
      format_tt(j = "^(ess)", digits = digits_ess, num_fmt = "decimal", num_zero = TRUE, num_mark_big = ",") |>
      style_tt(j = "^(ess)", align = "r")
  }
  # Rhat
  if (sum(str_detect(colnames(x), pattern = "rhat")) > 0) {
    t <- t |>
      format_tt(j = "rhat", digits = digits_rhat, num_fmt = "decimal", num_zero = TRUE) |>
      style_tt(j = "rhat", align = "r")
  }
  # MCSE columns
  if (sum(str_detect(colnames(x), pattern = "mcse")) > 0) {
    t <- t |>
      format_tt(j = "^(mcse)", digits = digits_mcse, num_fmt = "decimal", num_zero = TRUE) |>
      style_tt(j = "^(mcse)", align = "r")
  }
  # `monospace = TRUE`
  if (!is.null(monospace_j)) {
    t <- t |>
      style_tt(i = 1:n_row, j = monospace_j, alignv = "m", monospace = TRUE)
  }
  # Rename `variable` column
  if (is.null(variable_name)) {
    t
  } else {
    names(t)[1] <- variable_name
    t
  }
}

