test_that("Character returns an error", {
  expect_error(height_weight_generator("1"))
  expect_error(height_weight_generator(1, "0.5"))
  expect_error(height_weight_generator(1, 0.5, "1"))
})

test_that("x within bounds", {
  expect_error(height_weight_generator(0))
  expect_error(height_weight_generator(1, 1.1, 1))
})

