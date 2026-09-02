test_that("`standardize()` returns a vector with mean 0 and sd 1", {
  x <- 1:6
  z <- standardize(x)
  expect_equal(mean(z), 0)
  expect_equal(sd(z), 1)
})

test_that("`standardize()` matches the manual `(x - mean) / sd` formula", {
  x <- c(3, 7, 2, 9, 15, 4)
  expect_equal(standardize(x), (x - mean(x)) / sd(x))
})

test_that("`standardize()` returns a vector the same length as `x`", {
  x <- rnorm(20)
  expect_length(standardize(x), length(x))
})

test_that("`standardize()` propagates `NA` by default (`na.rm = FALSE`)", {
  x <- c(1:5, NA)
  z <- standardize(x)
  expect_true(all(is.na(z)))
})

test_that("`na.rm = TRUE` standardizes around the non-missing values, and keeps `NA` in place", {
  x <- c(1:5, NA)
  z <- standardize(x, na.rm = TRUE)
  expect_equal(z[1:5], (x[1:5] - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE))
  expect_true(is.na(z[6]))
  expect_length(z, length(x))
})

test_that("A constant vector produces `NaN` because `sd()` is zero", {
  expect_true(all(is.nan(standardize(rep(5, 10)))))
})

