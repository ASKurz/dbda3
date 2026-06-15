#' The inverse of the softplus function
#'
#' Transform numeric values with the inverse of the softplus function. This is also sometimes called the *shifted softplus inverse* or *expxm1 inverse*.
#'
#' @param x A vector of non-negative numeric values.
#'
#' @returns A vector of real numeric values the same length of `x`.
#'
#' @details
#' The softplus function follows the form
#'
#' \deqn{f(x) = \log(\exp(x) - 1).}
#'
#' @seealso [softplus()] for the inverse function.
#'
#' @examples
#' softplus_inverse(1)
#' softplus_inverse(0:19)
#'
#' @export
softplus_inverse <- function(x) log(exp(x) - 1)

