#' @title Spectral response of sensors
#'
#' @description A collection of response spectra for various broadband sensors
#' used for measuring ultraviolet and visible radiation. Each spectrun in the
#' collection contains two variables, wavelengths (nm) at either regular or
#' irregular intervals and spectral responsiveness (in energy units).
#' Spectral data are in most cases normalized to one at the wavelength of
#' maximum energy responsivity. Absolute calibration values are given only for
#' data from a publication which reports on mulstiple units of the same type.
#'
#' @format A \code{response_mspct} object containing a
#' \code{response_spct} objects as \emph{named} members.
#'
#' Each member spectrum contains two variables, with responsivity in most cases
#' in relative energy units:
#' \itemize{
#'    \item w.length (nm)
#'    \item s.e.response (r.u.)
#' }
#'
#' @note In addition to this object containing the spectral data, this package
#' provides character vectors useful for subsetting spectra by supplier, type,
#' color, etc.
#'
#' @docType data
#' @keywords datasets
#'
#' @seealso \code{\link[photobiology]{source_spct}} and \code{\link[photobiology]{generic_mspct}}
#'
#' @examples
#' names(sensors.mspct)
#'
"sensors.mspct"
