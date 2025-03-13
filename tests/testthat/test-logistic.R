test_that("Character returns an error", {
  expect_error(logistic("0.5"))
})

test_that("logistic() equals plogis()", {
  x <- runif(n = 1, min = -10, max = 10)
  logical_value <- logistic(x) == plogis(x)
  expect_true(logical_value)
})

