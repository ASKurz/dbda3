#' Helper function for `exp_loss_rope_decis()`
#'
#' This helper function streamlines some of the code for the `exp_loss_rope_decis()` function. It is not meant for regular use.
#'
#' @param x A numeric vector of MCMC samples.
#' @param alpha A numeric value for the loss for 'uncommitted.' Defaults to `0.05`.
#'
#' @returns A numeric vector of `alpha` values the same length of `x` to be passed internally to `exp_loss_rope_decis()`.
#'
#' @keywords internal
#' @export
loss_uncom <- function(x, alpha = 0.05) {
  rep(alpha, length(x))
}

