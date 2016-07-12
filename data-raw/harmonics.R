library(devtools)
library(rtide)

rm(list = ls())

# From https://github.com/millerlp/Misc_R_scripts
load("data-raw/Harmonics_20120302.Rdata")

harmonics <- rtide:::tide_harmonics(harms)

use_data(harmonics, overwrite = TRUE)
