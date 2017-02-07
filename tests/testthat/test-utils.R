context("utils")

test_that("datetimes and seconds work", {
  start <- ISOdate(1970,1,1,0)
  expect_identical(datetime2seconds(seconds2datetime(datetime2seconds(start))), 0)
  expect_identical(datetime2seconds(seconds2datetime(datetime2seconds(start + lubridate::seconds(3)))), 3)
})
