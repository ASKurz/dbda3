#' The Metropolis algorithm applied to Bernoulli data
#'
#' This is not a general-purpose sampler. Rather, it's a highly constrained version of the Metropolis algorithm applied to a summary of Bernoulli data and a beta prior, as showcased in Chapter 7 of *DBDA3*.
#'
#' @param pro_sd A single numeric value for the standard deviation of the proposal distribution, which is Gaussian with a mean at the current position. Defaults to `0.02`.
#' @param init_pos A single numeric value for the initial position of the walk. Defaults to `0.01`.
#' @param n_steps A single numeric value for the number of MCMC steps. Defaults to `2000`.
#' @param seed A single numeric value passed to the `seed` argument in `set.seed()`, to make the results computationally reproducible. Defaults to `47405`.
#' @param z The number of `1`'s (e.g., heads in coin flips, successes in pass/fail trials). Defaults to `14`.
#' @param n The total number of Bernoulli trials. Defaults to `20`.
#' @param a,b The numeric values for the first and second parameters in the beta prior. The values are passed to the `shape1` and `shape2` arguments of the `dbeta()` function, respectively. Both default to `1`.
#'
#' @returns A data frame with rows equal to `n_steps`, and two columns, `step` and `theta`. The `step` column is an index marking off the MCMC steps, starting at `1` and ending at `n_steps`. The `theta` column contains the posterior draws for \eqn{\theta}, the probability parmeter of the Bernoulli likelihood.
#'
#' @examples
#' library(ggplot2)
#' library(patchwork)
#' library(tibble)
#'
#' # Save the default output
#' metro_df <- metro_walk()
#'
#' # Examine the structure of the results
#' glimpse(metro_df)
#'
#' # Showcase the Metropolis samples in a diagnostic plot
#'
#' # Trace plot
#' p1 <- metro_df |>
#'   ggplot(aes(x = step, y = theta)) +
#'   geom_line() +
#'   ylim(0:1)
#'
#' # Histogram
#' p2 <- metro_df |>
#'   ggplot(aes(x = theta)) +
#'   geom_histogram(aes(y = after_stat(density)),
#'                  binwidth = 0.02, boundary = 0) +
#'   stat_function(fun = dbeta,
#'                 args = list(shape1 = 14 + 1, shape2 = 20 - 14 + 1),
#'                 color = "red") +
#'   coord_flip() +
#'   scale_x_continuous(NULL, labels = NULL, limits = 0:1) +
#'   scale_y_continuous(NULL, breaks = NULL) +
#'   theme(axis.ticks.y = element_blank())
#'
#' # Combine, entitle, adjust, and display
#' p1 + p2 +
#'   plot_annotation(title = "Trace plot and histogram",
#'                   subtitle = "The red line shows the analytic solution.") +
#'   plot_layout(widths = c(4, 1))
#'
#' @importFrom stats dbeta rnorm runif
#' @export
metro_walk <- function(pro_sd = 0.02, init_pos = 0.01,
                       n_steps = 2000, seed = 47405,
                       z = 14, n = 20,
                       a = 1, b = 1) {

  checkmate::assert_numeric(pro_sd, lower = 0)
  checkmate::assert_numeric(init_pos, lower = 0, upper = 1)
  checkmate::assert_numeric(n_steps, lower = 0)
  checkmate::assert_numeric(seed, null.ok = TRUE)
  checkmate::assert_numeric(z, lower = 0)
  checkmate::assert_numeric(n, lower = 1)
  checkmate::assert_numeric(a, lower = 0)
  checkmate::assert_numeric(b, lower = 0)

  # Bernoulli likelihood function
  likelihood <- function(theta) {
    ifelse(theta >= 0.0 & theta <= 1.0,  # Check for `theta` in range
           theta^z * (1.0 - theta)^(n - z), 0.0)
  }

  # Beta prior
  prior <- function(theta) {
    ifelse(theta >= 0.0 & theta <= 1.0,  # Check for `theta` in range
           dbeta(x = theta, shape1 = a, shape2 = b), 0.0)
  }

  # Initialize the trajectory
  traj <- rep(NA, n_steps)
  traj[1] <- init_pos

  set.seed(seed)

  for (i in 2:n_steps) {
    # Define the current position (starting with `init_pos` for the first step)
    cur_pos <- traj[i - 1]
    # Define the proposal position as the current position plus a random Gaussian deviation (the proposed jump)
    pro_pos <- cur_pos + rnorm(n = 1, mean = 0, sd = pro_sd)
    # Accept or reject the proposal position
    p_accept <- min(1.0,
                    (likelihood(theta = pro_pos) * prior(theta = pro_pos)) /
                      (likelihood(theta = cur_pos) * prior(theta = cur_pos)))
    accept <- runif(n = 1, min = 0, max = 1) <= p_accept
    traj[i] <- ifelse(accept, pro_pos, cur_pos)
  }

  # Store the primary results in a data frame
  data.frame(step = 1:n_steps,
             theta = traj)
}

