context("tide-datetimes")

test_that("tide_datetimes works", {

  minutes <- 17L
  from <- as.Date("2000-02-01")
  to <- as.Date("2000-05-02")
  tz <- "PST8PDT"

  expect_equal(lubridate::tz(tide_datetimes(minutes = minutes, from = from, to = to, tz = tz)), "PST8PDT")
  expect_equal(tide_datetimes(minutes = minutes, from = from, to = to, tz = tz)[1], ISOdate(2000,02,01,0,tz = tz))
  expect_equal(max(lubridate::date(tide_datetimes(minutes = minutes, from = from, to = to, tz = tz))), to)

  expect_error(lubridate::tz(tide_datetimes(minutes = minutes, from = to, to = from, tz = tz)))
})
