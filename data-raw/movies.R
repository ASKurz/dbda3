# Load the packages
library(tidyverse)

# Data collected from Amazon.com in the Movies and TV category, sorted by relevance, and the first 36 entries with at least 500 reviews
# [full details are on p. 333 of Liddell & Kruschke (2018; https://doi.org/10.1016/j.jesp.2018.08.009)]
# This .csv file came directly from Kruschke
movies <- read_csv("data-raw/data_new/MoviesData.csv", show_col_types = FALSE) |>
  # Adjust names
  rename(title = Descrip, id = ID) |>
  # Consolidate the ratings columns
  pivot_longer(cols = n1:n5,
               names_to = "rating",
               values_to = "count") |>
  # Make `rating` and `id` ordered factors
  mutate(rating = str_remove(string = rating, pattern = "n") |>
           factor(levels = 1:5, ordered = TRUE),
         id = as.character(id) |>
           factor(levels = 1:36),
         # Save as an integer
         count = as.integer(count)) |>
  # Compute proportions of counts within groups
  group_by(id) |>
  mutate(prop = count / sum(count)) |>
  ungroup() |>
  # Save as a conventional data frame
  data.frame()

# Inspect the data
glimpse(movies)

# Save `movies` as `movies.rda` in the `data` folder
usethis::use_data(movies)

