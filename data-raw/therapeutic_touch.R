# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
therapeutic_touch <- read_csv("data-raw/data.R/TherapeuticTouchData.csv")

# Convert both variables to integers
# therapeutic_touch <- therapeutic_touch |>
#   mutate(y = as.integer(y),
#          s = factor(s) |> as.integer())

# Convert numeric `y` values to descriptive characters
therapeutic_touch <- therapeutic_touch |>
  mutate(response = ifelse(y == 0, "wrong", "correct"))

# Confirm the new `response` values are as desired
therapeutic_touch |>
  distinct(y, response)

# Rename `s` to `participant`
therapeutic_touch <- therapeutic_touch |>
  rename(participant = s)

# Remove `y`
therapeutic_touch <- therapeutic_touch |>
  select(-y)

# Confirm the desired columns remain
colnames(therapeutic_touch)

# Save `therapeutic_touch` as `therapeutic_touch.rda` in the `data` folder
usethis::use_data(therapeutic_touch)

