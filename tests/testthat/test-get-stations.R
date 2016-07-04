context("get-stations")

test_that("get_stations works", {

  expect_equal(get_stations("Monterey", rtide::harmonics), c("Monterey, Monterey Harbor, California", "Elkhorn Slough railroad bridge, Monterey Bay, California"))
  expect_error(get_stations("^Monterey$", rtide::harmonics), "no matching stations")
  expect_error(get_stations(1, rtide::harmonics), "stations must be of class 'character'")
})
