test_that("Character returns an error", {
  expect_error(beta_a_b_from_mean_kappa("0.25", 200))
  expect_error(beta_a_b_from_mean_kappa(0.25, "200"))
})

test_that("mean within bounds", {
  expect_error(beta_a_b_from_mean_kappa(0, 200))
  expect_error(beta_a_b_from_mean_kappa(1.1, 200))
})

test_that("kappa within bounds", {
  expect_error(beta_a_b_from_mean_kappa(0.5, 0))
})

