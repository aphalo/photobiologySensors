#' Calculate multipliers by interpolation from sensor data
#'
#' @description
#' Calculate multipliers by interpolation from sensor data, from user-supplied spectral response
#' data or by name for data included in the package
#'
#' @usage calc_sensor_multipliers(w.length.out, sensor.name="e.flat",
#'                                w.length.in=NULL, response.in=NULL,
#'                                pc=FALSE, div=1.0,
#'                                unit.in="energy", unit.out=NULL,
#'                                scaled=NULL, fill=NA)
#'
#' @param w.length.out numeric vector of wavelengths (nm) for output
#' @param sensor.name a character string giving the name of a sensor data set, default is a 'e.flat' filter (flat response to energy)
#' @param w.length.in numeric vector of wavelengths (nm) for input
#' @param response.in numeric vector of spectral transmittance value (fractions or percent)
#' @param pc logical value indicating whether transmittances are expressed as percentages or fractions (default is \%)
#' @param div numeric value default is 100.0 if pc=TRUE, but if pc=FALSE, default is 1.0, but can be changed in the call
#' @param unit.in a character string "energy" or "photon"
#' @param unit.out a character string "energy" or "photon", if NULL (the default) unit.out is set to unit.in (which depends on sensor data, if selected with sensor.name)
#' @param scaled NULL, "peak", "area"; div ignored if !is.null(scaled)
#' @param fill if NA, no extrapolation is done, and NA is returned for wavelengths outside the range of the input. If NULL then the tails are deleted. If 0 then the tails are set to zero.
#'
#' @return a dataframe with two numeric vectors with wavelength values and scaled and interpolated response values
#' @keywords manip misc
#' @export
#' @examples
#' with(Berger_UV_erythemal.spct,
#'      calc_sensor_multipliers(290:450, w.length.in=w.length, response.in=s.e.response))
#' with(Berger_UV_erythemal.spct,
#'      calc_sensor_multipliers(290:450, w.length.in=w.length,
#'                              response.in=s.e.response, unit.out="photon"))
#' calc_sensor_multipliers(290:450, w.length.in=Berger_UV_erythemal.spct$w.length,
#'                         response.in=Berger_UV_erythemal.spct$s.e.response)
#' calc_sensor_multipliers(290:450, "Berger_UV_erythemal")
#' calc_sensor_multipliers(400:500)
#'
calc_sensor_multipliers <- function(w.length.out,
                                    sensor.name="e.flat",
                                    w.length.in=NULL, response.in=NULL,
                                    pc=FALSE, div = 1.0,
                                    unit.in="energy", unit.out=NULL,
                                    scaled=NULL, fill=NA) {
  if (pc) div <- 100.0

  # we first check the different possible inputs and convert to
  # two vectors w.length.in and response.in

  if (is.null(w.length.in) | is.null(response.in)) {
    if (is.null(sensor.name)) return(NA)
    if (sensor.name=="e.flat") {
      w.length.in <- w.length.out
      response.in <- rep(1.0, length(w.length.out))
      unit.in <- "energy"
      div <- 1.0
    }
    else if (sensor.name=="q.flat") {
      w.length.in <- w.length.out
      response.in <- rep(1.0, length(w.length.out))
      unit.in <- "photon"
      div <- 1.0
    }
    else {
      sensor.object.name <- paste(sensor.name, "spct", sep=".")
      if (!exists(sensor.object.name)) {
        sensor.object.name <- paste(sensor.name, "dt", sep=".")
        if (!exists(sensor.object.name)) {
          sensor.object.name <- paste(sensor.name, "data", sep=".")
          if (!exists(sensor.object.name)) {
          warning("No data for sensor with name: ", sensor.object.name)
          return(NA)
          }
        }
      }
      sensor.object <- get(sensor.object.name)
      w.length.in <- sensor.object$w.length
      if (with(sensor.object, exists("s.e.response"))) {
        unit.in <- "energy"
        response.in <- sensor.object$s.e.response
      }
      else if (with(sensor.object, exists("s.q.response"))) {
        unit.in <- "photon"
        response.in <- sensor.object$s.q.response
      }
      else {
        return(NA)
      }
    }
  }
  else if (!check_spectrum(w.length.in, response.in)) {
      return(NA)
    }

  # we check unit.in and unit.out and convert the raw response accordingly
  if (is.null(unit.out)) unit.out <- unit.in

  if (unit.in == unit.out) {
      s.response <- response.in
    }
    else if (unit.in == "energy" && unit.out == "photon") {
      # this is counter-intuitive because we must transform the "input" from "energy" to "photon" and
      # based on this we can use the opposite transformation on the response itself!
      s.response <- as_energy(w.length.in, response.in)
    }
    else if (unit.in == "photon" && unit.out == "energy") {
      s.response <- as_quantum_mol(w.length.in, response.in)
    }
    else {
      warning("Bad unit argument. unit.in: ", unit.in, "unit.out: ", unit.out)
      return(NA)
    }

  # we interpolate uisng a spline
  if (length(w.length.out) < 25) {
    # cubic spline
    response.out <- stats::spline(w.length.in, s.response, xout=w.length.out)$y
  } else {
    # linear interpolation
    response.out <- stats::approx(w.length.in, s.response, xout=w.length.out, ties="ordered", rule=2)$y
  }

  # we trim the tails as it makes no sense to extrapolate

  out.data <- trim_tails(w.length.out, response.out,
                         max(w.length.in[1], w.length.out[1]),
                         min(w.length.in[length(w.length.in)], w.length.out[length(w.length.out)]),
                         use.hinges=FALSE,
                         fill=fill)
  names(out.data)[2] <- "response"
  if (!is.null(scaled)) {
    if (scaled=="peak") {
      div <- with(out.data, max(response, na.rm=TRUE))
    }
    else if (scaled=="area") {
      div <- with(stats::na.omit(out.data), integrate_xy(w.length, response))
    }
    else {
      warning("Ignoring unsupported scaled argument: ", scaled)
    }
  }
  out.data$response <- with(out.data, response / div)
  return(out.data)
}