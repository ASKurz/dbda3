test_that("Character returns an error", {
  expect_error(bf_plot(bf = "bob"))
  expect_error(bf_plot(crit_post = "bob"))
  expect_error(bf_plot(bf_size = "bob"))
  expect_error(bf_plot(ar_size = "bob"))
})

test_that("x within bounds", {
  expect_error(bf_plot(bf = 0))
  expect_error(bf_plot(bf = Inf))
  expect_error(bf_plot(crit_post = 0.4))
  expect_error(bf_plot(crit_post = 2))
})

