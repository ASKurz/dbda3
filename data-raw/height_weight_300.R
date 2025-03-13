# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
height_weight_300 <- read_csv("data-raw/data.R/HtWtData300.csv")

# Add standardized versions of `height` and `weight`
height_weight_300 <- height_weight_300 |>
  mutate(height_z = (height - mean(height)) / sd(height),
         weight_z = (weight - mean(weight)) / sd(weight))

# Remove the `male` column
height_weight_300 <- height_weight_300 |>
  select(-male)

# Confirm the desired columns remain
colnames(height_weight_300)

# Confirm the transformation worked as intended
height_weight_300 |>
  pivot_longer(everything()) |>
  group_by(name) |>
  summarise(m = mean(value),
            s = sd(value))

# Save `height_weight_300` as `height_weight_300.rda` in the `data` folder
usethis::use_data(height_weight_300)

