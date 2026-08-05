library(devtools)
library(rtide)

rm(list = ls())

# After running 'data-raw/tide_harmonics_parse.R' on a new 
# text-format harmonics database file from Xtide. 
load("data-raw/Harmonics_20251228.Rdata")

harmonics <- rtide:::tide_harmonics(harms) # convert to tide_harmonics object

use_data(harmonics, overwrite = TRUE) # create a new harmonics.rda file in /data
