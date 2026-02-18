# Spectral and multichannel sensors
#
# responsivity in A/W usually normalised, is used by ams-OSRAM in specs!

library(photobiology)
library(ggspectra)
library(dplyr)
library(ggspectra)

rm(list = ls())

energy_as_default()

plotting <- TRUE

file.list <- list.files("./data-raw/ams", "AS7331.*\\.csv", full.names = TRUE)

ams_AS7331.mspct <- response_mspct()
for (file.name in file.list) {
  # data object
  cat(basename(file.name), "\n")
  df.name <- gsub(pattern = "^AS7331-|\\.csv$",
                       replacement = "", x = basename(file.name),
                       fixed = FALSE)
  temp.df <- read.csv(file.name, header = FALSE, skip = 1,
                      col.names = c("w.length", "s.e.response"),
                      colClasses = "numeric")
  if (anyNA(temp.df$w.length)) {
    stop("'w.length' NA found at row(s): ", which(is.na(temp.df$w.length)))
  }
  if (anyNA(temp.df$s.e.response)) {
    stop("'s.e.response' NA found at row(s): ", which(is.na(temp.df$s.e.response)))
  }
  temp.df <- group_by(temp.df, w.length)
  # if multiple observations present for the same wavelength, use their mean
  temp.dt <- summarize(temp.df, s.e.response = mean(s.e.response))
  setResponseSpct(temp.dt)
  if (nrow(temp.df) > 300) {
    temp.dt <- smooth_spct(temp.dt, method = "supsmu", strength = 0.4)
  }
  if (nrow(temp.dt) < 300) {
    temp.dt <- interpolate_spct(temp.dt, length.out = 300, method = "approx")
  }
  if (stepsize(temp.dt)[1] > 1) {
    temp.dt <- interpolate_spct(temp.dt, length.out = expanse(temp.dt) * 2)
  }
  if (is_energy_based(temp.dt)) {
    temp.dt$s.e.response <- with(temp.dt,
                                 ifelse(s.e.response < 0,
                                        0,
                                        s.e.response))
    cat("energy based\n")
  } else if (is_photon_based(temp.dt)) {
    temp.dt$s.q.response <- with(temp.dt,
                                 ifelse(s.q.response < 0,
                                        0,
                                        s.q.response))
    cat("photon based\n")
  } else
    cat("wrong base\n")
  #
  cat(class(temp.dt)[1], "\n\n")
  if (plotting) {
    print(autoplot(temp.dt, annotations = c("+", "title:what:how")))
    readline("Next: ")
  }
  print(nrow(temp.dt))
  if (nrow(temp.dt) > 200) {
    temp.dt <- thin_wl(temp.dt, max.wl.step = 2, max.slope.delta = 0.001)
    if (plotting) {
      print(autoplot(temp.dt) + ggtitle(df.name, "Thinned"))
      readline("Next: ")
    }
  }
  print(nrow(temp.dt))
  ams_AS7331.mspct[[df.name]] <- temp.dt
}

ams_AS7331_channels <- names(ams_AS7331.mspct)
ams_AS7331.spct <-
  rbindspct(normalise(ams_AS7331.mspct, norm = "max"), idfactor = "channel")
autoplot(ams_AS7331.spct, annotations = "wls", facets = 1)

# descriptor of sensor channels

AS7331_channels.tb <-
  data.frame(ch.no = 1:3,
             sensor.ch.name = c("UVA", "UVB", "UVC"),
             ch.wl.peak = c(337, 293, 251),
             ch.fwhm = c(88, 33, 39))

# updating a data.frame column by column drops names!
AS7331_channels.named_tb <- list()
for (col in colnames(AS7331_channels.tb)) {
  temp <- AS7331_channels.tb[[col]]
  if (col == "ch.ic.name") {
    names(temp) <- AS7331_channels.tb$module.ch.name
  } else {
    names(temp) <- AS7331_channels.tb$sensor.ch.name
  }
  AS7331_channels.named_tb[[col]] <- I(temp)
}
AS7331_channels.named_tb <- as.data.frame(AS7331_channels.named_tb)
# names(AS7331_channels.named_tb[[2]])

sensor.properties <- list(sensor.name = "AS7331",
                          sensor.supplier = "ams OSRAM",
                          sensor.type = "integrated circuit",
                          sensor.io = "I2C",
#                          module.name = "Yocto-I2C and IC breakout board",
#                          module.supplier = "YoctoPuce",
#                          module.io = "USB",
                          num.channels = 3,
                          output = "digital",
                          channels = AS7331_channels.named_tb)

attr(ams_AS7331.spct, "sensor.properties") <- sensor.properties

what_measured(ams_AS7331.spct) <-
  paste("ams AS7331 Spectral Sensor with 3 UV channels.",
        "SMD electronic component from ams-OSRAM. 2022-current.")
how_measured(ams_AS7331.spct) <-
  "Digitized from plot in data sheet from ams-OSRAM with DigitizeIt."
comment(ams_AS7331.spct) <-
  "Data are approximate, not specifications. Provided as examples only"

autoplot(ams_AS7331.spct,
         annotations = c("wls.labels", "peak.labels", "colour.guide"))

save(ams_AS7331.spct, file = "./data-raw/ams/ams-AS7331.rda")
