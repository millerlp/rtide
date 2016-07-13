library(devtools)
library(readr)
library(lubridate)
library(dplyr)
library(tidyr)
library(magrittr)
library(rtide)

rm(list = ls())

# From http://tidesandcurrents.noaa.gov/noaatidepredictions/NOAATidesFacade.jsp?Stationid=9413450

brandywine <- read_tsv("data-raw/8555889.txt", skip = 13)
brandywine %<>% mutate(Station = tide_stations("Brandywine"))

brandywine %<>% select(Station, Date, Time, MLLW = Pred) %>%
  unite(DateTime, Date, Time, sep = " ")

brandywine %<>% mutate(DateTime = ymd_hm(DateTime, tz = "PST8PDT"),
                     MLLW = rtide:::ft2m(MLLW))

use_data(brandywine, overwrite = TRUE)
