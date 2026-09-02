test_that("Character returns an error", {
  expect_error(softmax(x = "bob"))
})

test_that("`softmax()` matches known values", {
  expect_equal(softmax(-1:1), c(0.09003057, 0.24472847, 0.66524096), tolerance = 1e-7)
})

test_that("`softmax()` matches the manual `exp(x) / sum(exp(x))` formula", {
  x <- c(-3, 0.5, 2, 4)
  expect_equal(softmax(x), exp(x) / sum(exp(x)))
})

test_that("`softmax()` output sums to 1", {
  expect_equal(sum(softmax(-1:1)), 1)
  expect_equal(sum(softmax(c(-10, 5, 0, 3, -2))), 1)
})

test_that("`softmax()` returns a vector the same length as `x`", {
  x <- rnorm(6)
  expect_length(softmax(x), length(x))
})

test_that("A single-element vector always returns 1", {
  expect_equal(softmax(5), 1)
  expect_equal(softmax(-100), 1)
})

test_that("`softmax()` is invariant to a constant shift in `x`", {
  x <- c(-1, 0, 1)
  expect_equal(softmax(x), softmax(x + 100))
  expect_equal(softmax(x), softmax(x - 50))
})

test_that("Equal elements of `x` receive equal probability", {
  expect_equal(softmax(rep(3, 4)), rep(0.25, 4))
})

test_that("Sufficiently large values no longer overflow to `NaN`", {
  out <- softmax(c(1000, 1001, 1002))
  expect_false(any(is.nan(out)))
  expect_equal(out, softmax(c(-2, -1, 0)))
})

test_that("Sufficiently negative values no longer underflow to all-zero", {
  out <- softmax(c(-1000, -1001, -1002))
  expect_equal(sum(out), 1)
  expect_equal(out, softmax(c(2, 1, 0)))
})

