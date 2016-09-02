context("years-tide-harmonics")

test_that("years_tide_harmonics works", {
  expect_is(years_tide_harmonics(rtide::harmonics), "integer")
})
