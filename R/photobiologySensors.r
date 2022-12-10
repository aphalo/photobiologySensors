#' @details
#' Data for spectral response for different types of broadband sensors are
#' stored as objects of class \code{sensor_spct} as collection members in
#' an object of class \code{sensor_mspct}.
#' In addition to the spectra the package provides character vectors of names
#' to be used as indexes to extract spectra from the collection.
#'
#' Data for angular response for different types of broadband sensors and some
#' diffusers used as entrance optics for spectrometers are stored as objects
#' of class \code{data.frame} as members of a \code{list}.
#' In addition to the list of data frames, the package provides character vectors of names
#' to be used as indexes to extract the data frames from the named list.
#'
#' The data in this package are not original. Some have been provided by
#' authors of scientific publications and manufacturers. However, most of
#' the spectra have been digitized from manufacturer's brochures and manuals
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
#' @references
#'
#' Aphalo, Pedro J. (2015) The r4photobiology suite. UV4Plants Bulletin, 2015:1,
#' 21-29. \doi{10.19232/uv4pb.2015.1.14}.
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
#' response(sensors.mspct$LICOR_LI_190R, w.band = PAR(), quantity = "contribution.pc")
#'
#' autoplot(sensors.mspct$LICOR_LI_190R, w.band = PAR(), label.qty = "contribution.pc")
#'
#' names(diffusers.lst)
#'
#' cosine_diffusers
#'
"_PACKAGE"
