test_that("Character returns an error", {
  expect_error(format_pval(x = "bob"))
  expect_error(format_pval(0.5, digits = "bob"))
  expect_error(format_pval(0.5, plotmath = "bob"))
})

test_that("x within bounds", {
  expect_error(format_pval(-0.1))
  expect_error(format_pval(1.1))
  expect_error(format_pval(0.5, digits = -1))
})

test_that("`format_pval()` matches known values", {
  expect_identical(format_pval(c(0.5, 0.0005)), c("== '0.500'", "< '0.001'"))
  expect_identical(format_pval(0.1, digits = 2, plotmath = FALSE), "= '0.10'")
})

test_that("Values below `10^(-digits)` are formatted as a lower bound", {
  expect_identical(format_pval(0), "< '0.001'")
  expect_identical(format_pval(0.0009999), "< '0.001'")
})

test_that("Values above `1 - 10^(-digits)` are formatted as an upper bound", {
  expect_identical(format_pval(1), "> '0.999'")
  expect_identical(format_pval(0.999999), "> '0.999'")
})

test_that("`plotmath = TRUE` (the default) uses `==` for the typical case, `plotmath = FALSE` uses `=`", {
  expect_identical(format_pval(0.5), "== '0.500'")
  expect_identical(format_pval(0.5, plotmath = FALSE), "= '0.500'")
})

test_that("`digits` controls the precision, and the extreme-value thresholds", {
  expect_identical(format_pval(0.000001, digits = 5), "< '0.00001'")
  expect_identical(format_pval(0.5, digits = 1), "== '0.5'")
})

test_that("`format_pval()` returns a character vector the same length as `x`", {
  x <- c(0.001, 0.5, 0.999)
  out <- format_pval(x)
  expect_type(out, "character")
  expect_length(out, length(x))
})

