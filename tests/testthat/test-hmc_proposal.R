test_that("x within bounds", {
  expect_error(hmc_proposal(epsilon = -1))
  expect_error(hmc_proposal(l = 0))
  expect_error(hmc_proposal(mo_sd = -5))
  expect_error(hmc_proposal(n_steps = -1))
})

test_that("Character returns an error", {
  expect_error(hmc_proposal(init_pos = "0"))
  expect_error(hmc_proposal(seed = "5"))
})

