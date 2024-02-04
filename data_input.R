# Libraries
library(readr)
library(readxl)
library(httr2)
library(jsonlite)
library(tidyverse)
library(forstringr)

# --- df1 (Public CCTV Cameras) --- #
# Loading data
df <- read_csv("https://city-of-edinburgh-council-open-spatial-data-cityofedinburgh.hub.arcgis.com/datasets/cityofedinburgh::public-cctv-locations.csv?where=1=1&outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D") # nolint: line_length_linter
write_csv(df, "Data/df.csv")

# Data preparation
# Adding PostcodePrefix variable
df <- df %>% mutate(
  PostcodePrefix = str_extract_part(Postcode, " ", before = TRUE)
)

# Adding count of cameras by postcode
postcode_count <- df %>%
  group_by(PostcodePrefix) %>%
  summarise(PostcodeCount = n()) %>%
  arrange(desc(PostcodeCount))

# Adding count of cameras by locality
locality_count <- df %>%
  group_by(Locality) %>%
  summarise(LocalityCount = n()) %>%
  arrange(desc(LocalityCount))

# --- df2 (Crime Rates) --- #
# Loading data
df2 <- read_csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Frecorded-crime") %>%  # nolint: line_length_linter
  filter(FeatureName == "City of Edinburgh")
write_csv(df2, "Data/df2.csv")

# -- df3 (Police confidence) -- #
# Loading data
df3 <- read_csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fconfidence-in-policing-sscq") %>% # nolint: line_length_linter
  filter(FeatureName == "City of Edinburgh")
write_csv(df3, "Data/df3.csv")

# TODO: locate dataset matching data zones to postcodes.
# Potentially here?:
#   https://www.nrscotland.gov.uk/statistics-and-data/geography/our-products/scottish-postcode-directory/2023-2 # nolint: line_length_linter