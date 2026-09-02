test_that("Documented example matches", {
  expect_equal(theta_for_label(2, 3, "hdi", "mode", 0.95, TRUE), 1 / 3)
})

test_that("`pp_point = 'mean'` matches `a / (a + b)`", {
  expect_equal(theta_for_label(2, 3, "hdi", "mean", 0.95, TRUE), 2 / (2 + 3))
})

test_that("`pp_point = 'median'` matches `qbeta(0.5, a, b)`", {
  expect_equal(theta_for_label(2, 3, "hdi", "median", 0.95, TRUE), qbeta(0.5, 2, 3))
})

test_that("`pp_point = 'mode'` with `a > 1 & b > 1` matches `(a - 1) / (a + b - 2)`", {
  expect_equal(theta_for_label(2, 3, "hdi", "mode", 0.95, TRUE), (2 - 1) / (2 + 3 - 2))
})

test_that("`pp_point = 'mode'` with `a <= 1 & a < b` returns 0", {
  expect_equal(theta_for_label(0.5, 2, "hdi", "mode", 0.95, TRUE), 0)
})

test_that("`pp_point = 'mode'` with `b <= 1 & b < a` returns 1", {
  expect_equal(theta_for_label(2, 0.5, "hdi", "mode", 0.95, TRUE), 1)
})

test_that("The bimodal special case (`a = b <= 1`, `unique_mode = FALSE`) matches `qbeta(0.5, a, b)`", {
  expect_equal(theta_for_label(0.5, 0.5, "hdi", "mode", 0.95, FALSE), qbeta(0.5, 0.5, 0.5))
})

test_that("The bimodal case with `unique_mode = TRUE` (mismatched) returns `NA`", {
  expect_true(is.na(theta_for_label(0.5, 0.5, "hdi", "mode", 0.95, TRUE)))
})

test_that("`pp_point = 'none'`, `interval = 'eti'` matches `qbeta(0.5, a, b)`", {
  expect_equal(theta_for_label(2, 3, "eti", "none", 0.95, TRUE), qbeta(0.5, 2, 3))
})

test_that("`pp_point = 'none'`, `interval = 'hdi'` matches `mean(hdi_of_icdf(qbeta, ...))`", {
  expected <- mean(hdi_of_icdf(qbeta, shape1 = 2, shape2 = 3, prob = 0.95))
  expect_equal(theta_for_label(2, 3, "hdi", "none", 0.95, TRUE), expected)
})

test_that("`theta_for_label()` returns a single numeric value between 0 and 1", {
  out <- theta_for_label(2, 3, "hdi", "mode", 0.95, TRUE)
  expect_type(out, "double")
  expect_length(out, 1)
  expect_true(out >= 0 && out <= 1)
})

