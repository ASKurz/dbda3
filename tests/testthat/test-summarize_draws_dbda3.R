draws <- posterior::example_draws()

test_that("Invalid `mcse` values return an error", {
  expect_error(summarize_draws_dbda3(draws, mcse = "bob"))
  expect_error(summarize_draws_dbda3(draws, mcse = 1))
})

test_that("Default call returns the expected columns", {
  out <- summarize_draws_dbda3(draws)
  expect_s3_class(out, "draws_summary")
  expect_identical(
    names(out),
    c("variable", "q50", "q2.5", "q97.5", "rhat", "ess_q50", "ess_eti")
  )
})

test_that("`mcse = TRUE` adds the `mcse_*` columns", {
  out <- summarize_draws_dbda3(draws, mcse = TRUE)
  expect_identical(
    names(out),
    c("variable", "q50", "q2.5", "q97.5", "mcse_q50", "mcse_q2.5", "mcse_q97.5", "rhat", "ess_q50", "ess_eti")
  )
})

test_that("Custom `probs` are reflected in the quantile column names", {
  out <- summarize_draws_dbda3(draws, probs = c(0.50, 0.05, 0.95))
  expect_identical(
    names(out),
    c("variable", "q50", "q5", "q95", "rhat", "ess_q50", "ess_eti")
  )
})

test_that("The `rhat` column matches `posterior::summarize_draws(draws, rhat)`", {
  out <- summarize_draws_dbda3(draws)
  manual <- posterior::summarize_draws(draws, rhat)
  expect_identical(out$rhat, manual$rhat)
})

test_that("The `ess_q50` column matches a manual `ess_quantile()` computation", {
  out <- summarize_draws_dbda3(draws)
  manual <- posterior::summarize_draws(draws, ~posterior::ess_quantile(.x, probs = 0.50))
  expect_identical(out$ess_q50, manual$ess_q50)
})

test_that("The `ess_eti` column uses `range(probs)` as the eti-ESS bounds", {
  out <- summarize_draws_dbda3(draws, probs = c(0.50, 0.05, 0.95))
  manual <- posterior::summarize_draws(draws, ess_eti = ~ess_eti(.x, probs = c(0.05, 0.95)))
  expect_identical(out$ess_eti, manual$ess_eti)
})

test_that("Additional named `...` arguments are forwarded to `summarize_draws()`", {
  out <- summarize_draws_dbda3(draws, mean = mean)
  expect_true("mean" %in% names(out))
  manual <- posterior::summarize_draws(draws, mean)
  expect_equal(out$mean, manual$mean)
})

test_that("The `variable` column matches the variable names in `draws`", {
  out <- summarize_draws_dbda3(draws)
  expect_identical(out$variable, posterior::variables(draws))
})

test_that("The number of rows matches the number of variables in `draws`", {
  out <- summarize_draws_dbda3(draws)
  expect_equal(nrow(out), length(posterior::variables(draws)))
})

