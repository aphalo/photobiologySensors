#' @title sglux broadband sensors
#'
#' @description A vector of indexes for extracting subsets of spectra from the
#' \code{\link{sensors.mspct}} object.
#'
#' @format A character vector of members of the collection of spectra.
#'
#' @docType data
#' @keywords datasets
#'
#' @details
#' sglux SG01D-A UV-A broadband sensor (filtered SiC sensor).
#'
#' sglux SG01D-B UV-B broadband sensor (filtered SiC sensor, VIS-blind).
#'
#' sglux SG01D-C UV-C broadband sensor (filtered SiC sensor, "solar-blind").
#'
#' sglux SG01L SiC broadband sensor (SiC sensor not filtered).
#'
#' sglux TOCON blue 4 blue light broadband sensor (pre-amplified GaP detector).
#'
#' TOCON preamplified sensors with similar spectral response as the diodes are
#' also available from sglux. The blue light sensor is only available as
#' preamplified TOCON. Sensors are available in different configurations with
#' different sensitivity and with different angular responses, and encased
#' to resist different environmental conditions.
#'
#' Manufacturer: sglux GmbH, Berlin, Germany.
#' \url{https://sglux.de/en/}
#'
#' @note
#' Original data supplied by the manufacturer as a computer readable file, or
#' digitized from plots in specifications or other documents.
#' These are typical measured data. Individual sensor units
#' are expected to differ to a small degree in spectral response.
#'
#' @references personal communication from Dr.\ Stefan Langer.
#'
#' @examples
#'
#' sglux_sensors
#'
"sglux_sensors"
