# Load the packages
library(tidyverse)

# Define population parameters
b0 <- 3
b1 <- 1
b2 <- 2
sigma <- 2

# Define the sample size
n <- 400

# Simulate the data
set.seed(96822)

linear_data <- data.frame(
  x1 = runif(n = n, min = -4, max = 2),
  x2 = runif(n = n, min = -4, max = 2)) %>%
  mutate(y = rnorm(n = n, mean = b0 + b1 * x1 + b2 * x2, sd = sigma))

# Check the structure
glimpse(linear_data)

# Save `linear_data` as `linear_data.rda` in the `data` folder
usethis::use_data(linear_data)

