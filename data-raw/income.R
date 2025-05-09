# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
income <- read_csv("data-raw/data.R/IncomeFamszState3yr.csv", comment = "#")

# Adjust the column names, and reorder the columns
income <- income |>
  # Convert to integer
  mutate(FamilySize = as.integer(FamilySize)) |>
  transmute(state = State,
            family_size = FamilySize,
            income = MedianIncome,
            income_se = SampErr) |>
  # Add spaces and make "of" lower case
  mutate(state = str_replace_all(state, "([a-z])([A-Z])", "\\1 \\2") |>
           str_replace(" Of", " of")) |>
  # Save as a conventional data frame
  data.frame()

# Inspect the data
glimpse(income)

# Save `income` as `income.rda` in the `data` folder
usethis::use_data(income)

