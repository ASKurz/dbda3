#' The softplus function
#'
#' Transform numeric values with the softplus function.
#'
#' @param x A vector of numeric values.
#'
#' @returns A vector of real numeric values the same length of `x`.
#'
#' @details
#' The softplus function follows the form
#'
#' \deqn{f(x) = \log(1 + \exp(x))}.
#'
#' @examples
#' softplus(1)
#' softplus(1:5)
#'
#' @export
softplus <- function(x) log(1 + exp(x))

