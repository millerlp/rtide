
<!-- README.md is generated from README.Rmd. Please edit that file -->
rtide
=====

`rtide` is an R package to calculate tide heights based on tide station harmonics. It includes the harmonics for US stations.

Disclaimer
----------

`rtide` is not suitable for navigation.

Usage
-----

``` r
library(lubridate)
library(ggplot2)
library(scales)
library(rtide)
```

``` r
data <- rtide::tide_height(
  "Monterey Harbor", from = as.Date("2015-01-01"), to = as.Date("2015-01-01"), 
  minutes = 10L, tz = "PST8PDT")

ggplot(data = data, aes(x = DateTime, y = TideHeight)) + 
  geom_line() + 
  scale_x_datetime(name = "1st January 2015", 
                   labels = date_format("%H:%M", tz="PST8PDT")) +
  scale_y_continuous(name = "Tide Height (m)") +
  ggtitle("Monterey Harbour")
```

![](README-unnamed-chunk-3-1.png)

Installation
------------

To install and load the development version from GitHub

    devtools::install_github("rtide")
    library(rtide)
