# `a > 1 & b > 1` shape parameters (used for the HDI branches that check shape)
a_hi <- 2
b_hi <- 3
# `a <= 1 | b <= 1` shape parameters
a_lo <- 0.5
b_lo <- 0.5

test_that("Documented example matches", {
  expect_identical(str_point_interval(2, 3, "hdi", "mode", 0.95, TRUE), "Mode, 95% HDI")
})

test_that("`interval = 'eti'` branches", {
  expect_identical(str_point_interval(a_hi, b_hi, "eti", "mean", 0.95, TRUE), "Mean, 95% ETI")
  expect_identical(str_point_interval(a_hi, b_hi, "eti", "median", 0.95, TRUE), "Median, 95% ETI")
  expect_identical(str_point_interval(a_hi, b_hi, "eti", "mode", 0.95, TRUE), "Mode, 95% ETI")
  expect_identical(str_point_interval(a_hi, b_hi, "eti", "mode", 0.95, FALSE), "95% ETI")
  expect_identical(str_point_interval(a_hi, b_hi, "eti", "none", 0.95, TRUE), "95% ETI")
})

test_that("`interval = 'hdi'`, `pp_point = 'mean'` branches", {
  expect_identical(str_point_interval(a_hi, b_hi, "hdi", "mean", 0.95, TRUE), "Mean, 95% HDI")
  expect_identical(str_point_interval(a_lo, b_lo, "hdi", "mean", 0.95, TRUE), "Mean")
})

test_that("`interval = 'hdi'`, `pp_point = 'median'` branches", {
  expect_identical(str_point_interval(a_hi, b_hi, "hdi", "median", 0.95, TRUE), "Median, 95% HDI")
  expect_identical(str_point_interval(a_lo, b_lo, "hdi", "median", 0.95, TRUE), "Median")
})

test_that("`interval = 'hdi'`, `pp_point = 'mode'` branches", {
  expect_identical(str_point_interval(a_hi, b_hi, "hdi", "mode", 0.95, TRUE), "Mode, 95% HDI")
  expect_identical(str_point_interval(a_hi, b_hi, "hdi", "mode", 0.95, FALSE), "95% HDI")
  expect_identical(str_point_interval(a_lo, b_lo, "hdi", "mode", 0.95, TRUE), "Mode")
  expect_identical(str_point_interval(a_lo, b_lo, "hdi", "mode", 0.95, FALSE), "")
})

test_that("`interval = 'hdi'`, `pp_point = 'none'` branches", {
  expect_identical(str_point_interval(a_hi, b_hi, "hdi", "none", 0.95, TRUE), "95% HDI")
  expect_identical(str_point_interval(a_lo, b_lo, "hdi", "none", 0.95, TRUE), "")
})

test_that("`interval = 'none'` branches", {
  expect_identical(str_point_interval(a_hi, b_hi, "none", "mean", 0.95, TRUE), "Mean")
  expect_identical(str_point_interval(a_hi, b_hi, "none", "median", 0.95, TRUE), "Median")
  expect_identical(str_point_interval(a_hi, b_hi, "none", "mode", 0.95, TRUE), "Mode")
  expect_identical(str_point_interval(a_hi, b_hi, "none", "mode", 0.95, FALSE), "")
})

test_that("The `a <= 1 | b <= 1` boundary is inclusive at exactly 1", {
  expect_identical(str_point_interval(1, 5, "hdi", "mean", 0.95, TRUE), "Mean")
  expect_identical(str_point_interval(5, 1, "hdi", "mean", 0.95, TRUE), "Mean")
})

test_that("`prob_text` reflects `100 * prob`", {
  expect_identical(str_point_interval(a_hi, b_hi, "eti", "mean", 0.50, TRUE), "Mean, 50% ETI")
  expect_identical(str_point_interval(a_hi, b_hi, "eti", "mean", 0.89, TRUE), "Mean, 89% ETI")
})

test_that("`str_point_interval()` returns a single character value", {
  out <- str_point_interval(a_hi, b_hi, "eti", "mean", 0.95, TRUE)
  expect_type(out, "character")
  expect_length(out, 1)
})

