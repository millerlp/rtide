context("subset")

test_that("subset works", {
  h <- rtide::harmonics
  expect_identical(subset(h, h$Station$Station[2])$Station,
                   h$Station[2,,drop = FALSE])
})
