test_that("Character returns an error", {
  expect_error(gamma_s_r_from_mean_sd("5", 2))
  expect_error(gamma_s_r_from_mean_sd(5, "2"))
})

test_that("mean within bounds", {
  expect_error(gamma_s_r_from_mean_sd(0, 2))
})

test_that("sd within bounds", {
  expect_error(gamma_s_r_from_mean_sd(5, 0))
})

