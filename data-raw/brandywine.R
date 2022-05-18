library(devtools)
library(readr)
library(dplyr)
library(tidyr)
library(rtide)

rm(list = ls())

# From https://tidesandcurrents.noaa.gov/noaatidepredictions/NOAATidesFacade.jsp?Stationid=9413450

brandywine <- read_tsv("data-raw/8555889.txt", skip = 13)
brandywine <- mutate(brandywine, Station = tide_stations("Brandywine"))

brandywine <- select(brandywine, Station, Date, Time, MLLW = Pred)
brandywine <- unite(brandywine, DateTime, Date, Time, sep = " ")

brandywine <- mutate(brandywine,
  DateTime = dtt_date_time(DateTime, tz = "EST5EDT"),
  MLLW = rtide:::ft2m(MLLW)
)

use_data(brandywine, overwrite = TRUE)
