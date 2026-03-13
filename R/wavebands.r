#' Sensors responsive to different wavebands
#'
#' @inherit ams_sensors
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

#' Types of sensors
#'
#' @inherit uv_sensors
#'
#' @concept sensors by type
#'
#' @examples
#' electronic_components
#'
"electronic_components"
