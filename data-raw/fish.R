# Load the packages
library(tidyverse)

# Data were downloaded on June 14, 2026, from https://stats.idre.ucla.edu/stat/data/fish.csv
fish <- read.csv("https://stats.idre.ucla.edu/stat/data/fish.csv") |>
  # Subset the columns
  select(count, child, persons, livebait, camper) |>
  # Save as factors
  mutate(camper = factor(camper),
         livebait = factor(livebait))

# Inspect the data
str(fish)

# Save `fish` as `fish.rda` in the `data` folder
usethis::use_data(fish)

