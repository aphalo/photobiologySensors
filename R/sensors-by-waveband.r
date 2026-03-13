#' Sensors responsive to different wavebands
#'
#' @inherit ams_sensors description format seealso
#'
#' @docType data
#' @keywords datasets
#'
#' @concept light sensors
#'
#' @rdname sensors-by-waveband
#' @aliases sensors-by-waveband uvc_sensors uvb_sensors uva_sensors epar_sensors par_sensors vis_sensors shortwave_sensors red_sensors far_red_sensors blue_sensors
#'
#' @details The sensors pointed at by each of these vectors are sensitive to
#'   light of a certain colour within visible radiation (VIS) or to different
#'   bands of ultraviolet (UV) or infrared (IR) radiation.
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
#' @inherit uv_sensors
#'
#' @concept sensors by type
#'
#' @details The sensors pointed at by this vector are those sold as electronic
#' components and used to construct sensors that can be deployed when interfaced
#' to other electronic components, possibly combined with optical filters and
#' entrance optics and protected inside a case or enclosure.
#'
#' @examples
#' electronic_components
#'
"electronic_components"
