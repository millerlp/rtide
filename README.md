
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtide

<!-- badges: start -->

[![lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![Travis-CI Build
Status](https://travis-ci.org/poissonconsulting/rtide.svg?branch=master)](https://travis-ci.org/poissonconsulting/rtide)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/poissonconsulting/rtide?branch=master&svg=true)](https://ci.appveyor.com/project/poissonconsulting/rtide)
[![codecov](https://codecov.io/gh/poissonconsulting/rtide/branch/master/graph/badge.svg)](https://codecov.io/gh/poissonconsulting/rtide)
[![License:
GPL3](https://img.shields.io/badge/License-GPL3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![Tinyverse
status](https://tinyverse.netlify.com/badge/rtide)](https://CRAN.R-project.org/package=rtide)
[![CRAN
status](https://www.r-pkg.org/badges/version/rtide)](https://cran.r-project.org/package=rtide)
![CRAN downloads](https://cranlogs.r-pkg.org/badges/rtide)
<!-- badges: end -->

## Introduction

`rtide` is an R package to calculate tide heights based on tide station
harmonics.

It includes the harmonics data for 637 US stations.

## Utilisation

``` r
library(rtide)
#> rtide is not suitable for navigation

data <- rtide::tide_height(
  "Monterey Harbor", from = as.Date("2016-07-13"), to = as.Date("2016-07-15"), 
  minutes = 10L, tz = "PST8PDT")

print(head(data))
#> # A tibble: 6 x 3
#>   Station                               DateTime            TideHeight
#>   <chr>                                 <dttm>                   <dbl>
#> 1 Monterey, Monterey Harbor, California 2016-07-13 00:00:00      0.514
#> 2 Monterey, Monterey Harbor, California 2016-07-13 00:10:00      0.496
#> 3 Monterey, Monterey Harbor, California 2016-07-13 00:20:00      0.481
#> 4 Monterey, Monterey Harbor, California 2016-07-13 00:30:00      0.468
#> 5 Monterey, Monterey Harbor, California 2016-07-13 00:40:00      0.457
#> 6 Monterey, Monterey Harbor, California 2016-07-13 00:50:00      0.449
```

``` r
library(ggplot2)
library(scales)
```

``` r
ggplot(data = data, aes(x = DateTime, y = TideHeight)) + 
  geom_line() + 
  scale_x_datetime(name = "Date", 
                   labels = date_format("%d %b %Y", tz="PST8PDT")) +
  scale_y_continuous(name = "Tide Height (m)") +
  ggtitle("Monterey Harbour")
```

![](man/figures/README-unnamed-chunk-4-1.png)<!-- -->

## Installation

To install the latest release from [CRAN](https://cran.r-project.org)

``` r
install.packages("rtide")
```

To install the developmental version from
[GitHub](https://github.com/poissonconsulting/rtide)

``` r
# install.packages("remotes")
remotes::install_github("poissonconsulting/rtide")
```

To install the latest developmental release from the Poisson drat
[repository](https://github.com/poissonconsulting/drat)

``` r
# install.packages("drat")
drat::addRepo("poissonconsulting")
install.packages("rtide")
```

## Shiny

Tide heights can be also obtained using rtide through a [shiny
interface](https://poissonconsulting.shinyapps.io/rtide/) developed by
Seb Dalgarno.

## Contribution

Please report any
[issues](https://github.com/poissonconsulting/rtide/issues).

[Pull requests](https://github.com/poissonconsulting/rtide/pulls) are
always welcome.

### Code of Conduct

Please note that the rtide project is released with a [Contributor Code
of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct/).
By contributing to this project, you agree to abide by its terms.

## Inspiration

The harmonics data was converted from
<https://github.com/poissonconsulting/rtide/blob/master/data-raw/harmonics-dwf-20151227-free.tar.bz2>,
NOAA web site data processed by David Flater for
[`XTide`](http://www.flaterco.com/xtide/). The code to calculate tide
heights from the harmonics is based on `XTide`.
