#' @title LI-COR sensors
#'
#' @inherit ams_sensors
#'
#' @details
#' In the LI-190SA and LI-190 PAR quantum sensor (PAR = photosynthetically
#' active radiation) colored glass filters are used to tailor the silicon
#' photodiode response to the desired quantum response. They have the same
#' spectral response.
#'
#' The type of filter used in the LI-190R PAR quantum sensor is not described,
#' but improves the spectral response compared to the LI-190.
#'
#' The LI-200SA features a silicon photovoltaic detector. This is not a true
#' 'pyranometer' and should be used only in sunlight, and calibrated in
#' sunlight.
#'
#' The LI-210SA Photometric Sensor utilizes a filtered silicon photodiode to
#' provide a spectral response that matches the CIE curve within ± 5% with most
#' light sources.
#'
#' The LI-210R Photometric Sensor utilizes a filtered silicon photodiode to
#' provide a spectral response that matches the CIE curve.
#'
#' Manufacturer: LI-COR Inc., Lincoln, Nebraska
#' \url{https://www.licor.com/env/}
#'
#' @references
#' LI-COR (2005) Instruction Manual 'LI-COR Terrestrial Radiation Sensors'.
#' LI-COR (2015) Technical Note 'Why Upgrade to the "R" Light and Radiation Sensors?'
#'
#' @examples
#' licor_sensors
#'
"licor_sensors"
