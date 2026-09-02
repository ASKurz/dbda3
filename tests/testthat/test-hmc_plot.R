withr::local_seed(9312)

# Small helper data frame with the columns `hmc_plot()` requires
make_hmc_df <- function(n_impulse = 5, l = 3) {
  purrr::map_dfr(
    seq_len(n_impulse),
    function(i) {
      hmc_proposal(epsilon = 0.1, l = l, seed = i) |>
        dplyr::mutate(impulse = i, epsilon = 0.1, .before = 1)
    }
  )
}

hmc_df <- make_hmc_df()

test_that("Missing required columns return an error", {
  expect_error(hmc_plot(hmc_df[, c("impulse", "epsilon")]))
  expect_error(hmc_plot(data.frame(x = 1:3)))
})

test_that("Non-data-frame input returns an error", {
  expect_error(hmc_plot(as.list(hmc_df)))
  expect_error(hmc_plot("bob"))
})

test_that("Invalid `mo_sd` values return an error", {
  expect_error(hmc_plot(hmc_df, mo_sd = -1))
  expect_error(hmc_plot(hmc_df, mo_sd = Inf))
  expect_error(hmc_plot(hmc_df, mo_sd = "bob"))
})

test_that("Default call returns a patchwork/ggplot object", {
  p <- hmc_plot(hmc_df)
  expect_s3_class(p, "patchwork")
  expect_s3_class(p, "ggplot")
})

test_that("`breaks = waiver()` is allowed and returns a plot", {
  expect_s3_class(hmc_plot(hmc_df, breaks = waiver()), "patchwork")
})

test_that("Aesthetic arguments can be adjusted without error", {
  p <- hmc_plot(
    hmc_df,
    top_facet_label = "Well-tuned HMC",
    fill_posterior = "plum1",
    color_potential = "plum3",
    color_hd = "plum4",
    fill_proposals = "plum2"
  )
  expect_s3_class(p, "patchwork")
})

