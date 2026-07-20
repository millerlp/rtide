# Changelog

## rtide 0.0.12

- patch to conform to new chk package (v0.11.0) expectations

## rtide 0.0.11

CRAN release: 2024-11-20

- patch to remove obsolete time zone references (i.e. ‘PST8PDT’)

## rtide 0.0.10

CRAN release: 2024-08-19

- Only supports R \>= 4.0.
- Housekeeping and minor updates.

## rtide 0.0.9

CRAN release: 2021-05-29

- No longer supports R 3.3.

## rtide 0.0.8

CRAN release: 2020-07-10

- House keeping.

## rtide 0.0.7

CRAN release: 2020-03-18

- Replaced dependency on checkr with chk.
- Replaced dependency on dttr with dttr2.

## rtide 0.0.6

- Replaced lubridate dependency with dttr
- internal rbind of list of data frames no longer includes
  stringsAsFactors as causes error with rbind.sf (instead sets and
  unsets in options)

## rtide 0.0.5

CRAN release: 2018-08-23

- Replaced dependency datacheckr with checkr
- Removed dependencies plyr, magrittr, tidyr, stringr
- tibble now only suggested

## rtide 0.0.4

CRAN release: 2017-05-09

- Removed dependency on dplyr

## rtide 0.0.3

CRAN release: 2016-12-22

- Recognises station names with brackets like ‘Annapolis (US Naval
  Academy), Severn River, Maryland’
- Calculates tide heights when a station name is subset of another
  station name. For example ‘San Francisco, San Francisco Bay,
  California’ and ‘North Point, Pier 41, San Francisco, San Francisco
  Bay, California’ (Issue
  [\#10](https://github.com/millerlp/rtide/issues/10))

## rtide 0.0.2

CRAN release: 2016-09-03

- Released on CRAN

## rtide 0.0.1

- Released on GitHub
