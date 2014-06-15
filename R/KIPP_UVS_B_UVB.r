#' Spectral data for sensors
#'
#' Datasets containing the wavelengths (nm) at either regular or irregular intervals and
#' tabulated values of spectral responsiveness for different sensors. 
#' Spectral response values are in arbitrary units.
#' 
#' The variables are as follows:
#' \itemize{
#'   \item w.length (nm)  
#'   \item s.e.response (a.u.)
#'   \item s.q.respone (a.u.) 
#' }
#' 
#' @author Tähti Pohjanmies
#' @author Pedro J. Aphalo \email{pedro.aphalo@@helsinki.fi} 
#' @docType data
#' @keywords datasets
#'
#' @name KIPP_UVS_B_UVB.dt
#' @note
#' UVS-B-T Radiometer.
#' The detection system includes optical filters and a phosphor
#' that determine the spectral response. The phosphor is very
#' sensitive to low levels of ultraviolet radiation and is stimulated
#' by the UV to emit green light, which is detected by a photodiode.
#' The system is temperature stabilised at +25 °C to prevent
#' changes in spectral response and sensitivity with variations in
#' the ambient conditions.
#' Digitized with 'enguage' from manufacturers brochures. This are approximate
#' data, both because of the digitizing process, and because they are
#' either typical values or for a particular sensor unit. Individual sensor units
#' are expected to differ to some degree in spectral response.
#' 
#' Manufacturer: Kipp & Zonen B.V., Delftechpark 36, 2628 XH Delft
#' \url{http://www.kippzonen.com/}
#'
#' @references Brochure 'Broadband UV Radiometers'
#'
NULL 
