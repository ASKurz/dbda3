#' Helper function for `bern_beta()`
#'
#' This helper function streamlines some of the annotation code for the `bern_beta()` function. It is not meant for regular use.
#'
#' @param shape1,shape2 The numeric values for the first and second parameters in the beta distribution. The values are passed to the `shape1` and `shape2` arguments of the `dbeta()` function, respectively.
#' @param interval A character value corresponding to the `interval` argument in the `bern_beta()` function.
#' @param pp_point A character value corresponding to the `pp_point` argument in the `bern_beta()` function.
#' @param prob A numeric value corresponding to the `prob` argument in the `bern_beta()` function.
#' @param unique_mode A logical value matching a logical test internal to the `bern_beta()` function. If `unique_mode` doesn't match the actual shape of the beta distribution (e.g., `TRUE` is passed for a bimodal `Beta(a, b)` with `a = b <= 1`), none of the internal conditions are met and the function returns `NA`.
#'
#' @returns A numeric value between zero and one to be passed internally to `bern_beta()`.
#'
#' @examples
#' theta_for_label(2, 3, "hdi", "mode", 0.95, TRUE)
#'
#' @keywords internal
#' @importFrom dplyr case_when
#' @export
theta_for_label <- function(shape1, shape2, interval, pp_point, prob, unique_mode) {

  # To streamline the logical statements
  a <- shape1
  b <- shape2

  case_when(
    pp_point == "mean"                        ~ a / (a + b),
    pp_point == "median"                      ~ qbeta(0.5, shape1 = a, shape2 = b),
    pp_point == "mode" & (a > 1 & b > 1)      ~ (a - 1) / (a + b - 2),
    pp_point == "mode" & (a <= 1 & a < b)     ~ 0,
    pp_point == "mode" & (b <= 1 & b < a)     ~ 1,
    # In this special case, there would be no HDI, but possibly an ETI
    pp_point == "mode" & unique_mode == FALSE ~ qbeta(0.5, shape1 = a, shape2 = b),
    pp_point == "none" & interval == "eti"    ~ qbeta(0.5, shape1 = a, shape2 = b),
    pp_point == "none" & interval == "hdi"    ~ hdi_of_icdf(qbeta, shape1 = a, shape2 = b, prob = prob) |> mean())

}

