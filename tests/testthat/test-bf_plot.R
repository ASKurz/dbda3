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

test_that("Invalid `coord_equal` values return an error", {
  expect_error(bf_plot(coord_equal = "bob"))
  expect_error(bf_plot(coord_equal = 1))
})

test_that("Default call returns a ggplot object", {
  p <- bf_plot()
  expect_s3_class(p, "ggplot")
})

test_that("`bf_plot()` returns a ggplot object for `bf` above, at, and below 1", {
  expect_s3_class(bf_plot(bf = 7.5), "ggplot")
  expect_s3_class(bf_plot(bf = 1), "ggplot")
  expect_s3_class(bf_plot(bf = 0.1), "ggplot")
})

test_that("`crit_post = NA` is allowed and returns a ggplot object", {
  expect_s3_class(bf_plot(crit_post = NA), "ggplot")
})

test_that("Additional ggplot2 layers can be added to the returned plot", {
  p <- bf_plot() +
    ggplot2::theme(panel.grid.major = ggplot2::element_line(color = "white"))
  expect_s3_class(p, "ggplot")
})

