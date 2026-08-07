# Filename: tide_harmonics_parse.R
#
# Author: Luke Miller  May 1, 2012
# Updated 2026-08-04 to use new harmonics input file from 2025-12-28
# Updated 2025-02-04 to use new harmonics input file from 2024-12-29
# Updated 2015-06-03 to use new harmonics input file from 2014-12-24
###############################################################################
# This is essentially a one-time use script to call the read_harmonicsfile.R
# functions and parse the tidal harmonics file from XTide. The resulting data
# for the ~637 (now ~1286 circa 2025) reference stations can be stored in a Rdata file for quick
# loading and use in tide predictions.
# The harmonics file must be a text format, not the binary
# tcd format that is generally distributed with XTide. To generate this text
# version of the harmonics.tcd file, you must use the command line tool
# 'restore_tide_db' found in the tcd-utils package distributed on the XTide
# site. This will require a Linux or Mac (not Windows) machine.
# See http://www.flaterco.com/xtide/files.html for downloads.

# Load the functions from read_harmonicsfile.R
source('./read_harmonicsfile.R')

# Start this process by dealing with accented characters in
# the text file. We'll convert some of them to their base
# characters without the accent mark, and others will end up
# getting processed into NAs.

# Read the original UTF-8 file
txt <- readLines("./harmonics-20251228.txt", encoding = "UTF-8")

# Remove accents, e.g. é -> e, ñ -> n, ü -> u
txt2 <- iconv(txt, from = "UTF-8", to = "ASCII//TRANSLIT")

# Convert from ASCII to Latin-1
txt <- iconv(txt, from = "ASCII", to = "latin1")

# Write the file explicitly using Latin-1 encoding
con <- file("./harmonics-20251228_cleaned.txt", open = "w", encoding = "latin1")
writeLines(txt, con)
close(con)

# Some of the station names with problematic UTF-8 characters will
# end up with a station name entry of 'NA', so we'll lose them
# in future steps.

# Create a connection to the harmonics text file for reading.
# fid = file('./harmonics-20141224.txt', open = 'rt') # old version
fid = file('./harmonics-20251228_cleaned.txt', open = 'rt') # newer version


# Call the read_harmonicsfile function (found in read_harmonicsfile.R) to parse
# the harmonics file into a usable format.
harms = read_harmonicsfile(fid) # this can take a minute or more

# Close file connection when finished.
close(fid)

##############
# Now remove the current speed stations from the data set to avoid potential
# ambiguities in finding tide stations by name. This should leave only
# the tide Reference stations. (Subordinate stations are not included in the
# tide harmonics tcd database) We also filter out any stations
# that ended up with "NA" as a station name
harms2 = list(name = harms$name, speed = harms$speed,
		startyear = harms$startyear,
		equilarg = harms$equilarg,
		nodefactor = harms$nodefactor,
		station = NULL,
		stationIDnumber = NULL,
		units = NULL,
		longitude = NULL,
		latitude = NULL,
		timezone = NULL,
		tzfile = NULL,
		datum = NULL,
		A = NULL,
		kappa = NULL)



for (i in 1:length(harms$units)) {
	# if (harms$units[i] == 'feet') {
	if (harms$units[i] == 'feet' & harms$station[i] != 'NA') {
		harms2$station = c(harms2$station, harms$station[i])
		harms2$stationIDnumber = c(harms2$stationIDnumber,
				harms$stationIDnumber[i])
		harms2$units = c(harms2$units, harms$units[i])
		harms2$longitude = c(harms2$longitude, harms$longitude[i])
		harms2$latitude = c(harms2$latitude, harms$latitude[i])
		harms2$timezone = c(harms2$timezone, harms$timezone[i])
		harms2$tzfile = c(harms2$tzfile, harms$tzfile[i])
		harms2$datum = c(harms2$datum, harms$datum[i])
		harms2$A = rbind(harms2$A, harms$A[i, ])
		harms2$kappa = rbind(harms2$kappa, harms$kappa[i, ])
	}
}

# Replace harms with harms2 contents
harms = harms2

# Save the results to a Rdata file, since there's no need to re-parse the
# harmonics file once you've done it once.
save(harms, file = 'Harmonics_20251228.Rdata')

# Afterwards, to make a final harmonics file formatted for use
# with rtide, you'll need to run the 'harmonics.R' script.

