# Load the packages
library(tidyverse)

# Load the full data file
load(file = "/Users/solomonkurz/Dropbox/IPIP300/data/ipip.rda")
# load(url("https://github.com/ASKurz/IPIP300/raw/main/data/ipip.rda"))

# Subset the data
set.seed(4)

big5_usa <- ipip |>
  # Drop unnecessary columns
  select(case:age, country:o) |>
  # Only retain complete cases
  drop_na() |>
  # Only cases from USA
  filter(country == "USA") |>
  # Group to guarantee equal numbers by `sex`
  group_by(sex) |>
  # Draw the cases, conditional on `age`
  slice_sample(n = 50, weight_by = dnorm(age, mean = 45, sd = 10)) |>
  ungroup() |>
  arrange(case)

# Wrangle the columns, and save as a conventional data frame
big5_usa <- big5_usa |>
  rename(id = case) |>
  mutate(sex = factor(sex, levels = 1:2, labels = c("male", "female"))) |>
  # Remove attributes
  mutate(across(.cols = c(id, age), .fns = as.integer),
         country = as.character(country)) |>
  data.frame()

# Check the structure
glimpse(big5_usa)

# Save `big5_usa` as `big5_usa.rda` in the `data` folder
usethis::use_data(big5_usa)

