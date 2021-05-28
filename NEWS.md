# rtide 0.0.9

- No longer supports R 3.3.

# rtide 0.0.8

- House keeping.

# rtide 0.0.7

- Replaced dependency on checkr with chk.
- Replaced dependency on dttr with dttr2.

# rtide 0.0.6

- Replaced lubridate dependency with dttr
- internal rbind of list of data frames no longer includes stringsAsFactors as causes error with rbind.sf (instead sets and unsets in options)

# rtide 0.0.5

- Replaced dependency datacheckr with checkr
- Removed dependencies plyr, magrittr, tidyr, stringr
- tibble now only suggested

# rtide 0.0.4

- Removed dependency on dplyr

# rtide 0.0.3

- Recognises station names with brackets like 'Annapolis (US Naval Academy), Severn River, Maryland'
- Calculates tide heights when a station name is subset of another station name.
For example 'San Francisco, San Francisco Bay, California' and 'North Point, Pier 41, San Francisco, San Francisco Bay, California' (Issue #10)

# rtide 0.0.2

- Released on CRAN

# rtide 0.0.1

- Released on GitHub
