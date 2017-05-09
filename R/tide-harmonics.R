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
    Datum = 1),
    key = "Station")

  check_data2(x$Node, values = list(
    Node = "",
    Speed = 1),
    key = "Node")

  if (!is.array(x$StationNode)) stop("StationNode must be an array", call. = FALSE)
  if (!is.array(x$NodeYear)) stop("NodeYear must be an array", call. = FALSE)
  if (mode(x$StationNode) != "numeric")
    stop("StationNode must be a numeric array", call. = FALSE)
  if (mode(x$NodeYear) != "numeric")
    stop("NodeYear must be a numeric array", call. = FALSE)

  if (!identical(dimnames(x$StationNode), list(x$Station$Station, x$Node$Node, c("A", "Kappa"))))
    stop("StationNode has invalid dimnames", call. = FALSE)

  if (!identical(dimnames(x$NodeYear)[c(1,3)], list(x$Node$Node, c("NodeFactor", "EquilArg"))))
    stop("NodeYear has invalid dimnames", call. = FALSE)

  years <- dimnames(x$NodeYear)[2][[1]]
  years <- as.numeric(years)
  years <- diff(years)
  if (!all(years == 1)) stop("NodeYear has invalid dimnames", call. = FALSE)
  x
}

tide_harmonics <- function (x) {
  if (!is.list(x)) stop("x must be a list", call. = FALSE)

  if (!all(c("name", "speed", "startyear", "equilarg", "nodefactor", "station",
             "units", "longitude", "latitude", "timezone", "tzfile", "datum",
             "A", "kappa") %in% names(x))) stop("x missing components", call. = FALSE)


  x$Station <- data.frame(
    Station = x$station, Units = x$unit, Longitude = x$longitude, Latitude = x$latitude,
    Hours = x$timezone, TZ = x$tzfile, Datum = x$datum, stringsAsFactors = TRUE)

  x$Station$Station %<>% enc2utf8()

  x$Node <- data.frame(Node = x$name, Speed = x$speed, stringsAsFactors = TRUE)
  x$StationNode <- abind::abind(A = x$A, Kappa = x$kappa, along = 3)
  dimnames(x$StationNode) <- list(x$Station$Station, x$Node$Node, c("A", "Kappa"))

  x$NodeYear <- abind::abind(NodeFactor = x$nodefactor, EquilArg = x$equilarg, along = 3)
  dimnames(x$NodeYear) <- list(x$Node$Node, seq(x$startyear, length.out = dim(x$NodeYear)[2]),
                               c("NodeFactor", "EquilArg"))

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
  x$Station <- x$Station[stations,]
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

years_tide_harmonics <- function(x) {
  x <- dimnames(x$NodeYear)[[2]]
  x %<>% as.character() %>% as.integer()
  x
}
