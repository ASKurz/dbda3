set.seed(2071)
x <- rnorm(1000, mean = 110, sd = 15)

test_that("Character returns an error", {
  expect_error(loss_decision(x = "bob", rope = c(99, 101)))
  expect_error(loss_decision(x, rope = "bob"))
  expect_error(loss_decision(x, rope_narrow = "bob", rope_wide = c(90, 110)))
  expect_error(loss_decision(x, rope_narrow = c(99, 101), rope_wide = "bob"))
  expect_error(loss_decision(x, rope = c(99, 101), loss_type = "bob"))
  expect_error(loss_decision(x, rope = c(99, 101), alpha = "bob"))
  expect_error(loss_decision(x, rope = c(99, 101), na.rm = "bob"))
})

test_that("x within bounds", {
  expect_error(loss_decision(x, rope = c(99, 101), alpha = -1))
  expect_error(loss_decision(x, rope = c(99, 101), alpha = 1.5))
})

test_that("`rope`, or `rope_narrow` and `rope_wide`, must be specified", {
  expect_error(loss_decision(x))
  expect_error(loss_decision(x, rope_narrow = c(99, 101)))
  expect_error(loss_decision(x, rope_wide = c(90, 110)))
})

test_that("`rope[1]` must be less than `rope[2]`, for `rope`, `rope_narrow`, and `rope_wide`", {
  expect_error(loss_decision(x, rope = c(101, 99)))
  expect_error(loss_decision(x, rope_narrow = c(101, 99), rope_wide = c(90, 110)))
  expect_error(loss_decision(x, rope_narrow = c(99, 101), rope_wide = c(110, 90)))
})

test_that("`rope` must nest between `rope_wide` and `rope_narrow`", {
  expect_error(loss_decision(x, rope = c(50, 101), rope_narrow = c(99, 101), rope_wide = c(90, 110)))
  expect_error(loss_decision(x, rope = c(99, 150), rope_narrow = c(99, 101), rope_wide = c(90, 110)))
})

test_that("`loss_decision()` returns a 1 x 5 data frame with the expected columns", {
  out <- loss_decision(x, rope = c(99, 101))
  expect_s3_class(out, "data.frame")
  expect_equal(dim(out), c(1, 5))
  expect_identical(
    names(out),
    c("less_than", "equivalent", "greater_than", "uncommitted", "decision")
  )
})

test_that("`decision` correctly identifies 'less than'", {
  x_low <- rnorm(1000, mean = 50, sd = 5)
  out <- loss_decision(x_low, rope = c(99, 101))
  expect_identical(out$decision, "less than")
})

test_that("`decision` correctly identifies 'greater than'", {
  x_high <- rnorm(1000, mean = 150, sd = 5)
  out <- loss_decision(x_high, rope = c(99, 101))
  expect_identical(out$decision, "greater than")
})

test_that("`decision` correctly identifies 'equivalent'", {
  x_eq <- rnorm(1000, mean = 100, sd = 0.2)
  out <- loss_decision(x_eq, rope = c(99, 101))
  expect_identical(out$decision, "equivalent")
})

test_that("`decision` correctly identifies 'uncommitted'", {
  out <- loss_decision(x, rope = c(99, 101))
  expect_identical(out$decision, "uncommitted")
})

test_that("`uncommitted` always equals `alpha`", {
  out <- loss_decision(x, rope = c(99, 101), alpha = 0.01)
  expect_equal(out$uncommitted, 0.01)
})

test_that("`na.rm = FALSE` (the default) propagates `NA` in the loss columns", {
  x_na <- c(x, NA)
  out <- loss_decision(x_na, rope = c(99, 101))
  expect_true(all(is.na(out[, c("less_than", "equivalent", "greater_than")])))
})

test_that("`na.rm = TRUE` computes losses over the non-missing values", {
  x_na <- c(x, NA)
  out_na_rm <- loss_decision(x_na, rope = c(99, 101), na.rm = TRUE)
  out_ref <- loss_decision(x, rope = c(99, 101))
  expect_equal(
    out_na_rm[, c("less_than", "equivalent", "greater_than")],
    out_ref[, c("less_than", "equivalent", "greater_than")]
  )
})

test_that("`loss_type` accepts 'step', 'halfstep', and 'thick' without error", {
  expect_s3_class(loss_decision(x, rope = c(99, 101), loss_type = "step"), "data.frame")
  expect_s3_class(loss_decision(x, rope = c(99, 101), loss_type = "halfstep"), "data.frame")
  expect_s3_class(loss_decision(x, rope = c(99, 101), loss_type = "thick"), "data.frame")
})

test_that("`rope_narrow` and `rope_wide` can be specified instead of `rope`", {
  out <- loss_decision(
    x,
    rope_narrow = 110 + c(-29, 29),
    rope_wide = 110 + c(-31, 31),
    loss_type = "halfstep"
  )
  expect_s3_class(out, "data.frame")
  expect_equal(dim(out), c(1, 5))
})

