test_that("Character returns an error", {
  expect_error(lpd("1", 1, 1, 1))
  expect_error(lpd(1, "1", 1, 1))
  expect_error(lpd(1, 1, "1", 1))
  expect_error(lpd(1, 1, 1, "1"))
})

test_that("x within bounds", {
  expect_error(lpd(-1, 1, 1, 1))
  expect_error(lpd(1, 0, 1, 1))
  expect_error(lpd(1, 1, -1, 1))
  expect_error(lpd(1, 1, 1, -1))
})

