#' The Metropolis algorithm applied to Bernoulli data (again)
#'
#' This is not a general-purpose sampler. Rather, it's a highly constrained version of the Metropolis algorithm applied to a summary of Bernoulli data and a beta prior, as showcased in Chapter 7 of *DBDA3*.
#'
#' @param seed A single numeric value passed to the `seed` argument in `set.seed()`, to make the results computationally reproducible. Defaults to `47405`.
#' @param n_steps A single numeric value for the number of MCMC steps. Defaults to `1000`.
#' @param z The number of `1`'s (e.g., heads in coin flips, successes in pass/fail trials). Defaults to `9`.
#' @param n The total number of Bernoulli trials. Defaults to `10`.
#' @param a,b The numeric values for the first and second parameters in the beta prior. The values are passed to the `shape1` and `shape2` arguments of the `dbeta()` function, respectively. Both default to `1`.
#'
#' @returns A data frame with rows equal to `n_steps`, and two columns, `step` and `theta`. The `step` column is an index marking off the MCMC steps, starting at `1` and ending at `n_steps`. The `theta` column contains the posterior draws for \eqn{\theta}, the probability parmeter of the Bernoulli likelihood.
#'
#' @importFrom stats dbeta rnorm runif
#' @export
#' @keywords internal
metro_walk_2 <- function(seed = 47405, n_steps = 1000,
                         z = 9, n = 10,
                         a = 1, b = 1) {

  set.seed(seed)

  # Randomly draw proposal SD
  pro_sd <- runif(n = 1, min = 0.15, max = 0.30)

  # Initialize trajectory
  traj <- rep(NA, n_steps)
  traj[1] <- runif(n = 1, min = 0.001, max = 0.999)  # Randomly draw initial position

  for (i in 2:n_steps) {
    cur_pos <- traj[i - 1]
    pro_pos <- (cur_pos + rnorm(n = 1, mean = 0, sd = pro_sd)) |> min(1) |> max(0)
    p_accept <- min(1.0,
                    dbeta(x = pro_pos, shape1 = z + a, shape2 = n - z + b) /
                      dbeta(x = cur_pos, shape1 = z + a, shape2 = n - z + b))
    if (runif(1) <= p_accept) {traj[i] <- pro_pos} else {traj[i] <- cur_pos}
  }

  # Store the primary results in a data frame
  df <- data.frame(step = 1:n_steps,
                   theta = traj)
  return(df)

}

