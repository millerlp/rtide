library(devtools)
library(readr)
library(dplyr)
library(tidyr)
library(rtide)

rm(list = ls())

# From https://tidesandcurrents.noaa.gov/noaatidepredictions.html?id=8555889&units=metric&bdate=20160713&edate=20160715&timezone=LST/LDT&clock=24hour&datum=MLLW&interval=hilo&action=dailychart

brandywine <- read_tsv("data-raw/8555889.txt", skip = 13)
brandywine <- mutate(brandywine, Station = tide_stations("Brandywine"))

brandywine <- select(brandywine, Station, Date, Time, NOAATideHeight = Pred)
brandywine <- unite(brandywine, DateTime, Date, Time, sep = " ")

brandywine <- mutate(brandywine,
  DateTime = dtt_date_time(DateTime, tz = "America/New_York"),
  NOAATideHeight= rtide:::ft2m(NOAATideHeight)
)

use_data(brandywine, overwrite = TRUE)
