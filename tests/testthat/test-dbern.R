test_that("Character returns an error", {
  expect_error(dbern("0.5", 1, 2))
  expect_error(dbern(0.5, "1", 2))
  expect_error(dbern(0.5, 1, "2"))
})

test_that("`x` within bounds", {
  expect_error(dbern(-1, 1, 2))
  expect_error(dbern(10, 1, 2))
})

test_that("`z` within bounds", {
  expect_error(dbern(0.5, -1, 2))
})

test_that("`n` within bounds", {
  expect_error(dbern(0.5, 1, 0))
  expect_error(dbern(0.5, 1, -1))
})

