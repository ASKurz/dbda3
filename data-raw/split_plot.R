# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
split_plot <- read_csv("data-raw/data.R/SplitPlotAgriData.csv")

split_plot <- split_plot |>
  # Adjust names
  rename_all(.funs = tolower) |>
  # Rename levels and save as a factor
  mutate(till = str_replace(string = till, pattern = "oldbrd", replacement = "oldboard"),
         across(.cols = till:fert, .fns = tolower),
         across(.cols = field:fert, .fns = as.factor)) |>
  # Modify so differences are smaller, and decisions change across models
  mutate(yield = ifelse(fert == "broad", yield + 10 - 5, yield),
         yield = ifelse(till == "chisel", yield + 10, yield),
         yield = ifelse(fert == "broad" & till == "ridge", yield + 5, yield),
         yield = ifelse(fert != "broad" & till == "ridge", yield - 5, yield),
         # Convert to integer
         yield = as.integer(yield)) |>
  # Convert to conventional data frame
  data.frame()

# Inspect the data
glimpse(split_plot)

# Save `split_plot` as `split_plot.rda` in the `data` folder
usethis::use_data(split_plot)

