#' Harmonics
#'
#' A object of class tide_harmonics providing tidal harmonic data for US stations.
#'
#' Converted from harmonics-dwf-20151227-free, NOAA web site data processed by David Flater for XTide.
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
