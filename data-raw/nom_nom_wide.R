# Load the packages
library(tidyverse)
library(dbda3)

data(nom_nom_long, package = "dbda3")

# Convert from the long to the wide
nom_nom_wide <- nom_nom_long |>
  count(group, y) |>
  pivot_wider(names_from = y, values_from = n) |>
  # mutate(y = cbind(`1`, `2`, `3`, `4`)) |>  # No more matrix column
  rename_with(.cols = `1`:`4`, .fn = \(x) str_c("y", x)) |>
  mutate(n = y1 + y2 + y3 + y4)

# Confirm
str(nom_nom_wide)

# Extract the matrix (Vestigial)
# nom_nom_wide$y

# Save `nom_nom_wide` as `nom_nom_wide` in the `data` folder
usethis::use_data(nom_nom_wide)

