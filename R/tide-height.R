ft2m <- function(x) {
  x * 0.3048
}

#' Tide Stations
#'
#' Gets vector of matching stations.
#'
#' @param stations A character vector of stations to match - treated as regular expressions.
#' @param harmonics The harmonics object.
#' @export
tide_stations <- function(stations = ".*", harmonics = rtide::harmonics) {
  check_vector(stations, "")
  check_tide_harmonics(harmonics)
  if (!is.tide_harmonics(harmonics))
    stop("harmonics must be an object of class 'tide_harmonics'", call. = FALSE)

  stations <- gsub("[(]", "[(]", stations)
  stations <- gsub("[)]", "[)]", stations)
  stations <- paste0("(", paste(stations, collapse = ")|("), ")")
  match <- grepl(stations, harmonics$Station$Station)
  match <- which(match)
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

  if (class(minutes) == "numeric"){
    check_vector(minutes, c(1,60), length = 1)
    if (minutes %% 1 != 0)	# If modulo isn't 0, decimal value is present
      warning("Truncating minutes interval to whole number", call.=FALSE)
    minutes <- as.integer(minutes)
  }
  check_vector(minutes, c(1L, 60L), length = 1)

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
  check_vector(datetime, Sys.time())
  stopifnot(identical(lubridate::tz(datetime), "UTC"))

  year <- lubridate::year(datetime)

  startdatetime <- ISOdate(year, 1, 1, 0, tz = "UTC")
  hours <- difftime(datetime, startdatetime, units = 'hours')
  hours <- as.numeric(hours)
  hours
}

tide_height_datetime <- function(d, h) {
  h$NodeYear <- h$NodeYear[,as.character(lubridate::year(d)),,drop = FALSE]

  height <- h$Station$Datum + sum(h$NodeYear[,,"NodeFactor"] * h$StationNode[,,"A"] *
                                    cos((h$Node$Speed * (hours_year(d) - h$Station$Hours) +
                                           h$NodeYear[,,"EquilArg"] - h$StationNode[,,"Kappa"]) * pi/180))

  height
}

tide_height_data_datetime <- function(d, h) {
  d$TideHeight <- tide_height_datetime(d$DateTime, h)
  d
}

tide_height_data_station <- function(data, harmonics) {
  harmonics <- subset(harmonics, paste0("^", data$Station[1], "$"))
  data <- split(data, 1:nrow(data))
  data <- lapply(data, FUN = tide_height_data_datetime, h = harmonics)
  data$stringsAsFactors <- FALSE
  data <- do.call("rbind", data)
  if (harmonics$Station$Units %in% c("feet", "ft"))
    data$TideHeight <- ft2m(data$TideHeight)
  data
}


#' Tide Height Data
#'
#' Calculates tide height at specified stations at particular date times based on the supplied harmonics object.
#'
#' @param data A data frame with the columns Station and DateTime.
#' @inheritParams tide_stations
#' @return A data frame of the tide heights in m.
#' @export
tide_height_data <- function(data, harmonics = rtide::harmonics) {
  check_data(data, values = list(Station = "", DateTime = Sys.time()),
             nrow = c(1L, .Machine$integer.max))

  if (!all(data$Station %in% tide_stations(harmonics = harmonics)))
    stop("unrecognised stations", call. = FALSE)

  if (has_name(data, "TideHeight"))
    stop("data already has 'TideHeight' column", call. = FALSE)

  tz <- lubridate::tz(data$DateTime)
  data$DateTime <- lubridate::with_tz(data$DateTime, tzone = "UTC")

  years <- range(lubridate::year(data$DateTime), na.rm = TRUE)
  if (!all(years %in% years_tide_harmonics(harmonics)))
    stop("years are outside harmonics range", call. = FALSE)

  station <- data$Station
  data <- split(data, station)
  data <- lapply(data, FUN = tide_height_data_station, harmonics = harmonics)
  data$stringsAsFactors <- FALSE
  data <- do.call("rbind", data)

  data$DateTime <- lubridate::with_tz(data$DateTime, tzone = tz)
  data <- data[order(data$Station, data$DateTime),]
  as_conditional_tibble(data)
}

#' Tide Height
#'
#' Calculates tide height at specified stations based on the supplied harmonics object.
#'
#' @inheritParams tide_stations
#' @inheritParams tide_datetimes
#' @return A data frame of the tide heights in m by the number of minutes for each station from from to to.
#' @export
tide_height <- function(
  stations = "Monterey Harbor", minutes = 60L,
  from = as.Date("2015-01-01"), to = as.Date("2015-01-01"), tz = "UTC",
  harmonics = rtide::harmonics) {
  stations <- tide_stations(stations, harmonics)
  datetimes <- tide_datetimes(minutes = minutes, from = from, to = to, tz = tz)

  data <- expand.grid(Station = stations, DateTime = datetimes, stringsAsFactors = FALSE)
  tide_height_data(data, harmonics = harmonics)
}
