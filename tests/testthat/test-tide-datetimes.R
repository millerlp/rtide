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
