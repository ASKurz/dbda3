#' The softmax function
#'
#' Compute the probability of outcome \eqn{k} as the exponentiated linear propensity of outcome \eqn{k} relative to the sum of exponentiated linear propensities across all outcomes in the set. The `softmax()` function is useful for the nominal models discussed in *DBDA3*, Chapter 20.
#'
#' @param x A vector of numeric values.
#'
#' @returns A vector of numeric values the same length of `x`, in the domain of \eqn{\begin{bmatrix} 0, 1\end{bmatrix}}.
#'
#' @details
#'
#' Consider a predicted variable, \eqn{y}, with several nominal levels indexed by \eqn{k}, and the set of possible outcomes is denoted \eqn{S}.
#' Say we define the simple linear propensity of categorical outcome \eqn{k} as
#'
#' \deqn{\lambda_k = \beta_{0, k} + \beta_{1, k} x,}
#'
#' for a single predictor \eqn{x}, which is on the log-odds scale. We can define the probability of outcome \eqn{k} with the *softmax* function, defined as
#'
#' \deqn{\phi_{k} = \operatorname{softmax}_S(\{\lambda_{k}\}) = \frac{ \exp(\lambda_{k}) }{ \sum_{k \in S} \exp(\lambda_k) }}.
#'
#' @examples
#'
#' softmax(-1:1)
#'
#' @export
softmax <- function(x) {

  # Check
  checkmate::assert_numeric(x)

  exp(x) / sum(exp(x))
}
