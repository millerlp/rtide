#' Harmonics
#'
#' A object of class tide_harmonics providing tidal harmonic data for US stations.
#'
#' The tidal harmonic data was originally derived from XTide (http://www.flaterco.com/xtide/)
#' by Luke Miller (https://github.com/millerlp/Misc_R_scripts).
"harmonics"

#' Monterey Tide Height Data
#'
#' High/Low Tide Predictions from \url{http://tidesandcurrents.noaa.gov/tide_predictions.html}.
#'
#' @format A tbl data frame:
#' \describe{
#'   \item{Station}{The station name (chr).}
#'   \item{DateTime}{The date time (time).}
#'   \item{MLLW}{The tide height in m (dbl).}
#' }
"monterey"

#' Brandywine Tide Height Data
#'
#' High/Low Tide Predictions from \url{http://tidesandcurrents.noaa.gov/tide_predictions.html}.
#'
#' @format A tbl data frame:
#' \describe{
#'   \item{Station}{The station name (chr).}
#'   \item{DateTime}{The date time (time).}
#'   \item{MLLW}{The tide height in m (dbl).}
#' }
"brandywine"
