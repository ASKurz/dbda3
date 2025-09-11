#' Expected loss from an MCMC sample
#'
#' The expected loss for an MCMC sample computed from Equation 11.3 in *DBDA3*.
#'
#' @param x A numeric vector of MCMC samples.
#' @param rope A two-element numeric vector of ROPE limits. Defaults to `NULL`.
#' @param rope_narrow,rope_wide A two-element numeric vector of narrow or wide ROPE limits, respectively. Default to `rope`, and can be specified instead of `rope` alone.
#' @param loss_type A character value indicating the type of loss function. Must be `"step"`, `"halfstep"`, or `"thick"`. Defaults to `"step"`.
#' @param alpha A numeric value for the loss for 'uncommitted.' Defaults to `0.05`.
#' @param na.rm A logical value indicating whether missing values should be removed. Defaults to `FALSE`.
#'
#' @returns A list of 4:
#'  * `exp_loss_equiv` A numeric value for the expected loss for deciding 'equivalent.'
#'  * `exp_loss_differ` A numeric value for the expected loss for deciding 'different.'
#'  * `exp_loss_uncom` A numeric value for the expected loss for deciding 'uncommitted.'
#'  * `decision` A character value for the decision based on loss.
#'
#' @examples
#' # Simulate a vector of posterior draws resembling a distribution of college-graduate IQ scores
#' set.seed(47)
#' x <- rnorm(n = 1e4, mean = 110, sd = 15)
#'
#' # Use a narrow ROPE around the population mean
#' exp_loss_rope_decis(x, rope = c(99, 101))
#'
#' # Adjust the loss for 'uncommitted'.
#' exp_loss_rope_decis(x, rope = c(99, 101), alpha = 0.01)
#'
#' # Use `loss_type = "halfstep"` and different ROPE criteria
#' exp_loss_rope_decis(x,
#'                     rope_narrow = 110 + c(-29, 29),
#'                     rope_wide = 110 + c(-31, 31),
#'                     loss_type = "halfstep")
#'
#' @export
exp_loss_rope_decis <- function(x,
                                rope = NULL,
                                rope_narrow = rope,
                                rope_wide = rope,
                                loss_type = c("step", "halfstep", "thick")[1],
                                alpha = 0.05,
                                na.rm = FALSE) {
  # Checks
  checkmate::assert_numeric(x, any.missing = FALSE)
  checkmate::assert_numeric(rope, null.ok = TRUE)
  checkmate::assert_numeric(rope_narrow, null.ok = TRUE)
  checkmate::assert_numeric(rope_wide, null.ok = TRUE)
  checkmate::assert_choice(loss_type, choices = c("step", "halfstep", "thick"))
  checkmate::assert_numeric(alpha, lower = 0, upper = 1, any.missing = FALSE)
  checkmate::assert_logical(na.rm)

  # Remove NA from param_sample:
  if (isTRUE(na.rm)) {
    x <- x[!is.na(x)]
  }

  expleq <- loss_equiv(
    x = x,
    rope = rope,
    rope_wide = rope_wide,
    rope_narrow = rope_narrow,
    loss_type = loss_type) |>
    mean()
  expldif <- loss_differ(
    x = x,
    rope = rope,
    rope_wide = rope_wide,
    rope_narrow = rope_narrow,
    loss_type = loss_type) |>
    mean()
  explunc <- loss_uncom(x = x, alpha = alpha) |> mean()

  list(exp_loss_equiv = expleq,
       exp_loss_differ = expldif,
       exp_loss_uncom = explunc,
       decision = c("equivalent", "different", "uncommitted")[which.min(c(expleq, expldif, alpha))])
}

