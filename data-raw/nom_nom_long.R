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

# Create temporary `nom_nom_1` data frame that has a single observation in
# each row, to imitate what might be created by actual research:

set.seed(47)
nom_nom_1 <- nom_nom_long |>
  uncount(z) |>
  slice_sample(prop = 1, replace = FALSE)

# Confirm all this does is disaggregate and reorder, but
# the original summaries are retained (yes)
all.equal(
  nom_nom_long |>
    arrange(group, y),
  nom_nom_1 |>
    count(group, y, name = "z")
)

# Confirm both versions have the desired distribution (Yes)
nom_nom_long |>
  ggplot(aes(x = group, fill = y, weight = z)) +
  geom_bar()

nom_nom_1 |>
  ggplot(aes(x = group, fill = y)) +
  geom_bar()

# Does it work to make a wide matrix version (Yes)
nomnom_wide <- nom_nom_long |>
  pivot_wider(names_from = y, values_from = z) |>
  mutate(y = cbind(`1`, `2`, `3`, `4`)) |>
  rename_with(.cols = `1`:`4`, .fn = \(x) str_c("y", x)) |>
  mutate(n = y1 + y2 + y3 + y4)

str(nomnom_wide)

# Save the disaggregated `nom_nom_1` as `nom_nom_long`
nom_nom_long <- nom_nom_1

# Check updated structure
str(nom_nom_long)

# Save `nom_nom_long` as `nom_nom_long.rda` in the `data` folder
usethis::use_data(nom_nom_long)

