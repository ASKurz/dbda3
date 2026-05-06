#' Make plots for HMC posteriors with decisions
#'
#' Makes ggplot2-based plots of HMC posteriors that include decisions by mass-in-ROPE criteria, as displayed in several figures in chapter 11 of *DBDA3*.
#'
#' @param data Default data frame to use for plot. Must be specified.
#' @param x The focal column in `data` to be displayed in the plot (i.e., \eqn{\theta}). This is specified with tidy selection (i.e., without quote marks) the same way as in `dplyr::select(...)` and similar functions. Must be specified.
#' @param rope A two-element numeric vector of ROPE limits. Defaults to `c(-0.201, 0.201)`.
#' @param rope_fill The fill color for the ROPE band in the background of the plot, passed to the `fill` argument in the `annotate()` function. Defaults to `"gray98"`.
#' @param breaks A numeric vector giving the bin boundaries, passed to the `breaks` argument in `geom_histogram()`. Defaults to `seq(from = -0.201 * 5, to = 0.201 * 10, by = 0.201 / 5)`.
#' @param text_theta The value on the x axis (the \eqn{\theta} axis) for the annotation. Defaults to the minimum of the ROPE and the `x` variable.
#' @param text_size The size aesthetic for the annotation text, passed to the `size` argument in the `geom_text()` function. Defaults to `2.75`.
#'
#' @returns An object of class `gg,` and `ggplot`.
#'
#' @examples
#'
#' library(ggplot2)
#'
#' # Example HMC draws
#' multi_normal_draws <- posterior::example_draws("multi_normal") |>
#'   posterior::as_draws_df() |>
#'   # Compute a contrast
#'   dplyr::mutate(mu1_mu2 = `mu[1]` - `mu[2]`)
#'
#' # Default
#' multi_normal_draws |>
#'   mass_in_rope_hmc_plot(x = mu1_mu2)
#'
#' # Customize
#' multi_normal_draws |>
#'   mass_in_rope_hmc_plot(
#'     x = mu1_mu2,
#'     rope = c(-0.1, 0.1),
#'     breaks = seq(from = -1, to = 1, by = 0.05),
#'     text_size = 4) +
#'   xlab(expression(mu[1]-mu[2])) +
#'   scale_fill_manual(values = c("blue", "gray80", "red"), breaks = NULL) +
#'   facet_wrap(~ "My contrast") +
#'   theme(panel.grid = element_blank())
#'
#' @import dplyr ggplot2
#' @export
mass_in_rope_hmc_plot <- function(
    data,
    x,
    rope = c(-0.201, 0.201),
    rope_fill = "gray98",
    breaks = seq(from = -0.201 * 5, to = 0.201 * 10, by = 0.201 / 5),
    text_theta = min(rope[1], min(pull(data, {{ x }}))),
    text_size = 2.75) {

  # Checks
  checkmate::assert_numeric(rope)
  checkmate::assert_numeric(text_theta)
  checkmate::assert_numeric(text_size, lower = 0)

  # Internal objects
  alpha <- 0.05

  x <- pull(data, {{ x }})
  length_x <- length(x)

  rope_mass_lt <- sum(x < rope[1])                 / length_x
  rope_mass_in <- sum(x >= rope[1] & x <= rope[2]) / length_x
  rope_mass_gt <- sum(x > rope[2])                 / length_x

  decision <- case_when(
    rope_mass_lt >= 1 - alpha ~ "Less~than~null",
    rope_mass_in >= 1 - alpha ~ "Equivalent~to~null",
    rope_mass_gt >= 1 - alpha ~ "Greater~than~null",
    .default = "Remain~uncommitted")

  min_x <- min(rope[1], min(x))
  max_x <- max(rope[2], max(x))
  max_y <- max(hist(x, breaks = breaks, plot = FALSE)$counts)

  # Data frame for the histogram
  data <- data |>
    mutate(rope_category = rope_category(x = {{ x }}, rope = rope))

  # Data frame for the annotation
  text_df <- data.frame(
    label = c(str_c("italic(p)(theta < ROPE)",    format_pval(rope_mass_lt)),
              str_c("italic(p)(theta %in% ROPE)", format_pval(rope_mass_in)),
              str_c("italic(p)(theta > ROPE)",    format_pval(rope_mass_gt)),
              str_c("Decision:~", decision)),
    x = text_theta,
    count = (0.95 + seq(from = 0, by = -0.075, length.out = 4)) * max_y * 1.125)

  # Plot
  data |>
    ggplot() +
    annotate(geom = "rect",
             xmin = rope[1], xmax = rope[2],
             ymin = -Inf, ymax = Inf,
             color = "transparent", fill = rope_fill) +
    geom_histogram(aes(x = {{ x }}, fill = rope_category),
                   breaks = breaks) +
    geom_text(data = text_df,
              aes(x = x, y = count, label = label),
              hjust = 0, parse = TRUE, size = text_size, vjust = 1) +
    coord_cartesian(xlim = c(min_x, max_x)) +
    scale_y_continuous(NULL, breaks = NULL)
}

