test_that("`prob` within bounds", {
  expect_error(hdi_of_icdf(qnorm, prob = -1))
  expect_error(hdi_of_icdf(qnorm, prob = 1.1))
})

test_that("`tol` within bounds", {
  expect_error(hdi_of_icdf(qnorm, tol = 0))
  expect_error(hdi_of_icdf(qnorm, tol = Inf))
})

