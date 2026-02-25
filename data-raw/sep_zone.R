# Load the packages
library(tidyverse)
library(dbda3)

# Number of cases per zone
n_per_zone <- 50

# Simulate the zeros
set.seed(47)
zeros <- MASS::mvrnorm(
  n = n_per_zone,
  m = c(0, 0),
  Sigma = matrix(c(1, -0.7, -0.7, 1), nrow = 2),
  empirical = TRUE)

# Simulate the ones
ones <- MASS::mvrnorm(
  n = n_per_zone,
  m = rep(3.75, 2),
  Sigma = matrix(c(1, -0.7, -0.7, 1), nrow = 2),
  empirical = TRUE)

# Combine the two, and wrangle
sep_zone <- rbind(zeros, ones) |>
  data.frame() |>
  rename_with(.fn = str_to_lower) |>
  mutate(y = rep(0:1, each = n_per_zone))

# Check the structure
str(sep_zone)

# Check the data with a `ggpairs()` plot
sep_zone |>
  mutate(y = factor(y)) |>
  GGally::ggpairs()

# Save `sep_zone` as `sep_zone.rda` in the `data` folder
usethis::use_data(sep_zone)

