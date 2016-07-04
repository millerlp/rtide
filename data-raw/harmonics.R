library(devtools)

# From https://github.com/millerlp/Misc_R_scripts
# This requires a previously-produced file of harmonics for the sites, stored as
# a Rdata file. The current file is Harmonics-20120302.Rdata. The harmonics file
# was originally derived from XTide, found at http://www.flaterco.com/xtide/
# The available reference tide stations are listed here:
# http://www.flaterco.com/xtide/locations.html

# Note that only stations listed as type 'Ref' on that page can be used
# with this script.
# The script assumes that all input times (and corresponding tide
# time outputs) are in UTC/GMT time zone, not your local time zone. Check the
# output against NOAA's tide predictions at
# http://tidesandcurrents.noaa.gov/tide_predictions.shtml
# This can produce predictions for years between 1700 and 2100, but with
# decreasing accuracy as you move further from 2012 (say beyond 1990 or 2030)
# since the harmonics file is derived from the current tidal epoch, and things
# like sea level have a tendency to change over time.

load("data-raw/harms.Rdata")

harmonics <- harms
rm(harms)

use_data(harmonics, overwrite = TRUE)
