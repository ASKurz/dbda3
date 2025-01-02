#' Identify equal tailed interval region from a grid
#'
#' Given a grid of probability mass values, identify whether each value in the grid is in the quantile-based equal tailed interval (ETI) of interest.
#'
#' @param x A vector of probability mass values. Each value must range from `0` to `1`, and the vector must sum to `1`.
#' @param prob A single numeric value in the range \eqn{[0, 1]} for the desired probability mass of the ETI region. Defaults to `0.95`.
#'
#' @returns A logical vector of the same length as `x`, indicating which values of `x` are within the ETI.
#'
#' @seealso [in_hdi_grid()] to identify highest density interval regions from a grid.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' library(ggplot2)
#' library(tibble)
#'
#' # Use `in_eti_grid()` with vectors
#'
#' # Define a sequence of theta (parameter) values
#' theta_vector <- seq(from = 0, to = 1, by = 0.01)
#' # Compute density values given a beta distribution
#' density_vector <- dbeta(x = theta_vector, shape1 = 3, shape2 = 6)
#' # Convert the `density_vector` values to a probability mass metric (i.e., sum to 1)
#' mass_vector <- density_vector / sum(density_vector)
#' # Compute whether values in the `theta_vector` are within the 95% ETI,
#' # based on their `mass_vector` values
#' in_eti_grid(x = mass_vector) |> str()
#'
#' # Use `in_eti_grid()` within a data frame
#'
#' # Mirror the workflow from above, in a data frame
#' example_df <- data.frame(theta = seq(from = 0, to = 1, by = 0.01)) |>
#'   mutate(density = dbeta(x = theta, shape1 = 3, shape2 = 6)) |>
#'   mutate(mass = density / sum(density)) |>
#'   mutate(in_eti = in_eti_grid(x = mass))
#'
#' # Examine the structure of the resulting data frame
#' glimpse(example_df)
#'
#' # Showcase the results in a plot
#' example_df |>
#'   ggplot(aes(x = theta, y = density, fill = in_eti)) +
#'   geom_col()
#'
#' @export
in_eti_grid <- function(x, prob = 0.95) {

  checkmate::assert_numeric(x, lower = 0, upper = 1)
  checkmate::assert_numeric(prob, lower = 0, upper = 1)
  checkmate::assert_scalar(prob)

  cdf <- cumsum(x)
  rcdf <- cumsum(rev(x))
  tail_low <- cdf <= (1 - prob) / 2
  tail_high <- rev(rcdf <= (1 - prob) / 2)
  in_eti <- tail_low == FALSE & tail_high == FALSE

  return(in_eti)

}

