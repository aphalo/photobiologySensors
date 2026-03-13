#' @title Entrance optics
#'
#' @description A vector of names useful for extracting subsets of angular
#'   response data from the \code{\link{diffusers.lst}} object.
#'
#' @docType data
#' @keywords datasets
#'
#' @details Irradiance measurements require diffusers or sensors with a response
#'   proportional to the cosine of the angle of light incidence, i.e., varying
#'   between a maximum and zero over 180 degrees in 3D. In practice no real
#'   diffusers achieve this over 180 degrees, and only the best ones approach
#'   the expected response over an angle of 160 to 170 degrees. Such entrance
#'   optics are described as cosine corrected and data for them can be extracted
#'   from \code{diffusers.lst} using \code{cosine_diffusers}. The response
#'   expected is given by the projected light exposed area under a collimated
#'   beam:
#'   \eqn{A_\mathrm{p} = A_\mathrm{max} \times \cos(z)}
#'   where \eqn{z} is the angle of incidence relative to the normal to the plane
#'   of the entrance optics or diffuser. For a horizontal sensor, \eqn{z} is the
#'   zenith angle of the sun.
#'
#'   Hemispherical scalar irradiance (or hemispherical fluence rate) requires an
#'   entrance optic with a response that varies with the angle of incidence
#'   between a maximum and its half over 180 degrees in 3D. Such sensors or
#'   diffusers are seldom available off-the-shelf. Data for them can be
#'   extracted from \code{diffusers.lst} using \code{dome_diffusers}. The
#'   response expected is given by the projected light exposed area under
#'   collimated light:
#'   \eqn{A_\mathrm{p} = A_\mathrm{max} \times 0.5 \times (1 + \cos(z))}
#'   where \eqn{z} is the angle of incidence relative to the normal to the plane
#'   of the entrance optics or diffuser.
#'
#'   Scalar irradiance (or fluence rate) measurements require a diffuser with
#'   response invariant over 360 degrees in 3D. Real sensors of this geometry
#'   have a blind spot as a fibre or a detector have to be attached to them. The
#'   response expected is given by the projected light exposed area under
#'   collimated light: \eqn{A_\mathrm{p} = A_\mathrm{max} \times 1} for all angles
#'   of incidence.
#'
#'   The angular response of ready-to-deploy broadband sensors can be extracted
#'   from \code{diffusers.lst} by \code{sensor_diffusers}. With a few exceptions
#'   these sensors are designed to measure irradiance.
#'
#'   The angular response of entrance optics suitable for use with spectrometers
#'   can be extracted from \code{diffusers.lst} by \code{entrance_optics}.
#'
#'   The angular response of bare sensors sold as electronic components
#'   including integrated circuits and photodiodes can be extracted from
#'   \code{diffusers.lst} by \code{ic_optics}. In some cases they approximate
#'   a cosine response except at high \eqn{z} angles. In other cases they have
#'   a much narrower angle of view.
#'
#'   The angular response expected based on physical quantity definitions can be
#'   extracted from \code{diffusers.lst} by \code{ideal_optics}. They have been
#'   computed using the equations shown above.
#'
#'   Responses are expressed relative to that for the maximum projected as
#'   fractions of one.
#'
#' @seealso Data in \code{\link{diffusers.lst}} and function
#'   \code{\link{angular_response}()}.
#'
#' @examples
#' all_diffusers
#'
"all_diffusers"

#' @rdname all_diffusers
#'
"cosine_diffusers"

#' @rdname all_diffusers
#'
"dome_diffusers"

#' @rdname all_diffusers
#'
"entrance_optics"

#' @rdname all_diffusers
#'
"sensor_optics"

#' @rdname all_diffusers
#'
"ic_optics"

#' @rdname all_diffusers
#'
"ideal_optics"
