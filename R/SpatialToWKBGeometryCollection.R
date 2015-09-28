# Convert a list of Spatial objects to a well-known binary (WKB) geometry
#   collection

#' Convert List of Spatial to \acronym{WKB} GeometryCollection
#' @noRd
ListOfSpatialToWKBGeometryCollection <- function(obj, endian) {
  wkb <- .ListOfSpatialToWKBGeometryCollection(obj, endian)
  if(identical(version$language, "TERR")) {
    attr(wkb, "SpotfireColumnMetaData") <-
      list(ContentType = "application/x-wkb", MapChart.ColumnTypeId = "Geometry")
  }
  I(wkb)
}

.ListOfSpatialToWKBGeometryCollection <- function(obj, endian) {
  rc <- rawConnection(raw(0), "r+")
  if(endian == "big") {
    writeBin(as.raw(0L), rc)
  } else {
    writeBin(as.raw(1L), rc)
  }
  writeBin(7L, rc, size = 4, endian = endian)
  writeBin(length(obj), rc, size = 4, endian = endian)
  gcHead <- rawConnectionValue(rc)
  close(rc)
  unlist(c(gcHead, lapply(X = obj, FUN = function(mygeometry) {
    unname(.writeWKB(mygeometry, endian))
  })), recursive = TRUE)
}
