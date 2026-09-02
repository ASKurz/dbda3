test_that("Character returns an error", {
  expect_error(rope_category(x = "bob"))
  expect_error(rope_category(x = 0.5, rope = "bob"))
})

test_that("`rope_category()` returns a factor with the expected levels", {
  f <- rope_category(x = 0.5)
  expect_s3_class(f, "factor")
  expect_identical(levels(f), c("less", "in", "greater"))
})

test_that("Values are categorized correctly relative to `rope`", {
  x <- c(0.1, 0.45, 0.5, 0.55, 0.9)
  f <- rope_category(x, rope = c(0.45, 0.55))
  expect_identical(as.character(f), c("less", "in", "in", "in", "greater"))
})

test_that("The `rope` boundaries are inclusive of the 'in' category", {
  expect_identical(as.character(rope_category(0.45, rope = c(0.45, 0.55))), "in")
  expect_identical(as.character(rope_category(0.55, rope = c(0.45, 0.55))), "in")
})

test_that("Values just outside the boundaries are 'less' or 'greater'", {
  expect_identical(as.character(rope_category(0.44999, rope = c(0.45, 0.55))), "less")
  expect_identical(as.character(rope_category(0.55001, rope = c(0.45, 0.55))), "greater")
})

test_that("The default `rope` matches `c(0.45, 0.55)`", {
  expect_identical(rope_category(0.5), rope_category(0.5, rope = c(0.45, 0.55)))
})

test_that("`rope_category()` is vectorized, and returns a factor the same length as `x`", {
  x <- seq(from = 0, to = 1, by = 0.01)
  f <- rope_category(x)
  expect_length(f, length(x))
  expect_true(all(levels(f) %in% c("less", "in", "greater")))
})

test_that("A custom `rope` can be specified", {
  f <- rope_category(x = c(-5, 0, 5), rope = c(-1, 1))
  expect_identical(as.character(f), c("less", "in", "greater"))
})

