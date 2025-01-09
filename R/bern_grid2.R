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
#' @param pp_point A character value for the type of central tendency displayed for the prior and posterior. Must be `"mean"`, `"median"`, `"mode"` or `"none"`. Defaults to `"none"`.
#' @param l_point A character value for the type of central tendency displayed for the likelihood. Must be `"max"` or `"none"`. Defaults to `"none"`.
#' @param arrow_linewidth A numeric value for the `linewidth` weight of the arrow marking off the interval. Defaults to `0.67`.
#' @param arrow_length A numeric value for the `length` of the arrow heads marking off the ends of the interval, as measured in inches. Defaults to `0.075`.
#' @param col_width A numeric value for the `width` argument within `geom_col()` for all three panels, which controls the widths of the vertical bars. Defaults to `NULL`.
#' @param fill_color A character value for the `fill` and `color` aesthetic mappings for the columns in `geom_col()`. Defaults to `"gray70"`.
#' @param darken_amount A numeric vector of two values for the `amount` argument within the `darken()` function to decrease and increase the `fill` and `color` values for the interval. Defaults to `c(-0.15, 0.15)`.
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
#' bern_grid2(theta = theta_vector, p_theta = prior_vector, z = z, n = n)
#'
#' # Add modes/95% HDIs
#' bern_grid2(theta = theta_vector, p_theta = prior_vector, z = z, n = n,
#'           interval = "hdi",
#'           pp_point = "mode",
#'           l_point = "max")
#'
#' # Add median/66.7% ETIs
#' bern_grid2(theta = theta_vector, p_theta = prior_vector, z = z, n = n,
#'           interval = "eti",
#'           prob = 0.667,
#'           pp_point = "median")
#'
#' # Add mean and ML
#' bern_grid2(theta = theta_vector, p_theta = prior_vector, z = z, n = n,
#'           pp_point = "mean",
#'           l_point = "max")
#'
#' # Make further aesthetic adjustments
#' bern_grid2(theta = theta_vector, p_theta = prior_vector, z = z, n = n,
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
#' posterior_vector <- bern_grid2(theta = theta_vector, p_theta = prior_vector, z = z, n = n,
#'                               return_post = TRUE)
#' str(posterior_vector)
#'
#' # Use the `posterior_vector` in `p_theta` and update `z` and `n`
#' bern_grid2(theta = theta_vector, p_theta = posterior_vector, z = z + 1, n = n + 1)
#'
#' @importFrom colorspace darken
#' @importFrom stringr str_c str_to_sentence str_to_upper
#' @import dplyr ggplot2 patchwork
#' @export
bern_grid2 <- function(theta, p_theta, z, n,  # The primary arguments
                      # Interval arguments
                      interval = c("eti", "hdi", "none")[3],
                      prob = 0.95,
                      # Central tendency arguments
                      pp_point = c("mean", "median", "mode", "none")[4],
                      l_point = c("max", "none")[2],
                      # General aesthetic arguments
                      arrow_linewidth = 0.67,
                      arrow_length = 0.075,
                      col_width = NULL,
                      fill_color = "gray70",
                      darken_amount = c(-0.15, 0.15),
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
                        prior = p_theta) |>
    mutate(likelihood = dbern(x = theta, z = z, n = n)) |>
    mutate(posterior = (prior * likelihood) / sum(prior * likelihood)) |>
    mutate(prior_in_interval = case_when(interval == "eti" ~ in_eti_grid(prior, prob = prob),
                                         interval == "hdi" ~ in_hdi_grid(prior, prob = prob),
                                         interval == "none" ~ NA),
           posterior_in_interval = case_when(interval == "eti" ~ in_eti_grid(posterior, prob = prob),
                                             interval == "hdi" ~ in_hdi_grid(posterior, prob = prob),
                                             interval == "none" ~ NA))

  # Compute the upper limit for the y axis of the prior and posterior
  pp_ylim_upper <- grid_df |>
    summarise(max = max(prior, posterior)) |>
    pull()

  # Compute the upper limit for the y axis of the likelihood (for the annotation)
  l_ylim_upper <- grid_df |>
    summarise(max = max(likelihood)) |>
    pull()

  # For the annotation in the likelihood panel
  text_df <- data.frame(
    hjust = ifelse(z / n >= 0.5, 0, 1),
    label = str_c("'Data:'~{italic(z)==", z, "}*', '*italic(N)==", n),
    likelihood = l_ylim_upper,
    theta = ifelse(z / n >= 0.5, 0, 1))

  # Compute and save the number of rows equal to the mode (to accommodate multi-modality)
  n_mode_prior <- grid_df |>
    slice_max(prior) |>
    nrow()
  n_mode_posterior <- grid_df |>
    slice_max(posterior) |>
    nrow()

  # Intervals
  if (interval == "eti" | interval == "hdi") {
    # Initial prior panel with interval information
    p1 <- grid_df |>
      ggplot(aes(x = theta, y = prior)) +
      geom_col(aes(color = prior_in_interval, fill = prior_in_interval),
               width = col_width) +
      geom_line(data = grid_df |>
                  # The `index`, `diff`, and `group` columns handle broken HDI regions
                  mutate(index = 1:n()) |>
                  filter(prior_in_interval == TRUE) |>
                  mutate(diff = case_when(index - lag(index) > 1 ~ 1,
                                          TRUE ~ 0),
                         group = cumsum(diff),
                         prior = 0),
                aes(group = group),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_color_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE)) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))

    # Initial posterior panel with interval information
    p3 <- grid_df |>
      ggplot(aes(x = theta, y = posterior)) +
      geom_col(aes(color = posterior_in_interval, fill = posterior_in_interval),
               width = col_width) +
      geom_line(data = grid_df |>
                  mutate(index = 1:n()) |>
                  filter(posterior_in_interval == TRUE) |>
                  mutate(diff = case_when(index - lag(index) > 1 ~ 1,
                                          TRUE ~ 0),
                         group = cumsum(diff),
                         posterior = 0),
                aes(group = group),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_color_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE)) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))
  } else if (interval == "none") {
    # Initial prior panel
    p1 <- grid_df |>
      ggplot(aes(x = theta, y = prior)) +
      geom_col(color = fill_color, fill = fill_color, width = col_width)

    # Initial posterior panel
    p3 <- grid_df |>
      ggplot(aes(x = theta, y = posterior)) +
      geom_col(color = fill_color, fill = fill_color, width = col_width)
  }

  # Prior/posterior central tendency points
  if (pp_point != "none") {
    # Save a common character value
    pp_point_name <- str_to_sentence(pp_point)

    # Prior panel
    if (pp_point %in% c("mean", "median") | (pp_point == "mode" & n_mode_prior == 1)) {
      # Make supporting data frame for the dot and text annotation
      prior_point_df <- grid_df |>
        summarise(
          theta = case_when(
            pp_point == "mean"   ~ sum(theta * prior),
            pp_point == "median" ~ min(theta[cumsum(prior) >= 0.5]),
            pp_point == "mode"   ~ theta[prior == max(prior)]),
          prior = 0,
          point_label = formatC(x = theta, digits = 3, format = "f"),
          hjust = case_when(
            theta < 0.05 ~ 0,
            theta < 0.95 ~ 0.5,
            theta >= 0.95 ~ 1))

      # Add point to prior panel
      p1 <- p1 +
        geom_point(data = prior_point_df,
                   size = point_size) +
        geom_text(data = prior_point_df,
                  aes(label = point_label, hjust = hjust),
                  size = text_size, vjust = -0.75)
    }
    # Posterior panel
    if (pp_point %in% c("mean", "median") | (pp_point == "mode" & n_mode_posterior == 1)) {
      # Make supporting data frame for the dot and text annotation
      posterior_point_df <- grid_df |>
        summarise(
          theta = case_when(
            pp_point == "mean"   ~ sum(theta * posterior),
            pp_point == "median" ~ min(theta[cumsum(posterior) >= 0.5]),
            pp_point == "mode"   ~ theta[posterior == max(posterior)]),
          posterior = 0,
          point_label = formatC(x = theta, digits = 3, format = "f"),
          hjust = case_when(
            theta < 0.05 ~ 0,
            theta < 0.95 ~ 0.5,
            theta >= 0.95 ~ 1))

      # Add point to prior panel
      p3 <- p3 +
        geom_point(data = posterior_point_df,
                   size = point_size) +
        geom_text(data = posterior_point_df,
                  aes(label = point_label, hjust = hjust),
                  size = text_size, vjust = -0.75)
    }
  }

  # Prior/posterior point/interval name label
  if (pp_point != "none" | interval != "none") {
    # Make supporting data frame for the prior name label
    prior_label_df <- grid_df |>
      summarise(
        theta = case_when(
          pp_point == "mean" ~ sum(theta * prior),
          pp_point == "median" ~ min(theta[cumsum(prior) >= 0.5]),
          pp_point == "mode" & interval != "none" & n_mode_prior == 1  ~ theta[prior == max(prior)],
          pp_point == "mode" & interval != "none" & n_mode_prior > 1  ~ median(theta[prior_in_interval == TRUE]),
          pp_point == "mode" & interval == "none" ~ theta[prior == max(prior)],
          pp_point == "none" & interval != "none" ~ median(theta[prior_in_interval == TRUE])),
        prior = 0,
        text_label = case_when(
          interval == "none" ~ pp_point_name,
          pp_point %in% c("mean", "median") & interval != "none" ~ str_c(pp_point_name, ", ", as.character(100 * prob), "% ", str_to_upper(interval)),
          pp_point == "mode" & interval != "none" & n_mode_prior == 1 ~ str_c(pp_point_name, ", ", as.character(100 * prob), "% ", str_to_upper(interval)),
          pp_point == "mode" & interval != "none" & n_mode_prior > 1 ~ str_c(as.character(100 * prob), "% ", str_to_upper(interval)),
          pp_point == "none" & interval != "none" ~ str_c(as.character(100 * prob), "% ", str_to_upper(interval))),
        hjust = case_when(
          theta < 0.05 ~ 0,
          theta < 0.95 ~ 0.5,
          theta >= 0.95 ~ 1),
        vjust = ifelse(pp_point == "none", -0.75, -2.25))

    # Make supporting data frame for the posterior name label
    posterior_label_df <- grid_df |>
      summarise(
        theta = case_when(
          pp_point == "mean" ~ sum(theta * posterior),
          pp_point == "median" ~ min(theta[cumsum(posterior) >= 0.5]),
          pp_point == "mode" & interval != "none" & n_mode_prior == 1  ~ theta[posterior == max(posterior)],
          pp_point == "mode" & interval != "none" & n_mode_prior > 1  ~ median(theta[posterior_in_interval == TRUE]),
          pp_point == "mode" & interval == "none" ~ theta[posterior == max(posterior)],
          pp_point == "none" & interval != "none" ~ median(theta[posterior_in_interval == TRUE])),
        posterior = 0,
        text_label = case_when(
          interval == "none" ~ pp_point_name,
          pp_point %in% c("mean", "median") & interval != "none" ~ str_c(pp_point_name, ", ", as.character(100 * prob), "% ", str_to_upper(interval)),
          pp_point == "mode" & interval != "none" & n_mode_prior == 1 ~ str_c(pp_point_name, ", ", as.character(100 * prob), "% ", str_to_upper(interval)),
          pp_point == "mode" & interval != "none" & n_mode_prior > 1 ~ str_c(as.character(100 * prob), "% ", str_to_upper(interval)),
          pp_point == "none" & interval != "none" ~ str_c(as.character(100 * prob), "% ", str_to_upper(interval))),
        hjust = case_when(
          theta < 0.05 ~ 0,
          theta < 0.95 ~ 0.5,
          theta >= 0.95 ~ 1),
        vjust = ifelse(pp_point == "none", -0.75, -2.25))

    # Add point/interval name label to prior panel
    p1 <- p1 +
      geom_text(data = prior_label_df,
                aes(label = text_label, hjust = hjust, vjust = vjust),
                size = text_size)

    # Add point/interval name label to posterior panel
    p3 <- p3 +
      geom_text(data = posterior_label_df,
                aes(label = text_label, hjust = hjust, vjust = vjust),
                size = text_size)
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
    # Compute max value
    likelihood_max <- z / n

    # Determine `hjust` parameter
    hjust <- case_when(
      likelihood_max < 0.05 ~ 0,
      likelihood_max < 0.95 ~ 0.5,
      likelihood_max >= 0.95 ~ 1)

    # Augment likelihood panel with max
    p2 <- p2 +
      annotate(geom = "point",
               x = likelihood_max, y = 0, size = point_size) +
      annotate(geom = "text",
               x = likelihood_max, y = 0,
               label = formatC(x = likelihood_max, digits = 3, format = "f"),
               hjust = hjust, size = text_size, vjust = -0.75) +
      annotate(geom = "text",
               x = likelihood_max, y = 0,
               label = "Max",
               hjust = hjust, size = text_size, vjust = -2.25)
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

