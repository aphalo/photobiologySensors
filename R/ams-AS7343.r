#' @title ams-AS7343 digital spectral sensor
#'
#' @description
#' AS7343 digital spectral sensor combining an array of photodiodes with
#' interference filters deposited diröectly on the sensor chip. The sensor
#' digitises the readings and communicates through I2C interface. In addition
#' to retrieving readings through I2C the analogue gain and integration time
#' used by can be programmed. The tolerance for the central
#' wavelengths of the channels is \eqn{\pm 10 nm}.
#'
#' @note
#' Digitized with 'DigitizeIt' from manufacturers' electronic component data
#' sheet. This are approximate data, both because of the digitizing process,
#' and because they are typical values. Individual sensor units are expected
#' to differ to some degree in spectral response.
#'
#' Manufacturer: ams-OSRAM AG, Austria.
#'
#' @references Data sheet for AS7343, ams-OSRAM. A USB module based on this
#' sensor is available from YoctoPuce as the Yocto-Spectral
#' (\url{https://www.yoctopuce.com}).
#'
#' @format A \code{response_spct} object containing 13 spectra in long form.
#'
#' @docType data
#' @keywords datasets
#'
#' @examples
#'
#' levels(ams_AS7343.spct[[getIdFactor(ams_AS7343.spct)]])
#' summary(ams_AS7343.spct, expand = "collection")
#'
"ams_AS7343.spct"

#' @title ams-AS7331 digital ultraviolet sensor
#'
#' @description
#' AS7331 digital ultraviolet sensor combining an array of photodiodes with
#' interference filters deposited directly on the sensor chip. The sensor
#' digitises the readings and communicates through I2C interface. In addition
#' to retrieving readings through I2C the analogue gain and integration time
#' used an be programmed.
#'
#' @note
#' Digitized with 'DigitizeIt' from manufacturers' electronic component data
#' sheet. This are approximate data, both because of the digitizing process,
#' and because they are typical values. Individual sensor units are expected
#' to differ to some degree in spectral response.
#'
#' Manufacturer: ams-OSRAM AG, Austria.
#'
#' @references Data sheet for AS7331, ams-OSRAM.
#'
#' @format A \code{response_spct} object containing 3 spectra in long form.
#'
#' @docType data
#' @keywords datasets
#'
#' @examples
#'
#' levels(ams_AS7331.spct[[getIdFactor(ams_AS7331.spct)]])
#' summary(ams_AS7331.spct, expand = "collection")
#'
"ams_AS7331.spct"

#' @title ams-TSL2591 ambient light sensor
#'
#' @description
#' TSL2591 digital ambient light sensor combining two photodiodes, one bare
#' and one filtered. The sensor digitises the readings and communicates through
#' I2C interface.
#'
#' @note
#' Digitized with 'DigitizeIt' from manufacturers' electronic component data
#' sheet. This are approximate data, both because of the digitizing process,
#' and because they are typical values. Individual sensor units are expected
#' to differ to some degree in spectral response.
#'
#' Manufacturer: ams-OSRAM AG, Austria.
#'
#' @references Data sheet for TSL2591, ams-OSRAM.
#'
#' @format A \code{response_spct} object containing 2 spectra in long form.
#'
#' @docType data
#' @keywords datasets
#'
#' @examples
#'
#' levels(ams_TSL2591.spct[[getIdFactor(ams_TSL2591.spct)]])
#' summary(ams_TSL2591.spct, expand = "collection")
#'
"ams_TSL2591.spct"

