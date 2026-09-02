diag_df <- posterior::example_draws() |>
  summarize_draws_dbda3()

test_that("Default call returns a `tt` object", {
  t <- tt_diag(diag_df)
  expect_s4_class(t, "tinytable")
})

test_that("First column is renamed to `variable_name`", {
  t <- tt_diag(diag_df)
  expect_identical(names(t)[1], "Parameter")

  t2 <- tt_diag(diag_df, variable_name = "Param")
  expect_identical(names(t2)[1], "Param")
})

test_that("`variable_name = NULL` retains the original column name", {
  t <- tt_diag(diag_df, variable_name = NULL)
  expect_identical(names(t)[1], "variable")
})

test_that("Adjusting digits arguments does not error", {
  expect_s4_class(
    tt_diag(diag_df, digits_q = 2, digits_rhat = 1, height = 0.2),
    "tinytable"
  )
  expect_s4_class(
    tt_diag(diag_df, digits_ess = 1, digits_mcse = 3),
    "tinytable"
  )
})

test_that("`monospace_j = NULL` skips the monospace styling without error", {
  expect_s4_class(tt_diag(diag_df, monospace_j = NULL), "tinytable")
})

test_that("`escape_body` and `escape_colnames` can be toggled without error", {
  expect_s4_class(tt_diag(diag_df, escape_body = FALSE), "tinytable")
  expect_s4_class(tt_diag(diag_df, escape_colnames = FALSE), "tinytable")
})

test_that("`tt_diag()` works when `mcse` columns are present", {
  diag_mcse_df <- posterior::example_draws() |>
    summarize_draws_dbda3(mcse = TRUE)
  expect_s4_class(tt_diag(diag_mcse_df), "tinytable")
})

test_that("A data frame lacking q/ess/rhat/mcse columns still returns a `tt` object", {
  plain_df <- data.frame(variable = c("a", "b"), value = c(1.1, 2.2))
  expect_s4_class(tt_diag(plain_df), "tinytable")
})

