library(posterior)

draws <- example_draws()
mu <- extract_variable_matrix(draws, "mu")

test_that("Invalid `probs` values return an error", {
  expect_error(ess_eti(mu, probs = 0.5))
  expect_error(ess_eti(mu, probs = c(0.05, 0.95, 0.5)))
  expect_error(ess_eti(mu, probs = "bob"))
})

test_that("Default `probs` matches a manual computation of `min(ess_quantile())`", {
  expect_equal(ess_eti(mu), min(ess_quantile(mu, probs = c(0.025, 0.975))))
})

test_that("`probs = c(0.05, 0.95)` matches `posterior::ess_tail()`", {
  expect_equal(ess_eti(mu, probs = c(0.05, 0.95)), ess_tail(mu))
})

test_that("`ess_eti()` returns a single numeric value for a draws matrix", {
  out <- ess_eti(mu)
  expect_type(out, "double")
  expect_length(out, 1)
})

test_that("Constant draws return `NA`", {
  const_mat <- matrix(5, nrow = 100, ncol = 4)
  expect_true(is.na(ess_eti(const_mat)))
})

test_that("Non-finite draws (`NA`, `NaN`, `Inf`) return `NA`", {
  na_mat <- mu
  na_mat[1, 1] <- NA
  expect_true(is.na(ess_eti(na_mat)))

  nan_mat <- mu
  nan_mat[1, 1] <- NaN
  expect_true(is.na(ess_eti(nan_mat)))

  inf_mat <- mu
  inf_mat[1, 1] <- Inf
  expect_true(is.na(ess_eti(inf_mat)))
})

test_that("`...` arguments are passed through to `ess_quantile()`", {
  # `names` is a valid argument of `ess_quantile()`; confirm no error when forwarded
  expect_no_error(ess_eti(mu, names = FALSE))
})

test_that("An `rvar` input currently returns a single scalar, not an array matching its dimensions", {
  # NOTE: the `@returns` documentation for `ess_eti()` claims that rvar input
  # returns "an array of the same dimensions as the rvar," mirroring each
  # element's own eti-ESS. In practice, `ess_quantile()` returns a
  # probs-by-element matrix for rvar input, and `min()` collapses across
  # *all* elements (not just the probs dimension), so the current
  # implementation returns one scalar for the whole rvar rather than one
  # value per element. This test documents the current behavior so a future
  # fix (or docs correction) doesn't go unnoticed.
  theta_rvar <- as_draws_rvars(draws)$theta
  out <- ess_eti(theta_rvar)
  expect_length(out, 1)
  expect_false(identical(dim(out), dim(theta_rvar)))
})

