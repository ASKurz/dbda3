# Load the packages
library(tidyverse)

# Data were downloaded on May 07, 2025, from https://www.tandfonline.com/doi/figure/10.1080/10691898.2019.1623137?scroll=top&needAccess=true
# They came in a zip file named `ujse_a_1623137_sm3250`
derby <- read_delim(
  "data-raw/data_new/ujse_a_1623137_sm3250/KYDerby17.txt",
  delim = "\t",
  escape_double = FALSE,
  trim_ws = TRUE)

# Convert all column names to lower case
derby <- derby |>
  rename_with(.fn = tolower) |>
  # Save as a conventional data frame
  data.frame()

# Inspect the data
glimpse(derby)

# Save `derby` as `derby.rda` in the `data` folder
usethis::use_data(derby)

