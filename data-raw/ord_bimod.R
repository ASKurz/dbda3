# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
ord_bimod <- read_csv("data-raw/data.R/OrdinalProbitData-1grp-2.csv") |>
  # Convert to an ordered factor
  transmute(y = factor(Y, ordered = TRUE)) |>
  # Convert to conventional data frame
  data.frame()

# Inspect the data
str(ord_bimod)

# Save `ord_bimod` as `ord_bimod.rda` in the `data` folder
usethis::use_data(ord_bimod)

