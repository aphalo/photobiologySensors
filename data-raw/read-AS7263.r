# Spectral and multichannel sensors
#

library(photobiology)
library(ggspectra)
library(dplyr)

rm(list = ls())

energy_as_default()

plotting <- TRUE

# read DigitizeIt CSV file
file.list <- list.files("./data-raw/ams", "AS7263.*\\.csv", full.names = TRUE)

ams_AS7263.mspct <- response_mspct()
for (file.name in rev(file.list)) {
  # data object
  cat(basename(file.name), "\n")
  df.name <- gsub(pattern = "^AS7263-|\\.csv$",
                  replacement = "", x = basename(file.name),
                  fixed = FALSE)
  temp.df <- read.csv2(file.name, header = FALSE, skip = 1,
                       col.names = c("w.length", "s.e.response"),
                       colClasses = "numeric")
  temp.df <- distinct(temp.df)
  temp.df <- group_by(temp.df, w.length)
  temp.dt <- summarize(temp.df, s.e.response = mean(s.e.response))
  setResponseSpct(temp.dt)
  if (nrow(temp.df) > 200) {
    temp.dt <- smooth_spct(temp.dt, method = "supsmu")
  }
  if (nrow(temp.dt) < 200) {
    temp.dt <- interpolate_spct(temp.dt, length.out = 200)
  }
  if (stepsize(temp.dt)[1] < 0.5) {
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
    temp.dt <- thin_wl(temp.dt, max.wl.step = 5, max.slope.delta = 0.002)
    if (plotting) {
      print(autoplot(temp.dt) + ggtitle(df.name, "Thinned"))
      readline("Next: ")
    }
  }
  print(nrow(temp.dt))
  ams_AS7263.mspct[[df.name]] <- temp.dt
}

ams_AS7263_channels <- names(ams_AS7263.mspct)

ams_AS7263.spct <-
  rbindspct(ams_AS7263.mspct, idfactor = "channel") |> normalise()

autoplot(ams_AS7263.spct)

# descriptor of sensor channels

AS7263_channels.tb <-
  data.frame(ch.no = 1:6,
             module.ch.name = paste("spectralChannel", 1:6, sep = ""),
             sensor.ch.name = c("R", "S", "T", "U", "V", "W"),
             ch.wl.peak = c(610, 680, 730, 760, 810, 860),
             ch.fwhm = rep(35, 6))

# updating a data.frame column by column drops names!
AS7263_channels.named_tb <- list()
for (col in colnames(AS7263_channels.tb)) {
  temp <- AS7263_channels.tb[[col]]
  if (col == "ch.ic.name") {
    names(temp) <- AS7263_channels.tb$module.ch.name
  } else {
    names(temp) <- AS7263_channels.tb$sensor.ch.name
  }
  AS7263_channels.named_tb[[col]] <- I(temp)
}
AS7263_channels.named_tb <- as.data.frame(AS7263_channels.named_tb)
# names(AS7263_channels.named_tb[[2]])

sensor.properties <- list(sensor.name = "AS7263",
                          sensor.supplier = "ams OSRAM",
                          sensor.type = "integrated circuit",
                          sensor.io = "I2C",
                          # module.name = "Yocto-Spectral",
                          # module.supplier = "YoctoPuce",
                          # module.io = "USB",
                          num.channels = 10,
                          output = "digital",
                          channels = AS7263_channels.named_tb)

attr(ams_AS7263.spct, "sensor.properties") <- sensor.properties

what_measured(ams_AS7263.spct) <-
  paste("ams AS7263 Spectral Sensor with 6 NIR channels.",
        "SMD electronic component from ams-OSRAM. 20xx-current.")
how_measured(ams_AS7263.spct) <-
  "Digitized from plot in data sheet from ams-OSRAM with DigitizeIt."
comment(ams_AS7263.spct) <-
  "Data are approximate, not specifications. Provided as examples only"

autoplot(ams_AS7263.spct,
         annotations = c("peak.labels", "colour.guide"))

save(ams_AS7263.spct, file = "./data-raw/ams/ams-AS7263.rda")
