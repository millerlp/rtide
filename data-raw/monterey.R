library(devtools)
library(readr)
library(dplyr)
library(tidyr)
library(rtide)

rm(list = ls())

# From https://tidesandcurrents.noaa.gov/noaatidepredictions.html?id=9413450&units=standard&bdate=20160713&edate=20160714&timezone=LST/LDT&clock=24hour&datum=MLLW&interval=hilo&action=dailychart

monterey <- read_tsv("data-raw/9413450.txt", skip = 13)
monterey <- mutate(monterey, Station = tide_stations("Monterey,"))

monterey <- select(monterey, Station, Date, Time, TideHeight = Pred)
monterey <- unite(monterey, DateTime, Date, Time, sep = " ")

monterey <- mutate(monterey,
  DateTime = dtt_date_time(DateTime, tz = "America/Los_Angeles"),
  TideHeight = rtide:::ft2m(TideHeight)
)

use_data(monterey, overwrite = TRUE)
