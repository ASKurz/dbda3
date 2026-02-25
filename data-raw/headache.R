# Load the packages
library(tidyverse)
library(dbda3)

# Cases per dosage level
n_per_dosage <- 50

# Simulate the data
set.seed(47)
headache <- crossing(
  dosage = seq(from = 0, to = 300, by = 50),
  subj_in_dose = 1:n_per_dosage) |>
  mutate(headache_prob = logistic((dosage - 225) / 125) ,
         headache = as.integer(runif(n = n(), min = 0, max = 1) < headache_prob)) |>
  select(dosage, headache)

# Check the structure
str(headache)

# Check the data in a plot
headache |>
  ggplot(aes(x = dosage, y = headache)) +
  geom_point(size = 0.1,
             position = position_jitter(seed = 42, height = 0.04, width = 7)) +
  stat_summary(fun = mean, shape = 18, size =1)

# Save `headache` as `headache.rda` in the `data` folder
usethis::use_data(headache)

