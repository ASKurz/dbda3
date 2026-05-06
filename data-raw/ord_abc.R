# Load the packages
library(tidyverse)

# Specify response levels:
r_levels <- 1:7
r_max <- max(r_levels)
tau <- seq(from = 1.5, to = (r_max - 0.5), length.out = r_max - 1)
tau_inf <- c(-Inf, tau, Inf)

# metric mean, i.e., expected value of ratings if treated as numeric
mm <- function(
    mu,
    sigma,
    tau = seq(from = 1.5, to = (r_max - 0.5), length.out = r_max - 1)
) {

  tau_inf <- c(-Inf, tau, Inf)

  p_r <-
    pnorm(tau_inf[2:length(tau_inf)], mean = mu, sd = sigma) -
    pnorm(tau_inf[1:(length(tau_inf) - 1)], mean = mu, sd = sigma)

  sum(p_r * r_levels)
}

# Check
# tau_inf[2:length(tau_inf)]
# tau_inf[1:(length(tau_inf) - 1)]
#
# tau_inf[2:length(tau_inf)] |> str()
# tau_inf[1:(length(tau_inf) - 1)] |> str()

# Difference between mm and target mm, for optimization discovery of mu values
mm_mu    <- function(mu , sigma, level = 5.0) (mm(mu = mu, sigma = sigma) - level)^2
mm_sigma <- function(sigma, mu, level = 5.0)  (mm(mu = mu, sigma = sigma) - level)^2

# A:
mu_A    <- 5.0
sigma_A <- 1.5
er_A    <- mm(mu = mu_A, sigma = sigma_A)

# B:
mu_B    <- mu_A
sigma_B <- 3.5
er_B    <- mm(mu = mu_B, sigma = sigma_B)

# C
mu_C <- 6.5
er_C <- er_B

sigma_C <- optimize(f = mm_sigma,
                    interval = c(4, 12),
                    mu = mu_C,
                    level = er_C)$minimum |> round(digits = 2)

# The data:

p_r <- function(mu, sigma) {
  pnorm(tau_inf[2:length(tau_inf)],       mean = mu, sd = sigma) -
    pnorm(tau_inf[1:(length(tau_inf) - 1)], mean = mu, sd = sigma)
}

n_per_group <- 500

counts_A <- (p_r(mu = mu_A, sigma = sigma_A) * n_per_group) |> round()
counts_B <- (p_r(mu = mu_B, sigma = sigma_B) * n_per_group) |> round()
counts_C <- (p_r(mu = mu_C, sigma = sigma_C) * n_per_group) |> round()

ord_abc <- data.frame(
  group = rep(LETTERS[1:3], each = r_max),
  rating = rep(1:r_max, times = 3) |>
    factor(ordered = TRUE),
  count = c(counts_A, counts_B, counts_C) |> as.integer())

# Inspect the data
str(ord_abc)

# Save `ord_abc` as `ord_abc.rda` in the `data` folder
usethis::use_data(ord_abc)

