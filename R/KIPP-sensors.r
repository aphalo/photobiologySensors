#' @title Kipp Radiometers.
#'
#' @description A vector of indeces for stracting subsets of spectra from the
#' \code{\link{sensors.mspct}} object.
#'
#' @format A character vector of members of the collection of spctra.
#'
#' @docType data
#' @keywords datasets
#'
#' @details
#' Kipp CUV 5 Broadband UV Radiometer:
#' Detection system includes optical filters and a photodiode.
#'
#' Kipp PQS 1 PAR Quantum Sensor:
#' Detection system includes optical filters and a photodiode.
#'
#' UVS-A-T Radiometer, UVS-B-T Radiometer, Kipp UVS-E-T Erythemal Radiometer:
#' The detection system includes optical filters and a phosphor
#' that determine the spectral response. The phosphor is very
#' sensitive to low levels of ultraviolet radiation and is stimulated
#' by the UV to emit green light, which is detected by a photodiode.
#' The system is temperature stabilised at +25 °C to prevent
#' changes in spectral response and sensitivity with variations in
#' the ambient conditions.
#'
#' Manufacturer: Kipp & Zonen B.V., Delftechpark 36, 2628 XH Delft, Nederlands.
#' \url{http://www.kippzonen.com/}
#'
#' @note
#' Digitized with 'enguage' from manufacturers brochures. These are approximate
#' data, both because of the digitizing process, and because they are
#' either typical values or for a particular sensor unit. Individual sensor units
#' are expected to differ to some degree in spectral response.
#'
#' @references
#' Brochure 'Broadband UV Radiometers',
#' Brochure 'PQS 1 PAR Quantum Sensor',
#' Brochure 'Broadband UV Radiometers'.
#'
#' @examples
#'
#' kipp_sensors
#'
"kipp_sensors"
