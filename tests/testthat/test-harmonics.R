context("harmonics")

test_that("harmonics correct", {
  expect_identical(anyDuplicated(years_tide_harmonics(rtide::harmonics)), 0L)
})
