test_that("tide_height works", {
  expect_error(chk::check_data(tide_height(),
    values = list(
      Station = "", DateTime = Sys.time(), TideHeight = 1
    ),
    nrow = 24,
    key = "DateTime",
    exclusive = TRUE,
    order = TRUE
  ), NA)

  expect_s3_class(tide_height(stations = ".*"), "data.frame")
})

test_that("hours_year works", {
  expect_error(hours_year(1))
  expect_identical(hours_year(ISOdate(2000, 1, 1, 1, tz = "UTC")), 1)
  expect_identical(hours_year(ISOdate(2000, 1, 1, c(1, 3, 1), tz = "UTC")), c(1L, 3, 1))
  expect_identical(hours_year(ISOdate(2001, 1, 1, c(1, 3, 1), tz = "UTC")), c(1, 3, 1))
  expect_identical(hours_year(ISOdate(2001, 1, 2, c(1, 3, 1), tz = "UTC")), c(25, 27, 25))
})

test_that("tide_datetimes works", {
  minutes <- 17L
  from <- as.Date("2000-02-01")
  to <- as.Date("2000-05-02")
  tz <- "PST8PDT"

  expect_equal(dtt_tz(tide_datetimes(minutes = minutes, from = from, to = to, tz = tz)), "PST8PDT")
  expect_equal(tide_datetimes(minutes = minutes, from = from, to = to, tz = tz)[1], ISOdate(2000, 02, 01, 0, tz = tz))
  expect_equal(max(dtt_date(tide_datetimes(minutes = minutes, from = from, to = to, tz = tz))), to)

  expect_error(dtt_tz(tide_datetimes(minutes = minutes, from = to, to = from, tz = tz)))

  expect_identical(tide_datetimes(minutes = 1), tide_datetimes(minutes = 1L))
  expect_warning(tide_datetimes(minutes = 1.9), "Truncating minutes interval to whole number")
  expect_chk_error(tide_datetimes(minutes = 0L), "^`minutes` must be between 1 and 60, not 0[.]$")
  expect_chk_error(tide_datetimes(minutes = 0.9), "^`minutes` must be between 1 and 60, not 0[.]9[.]$")
})

test_that("tide_height_data works", {
  data <- data.frame(
    Station = "Monterey, Monterey Harbor, California",
    DateTime = ISOdate(2015, 1, 1, 10, tz = "PST8PDT"),
    stringsAsFactors = FALSE
  )

  expect_error(chk::check_data(tide_height_data(data),
    values = list(
      Station = "", DateTime = Sys.time(), TideHeight = 1
    ),
    nrow = 1, exclusive = TRUE, order = TRUE
  ), NA)
  expect_identical(dtt_tz(data$DateTime), "PST8PDT")
})

test_that("tide_height_data predictions", {
  expect_equal(rtide::monterey$MLLW,
    tide_height_data(rtide::monterey)$TideHeight,
    tolerance = 0.002
  )
  expect_equal(rtide::brandywine$MLLW,
    tide_height_data(rtide::brandywine)$TideHeight,
    tolerance = 0.002
  )
})

test_that("tide_height_data checks", {
  data <- data.frame(
    Station = "Monterey, Monterey Harbor, California",
    DateTime = ISOdate(2015, 1, 1, 10, tz = "PST8PDT"),
    stringsAsFactors = FALSE
  )

  data$TideHeight <- 1

  expect_error(tide_height_data(data), "data already has 'TideHeight' column")

  data$TideHeight <- NULL
  dtt_year(data$DateTime) <- 1699L
  expect_error(tide_height_data(data), "years are outside harmonics range")
})

test_that("tide_height_data tz", {
  data <- data.frame(
    Station = "Monterey, Monterey Harbor, California",
    DateTime = ISOdate(2015, 1, 1, 10, tz = "PST8PDT"),
    stringsAsFactors = FALSE
  )

  data2 <- data
  data2$DateTime <- dtt_adjust_tz(data2$DateTime, tz = "EST")

  expect_equal(tide_height_data(data)$TideHeight, tide_height_data(data2)$TideHeight)
})

test_that("tide_stations works", {
  expect_equal(tide_stations("Monterey", rtide::harmonics), c("Elkhorn Slough railroad bridge, Monterey Bay, California", "Monterey, Monterey Harbor, California"))
  expect_equal(
    tide_stations(
      c("Elkhorn Slough railroad bridge, Monterey Bay, California", "Monterey, Monterey Harbor, California")
    ),
    c("Elkhorn Slough railroad bridge, Monterey Bay, California", "Monterey, Monterey Harbor, California")
  )

  expect_equal(tide_stations("Annapolis (US Naval Academy), Severn River, Maryland", rtide::harmonics), "Annapolis (US Naval Academy), Severn River, Maryland")

  expect_error(tide_stations("^Monterey$", rtide::harmonics), "no matching stations")
  expect_chk_error(tide_stations(1, rtide::harmonics), "^`stations` must inherit from S3 class 'character'[.]$")
})
