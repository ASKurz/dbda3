# Load the packages
library(tidyverse)
library(dbda3)

data(nomnom_long, package = "dbda3")

# Convert from the long to the wide
nomnom_wide <- nomnom_long |>
  pivot_wider(names_from = y, values_from = z) |>
  mutate(y = cbind(`1`, `2`, `3`, `4`)) |>
  rename_with(.cols = `1`:`4`, .fn = \(x) str_c("y", x)) |>
  mutate(n = y1 + y2 + y3 + y4)

# Confirm
str(nomnom_wide)

# Extract the matrix
nomnom_wide$y

# Save `nomnom_wide` as `nomnom_wide` in the `data` folder
usethis::use_data(nomnom_wide)

