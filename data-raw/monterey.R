library(devtools)
library(readr)
library(dplyr)
library(tidyr)
library(rtide)

rm(list = ls())

# From https://tidesandcurrents.noaa.gov/noaatidepredictions/NOAATidesFacade.jsp?Stationid=9413450

monterey <- read_tsv("data-raw/9413450.txt", skip = 13)
monterey <- mutate(monterey, Station = tide_stations("Monterey,"))

monterey <- select(monterey, Station, Date, Time, MLLW = Pred)
monterey <- unite(monterey, DateTime, Date, Time, sep = " ")

monterey <- mutate(monterey,
  DateTime = dtt_date_time(DateTime, tz = "PST8PDT"),
  MLLW = rtide:::ft2m(MLLW)
)

use_data(monterey, overwrite = TRUE)
