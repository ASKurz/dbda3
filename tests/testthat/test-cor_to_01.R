test_that("Character returns an error", {
  expect_error(cor_to_01("0.5"))
})

test_that("x within bounds", {
  expect_error(cor_to_01(-1.1))
  expect_error(cor_to_01(1.1))
})

