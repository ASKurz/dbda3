# Load the packages
library(tidyverse)
library(dbda3)

# Simulate the data
set.seed(47)
cor_pred_dichot <- data.frame(x1 = rnorm(n = 100, mean = 0, sd = 3.5)) |>
  mutate(x2 = x1 + rnorm(n = n(), mean = 0, sd = 1.0),
         y = as.integer(runif(n = n(), min = 0, max = 1) < logistic(x1)))

# Check the structure
str(cor_pred_dichot)

# Check the data with a `ggpairs()` plot
cor_pred_dichot |>
  mutate(y = factor(y)) |>
  GGally::ggpairs()

# Save `cor_pred_dichot` as `cor_pred_dichot.rda` in the `data` folder
usethis::use_data(cor_pred_dichot)

