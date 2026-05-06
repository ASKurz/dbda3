#' Draw a tiny prior table
#'
#' `tt_prior()` is an extension of a few functions from the tinytable package, such as `tt()` and `format_tt()`, with default settings used in the prior tables in *DBDA3*.
#'
#' @param x An object of class `brmsprior`, or a data frame with a similar format to be rendered as a table.
#' @param height Row height in em units. Single numeric value greater than zero that determines the row height spacing. The value is passed to the `height` argument in `tt()`. Defaults to `0.3`.
#' @param placement Character string specifying LaTeX float placement options for the table environment (e.g., `"h"`, `"t"`, `"b"`, `"p"`, `"H"`). Only used when `environment_table = TRUE`. The value is passed to `theme_latex()`. Defaults to `"H"`.
#' @param ... Further arguments passed to `tt()`.
#'
#' @returns An object of class `tt` representing the table.
#'
#' @importFrom dplyr mutate
#' @import tinytable
#' @export
tt_prior <- function(x,
                     height = 0.2,
                     placement = "H", ... ) {

  n_var_cols <- ncol(x)

  x |>
    # Replace empty prior cells with "(flat)"
    mutate(prior = ifelse(prior == "", "(flat)", prior)) |>
    tt(height = height, ... ) |>
    format_tt(j = 1:n_var_cols, escape = TRUE) |> # To handle the underscores in body
    # `variable` columns
    style_tt(j = 1:n_var_cols, align = "l") |>
    style_tt(j = 1:n_var_cols, i = 1:nrow(x),  monospace = TRUE) |>
    # Default to latex inline placement "H", but allow override
    theme_latex(placement = placement)
}

