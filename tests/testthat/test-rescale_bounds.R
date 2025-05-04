test_that("Character returns an error", {
  expect_error(rescale_bounds("0.5", 0, 1, 0, 1))
  expect_error(rescale_bounds(0.5, "0", 1, 0, 1))
  expect_error(rescale_bounds(0.5, 0, "1", 0, 1))
  expect_error(rescale_bounds(0.5, 0, 1, "0", 1))
  expect_error(rescale_bounds(0.5, 0, 1, 0, "1"))
})

