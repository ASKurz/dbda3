# Load the packages
library(tidyverse)
library(dbda3)

n_group <- 11
n_y <- 4

# Simulate the data
nomnom_long <- data.frame(
  group = rep(LETTERS[1:n_group], times = n_y) |>
    factor(),
  y = rep(1:n_y, each = n_group) |>
    factor(),
  z = c(n_group:1, rep(6, times = n_group), rep(6, times = n_group), 1:n_group) |>
    as.integer())

# Confirm the total counts are all 24 (Yes)
nomnom_long |>
  group_by(group) |>
  mutate(n = sum(z)) |>
  ungroup() |>
  distinct(n)

# Confirm the desired distribution (Yes)
nomnom_long |>
  ggplot(aes(x = group, fill = y, weight = z)) +
  geom_bar()

# Does it work to make a wide matrix version (Yes)
nomnom_wide <- nomnom_long |>
  pivot_wider(names_from = y, values_from = z) |>
  mutate(y = cbind(`1`, `2`, `3`, `4`)) |>
  rename_with(.cols = `1`:`4`, .fn = \(x) str_c("y", x)) |>
  mutate(n = y1 + y2 + y3 + y4)

str(nomnom_wide)

# Save `nomnom_long` as `nomnom_long.rda` in the `data` folder
usethis::use_data(nomnom_long)

