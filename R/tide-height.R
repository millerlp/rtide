get_stations <- function(stations, harmonics) {
  datacheckr::check_vector(stations, value = c(""))

  match <- stringr::str_detect(harmonics$station, stations)
  match %<>% which()
  if (!length(match)) stop("no matching stations", call. = FALSE)
  harmonics$station[sort(unique(match))]
}

#' Tide Height
#'
#' Calculates tide height at specified stations based on the supplied harmonics object.
#'
#' stations is treated as a vector of regular expressions.
#'
#' @param stations A character vector of stations to calculate tide height.
#' @param minutes An integer of the number of minutes between tide heights
#' @param from A Date of the start of the period of interest
#' @param to A Date of the end of the period of interest
#' @param harmonics The harmonics object
#' @param tz A string of the time zone.
#'
#' @return A tibble of the tide heights in m by the number of minutes for each station from from to to.
#' @export
#'
#' @examples
#' tide_height()
tide_height <- function(
  stations = "Monterey Harbor", minutes = 60L,
  from = as.Date("2015-01-01"), to = as.Date("2015-31-12"),
  harmonics = rtide::harmonics,
  tz = "PST8PDT") {

  stations %<>% get_stations(harmonics)
  stations
}
