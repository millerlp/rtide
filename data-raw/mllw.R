library(devtools)
library(readr)
library(lubridate)
library(dplyr)
library(tidyr)
library(magrittr)
library(rtide)

rm(list = ls())

# From http://tidesandcurrents.noaa.gov/noaatidepredictions/NOAATidesFacade.jsp?Stationid=9413450

monterey <- read_tsv("data-raw/9413450.txt", skip = 13)
monterey %<>% mutate(Station = tide_stations("Monterey,"))

brandywine <- read_tsv("data-raw/8555889.txt", skip = 13)
brandywine %<>% mutate(Station = tide_stations("Brandywine"))

mllw <- bind_rows(monterey, brandywine)

mllw %<>% select(Station, Date, Time, MLLW = Pred) %>%
  unite(DateTime, Date, Time, sep = " ")

mllw %<>% mutate(DateTime = ymd_hm(DateTime, tz = "PST8PDT"),
                     MLLW = rtide:::ft2m(MLLW))

use_data(mllw, overwrite = TRUE)
