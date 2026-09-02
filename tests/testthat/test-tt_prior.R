prior_df <- data.frame(
  prior = c("normal(0, 1)", "", "cauchy(0, 2.5)"),
  class = c("b", "Intercept", "sigma")
)

test_that("Default call returns a `tinytable` object", {
  t <- tt_prior(prior_df)
  expect_s4_class(t, "tinytable")
})

test_that("Empty `prior` cells are replaced with '(flat)'", {
  t <- tt_prior(prior_df)
  expect_identical(t@data$prior, c("normal(0, 1)", "(flat)", "cauchy(0, 2.5)"))
})

test_that("Adjusting `height` does not error", {
  expect_s4_class(tt_prior(prior_df, height = 0.5), "tinytable")
})

test_that("Adjusting `placement` does not error", {
  expect_s4_class(tt_prior(prior_df, placement = "h"), "tinytable")
})

test_that("A single-row prior data frame is handled without error", {
  expect_s4_class(tt_prior(prior_df[1, , drop = FALSE]), "tinytable")
})

test_that("A prior data frame with no empty priors is handled without error", {
  no_flat_df <- data.frame(prior = c("normal(0, 1)", "cauchy(0, 2.5)"), class = c("b", "sigma"))
  t <- tt_prior(no_flat_df)
  expect_s4_class(t, "tinytable")
  expect_identical(t@data$prior, c("normal(0, 1)", "cauchy(0, 2.5)"))
})

test_that("Additional arguments are passed through to `tt()`", {
  expect_s4_class(tt_prior(prior_df, width = 0.5), "tinytable")
})

