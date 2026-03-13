#' Sensors responsive to different wavebands
#'
#' @inherit ams_sensors description format seealso
#'
#' @format A character vector of names of members of the collection of spectra.
#'
#' @docType data
#' @keywords datasets
#'
#' @concept light sensors
#'
#' @rdname sensors-by-waveband
#' @aliases sensors-by-waveband uvc_sensors uvb_sensors uva_sensors epar_sensors par_sensors vis_sensors shortwave_sensors red_sensors far_red_sensors blue_sensors
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
"uv_sensors"

#' @rdname sensors-by-waveband
"uvc_sensors"

#' @rdname sensors-by-waveband
"uvb_sensors"

#' @rdname sensors-by-waveband
"erythemal_sensors"

#' @rdname sensors-by-waveband
"uva_sensors"

#' @rdname sensors-by-waveband
"par_sensors"

#' @rdname sensors-by-waveband
"epar_sensors"

#' @rdname sensors-by-waveband
"vis_sensors"

#' @rdname sensors-by-waveband
"photometric_sensors"

#' @rdname sensors-by-waveband
"shortwave_sensors"

#' @rdname sensors-by-waveband
"pyranometer_sensors"

#' @rdname sensors-by-waveband
"red_sensors"

#' @rdname sensors-by-waveband
"far_red_sensors"

#' @rdname sensors-by-waveband
"blue_sensors"

#' @rdname sensors-by-waveband
"green_sensors"

#' @rdname sensors-by-waveband
"multichannel_sensors"

#' Types of sensors
#'
#' @inherit sensors-by-waveband
#'
#' @concept sensors by type
#'
#' @examples
#' electronic_components
#'
"electronic_components"
