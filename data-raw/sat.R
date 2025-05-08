# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
sat <- read_csv("data-raw/data.R/Guber1999data.csv")

# Convert all column names to lower case
sat <- sat |>
  rename_with(.fn = tolower)

# Inspect the data
glimpse(sat)

# Save `sat` as `sat.rda` in the `data` folder
usethis::use_data(sat)

