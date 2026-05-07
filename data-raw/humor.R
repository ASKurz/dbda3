# Load the packages
library(tidyverse)
library(dbda3)

# This .csv file came directly from Kruschke. The data are from Kruschke & Vollmer (2014; https://doi.org/10.2139/ssrn.2519218)
humor <- read_csv("data-raw/data_new/HumorMoralityDataSummary-Master.csv", show_col_types = FALSE) |>
  transmute(subj = factor(Subj),
            joke_id = factor(Joke),
            found = factor(JokeFoundat),
            funny = factor(Funniness, levels = sort(unique(Funniness)), ordered = TRUE),
            moral = MFQofJokeFoundat) |>
  mutate(joke = str_c(
    found, str_sub(joke_id, 1, 2), str_sub(joke_id, -2, -1), sep = ".") |>
      factor()) |>
  arrange(subj, joke) |>
  # Standardize a couple variables
  mutate(z_moral = standardize(moral)) |>
  group_by(found) |>
  mutate(z_moral_wf = standardize(moral)) |>
  ungroup() |>
  # Reorder columns
  select(subj, joke_id, found, joke, moral, z_moral, z_moral_wf, funny) |>
  # Save as a conventional data frame
  data.frame()

# Inspect the data
glimpse(humor)

# Save `humor` as `humor.rda` in the `data` folder
usethis::use_data(humor)

humor |>
  distinct(funny) |> str()
humor |>
  distinct(found) |> pull()

humor |>
  distinct(joke)

