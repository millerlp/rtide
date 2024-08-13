test_that("data", {
  expect_s3_class(check_tide_harmonics(rtide::harmonics), "tide_harmonics")
})
