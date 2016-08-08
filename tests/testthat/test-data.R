context("data")

test_that("data", {
  expect_is(check_tide_harmonics(rtide::harmonics), "tide_harmonics")
})
