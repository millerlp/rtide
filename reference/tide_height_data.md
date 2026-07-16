# Tide Height Data

Calculates tide height at specified stations at particular date times
based on the supplied harmonics object.

## Usage

``` r
tide_height_data(data, harmonics = rtide::harmonics)
```

## Arguments

- data:

  A data frame with the columns Station and DateTime.

- harmonics:

  The harmonics object.

## Value

A data frame of the tide heights in m.
