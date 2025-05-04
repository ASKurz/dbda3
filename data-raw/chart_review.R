# Load the packages
library(tidyverse)

# Define the column names
name_vec <- c("obsno", "age", "sex", "alkphos", "lab", "cammol", "phosmmol", "age_group")

# Extract the data from online
chart_review <- read_table(
  # The url was working for direct download on March 16, 2025
  file = url("https://jse.amstat.org/datasets/calcium.dat.txt"),
  col_names = name_vec) |>
  # Save three variables as factors
  mutate(sex = factor(sex, levels = 1:2, labels = c("male", "female")),
         lab = factor(lab, levels = 1:6, labels = c("Metpath", "Deyor", "St. Elizabeth's", "CB Rouche", "YOH", "Horizon")),
         age_group = factor(age_group, levels = 1:5, labels = c("65-69", "70-74", "75-79", "80-84", "85-89")))

# Check the missingness pattern
mice::md.pattern(chart_review)

# Review the structure of the data
glimpse(chart_review)

# Recreate Figure 1 in Holcomb & Spalsbury (2005)
chart_review |>
  ggplot(aes(y = phosmmol)) +
  geom_boxplot() +
  scale_x_continuous("phosmmol", breaks = NULL, expand = expansion(mult = 1)) +
  scale_y_continuous(NULL, breaks = -1:5 * 2, limits = c(-2, 10))

# Save `chart_review` as `chart_review.rda` in the `data` folder
usethis::use_data(chart_review)

