context("tide-height-data")

test_that("tide_height_data works", {
  expect_df <- function(x) expect_is(x, "data.frame")

  data <- data.frame(Station = "Monterey, Monterey Harbor, California",
                     DateTime = ISOdate(2015,1,1,10,tz = "PST8PDT"),
                     stringsAsFactors = FALSE)

  expect_df(check_data3(tide_height_data(data), values = list(
    Station = "", DateTime = Sys.time(), TideHeight = 1),
    min_row = 1, max_row = 1))
  expect_identical(lubridate::tz(data$DateTime), "PST8PDT")
})

test_that("tide_height_data predictions", {
  mllw <- rtide::mllw
  expect_equal(mllw$MLLW, tide_height_data(mllw)$TideHeight, tolerance = 1)
})
