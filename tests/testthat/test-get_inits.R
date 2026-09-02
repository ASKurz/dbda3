# `get_inits()` only reads `object$fit@inits`, so we build a lightweight
# stand-in for a `brmsfit` object rather than fitting a real Stan model
# (which would be slow and unnecessary for exercising this function).
methods::setClass("mock_stanfit", representation(inits = "list"))

make_mock_brmsfit <- function(inits) {
  mock_fit <- methods::new("mock_stanfit", inits = inits)
  mock_brmsfit <- list(fit = mock_fit)
  class(mock_brmsfit) <- "brmsfit"
  mock_brmsfit
}

mock_inits <- list(
  list(mu = 0.1,  sigma = 1.2),
  list(mu = -0.3, sigma = 0.9),
  list(mu = 0.05, sigma = 1.1),
  list(mu = 0.2,  sigma = 1.0)
)

test_that("A non-`brmsfit` object returns an error", {
  expect_error(get_inits(list(a = 1)), "must be of class `brmsfit`")
  expect_error(get_inits(data.frame(x = 1)), "must be of class `brmsfit`")
  expect_error(get_inits("bob"), "must be of class `brmsfit`")
  expect_error(get_inits(lm(mpg ~ wt, data = mtcars)), "must be of class `brmsfit`")
})

test_that("`get_inits()` extracts `object$fit@inits` unchanged", {
  mock_brmsfit <- make_mock_brmsfit(mock_inits)
  expect_identical(get_inits(mock_brmsfit), mock_inits)
})

test_that("The result is a list with one element per chain", {
  mock_brmsfit <- make_mock_brmsfit(mock_inits)
  out <- get_inits(mock_brmsfit)
  expect_type(out, "list")
  expect_length(out, 4)
  expect_true(all(vapply(out, is.list, logical(1))))
})

test_that("Each chain-level list is named for its parameters", {
  mock_brmsfit <- make_mock_brmsfit(mock_inits)
  out <- get_inits(mock_brmsfit)
  expect_identical(names(out[[1]]), c("mu", "sigma"))
})

test_that("A different number of chains is reflected in the output length", {
  two_chain_inits <- mock_inits[1:2]
  mock_brmsfit <- make_mock_brmsfit(two_chain_inits)
  expect_length(get_inits(mock_brmsfit), 2)
})

