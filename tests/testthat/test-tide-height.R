context("tide-height")

test_that("tide_height works", {
  expect_df <- function (x) expect_is(x, "data.frame")

  expect_df(checkr::check_data(tide_height(), values = list(
    Station = "", DateTime = Sys.time(), TideHeight = 1),
    nrow = 24,
    key = "DateTime",
    exclusive = TRUE,
    order = TRUE))

  expect_df(tide_height(stations = ".*"))
})
