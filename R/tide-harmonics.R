#' Is tide_harmonics
#'
#' Tests if object inherits from class tide_harmonics.
#'
#' @param x The object to test.
#' @export
is.tide_harmonics <- function(x) {
  inherits(x, "tide_harmonics")
}

check_tide_harmonics <- function(x) {
  if (!is.tide_harmonics(x)) stop("x is not class 'tide_harmonics'")

  if (!all(c("Station", "Node", "StationNode", "NodeYear") %in% names(x)))
    stop("x is missing components", call. = FALSE)

  check_data2(x$Station, values = list(
    Station = "",
    Units = c("feet", "ft", "m", "metre"),
    Longitude = 1,
    Latitude = 1,
    Hours = c(-12,12),
    TZ = "",
    Datum = 1))

  x
}

tide_harmonics <- function (x) {
  if (!is.list(x)) stop("x must be a list", call. = FALSE)

  if (!all(c("name", "speed", "startyear", "equilarg", "nodefactor", "station",
            "units", "longitude", "latitude", "timezone", "tzfile", "datum",
            "A", "kappa") %in% names(x))) stop("x missing components", call. = FALSE)


  x$Station <- dplyr::data_frame(
    Station = x$station, Units = x$unit, Longitude = x$longitude, Latitude = x$latitude,
    Hours = x$timezone, TZ = x$tzfile, Datum = x$datum)

  x$Node <- dplyr::data_frame(Node = x$name, Speed = x$speed)
  x$StationNode <- abind::abind(A = x$A, Kappa = x$kappa, along = 3)
  dimnames(x$StationNode) <- list(x$Station$Station, x$Node$Node, c("A", "Kappa"))

  x$NodeYear <- abind::abind(EquilArg = x$equilarg, NodeFactor = x$nodefactor, along = 3)
  dimnames(x$NodeYear) <- list(x$Node$Node, seq(x$startyear, length.out = dim(x$NodeYear)[2]),
                               c("EquilArg", "NodeFactor"))

  x <- x[c("Station", "Node", "StationNode", "NodeYear")]

  station <- order(x$Station$Station)
  x$Station <- x$Station[station,,drop = FALSE]
  x$StationNode <- x$StationNode[station,,,drop = FALSE]

  node <- order(x$Node$Node)
  x$Node <- x$Node[node,,drop = FALSE]
  x$StationNode <- x$StationNode[,node,,drop = FALSE]
  x$NodeYear <- x$NodeYear[node,,,drop = FALSE]

  class(x) <- c("tide_harmonics")
  check_tide_harmonics(x)
  x
}

#' @export
subset.tide_harmonics <- function(x, stations, ...) {
  stations %<>% tide_stations(x)
  stations <- x$Station$Station %in% stations %>% which()
  x$Station %<>% dplyr::slice(stations)
  x$StationNode <- x$StationNode[stations,,,drop = FALSE]
  x
}

#' @export
format.tide_harmonics <- function(x, ...) {
  utils::str(x, ...)
}

#' @export
print.tide_harmonics <- function(x, ...) {
  cat(format(x, ...), "\n")
}
