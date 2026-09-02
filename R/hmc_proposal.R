#' Compute Hamiltonian Monte Carlo proposals
#'
#' This is not a general purpose Hamiltonian Monte Carlo (HMC) sampler. Rather, it's a highly constrained function designed to highlight some of ways HMC samplers determine their proposals, as discussed in Chapter 7 of *DBDA3*. In this case, the posterior distribution for the single parameter \eqn{\theta} is Gaussian with a mean at zero and a standard deviation at one.
#'
#' @param epsilon A numeric value for the step size in the HMC chain, often denoted \eqn{\epsilon}. Defaults to `0.1`.
#' @param l A numeric value for the number of leapfrog step, often denoted \eqn{L}. Defaults to `5`.
#' @param mo_sd A single numeric value for the standard deviation of the momentum distribution, which is Gaussian with a mean at zero. Defaults to `1`.
#' @param init_pos A single numeric value for the initial value on posterior space (theta). Defaults to `2`.
#' @param seed A single numeric value passed to the `seed` argument in `set.seed()`, to make the results computationally reproducible. Defaults to `47405`.
#'
#' @returns A data frame with rows equal to `l + 1`, and two columns, `step` and `proposal`. The `step` column is an index, starting at `0` and ending at `l`, which marks off the steps. The `proposal` column contains the draws from the proposal distribution.
#'
#' @seealso [hmc_plot()] for documentation on we plotted the `hmc_proposal()` output in *DBDA3*.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' library(ggplot2)
#' library(purrr)
#' library(tibble)
#' library(tidyr)
#'
#' # Default results
#' hmc_proposal() |>
#'   glimpse()
#'
#' # Adjust the step size `epsilon`,
#' # the number of leapfrog steps `l`, and
#' # the standard deviation of the momentum distribution `mo_sd`
#' hmc_proposal(epsilon = 0.01, l = 10, mo_sd = 2) |>
#'   glimpse()
#'
#' # Showcase results from a combination of a few `epsilon`, `l`, and `seed` values
#'
#' set.seed(1)
#'
#' crossing(epsilon = c(0.05, 0.1, 0.2, 0.4),
#'          l = c(5, 10, 15, 20)) |>
#'   expand_grid(iteration = 1:30) |>
#'   mutate(seed = sample(1:n())) |>
#'   mutate(h = pmap(.l = list(epsilon, l, seed),
#'                   .f = function(x, y, z) hmc_proposal(epsilon = x, l = y, seed = z))) |>
#'   unnest(h) |>
#'
#'   ggplot(aes(x = proposal, y = step, group = seed)) +
#'   geom_path(linewidth = 1/5) +
#'   facet_grid(l ~ epsilon, labeller = label_both)
#'
#' @importFrom stats rnorm
#' @export
hmc_proposal <- function(epsilon = 0.1,
                         l = 5,
                         mo_sd = 1,
                         init_pos = 2,
                         seed = 47405) {
  # Checks
  checkmate::assert_numeric(epsilon, lower = 0)
  checkmate::assert_numeric(l, lower = 1)
  checkmate::assert_numeric(mo_sd, lower = 0)
  checkmate::assert_numeric(init_pos)
  checkmate::assert_numeric(seed)

  # The gradient of energy for a univariate Gaussian posterior
  gradient <- function(x, mean = 0, sd = 1) {
    # More fully: `(x - mean) / sd`, which simplifies to `x` given the default settings
    x
  }

  # Simplify for the code below
  x <- init_pos

  # Random flick (`phi` is momentum)
  set.seed(seed)
  phi <- rnorm(n = 1, mean = 0, sd = mo_sd)

  # Bookkeeping: Define and initialize proposal and momentum vectors
  proposal_vector <- rep(NA, times = l + 1)
  momentum_vector <- proposal_vector

  proposal_vector[1] <- init_pos
  momentum_vector[1] <- phi

  # Alternate full steps for position and momentum
  for (i in 1:l) {
    # Make a half step in `phi`
    phi <- phi - epsilon * gradient(x) / 2
    # Make a half step in `x` based in the half step in `phi`
    x <- x + epsilon * phi  # Full step for the position
    proposal_vector[i + 1] <- x
    # Make another half step in `phi`
    phi <- phi - epsilon * gradient(x) / 2
    # This step is not strictly necessary for the simulation,
    # but it's typical for normal HMC purposes
    momentum_vector[i + 1] <- phi
  }

  # Convert the primary output to a data frame
  data.frame(
    step = 0:l,
    proposal = proposal_vector)
}

