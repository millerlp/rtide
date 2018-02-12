context("tide-slack-data")

test_that("tide_slack_data works", {
  expect_df <- function(x) expect_is(x, "data.frame")

  data <- data.frame(Station = "Monterey, Monterey Harbor, California",
                     DateTime = ISOdate(2015,1,1,10,tz = "PST8PDT"),
                     stringsAsFactors = FALSE)

  expect_df(check_data(tide_slack_data(data), values = list(
    Station = "", DateTime = Sys.time(), SlackDateTime = Sys.time(),
    SlackTideHeight = 1, SlackType = ""),
    nrow = 1, exclusive = TRUE, order = TRUE))
})

test_that("tide_height_data predictions", {
  slack <- tide_slack_data(rtide::monterey)
  expect_equal(slack$MLLW, slack$SlackTideHeight, tolerance = 0.002)
  expect_equal(slack$DateTime, slack$SlackDateTime, tolerance = 30)
  expect_identical(slack$SlackType, rep(c("low", "high"), 4))

  monterey <- rtide::monterey
  monterey$DateTime <- monterey$DateTime + lubridate::hours(2)
  slack2 <- tide_slack_data(monterey)
})

