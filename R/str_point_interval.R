#' Helper function for `bern_beta()`
#'
#' This helper function streamlines some of the annotation code for the `bern_beta()` function. It is not meant for regular use.
#'
#' @param shape1,shape2 The numeric values for the first and second parameters in the beta distribution. The values are passed to the `shape1` and `shape2` arguments of the `dbeta()` function, respectively.
#' @param interval A character value corresponding to the `interval` argument in the `bern_beta()` function.
#' @param pp_point A character value corresponding to the `pp_point` argument in the `bern_beta()` function.
#' @param prob A numeric value corresponding to the `prob` argument in the `bern_beta()` function.
#' @param unique_mode A logical value matching a logical test internal to the `bern_beta()` function.
#'
#' @returns A character value to be passed internally to `bern_beta()`.
#'
#' @examples
#' str_point_interval(2, 3, "hdi", "mode", 0.95, TRUE)
#'
#' @keywords internal
#' @importFrom stringr str_c str_to_sentence str_to_upper
#' @importFrom dplyr case_when
#' @export
str_point_interval <- function(shape1, shape2, interval, pp_point, prob, unique_mode) {

  # Define new character values
  interval_text <- str_to_upper(interval)
  pp_point_name <- str_to_sentence(pp_point)
  prob_text     <- as.character(100 * prob)

  # Streamline some of the logical statements
  a <- shape1
  b <- shape2

  case_when(
    interval == "eti"  & pp_point == "mean"                                              ~ str_c(pp_point_name, ", ", prob_text, "% ", interval_text),
    interval == "eti"  & pp_point == "median"                                            ~ str_c(pp_point_name, ", ", prob_text, "% ", interval_text),
    interval == "eti"  & pp_point == "mode"   & unique_mode == TRUE                      ~ str_c(pp_point_name, ", ", prob_text, "% ", interval_text),
    interval == "eti"  & pp_point == "mode"   & unique_mode == FALSE                     ~ str_c(prob_text, "% ", interval_text),
    interval == "eti"  & pp_point == "none"                                              ~ str_c(prob_text, "% ", interval_text),
    interval == "hdi"  & pp_point == "mean"   & (a > 1 & b > 1)                          ~ str_c(pp_point_name, ", ", prob_text, "% ", interval_text),
    interval == "hdi"  & pp_point == "mean"   & (a <= 1 | b <= 1)                        ~ pp_point_name,
    interval == "hdi"  & pp_point == "median" & (a > 1 & b > 1)                          ~ str_c(pp_point_name, ", ", prob_text, "% ", interval_text),
    interval == "hdi"  & pp_point == "median" & (a <= 1 | b <= 1)                        ~ pp_point_name,
    interval == "hdi"  & pp_point == "mode"   & (a > 1 & b > 1)   & unique_mode == TRUE  ~ str_c(pp_point_name, ", ", prob_text, "% ", interval_text),
    interval == "hdi"  & pp_point == "mode"   & (a > 1 & b > 1)   & unique_mode == FALSE ~ str_c(prob_text, "% ", interval_text),
    interval == "hdi"  & pp_point == "mode"   & (a <= 1 | b <= 1) & unique_mode == TRUE  ~ pp_point_name,
    interval == "hdi"  & pp_point == "mode"   & (a <= 1 | b <= 1) & unique_mode == FALSE ~ "",
    interval == "hdi"  & pp_point == "none"   & (a > 1 & b > 1)                          ~ str_c(prob_text, "% ", interval_text),
    interval == "hdi"  & pp_point == "none"   & (a <= 1 | b <= 1)                        ~ "",
    interval == "none" & pp_point == "mean"                                              ~ pp_point_name,
    interval == "none" & pp_point == "median"                                            ~ pp_point_name,
    interval == "none" & pp_point == "mode"   & unique_mode == TRUE                      ~ pp_point_name,
    interval == "none" & pp_point == "mode"   & unique_mode == FALSE                     ~ "")
}

