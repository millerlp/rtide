context("tide-height-data")

test_that("tide_height_data works", {
  expect_df <- function(x) expect_is(x, "data.frame")

  data <- data.frame(Station = "Monterey, Monterey Harbor, California",
                     DateTime = ISOdate(2015,1,1,10,tz = "PST8PDT"),
                     stringsAsFactors = FALSE)

  expect_df(checkr::check_data(tide_height_data(data), values = list(
    Station = "", DateTime = Sys.time(), TideHeight = 1),
    nrow = 1, exclusive = TRUE, order = TRUE))
  expect_identical(lubridate::tz(data$DateTime), "PST8PDT")
})

test_that("tide_height_data predictions", {
  expect_equal(rtide::monterey$MLLW,
               tide_height_data(rtide::monterey)$TideHeight, tolerance = 0.002)
  expect_equal(rtide::brandywine$MLLW,
               tide_height_data(rtide::brandywine)$TideHeight, tolerance = 0.002)
})

test_that("tide_height_data checks", {
  library(lubridate)

  data <- data.frame(Station = "Monterey, Monterey Harbor, California",
                     DateTime = ISOdate(2015,1,1,10,tz = "PST8PDT"),
                     stringsAsFactors = FALSE)

  data$TideHeight <- 1

  expect_error(tide_height_data(data), "data already has 'TideHeight' column")

  data$TideHeight <- NULL
  year(data$DateTime) <- 1699
  expect_error(tide_height_data(data), "years are outside harmonics range")
})

test_that("tide_height_data tz", {
  library(lubridate)

  data <- data.frame(Station = "Monterey, Monterey Harbor, California",
                     DateTime = ISOdate(2015,1,1,10,tz = "PST8PDT"),
                     stringsAsFactors = FALSE)

  data2 <- data
  data2$DateTime <- lubridate::with_tz(data2$DateTime, tz = "EST")

  expect_equal(tide_height_data(data), tide_height_data(data2))
})

