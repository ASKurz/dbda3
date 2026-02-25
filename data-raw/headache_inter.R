# Load the packages
library(tidyverse)
library(dbda3)

# Total sample size
sample_size <- 250

# Set the seed
set.seed(47405)

# Simulate predictors
age    <- runif(n = sample_size, min = 18, max = 90)
dosage <- runif(n = sample_size, min = 0, max = 250)

# Population parameters
b_0 <- -5
b_ag <- 0 / max(age)
b_do <- 0 / max(dosage)
b_ag_do <- 20 / (max(age) * max(dosage))

# b_0; b_ag; b_do; b_ag_do

# Simulate the data
headache_inter2 <- data.frame(
  age    = age,
  dosage = dosage) |>
  mutate(p = logistic(b_0 + (b_ag * age) + (b_do * dosage) + (b_ag_do * age * dosage))) |>
  mutate(headache = (runif(n = sample_size, min = 0, max = 1) < p) |> as.integer(),
         across(.cols = age:dosage, .fns = round)) |>
  select(-p)

# Check the structure
str(headache_inter)

# Check the data with a `ggpairs()` plot
headache_inter |>
  mutate(headache = factor(headache)) |>
  GGally::ggpairs()

# Save `headache_inter` as `headache_inter.rda` in the `data` folder
usethis::use_data(headache_inter)

