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
loss_equiv <- function(x,
                       rope = NULL,
                       rope_narrow = rope,
                       rope_wide = rope,
                       loss_type = c("step", "halfstep", "thick")[1]) {

  # Check that `rope` or `rope_narrow` & `rope_wide` are specified
  if (is.null(rope) && (is.null(rope_narrow) || is.null(rope_wide))) {
    stop("`rope`, or `rope_narrow` and `rope_wide`, must be specified.")
  }
  if (is.null(rope)) {
    rope <- colMeans(rbind(rope_narrow, rope_wide))
  }
  # Check ROPE specifications for consistency
  if (rope[2] < rope[1] || rope_narrow[1] < rope[1] || rope_wide[1] > rope[1] ||
      rope_narrow[2] > rope[2] || rope_wide[2] < rope[2]) {
    stop("ROPE specifications not consistent.")
  }

  # Note. In the code below, the algebraic value `1` is the value for the
  # upper bound for loss, and the value for the lower bound for loss is zero.
  # In principle, these values can be generalized.
  loss <- rep(0, length(x))  # Default place holder
  if (loss_type == "step") {
    loss[which(x < rope[1] | x > rope[2])] <- 1
  }
  if (loss_type == "halfstep") {
    loss[which(x < rope_wide[1] | x > rope_wide[2])] <- 1
    # If the upper and/or lower bounds for loss were generalized, the values on the right of the arrows
    # for these two lines would instead be `(u - l) / 2`, where `u` is the upper bound and `l` is the lower.
    loss[which(x >= rope_wide[1] & x <= rope_narrow[1])] <- 1 / 2
    loss[which(x >= rope_narrow[2] & x <= rope_wide[2])] <- 1 / 2
  }
  if (loss_type == "thick") {
    loss[which(x < rope_narrow[1] | x > rope_narrow[2])] <- 1
  }

  loss
}

8/7
