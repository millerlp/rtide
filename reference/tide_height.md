# Tide Height

Calculates tide height at specified stations based on the supplied
harmonics object.

## Usage

``` r
tide_height(
  stations = "Monterey Harbor",
  minutes = 60L,
  from = as.Date("2015-01-01"),
  to = as.Date("2015-01-01"),
  tz = "UTC",
  harmonics = rtide::harmonics
)
```

## Arguments

- stations:

  A character vector of stations to match - treated as regular
  expressions.

- minutes:

  An integer of the number of minutes between tide heights

- from:

  A Date of the start of the period of interest

- to:

  A Date of the end of the period of interest

- tz:

  A string of the time zone.

- harmonics:

  The harmonics object.

## Value

A data frame of the tide heights in meters by the number of minutes for
each station from from to to.
