#' Calculate sensor response from spectral (energy or photon) irradiance.
#'
#' This function gives the (electrical signal) sensor response for a given
#' spectral irradiance. Response will be in absolute or relative units depending on the
#' sensor response data used.
#'
#' @usage sensor_response(w.length, s.irrad, sensor.name="e.flat", unit.in="energy", reference.irrad=1.0,
#' check.spectrum=TRUE)
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
#' @keywords manip misc
#' @export
#' @examples
#' data(sun.data)
#' with(sun.data, sensor_response(w.length, s.e.irrad))
#' with(sun.data, energy_irradiance(w.length, s.e.irrad))
#' with(sun.data, sensor_response(w.length, s.e.irrad, "q.flat")) * 1e6
#' with(sun.data, photon_irradiance(w.length, s.e.irrad)) * 1e6
#' @note 
#' One parameter controls a speed optimization. The default should be suitable
#' in mosts cases. If you set \code{check.spectrum=FALSE} then you should call \code{check_spectrum()}
#' at least once for your spectrum before using any of the other functions. 

sensor_response <- 
  function(w.length, s.irrad, sensor.name="e.flat", unit.in="energy", reference.irrad=1.0, 
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
    response <- integrate_irradiance(w.length, s.irrad * mult) / reference.irrad
    
    return(response)
  }
