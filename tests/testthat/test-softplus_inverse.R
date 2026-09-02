test_that("`softplus_inverse()` matches known values", {
  expect_equal(softplus_inverse(log(2)), 0)
  expect_equal(softplus_inverse(1), log(exp(1) - 1))
})

test_that("`softplus_inverse()` is vectorized", {
  x <- 0:19
  expect_equal(softplus_inverse(x), log(exp(x) - 1))
  expect_length(softplus_inverse(x), length(x))
})

test_that("`softplus_inverse()` returns `-Inf` at the lower domain boundary", {
  expect_equal(softplus_inverse(0), -Inf)
})

test_that("`softplus_inverse()` produces `NaN` with a warning for negative input", {
  expect_warning(result <- softplus_inverse(-1), "NaNs produced")
  expect_true(is.nan(result))
})

test_that("`softplus_inverse()` is monotonically increasing on its domain", {
  x <- seq(from = 0.01, to = 20, by = 0.1)
  expect_true(all(diff(softplus_inverse(x)) > 0))
})

test_that("`softplus_inverse()` is the inverse of `softplus()`", {
  x <- seq(from = 0.5, to = 20, by = 0.5)
  expect_equal(softplus(softplus_inverse(x)), x, tolerance = 1e-8)
})

