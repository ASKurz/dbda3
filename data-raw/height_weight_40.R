# Load the packages
library(tidyverse)
library(dbda3)

# Generate initial values
height_weight_38 <- height_weight_generator(n = 38, seed = 42)

# Fit a linear model for subsequently constructing outliers
fit1 <- lm(data = height_weight_38, weight ~ height)

# Compare to `sigma(fit1)`
epsilon <- sqrt(mean(fit1$residuals^2))  # 34.39838

# Define a predictor data frame with extreme values
nd <- data.frame(height = range(height_weight_38$height) + c(-2, 2))

# Save the new version of the data
height_weight_40 <- height_weight_38 |>
  # Drop the `male` dummy
  select(-male) |>
  # Add the adjusted fitted values to the data frame
  bind_rows(nd |>
              mutate(weight = predict(fit1, newdata = nd) |>
                       # Adjust the fitted values to make them outliers
                       round(digits = 1) + c(5, - 4) * epsilon))

# Check the results in a plot
height_weight_40 |>
  mutate(outlier = rep(0:1, times = c(38, 2))) |>
  ggplot(aes(x = height, y = weight, color = factor(outlier))) +
  geom_point() +
  scale_color_viridis_d(option = "A", end = 0.6)

# Save `height_weight_40` as `height_weight_40.rda` in the `data` folder
usethis::use_data(height_weight_40)

