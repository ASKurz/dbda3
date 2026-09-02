# Disable ANSI color codes for the whole file, so captured `glimpse()`
# output is directly comparable across calls.
withr::local_options(list(cli.num_colors = 1))

test_that("`peek_pipe()` returns `x` unchanged, and invisibly", {
  out <- withVisible(peek_pipe(mtcars))
  expect_identical(out$value, mtcars)
  expect_false(out$visible)
})

test_that("The default `view` behaves like `dplyr::glimpse()`, plus a trailing blank line", {
  expect_identical(
    capture.output(peek_pipe(mtcars)),
    c(capture.output(dplyr::glimpse(mtcars)), "")
  )
})

test_that("`view = \"str\"` (quoted) behaves like `str()`, plus a trailing blank line", {
  x <- 1:5
  expect_identical(
    capture.output(peek_pipe(x, view = "str")),
    c(capture.output(str(x)), "")
  )
})

test_that("`view = str` (unquoted) behaves the same as the quoted string", {
  x <- 1:5
  expect_identical(
    capture.output(peek_pipe(x, view = str)),
    capture.output(peek_pipe(x, view = "str"))
  )
})

test_that("`view = \"print\"` behaves like `print()`, plus a trailing blank line", {
  x <- 1:5
  expect_identical(
    capture.output(peek_pipe(x, view = "print")),
    c(capture.output(print(x)), "")
  )
})

test_that("`view = \"glimpse\"` (explicit string) matches the default behavior", {
  expect_identical(
    capture.output(peek_pipe(mtcars, view = "glimpse")),
    capture.output(peek_pipe(mtcars))
  )
})

test_that("An unrecognized `view` value falls back to `glimpse`", {
  expect_identical(
    capture.output(peek_pipe(mtcars, view = "bob")),
    capture.output(peek_pipe(mtcars))
  )
})

test_that("A trailing blank line is appended after the view output", {
  out <- capture.output(peek_pipe(1:5, view = "str"))
  expect_identical(out[length(out)], "")
})

test_that("Additional `...` arguments are passed through to the underlying view function", {
  full <- capture.output(peek_pipe(mtcars, view = "str"))
  truncated <- capture.output(peek_pipe(mtcars, view = "str", max.level = 0))
  expect_false(identical(full, truncated))
})

test_that("`peek_pipe()` works on non-data-frame input", {
  expect_identical(
    capture.output(peek_pipe(1:5)),
    c(capture.output(dplyr::glimpse(1:5)), "")
  )
})

