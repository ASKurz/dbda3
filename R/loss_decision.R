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
#' @returns A 1 X 5 data frame:
#'  * `less_than` A numeric value for the expected loss for deciding 'less than'
#'  * `equivalent` A numeric value for the expected loss for deciding 'equivalent.'
#'  * `greater_than` A numeric value for the expected loss for deciding 'greater than'
#'  * `uncommitted` A numeric value for the expected loss for deciding 'uncommitted.'
#'  * `decision` A character value for the decision based on loss.
#'
#' @examples
#' # Simulate a vector of posterior draws resembling a distribution of college-graduate IQ scores
#' set.seed(47)
#' x <- rnorm(n = 1e4, mean = 110, sd = 15)
#'
#' # Use a narrow ROPE around the population mean
#' loss_decision(x, rope = c(99, 101))
#'
#' # Adjust the loss for 'uncommitted'.
#' loss_decision(x, rope = c(99, 101), alpha = 0.01)
#'
#' # Use `loss_type = "halfstep"` and different ROPE criteria
#' loss_decision(x,
#'               rope_narrow = 110 + c(-29, 29),
#'               rope_wide = 110 + c(-31, 31),
#'               loss_type = "halfstep")
#'
#' @export
loss_decision <- function(x,
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

  # Checks
  if (is.null(rope) & (is.null(rope_narrow) | is.null(rope_wide))) {
    stop("`rope`, or `rope_narrow` and `rope_wide`, must be specified.")
  }
  if (is.null(rope)) {
    rope <- colMeans(rbind(rope_narrow, rope_wide))
  }
  # Many checks
  if (rope[2] < rope[1]) {
    stop("`rope[1]` must be less than `rope[2]`.")
  }
  if (rope_narrow[2] < rope_narrow[1]) {
    stop("`rope_narrow[1]` must be less than `rope_narrow[2]`.")
  }
  if (rope_wide[2] < rope_wide[1]) {
    stop("`rope_wide[1]` must be less than `rope_wide[2]`.")
  }
  if (isFALSE(between(rope[1], rope_wide[1], rope_narrow[1]))) {
    stop("`rope[1]` must be between `rope_wide[1]` and `rope_narrow[1]`.")
  }
  if (isFALSE(between(rope[2], rope_narrow[2], rope_wide[2]))) {
    stop("`rope[2]` must be between `rope_narrow[2]` and `rope_wide[2]`.")
  }

  # Compute
  e_less <- loss_less_than(
    x = x,
    rope = rope,
    rope_wide = rope_wide,
    rope_narrow = rope_narrow,
    loss_type = loss_type,
    na.rm = na.rm)
  e_eql <- loss_equivalent(
    x = x,
    rope = rope,
    rope_wide = rope_wide,
    rope_narrow = rope_narrow,
    loss_type = loss_type,
    na.rm = na.rm)
  e_grtr <- loss_greater_than(
    x = x,
    rope = rope,
    rope_wide = rope_wide,
    rope_narrow = rope_narrow,
    loss_type = loss_type,
    na.rm = na.rm)

  decision <- c("less than", "equivalent", "greater than", "uncommitted")[which.min(c(e_less, e_eql, e_grtr, alpha))]

  # Arrange the summary
  data.frame(less_than    = e_less,
             equivalent   = e_eql,
             greater_than = e_grtr,
             uncommitted  = alpha,
             decision = decision)
}

