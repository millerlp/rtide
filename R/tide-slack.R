tide_slack_datetime <- function(d, h, high = TRUE, forward = TRUE) {
  hours <- lubridate::minutes(cumsum(c(0,rep(15,25)))) * if (forward) 1 else -1
  height <- vapply(d + hours, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d <- d + hours[which]

  minutes <- lubridate::minutes(c(cumsum(rep(-1,15)), 0, cumsum(rep(1,15))))
  height <- vapply(d + minutes, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d <- d + minutes[which]

  seconds <- lubridate::seconds(c(cumsum(rep(-3,10)), 0, cumsum(rep(3,10))))
  height <- vapply(d + seconds, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d <- d + seconds[which]

  seconds <- lubridate::seconds(c(cumsum(rep(-1,3)), 0, cumsum(rep(1,3))))
  height <- vapply(d + seconds, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d <- d + seconds[which]

  d
}

tide_slack_data_datetime <- function(d, h) {
  datetimes <- list(
    tide_slack_datetime(d$DateTime, h, TRUE, TRUE),
    tide_slack_datetime(d$DateTime, h, TRUE, FALSE),
    tide_slack_datetime(d$DateTime, h, FALSE, TRUE),
    tide_slack_datetime(d$DateTime, h, FALSE, FALSE))

  seconds <- vapply(datetimes, datetime2seconds, 1)
  which <- which.min(abs(seconds - datetime2seconds(d$DateTime)))

  d$SlackDateTime <- datetimes[[which]]
  d$SlackTideHeight <- tide_height_datetime(d$SlackDateTime, h = h)
  d$SlackType <- if(which %in% 1:2) "high" else "low"
  d
}

tide_slack_data_station <- function(data, harmonics) {
  harmonics <- subset(harmonics, paste0("^", data$Station[1], "$"))
  data <- split(data, 1:nrow(data))
  data <- lapply(data, FUN = tide_slack_data_datetime, h = harmonics)
  data$stringsAsFactors <- FALSE
  data <- do.call("rbind", data)
  if (harmonics$Station$Units %in% c("feet", "ft"))
    data$SlackTideHeight <- ft2m(data$SlackTideHeight)
  data
}

#' Tide Slack Data
#'
#' Determines the closest slack tide for specified stations at particular date times based on the supplied harmonics object.
#'
#' @param data A data frame with the columns Station and DateTime.
#' @inheritParams tide_stations
#' @return A data frame of the slack tide date times and heights in m.
#' @export
tide_slack_data <- function (data, harmonics = rtide::harmonics) {
  check_data(data, values = list(Station = "", DateTime = Sys.time()),
                       nrow = c(1L, .Machine$integer.max))

  if (!all(data$Station %in% tide_stations(harmonics = harmonics)))
    stop("unrecognised stations", call. = FALSE)

  if (has_name(data, "SlackTideHeight"))
    stop("data already has 'SlackTideHeight' column", call. = FALSE)

  if (has_name(data, "SlackDateTime"))
    stop("data already has 'SlackDateTime' column", call. = FALSE)

  if (has_name(data, "SlackType"))
    stop("data already has 'SlackType' column", call. = FALSE)

  tz <- lubridate::tz(data$DateTime)
  data$DateTime <- lubridate::with_tz(data$DateTime, tzone = "UTC")

  years <- range(lubridate::year(data$DateTime), na.rm = TRUE)
  if (!all(years %in% years_tide_harmonics(harmonics)))
    stop("years are outside harmonics range", call. = FALSE)

  data <- split(data, data$Station)
  data <- lapply(data, FUN = tide_slack_data_station, harmonics = harmonics)
  data$stringsAsFactors <- FALSE
  data <- do.call("rbind", data)

  data$DateTime <- lubridate::with_tz(data$DateTime, tzone = tz)
  data$SlackDateTime <- lubridate::with_tz(data$SlackDateTime, tzone = tz)
  data <- data[order(data$Station, data$DateTime),]
  as_conditional_tibble(data)
}
