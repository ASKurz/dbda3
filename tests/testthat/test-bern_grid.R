test_that("Character returns an error", {
  expect_error(bern_grid(theta = as.character(0:3 / 3)))
  expect_error(bern_grid(p_theta = as.character(0:3 / 3)))
  expect_error(bern_grid(z = "bob"))
  expect_error(bern_grid(n = "bob"))
  expect_error(bern_grid(prob = "bob"))
  expect_error(bern_grid(interval = "bob"))
  expect_error(bern_grid(pp_point = "bob"))
  expect_error(bern_grid(l_point = "bob"))
})

test_that("x within bounds", {
  expect_error(bern_grid(theta = -1:4 / 3))
  expect_error(bern_grid(p_theta = 0:4))
  expect_error(bern_grid(z = -1))
  expect_error(bern_grid(n = -1))
  expect_error(bern_grid(prob = 2))
})

