# Spectral and multichannel sensors
#

library(photobiology)
library(ggspectra)
library(dplyr)
library(ggspectra)

rm(list = ls())

energy_as_default()

plotting <- TRUE

file.list <- list.files("./data-raw/vishay", "Vishay-VEML6075-.*\\.csv", full.names = TRUE)

Vishay_VEML6075.mspct <- response_mspct()
for (file.name in file.list) {
  # data object
  cat(basename(file.name), "\n")
  df.name <- gsub(pattern = "^Vishay-VEML6075-|\\.csv$",
                       replacement = "", x = basename(file.name),
                       fixed = FALSE)
  temp.df <- read.csv(file.name, header = TRUE, comment.char = "#")
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
  Vishay_VEML6075.mspct[[df.name]] <- temp.dt
}

Vishay_VEML6075_channels <- names(Vishay_VEML6075.mspct)
Vishay_VEML6075.spct <-
  rbindspct(normalise(Vishay_VEML6075.mspct), idfactor = "channel")
autoplot(Vishay_VEML6075.spct, annotations = "wls", facets = 1)

# descriptor of sensor channels

VEML6075_channels.tb <-
  data.frame(ch.no = 1:3,
             sensor.ch.name = c("UVA", "UVB", "UVC"),
             ch.wl.peak = c(337, 293, 251),
             ch.fwhm = c(88, 33, 39))

# updating a data.frame column by column drops names!
VEML6075_channels.named_tb <- list()
for (col in colnames(VEML6075_channels.tb)) {
  temp <- VEML6075_channels.tb[[col]]
  if (col == "ch.ic.name") {
    names(temp) <- VEML6075_channels.tb$module.ch.name
  } else {
    names(temp) <- VEML6075_channels.tb$sensor.ch.name
  }
  VEML6075_channels.named_tb[[col]] <- I(temp)
}
VEML6075_channels.named_tb <- as.data.frame(VEML6075_channels.named_tb)
# names(VEML6075_channels.named_tb[[2]])

sensor.properties <- list(sensor.name = "VEML6075",
                          sensor.supplier = "Vishay",
                          sensor.type = "integrated circuit",
                          sensor.io = "I2C",
#                          module.name = "Yocto-I2C and IC breakout board",
#                          module.supplier = "YoctoPuce",
#                          module.io = "USB",
                          num.channels = 3,
                          output = "digital",
                          channels = VEML6075_channels.named_tb)

attr(Vishay_VEML6075.spct, "sensor.properties") <- sensor.properties

what_measured(Vishay_VEML6075.spct) <-
  paste("VEML6075 UV Sensor with 2 UV channels:",
        "UV-A1 and UV-A2 but named \"UVA\" and \"UVB\"!",
        "SMD electronic component from Vishay. 2016-2019 (still available?).",
        "Manufacturer: VISHAY INTERTECHNOLOGY, INC. Shelton, CT, USA.",
        "https://www.vishay.com/.")
how_measured(Vishay_VEML6075.spct) <-
  "Digitized from plot in data sheet from ams-OSRAM with DigitizeIt."
comment(Vishay_VEML6075.spct) <-
  "Data are approximate, not specifications. Provided as examples only"

autoplot(Vishay_VEML6075.spct,
         annotations = c("wls.labels", "peak.labels", "colour.guide"))

save(Vishay_VEML6075.spct, file = "./data-raw/vishay/Vishay-VEML6075.rda")
