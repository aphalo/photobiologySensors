#' Calculate multipliers by interpolation from sensor data
#' 
#' @description
#' Calculate multipliers by interpolation from sensor data, from user-supplied spectral response 
#' data or by name for data included in the package
#'
#' @usage calc_sensor_multipliers(w.length.out, sensor.name="e.flat", 
#'                                w.length.in=NULL, response.in=NULL, 
#'                                pc=FALSE, div=1.0,
#'                                unit.in="energy", unit.out=unit.in,
#'                                scaled=NULL)
#' 
#' @param w.length.out numeric vector of wavelengths (nm) for output
#' @param sensor.name a character string giving the name of a sensor data set, default is a 'e.flat' filter (flat response to energy)
#' @param w.length.in numeric vector of wavelengths (nm) for input
#' @param response.in numeric vector of spectral transmittance value (fractions or percent)
#' @param pc logical value indicating whether transmittances are expressed as percentages or fractions (default is \%)
#' @param div numeric value default is 100.0 if pc=TRUE, but if pc=FALSE, default is 1.0, but can be changed in the call
#' @param unit.in a character string "energy" or "photon"
#' @param unit.out a character string "energy" or "photon"
#' @param scaled NULL, "peak", "area"; div ignored if !is.null(scaled) 
#'  
#' @return a numeric vector of responsivities 
#' @keywords manip misc
#' @export
#' @examples
#' with(Berger_UV_erythemal.data, calc_sensor_multipliers(290:450, w.length.in=w.length, response.in=s.e.response))
#' with(Berger_UV_erythemal.data, calc_sensor_multipliers(290:450, w.length.in=w.length, 
#'                                                        response.in=s.e.response, unit.out="photon"))
#' calc_sensor_multipliers(290:450, w.length.in=Berger_UV_erythemal.data$w.length, 
#'                         response.in=Berger_UV_erythemal.data$s.e.response)
#' calc_sensor_multipliers(290:450, "Berger_UV_erythemal")
#' calc_sensor_multipliers(400:500)
#' 
calc_sensor_multipliers <- function(w.length.out,
                                    sensor.name="e.flat", 
                                    w.length.in=NULL, response.in=NULL, 
                                    pc=FALSE, div = 1.0,
                                    unit.in="energy", unit.out=unit.in,
                                    scaled=NULL) {
  if (pc) div <- 100.0
  if (is.null(w.length.in) | is.null(response.in)) {
    if ((sensor.name=="e.flat" && unit.out=="energy") ||
          (sensor.name=="q.flat" && unit.out=="photon"))  {
      response.out <- rep(1.0, length(w.length.out))
    } 
    else if (sensor.name=="e.flat" && unit.out=="photon") {
      response.out <- 1.0 / w.length.out
      response.out <- response.out / max(response.out)
    } 
    else if (sensor.name=="q.flat" && unit.out=="energy") {
      response.out <- w.length.out / max(w.length.out)
    } 
    else {
      sensor.object.name <- paste(sensor.name, "data", sep=".")
      sensor.object <- get(sensor.object.name)
      if (unit.out=="energy" && with(sensor.object, exists("s.e.response"))) {
        response.out <- with(sensor.object, spline(w.length, s.e.response, xout=w.length.out)$y)
      } 
      else if (unit.out=="photon" && with(sensor.object, exists("s.q.response"))) {
        response.out <- with(sensor.object, spline(w.length, s.q.response, xout=w.length.out)$y)
      }
      else {
        return(NA)
      }
    }
  } else {
    if (!check_spectrum(w.length.in, response.in)) {
      return(NA)
    }
    if (unit.in == unit.out) {
      s.response <- response.in
    }
    else if (unit.in == "energy" && unit.out == "photon") {
      s.response <- as_quantum_mol(w.length.in, response.in)
    }
    else if (unit.in == "photon" && unit.out == "energy") {
      s.response <- as_energy(w.length.in, response.in)
    }
    else {
      warning(paste("Bad unit argument. unit.in:", unit.in, "unit.out:", unit.out))
      return(NA)
    }
    response.out <- spline(w.length.in, s.response, xout=w.length.out)$y
  }
  if (!is.null(scaled)) {
    if (scaled=="peak") {
      div <- max(response.out)
    }
    else if (scaled=="area") {
      div <- integrate_irradianceC(w.length.out, response.out)
    }
    else {
      warning(paste("Ignoring unsupported scaled argument:", scaled))
    }
  }
  return(response.out / div)
}