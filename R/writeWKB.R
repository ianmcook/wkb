# Convert an R spatial object to a well-known binary (WKB) geometry
# representation

#' Convert Spatial Objects to WKB
#'
#' Converts \code{Spatial} objects to well-known binary (WKB) geometry
#' representations.
#'
#' @param obj object inheriting class \code{\link[sp:Spatial-class]{Spatial}}.
#' @details The argument \code{obj} may be an object of class
#'   \code{\link[sp:SpatialPoints-class]{SpatialPoints}},
#'   \code{\link[sp:SpatialPointsDataFrame-class]{SpatialPointsDataFrame}},
#'   \code{\link[sp:SpatialLines-class]{SpatialLines}},
#'   \code{\link[sp:SpatialLinesDataFrame-class]{SpatialLinesDataFrame}},
#'   \code{\link[sp:SpatialPolygons-class]{SpatialPolygons}}, or
#'   \code{\link[sp:SpatialPolygonsDataFrame-class]{SpatialPolygonsDataFrame}},
#'   or a \code{list} in which each element is an object of class
#'   \code{\link[sp:SpatialPoints-class]{SpatialPoints}} or
#'   \code{\link[sp:SpatialPointsDataFrame-class]{SpatialPointsDataFrame}}.
#' @return A \code{list} with class \code{AsIs}. The length of the returned list
#'   is the same as the length of the argument \code{obj}. Each element of the
#'   returned list is a \code{\link[base]{raw}} vector consisting of a WKB
#'   geometry representation. The WKB geometry type depends on the class of
#'   \code{obj} as shown in the table below.
#'
#' \tabular{ll}{
#' \strong{Class of \code{obj}} \tab \strong{Type of WKB geometry}\cr
#' \code{SpatialPoints} or \code{SpatialPointsDataFrame} \tab Point\cr
#' \code{list} of \code{SpatialPoints} or \code{SpatialPointsDataFrame} \tab MultiPoint\cr
#' \code{SpatialLines} or \code{SpatialLinesDataFrame} \tab MultiLineString\cr
#' \code{SpatialPolygons} or \code{SpatialPolygonsFrame} \tab Polygon\cr
#' }
#'
#' Returned WKB geometry representations use little-endian byte order.
#'
#' When this function is run in TIBCO Enterprise Runtime for R (TERR), the
#' return value has the SpotfireColumnMetaData attribute set to enable TIBCO
#' Spotfire to recognize it as a WKB geometry representation.
#' @examples
#' # create an object of class SpatialPoints
#' x = c(1, 2)
#' y = c(3, 2)
#' obj <- sp::SpatialPoints(data.frame(x, y))
#'
#' # convert to WKB Point
#' wkb <- writeWKB(obj)
#'
#'
#' # create a list of objects of class SpatialPoints
#' x1 = c(1, 2, 3, 4, 5)
#' y1 = c(3, 2, 5, 1, 4)
#' x2 <- c(9, 10, 11, 12, 13)
#' y2 <- c(-1, -2, -3, -4, -5)
#' Sp1 <- sp::SpatialPoints(data.frame(x1, y1))
#' Sp2 <- sp::SpatialPoints(data.frame(x2, y2))
#' obj <- list("a"=Sp1, "b"=Sp2)
#'
#' # convert to WKB MultiPoint
#' wkb <- writeWKB(obj)
#'
#'
#' # create an object of class SpatialLines
#' l1 <- data.frame(x = c(1, 2, 3), y = c(3, 2, 2))
#' l1a <- data.frame(x = l1[, 1] + .05, y = l1[, 2] + .05)
#' l2 <- data.frame(x = c(1, 2, 3), y = c(1, 1.5, 1))
#' Sl1 <- sp::Line(l1)
#' Sl1a <- sp::Line(l1a)
#' Sl2 <- sp::Line(l2)
#' S1 <- sp::Lines(list(Sl1, Sl1a), ID = "a")
#' S2 <- sp::Lines(list(Sl2), ID = "b")
#' obj <- sp::SpatialLines(list(S1, S2))
#'
#' # convert to WKB MultiLineString
#' wkb <- writeWKB(obj)
#'
#'
#' # create an object of class SpatialPolygons
#' triangle <- sp::Polygons(
#'   list(
#'     sp::Polygon(data.frame(x = c(2, 2.5, 3, 2), y = c(2, 3, 2, 2)))
#'   ), "triangle")
#' rectangles <- sp::Polygons(
#'    list(
#'      sp::Polygon(data.frame(x = c(0, 0, 1, 1, 0), y = c(0, 1, 1, 0, 0))),
#'      sp::Polygon(data.frame(x = c(0, 0, 2, 2, 0), y = c(-2, -1, -1, -2, -2)))
#'    ), "rectangles")
#' obj <- sp::SpatialPolygons(list(triangle, rectangles))
#'
#' # convert to WKB Polygon
#' wkb <- writeWKB(obj)
#'
#'
#' # use the WKB as a column in a data frame
#' ds <- data.frame(ID = c("a","b"), Geometry = wkb)
#'
#' # calculate envelope columns and cbind to the data frame
#' coords <- writeEnvelope(obj)
#' ds <- cbind(ds, coords)
#' @seealso \code{\link{writeEnvelope}}, \code{\link{readWKB}}
#' @keywords wkb
#' @export
writeWKB <- function(obj) {
  if(inherits(obj, c("SpatialPoints", "SpatialPointsDataFrame"), which = FALSE)) {

    SpatialPointsToWKBPoint(obj)

  } else if(inherits(obj, "list") && length(obj) > 0 &&
          all(vapply(
            X = obj,
            FUN = inherits,
            FUN.VALUE = logical(1),
            c("SpatialPoints", "SpatialPointsDataFrame"))
            )
          ) {

    ListOfSpatialPointsToWKBMultiPoint(obj)

  } else if(inherits(obj, c("SpatialLines", "SpatialLinesDataFrame"), which = FALSE)) {

    SpatialLinesToWKBMultiLineString(obj)

  } else if(inherits(obj, c("SpatialPolygons", "SpatialPolygonsDataFrame"), which = FALSE)) {

    SpatialPolygonsToWKBPolygon(obj)

  } else {

    stop("obj must be an object of class SpatialPoints, SpatialPointsDataFrame, ",
         "SpatialLines, SpatialLinesDataFrame, SpatialPolygons, ",
         "or SpatialPolygonsDataFrame, or a list of objects of class ",
          "SpatialPoints or SpatialPointsDataFrame")

  }
}
