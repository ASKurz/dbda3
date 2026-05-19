# Load the packages
library(tidyverse)
library(dbda3)  # For `standardize()`

# Number per group
n <- 5

# Simulate the data
set.seed(42)

group_ae <- data.frame(m = c(1:4, 10)) |>
  mutate(y = map(.x = m, .f = function(m) {
    rnorm(n = n) |> standardize() + m
  })) |>
  unnest(y) |>
  mutate(group_first = rep(LETTERS[c(2:n, 1)], each = n) |> factor(levels = LETTERS[1:n]),
         group_last  = rep(LETTERS[1:n],       each = n) |> factor(levels = LETTERS[1:n])) |>
  rename(group_orig = group_last,
         group_perm = group_first) |>
  select(y, group_orig, group_perm) |>
  # Save as conventional data frame
  data.frame()

# Check the structure
glimpse(group_ae)

# Summarize
group_ae |>
  group_by(group_orig, group_perm) |>
  summarize(n = n(),
            m = mean(y) |> round(digits = 4),
            s = sd(y))

# Save `group_ae` as `group_ae.rda` in the `data` folder
usethis::use_data(group_ae)

