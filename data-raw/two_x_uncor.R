# Load the packages
library(tidyverse)

# Define population parameters
b0 <- 10
b1 <- 1
b2 <- 2
sd_y <- 2.0

# Total desired sample size
n_desired <- 200

# Simulate the predictor values
set.seed(42)

# Make extra to account for the `filter()` lines
two_x_uncor <- data.frame(x1 = rnorm(n = n_desired * 1.1, mean = 5, sd = 2),
                          x2 = rnorm(n = n_desired * 1.1, mean = 5, sd = 2)) |>
  # Exclude cases with extreme predictor values
  filter(between(x1, 0, 10)) |>
  filter(between(x2, 0, 10)) |>
  # Reduce the data set to the desired sample size
  slice(1:n_desired) |>
  # Simulate the DV
  mutate(y = rnorm(n = n_desired,
                   mean = b0 + b1 * x1 + b2 * x2,
                   sd = sd_y))

# Check the structure
glimpse(two_x_uncor)

# Check univariate statistics
two_x_uncor |>
  pivot_longer(cols = everything(), names_to = "variable") |>
  group_by(variable) |>
  summarise(m = mean(value),
            s = sd(value),
            min = min(value),
            max = max(value)) |>
  mutate(across(.cols = -variable, .fns = \(x) round(x, digits = 2)))

# Check correlation matrix
cor(two_x_uncor) |>
  round(digits = 3)

# Save `two_x_uncor` as `two_x_uncor.rda` in the `data` folder
usethis::use_data(two_x_uncor)

