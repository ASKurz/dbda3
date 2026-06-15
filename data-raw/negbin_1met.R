# Load the packages
library(tidyverse)

# Beta coefficients
b0 <- 2.0
b1 <- 0.5

# Simulate
set.seed(42)

negbin_1met <- data.frame(x = runif(n = 1000, min = -1, max = 3)) |>
  mutate(y_m = exp(b0 + b1 * x))

set.seed(47)
negbin_1met <- negbin_1met |>
  mutate(y = rnbinom(n = n(), size = 5, mu = y_m) |>
           as.integer()) |>
  select(x, y, y_m)

# Inspect the data
str(negbin_1met)

# Save `negbin_1met` as `negbin_1met.rda` in the `data` folder
usethis::use_data(negbin_1met)

