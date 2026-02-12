#' ETI effective sample size (eti-ESS)
#'
#' `ess_eti()` is a light-weight generalization of the `ess_tail()` function from the posterior package. The `ess_tail()` functions computes a tail effective sample size estimate (tail-ESS) for a single variable, where the two points of the tail are strictly defined as the 5% and 95% quantiles. The `ess_tail()` function returns the minimum value of for those two quantiles. The `ess_eti()` function allows for different pairs of quantiles.
#'
#' @param x A matrix of draws for a single variable (iterations x chains), or an [`rvar`], passed to the `x` argument within the `ess_quantile()` function.
#' @param probs A numeric vector of probability values ranging from `0` to `1` passed to the `probs` argument of the `ess_quantile()`. Defaults to `c(0.025, 0.975)`.
#' @param ... Additional arguments passed to `ess_quantile()`.
#'
#' @returns If the input is an array, returns a single numeric value. If any of the draws is non-finite, that is, `NA`, `NaN`, `Inf`, or `-Inf`, the returned output will be (numeric) `NA`. Also, if all draws within any of the chains of a variable are the same (constant), the returned output will be (numeric) `NA` as well. The reason for the latter is that, for constant draws, we cannot distinguish between variables that are supposed to be constant (e.g., a diagonal element of a correlation matrix is always 1) or variables that just happened to be constant because of a failure of convergence or other problems in the sampling process.
#'
#' If the input is an rvar, returns an array of the same dimensions as the rvar, where each element is equal to the value that would be returned by passing the draws array for that element of the rvar to this function.
#'
#' @examples
#'
#' # Default behavior
#' posterior::example_draws() |>
#'   posterior::summarize_draws(ess_eti = ess_eti)
#'
#' # Adjust the `probs` argument to match `posterior::ess_tail()`
#' posterior::example_draws() |>
#'   posterior::summarize_draws(ess_eti = \(x) ess_eti(x, probs = c(0.05, 0.95)))
#'
#' @import posterior
#' @export
ess_eti <- function(x, probs = c(0.025, 0.975), ...) {
  ess_quantile(x, probs = probs, ...) |> min()
}
