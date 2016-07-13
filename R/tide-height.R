#' Tide Stations
#'
#' Gets vector of matching stations.
#'
#' @param stations A character vector of stations to match - treated as regular expressions.
#' @param harmonics The harmonics object.
#' @export
tide_stations <- function(stations = ".*", harmonics = rtide::harmonics) {
  check_vector(stations, value = c(""))
  check_tide_harmonics(harmonics)
  if (!is.tide_harmonics(harmonics))
    stop("harmonics must be an object of class 'tide_harmonics'", call. = FALSE)

  match <- stringr::str_detect(harmonics$Station$Station, stations)
  match %<>% which()
  if (!length(match)) stop("no matching stations", call. = FALSE)
  harmonics$Station$Station[sort(unique(match))]
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
  hours %<>% as.numeric()
  hours
}

tide_height_data_datetime <- function(d, h) {
  h$NodeYear <- h$NodeYear[,as.character(d$Year),,drop = FALSE]

  height <- h$Station$Datum + sum(h$NodeYear[,,"NodeFactor"] * h$StationNode[,,"A"] *
    cos((h$Node$Speed * (d$Hours - h$Station$Hours) +
           h$NodeYear[,,"EquilArg"] - h$StationNode[,,"Kappa"]) * pi/180))

  d$TideHeight <- height
  d
}

tide_height_data_station <- function(data, harmonics) {
  harmonics %<>% subset(data$Station[1])
  data <- plyr::adply(.data = data, .margins = 1, .fun = tide_height_data_datetime,
                        h = harmonics)
  if (harmonics$Station$Units %in% c("feet", "ft"))
    data %<>% dplyr::mutate_(TideHeight = ~TideHeight * 0.3048)
  data
}


#' Tide Height Data
#'
#' Calculates tide height at specified stations at particular date times based on the supplied harmonics object.
#'
#' @param data A data frame with the columns Station and DateTime.
#' @inheritParams tide_stations
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

  data %<>% plyr::ddply(.variables = c("Station"), tide_height_data_station, harmonics = harmonics)

  data %<>% dplyr::mutate_(DateTime = ~lubridate::with_tz(DateTime, tzone = tz))
  data %<>% dplyr::inner_join(harmonics$Station, by = "Station") %>%
    dplyr::select_(~Station, ~DateTime, ~TideHeight, ~TZ, ~Longitude, ~Latitude) %>%
    dplyr::arrange_(~Station, ~DateTime)
  data %<>% dplyr::as.tbl()
  data
}

#' Tide Height
#'
#' Calculates tide height at specified stations based on the supplied harmonics object.
#'
#' @inheritParams tide_stations
#' @inheritParams tide_datetimes
#' @return A tibble of the tide heights in m by the number of minutes for each station from from to to.
#' @export
tide_height <- function(
  stations = "Monterey Harbor", minutes = 60L,
  from = as.Date("2015-01-01"), to = as.Date("2015-01-01"), tz = "UTC",
  harmonics = rtide::harmonics) {
  stations %<>% tide_stations(harmonics)
  datetimes <- tide_datetimes(minutes = minutes, from = from, to = to, tz = tz)

  data <- tidyr::crossing(Station = stations, DateTime = datetimes)
  tide_height_data(data, harmonics = harmonics)
}
