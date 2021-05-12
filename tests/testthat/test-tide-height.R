test_that("tide_height works", {
  expect_error(chk::check_data(tide_height(),
    values = list(
      Station = "", DateTime = Sys.time(), TideHeight = 1
    ),
    nrow = 24,
    key = "DateTime",
    exclusive = TRUE,
    order = TRUE
  ), NA)

  expect_is(tide_height(stations = ".*"), "data.frame")
})
