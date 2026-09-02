z_ex <- c(15, 20, 25, 30, 35)
n_ex <- c(50, 50, 50, 50, 50)
param_ex <- c(theta = z_ex / n_ex, omega = sum(z_ex) / sum(n_ex), kappa = 2.01)

test_that("`neg_log_lik()` matches a manual computation of the negative log likelihood", {
  theta <- z_ex / n_ex
  omega <- sum(z_ex) / sum(n_ex)
  kappa <- 2.01
  a <- omega * (kappa - 2) + 1
  b <- (1 - omega) * (kappa - 2) + 1
  log_p_data_g_theta <- z_ex * log(theta) + (n_ex - z_ex) * log(1 - theta)
  log_p_theta_g_ab <- dbeta(theta, a, b, log = TRUE)
  expected <- -sum(log_p_data_g_theta + log_p_theta_g_ab)

  expect_equal(neg_log_lik(param = param_ex, z = z_ex, n = n_ex), expected)
})

test_that("`neg_log_lik()` returns a single numeric value", {
  result <- neg_log_lik(param = param_ex, z = z_ex, n = n_ex)
  expect_length(result, 1)
  expect_type(result, "double")
})

test_that("`theta` and `omega` are clamped away from the (0, 1) boundary", {
  # theta = 0 and theta = 1 would otherwise produce -Inf via log(0)
  param_extreme <- c(theta = c(0, 1), omega = 0.5, kappa = 5)
  result <- neg_log_lik(param = param_extreme, z = c(0, 5), n = c(5, 5))
  expect_true(is.finite(result))
})

test_that("`kappa` is clamped to a minimum of 2", {
  param_low_kappa <- c(theta = 0.5, omega = 0.5, kappa = 0.5)
  param_min_kappa <- c(theta = 0.5, omega = 0.5, kappa = 2)
  expect_equal(
    neg_log_lik(param = param_low_kappa, z = 3, n = 6),
    neg_log_lik(param = param_min_kappa, z = 3, n = 6)
  )
})

test_that("`neg_log_lik()` is deterministic for repeated calls with the same input", {
  expect_equal(
    neg_log_lik(param = param_ex, z = z_ex, n = n_ex),
    neg_log_lik(param = param_ex, z = z_ex, n = n_ex)
  )
})

