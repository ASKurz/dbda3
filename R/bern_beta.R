#' Plot prior, likelihood, and posterior for a beta Bernoulli model
#'
#' Make figures highlighting the effect a beta prior has on the posterior distribution of the success probability parameter for the Bernoulli likelihood, such as seen in Chapter 5 of *DBDA3*.
#'
#' @param a,b The numeric values for the first and second parameters in the beta prior. The values are passed to the `shape1` and `shape2` arguments of the `dbeta()` function, respectively. Both default to `1`.

#' @param p_theta A vector of probability mass values for the values of `theta`, of the same length as `theta`.
#' @param z The number of `1`'s for the Bernoulli likelihood. Defaults to `1`.
#' @param n The total number of Bernoulli trials. Defaults to `1`.
#' @param interval The type of credible interval displayed. Must be `"eti"`, `"hdi"`, or `"none"`. Defaults to `"none"`.
#' @param prob A single numeric value in the range \eqn{[0, 1]} for the desired probability mass displayed with the interval. Defaults to `0.95`.
#' @param pp_point A character value for the type of central tendency displayed for the prior and posterior. Must be `"mean"`, `"median"`, `"mode"` or `"none"`. Defaults to `"none"`.
#' @param l_point A character value for the type of central tendency displayed for the likelihood. Must be `"max"` or `"none"`. Defaults to `"none"`.
#' @param arrow_linewidth A numeric value for the `linewidth` weight of the arrow marking off the interval. Defaults to `0.67`.
#' @param arrow_length A numeric value for the `length` of the arrow heads marking off the ends of the interval, as measured in inches. Defaults to `0.075`.
#' @param fill_color A character value for the `fill` and `color` aesthetic mappings for the columns in `geom_col()`. Defaults to `"gray70"`.
#' @param darken_amount A numeric vector of two values for the `amount` argument within the `darken()` function to decrease and increase the `fill` values for the interval. Defaults to `c(-0.15, 0.15)`.
#' @param point_size A numeric value for the `size` argument of the central-tendency points in `geom_point()`. Defaults to `1.5`.
#' @param text_size A numeric value for the `size` argument of the text annotation describing the central tendency points, and the data description, in `geom_text()`. Defaults to `3.25`.
#'
#' @returns An object of class `patchwork`, `gg,` and `ggplot`.
#'
#' @examples
#' # Default behavior
#' bern_beta()
#'
#' # Define the primary input values
#' a <- 5
#' b <- 5
#' z <- 5
#' n <- 14
#'
#' # Add modes/95% HDIs
#' bern_beta(a = a, b = b, z = z, n = n,
#'           interval = "hdi",
#'           pp_point = "mode",
#'           l_point = "max")
#'
#' # Add median/67% ETIs
#' bern_beta(a = a, b = b, z = z, n = n,
#'           interval = "eti",
#'           prob = 0.67,
#'           pp_point = "median")
#'
#' # Add mean and ML
#' bern_beta(a = a, b = b, z = z, n = n,
#'           pp_point = "mean",
#'           l_point = "max")
#'
#' # Make further aesthetic adjustments
#' bern_beta(a = a, b = b, z = z, n = n,
#'           interval = "eti",
#'           prob = 0.67,
#'           pp_point = "median",
#'           # new settings
#'           arrow_linewidth = 1.5,
#'           arrow_length = 0.125,
#'           fill_color = "skyblue2",
#'           darken_amount = c(-0.4, 0.3),
#'           point_size = 3,
#'           text_size = 4)
#'
#' @importFrom colorspace darken
#' @importFrom stringr str_c
#' @import dplyr ggplot2 patchwork
#' @export
bern_beta <- function(a = 1, b = 1, z = 1, n = 1,  # The primary arguments
                      # Interval arguments
                      interval = c("eti", "hdi", "none")[3],
                      prob = 0.95,
                      # Central tendency arguments
                      pp_point = c("mean", "median", "mode", "none")[4],
                      l_point = c("max", "none")[2],
                      # General aesthetic arguments
                      arrow_linewidth = 0.67,
                      arrow_length = 0.075,
                      fill_color = "gray70",
                      darken_amount = c(-0.15, 0.15),
                      point_size = 1.5,
                      text_size = 3.25) {

  checkmate::assert_numeric(a, lower = 0)
  checkmate::assert_numeric(b, lower = 0)
  checkmate::assert_numeric(z, lower = 0)
  checkmate::assert_numeric(n, lower = 1)
  checkmate::assert_numeric(prob, lower = 0, upper = 1)
  checkmate::assert_choice(interval, choices = c("eti", "hdi", "none"))
  checkmate::assert_choice(pp_point, choices = c("mean", "median", "mode", "none"))
  checkmate::assert_choice(l_point, choices = c("max", "none"))

  # Make the primary data frame
  grid_df <- data.frame(theta = seq(from = 0.001, to = 0.999, by = 0.001)) |>
    # All in a density metric
    mutate(prior = dbeta(x = theta, shape1 = a, shape2 = b),
           likelihood = dbern(x = theta, z = z, n = n),
           posterior = dbeta(x = theta, shape1 = z + a, shape2 = n - z + b))

  # Compute the upper limit for the y axis of the prior and posterior
  pp_ylim_upper <- grid_df |>
    summarise(max = max(prior, posterior, na.rm = TRUE)) |>
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

  # Intervals
  if (interval == "hdi") {
    # Compute and save HDI values
    prior_hdi <- hdi_of_icdf(qbeta, shape1 = a, shape2 = b, prob = prob)
    posterior_hdi <- hdi_of_icdf(qbeta, shape1 = z + a, shape2 = n - z + b, prob = prob)

    # Augment primary data frame with HDI information
    grid_df <- grid_df |>
      mutate(prior_in_hdi = between(theta, left = prior_hdi[1], right = prior_hdi[2]),
             posterior_in_hdi = between(theta, left = posterior_hdi[1], right = posterior_hdi[2]))

    # Initial prior panel
    if (a > 1 & b > 1 & pp_point != "none") {
      p1 <- grid_df |>
        ggplot(aes(x = theta, y = prior)) +
        geom_area(aes(fill = prior_in_hdi),
                  position = "identity") +
        geom_line(data = grid_df |>
                    filter(prior_in_hdi == TRUE) |>
                    mutate(prior = 0),
                  linewidth = arrow_linewidth,
                  arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
        scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))
    } else if (a > 1 & b > 1 & pp_point == "none") {
      # Add HDI label to prior panel
      prior_point <- mean(prior_hdi)
      hjust <- case_when(
        prior_point < 0.05 ~ 0,
        prior_point < 0.95 ~ 0.5,
        prior_point >= 0.95 ~ 1)

      p1 <- grid_df |>
        ggplot(aes(x = theta, y = prior)) +
        geom_area(aes(fill = prior_in_hdi),
                  position = "identity") +
        geom_line(data = grid_df |>
                    filter(prior_in_hdi == TRUE) |>
                    mutate(prior = 0),
                  linewidth = arrow_linewidth,
                  arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
        scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE)) +
        annotate(geom = "text",
                 x = prior_point, y = 0,
                 label = str_c(as.character(100 * prob), "% HDI"),
                 hjust = hjust, size = text_size, vjust = -0.75)
    } else {
      p1 <- grid_df |>
        ggplot(aes(x = theta, y = prior)) +
        geom_area(fill = fill_color)
    }

    # Initial posterior panel
    if (z + a > 1 & n - z + b > 1 & pp_point != "none") {
      p3 <- grid_df |>
        ggplot(aes(x = theta, y = posterior)) +
        geom_area(aes(fill = posterior_in_hdi),
                  position = "identity") +
        geom_line(data = grid_df |>
                    filter(posterior_in_hdi == TRUE) |>
                    mutate(posterior = 0),
                  linewidth = arrow_linewidth,
                  arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
        scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))
    } else if (z + a > 1 & n - z + b > 1 & pp_point == "none") {
      # Add HDI label to posterior panel
      posterior_point <- mean(posterior_hdi)
      hjust <- case_when(
        posterior_point < 0.05 ~ 0,
        posterior_point < 0.95 ~ 0.5,
        posterior_point >= 0.95 ~ 1)

      p3 <- grid_df |>
        ggplot(aes(x = theta, y = posterior)) +
        geom_area(aes(fill = posterior_in_hdi),
                  position = "identity") +
        geom_line(data = grid_df |>
                    filter(posterior_in_hdi == TRUE) |>
                    mutate(posterior = 0),
                  linewidth = arrow_linewidth,
                  arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
        scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE)) +
        annotate(geom = "text",
                 x = posterior_point, y = 0,
                 label = str_c(as.character(100 * prob), "% HDI"),
                 hjust = hjust, size = text_size, vjust = -0.75)
    } else {
      p3 <- grid_df |>
        ggplot(aes(x = theta, y = posterior)) +
        geom_area(fill = fill_color)
    }

  }
  if (interval == "eti") {
    # Compute and save ETI values
    p_vector <- c((1.0 - prob) / 2, 1.0 - (1.0 - prob) / 2)
    prior_eti <- qbeta(p_vector, shape1 = a, shape2 = b)
    posterior_eti <- qbeta(p_vector, shape1 = z + a, shape2 = n - z + b)

    # Augment primary data frame with ETI information
    grid_df <- grid_df |>
      mutate(prior_in_eti = between(theta, left = prior_eti[1], right = prior_eti[2]),
             posterior_in_eti = between(theta, left = posterior_eti[1], right = posterior_eti[2])) |>
      # To handle when `a < 1 | b < 1`
      mutate(prior_eti_group = case_when(
        theta < prior_eti[1] ~ 1,
        theta < prior_eti[2] ~ 2,
        theta >= prior_eti[2] ~ 3),
        # To handle when `z + a < 1 | n - z + b < 1`
        posterior_eti_group = case_when(
          theta < posterior_eti[1] ~ 1,
          theta < posterior_eti[2] ~ 2,
          theta >= posterior_eti[2] ~ 3))

    # Initial prior panel
    p1 <- grid_df |>
      ggplot(aes(x = theta, y = prior)) +
      geom_area(aes(fill = prior_in_eti, group = interaction(prior_eti_group, prior_in_eti)),
                position = "identity") +
      geom_line(data = grid_df |>
                  filter(prior_in_eti == TRUE) |>
                  mutate(prior = 0),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))
    # Initial posterior panel
    p3 <- grid_df |>
      ggplot(aes(x = theta, y = posterior)) +
      geom_area(aes(fill = posterior_in_eti, group = interaction(posterior_eti_group, posterior_in_eti)),
                position = "identity") +
      geom_line(data = grid_df |>
                  filter(posterior_in_eti == TRUE) |>
                  mutate(posterior = 0),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount), breaks = NULL, limits = c(FALSE, TRUE))

    if (pp_point == "none") {
      # Add ETI label to prior panel
      prior_point <- mean(prior_eti)
      hjust <- case_when(
        prior_point < 0.05 ~ 0,
        prior_point < 0.95 ~ 0.5,
        prior_point >= 0.95 ~ 1)

      p1 <- p1 +
        annotate(geom = "text",
                 x = prior_point, y = 0,
                 label = str_c(as.character(100 * prob), "% ETI"),
                 hjust = hjust, size = text_size, vjust = -0.75)

      # Add ETI label to posterior panel
      posterior_point <- mean(posterior_eti)
      hjust <- case_when(
        posterior_point < 0.05 ~ 0,
        posterior_point < 0.95 ~ 0.5,
        posterior_point >= 0.95 ~ 1)

      p3 <- p3 +
        annotate(geom = "text",
                 x = posterior_point, y = 0,
                 label = str_c(as.character(100 * prob), "% ETI"),
                 hjust = hjust, size = text_size, vjust = -0.75)
    }
  }
  if (interval == "none") {
    # Initial prior panel
    p1 <- grid_df |>
      ggplot(aes(x = theta, y = prior)) +
      geom_area(fill = fill_color)
    # Initial posterior panel
    p3 <- grid_df |>
      ggplot(aes(x = theta, y = posterior)) +
      geom_area(fill = fill_color)
  }

  # Prior/posterior central tendency point
  if (pp_point == "mean") {
    # Compute mean values
    prior_mean <- a / (a + b)
    posterior_mean <- (z + a) / (a + n + b)

    # Define text label
    point_label <- case_when(
      interval == "eti" ~ str_c("Mean, ", as.character(100 * prob), "% ETI"),
      interval == "hdi" ~ str_c("Mean, ", as.character(100 * prob), "% HDI"),
      interval == "none" ~ "Mean")

    # Add mean to prior panel
    hjust <- case_when(
      prior_mean < 0.05 ~ 0,
      prior_mean < 0.95 ~ 0.5,
      prior_mean >= 0.95 ~ 1)

    p1 <- p1 +
      annotate(geom = "point",
               x = prior_mean, y = 0, size = point_size) +
      annotate(geom = "text",
               x = prior_mean, y = 0,
               label = formatC(x = prior_mean, digits = 3, format = "f"),
               hjust = hjust, size = text_size, vjust = -0.75) +
      annotate(geom = "text",
               x = prior_mean, y = 0,
               label = point_label,
               hjust = hjust, size = text_size, vjust = -2.25)

    # Add mean to posterior panel
    hjust <- case_when(
      posterior_mean < 0.05 ~ 0,
      posterior_mean < 0.95 ~ 0.5,
      posterior_mean >= 0.95 ~ 1)

    p3 <- p3 +
      annotate(geom = "point",
               x = posterior_mean, y = 0, size = point_size) +
      annotate(geom = "text",
               x = posterior_mean, y = 0,
               label = formatC(x = posterior_mean, digits = 3, format = "f"),
               hjust = hjust, size = text_size, vjust = -0.75) +
      annotate(geom = "text",
               x = posterior_mean, y = 0,
               label = point_label,
               hjust = hjust, size = text_size, vjust = -2.25)
  }
  if (pp_point == "median") {
    # Compute median values
    prior_median <- qbeta(0.5, shape1 = a, shape2 = b)
    posterior_median <- qbeta(0.5, shape1 = z + a, shape2 = n - z + b)

    # Define text label
    point_label <- case_when(
      interval == "eti" ~ str_c("Median, ", as.character(100 * prob), "% ETI"),
      interval == "hdi" ~ str_c("Median, ", as.character(100 * prob), "% HDI"),
      interval == "none" ~ "Median")

    # Add median to prior panel
    hjust <- case_when(
      prior_median < 0.05 ~ 0,
      prior_median < 0.95 ~ 0.5,
      prior_median >= 0.95 ~ 1)

    p1 <- p1 +
      annotate(geom = "point",
               x = prior_median, y = 0, size = point_size) +
      annotate(geom = "text",
               x = prior_median, y = 0,
               label = formatC(x = prior_median, digits = 3, format = "f"),
               hjust = hjust, size = text_size, vjust = -0.75) +
      annotate(geom = "text",
               x = prior_median, y = 0,
               label = point_label,
               hjust = hjust, size = text_size, vjust = -2.25)

    # Add median to posterior panel
    hjust <- case_when(
      posterior_median < 0.05 ~ 0,
      posterior_median < 0.95 ~ 0.5,
      posterior_median >= 0.95 ~ 1)

    p3 <- p3 +
      annotate(geom = "point",
               x = posterior_median, y = 0, size = point_size) +
      annotate(geom = "text",
               x = posterior_median, y = 0,
               label = formatC(x = posterior_median, digits = 3, format = "f"),
               hjust = hjust, size = text_size, vjust = -0.75) +
      annotate(geom = "text",
               x = posterior_median, y = 0,
               label = point_label,
               hjust = hjust, size = text_size, vjust = -2.25)
  }
  if (pp_point == "mode") {

    # Define text label
    point_label <- case_when(
      interval == "eti" ~ str_c("Mode, ", as.character(100 * prob), "% ETI"),
      interval == "hdi" ~ str_c("Mode, ", as.character(100 * prob), "% HDI"),
      interval == "none" ~ "Mode")

    # shape1 > 1 & shape2 > 1
    if (a > 1 & b > 1) {
      prior_mode <- (a - 1) / (a + b - 2)
    }
    if (z + a > 1 & n - z + b > 1) {
      posterior_mode <- (z + a - 1) / (a + n + b - 2)
    }

    # shape1 <= 1 & shape1 < shape2
    if (a <= 1 & a < b) {
      prior_mode <- 0
    }
    if (z + a <= 1 & z + a < n - z + b) {
      posterior_mode <- 0
    }

    # shape2 <= 1 & shape2 < shape1
    if (b <= 1 & b < a) {
      prior_mode <- 1
    }
    if (n - z + b <= 1 & n - z + b < z + a) {
      posterior_mode <- 1
    }

    if (a == b & a < 1) {
      # No distinct mode
    } else {
      hjust <- case_when(
        prior_mode < 0.05 ~ 0,
        prior_mode < 0.95 ~ 0.5,
        prior_mode >= 0.95 ~ 1)

      p1 <- p1 +
        annotate(geom = "point",
                 x = prior_mode, y = 0, size = point_size) +
        annotate(geom = "text",
                 x = prior_mode, y = 0,
                 label = formatC(x = prior_mode, digits = 3, format = "f"),
                 hjust = hjust, size = text_size, vjust = -0.75) +
        annotate(geom = "text",
                 x = prior_mode, y = 0,
                 label = point_label,
                 hjust = hjust, size = text_size, vjust = -2.25)
    }

    # Add mode to posterior panel
    if (z + a == n - z + b & z + a == 1) {
      # No distinct mode
    } else {
      hjust <- case_when(
        posterior_mode < 0.05 ~ 0,
        posterior_mode < 0.95 ~ 0.5,
        posterior_mode >= 0.95 ~ 1)

      p3 <- p3 +
        annotate(geom = "point",
                 x = posterior_mode, y = 0, size = point_size) +
        annotate(geom = "text",
                 x = posterior_mode, y = 0,
                 label = formatC(x = posterior_mode, digits = 3, format = "f"),
                 hjust = hjust, size = text_size, vjust = -0.75)  +
        annotate(geom = "text",
                 x = posterior_mode, y = 0,
                 label = point_label,
                 hjust = hjust, size = text_size, vjust = -2.25)
    }
  }

  # Initial likelihood panel
  p2 <- grid_df |>
    ggplot(aes(x = theta, y = likelihood)) +
    geom_line(color = fill_color, linewidth = 1) +
    geom_text(data = text_df,
              aes(label = label, hjust = hjust),
              parse = TRUE, size = text_size, vjust = 1)

  # Likelihood z / n (max) point
  if (l_point == "max") {
    # Compute max value
    likelihood_max <- z / n

    # Augment likelihood panel with mode
    hjust <- case_when(
      likelihood_max < 0.05 ~ 0,
      likelihood_max < 0.95 ~ 0.5,
      likelihood_max >= 0.95 ~ 1)

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

  print(p1 / p2 / p3)

}

