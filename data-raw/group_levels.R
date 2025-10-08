# Load the packages
library(tidyverse)
library(dbda3)  # For `standardize()`

# Number per group
n <- 5

# Simulate the data
set.seed(42)

group_levels <- data.frame(m = c(rep(0, times = 4), 10)) |>
  mutate(y = map(.x = m, .f = function(m) {
    rnorm(n = n) |> standardize() + m
  })) |>
  unnest(y) |>
  mutate(group_first = rep(LETTERS[c(2:n, 1)], each = n) |> factor(levels = LETTERS[1:n], ordered = TRUE),
         group_last  = rep(LETTERS[1:n],       each = n) |> factor(levels = LETTERS[1:n], ordered = TRUE)) |>
  select(-m) |>
  # Save as conventional data frame
  data.frame()

# Check the structure
glimpse(group_levels)

# Save `group_levels` as `group_levels.rda` in the `data` folder
usethis::use_data(group_levels)

