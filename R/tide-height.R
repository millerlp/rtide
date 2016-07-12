#' Tide Stations
#'
#' @param stations A character vector of stations to match - treated as regular expressions.
#' @param harmonics The harmonics object.
#'
#' @return A character vector of the matching stations in the harmonics object.
#' @export
#'
#' @examples
#' tide_stations()
tide_stations <- function(stations = ".*", harmonics = rtide::harmonics) {
  check_vector(stations, value = c(""))

  match <- stringr::str_detect(harmonics$station, stations)
  match %<>% which()
  if (!length(match)) stop("no matching stations", call. = FALSE)
  harmonics$station[sort(unique(match))]
}

#' Tide Date Times
#'
#' Generates sequence of date times.
#'
#' @param minutes An integer of the number of minutes between tide heights
#' @param from A Date of the start of the period of interest
#' @param to A Date of the end of the period of interest
#' @param tz A string of the time zone.
#'
#' @return A POSIXct vector.
#' @export
#'
#' @examples
#' tide_datetimes()
tide_datetimes <- function(minutes = 60L, from = as.Date("2015-01-01"), to = as.Date("2015-12-31"),
                           tz = "PST8PDT") {
  check_scalar(minutes, c(1L, 60L))
  check_date(from)
  check_date(to)
  check_string(tz)

  from <- ISOdatetime(year = lubridate::year(from), month = lubridate::month(from),
                      day = lubridate::day(from), hour = 0, min = 0, sec = 0, tz = tz)
  to <- ISOdatetime(year = lubridate::year(to), month = lubridate::month(to),
                    day = lubridate::day(to), hour = 23, min = 59, sec = 59, tz = tz)

  seq(from, to, by = paste(minutes, "min"))
}

hours_year <- function(datetime) {
  check_vector(datetime, value = Sys.time())
  stopifnot(identical(lubridate::tz(datetime), "UTC"))

  year <- lubridate::year(datetime)

  startdatetime <- ISOdate(year, 1, 1, 0, tz = "UTC")
  hours <- difftime(datetime, startdatetime, units = 'hours')
  hours %<>% as.integer()
  hours
}

station_number <- function(station, harmonics) {
  check_string(station)
  station <- stringr::str_detect(harmonics$station, paste0("^", station, "$")) %>% which() %>%
    as.integer()
  if (!length(station)) stop("no matching stations", call. = FALSE)
  if (length(station) > 1) stop("multiple matching stations", call. = FALSE)
  station
}

tide_height_data_row <- function(data, station, harmonics) {

  harmonics$nodefactor

    # for (i in 1:length(harms$name)) {
  #   pred[j] = pred[j] + ((harms$nodefactor[i,times$yrindx[j]] *
  #                           t(harms$A[stInd,i]) *
  #                           (cos((harms$speed[i] *
  #                                   times$hours[j] +
  #                                   harms$equilarg[i, times$yrindx[j]] -
  #                                   t(harms$kappa[stInd,i])) *
  #                                  pi/180))))
  # }
  #

  print(data)
  # for (i in 1:length(harms$name)) {
  #   pred[j] = pred[j] + ((harms$nodefactor[i,times$yrindx[j]] *
  #                           t(harms$A[stInd,i]) *
  #                           (cos((harms$speed[i] *
  #                                   times$hours[j] +
  #                                   harms$equilarg[i, times$yrindx[j]] -
  #                                   t(harms$kappa[stInd,i])) *
  #                                  pi/180))))
  # }
  data
}

tide_height_data_station <- function(data, harmonics) {

  station <- station_number(data$Station[1], harmonics)

  data %<>% dplyr::mutate_(YearIndex = ~Year - harmonics$startyear + 1,
                           TideHeight = ~harmonics$datum[station])

  data %<>% plyr::adply(.margins = 1, .fun = tide_height_data_row,
                        station = station, harmonics = harmonics)
  data
}


#' Tide Height Data
#'
#' Calculates tide height at specified stations at particular date times based on the supplied harmonics object.
#'
#' @param data A data frame with the columns Station and DateTime.
#' @inheritParams tide_stations
#'
#' @return A tibble of the tide heights in m.
#' @export
tide_height_data <- function(data, harmonics = rtide::harmonics) {
  data %<>% check_data2(values = list(Station = "", DateTime = Sys.time()))

  stations <- unique(data$Station)
  stations <- stations[!stations %in% tide_stations(stations, harmonics)]
  if (length(stations)) stop("unrecognised stations", call. = FALSE)

  tz <- lubridate::tz(data$DateTime)
  data %<>% dplyr::mutate_(DateTime = ~lubridate::with_tz(DateTime, tzone = "UTC"),
                           Year = ~lubridate::year(DateTime),
                           Hours = ~hours_year(DateTime))

  data %<>% plyr::ddply(c("Station"), tide_height_data_station, harmonics = harmonics)

  data %<>% dplyr::mutate_(DateTime = ~lubridate::with_tz(DateTime, tzone = tz))
  data %<>% dplyr::select_(~Station, ~DateTime, ~TideHeight) %>%
    dplyr::arrange_(~Station, ~DateTime)
  data
}

#' Tide Height
#'
#' Calculates tide height at specified stations based on the supplied harmonics object.
#'
#' @inheritParams tide_stations
#' @inheritParams tide_datetimes
#'
#' @return A tibble of the tide heights in m by the number of minutes for each station from from to to.
#' @export
#'
#' @examples
#' tide_height()
tide_height <- function(
  stations = "Monterey Harbor", minutes = 60L,
  from = as.Date("2015-01-01"), to = as.Date("2015-12-31"), tz = "PST8PDT",
  harmonics = rtide::harmonics) {

  stations %<>% tide_stations(harmonics)
  datetimes <- tide_datetimes(minutes = minutes, from = from, to = to, tz = tz)

  data <- tidyr::crossing(Station = stations, DateTime = datetimes)
  tide_height_data(data, harmonics = harmonics)
}
