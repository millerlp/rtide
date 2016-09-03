
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/poissonconsulting/rtide.svg?branch=master)](https://travis-ci.org/poissonconsulting/rtide) [![codecov](https://codecov.io/gh/poissonconsulting/rtide/branch/master/graph/badge.svg)](https://codecov.io/gh/poissonconsulting/rtide) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rtide)](https://cran.r-project.org/package=rtide) [![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/rtide)](https://hadley.shinyapps.io/cran-downloads)

rtide
=====

Introduction
------------

`rtide` is an R package to calculate tide heights based on tide station harmonics.

It includes the harmonics data for 637 US stations. The harmonics data was converted from harmonics-dwf-20151227-free, NOAA web site data processed by David Flater for XTide. The code to calculate tide heights from the harmonics is based on [XTide](http://www.flaterco.com/xtide/).

Utilisation
-----------

``` r
library(rtide)
#> rtide is not suitable for navigation

data <- rtide::tide_height(
  "Monterey Harbor", from = as.Date("2015-01-01"), to = as.Date("2015-01-01"), 
  minutes = 10L, tz = "PST8PDT")

print(data)
#> # A tibble: 144 × 3
#>                                  Station            DateTime TideHeight
#>                                    <chr>              <dttm>      <dbl>
#> 1  Monterey, Monterey Harbor, California 2015-01-01 00:00:00  0.6452338
#> 2  Monterey, Monterey Harbor, California 2015-01-01 00:10:00  0.6353040
#> 3  Monterey, Monterey Harbor, California 2015-01-01 00:20:00  0.6281772
#> 4  Monterey, Monterey Harbor, California 2015-01-01 00:30:00  0.6240083
#> 5  Monterey, Monterey Harbor, California 2015-01-01 00:40:00  0.6229294
#> 6  Monterey, Monterey Harbor, California 2015-01-01 00:50:00  0.6250485
#> 7  Monterey, Monterey Harbor, California 2015-01-01 01:00:00  0.6304487
#> 8  Monterey, Monterey Harbor, California 2015-01-01 01:10:00  0.6391874
#> 9  Monterey, Monterey Harbor, California 2015-01-01 01:20:00  0.6512954
#> 10 Monterey, Monterey Harbor, California 2015-01-01 01:30:00  0.6667771
#> # ... with 134 more rows
```

``` r
library(ggplot2)
library(scales)
```

``` r
ggplot(data = data, aes(x = DateTime, y = TideHeight)) + 
  geom_line() + 
  scale_x_datetime(name = "1st January 2015", 
                   labels = date_format("%H:%M", tz="PST8PDT")) +
  scale_y_continuous(name = "Tide Height (m)") +
  ggtitle("Monterey Harbour")
```

![](README-unnamed-chunk-4-1.png)

Installation
------------

To install the release version from CRAN

    install.packages("rtide")

Or the development version from GitHub

    # install.packages("devtools")
    devtools::install_github("poissonconsulting/rtide")

Contribution
------------

Please [report](https://github.com/poissonconsulting/rtide/issues) any issues.

[Pull requests](https://github.com/poissonconsulting/rtide/pulls) and [suggestions](https://github.com/poissonconsulting/rtide/issues) for improvements are always welcome.

Inspiration
-----------

-   [XTide](http://www.flaterco.com/xtide/)
