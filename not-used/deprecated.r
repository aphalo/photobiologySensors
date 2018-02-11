#' Calculate sensor response from spectral (energy or photon) irradiance (DEPRECATED)
#'
#' This DEPRECATED function gives the (electrical signal) sensor response for a given
#' spectral irradiance. Response will be in absolute or relative units depending on the
#' sensor response data used.
#'
#' @param w.length numeric array of wavelength (nm)
#' @param s.irrad numeric array of spectral (energy) irradiances (W m-2 nm-1)
#' @param sensor.name character string giving the name of one of the predefined sensors (default is "e.flat").
#' @param unit.in character string with allowed values "energy", and "photon", or its alias "quantum"
#' @param check.spectrum logical indicating whether to sanity check input data, default is TRUE
#' @param reference.irrad numeric value indicating the known value of the quantity being measured (defaults to 1.0)
#'
#' @return a single numeric value with no change in scale factor (in the units used in the description of the
#' spectral response of the sensor). If the reference irradiance is supplied, then the returned value is the
#' calibration factor needed to convert the reading of the sensor into the quantity given. Of course one should be
#' careful to also take into account electrical amplification, and the actual electrical signal measured, to get an
#' absolute calibration factor to use in real measurements.
#'
#' @export
#' @examples
#' data(sun.data)
#' with(sun.data, sensor_response(w.length, s.e.irrad))
#' with(sun.data, energy_irradiance(w.length, s.e.irrad))
#' with(sun.data, sensor_response(w.length, s.e.irrad, "q.flat")) * 1e6
#' with(sun.data, photon_irradiance(w.length, s.e.irrad)) * 1e6
#'
#' @note
#' One parameter controls a speed optimization. The default should be suitable
#' in mosts cases. If you set \code{check.spectrum=FALSE} then you should call \code{check_spectrum()}
#' at least once for your spectrum before using any of the other functions.
sensor_response <-
  function(w.length,
           s.irrad,
           sensor.name="e.flat",
           unit.in="energy",
           reference.irrad=1.0,
           check.spectrum=TRUE){
    # make code a bit simpler further down
    if (unit.in=="quantum") {unit.in <- "photon"}
    # sanity check for spectral data and abort if check fails
    if (check.spectrum && !check_spectrum(w.length, s.irrad)) {
      return(NA)
    }
    # calculate the multipliers
    # the unit.out refers to the type of multipliers we want, which needs
    # to match the "unit.in" of the spectral irradiance
    mult <- calc_sensor_multipliers(w.length.out=w.length, sensor.name=sensor.name, unit.out=unit.in,
                                    scaled=NULL, fill=0.0)$response

    # calculate sensor-weighted irradiance presumably an electrical voltage or current value
    response <- integrate_xy(w.length, s.irrad * mult) / reference.irrad

    return(response)
  }

#' Calculate multipliers by interpolation from sensor data (DEPRECATED)
#'
#' @description
#' Calculate multipliers by interpolation from sensor data, from user-supplied spectral response
#' data or by name for data included in the package
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
#' @export
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
