test_that("Character returns an error", {
  expect_error(in_hdi_grid("0.5", 0.95))
  expect_error(in_hdi_grid(0.5, "0.95"))
})

test_that("x within bounds", {
  expect_error(in_hdi_grid(-0.1, 0.95))
  expect_error(in_hdi_grid(1.1, 0.95))
})

test_that("prob within bounds", {
  expect_error(in_hdi_grid(0.5, -0.1))
  expect_error(in_hdi_grid(0.5, 1.1))
})

test_that("probdplyr::if_else(theta >= 0.0 & theta <= 1.0,  # Check for `theta` in range
           theta^z * (1.0 - theta)^(n - z), 0.0) must be a scalar", {
  expect_error(in_hdi_grid(0.5, c(0.8, 0.9)))
})

