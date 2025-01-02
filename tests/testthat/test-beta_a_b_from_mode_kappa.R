test_that("Character returns an error", {
  expect_error(beta_a_b_from_mode_kappa("0.5", 3))
  expect_error(beta_a_b_from_mode_kappa(0.5, "3"))
})

test_that("mode within bounds", {
  expect_error(beta_a_b_from_mode_kappa(0, 3))
  expect_error(beta_a_b_from_mode_kappa(1.1, 3))
})

test_that("kappa within bounds", {
  expect_error(beta_a_b_from_mode_kappa(0.5, 0))
})

