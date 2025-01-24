# Load the packages
library(tidyverse)

# Data from Table 2 of Horan & Johnson (1971, p. 246)
horan_1971 <- tibble(
  treatment = factor(rep(1:4, times = c(22, 20, 19, 19)),
                     labels = c("delayed", "placebo", "scheduled", "experimental"),
                     ordered = TRUE),
  pre = c(149.5, 131.25, 146.5, 133.25, 131, 141, 145.75, 146.75, 172.5,
          156.5, 153, 136.25, 148.25, 152.25, 167.5, 169.5, 151.5, 165,
          144.25, 167, 195, 179.5, 127, 134, 163.5, 155, 157.25, 121,
          161.25, 147.25, 134.5, 121, 133.5, 128.5, 151, 141.25, 164.25,
          138.25, 176, 178, 183, 164, 149, 134.25, 168, 116.25, 122.75,
          122.5, 130, 139, 121.75, 126, 159, 134.75, 140.5, 174.25, 140.25,
          133, 171.25, 198.25, 141.25, 137, 157, 142.25, 123, 163.75, 168.25,
          146.25, 174.75, 174.5, 179.75, 162.5, 145, 127, 146.75, 137.5,
          179.75, 168.25, 187.5, 144.5),
  post = c(149, 130, 147.75, 139, 134, 145.25, 142.25, 147, 158.25, 155.25,
           151.5, 134.5, 145.75, 153.5, 163.75, 170, 153, 178, 144.75,
           164.25, 194, 183.25, 121.75, 132.25, 166, 146.5, 154.5, 114,
           148.25, 148.25, 133.5, 126.5, 137, 126.5, 148.5, 145.5, 151.5,
           128.5, 176.5, 170.5, 181.5, 160.5, 145.5, 122.75, 164, 118.5,
           122, 125.5, 129.5, 137, 119.5, 123.5, 150.5, 125.75, 135, 164.25,
           144.5, 135.5, 169.5, 194.5, 142.5, 129, 146.5, 142.25, 114.5,
           148.25, 161.25, 142.5, 174.5, 163, 160.5, 151.25, 144, 135.5,
           136.5, 145.5, 185, 174.75, 179, 141.5) ) |>
  # Dichotomize the change score into: did you lose weight (`lose == 1`) or not (`lose == 0`)?
  mutate(lose = ifelse(pre - post > 0, 1, 0))

# Compute the group means for `lose`
horan_1971 |>
  group_by(treatment) |>
  summarise(p_lose = mean(lose))

# Now update the data based on the needs of the examples in the book
weight_loss <- horan_1971 |>
  # Isolate the 4 levels of `treatment`
  distinct(treatment) |>
  # Alter the group sample sizes, and give them slightly different proportion values
  mutate(n = 200,
         p_lose = c(0.50, 0.67, 0.70, 0.73)) |>
  # Compute `z` given `n` and `p_lose`
  mutate(z = round(n * p_lose)) |>
  # Drop the unneeded column and rearrange the others
  select(treatment, z, n)

# Save `weight_loss` as `weight_loss.rda` in the `data` folder
usethis::use_data(weight_loss)

