#' Plot the output of `hmc_proposal()`
#'
#' Make figures displaying Hamiltonian Monte Carlo proposal distributions, based on the output of the `hmc_proposal()` function. This will produce figures with four panels, as seen in *DBDA3* Chapter 8. The first panel displays the posterior distribution and the initial position of the random walk. The second panel depicts the potential energy, and a random impulse. The third panel displays the trajectories from several impulses. The fourth panel shows a histogram of the final proposals from the third panel.
#'
#' @param hmc_data A data frame containing at least four columns:
#'  * `impulse` An integer row index doubling as an index for the HMC impulses.
#'  * `epsilon` A numeric vector for the step size in the HMC chain for each impulse, often denoted \eqn{\epsilon}. Corresponds to the values passed to the `epsilon` argument in the `hmc_proposal()` function.
#'  * `step` A numeric vector of steps returned by the `hmc_proposal()` function.
#'  * `proposal` A numeric vector of HMC proposal values returned by the `hmc_proposal()` function.
#' @param mo_sd A single numeric value for the standard deviation of the momentum distribution, which is Gaussian with a mean at zero. In the plot, this value controls the width of the arrows depicting the random impulse. Defaults to `1`.
#' @param fill_color The predominant color used in the first, second, and fourth panels. Defaults to `"#82BAD8"`.
#' @param line_color The color of the trajectory lines in the third panel. Defaults to `"#B6242F"`.
#'
#' @returns An object of class `patchwork`, `gg,` and `ggplot`.
#'
#' @seealso [hmc_proposal()] for documentation on the HMC proposal inputs.
#'
#' @examples
#' # Load
#' library(dplyr)
#' library(purrr)
#'
#' # Make the primary data frame
#' hmc_df <- data.frame(
#'   impulse = 1:1e3,
#'   epsilon = runif(n = 1e3, min = 0.005, max = 0.195)) |>
#'   mutate(l = runif(n = 1e3, min = 1 / epsilon, max = pi / (2 * epsilon)) |> ceiling()) |>
#'   mutate(hmc = pmap(.l = list(epsilon, l, impulse),
#'                     .f = function(x, y, z) hmc_proposal(epsilon = x, l = y, seed = z))) |>
#'   unnest(hmc)
#'
#' # Plot
#' plot_hmc(hmc_df)
#'
#' @import dplyr ggplot2 patchwork
#' @export
plot_hmc <- function(hmc_data,
                     mo_sd = 1,
                     fill_color = "#82BAD8",
                     line_color = "#B6242F") {

  # Check the `hmc_data` input
  checkmate::assert_data_frame(hmc_data)
  checkmate::assert_names(names(hmc_data),
                          must.include = c("impulse", "epsilon", "step", "proposal"))
  checkmate::assert_numeric(mo_sd, lower = 0)

  # Check the `mo_sd` input
  checkmate::assert_numeric(mo_sd, lower = 0, finite = TRUE)

  # Make the primary data frame for the first two panels
  post_df <- data.frame(theta = seq(from = -4, to = 4, length.out = 501)) |>
    mutate(density = dnorm(x = theta, mean = 0, sd = 1),
           neg_log_density = dnorm(x = theta, mean = 0, sd = 1, log = TRUE))

  # Save these values for some of the panels
  impulse_subset <- 100
  point_size <- 3
  init_pos <- 2.0

  # First panel
  p1 <- post_df |>
    ggplot(aes(x = theta, y = density)) +
    geom_area(fill = fill_color) +
    geom_point(data = post_df |>
                 filter(theta == init_pos),
               size = point_size) +
    geom_text(data = post_df |>
                filter(theta == init_pos),
              label = "Current\nposition",
              hjust = 0.5, size = 3, vjust = -0.4) +
    scale_x_continuous(NULL, breaks = NULL) +
    ylab("Density") +
    facet_wrap(~ "Posterior distribution")

  # Second panel
  p2 <- post_df |>
    ggplot(aes(x = theta, y = -neg_log_density)) +
    geom_line(color = fill_color, linewidth = 1) +
    geom_point(data = post_df |>
                 filter(theta == init_pos),
               size = point_size) +
    geom_line(data = post_df |>
                filter(theta == init_pos) |>
                expand_grid(row = 1:2) |>
                mutate(theta = init_pos + c(-1, 1) * 0.65 * mo_sd),
              arrow = arrow(length = unit(0.075, "inches"), ends = "both"),
              linewidth = 0.5) +
    geom_text(data = post_df |>
                filter(theta == init_pos),
              label = "Random\nimpulse",
              hjust = 0.5, size = 3, vjust = -0.4)  +
    scale_x_continuous(NULL, breaks = NULL) +
    ylab("-log(Density)") +
    facet_wrap(~ 'Negative log posterior: "Potential"')

  # Third panel
  p3 <- hmc_data |>
    filter(impulse <= impulse_subset) |>
    ggplot(aes(x = proposal, y = step * epsilon, group = impulse)) +
    geom_path(alpha = 2/3, color = line_color, linewidth = 1/15) +
    geom_point(data = hmc_data |>
                 filter(impulse <= impulse_subset) |>
                 group_by(impulse) |>
                 slice_max(step),
               size = point_size / 5) +
    geom_point(data = hmc_data |>
                 filter(impulse == 1, step == 0),
               size = point_size) +
    scale_x_continuous(NULL, breaks = NULL) +
    ylab(expression(Step%*%epsilon)) +
    facet_wrap(~ 'Hamiltonian dynamics')

  # Fourth panel
  p4 <- hmc_data |>
    group_by(impulse) |>
    filter(step == max(step))  |>

    ggplot(aes(x = proposal, y = after_stat(density))) +
    geom_histogram(binwidth = 0.2, fill = fill_color) +
    annotate(geom = "point",
             x = init_pos, y = 0,
             size = point_size) +
    labs(x = expression(theta),
         y = "Density") +
    facet_wrap(~ 'Hamiltonian MC proposals')

  # Combine panels, adjust `xlim`, and print
  p1 / p2 / p3 / p4 &
    coord_cartesian(xlim = c(-3.5, 3.5)) &
    theme_gray(base_size = 13) &
    theme(panel.grid = element_blank())
}

