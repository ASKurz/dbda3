# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
fruitfly <- read_csv("data-raw/data.R/FruitflyDataReduced.csv")

fruitfly <- fruitfly |>
  # Adjust names
  rename_all(.funs = tolower) |>
  rename(companion_number = companionnumber) |>
  # Rename levels and save as a factor
  mutate(companion_number = str_replace(companion_number, pattern = "Pregnant", replacement = "pregnant_") |>
           str_replace(pattern = "None", replacement = "none_") |>
           str_replace(pattern = "Virgin", replacement = "virgin_") |>
           factor(levels = c("none_0", "pregnant_1", "pregnant_8", "virgin_1", "virgin_8")),
         # Convert to integer
         longevity = as.integer(longevity)) |>
  # Reorder columns
  select(companion_number, thorax, longevity) |>
  # Convert to conventional data frame
  data.frame() |>
  # Change the name of the group
  rename(group = companion_number)

# Inspect the data
glimpse(fruitfly)

# Save `fruitfly` as `fruitfly.rda` in the `data` folder
usethis::use_data(fruitfly)

