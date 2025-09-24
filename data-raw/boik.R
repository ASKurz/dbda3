# Load the packages
library(tidyverse)

# John emailed the `boik.Rdata` file on September 18, 2025
load(file = "data-raw/data_new/boik.Rdata")

# Inspect the data
glimpse(boik)
class(boik)

# Save `boik` as `boik.rda` in the `data` folder
usethis::use_data(boik)

