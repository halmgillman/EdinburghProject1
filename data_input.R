# Libraries
library(readr)
library(tidyverse)
library(forstringr)

# Loading data
df <- read_csv("https://city-of-edinburgh-council-open-spatial-data-cityofedinburgh.hub.arcgis.com/datasets/cityofedinburgh::public-cctv-locations.csv?where=1=1&outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D") # nolint: line_length_linter.

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
