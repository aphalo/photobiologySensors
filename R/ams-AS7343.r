#' @title Digital integrated sensors
#'
#' @description
#' Single channel, multiple channel and "spectral" sensors combining a single or
#' an array of filtered photodiodes, analogue amplifier(s), and analogue to
#' digital converters (ADC). They communicate with microprocessors using in most
#' cases one or more of three protocols I2C, SPI or text-based serial. The
#' digital interface can be used to retrieve readings, and set parameters such
#' as analogue amplification gain and ADC integration time. Some are capable of
#' automatic adjustment of some parameters. They are extremily small, frequently
#' as small as \eqn{6 mm^3} and in SMD packaging. The tolerance for the central
#' wavelengths of the channels is \eqn{\pm 10 nm}. They are also cheap and
#' easily available, both individually and on small break-out boards. At least a
#' few of them are also available as modules with logger functionality.
#'
#' @note
#' Digitized with 'DigitizeIt' from manufacturers' electronic component data
#' sheet. This are approximate data, both because of the digitizing process,
#' and because they are typical values. Individual sensor units are expected
#' to differ to some degree in spectral response. The data are normalised as
#' there is some variation in how they are shown in the data sheets.
#'
#' Supplier full type code and other metadata are stored in the spectarl objects
#' as R attributes.
#'
#' @references Data sheet for AS7343, ams-OSRAM. A USB module based on this
#' sensor is available from YoctoPuce as the Yocto-Spectral
#' (\url{https://www.yoctopuce.com}).
#'
#' @format A list-like \code{response_mspct} object containing one spectral
#'   object per sensor. The number of spectra in each spectral object varies
#'   following the number of channels peresent in each sensor, i.e., the
#'   channels response spectra are stored in long form.
#'
#' @docType data
#' @keywords datasets
#'
#' @examples
#'
#' names(ic_sensors.mspct)
#' summary(ic_sensors.mspct, expand = "collection")
#'
"ic_sensors.mspct"

