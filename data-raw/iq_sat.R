# Load the packages
library(tidyverse)

# Sample size per group
n <- 50

# MVN distribution parameters
iq_mean <- 100; sat_mean <- 1060
iq_sd <- 15;    sat_sd <- 195
rho <- 0.82
tau <- 5
tau_sd <- 2

sigma_1 <- matrix(c(iq_sd^2, rho * iq_sd * sat_sd,
                    rho * iq_sd * sat_sd, sat_sd^2),
                  nrow = 2)

sigma_2 <- matrix(c((iq_sd + tau_sd)^2, rho * (iq_sd + tau_sd) * sat_sd,
                    rho * (iq_sd + tau_sd) * sat_sd, sat_sd^2),
                  nrow = 2)

# Simulate
set.seed(9)

iq_sat <- rbind(
  MASS::mvrnorm(n = n, mu = c(iq_mean,       sat_mean), Sigma = sigma_1),
  MASS::mvrnorm(n = n, mu = c(iq_mean + tau, sat_mean), Sigma = sigma_2)) |>
  data.frame() |>
  set_names(c("iq", "sat")) |>
  mutate(across(.cols = everything(), .fns = round),
         tx = rep(0:1, each = n)) |>
  mutate(group = ifelse(tx == 0, "Placebo", "Smart Drug") |> factor()) |>
  select(group, tx, iq, sat)

# Check the structure
glimpse(iq_sat)

# Check the sample statistics
iq_sat |>
  group_by(group) |>
  summarize(m = mean(iq),
            s = sd(iq),
            r = cor(iq, sat))

# Save `iq_sat` as `iq_sat.rda` in the `data` folder
usethis::use_data(iq_sat)

