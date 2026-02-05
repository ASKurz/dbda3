# Load the packages
library(tidyverse)
library(dbda3)

# Load the data file, as used for DBDA2
HtWtData110 <- read_csv("data-raw/data.R/HtWtData110.csv") |>
  data.frame()

# Compute the data fresh
height_weight_110 <- height_weight_generator(n = 110, seed = 474)

# Are they the same? (Yes)s
all.equal(
  HtWtData110,
  height_weight_110)

# Save `height_weight_110` as `height_weight_110` in the `data` folder
usethis::use_data(height_weight_110)

