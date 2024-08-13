test_that("years_tide_harmonics works", {
  expect_type(years_tide_harmonics(rtide::harmonics), "integer")
})
