# Load the packages
library(tidyverse)
library(dbda3)

# Simulate the data
set.seed(47)

# Cases per group
n <- 25

het_dat <- data.frame(group = LETTERS[1:4] |> factor(),
                      m = c(100, 102, 100, 104),
                      s = c(2, 2, 8, 8)) |>
  mutate(y = map2(.x = m, .y = s, .f = \(m, s) {
    # This operation guarantees exact means and SDs
    rnorm(n = n) |>
      standardize() * s + m
  })) |>
  unnest(y) |>
  select(group, y) |>
  # Make it a conventional data frame
  data.frame()

# Check the structure
str(het_dat)

# Check the sample statistics
het_dat |>
  group_by(group) |>
  summarise(m = mean(y),
            s = sd(y),
            n = n())

# Save `het_dat` as `het_dat.rda` in the `data` folder
usethis::use_data(het_dat)

