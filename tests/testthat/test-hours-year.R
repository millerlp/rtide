context("hours-year")

test_that("hours_year works", {
  expect_error(hours_year(1))
  expect_identical(hours_year(ISOdate(2000,1,1,1,tz = "UTC")), 1)
  expect_identical(hours_year(ISOdate(2000,1,1,c(1,3,1),tz = "UTC")), c(1L,3,1))
  expect_identical(hours_year(ISOdate(2001,1,1,c(1,3,1),tz = "UTC")), c(1,3,1))
  expect_identical(hours_year(ISOdate(2001,1,2,c(1,3,1),tz = "UTC")), c(25,27,25))
})
