#' Format numbers
#'
#' This helper function is a lightweight wrapper around the base `formatC()` function, with the following defaults set for the book: `formatC(format = "f", big.mark = ",", drop0trailing = FALSE)`. For further details, see the help file for `formatC()`.
#'
#' @param x An atomic numerical or character object, possibly complex only for `prettyNum()`, typically a vector of real numbers. Any class is discarded, with a warning.
#' @param digits The desired number of digits after the decimal point (`format = "f"`) or *significant* digits (`format = "g"`, `= "e"` or `= "fg"`). Defaults to `2`.
#'
#' @returns A character vector of length `x`.
#'
#' @examples
#' format_num(1e4)
#' format_num(1e4, digits = 0)
#'
#' @keywords internal
#' @importFrom dplyr case_when
#' @importFrom stringr str_c
#' @export
format_num <- function(x, digits = 2) {
  formatC(x,
          digits = digits,        # Number of decimal places
          format = "f",           # "f" for fixed decimal places
          big.mark = ",",         # Thousands separator
          drop0trailing = FALSE)  # Forces the padding of zeros
}

