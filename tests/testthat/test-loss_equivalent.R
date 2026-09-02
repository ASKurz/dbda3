x <- c(-3, -1.5, -0.75, -0.25, 0.25, 0.75, 1.5, 3)
rope <- c(-1, 1)
rope_narrow <- c(-0.5, 0.5)
rope_wide <- c(-2, 2)

test_that("`loss_type = 'step'` matches a manual computation", {
  expect_equal(
    loss_equivalent(x, rope = rope, loss_type = "step"),
    mean(x < rope[1] | x > rope[2])
  )
  expect_equal(loss_equivalent(x, rope = rope, loss_type = "step"), 0.5)
})

test_that("`loss_type = 'thick'` matches a manual computation", {
  expect_equal(
    loss_equivalent(x, rope_narrow = rope_narrow, loss_type = "thick"),
    mean(x < rope_narrow[1] | x > rope_narrow[2])
  )
  expect_equal(loss_equivalent(x, rope_narrow = rope_narrow, loss_type = "thick"), 0.75)
})

test_that("`loss_type = 'halfstep'` matches a manual computation", {
  expect_equal(
    loss_equivalent(x, rope_narrow = rope_narrow, rope_wide = rope_wide, loss_type = "halfstep"),
    0.5
  )
})

test_that("`loss_equivalent()` returns a single numeric value between 0 and 1", {
  out <- loss_equivalent(x, rope = rope, loss_type = "step")
  expect_length(out, 1)
  expect_true(out >= 0 && out <= 1)
})

test_that("`na.rm = FALSE` (the default) propagates `NA`", {
  x_na <- c(x, NA)
  expect_true(is.na(loss_equivalent(x_na, rope = rope, loss_type = "step")))
})

test_that("`na.rm = TRUE` computes the loss over the non-missing values", {
  x_na <- c(x, NA)
  expect_equal(
    loss_equivalent(x_na, rope = rope, loss_type = "step", na.rm = TRUE),
    loss_equivalent(x, rope = rope, loss_type = "step")
  )
})

test_that("A vector entirely within `rope` has zero loss under `loss_type = 'step'`", {
  expect_equal(loss_equivalent(c(-0.5, 0, 0.5), rope = rope, loss_type = "step"), 0)
})

test_that("A vector entirely outside `rope` has loss 1 under `loss_type = 'step'`", {
  expect_equal(loss_equivalent(c(-10, -8, 8, 10), rope = rope, loss_type = "step"), 1)
})

