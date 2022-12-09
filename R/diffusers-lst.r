#' @title Angular response of sensors
#'
#' @description A collection of angular response data for selected broadband
#' sensors used for measuring ultraviolet and visible radiation and of cosine
#' diffusers used with spectrometers. Each data frame in the
#' collection contains three variables, angle.deg (degrees) at either regular or
#' irregular intervals, response relative to the maximum (as a fraction of one)
#' and response relative to a perfect cosine response (as a fraction of one).
#' Data are either from manufacturer specifications or independent measurements
#' reported in the scientific literature.
#'
#' @format A \code{response_mspct} object containing a
#' \code{response_spct} objects as \emph{named} members.
#'
#' Each member spectrum contains three variables:
#' \itemize{
#'    \item angle.deg (degrees)
#'    \item response (/1)
#'    \item response.over.cosine (/1)
#' }
#'
#' @note Values are only good as reference, as individual sensors and diffusers
#'   deviate to a smaller or larger extent from typical or mean responses for
#'   their type. Variability is also reflected in some cases as an asymmetry in
#'   opposite angles away from the vertical.
#'
#' @docType data
#' @keywords datasets
#'
#' @examples
#' names(diffusers.lst)
#'
"diffusers.lst"
