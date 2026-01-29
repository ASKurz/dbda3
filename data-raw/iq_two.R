# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
iq_two <- read_csv("data-raw/data.R/TwoGroupIQ.csv") |>
  # Rename and reorder
  transmute(group = factor(Group),         # Convert to factor
            score = as.integer(Score)) |>  # Convert to integer
  # Convert to conventional data frame
  data.frame()

# Inspect the data
glimpse(iq_two)

# Save `iq_two` as `iq_two.rda` in the `data` folder
usethis::use_data(iq_two)

