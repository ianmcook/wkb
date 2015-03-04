# Convert a string hexadecimal representation to a raw vector

#' Convert String Hex Representation to Raw Vector
#'
#' Converts a string hexadecimal representation to a \code{raw} vector.
#'
#' @param hex character string or character vector containing a hexadecimal
#'   representation.
#' @details Non-hexadecimal characters are removed.
#' @return A \code{\link[base]{raw}} vector.
#' @examples
#' # create a character string containing a hexadecimal representation
#' hex <- "0101000000000000000000f03f0000000000000840"
#'
#' # convert to raw vector
#' wkb <- hex2raw(hex)
#'
#'
#' # create a character vector containing a hexadecimal representation
#' hex <- c("01", "01", "00", "00", "00", "00", "00", "00", "00", "00", "00",
#'          "f0", "3f", "00", "00", "00", "00", "00", "00", "08", "40")
#'
#' # convert to raw vector
#' wkb <- hex2raw(hex)
#'
#'
#' # create vector of two character strings each containing a hex representation
#' hex <- c("0101000000000000000000f03f0000000000000840",
#'          "010100000000000000000000400000000000000040")
#'
#' # convert to list of two raw vectors
#' wkb <- lapply(hex, hex2raw)
#' @seealso \code{raw2hex} in package
#'   \href{http://cran.r-project.org/package=PKI}{PKI}, \code{\link{readWKB}}
#' @export
hex2raw <- function(hex) {
  if(!is.character(hex)) {
    stop("hex must be a character string or character vector")
  }
  hex <- gsub("[^0-9a-fA-F]", "", hex)
  if(length(hex) == 1) {
    if(nchar(hex) %% 2 != 0) {
      stop("hex is not a valid hexadecimal representation")
    }
    hex <- substring(hex, seq(1, nchar(hex), 2), seq(2, nchar(hex), 2))
  }
  if(!all(lapply(hex, nchar) == 2)) {
    stop("hex is not a valid hexadecimal representation")
  }
  hex <- paste("0x", hex, sep = "")
  as.raw(hex)
}
