#' Sensors responsive to different wavebands
#'
#' Vectors of names of members of the collection of spectra
#' \code{\link{sensors.mspct}} by the wavelengths or colours they are sensitive
#' to.
#'
#' @docType data
#' @keywords datasets
#' @format A vector of character strings.
#'
#' @concept sensors by waveband or color
#'
#' @examples
#' uv_sensors # ultraviolet
#' uvc_sensors # ultraviolet-C
#' uvb_sensors # ultraviolet-B
#' uva_sensors # ultraviolet-A
#' epar_sensors # extended photosynthetically active radiation
#' par_sensors # photosynthetically active radiation
#' vis_sensors # "visual" light sensors
#' shortwave_sensors
#' red_sensors
#' far_red_sensors
#' blue_sensors
#' multichannel_sensors
#' electronic_components # native spectral response, sold as parts
#'
#' # select PAR sensors
#' sensors.mspct[par_sensors]
#'
#' @seealso \code{\link{sensors.mspct}}
#'
"uv_sensors"

#' @rdname uv_sensors
"uvc_sensors"

#' @rdname uv_sensors
"uvb_sensors"

#' @rdname uv_sensors
"erythemal_sensors"

#' @rdname uv_sensors
"uva_sensors"

#' @rdname uv_sensors
"par_sensors"

#' @rdname uv_sensors
"epar_sensors"

#' @rdname uv_sensors
"vis_sensors"

#' @rdname uv_sensors
"photometric_sensors"

#' @rdname uv_sensors
"shortwave_sensors"

#' @rdname uv_sensors
"pyranometer_sensors"

#' @rdname uv_sensors
"red_sensors"

#' @rdname uv_sensors
"far_red_sensors"

#' @rdname uv_sensors
"blue_sensors"

#' @rdname uv_sensors
"green_sensors"

#' @rdname uv_sensors
"multichannel_sensors"

#' @rdname uv_sensors
"electronic_components"
