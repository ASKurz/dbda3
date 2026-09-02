test_that("`format_num()` matches known values", {
  expect_identical(format_num(1e4), "10,000.00")
  expect_identical(format_num(1e4, digits = 0), "10,000")
})

test_that("`format_num()` returns a character vector the same length as `x`", {
  x <- c(1234.5, 0.1, -5)
  out <- format_num(x)
  expect_type(out, "character")
  expect_length(out, length(x))
})

test_that("`format_num()` inserts a thousands separator, and pads decimal places", {
  expect_identical(format_num(1234567.891, digits = 3), "1,234,567.891")
  expect_identical(format_num(0.1), "0.10")
})

test_that("`format_num()` handles negative values", {
  expect_identical(format_num(-5), "-5.00")
})

test_that("`digits` controls the number of decimal places", {
  expect_identical(format_num(pi, digits = 0), "3")
  expect_identical(format_num(pi, digits = 5), "3.14159")
})

