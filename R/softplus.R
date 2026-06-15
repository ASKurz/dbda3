#' The softplus function
#'
#' Transform numeric values with the softplus function.
#'
#' @param x A vector of numeric values.
#'
#' @returns A vector of positive real numeric values the same length of `x`.
#'
#' @details
#' The softplus function follows the form
#'
#' \deqn{f(x) = \log(1 + \exp(x)).}
#'
#' @seealso [softplus_inverse()] for the inverse function.
#'
#' @examples
#' softplus(0)
#' softplus(-5:5)
#'
#' @export
softplus <- function(x) log(1 + exp(x))

