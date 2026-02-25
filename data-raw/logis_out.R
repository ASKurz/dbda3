# Load the packages
library(tidyverse)
library(dbda3)

# Population parameters
gn <- 1
th <- 0

# Make data without outliers
set.seed(47)

logis_out <- data.frame(x = seq(from = -10, to = 10, length.out = 101)) |>
  mutate(p = logistic(gn * (x - th)),
         y = (runif(n = n(), min = 0, max = 1) < p) |> as.integer())

# Append outliers
logis_out <- logis_out |>
  rows_append(
    data.frame(x = c(-10, -9, -8, 8, 9, 10),
               y = rep(1:0, each = 3)) |>
      mutate(p = logistic(gn * (x - th)))) |>
  select(x, y)

# Check the structure
str(logis_out)

# Check the data with a `ggpairs()` plot
logis_out |>
  mutate(y = factor(y)) |>
  GGally::ggpairs()

# Save `logis_out` as `logis_out.rda` in the `data` folder
usethis::use_data(logis_out)

