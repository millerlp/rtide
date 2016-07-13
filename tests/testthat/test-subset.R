context("subset")

test_that("subset works", {
  h <- rtide::harmonics
  expect_equal(subset(h, h$Station$Station[2])$Station,
                   h$Station[2,,drop = FALSE])
})
