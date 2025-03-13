test_that("Character returns an error", {
  expect_error(logit("0.5"))
})

test_that("x within bounds", {
  expect_error(logit(-0.1))
  expect_error(logit(1.1))
})

test_that("logit() equals qlogis()", {
  x <- runif(n = 1, min = 0.001, max = 0.999)
  logical_value <- logit(x) == qlogis(x)
  expect_true(logical_value)
})

