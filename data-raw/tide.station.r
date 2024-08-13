# Abram Fleishman
# Conservation Metrics Inc
# www.conservationmetrics.com
# 10 Jan 2016
# abram AT conservationmetrics.com

# use rvest to scrape station info from NOAA site
library(stringr)
library(dplyr)
library(rvest)
noaa_tide <- read_html("https://tidesandcurrents.noaa.gov/tide_predictions.html")
a <- noaa_tide %>%
  html_nodes(xpath = "//table//td//a") %>%
  html_attrs()
dataOut <- NULL
# get info for each tide station then subset for subordinate stations only
for (i in seq_along(a)) {
  noaa_tide_temp <- read_html(paste0("https://tidesandcurrents.noaa.gov/tide_predictions.html", a[i]))
  b <- noaa_tide_temp %>%
    html_nodes("table") %>%
    html_table()
  b <- b[[1]][b[[1]]$Predictions != "&nbsp", ]
  head(b)

  bb <- noaa_tide_temp %>%
    html_nodes(xpath = "//table//tr//td/a") %>%
    html_attrs()
  b$path <- (unlist(bb))
  bb <- b[b$Predictions == "Subordinate", ]

  # Loop through the stations to get off sets and ref staton names
  for (j in seq_along(bb$Predictions)) {
    noaa_tide_temp <- read_html(paste0("https://tidesandcurrents.noaa.gov", bb$path[j]))
    aa <- noaa_tide_temp %>%
      html_nodes(xpath = "//div//div//ul//div//div//div//div") %>%
      html_text()
    aaa <- str_extract(aa, "Time Zone: .*D")[1]
    aaa <- gsub(".{1}$", "", aaa)
    bb$timezone[j] <- aaa
    bb$Datum[j] <- str_extract(aa, "Datum: .*")[1]
    bb$units[j] <- str_extract(aa, "Daily Tide Prediction in.*")[1]

    bbb <- noaa_tide_temp %>%
      html_nodes(xpath = "//p") %>%
      html_text()
    result <- bbb[str_detect(bbb, "Referenced.*.")]
    result <- str_trim(result, "both")
    result <- gsub("Referenced to Station\\:", "", result)
    result <- gsub("Time offset in mins \\(", "", result)
    result <- gsub("Height offset in feet \\(", "", result)
    result <- gsub("\\)", "", result)
    result <- gsub("\\(", "", result)
    result <- gsub("\\)\\\n", "", result)
    result <- str_trim(result, "both")
    result <- str_split(result, "  ")
    result <- str_trim(result[[1]], "both")
    bb$ref_station[j] <- result[1]
    bb$time_offset[j] <- result[2]
    bb$height_offset[j] <- result[3]
    print(paste("i:", i, "j:", j))
    bb$Id <- as.character(bb$Id)
    bb$Lat <- as.character(bb$Lat)
    bb$Lon <- as.character(bb$Lon)
  }

  dataOut <- bind_rows(dataOut, bb)
}

head(dataOut)
dataOut <- dataOut[!duplicated(dataOut), ]
dataOut <- select(dataOut, -c(dup))

# split out all the parameters
dataOut$ref_station_id <- str_extract(dataOut$ref_station, "[0-9]{7}")
dataOut$ref_station_name <- gsub("[0-9]{7}", "", dataOut$ref_station)
dataOut$ref_station_name <- str_trim(dataOut$ref_station_name)
dataOut$time_offset_high <- str_extract((dataOut$time_offset), "-?\\d{1,}")
dataOut$time_offset_low <- str_extract((dataOut$time_offset), "-?\\d{1,}$")
dataOut$height_offset_high <- str_extract((dataOut$height_offset), "[\\-\\+\\*\\s.]{1,}\\d{1,}.\\d{1,}")
dataOut$height_offset_low <- str_extract((dataOut$height_offset), "[\\-\\+\\*\\s\\*]{1,}\\d{1,}.\\d{1,}$")

stations <- dataOut

# Save
saveRDS(stations, "D:/tide.station.rda")
