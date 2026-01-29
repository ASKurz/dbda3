# Load the packages
library(tidyverse)

# Load and rename the `Boik` data from the {phia} package
boik <- phia::Boik

# Rename factor levels
boik <- boik |>
  mutate(
    therapy = case_match(
      therapy,
      "control" ~ "control",
      "T1"      ~ "b",
      "T2"      ~ "a") |>
      factor(levels = c("control", "a", "b")),
    medication = case_match(
      medication,
      "placebo" ~ "placebo",
      "D1"      ~ "low",
      "D2"      ~ "medium",
      "D3"      ~ "high") |>
      factor(levels = c("placebo", "low", "medium", "high")))

# Within each cell, enlarge the SD (keeping means the same), the goals being to
# make the data a little more realistic and to show shrinkage in the
# hierarchical model.
sd_increase <- 2.5

boik <- boik |>
  group_by(therapy, medication) |>
  mutate(cell_mean = mean(edr),
         cell_resid = edr - cell_mean,
         edr = cell_mean + sd_increase * cell_resid) |>
  ungroup() |>
  select(-cell_mean, -cell_resid) |>
  # Add constant to `edr` so its minimum value is 10 (arbitrary positive value)
  mutate(edr = edr - min(edr) + 10.0) |>
  # Convert to conventional data frame
  data.frame()

# Summarize
boik |>
  group_by(therapy, medication) |>
  summarize(m = mean(edr),
            s = sd(edr),
            min = min(edr))

# Inspect the data
str(boik)

# Save `boik` as `boik.rda` in the `data` folder
usethis::use_data(boik)

