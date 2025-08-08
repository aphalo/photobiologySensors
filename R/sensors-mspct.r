#' @title Spectral response of sensors
#'
#' @description A collection of response spectra for various broadband sensors
#' used for measuring ultraviolet and visible radiation. Each spectrun in the
#' collection contains two variables, wavelengths (nm) at either regular or
#' irregular intervals and spectral responsiveness (in energy units).
#' Spectral data are in most cases normalized to one at the wavelength of
#' maximum energy responsivity. Absolute calibration values are given only for
#' data from a publication which reports on multiple units of the same type.
#'
#' @format A \code{response_mspct} object containing
#' \code{response_spct} objects as \emph{named} members.
#'
#' Spectral objects for single channel sensers contain two numeric variables,
#' with responsivity in most cases in relative energy units:
#' \itemize{
#'    \item w.length (nm)
#'    \item s.e.response (r.u.)
#' }
#' Spectral objects for multichannel sensors contain the spectra in long form
#' with two numeric variables, and in addition a factor with channel ids:
#' \itemize{
#'    \item w.length (nm)
#'    \item s.e.response (r.u.)
#'    \item channel (factor with names as levels)
#' }
#' The spectral objects contain, in addition to the spectral data, metadata
#' stored in R attributes.
#'
#' @note In addition to this object containing the spectral data, this package
#' provides character vectors useful for subsetting spectra by supplier, type,
#' colour, etc.
#'
#' @docType data
#' @keywords datasets
#'
#' @seealso \code{\link[photobiology]{source_spct}} and
#' \code{\link[photobiology:generic_mspct]{source_mspct}}
#'
#' @examples
#' names(sensors.mspct)
#'
"sensors.mspct"
