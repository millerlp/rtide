tide_slack_datetime <- function(d, h, high = TRUE, forward = TRUE) {
  hours <- lubridate::minutes(cumsum(c(0,rep(15,25)))) * if (forward) 1 else -1
  height <- vapply(d + hours, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d %<>% magrittr::add(hours[which])

  minutes <- lubridate::minutes(c(cumsum(rep(-1,15)), 0, cumsum(rep(1,15))))
  height <- vapply(d + minutes, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d %<>% magrittr::add(minutes[which])

  seconds <- lubridate::seconds(c(cumsum(rep(-3,10)), 0, cumsum(rep(3,10))))
  height <- vapply(d + seconds, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d %<>% magrittr::add(seconds[which])

  seconds <- lubridate::seconds(c(cumsum(rep(-1,3)), 0, cumsum(rep(1,3))))
  height <- vapply(d + seconds, tide_height_datetime, 1, h = h)
  which <- which.max(height * if (high) 1 else -1)
  d %<>% magrittr::add(seconds[which])

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
  harmonics %<>% subset(stringr::str_c("^", data$Station[1], "$"))
  data <- plyr::adply(.data = data, .margins = 1, .fun = tide_slack_data_datetime,
                      h = harmonics)
  if (harmonics$Station$Units %in% c("feet", "ft"))
    data %<>% dplyr::mutate_(SlackTideHeight = ~ft2m(SlackTideHeight))
  data
}

#' Tide Slack Data
#'
#' Determines the closest slack tide for specified stations at particular date times based on the supplied harmonics object.
#'
#' @param data A data frame with the columns Station and DateTime.
#' @inheritParams tide_stations
#' @return A tibble of the slack tide date times and heights in m.
#' @export
tide_slack_data <- function (data, harmonics = rtide::harmonics) {
  data %<>% check_data2(values = list(Station = "", DateTime = Sys.time()))

  if (!all(data$Station %in% tide_stations(harmonics = harmonics)))
    stop("unrecognised stations", call. = FALSE)

  if (tibble::has_name(data, "SlackTideHeight"))
    stop("data already has 'SlackTideHeight' column", call. = FALSE)

  if (tibble::has_name(data, "SlackDateTime"))
    stop("data already has 'SlackDateTime' column", call. = FALSE)

  if (tibble::has_name(data, "SlackType"))
    stop("data already has 'SlackType' column", call. = FALSE)

  tz <- lubridate::tz(data$DateTime)
  data %<>% dplyr::mutate_(DateTime = ~lubridate::with_tz(DateTime, tzone = "UTC"))

  years <- range(lubridate::year(data$DateTime), na.rm = TRUE)
  if (!all(years %in% years_tide_harmonics(harmonics)))
    stop("years are outside harmonics range", call. = FALSE)

  data %<>% plyr::ddply(.variables = c("Station"), tide_slack_data_station, harmonics = harmonics)

  data %<>% dplyr::mutate_(DateTime = ~lubridate::with_tz(DateTime, tzone = tz))
  data %<>% dplyr::mutate_(SlackDateTime = ~lubridate::with_tz(SlackDateTime, tzone = tz))
  data %<>% dplyr::arrange_(~Station, ~DateTime)
  data %<>% dplyr::as.tbl()
  data
}
