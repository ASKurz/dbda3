#' The Gibbs sampler applied to a 2-dimensional binomial model
#'
#' This is not a general-purpose sampler. Rather, it's a highly constrained version of the Gibbs sampler applied to a summary of two sequences of Bernoulli data, and two beta priors, as showcased in Chapter 7 of *DBDA3*.
#'
#' @param init_pos A numeric vector of two values defining the initial positions for the two parameters. Defaults to `c(0.01, 0.01)`.
#' @param n_cycle A single numeric value for the number of Gibbs cycles. Defaults to `350`.
#' @param seed A single numeric value passed to the `seed` argument in `set.seed()`, to make the results computationally reproducible. Defaults to `47405`.
#' @param z1,z2 The number of `1`'s (e.g., heads in coin flips, successes in pass/fail trials), in each of the two data examples. Default to `5` and `2`, respectively.
#' @param n1,n2 The total number of Bernoulli trials, in each of the two examples. Default to `7` and `7`.
#' @param a1,a2 The numeric value denoting the first parameter in the beta prior for each of the two examples. Each value is passed to the `shape1` argument in the `dbeta()` function. Default to `1` and `1`.
#' @param b1,b2 The numeric value denoting the second parameter in the beta prior for each of the two examples. Each value is passed to the `shape2` argument in the `dbeta()` function. Default to `1` and `1`.
#' @param exclude_inits A logical value indicating whether to drop the initial values. Defaults to `TRUE`.
#'
#' @returns A data frame with rows equal to `n_steps`, and two columns, `step` and `theta`. The `step` column is an index, starting at `1` and ending at `n_steps`, which marks off the MCMC steps. The `theta` column contains the posterior draws for the focal parameter,  \eqn{theta}.
#'
#' @examples
#' library(ggplot2)
#' library(tibble)
#'
#' # Default results
#'
#' # Save the default output
#' gibbs_df <- gibbs_walk()
#'
#' # Examine the structure of the results
#' glimpse(gibbs_df)
#'
#' # Showcase the results in a 2-dimensional line plot
#' gibbs_df |>
#'   ggplot(aes(x = theta1, y = theta2)) +
#'   geom_path(linewidth = 0.1) +
#'   coord_equal(xlim = 0:1, ylim = 0:1) +
#'   ggtitle("Default setting")
#'
#' # Change the default settings
#'
#' gibbs_walk(
#'   # Set the initial position in the middle of the parameter space
#'   init_pos = c(0.5, 0.5),
#'   # Shorten the cycle and change the `seed`
#'   n_cycle = 200, seed = 1,
#'   # New data and new priors
#'   z1 = 2, n1 = 20, a1 = 5, b1 = 5,
#'   z2 = 18, n2 = 20, a2 = 5, b2 = 5) |>
#'
#'   # Plot the results
#'   ggplot(aes(x = theta1, y = theta2)) +
#'   geom_path(linewidth = 0.1) +
#'   coord_equal(xlim = 0:1, ylim = 0:1) +
#'   ggtitle("Off the defaults")
#'
#' @export
gibbs_walk <- function(init_pos = c(0.01, 0.01),
                       n_cycle = 350, seed = 47405,
                       z1 = 5, n1 = 7, a1 = 1, b1 = 1,
                       z2 = 2, n2 = 7, a2 = 1, b2 = 1,
                       exclude_inits = TRUE) {
  # Checks
  checkmate::assert_numeric(init_pos, lower = 0, upper = 1)
  checkmate::assert_numeric(n_cycle, lower = 0)
  checkmate::assert_numeric(seed)
  checkmate::assert_numeric(z1, lower = 0)
  checkmate::assert_numeric(n1, lower = 1)
  checkmate::assert_numeric(a1, lower = 0)
  checkmate::assert_numeric(b1, lower = 0)
  checkmate::assert_numeric(z2, lower = 0)
  checkmate::assert_numeric(n2, lower = 1)
  checkmate::assert_numeric(a2, lower = 0)
  checkmate::assert_numeric(b2, lower = 0)
  checkmate::assert_logical(exclude_inits)

  # Number of parameters:
  n_param <- 2  # theta_1 and theta_2

  # Set up matrix for storing the MCMC walk (aka trajectory)
  traj_col_names <- c("step", "param", "cycle_fin", "theta1", "theta2")
  traj <- matrix(0.0,
                 nrow = n_cycle * n_param + 1,  # `+ 1` for the initial position
                 ncol = length(traj_col_names))
  colnames(traj) <- traj_col_names
  traj[1, c("step", "theta1", "theta2")] <- c(1, init_pos)

  # Generate MCMC walk
  set.seed(seed)
  step_idx <- 1  # Initialize step index
  while (step_idx < nrow(traj)) {
    step_idx <- step_idx + 1                # Increment step index
    param_idx <- (step_idx %% n_param) + 1  # Compute parameter index
    traj[step_idx, "step"] <- step_idx
    traj[step_idx, "param"] <- param_idx
    traj[step_idx, "cycle_fin"] <- ifelse(param_idx == n_param, 1, 0)
    # Copy previous position before sampling one parameter
    traj[step_idx, c("theta1", "theta2")] <-
      traj[step_idx - 1, c("theta1", "theta2")]
    # Sample one parameter:
    traj[step_idx, c("theta1", "theta2")[param_idx]] <-
      switch(param_idx,
             rbeta(n = 1, shape1 = a1 + z1, shape2 = b1 + n1 - z1),
             rbeta(n = 1, shape1 = a2 + z2, shape2 = b2 + n2 - z2))
  }

  # df_traj <- data.frame( traj[ traj[,"step"] > 2 , ] ) # exclude init's

  # Convert the output to a data frame
  if (isTRUE(exclude_inits)) {
    data.frame(traj[traj[, "step"] > 2, ])
  } else {
    data.frame(traj)
  }
}

