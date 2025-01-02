test_that("x within bounds", {
  expect_error(metro_walk(pro_sd = -1))
  expect_error(metro_walk(init_pos = -5))
  expect_error(metro_walk(init_pos = 5))
  expect_error(metro_walk(n_steps = -1))
  expect_error(metro_walk(z = -1))
  expect_error(metro_walk(n = -1))
  expect_error(metro_walk(n = 0))
  expect_error(metro_walk(a = -1))
  expect_error(metro_walk(b = -1))
})

