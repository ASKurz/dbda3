test_that("Character returns an error", {
  expect_error(mass_in_rope_beta_plot(rope = "bob"))
  expect_error(mass_in_rope_beta_plot(text_theta = "bob"))
  expect_error(mass_in_rope_beta_plot(text_size = "bob"))
})

test_that("x within bounds", {
  expect_error(mass_in_rope_beta_plot(text_theta = -0.1))
  expect_error(mass_in_rope_beta_plot(text_theta = 1.1))
  expect_error(mass_in_rope_beta_plot(text_size = -1))
})

test_that("Invalid `mode`/`kappa` values propagate an error", {
  expect_error(mass_in_rope_beta_plot(kappa = 1))
  expect_error(mass_in_rope_beta_plot(mode = -1))
  expect_error(mass_in_rope_beta_plot(mode = 2))
})

test_that("Default call returns a ggplot object", {
  p <- mass_in_rope_beta_plot()
  expect_s3_class(p, "ggplot")
})

test_that("`mass_in_rope_beta_plot()` returns a plot across the decision regions", {
  # Less than null
  expect_s3_class(mass_in_rope_beta_plot(mode = 0.1, kappa = 400), "ggplot")
  # Equivalent to null
  expect_s3_class(mass_in_rope_beta_plot(mode = 0.50, kappa = 400), "ggplot")
  # Greater than null
  expect_s3_class(mass_in_rope_beta_plot(mode = 0.9, kappa = 400), "ggplot")
  # Remain uncommitted
  expect_s3_class(mass_in_rope_beta_plot(mode = 0.50, kappa = 3), "ggplot")
})

test_that("Additional ggplot2 layers can be added to the returned plot", {
  p <- mass_in_rope_beta_plot(
    mode = 0.53,
    kappa = 200,
    text_theta = 0.3,
    text_size = 4) +
    ggplot2::coord_cartesian(xlim = c(0.3, 0.7)) +
    ggplot2::scale_fill_manual(values = c("blue", "gray80", "red"), breaks = NULL) +
    ggplot2::theme(panel.grid = ggplot2::element_blank())
  expect_s3_class(p, "ggplot")
})

