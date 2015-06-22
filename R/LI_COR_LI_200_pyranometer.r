#' @description Datasets containing the wavelengths (nm) at either regular or
#' irregular intervals and tabulated values of spectral responsiveness for
#' different sensors (in most cases spectral data are normalized to one at the
#' wavelength of maximum energy responsivity).
#'
#' The variables are as follows, but only one of s.e.response or s.q.response is
#' included:
#' \itemize{
#'    \item w.length (nm)
#'    \item s.e.response (a.u.)
#' }
#'
#' @docType data
#' @keywords datasets
#'
#' @name LI_COR_LI_200_pyranometer.spct
#' @title LI-COR LI-200SA pyranometer
#' @note
#' The LI-200SA features a silicon photovoltaic detector.
#' This is not a true 'pyranometer' and should be used only in sunlight, and calibarted in sunlight.
#' Digitized with 'enguage' from manufacturers brochures. This are approximate
#' data, both because of the digitizing process, and because they are
#' either typical values or for a particular sensor unit. Individual sensor units
#' are expected to differ to some degree in spectral response.
#'
#' Manufacturer: LI-COR Inc., Lincoln, Nebraska
#' \url{http://www.licor.com/}
#'
#' @references Brochure 'LI-190SA quantum sensor'
#'
NULL 
