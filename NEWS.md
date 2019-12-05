# wkb 0.4-0

* Change to which WKB representations SpatialPolygons convert to
  * SpatialPolygons objects now convert to either WKB Polygons or WKB MultiPolygons
    * If each Polygons object in the SpatialPolygons object contains a single Polygon object with only one exterior boundary then convert to WKB Polygon, otherwise convert to WKB MultiPolygon
    * Previously SpatialPolygons were converted to WKB Polygon containing multiple rings
* Make changes for compatibility with R 4.0.0 ([#12](https://github.com/ianmcook/wkb/issues/12))

# wkb 0.3-0

* Improved performance of function `hex2raw()` ([#10](https://github.com/ianmcook/wkb/issues/10))

# wkb 0.2-0

* Added support for big-endian WKB ([#2](https://github.com/ianmcook/wkb/issues/2))
* Added function `hex2raw()` ([#4](https://github.com/ianmcook/wkb/issues/4))
* Added tests

# wkb 0.1-0

* First CRAN release
