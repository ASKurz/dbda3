# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
two_group_iq <- read_csv("data-raw/data.R/TwoGroupIQ.csv") |>
  # Rename and reorder
  transmute(group = factor(Group),         # Convert to factor
            score = as.integer(Score)) |>  # Convert to integer
  # Convert to conventional data frame
  data.frame()

# Inspect the data
glimpse(two_group_iq)

# Save `two_group_iq` as `two_group_iq.rda` in the `data` folder
usethis::use_data(two_group_iq)

