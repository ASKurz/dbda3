#' Draw a tiny diagnostic table
#'
#' `tt_diag()` is a light-weight wrapper around the `tt()` function from the tinytable package, with default settings frequently used in the HMC diagnostic tables frequently used in *DBDA3*.
#'
#' @param x A data frame, data table, or tibble to be rendered as a table.
#'
#' @returns An object of class `tt` representing the table.
#'
#' @examples
#' library(tinytable)
#'
#' # Extract, summarize, and subset example HMC draws
#' example_draws_diag <- posterior::example_draws() |>
#'   dbda3::summarize_draws_dbda3() |>
#'   dplyr::select(variable, q50, q2.5, q97.5, ess_q50)
#'
#' # Default behavior
#' example_draws_diag |>
#'   tt_diag()
#'
#' # Round digits in select columns with `format_tt()`
#' example_draws_diag |>
#'   tt_diag() |>
#'   format_tt(j = 2:4, digits = 2, num_fmt = "decimal", num_zero = TRUE) |>
#'   format_tt(j = 5, digits = 1, num_fmt = "decimal", num_zero = TRUE)
#'
#' @import tinytable
#' @export
tt_diag <- function(x) {
  n_col <- ncol(x)
  n_row <- nrow(x)

  x |>
    tt() |>
    format_tt(i = "colnames", escape = TRUE) |>  # To handle the underscores in the column names
    format_tt(j = 1, escape = TRUE) |>           # To handle the underscores in column 1
    style_tt(j = 1, align = "l") |>
    style_tt(j = 2:n_col, align = "r") |>
    style_tt(i = 1:n_row, j = 1, monospace = TRUE)
}

