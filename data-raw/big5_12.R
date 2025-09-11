# Load the packages
library(tidyverse)

# Load the full data file
load(file = "/Users/solomonkurz/Dropbox/IPIP300/data/ipip.rda")
# load(url("https://github.com/ASKurz/IPIP300/raw/main/data/ipip.rda"))

# Randomly choose 12 levels of `country`
set.seed(1)

random_12_countries_vec <- ipip |>
  # Some cells have white space at the start of `country`
  drop_na() |>
  mutate(country = str_trim(country)) |>
  # Exclude levels with fewer than 100 cases for both levels of `sex`
  count(country, sex) |>
  group_by(country) |>
  filter(min(n) >= 100) |>
  distinct(country) |>
  ungroup() |>
  slice_sample(n = 12) |>
  arrange(country) |>
  pull()

# Inspect the levels
random_12_countries_vec

# Subset the data
set.seed(2)

big5_12 <- ipip |>
  # Drop unnecessary columns
  select(case:age, country:o) |>
  # Only retain complete cases
  drop_na() |>
  # Only cases from the 12 randomly chosen levels of `country`
  filter(country %in% random_12_countries_vec) |>
  group_by(country, sex) |>
  # Draw the cases, conditional on `age`
  slice_sample(n = 50, weight_by = dnorm(age, mean = 45, sd = 10)) |>
  ungroup() |>
  arrange(case)

# Wrangle the columns, and save as a conventional data frame
big5_12 <- big5_12 |>
  rename(id = case) |>
  mutate(sex = factor(sex, levels = 1:2, labels = c("male", "female")),
         country = ifelse(country == "South Afric", "South Africa", country)) |>
  # Remove attributes
  mutate(across(.cols = c(id, age), .fns = as.integer),
         country = as.character(country)) |>
  data.frame()

# Check the structure
glimpse(big5_12)

# Save `big5_12` as `big5_12.rda` in the `data` folder
usethis::use_data(big5_12)

