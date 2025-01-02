#' Make plots for Bayes factors
#'
#' A ggplot2-based revision of the `bfplot()` function, as introduced in Kruschke (2021).
#'
#' @param bf A single numeric value for the Bayes factor.
#' @param crit_post A single numeric value in the range \eqn{[0, 1]}. Defaults to `0.95`.
#' @param xlab The title to the x axis. Passed to the `x` argument within `labs()`. Defaults to `expression(italic(p)(Numerator~Model))`.
#' @param ylab The title to the y axis. Passed to the `y` argument within `labs()`. Defaults to `expression(italic(p)(Numerator~Model*' | '*D))`.
#' @param title The text for the title. Passed to the `title` argument within `labs()`. Defaults to `NULL`.
#' @param subtitle The text for the subtitle. Passed to the `subtitle` argument within `labs()`. Defaults to `"Numerator Model\n/ Denominator Model"`.
#' @param bf_col The color for the BF annotation. Defaults to `"deepskyblue"`.
#' @param accept_col The color for the acceptance annotation. Defaults to `"darkgreen"`.
#' @param reject_col The color for the rejection annotation. Defaults to `"darkred"`.
#' @param bf_label_nudge A single numeric value for the amount of position nudging the BF label takes from the curve. Defaults to `0.2`.
#' @param bf_size A single numeric value for the size of the BF text annotation, passed to the `size` argument in `geom_text()`. Defaults to `6`.
#' @param ar_size A single numeric value for the size of the accept/reject text annotation, passed to the `size` argument in `geom_text()`. Defaults to `3.5`.
#' @param axis_breaks A numeric vector for the breaks in the x and y axes, passed to the `breaks` argument in `scale_x_continuous()` and `scale_y_continuous()`. Defaults to `0:5 / 5`.
#' @param no_plot A logical value. Currently serves no function, and will be fleshed out later.
#'
#' @returns If `no_plot == FALSE`, an object of class `ggplot`.
#'
#' @source
#' Kruschke, J. K. (2021).
#' Bayesian Analysis Reporting Guidelines.
#' \emph{Nature Human Behavior}, 5, 1282–1291.
#' <https://doi.org/10.1038/s41562-021-01177-7>
#'
#' @examples
#' library(ggplot2)
#'
#' # Default behavior
#' bf_plot(bf = 5)
#'
#' # Adjust a few parameters
#' bf_plot(bf = 7.5,
#'         xlab = expression(italic(p)(italic(M)[Fair])),
#'         ylab = expression(italic(p)(italic(M)[Fair]*'|'*D)),
#'         subtitle = NULL,
#'         bf_col = "steelblue",
#'         bf_size = 4,
#'         ar_size = 2.5) +
#'   facet_wrap(~ "italic(M)[Fair]/italic(M)[Haldane]", labeller = label_parsed)
#'
#' @importFrom stringr str_c
#' @import dplyr ggplot2
#' @export
bf_plot <- function(
    bf,
    crit_post = 0.95,  # or NA
    xlab = expression(italic(p)(Numerator~Model)),
    ylab = expression(italic(p)(Numerator~Model*' | '*D)),
    title = NULL,
    subtitle = "Numerator Model\n/ Denominator Model",
    bf_col = "deepskyblue",
    accept_col = "darkgreen",
    reject_col = "darkred",
    bf_label_nudge = 0.2,
    # new
    bf_size = 6,
    ar_size = 3.5,
    axis_breaks = 0:5 / 5,
    # if TRUE then only returns info, no plot
    no_plot = FALSE) {

  # Check the inputs values
  if (bf <= 0) stop("`bf` must be greater than zero.")
  if (!is.na(crit_post)) {
    if (crit_post <= 0.50) stop("`crit_post` must be greater than 0.50.")
    if (crit_post > 1) stop("`crit_post` must not exceed 1.")
  }

  # Primary data frame for the curve
  bf_df <- data.frame(prior = seq(from = 0, to = 1, length.out = 501)) |>
    mutate(prior_odds = prior / (1 - prior)) |>
    mutate(post_odds = bf * prior_odds) |>
    mutate(post = post_odds / (1 + post_odds)) |>
    # Because of the Inf values for _odds columns, we get NaN on post, when prior == 1.
    # This line might be a viable solution.
    mutate(post = ifelse(is.na(post), prior, post))

  # Annotate curve with `bf` value
  bf_label_nudge_crit <- 1.7

  if (bf > 1) {
    # Data frame for the BF annotation
    bf_label_df <- bf_df |>
      slice_max(post - prior) |>
      mutate(label = str_c("BF==", signif(bf, digits = 3)))
    # Adjust the horizontal and vertical text alignment within geom_text()
    h_just <- 0 - bf_label_nudge
    v_just <- 1 + bf_label_nudge + 1.3 * (abs(log10(bf)) > bf_label_nudge_crit)
  } else {
    bf_label_df <- bf_df |>
      slice_min(post - prior, with_ties = FALSE) |>
      mutate(label = str_c("BF==", signif(bf, digits = 3)))
    h_just <- 1
    v_just <- 0 - bf_label_nudge + 1.3 * (abs(log10(bf)) > bf_label_nudge_crit)
  }

  # Compute critical values for prior probability
  hi_crit_post <- crit_post                                      # hiCritPost
  hi_crit_post_odds <- hi_crit_post / (1 - hi_crit_post)         # hiCritPostOdds
  hi_crit_prior <- hi_crit_post_odds / (bf + hi_crit_post_odds)  # hiCritPrior
  lo_crit_post <- 1 - crit_post                                  # loCritPost
  lo_crit_post_odds <- lo_crit_post / (1 - lo_crit_post)         # loCritPostOdds
  lo_crit_prior <- lo_crit_post_odds / (bf + lo_crit_post_odds)  # loCritPrior

  # Annotation related to `crit_post`
  crit_post_df <- data.frame(
    level = rep(c("hi", "lo"), each = 4),
    post = rep(c(hi_crit_post, lo_crit_post), each = 4)) |>
    mutate(prior = c(0, hi_crit_prior, hi_crit_prior, 1, 0, lo_crit_prior, lo_crit_prior, 1)) |>
    mutate(decision = rep(c("reject", "accept", "accept", "reject"), each = 2))

  crit_value_df <- crit_post_df |>
    slice(c(2, 6)) |>
    mutate(label = round(prior, digits = 3),
           vjust = c(-0.3, 1.3))

  crit_label_df <- crit_post_df |>
    slice(4:5) |>
    mutate(label = c(str_c("Prior~s.t.~Post>", round(hi_crit_post, digits = 3)),
                     str_c("Prior~s.t.~Post<", round(lo_crit_post, digits = 3))),
           hjust = 1:0,
           vjust = c(1.3, -0.3))

  # For when `crit_post = NA`
  if (is.na(crit_post)) {
    crit_post_df <- crit_post_df |>
      slice(0)
    crit_value_df <- crit_value_df |>
      slice(0)
    crit_label_df <- crit_label_df |>
      slice(0)
  }

  # Make the plot
  the_bf_plot <- bf_df |>
    ggplot(aes(x = prior, y = post)) +
    geom_line(color = bf_col, linewidth = 1) +
    geom_text(data = bf_label_df,
              aes(label = label),
              color = bf_col, hjust = h_just, parse = TRUE,
              size = bf_size, vjust = v_just) +
    geom_line(data = crit_post_df,
              aes(color = level, linetype = decision, linewidth = decision)) +
    geom_text(data = crit_value_df,
              aes(label = label, color = level, vjust = vjust),
              size = ar_size) +
    geom_text(data = crit_label_df,
              aes(label = label, color = level, hjust = hjust, vjust = vjust),
              parse = TRUE, size = ar_size) +
    # Note the flexible axis breaks (maybe not needed)
    scale_x_continuous(breaks = axis_breaks, expand = expansion(mult = 0.075)) +
    scale_y_continuous(breaks = axis_breaks, expand = expansion(mult = 0.075)) +
    scale_color_manual(values = c(accept_col, reject_col)) +
    scale_linetype_manual(values = c(1, 2)) +
    scale_linewidth_manual(values = c(1, 1/3)) +
    # This keeps the axis titles from getting too long
    labs(x = xlab,
         y = ylab,
         title = title,
         subtitle = subtitle) +
    coord_equal() +
    theme(legend.position = "none",
          panel.grid = element_blank(),
          plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5))

  the_bf_plot

}

