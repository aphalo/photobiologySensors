% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/diffusers.r
\docType{data}
\name{all_diffusers}
\alias{all_diffusers}
\alias{cosine_diffusers}
\alias{dome_diffusers}
\title{Entrance optics}
\format{
A character vector of names of members of the list of data
  frames.

An object of class \code{character} of length 11.

An object of class \code{character} of length 1.
}
\usage{
all_diffusers

cosine_diffusers

dome_diffusers
}
\description{
A vector of names useful for extracting subsets of angular
  response data from the \code{\link{diffusers.lst}} object.
}
\note{
Irradiance measurements require diffusers or sensors with a responsivity
proportional to the cosine of the angle of incidence. These described as
cosine corrected. In practice no real diffusers achieve this over 180
degrees, and only the best approach the expected response over an angle
of 160 to 170 degrees.

Hemispherical scalar irradiance (or hemispherical fluence rate) requires an
entrance optics with a response invariant with the angle of incidence over
180 degrees in 3D. Such sensors or diffusers are seldom available
off-the-shelf.

Scalar irradiance (or fluence rate) measurements require a diffuser with
response invariant over 360 degrees in 3D.
}
\examples{
all_diffusers

}
\keyword{datasets}
