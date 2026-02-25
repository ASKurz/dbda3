# Load the packages
library(tidyverse)
library(dbda3)

# Simulate the data
set.seed(47)
few_ones <- data.frame(x1 = rnorm(100, mean = 0, sd = 3.5)) |>
  mutate(
    x2 = rnorm(n = n(), mean = 0, sd = 3.5),
    y     = as.integer(runif(n = n(), min = 0, max = 1) < logistic(x1)),
    y_few = as.integer(runif(n = n(), min = 0, max = 1) < logistic(x1 - 6.0)))

# Check the structure
str(few_ones)

# Check the data with a `ggpairs()` plot
few_ones |>
  mutate(y = factor(y),
         y_few = factor(y_few)) |>
  GGally::ggpairs()

# Save `few_ones` as `few_ones.rda` in the `data` folder
usethis::use_data(few_ones)
