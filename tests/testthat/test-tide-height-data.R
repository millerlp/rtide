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
