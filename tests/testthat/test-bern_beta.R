test_that("Character returns an error", {
  expect_error(bern_beta(a = "bob"))
  expect_error(bern_beta(b = "bob"))
  expect_error(bern_beta(z = "bob"))
  expect_error(bern_beta(n = "bob"))
  expect_error(bern_beta(prob = "bob"))
  expect_error(bern_beta(interval = "bob"))
  expect_error(bern_beta(pp_point = "bob"))
  expect_error(bern_beta(l_point = "bob"))
})

test_that("x within bounds", {
  expect_error(bern_beta(a = -1))
  expect_error(bern_beta(b = -1))
  expect_error(bern_beta(z = -1))
  expect_error(bern_beta(n = -1))
  expect_error(bern_beta(prob = 2))
})

