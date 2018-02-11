#' Sensors responsive to different wavebands
#' 
#' Names of datasets containing the wavelengths and tabulated values spectral emittance 
#' for broadband sensors from various suppliers. 
#' 
#' @docType data
#' @keywords datasets
#' @format A vector of character strings.
#' 
#' @aliases 'sensors by waveband' 
#' 
#' @examples 
#' uvc_sensors
#' uvb_sensors
#' uva_sensors
#' par_sensors
#' vis_sensors
#' shortwave_sensors
#' red_sensors
#' far_red_sensors
#' blue_sensors
#' multichannel_sensors
#' 
#' # select PAR sensors
#' leds.mspct[par_sensors]
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
"vis_sensors"

#' @rdname uv_sensors
"photometric_sensors"

#' @rdname uv_sensors
"shortwave_sensors"

#' @rdname uv_sensors
"red_sensors"

#' @rdname uv_sensors
"far_red_sensors"

#' @rdname uv_sensors
"blue_sensors"

#' @rdname uv_sensors
"multichannel_sensors"


