# Load the packages
library(tidyverse)

# Load the data file, as used for DBDA2
hair_eye_color <- read_csv("data-raw/data.R/HairEyeColor.csv")

# Make variable names lower case
hair_eye_color <- hair_eye_color |>
  rename_all(.fun = tolower)

# Adjust the `hair` and `eye` columns to ensure our output matches
# the order presented in in Table 4.1 of DBDA2
hair_eye_color <- hair_eye_color |>
  mutate(hair = if_else(hair == "Brown", "Brunette", hair) |>
           factor(levels = c("Black", "Brunette", "Red", "Blond")),
         eye  = factor(eye, levels = c("Brown", "Blue", "Hazel", "Green")))

# Save `hair_eye_color` as `hair_eye_color.rda` in the `data` folder
usethis::use_data(hair_eye_color)

