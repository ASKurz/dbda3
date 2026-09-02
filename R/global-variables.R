# Suppress `R CMD check` NOTEs for non-standard evaluation (NSE) column
# names referenced inside `dplyr`/`ggplot2` calls throughout the package
# (e.g. `aes(x = theta)`, `mutate(prior = ...)`). These are not undefined
# globals; they are resolved from data frames at runtime.
utils::globalVariables(c(
  "decision", "density", "epsilon", "ess_q50", "group", "hjust",
  "impulse", "label", "level", "likelihood", "neg_log_density",
  "point_label", "post", "post_odds", "posterior", "posterior_group",
  "posterior_in_interval", "prior", "prior_group", "prior_in_interval",
  "prior_odds", "proposal", "q2.5", "q50", "q97.5", "qbeta", "step",
  "text_label", "theta", "variable", "vjust"
))

