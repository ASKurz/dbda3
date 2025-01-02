test_that("Character returns an error", {
  expect_error(beta_a_b_from_mean_sd("0.5", 0.2))
  expect_error(beta_a_b_from_mean_sd(0.5, "0.2"))
})

test_that("mean within bounds", {
  expect_error(beta_a_b_from_mean_sd(0, 0.2))
  expect_error(beta_a_b_from_mean_sd(1.1, 0.2))
})

test_that("kappa within bounds", {
  m <- 0.5
  s <- 1
  kappa <- m * (1 - m) / s^2 - 1  # less than zero

  expect_error(beta_a_b_from_mean_sd(m, s))
})

