withr::local_seed(4187)

draws_df <- data.frame(theta = rnorm(1000, mean = 0, sd = 0.1))

test_that("Character returns an error", {
  expect_error(mass_in_rope_hmc_plot(draws_df, x = theta, rope = "bob"))
  expect_error(mass_in_rope_hmc_plot(draws_df, x = theta, text_theta = "bob"))
  expect_error(mass_in_rope_hmc_plot(draws_df, x = theta, text_size = "bob"))
})

test_that("x within bounds", {
  expect_error(mass_in_rope_hmc_plot(draws_df, x = theta, text_size = -1))
})

test_that("Default call returns a ggplot object", {
  p <- mass_in_rope_hmc_plot(draws_df, x = theta)
  expect_s3_class(p, "ggplot")
})

test_that("`mass_in_rope_hmc_plot()` returns a plot across the decision regions", {
  # Equivalent to null (draws concentrated within the default ROPE)
  expect_s3_class(
    mass_in_rope_hmc_plot(data.frame(theta = rnorm(1000, mean = 0, sd = 0.01)), x = theta),
    "ggplot"
  )
  # Less than null
  expect_s3_class(
    mass_in_rope_hmc_plot(
      data.frame(theta = rnorm(1000, mean = -5, sd = 0.1)), x = theta,
      breaks = seq(from = -6, to = -4, by = 0.1)
    ),
    "ggplot"
  )
  # Greater than null
  expect_s3_class(
    mass_in_rope_hmc_plot(
      data.frame(theta = rnorm(1000, mean = 5, sd = 0.1)), x = theta,
      breaks = seq(from = 4, to = 6, by = 0.1)
    ),
    "ggplot"
  )
  # Remain uncommitted (wide spread straddling the ROPE)
  expect_s3_class(
    mass_in_rope_hmc_plot(
      data.frame(theta = rnorm(1000, mean = 0, sd = 2)), x = theta,
      breaks = seq(from = -8, to = 8, by = 0.2)
    ),
    "ggplot"
  )
})

test_that("Custom `rope`, `breaks`, and `text_theta` arguments work", {
  p <- mass_in_rope_hmc_plot(
    draws_df,
    x = theta,
    rope = c(-0.1, 0.1),
    breaks = seq(from = -1, to = 1, by = 0.05),
    text_size = 4
  )
  expect_s3_class(p, "ggplot")
})

test_that("Additional ggplot2 layers can be added to the returned plot", {
  p <- mass_in_rope_hmc_plot(draws_df, x = theta) +
    ggplot2::xlab(expression(theta)) +
    ggplot2::scale_fill_manual(values = c("blue", "gray80", "red"), breaks = NULL) +
    ggplot2::facet_wrap(~ "My contrast") +
    ggplot2::theme(panel.grid = ggplot2::element_blank())
  expect_s3_class(p, "ggplot")
})

