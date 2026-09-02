#' Assign ROPE categories
#'
#' Categorize a vector of posterior draws with respect to a region of practical equivalence (ROPE).
#'
#' @param x A vector of numeric values.
#' @param rope A two-element numeric vector of ROPE limits. Defaults to `c(0.45, 0.55)`.
#'
#' @returns A factor vector of length `x`. The factor will have three levels: `"less"`, `"in"`, and `"greater"`.
#'
#' @examples
#' library(dplyr)
#'
#' data.frame(theta = rbeta(n = 1e4, shape1 = 40, shape2 = 30)) |>
#'   mutate(rope_category = rope_category(x = theta)) |>
#'   str()
#'
#' @importFrom dplyr case_when
#' @export
rope_category <- function(x, rope = c(0.45, 0.55)) {

  # Check
  checkmate::assert_numeric(x)
  checkmate::assert_numeric(rope)

  rope <- rope
  case_when(
    x < rope[1] ~ "less",
    x >= rope[1] & x <= rope[2] ~ "in",
    x > rope[2] ~ "greater") |>
    factor(levels = c("less", "in", "greater"))
}

