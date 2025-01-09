#' Plot prior, likelihood, and posterior for a beta Bernoulli model
#'
#' Make figures highlighting the effect a beta prior has on the posterior distribution of the success probability parameter for the Bernoulli likelihood, such as seen in Chapter 5 of *DBDA3*.
#'
#' @param theta A vector of success probabilities ranging from `0` to `1`.
#' @param p_theta A vector of probability mass values for the values of `theta`, of the same length as `theta`.
#' @param z The number of `1`'s for the Bernoulli likelihood.
#' @param n The total number of Bernoulli trials.
#' @param interval The type of credible interval displayed. Must be `"eti"`, `"hdi"`, or `"none"`. Defaults to `"none"`.
#' @param prob A single numeric value in the range \eqn{[0, 1]} for the desired probability mass displayed with the interval. Defaults to `0.95`.
#' @param pp_point A character value for the type of central tendency displayed for the prior and posterior. Must be `"median"`, `"mode"` or `"none"`. Defaults to `"none"`.
#' @param l_point A character value for the type of central tendency displayed for the likelihood. Must be `"max"` or `"none"`. Defaults to `"none"`.
#' @param arrow_linewidth A numeric value for the `linewidth` weight of the arrow marking off the interval. Defaults to `0.67`.
#' @param arrow_length A numeric value for the `length` of the arrow heads marking off the ends of the interval, as measured in inches. Defaults to `0.075`.
#' @param col_width A numeric value for the `width` argument within `geom_col()` for all three panels, which controls the widths of the vertical bars. Defaults to `NULL`.
#' @param fill_color A character value for the `fill` and `color` aesthetic mappings for the columns in `geom_col()`. Defaults to `"gray65"`.
#' @param darken_amount A numeric vector of two values for the `amount` argument within the `darken()` function to decrease and increase the `fill` and `color` values for the interval. Defaults to `c(-0.25, 0.15)`.
#' @param point_size A numeric value for the `size` argument of the central-tendency points in `geom_point()`. Defaults to `1.5`.
#' @param text_size A numeric value for the `size` argument of the text annotation describing the central tendency points, and the data description, in `geom_text()`. Defaults to `3.25`.
#' @param return_post A logical value dictating whether to return the posterior distribution as a numeric vector. Defaults to `FALSE`.
#'
#' @returns If `return_post == FALSE`, an object of class `patchwork`, `gg,` and `ggplot`. If `return_post == TRUE`, a numeric vector the same length as `theta`.
#'
#' @examples
#' # Define the primary input values
#' theta_vector <- seq(from = 0, to = 1, length.out = 51)
#' prior_vector <- pmin(theta_vector, 1 - theta_vector)
#' prior_vector <- prior_vector / sum(prior_vector)  # Normalize `prior_vector`
#' z <- 5
#' n <- 6
#'
#' # Default behavior
#' bern_grid(theta = theta_vector, p_theta = prior_vector, z = z, n = n)
#'
#' # Add modes/95% HDIs
#' bern_grid(theta = theta_vector, p_theta = prior_vector, z = z, n = n,
#'           interval = "hdi",
#'           pp_point = "mode",
#'           l_point = "max")
#'
#' # Add median/67% ETIs
#' bern_grid(theta = theta_vector, p_theta = prior_vector, z = z, n = n,
#'           interval = "eti",
#'           prob = 0.67,
#'           pp_point = "median")
#'
#' # Make further aesthetic adjustments
#' bern_grid(theta = theta_vector, p_theta = prior_vector, z = z, n = n,
#'           interval = "eti",
#'           prob = 0.67,
#'           pp_point = "median",
#'           # new settings
#'           arrow_linewidth = 1.5,
#'           arrow_length = 0.125,
#'           col_width = 0.01,
#'           fill_color = "skyblue2",
#'           darken_amount = c(-0.4, 0.3),
#'           point_size = 3,
#'           text_size = 4)
#'
#' # Return the vector of posterior values
#' posterior_vector <- bern_grid(theta = theta_vector, p_theta = prior_vector, z = z, n = n,
#'                               return_post = TRUE)
#' str(posterior_vector)
#'
#' # Use the `posterior_vector` in `p_theta` and update `z` and `n`
#' bern_grid(theta = theta_vector, p_theta = posterior_vector, z = z + 1, n = n + 1)
#'
#' @importFrom colorspace darken
#' @importFrom stringr str_c
#' @import dplyr ggplot2 patchwork
#' @export
bern_grid <- function(theta, p_theta, z, n,  # The primary arguments
                      # Interval arguments
                      interval = c("eti", "hdi", "none")[3],
                      prob = 0.95,
                      # Central tendency arguments
                      pp_point = c("median", "mode", "none")[3],
                      l_point = c("max", "none")[2],
                      # General aesthetic arguments
                      arrow_linewidth = 0.67,
                      arrow_length = 0.075,
                      col_width = NULL,
                      fill_color = "gray65",
                      darken_amount = c(-0.25, 0.15),
                      point_size = 1.5,
                      text_size = 3.25,
                      return_post = c(TRUE, FALSE)[2]) {

  checkmate::assert_numeric(z, lower = 0)
  checkmate::assert_numeric(n, lower = 1)
  checkmate::assert_numeric(prob, lower = 0, upper = 1)
  checkmate::assert_choice(interval, choices = c("eti", "hdi", "none"))
  checkmate::assert_choice(pp_point, choices = c("mean", "median", "mode", "none"))
  checkmate::assert_choice(l_point, choices = c("max", "none"))

  # Make the primary data frame
  grid_df <- data.frame(theta = theta,
                        prior = p_theta,
                        n = n,
                        z = z) |>
    mutate(likelihood = dbern(x = theta, z = z, n = n)) |>
    mutate(posterior = (prior * likelihood) / sum(prior * likelihood))

  # Compute the upper limit for the y axis of the prior and posterior
  pp_ylim_upper <- grid_df |>
    summarise(max = max(prior, posterior)) |>
    mutate(max = ifelse(pp_point == "none", max, max * 1.2)) |>
    pull()

  # Compute the upper limit for the y axis of the likelihood (for the annotation)
  l_ylim_upper <- grid_df |>
    summarise(max = max(likelihood)) |>
    mutate(max = ifelse(l_point == "none", max, max * 1.2)) |>
    pull()

  # For the annotation in the likelihood panel
  text_df <- data.frame(
    hjust = ifelse(z / n >= 0.5, 0, 1),
    label = str_c("'Data:'~{italic(z)==", z, "}*', '*italic(N)==", n),
    likelihood = l_ylim_upper,
    theta = ifelse(z / n >= 0.5, 0, 1))

  # Intervals
  if (interval == "hdi") {
    # Augment primary data frame with HDI information
    grid_df <- grid_df |>
      mutate(prior_in_hdi = in_hdi_grid(prior, prob = prob),
             posterior_in_hdi = in_hdi_grid(posterior, prob = prob))
    # Initial prior panel
    p1 <- grid_df |>
      ggplot(aes(x = theta, y = prior)) +
      geom_col(aes(color = prior_in_hdi, fill = prior_in_hdi),
               width = col_width) +
      geom_line(data = grid_df |>
                  # The `index`, `diff`, and `group` columns handle broken HDI regions
                  mutate(index = 1:n()) |>
                  filter(prior_in_hdi == TRUE) |>
                  mutate(diff = case_when(index - lag(index) > 1 ~ 1,
                                          TRUE ~ 0),
                         group = cumsum(diff),
                         prior = 0),
                aes(group = group),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_color_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE)) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))
    # Initial posterior panel
    p3 <- grid_df |>
      ggplot(aes(x = theta, y = posterior)) +
      geom_col(aes(color = posterior_in_hdi, fill = posterior_in_hdi),
               width = col_width) +
      geom_line(data = grid_df |>
                  mutate(index = 1:n()) |>
                  filter(posterior_in_hdi == TRUE) |>
                  mutate(diff = case_when(index - lag(index) > 1 ~ 1,
                                          TRUE ~ 0),
                         group = cumsum(diff),
                         posterior = 0),
                aes(group = group),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_color_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE)) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))
  }
  if (interval == "eti") {
    # Augment primary data frame with ETI information
    grid_df <- grid_df |>
      mutate(prior_in_eti = in_eti_grid(prior, prob = prob),
             posterior_in_eti = in_eti_grid(posterior, prob = prob))
    # Initial prior panel
    p1 <- grid_df |>
      ggplot(aes(x = theta, y = prior)) +
      geom_col(aes(color = prior_in_eti, fill = prior_in_eti),
               width = col_width) +
      geom_line(data = grid_df |>
                  filter(prior_in_eti == TRUE) |>
                  mutate(prior = 0),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_color_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE)) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))
    # Initial posterior panel
    p3 <- grid_df |>
      ggplot(aes(x = theta, y = posterior)) +
      geom_col(aes(color = posterior_in_eti, fill = posterior_in_eti),
               width = col_width) +
      geom_line(data = grid_df |>
                  filter(posterior_in_eti == TRUE) |>
                  mutate(posterior = 0),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_color_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE)) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))
  }
  if (interval == "none") {
    # Initial prior panel
    p1 <- grid_df |>
      ggplot(aes(x = theta, y = prior)) +
      geom_col(color = fill_color, fill = fill_color, width = col_width)
    # Initial posterior panel
    p3 <- grid_df |>
      ggplot(aes(x = theta, y = posterior)) +
      geom_col(color = fill_color, fill = fill_color, width = col_width)
  }

  # Prior/posterior central tendency point
  if (pp_point == "mode") {
    # Add mode to prior panel
    p1 <- p1 +
      geom_point(data = grid_df |>
                   slice_max(prior),
                 size = point_size) +
      geom_text(data = grid_df |>
                  slice_max(prior) |>
                  mutate(label = formatC(x = theta, digits = 3, format = "f")),
                aes(label = label),
                size = text_size, vjust = -0.75)
    # Add mode to posterior panel
    p3 <- p3 +
      geom_point(data = grid_df |>
                   slice_max(posterior),
                 size = point_size) +
      geom_text(data = grid_df |>
                  slice_max(posterior) |>
                  mutate(label = formatC(x = theta, digits = 3, format = "f")),
                aes(label = label),
                size = text_size, vjust = -0.75)

  }
  if (pp_point == "median") {
    # Add median to prior panel
    p1 <- p1 +
      geom_point(data = grid_df |>
                   filter(cumsum(prior) >= 0.5) |>
                   slice_min(theta),
                 size = point_size) +
      geom_text(data = grid_df |>
                  filter(cumsum(prior) >= 0.5) |>
                  slice_min(theta) |>
                  mutate(label = formatC(x = theta, digits = 3, format = "f")),
                aes(label = label),
                size = text_size, vjust = -0.75)
    # Add median to posterior panel
    p3 <- p3 +
      geom_point(data = grid_df |>
                   filter(cumsum(posterior) >= 0.5) |>
                   slice_min(theta),
                 size = point_size) +
      geom_text(data = grid_df |>
                  filter(cumsum(posterior) >= 0.5) |>
                  slice_min(theta) |>
                  mutate(label = formatC(x = theta, digits = 3, format = "f")),
                aes(label = label),
                size = text_size, vjust = -0.75)
  }

  # Initial likelihood panel
  p2 <- grid_df |>
    ggplot(aes(x = theta, y = likelihood)) +
    geom_point(color = fill_color, size = 1) +
    geom_text(data = text_df,
              aes(label = label, hjust = hjust),
              parse = TRUE, size = text_size, vjust = 1)

  # Likelihood z / n (max) point
  if (l_point == "max") {
    # Augment likelihood panel with max
    p2 <- p2 +
      geom_point(data = grid_df |>
                   slice_max(likelihood),
                 size = point_size) +
      geom_text(data = grid_df |>
                  slice_max(likelihood) |>
                  mutate(label = formatC(x = theta, digits = 3, format = "f")),
                aes(label = label),
                size = text_size, vjust = -0.75)

  }

  # Add final adjustments
  # Adjust prior panel
  p1 <- p1 +
    scale_x_continuous(NULL, breaks = NULL) +
    scale_y_continuous(expression(italic(p)(theta)), limits = c(0, pp_ylim_upper)) +
    coord_cartesian(xlim = 0:1) +
    labs(subtitle = "Prior") +
    theme(panel.grid = element_blank())
  # Adjust likelihood panel
  p2 <- p2 +
    scale_x_continuous(NULL, breaks = NULL) +
    scale_y_continuous(expression(italic(p)(D*'|'*theta)), limits = c(0, l_ylim_upper)) +
    coord_cartesian(xlim = 0:1) +
    labs(subtitle = "Likelihood") +
    theme(panel.grid = element_blank())
  # Adjust posterior panel
  p3 <- p3 +
    scale_x_continuous(expression(theta), breaks = 0:5 / 5) +
    scale_y_continuous(expression(italic(p)(theta*'|'*D)), limits = c(0, pp_ylim_upper)) +
    coord_cartesian(xlim = 0:1) +
    labs(subtitle = "Posterior") +
    theme(panel.grid = element_blank())

  # Return plot or posterior vector
  if (return_post == FALSE) {
    print(p1 / p2 / p3)
  } else {
    pull(grid_df, posterior)
  }

}

