# Load the packages
library(tidyverse)
library(dbda3)

n_group <- 11
n_y <- 4

# Simulate the data
nom_nom_long <- data.frame(
  group = rep(LETTERS[1:n_group], times = n_y) |>
    factor(),
  y = rep(1:n_y, each = n_group) |>
    factor(),
  z = c(n_group:1, rep(6, times = n_group), rep(6, times = n_group), 1:n_group) |>
    as.integer())

# Confirm the total counts are all 24 (Yes)
nom_nom_long |>
  group_by(group) |>
  mutate(n = sum(z)) |>
  ungroup() |>
  distinct(n)

# Confirm the desired distribution (Yes)
nom_nom_long |>
  ggplot(aes(x = group, fill = y, weight = z)) +
  geom_bar()

# Does it work to make a wide matrix version (Yes)
nomnom_wide <- nom_nom_long |>
  pivot_wider(names_from = y, values_from = z) |>
  mutate(y = cbind(`1`, `2`, `3`, `4`)) |>
  rename_with(.cols = `1`:`4`, .fn = \(x) str_c("y", x)) |>
  mutate(n = y1 + y2 + y3 + y4)

str(nomnom_wide)

# Save `nom_nom_long` as `nom_nom_long.rda` in the `data` folder
usethis::use_data(nom_nom_long)

