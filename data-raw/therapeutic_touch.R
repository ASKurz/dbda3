# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
therapeutic_touch <- read_csv("data-raw/data.R/TherapeuticTouchData.csv")

# Convert both variables to integers
therapeutic_touch <- therapeutic_touch |>
  mutate(y = as.integer(y),
         s = factor(s) |> as.integer())

# Save `therapeutic_touch` as `therapeutic_touch.rda` in the `data` folder
usethis::use_data(therapeutic_touch)

