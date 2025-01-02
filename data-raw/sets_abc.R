# Load the packages
library(tidyverse)

# Define the data sets

# Data set A
set_a <- data.frame(s = rep(1:20, each = 10),
                    y = c(rep(1:0, times = c(3, 7)) |> rep(times = 10),
                          rep(0:1, times = c(3, 7)) |> rep(times = 10)))

# Data set B
set_b <- data.frame(s = rep(1:2, each = 100),
                    y = c(rep(1:0, times = c(30, 70)),
                          rep(0:1, times = c(30, 70))))

# Data set C
set_c <- data.frame(z = c(3, 15, 7, 35),
                    n = c(10, 50, 10, 50),
                    n_subject = c(5, 1, 5, 1)) |>
  uncount(weights = n_subject) |>
  mutate(s = row_number()) |>
  mutate(y = map2(.x = z, .y = n, .f = ~rep(1:0, times = c(.x, .y - .x)))) |>
  select(-z, -n) |>
  unnest(y)

# Confirm the counts are as desired
set_a |>
  group_by(s) |>
  summarise(z = sum(y),
            n = n()) |>
  count(z, n, name = "count")

set_b |>
  group_by(s) |>
  summarise(z = sum(y),
            n = n()) |>
  count(z, n, name = "count")

set_c |>
  group_by(s) |>
  summarise(z = sum(y),
            n = n()) |>
  count(z, n, name = "count")

# Save `set_a` as `set_a.rda` in the `data` folder
# Save `set_b` as `set_b.rda` in the `data` folder
# Save `set_c` as `set_c.rda` in the `data` folder
usethis::use_data(set_a)
usethis::use_data(set_b)
usethis::use_data(set_c)

