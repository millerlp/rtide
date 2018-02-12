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
library(magrittr)

noaa_tide <- read_html("https://tidesandcurrents.noaa.gov/tide_predictions.html")
noaa_tide %>% html_nodes(xpath = "//table//td//a") %>% html_attrs() ->a
dataOut<-NULL
head(a)
#get info for each tide station then subset for subordinate stations only
for(i in 1:length(a)){
  noaa_tide_temp <- read_html(paste0("https://tidesandcurrents.noaa.gov/tide_predictions.html",a[i]))
  noaa_tide_temp %>% html_nodes("table") %>% html_table() ->b
  b<-b[[1]][b[[1]]$Predictions!="&nbsp",]
  head(b)

  noaa_tide_temp %>% html_nodes(xpath="//table//tr//td/a") %>% html_attrs() ->bb
  b$path<-(unlist(bb))
  bb<-b[b$Predictions=="Harmonic",]

  bb$Id<-as.character(bb$Id)
  bb$Lat<-as.character(bb$Lat)
  bb$Lon<-as.character(bb$Lon)

  dataOut<-bind_rows(dataOut,bb)
}

head(dataOut)
dataOut$Name<-gsub("&nbsp",'',dataOut$Name)
dataOut<-dataOut[!duplicated(dataOut),]
harmonic_stations<-dataOut

harmonic_stations$Lat<-as.numeric(gsub("+",'',harmonic_stations$Lat))
harmonic_stations$Lon<-as.numeric(gsub("+",'',harmonic_stations$Lon))

rhar<-rtide::harmonics$Station
rhar_full<-rtide::harmonics$Node
# loop through the rtide::harmonics$Station data and match latitude and longitude to the data from the noaa site.
# I had to round the lat/lon values when matching to 3 decimals because the same site in some cases were off by a little
rhar$Id<-NA
for(i in 1:nrow(rhar)){
  rhar$Id[round(rhar$Longitude,3)==round(harmonic_stations$Lon[i],3)&
          round(rhar$Latitude,3)==round(harmonic_stations$Lat[i],3)]<-harmonic_stations$Id[i]
}

head(rhar)

table(unique(stations$ref_station_id)%in%rhar$Id)
table(is.na(rhar$Id))

stations[stations$ref_station_id=="9751401",]
harmonic_stations[harmonic_stations$Id=="9751401",]

# Save
saveRDS(harmonic_stations,"D:/harmonic_stations.rda")
saveRDS(rhar,"D:/new_harmonic_with_ref_id.rda")
