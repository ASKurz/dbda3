# Load the packages
library(tidyverse)

# Simulate the data
set.seed(47)

het_dat <- data.frame(
  group = LETTERS[1:4] |> factor(),
  m = c(100, 102.8, 100, 103.4),
  s = rep(c(1, 8), each = 2)) |>
  mutate(y = map2(.x = m, .y = s, .f = \(m, s) rnorm(n = 25, mean = m, sd = s))) |>
  select(group, y) |>
  unnest(y) |>
  # Make it a conventional data frame
  data.frame()

# Check the structure
glimpse(het_dat)

# Check the sample statistics
het_dat |>
  group_by(group) |>
  summarise(m = mean(y),
            s = sd(y))

# Save `het_dat` as `het_dat.rda` in the `data` folder
usethis::use_data(het_dat)

