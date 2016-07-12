context("station-number")

test_that("station_number works", {
  expect_error(station_number(1))
  expect_identical(station_number(rtide::harmonics$station[1], rtide::harmonics), 1L)
  expect_identical(station_number(rtide::harmonics$station[3], rtide::harmonics), 3L)
  expect_error(station_number(rtide::harmonics$station[1:2], rtide::harmonics), "station must be a scalar")
  expect_error(station_number("not a station", rtide::harmonics), "no matching stations")
  expect_error(station_number("e", rtide::harmonics), "no matching stations")
})
