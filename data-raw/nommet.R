# Load the packages
library(tidyverse)
library(dbda3)


n_pts <- 500
x1shift <- 5
x2shift <- 10

set.seed(42)

x_pts <- data.frame(x1 = rnorm(n_pts, mean = 0, sd = 2) + x1shift) |>
  mutate(x2 = 0.5 * (x1 - x1shift) + rnorm(n_pts, mean = 0, sd = 1.5) + x2shift)

nommet_coef <- data.frame(
  x1 = c(0, 5, 0, -5),
  x2 = c(0, 0, 5, -5)) |>
  mutate(Intercept = c(0, -4, -4, -10) + -x1 * x1shift + -x2 * x2shift,
         .before = 1)

lambda_pts <- as.matrix(
  cbind(rep(1, nrow(x_pts)), x_pts)) %*%
  t(as.matrix(nommet_coef))

prob_pts <- apply(lambda_pts, MARGIN = 1, FUN = softmax) |> t()

y <- apply(prob_pts,
           MARGIN = 1,
           FUN = \(v) sample(c(1, 2, 3, 4), size = 1, prob = v))

nommet <- x_pts |>
  mutate(y = factor(y))

# Check the structure
str(nommet)

# Check the results
nommet |>
  ggplot(aes(x = x1, y = x2, label = y, color = y)) +
  geom_text() +
  geom_abline(data = nommet_coef |>
                slice(-1) |>
                # To avoid dividing by zero
                mutate(x2 = ifelse(x2 == 0, 0.0001, x2)),
              aes(intercept = -Intercept / x2,
                  slope = -x1 / x2))

# Save `nommet` as `nommet.rda` in the `data` folder
usethis::use_data(nommet)

