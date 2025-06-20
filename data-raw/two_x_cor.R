# Load the packages
library(tidyverse)

# Define population parameters
b0 <- 10
b1 <- 1
b2 <- 2
sd_y <- 2.0

# Total desired sample size
n_desired <- 200

# Define the matrix of predictor SDs
s_matrix <- matrix(c(2, 0, 0, 2), nrow = 2)

# Define the correlation matrix for the predictors
rho <- -0.9
r_matrix <- matrix(c(1, rho, rho, 1), nrow = 2)

# Define the predictor variance/covariance matrix
sigma_matrix <- s_matrix %*% r_matrix %*% s_matrix

# Simulate the predictor values
set.seed(42)

two_x_cor <- MASS::mvrnorm(
  # Extra to account for the `filter()` lines
  n = n_desired * 1.1,
  mu = c(5, 5),
  Sigma = sigma_matrix,
  empirical = TRUE) |>
  data.frame() |>
  rename_all(.funs = tolower) |>
  # Exclude cases with extreme predictor values
  filter(between(x1, left = 0, right = 10)) |>
  filter(between(x2, left = 0, right = 10)) |>
  # Reduce the data set to the desired sample size
  slice(1:n_desired) |>
  # Simulate the DV
  mutate(y = rnorm(n = n_desired,
                   mean = b0 + b1 * x1 + b2 * x2,
                   sd = sd_y))

# Check the structure
glimpse(two_x_cor)

# Check univariate statistics
two_x_cor |>
  pivot_longer(cols = everything(), names_to = "variable") |>
  group_by(variable) |>
  summarise(m = mean(value),
            s = sd(value),
            min = min(value),
            max = max(value)) |>
  mutate(across(.cols = -variable, .fns = \(x) round(x, digits = 2)))

# Check correlation matrix
cor(two_x_cor) |>
  round(digits = 3)

# Save `two_x_cor` as `two_x_cor.rda` in the `data` folder
usethis::use_data(two_x_cor)

