#' Helper function for `loss_decision()`
#'
#' This helper function streamlines some of the code for the `loss_decision()` function. It is not meant for regular use.
#'
#' @param x A numeric vector of MCMC samples.
#' @param rope A two-element numeric vector of ROPE limits. Defaults to `NULL`.
#' @param rope_narrow,rope_wide A two-element numeric vector of narrow or wide ROPE limits, respectively. Default to `rope`, and can be specified instead of `rope` alone.
#' @param loss_type A character value indicating the type of loss function. Must be `"step"`, `"halfstep"`, or `"thick"`. Defaults to `"step"`.
#' @param na.rm A logical value passed to `na.rm` within the `mean()` function. Defaults to `FALSE`.
#'
#' @returns A numeric value for expected loss passed to `loss_decision()`.
#'
#' @keywords internal
#' @export
loss_less_than <- function(x,
                           rope = NULL,
                           rope_narrow = rope,
                           rope_wide = rope,
                           loss_type = c("step", "halfstep", "thick")[1],
                           na.rm = FALSE) {
  if (loss_type == "step") {
    loss <- x > rope[1]
  }
  if (loss_type == "thick") {
    loss <- x > rope_wide[1]
  }
  if (loss_type == "halfstep") {
    loss <- rep(0, length(x))  # Default place holder
    loss[x > rope_narrow[1]] <- 1
    loss[x >= rope_wide[1] & x <= rope_narrow[1]] <- 0.5
  }
  mean(loss, na.rm = na.rm)
}

