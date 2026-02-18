# Spectral and multichannel sensors
#
# response (%) is used by Vishay, for photodiodes this is most likely
# responsivity in A/W usually normalised!

library(photobiology)
library(ggspectra)
library(dplyr)
library(ggspectra)

rm(list = ls())

energy_as_default()

plotting <- TRUE

file.list <- list.files("./data-raw/Lite-On", "LiteOn-LTR390-.*\\.csv", full.names = TRUE)

LiteOn_LTR390.mspct <- response_mspct()
for (file.name in file.list) {
  # data object
  cat(basename(file.name), "\n")
  df.name <- gsub(pattern = "^LiteOn-LTR390-|\\.csv$",
                       replacement = "", x = basename(file.name),
                       fixed = FALSE)
  temp.df <- read.csv2(file.name, header = TRUE, comment.char = "#")
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
    temp.dt <- smooth_spct(temp.dt, method = "supsmu", strength = 2)
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
  LiteOn_LTR390.mspct[[df.name]] <- temp.dt
}

LiteOn_LTR390_channels <- names(LiteOn_LTR390.mspct)
LiteOn_LTR390.spct <-
  rbindspct(normalise(LiteOn_LTR390.mspct, norm = "max"), idfactor = "channel")
autoplot(LiteOn_LTR390.spct, annotations = "wls", facets = 1)

# descriptor of sensor channels

LTR390_channels.tb <-
  data.frame(ch.no = 1:2,
             sensor.ch.name = c("UV", "VIS"),
             ch.wl.peak = c(360, 330),
             ch.fwhm = c(25, 25))

# updating a data.frame column by column drops names!
LTR390_channels.named_tb <- list()
for (col in colnames(LTR390_channels.tb)) {
  temp <- LTR390_channels.tb[[col]]
  if (col == "ch.ic.name") {
    names(temp) <- LTR390_channels.tb$module.ch.name
  } else {
    names(temp) <- LTR390_channels.tb$sensor.ch.name
  }
  LTR390_channels.named_tb[[col]] <- I(temp)
}
LTR390_channels.named_tb <- as.data.frame(LTR390_channels.named_tb)
# names(VEML6075_channels.named_tb[[2]])

sensor.properties <- list(sensor.name = "LTR390UV",
                          sensor.supplier = "LiteOn",
                          sensor.type = "integrated circuit",
                          sensor.io = "I2C",
#                          module.name = "Yocto-I2C and IC breakout board",
#                          module.supplier = "YoctoPuce",
#                          module.io = "USB",
                          num.channels = 2,
                          output = "digital",
                          channels = LTR390_channels.named_tb)

attr(LiteOn_LTR390.spct, "sensor.properties") <- sensor.properties

what_measured(LiteOn_LTR390.spct) <-
  paste("LTR390 UV Sensor with 1 UV channel and 1 VIS channel:",
        "named \"UV\" and \"VIS\"",
        "SMD electronic component from LiteOn.",
        "Manufacturer: LITE-ON Technology Corp, Taiwan",
        "https://www.liteon.com/en/")
how_measured(LiteOn_LTR390.spct) <-
  "Digitized from plot in data sheet from LiteOn with DigitizeIt."
comment(LiteOn_LTR390.spct) <-
  "Data are approximate, not specifications. Provided as examples only"

autoplot(LiteOn_LTR390.spct,
         annotations = c("wls.labels", "peak.labels", "colour.guide"))

save(LiteOn_LTR390.spct, file = "./data-raw/Lite-On/LiteOn-LTR390.rda")
