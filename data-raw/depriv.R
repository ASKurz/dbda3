# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
depriv <- read_csv("data-raw/data.R/ShohatOphirKAMH2012dataReduced.csv") |>
  # Adjust names
  rename(group             = Group,
         id_in_group       = SubjectInGroup,
         non_ethanol_3_day = NonEthanol3DayTotal,
         ethanol_3_day     = Ethanol3DayTotal,
         total             = GrandTotal,
         pref              = PreferenceIndex) |>
  # Convert to factors
  mutate(id_in_group = as.factor(id_in_group),
         group = case_when(
           group == "MatedGrouped"     ~ "mated",
           group == "RejectedIsolated" ~ "rejected") |>
           as.factor()) |>
  # Convert to integers (save memory)
  mutate(across(.cols = non_ethanol_3_day:total, .fns = as.integer)) |>
  # Convert to conventional data frame
  data.frame()

# Inspect the data
str(depriv)

# Save `depriv` as `depriv.rda` in the `data` folder
usethis::use_data(depriv)

