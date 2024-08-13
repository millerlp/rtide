test_that("harmonics correct", {
  expect_identical(anyDuplicated(years_tide_harmonics(rtide::harmonics)), 0L)
})

test_that("subset works", {
  h <- rtide::harmonics
  expect_equal(
    subset(h, h$Station$Station[2])$Station,
    h$Station[2, , drop = FALSE]
  )
})

test_that("years_tide_harmonics works", {
  expect_type(years_tide_harmonics(rtide::harmonics), "integer")
})
