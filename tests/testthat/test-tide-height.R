context("tide-height")

test_that("tide_height works", {
  expect_df <- function (x) expect_is(x, "data.frame")

  expect_df(check_data3(tide_height(), values = list(
    Station = "", DateTime = Sys.time(), TideHeight = 1),
    min_row = 24, max_row = 24,
    key = "DateTime"))
})
