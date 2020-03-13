# Abram Fleishman
# Conservation Metrics Inc
# www.conservationmetrics.com
# 10 Jan 2016
# abram AT conservationmetrics.com

# use rvest to scrape station info from NOAA site
library(stringr)
library(dplyr)
library(rvest)
library(rtide)
noaa_tide <- read_html("https://tidesandcurrents.noaa.gov/tide_predictions.html")
noaa_tide %>%
  html_nodes(xpath = "//table//td//a") %>%
  html_attrs() -> a
dataOut <- NULL
head(a)
# get info for each tide station then subset for subordinate stations only
for (i in 30:length(a)) {
  noaa_tide_temp <- read_html(paste0("https://tidesandcurrents.noaa.gov/tide_predictions.html", a[i]))
  noaa_tide_temp %>%
    html_nodes("table") %>%
    html_table() -> b
  b <- b[[1]][b[[1]]$Predictions != "&nbsp", ]
  head(b)

  noaa_tide_temp %>%
    html_nodes(xpath = "//table//tr//td/a") %>%
    html_attrs() -> bb
  b$path <- (unlist(bb))
  bb <- b[b$Predictions == "Harmonic", ]
  if (nrow(bb) == 0) next
  bb$Id <- as.character(bb$Id)
  bb$Lat <- as.character(bb$Lat)
  bb$Lon <- as.character(bb$Lon)
  bb$harpath <- paste0("/harcon.html?id=", bb$Id)
  # Loop through the stations to get harmonic_constituents
  for (j in 1:length(bb$Predictions)) {
    noaa_tide_temp <- read_html(paste0("https://tidesandcurrents.noaa.gov", bb$harpath[j]))
    noaa_tide_temp %>%
      html_nodes("table.table.table-striped") %>%
      html_table() -> aa
    if (length(aa) == 0) next

    aaa <- data.frame(aa[[1]], bb[j, ])

    aaa <- rename(aaa, Constituent_Num = Constituent.., Constituent_Name = Name, Name = Name.1)
    dataOut <- bind_rows(dataOut, aaa)
  }
}

head(dataOut)
dataOut$Name <- gsub("&nbsp", "", dataOut$Name)
dataOut <- dataOut[!duplicated(dataOut), ]
harmonic_constituents <- dataOut

harmonic_constituents$Lat <- as.numeric(gsub("+", "", harmonic_constituents$Lat))
harmonic_constituents$Lon <- as.numeric(gsub("+", "", harmonic_constituents$Lon))

# Save
saveRDS(harmonic_constituents, "D:/harmonic_constituents.rda")
