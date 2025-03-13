test_that("Character returns an error", {
  expect_error(in_eti_grid("0.5", 0.95))
  expect_error(in_eti_grid(0.5, "0.95"))
})

test_that("x within bounds", {
  expect_error(in_eti_grid(-0.1, 0.95))
  expect_error(in_eti_grid(1.1, 0.95))
})

test_that("prob within bounds", {
  expect_error(in_eti_grid(0.5, -0.1))
  expect_error(in_eti_grid(0.5, 1.1))
})

