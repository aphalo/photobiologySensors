#' @title LI-COR sensors
#'
#' @description A vector of indeces for extracting subsets of spectra from the
#' \code{\link{sensors.mspct}} object.
#'
#' @format A character vector of members of the collection of spctra.
#'
#' @docType data
#' @keywords datasets
#'
#' @details
#' In the LI-190 PAR quantum sensor (PAR = photosynthetically active radiation)
#' colored glass filters are used to tailor the silicon photodiode response
#' to the desired quantum response.
#'
#' The LI-200SA features a silicon photovoltaic detector.
#' This is not a true 'pyranometer' and should be used only in sunlight, and
#' calibrated in sunlight.
#'
#' The LI-210SA Photometric Sensor utilizes a filtered silicon photodiode to provide
#' a spectral response that matches the CIE curve within ± 5% with most light sources.
#'
#' @note
#' Digitized with 'enguage' from manufacturers brochures. These are approximate
#' data, both because of the digitizing process, and because they are
#' either typical values or for a particular sensor unit. Individual sensor units
#' are expected to differ to some degree in spectral response.
#'
#' Manufacturer: LI-COR Inc., Lincoln, Nebraska
#' \url{http://www.licor.com/}
#'
#' @references
#' Brochure from manufacturer.
#'
#' @examples
#' LICOR_sensors
#'
"LICOR_sensors"
