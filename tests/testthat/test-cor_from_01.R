test_that("Character returns an error", {
  expect_error(cor_from_01("0.5"))
})

test_that("x within bounds", {
  expect_error(cor_from_01(-0.1))
  expect_error(cor_from_01(1.1))
})

