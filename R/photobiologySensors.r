#' @details
#' Data for response spectra for different types of broadband sensors.
#' The package contains one collection of spectra for different broadband
#' sensors.
#'
#' In addition to the spectra the package provides character vectors of names
#' to be used as indexes to subset groups of spectra. In many cases spectral
#' data are normalized to spectral energy responsieness equal to one at the
#' wavelength of maximum spectral energy response (peak sensitivity).
#'
#' The data in this package are not original. Some have been provided by
#' authors of scientific publications and manufacturers. However, most of
#' the spectra have been digitised from manufacturer's brochures and manuals
#' available on web sites.
#'
#' @section Warning!:
#' The spectral data included in this package are not all based on supplier's
#' specifications and are only for information. The exact response spectrum
#' depends to some extent on testing conditions, but more importantly varies among
#' individual sensor units. Spectral specifications are usually given as typical
#' values. All the sensors for which data are presented here need periodic
#' calibration. In other words, the data provided here are not a substitute
#' for actual calibration under measuring conditions for each individual sensor
#' unit. For less demanding situations like roughly assessing the suitability
#' of sensors or the need or not of a transfer calibration, the data are good
#' enough. They can be especially useful in teaching.
#'
#' @import photobiology
#'
#' @examples
#' library(photobiology)
#' library(photobiologyWavebands)
#' library(ggspectra)
#'
#' names(sensors.mspct)
#'
#' licor_sensors
#' par_sensors
#' intersect(par_sensors, licor_sensors)
#'
#' photon_as_default()
#'
#' response(sensors.mspct$LI_190, w.band = PAR(), quantity = "contribution.pc")
#'
#' plot(sensors.mspct$LI_190, w.band = PAR(), label.qty = "contribution.pc")
#'
"_PACKAGE"
