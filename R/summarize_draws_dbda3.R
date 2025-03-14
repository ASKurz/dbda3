#' Summarize `draws` objects
#'
#' `summarize_draws_dbda3()` is a light-weight wrapper around the `summarize_draws()` function from the posterior package, with default settings frequently used in *DBDA3*.
#'
#' @param .x An object of class `draws` passed to the `.x` argument within the `summarize_draws()` function.
#' @param probs A numeric vector of probability values ranging from `0` to `1` passed to the `probs` argument of the `ess_quantile()`, `mcse_quantile()`, and `quantile2()` functions from the posterior package. Defaults to `c(0.50, 0.025, 0.975)`.
#' @param ... Additional arguments passed to `summarize_draws()`.
#'
#' @returns An object of `draws_summary`, `tbl_df`, `tbl`, and `data.frame` returned by the `summarize_draws()` function. The first column, `variable`, is a character vector of the names of the summarized columns. The remaining columns contain numeric values for the summary statistics and convergence measures from the following functions: `rhat()`, `ess_quantile()`, `mcse_quantile()`, and `quantile2()`.
#'
#' @examples
#'
#' # Default behavior
#' posterior::example_draws() |>
#'   summarize_draws_dbda3() |>
#'   str()
#'
#' # Adjust the `probs` argument
#' posterior::example_draws() |>
#'   summarize_draws_dbda3(probs = 0.5) |>
#'   str()
#'
#' @import posterior
#' @export
summarize_draws_dbda3 <- function(.x, probs = c(0.50, 0.025, 0.975), ...) {
  summarize_draws(.x,
                  rhat,
                  ~ess_quantile(.x, probs = probs),
                  ~mcse_quantile(.x, probs = probs),
                  ~quantile2(.x, probs = probs),
                  ...)
}

