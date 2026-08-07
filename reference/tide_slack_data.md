# Tide Slack Data

Determines the closest slack tide for specified stations at particular
date times based on the supplied harmonics object.

## Usage

``` r
tide_slack_data(data, harmonics = rtide::harmonics)
```

## Arguments

- data:

  A data frame with the columns Station and DateTime.

- harmonics:

  The harmonics object.

## Value

A data frame of the slack tide date times and heights in meters.
