datetime2seconds <- function(x) {
  as.numeric(x)
}

has_name <- function(x, colname) colname %in% colnames(x)

seconds2datetime <- function(x) {
  as.POSIXct(x, origin = ISOdate(1970, 1, 1, 0), tz = "UTC")
}
