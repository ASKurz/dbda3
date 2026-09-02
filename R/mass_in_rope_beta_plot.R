#' Make plots for beta posteriors with decisions
#'
#' Makes ggplot2-based plots of beta posteriors that include decisions by mass-in-ROPE criteria, as displayed in several figures in chapter 11 of *DBDA3*.
#'
#' @param mode A numeric value defining the mode of the beta distribution, passed to the `mode` argument in the `beta_a_b_from_mode_kappa()` function. Defaults to `0.50`.
#' @param kappa A numeric value defining the concentration (kappa) of the beta distribution, passed to the `kappa` argument in the `beta_a_b_from_mode_kappa()` function. Defaults to `400`.
#' @param rope A two-element numeric vector of ROPE limits. Defaults to `c(0.45, 0.55)`.
#' @param rope_fill The fill color for the ROPE band in the background of the plot, passed to the `fill` argument in the `annotate()` function. Defaults to `"gray98"`.
#' @param text_theta The value on the x axis (the \eqn{\theta} axis) for the annotation. Defaults to `0.0`.
#' @param text_size The size aesthetic for the annotation text, passed to the `size` argument in the `geom_text()` function. Defaults to `2.75`.
#'
#' @returns An object of class `gg,` and `ggplot`.
#'
#' @examples
#'
#' library(ggplot2)
#'
#' # Default
#' mass_in_rope_beta_plot()
#'
#' # Customize
#' mass_in_rope_beta_plot(
#'   mode = 0.53,
#'   kappa = 200,
#'   text_theta = 0.3,
#'   text_size = 4) +
#'   coord_cartesian(xlim = c(0.3, 0.7)) +
#'   scale_fill_manual(values = c("blue", "gray80", "red"), breaks = NULL) +
#'   theme(panel.grid = element_blank())
#'
#' @import dplyr ggplot2
#' @importFrom stats dbeta pbeta
#' @export
mass_in_rope_beta_plot <- function(
    mode = 0.50,
    kappa = 400,
    rope = c(0.45, 0.55),
    rope_fill = "gray98",
    text_theta = 0.0,
    text_size = 2.75) {

  # Checks
  checkmate::assert_numeric(rope)
  checkmate::assert_numeric(text_theta, lower = 0, upper = 1)
  checkmate::assert_numeric(text_size, lower = 0)

  # Internal objects
  alpha <- 0.05
  beta_ab <- beta_a_b_from_mode_kappa(mode = mode, kappa = kappa)
  pbeta_rope <- pbeta(rope, beta_ab$a, beta_ab$b)
  rope_mass_lt <- pbeta_rope[1]
  rope_mass_in <- pbeta_rope[2] - pbeta_rope[1]
  rope_mass_gt <- 1 - pbeta_rope[2]

  decision <- case_when(
    rope_mass_lt >= 1 - alpha ~ "Less~than~null",
    rope_mass_in >= 1 - alpha ~ "Equivalent~to~null",
    rope_mass_gt >= 1 - alpha ~ "Greater~than~null",
    .default = "Remain~uncommitted"
  )

  # Data frame for the density
  density_df <- data.frame(theta = seq(from = 0, to = 1, by = 0.001)) |>
    mutate(density = dbeta(x = theta, shape1 = beta_ab$a, shape2 = beta_ab$b),
           rope_category = rope_category(x = theta, rope = rope))

  # Data frame for the annotation
  text_df <- data.frame(
    label = c(str_c("italic(p)(theta < ROPE)",    format_pval(rope_mass_lt)),
              str_c("italic(p)(theta %in% ROPE)", format_pval(rope_mass_in)),
              str_c("italic(p)(theta > ROPE)",    format_pval(rope_mass_gt)),
              str_c("Decision:~", decision)),
    theta = text_theta,
    density = (0.95 + seq(from = 0, by = -0.075, length.out = 4)) * max(density_df$density) * 1.125)

  # Plot
  density_df |>
    ggplot(aes(x = theta, y = density)) +
    annotate(geom = "rect",
             xmin = rope[1], xmax = rope[2],
             ymin = -Inf, ymax = Inf,
             color = "transparent", fill = rope_fill) +
    geom_area(aes(fill = rope_category, group = rope_category)) +
    geom_text(data = text_df,
              aes(label = label),
              hjust = 0, parse = TRUE, size = text_size, vjust = 1) +
    scale_y_continuous(NULL, breaks = NULL) +
    xlab(expression(theta))
}

