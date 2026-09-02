test_that("`softplus()` matches known values", {
  expect_equal(softplus(0), log(2))
  expect_equal(softplus(1), log(1 + exp(1)))
})

test_that("`softplus()` is vectorized", {
  x <- -5:5
  expect_equal(softplus(x), log(1 + exp(x)))
  expect_length(softplus(x), length(x))
})

test_that("`softplus()` output is always non-negative, and strictly positive over a moderate range", {
  expect_true(all(softplus(-1e3:1e3) >= 0))
  expect_true(all(softplus(-30:30) > 0))
})

test_that("`softplus()` is monotonically increasing", {
  x <- seq(from = -10, to = 10, by = 0.1)
  expect_true(all(diff(softplus(x)) > 0))
})

test_that("`softplus()` approaches known asymptotes", {
  # As x -> -Inf, softplus(x) -> 0
  expect_equal(softplus(-1e3), 0)
  # As x -> Inf, softplus(x) -> x
  expect_equal(softplus(1e3), Inf)
  expect_equal(softplus(50), 50, tolerance = 1e-10)
})

test_that("`softplus()` is the inverse of `softplus_inverse()`", {
  x <- seq(from = -5, to = 5, by = 0.5)
  expect_equal(softplus_inverse(softplus(x)), x, tolerance = 1e-8)
})

