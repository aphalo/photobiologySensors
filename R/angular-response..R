#' Angular response
#'
#' Angular response of idealized entrance optics used in light measurements.
#'
#' @param elevation.angle,zenith.angle numeric The elevation angle of
#' a point light source such as the sun or its zenith angle [degrees].
#' @param geometry character The type of entrance optics, one of
#' \code{"flat disk"}, \code{"cosine"}, \code{"dome"}, \code{"hemisphere"},
#' \code{"ball"}, or \code{"sphere"}.
#' @param diameter numeric The diameter of the entrance optics. If \code{NULL},
#' the default, a relative value is returned.
#'
#' @details The maximum projected area (\eqn{A_\mathrm{max}}) is always computed
#'   for a circle of diameter \eqn{d} as \eqn{A_\mathrm{max} = \pi \times d^2 / 4}
#'   when computing actual projected areas, or set to \eqn{A_\mathrm{max} = 1}
#'   for computation of relative values.
#'
#' The \emph{cosine response} for a \emph{flat disk} is computed as
#' \deqn{A_\mathrm{p} = A_\mathrm{max} \times \cos(z)}
#'
#' The \emph{hemispherical response} for a \emph{dome} is computed as
#' \deqn{A_\mathrm{p} = A_\mathrm{max} \times 0.5 \times (1 + \cos(z))}
#'
#' The \emph{spherical response} for a \emph{"ball"} is computed as
#' \deqn{A_\mathrm{p} = A_\mathrm{max} \times 1}
#'
#' @value A numeric vector of the same length as the numeric arguments following
#' the recycling rules of R expressions. With \code{diameter = NULL}, the
#' returned values are positive fractions or one, and otherwise the projected
#' area expressed in the area units matching the length unit in which the
#' argument passed to \code{diameter} is expressed.
#'
#' @export
#'
#' @seealso \code{\link{all_diffusers}} and \code{\link{diffusers.lst}} for
#'   data for real sensors and entrance optics.
#'
#' @examples
#' angular_response(45)
#' angular_response(45, "cosine")
#' angular_response(45, "dome")
#' angular_response(45, "sphere")
#' angular_response(c(0, 30, 60, 90))
#' angular_response(-c(0, 30, 60, 90))
#' angular_response(c(0, 30, 60, 90), "dome")
#' angular_response(c(0, 30, 60, 90), "sphere")
#'
angular_response <- function(elevation.angle = 90,
                             geometry = "cosine",
                             zenith.angle = 90 - elevation.angle,
                             diameter = NULL) {
  known.geometries <-
    c("flat disk", "cosine", "dome", "hemisphere", "ball", "sphere")
  if (length(geometry) > 1) {
    stop("Two many geometry names: ", length(geometry), " instead of 1")
  }
  if (!geometry %in% known.geometries) {
    stop("Unrecognized 'entrance.optics': ", geometry)
  }
  off.range <- zenith.angle < 0 | zenith.angle > 180
  if (any(off.range)) {
    warning("Set to 'NA' ", sum(off.range), " off-range angles!")
    zenith.angle[off.range] <- NA_real_
  }
  z <- zenith.angle / 180 * pi
  r <- if (is.null(diameter)) diameter else diameter / 2

  if (geometry %in% c("flat disk", "cosine")) {
    rel.area <- ifelse(z <= pi / 2, cos(z), 0)
  } else if (geometry %in% c("dome", "hemisphere")) {
    # with help from deepseek in finding correct equation
    rel.area <- ifelse(z <= pi / 2, 0.5 * (1 + cos(z)), 0)
  } else if (geometry %in% c("ball", "sphere")) {
    rel.area <- rep(1, length(z))
  }
  rel.area <- ifelse(rel.area < 1e-14, 0, rel.area)
  if (!is.null(r)) {
    rel.area * pi * r^2
  } else {
    rel.area
  }
}
