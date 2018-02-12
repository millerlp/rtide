context("tide-stations")

test_that("tide_stations works", {

  expect_equal(tide_stations("Monterey", rtide::harmonics), c("Elkhorn Slough railroad bridge, Monterey Bay, California", "Monterey, Monterey Harbor, California"))
  expect_equal(tide_stations(
    c("Elkhorn Slough railroad bridge, Monterey Bay, California", "Monterey, Monterey Harbor, California")),
    c("Elkhorn Slough railroad bridge, Monterey Bay, California", "Monterey, Monterey Harbor, California"))

  expect_equal(tide_stations("Annapolis (US Naval Academy), Severn River, Maryland", rtide::harmonics), "Annapolis (US Naval Academy), Severn River, Maryland")

  expect_error(tide_stations("^Monterey$", rtide::harmonics), "no matching stations")
  expect_error(tide_stations(1, rtide::harmonics), "stations must be class character")
})

