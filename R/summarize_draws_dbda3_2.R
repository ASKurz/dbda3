#' Summarize `draws` objects
#'
#' `summarize_draws_dbda3_2()` is a light-weight wrapper around the `summarize_draws()` function from the posterior package, with default settings frequently used in *DBDA3*.
#'
#' @param .x An object of class `draws` passed to the `.x` argument within the `summarize_draws()` function.
#' @param probs A numeric vector of probability values ranging from `0` to `1`. The full vector is passed to the `probs` argument of the `quantile2()` and `mcse_quantile()` functions (when `mcse = TRUE`), and the minimum and maximum values are passed to the `probs` argument in the `ess_eti()` function. Defaults to `c(0.50, 0.025, 0.975)`.
#' @param mcse A logical value indicating whether to include Monte Carlo standard errors for quantile estimates . Defaults to `FALSE`.
#' @param ... Additional arguments passed to `summarize_draws()`.
#'
#' @returns An object of `draws_summary`, `tbl_df`, `tbl`, and `data.frame` returned by the `summarize_draws()` function. The first column, `variable`, is a character vector of the names of the summarized columns. The remaining columns contain numeric values for the summary statistics and convergence measures from the following functions: `quantile2()`, `rhat()`, `ess_quantile()`, and `ess_eti()`.
#'
#' @examples
#'
#' # Default behavior
#' posterior::example_draws() |>
#'   summarize_draws_dbda3_2() |>
#'   str(give.attr = FALSE)
#'
#' # Adjust the `probs` argument, and include MCSE
#' posterior::example_draws() |>
#'   summarize_draws_dbda3_2(probs = c(0.50, 0.05, 0.95), mcse = TRUE) |>
#'   str(give.attr = FALSE)
#'
#' @import posterior
#' @export
summarize_draws_dbda3_2 <- function(.x, probs = c(0.50, 0.025, 0.975), mcse = FALSE, ...) {

  # Check
  checkmate::assert_logical(mcse)

  # Define the ETI
  eti <- range(probs)

  if (!isTRUE(mcse)) {
    summarize_draws(.x,
                    ~quantile2(.x, probs = probs),
                    rhat,
                    ~ess_quantile(.x, probs = 0.50),
                    ess_eti = ~ess_eti(.x, probs = eti),
                    ...)
  } else if (isTRUE(mcse)) {
    summarize_draws(.x,
                    ~quantile2(.x, probs = probs),
                    ~mcse_quantile(.x, probs = probs),
                    rhat,
                    ~ess_quantile(.x, probs = 0.50),
                    ess_eti = ~ess_eti(.x, probs = eti),
                    ...)
  }
}

