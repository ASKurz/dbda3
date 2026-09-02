withr::local_seed(6029)

loss_df <- rnorm(n = 1e3, mean = 110, sd = 15) |>
  loss_decision(rope = c(99, 101))

test_that("Default call returns a `tinytable` object", {
  t <- tt_loss(loss_df)
  expect_s4_class(t, "tinytable")
})

test_that("Adjusting `digits` and `height` does not error", {
  expect_s4_class(tt_loss(loss_df, digits = 4, height = 0.2), "tinytable")
})

test_that("Adjusting `placement` does not error", {
  expect_s4_class(tt_loss(loss_df, placement = "h"), "tinytable")
})

test_that("`tt_loss()` works across the four possible decisions", {
  # less than
  expect_s4_class(
    tt_loss(loss_decision(rnorm(1e3, mean = 50, sd = 15), rope = c(99, 101))),
    "tinytable"
  )
  # equivalent
  expect_s4_class(
    tt_loss(loss_decision(rnorm(1e3, mean = 100, sd = 1), rope = c(99, 101))),
    "tinytable"
  )
  # greater than
  expect_s4_class(
    tt_loss(loss_decision(rnorm(1e3, mean = 150, sd = 15), rope = c(99, 101))),
    "tinytable"
  )
  # uncommitted
  expect_s4_class(
    tt_loss(loss_decision(rnorm(1e3, mean = 100, sd = 15), rope = c(99, 101), alpha = 0.99)),
    "tinytable"
  )
})

test_that("Additional arguments are passed through to `tt()`", {
  expect_s4_class(tt_loss(loss_df, width = 0.5), "tinytable")
})

