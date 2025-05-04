# Load the packages
library(tidyverse)
library(dbda3)

# Set parameters for the `panel`-level n
n_panel_row <- 4
n_panel_col <- 7
initial_n <- (n_panel_row * n_panel_col - 2)  # 26

# Simulate
set.seed(47)

normal_panels <- data.frame(
  panel = 1:initial_n,
  # A temporary anchoring value for the intercept and slope in each panel.
  # It sequentially increases across the levels of `panel`.
  intercept_slope = seq(from = 0, to = 10, length.out = initial_n)) |>
  mutate(dat = map(.x = intercept_slope, .f = function(intercept_slope) {

    # Random number of rows per `panel`
    n <- max(2, rpois(n = 1, lambda = 5))

    # Range for `x`
    min <- 14 - (intercept_slope / 10) * (14 - 10)
    max <- 20 - (intercept_slope / 10) * (20 - 16)

    # `panel` level data for the predictor `x`
    d <- data.frame(x = runif(n = n, min = min, max = max))

    # Parameters for `y`
    b0 <- 5 * (intercept_slope - 5 + rnorm(1, mean = 0, sd = 1))
    b1 <- intercept_slope - 0 + rnorm(1, mean = 0, sd = 1)

    # `panel` level data for `y`
    d <- d |>
      mutate(y = b0 + b1 * x + rnorm(n = n, mean = 0, sd = 10))
  })) |>
  unnest(dat)|>
  # Drop unneeded column
  select(-intercept_slope)

# Append two single-point panels, `y` high and `y` low
normal_panels <- normal_panels |>
  bind_rows(
    data.frame(panel = initial_n + 1:2,
               x = mean(normal_panels$x),
               y = mean(normal_panels$y) + c(2, -2) * sd(normal_panels$y))) |>
  # Add standardized versions of the variables
  mutate(z_x = standardize(x),
         z_y = standardize(y),
         # Make the index a factor
         panel = factor(panel)) |>
  # Convert from tibble to generic data frame
  data.frame()

# Check the structure
str(normal_panels)

# Save `normal_panels` as `normal_panels.rda` in the `data` folder
usethis::use_data(normal_panels)

