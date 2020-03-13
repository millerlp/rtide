tide_slack_datetime <- function(d, h, high = TRUE, forward = TRUE) {
  minutes <- seq(0L, 375L, by = 15L)
  d <- rep(d, length(minutes))
  if (!forward) minutes <- minutes * -1L
  d <- dtt_add_minutes(d, minutes)
  height <- vapply(d, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d <- d[which]

  minutes <- -15:15
  d <- rep(d, length(minutes))
  d <- dtt_add_minutes(d, minutes)
  height <- vapply(d, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d <- d[which]

  seconds <- seq(-30L, 30L, by = 3L)
  d <- rep(d, length(seconds))
  d <- dtt_add_seconds(d, seconds)
  height <- vapply(d, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d <- d[which]

  seconds <- -3:3
  d <- rep(d, length(seconds))
  d <- dtt_add_seconds(d, seconds)
  height <- vapply(d, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d[which]
}

tide_slack_data_datetime <- function(d, h) {
  datetimes <- list(
    tide_slack_datetime(d$DateTime, h, TRUE, TRUE),
    tide_slack_datetime(d$DateTime, h, TRUE, FALSE),
    tide_slack_datetime(d$DateTime, h, FALSE, TRUE),
    tide_slack_datetime(d$DateTime, h, FALSE, FALSE)
  )

  seconds <- vapply(datetimes, datetime2seconds, 1)
  which <- which.min(abs(seconds - datetime2seconds(d$DateTime)))

  d$SlackDateTime <- datetimes[[which]]
  d$SlackTideHeight <- tide_height_datetime(d$SlackDateTime, h = h)
  d$SlackType <- if (which %in% 1:2) "high" else "low"
  d
}

tide_slack_data_station <- function(data, harmonics) {
  harmonics <- subset(harmonics, paste0("^", data$Station[1], "$"))
  data <- split(data, 1:nrow(data))
  data <- lapply(data, FUN = tide_slack_data_datetime, h = harmonics)
  data <- do.call("rbind", data)
  if (harmonics$Station$Units %in% c("feet", "ft")) {
    data$SlackTideHeight <- ft2m(data$SlackTideHeight)
  }
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
tide_slack_data <- function(data, harmonics = rtide::harmonics) {
  check_data(data,
    values = list(Station = "", DateTime = Sys.time()),
    nrow = c(1L, .Machine$integer.max)
  )

  if (!all(data$Station %in% tide_stations(harmonics = harmonics))) {
    stop("unrecognised stations", call. = FALSE)
  }

  if (has_name(data, "SlackTideHeight")) {
    stop("data already has 'SlackTideHeight' column", call. = FALSE)
  }

  if (has_name(data, "SlackDateTime")) {
    stop("data already has 'SlackDateTime' column", call. = FALSE)
  }

  if (has_name(data, "SlackType")) {
    stop("data already has 'SlackType' column", call. = FALSE)
  }

  tz <- dtt_tz(data$DateTime)
  data$DateTime <- dtt_adjust_tz(data$DateTime, tz = "UTC")

  years <- range(dtt_year(data$DateTime), na.rm = TRUE)
  if (!all(years %in% years_tide_harmonics(harmonics))) {
    stop("years are outside harmonics range", call. = FALSE)
  }

  data <- split(data, data$Station)
  data <- lapply(data, FUN = tide_slack_data_station, harmonics = harmonics)
  op <- options(stringsAsFactors = FALSE)
  on.exit(options(op))
  data <- do.call("rbind", data)

  data$DateTime <- dtt_adjust_tz(data$DateTime, tz = tz)
  data$SlackDateTime <- dtt_adjust_tz(data$SlackDateTime, tz = tz)
  data <- data[order(data$Station, data$DateTime), ]
  tibble::as_tibble(data)
}
