# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
height_weight_30 <- read_csv("data-raw/data.R/HtWtData30.csv")

# Convert from a tibble to a conventional data frame
height_weight_30 <- data.frame(height_weight_30)

# Save `height_weight_30` as `height_weight_30.rda` in the `data` folder
usethis::use_data(height_weight_30)

