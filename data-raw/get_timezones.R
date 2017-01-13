# Code to find OlsonNames() for a lat/lon

# Abram Fleishman
# Conservation Metrics Inc
# www.conservationmetrics.com
# 10 Jan 2016
# abram AT conservationmetrics.com

# Get Timezone for each point ---------------------------------------------
library(rgdal)
library(maptools)

# Load stations data
stations<-readRDS("D:/tide.station.rda")

# download file from: http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_time_zones.zip
# Read Shape File
b<-readShapePoly("D:/ne_10m_time_zones/ne_10m_time_zones")
Data_sp<-as.data.frame(stations)
Data_sp$Lat<-as.numeric(gsub("+",'',Data_sp$Lat))
Data_sp$Lon<-as.numeric(gsub("+",'',Data_sp$Lon))
head(Data_sp)
# Make spatialpoints dataframe
coordinates(Data_sp)<-cbind(Data_sp$Lon,Data_sp$Lat)

# Use over to do a patial join getting the attributes from the shape file for each point
pts_over_tz <- over(Data_sp, b)

# Add the timezone name to your data
stations$timezone<-as.character(pts_over_tz$tz_name1st)

# Save
saveRDS(stations,"D:/tide.station.rda")
