#' Helper function for `loss_decision()`
#'
#' This helper function streamlines some of the code for the `loss_decision()` function. It is not meant for regular use.
#'
#' @param x A numeric vector of MCMC samples.
#' @param rope A two-element numeric vector of ROPE limits. Defaults to `NULL`.
#' @param rope_narrow,rope_wide A two-element numeric vector of narrow or wide ROPE limits, respectively. Default to `rope`, and can be specified instead of `rope` alone.
#' @param loss_type A character value indicating the type of loss function. Must be `"step"`, `"halfstep"`, or `"thick"`. Defaults to `"step"`.
#'
#' @returns A numeric vector the same length of `x` to be passed internally to `loss_decision()`.
#'
#' @keywords internal
#' @export
loss_lessthan <- function(x,
                          rope = NULL,
                          rope_narrow = rope,
                          rope_wide = rope,
                          loss_type = c("step", "halfstep", "thick")[1]) {
  # Checks
  if (is.null(rope) & (is.null(rope_narrow) | is.null(rope_wide))) {
    stop("`rope`, or `rope_narrow` and `rope_wide`, must be specified.")
  }
  if (is.null(rope)) {
    rope <- colMeans(rbind(rope_narrow, rope_wide))
  }
  if (rope[2] < rope[1] | rope_narrow[1] < rope[1] | rope_wide[1] > rope[1] |
      rope_narrow[2] > rope[2] | rope_wide[2] < rope[2]) {
    stop("`rope` specifications not consistent.")
  }
  # Proceed
  loss <- rep(0, length(x))  # Default place holder
  if (loss_type == "step") {
    loss[which(x > rope[1])] <- 1
  }
  if (loss_type == "thick") {
    loss[which(x > rope_wide[1])] <- 1
  }
  if (loss_type == "halfstep") {
    loss[which(x > rope_narrow[1])] <- 1
    loss[which(x >= rope_wide[1] & x <= rope_narrow[1])] <- (1 - 0) / 2
  }
  loss
}

