#' @title 'ams' sensors
#'
#' @description A vector of indexes for extracting subsets of spectra from the
#' \code{\link{sensors.mspct}} object.
#'
#' @format A character vector of names of members of the collection of spectra.
#'
#' @docType data
#' @keywords datasets
#'
#' @details
#' TSL254R light-to-voltage optical sensor combining a photodiode
#' and a transimpedance amplifier, sold as electronic components.
#' The spectral response is nearly identical
#' for type TSL250, TSL251 and TSL252.  (part is no longer in production.)
#'
#' TSL257 high-sensitivity low-noise light-to-voltage optical
#' converter that combines a photodiode and a transimpedance amplifier,
#' sold as electronic components.
#'
#' @note
#' Digitized with 'DigitizeIt' from manufacturers data sheets. This are
#' approximate data, both because of the
#' digitizing process, and because they are either typical values or for a
#' specific sensor unit. Individual sensor units are expected to differ to some
#' degree in spectral response.
#'
#' Manufacturer: ams-OSRAM AG, Austria. \url{https://ams.com/}
#'
#' @references
#' Data sheet for TSL254R (TAOS, TAOS071C - SEPTEMBER 2007)
#'
#' Data sheet for TSL257 ([v1-00] 2016-Jul-25)
#'
#' @examples
#'
#' ams_sensors
#'
"ams_sensors"
