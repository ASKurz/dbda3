# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
height_weight_300 <- read_csv("data-raw/data.R/HtWtData300.csv")

# Convert from a tibble to a conventional data frame
height_weight_300 <- data.frame(height_weight_300)

# Save `height_weight_300` as `height_weight_300.rda` in the `data` folder
usethis::use_data(height_weight_300)

