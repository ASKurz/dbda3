#' Plot prior, likelihood, and posterior for a beta Bernoulli model
#'
#' A [ggplot2]-based update of the `BernBeta()` function, as introduced in Chapter 6 of *DBDA2*. The revised `bern_beta()` function makes figures highlighting the effect a beta prior has on the posterior distribution of the success probability parameter for the Bernoulli likelihood, such as seen in Chapter 6 of *DBDA3*. The solution is based on exact mathematical analysis.
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
#' @source
#' Kruschke, J. K. (2015).
#' \emph{Doing Bayesian Data Analysis: A Tutorial with R, JAGS, and Stan} (2nd ed.).
#' Elsevier.
#' <https://sites.google.com/site/doingbayesiandataanalysis/>
#'
#' @seealso [bern_grid()] for similar plots based on a general prior distribution defined with a grid.
#'
#' @examples
#' # Default behavior
#' bern_beta()
#'
#' # Define the primary input values
#' a <- 2
#' b <- 2
#' z <- 1
#' n <- 10
#'
#' # Add modes/95% HDIs
#' bern_beta(a = a, b = b, z = z, n = n,
#'           interval = "hdi",
#'           pp_point = "mode",
#'           l_point = "max")
#'
#' # Add median/66.7% ETIs
#' bern_beta(a = a, b = b, z = z, n = n,
#'           interval = "eti",
#'           prob = 0.667,
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
#'           prob = 0.8,
#'           pp_point = "mean",
#'           # Aesthetic settings
#'           arrow_linewidth = 1.25,
#'           arrow_length = 0.1,
#'           fill_color = "steelblue1",
#'           darken_amount = c(-0.3, 0.2),
#'           point_size = 3,
#'           text_size = 5)
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
  # Checks
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

  # Compute and save ETI values
  p_vector <- c((1.0 - prob) / 2, 1.0 - (1.0 - prob) / 2)
  prior_eti <- qbeta(p_vector, shape1 = a, shape2 = b)
  posterior_eti <- qbeta(p_vector, shape1 = z + a, shape2 = n - z + b)

  # Compute and save HDI values
  prior_hdi <- hdi_of_icdf(qbeta, shape1 = a, shape2 = b, prob = prob)
  posterior_hdi <- hdi_of_icdf(qbeta, shape1 = z + a, shape2 = n - z + b, prob = prob)

  # Add interval information to primary data frame
  grid_df <- grid_df |>
    mutate(
      prior_in_interval = case_when(
        interval == "eti" ~ between(theta, left = prior_eti[1], right = prior_eti[2]),
        interval == "hdi" & (a > 1 & b > 1) ~ between(theta, left = prior_hdi[1], right = prior_hdi[2]),
        interval == "hdi" & (a <= 1 | b <= 1) ~ NA,
        interval == "none" ~ NA),
      posterior_in_interval = case_when(
        interval == "eti" ~ between(theta, left = posterior_eti[1], right = posterior_eti[2]),
        interval == "hdi" & (z + a > 1 & n - z + b > 1) ~ between(theta, left = posterior_hdi[1], right = posterior_hdi[2]),
        interval == "hdi" & (z + a <= 1 | n - z + b <= 1) ~ NA,
        interval == "none" ~ NA),
      prior_group = case_when(
        # Logic matches that used in `dplyr::between()`
        interval == "eti" & theta <= prior_eti[1] ~ "1",
        interval == "eti" & theta <= prior_eti[2] ~ "2",
        interval == "eti" & theta >  prior_eti[2] ~ "3",
        interval == "hdi" & theta <= prior_hdi[1] ~ "1",
        interval == "hdi" & theta <= prior_hdi[2] ~ "2",
        interval == "hdi" & theta >  prior_hdi[2] ~ "3",
        interval == "none" ~ "1"),
      posterior_group = case_when(
        interval == "eti" & theta <= posterior_eti[1] ~ "1",
        interval == "eti" & theta <= posterior_eti[2] ~ "2",
        interval == "eti" & theta >  posterior_eti[2] ~ "3",
        interval == "hdi" & theta <= posterior_hdi[1] ~ "1",
        interval == "hdi" & theta <= posterior_hdi[2] ~ "2",
        interval == "hdi" & theta >  posterior_hdi[2] ~ "3",
        interval == "none" ~ "1"))

  # Intervals
  if (interval == "eti" || interval == "hdi") {
    # Initial prior panel with interval information
    p1 <- grid_df |>
      ggplot(aes(x = theta, y = prior)) +
      geom_area(aes(fill = prior_in_interval, group = prior_group),
                position = "identity") +
      geom_line(data = grid_df |>
                  filter(prior_in_interval == TRUE) |>
                  mutate(prior = 0),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount),
                        # `na.value` makes this robust to difficult HDI regions
                        breaks = NULL, limits = c(FALSE, TRUE), na.value = fill_color)

    # Initial posterior panel with interval information
    p3 <- grid_df |>
      ggplot(aes(x = theta, y = posterior)) +
      geom_area(aes(fill = posterior_in_interval, group = posterior_group),
                position = "identity") +
      geom_line(data = grid_df |>
                  filter(posterior_in_interval == TRUE) |>
                  mutate(posterior = 0),
                linewidth = arrow_linewidth,
                arrow = arrow(length = unit(arrow_length, "in"), ends = "both")) +
      scale_fill_manual(values = darken(col = fill_color, amount = darken_amount),
                        # `na.value` makes this robust to difficult HDI regions
                        breaks = NULL, limits = c(FALSE, TRUE), na.value = fill_color)
  } else if (interval == "none") {
    # Initial prior panel
    p1 <- grid_df |>
      ggplot(aes(x = theta, y = prior)) +
      geom_area(fill = fill_color)

    # Initial posterior panel
    p3 <- grid_df |>
      ggplot(aes(x = theta, y = posterior)) +
      geom_area(fill = fill_color)
  }

  # Prior/posterior central tendency points
  # Check whether the prior/posterior modes are unique
  unique_prior_mode <- ifelse((a == b & a <= 1), FALSE, TRUE)
  unique_posterior_mode <- ifelse((z + a == n - z + b & z + a <= 1), FALSE, TRUE)

  if (pp_point != "none") {
    # Prior panel
    if (pp_point == "mean" || pp_point ==  "median" || (pp_point == "mode" && unique_prior_mode == TRUE)) {
      # Make supporting data frame for the dot and text annotation
      prior_point_df <- grid_df |>
        summarise(
          theta = case_when(
            pp_point == "mean"   ~ a / (a + b),
            pp_point == "median" ~ qbeta(0.5, shape1 = a, shape2 = b),
            pp_point == "mode" & (a > 1 & b > 1)  ~ (a - 1) / (a + b - 2),
            pp_point == "mode" & (a <= 1 & a < b) ~ 0,
            pp_point == "mode" & (b <= 1 & b < a) ~ 1),
          prior = 0,
          point_label = formatC(x = theta, digits = 3, format = "f"),
          hjust = theta)

      # Add point to prior panel
      p1 <- p1 +
        geom_point(data = prior_point_df,
                   size = point_size) +
        geom_text(data = prior_point_df,
                  aes(label = point_label, hjust = hjust),
                  size = text_size, vjust = -0.75)
    }
    # Posterior panel
    if (pp_point == "mean" || pp_point ==  "median" || (pp_point == "mode" && unique_posterior_mode == TRUE)) {
      # Make supporting data frame for the dot and text annotation
      posterior_point_df <- grid_df |>
        summarise(
          theta = case_when(
            pp_point == "mean"   ~ (z + a) / (a + n + b),
            pp_point == "median" ~ qbeta(0.5, shape1 = z + a, shape2 = n - z + b),
            pp_point == "mode" & (z + a > 1 & n - z + b > 1)  ~ (z + a - 1) / (z + a + n - z + b - 2),
            pp_point == "mode" & (z + a <= 1 & z + a < n - z + b) ~ 0,
            pp_point == "mode" & (n - z + b <= 1 & n - z + b < z + a) ~ 1),
          posterior = 0,
          point_label = formatC(x = theta, digits = 3, format = "f"),
          hjust = theta)

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
  if (pp_point != "none" || interval != "none") {
    # Make supporting data frame for the prior name label
    prior_label_df <- grid_df |>
      summarise(
        # An internal helper function
        theta = theta_for_label(shape1 = a, shape2 = b,
                                interval = interval, pp_point = pp_point, prob = prob, unique_mode = unique_prior_mode),
        prior = 0,
        # An internal helper function
        text_label = str_point_interval(shape1 = a, shape2 = b,
                                        interval = interval, pp_point = pp_point, prob = prob, unique_mode = unique_prior_mode),
        hjust = theta,
        vjust = ifelse(pp_point == "none", -0.75, -2.25))

    # Make supporting data frame for the posterior name label
    posterior_label_df <- grid_df |>
      summarise(
        theta = theta_for_label(shape1 = z + a, shape2 = n - z + b,
                                interval = interval, pp_point = pp_point, prob = prob, unique_mode = unique_posterior_mode),
        posterior = 0,
        text_label = str_point_interval(shape1 = z + a, shape2 = n - z + b,
                                        interval = interval, pp_point = pp_point, prob = prob, unique_mode = unique_posterior_mode),
        hjust = theta,
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
    geom_line(color = fill_color, linewidth = 1) +
    geom_text(data = text_df,
              aes(label = label, hjust = hjust),
              parse = TRUE, size = text_size, vjust = 1)

  # Likelihood z / n (max) point
  if (l_point == "max") {
    # Compute max value
    likelihood_max <- z / n

    # Augment likelihood panel with mode
    hjust <- likelihood_max

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

  p1 / p2 / p3
}

