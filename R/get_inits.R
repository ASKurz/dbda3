#' Get initial values from `brm()` models
#'
#' Extract the `init` values for parameters used in sampling all chains for models of class `brmsfit`. This is a simple analogue to the `get_inits()` function form \pkg{rstan}.
#'
#' @param object An object of class `brmsfit`.
#'
#' @returns A list of lists, one per MCMC chain (4 by default). Within each chain-level list, each component is a named for each parameter for the corresponding chain.
#'
#' @note brms already provides an equivalent `brms::inits.brmsfit()` method with the same output structure. `get_inits()` predates that method and is kept here as a direct analogue to \pkg{rstan}'s `get_inits()`; consider using `brms::inits()` instead.
#'
#' @examples
#' \dontrun{
#' dat <- data.frame(y = rnorm(n = 100))
#' fit <- brm(data = dat, y ~ 1, family = gaussian)
#' get_inits(fit) |> str()
#'}
#'
#' @importFrom brms is.brmsfit
#' @export
get_inits <- function(object) {

  # Check
  if(!is.brmsfit(object)) stop("`object` must be of class `brmsfit`.")

  object$fit@inits
}

