# Spectral and multichannel sensors
#

library(photobiology)
library(ggspectra)
library(dplyr)

rm(list = ls())

energy_as_default()

plotting <- TRUE

# read DigitizeIt CSV file
file.list <- list.files("./data-raw/ams", "AS7341.*\\.csv", full.names = TRUE)

ams_AS7341.mspct <- response_mspct()
for (file.name in rev(file.list)) {
  # data object
  cat(basename(file.name), "\n")
  df.name <- gsub(pattern = "^AS7341-|\\.csv$",
                  replacement = "", x = basename(file.name),
                  fixed = FALSE)
  temp.df <- read.csv(file.name, header = FALSE, skip = 1,
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
  ams_AS7341.mspct[[df.name]] <- temp.dt
}

ams_AS7341_channels <- names(ams_AS7341.mspct)

ams_AS7341.spct <-
  rbindspct(ams_AS7341.mspct, idfactor = "channel") |> normalise()

autoplot(ams_AS7341.spct)

# descriptor of sensor channels

AS7341_channels.tb <-
  data.frame(ch.no = 1:10,
             module.ch.name = paste("spectralChannel", 1:10, sep = ""),
             sensor.ch.name = c("F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "Clear", "NIR"),
             ch.wl.peak = c(415, 445, 480, 515, 555, 590, 630, 680, NA, 910),
             ch.fwhm = c(26, 30, 36, 39, 39, 40, 50, 52, NA, NA))

# updating a data.frame column by column drops names!
AS7341_channels.named_tb <- list()
for (col in colnames(AS7341_channels.tb)) {
  temp <- AS7341_channels.tb[[col]]
  if (col == "ch.ic.name") {
    names(temp) <- AS7341_channels.tb$module.ch.name
  } else {
    names(temp) <- AS7341_channels.tb$sensor.ch.name
  }
  AS7341_channels.named_tb[[col]] <- I(temp)
}
AS7341_channels.named_tb <- as.data.frame(AS7341_channels.named_tb)
# names(AS7341_channels.named_tb[[2]])

sensor.properties <- list(sensor.name = "AS7341",
                          sensor.supplier = "ams OSRAM",
                          sensor.type = "integrated circuit",
                          sensor.io = "I2C",
                          # module.name = "Yocto-Spectral",
                          # module.supplier = "YoctoPuce",
                          # module.io = "USB",
                          num.channels = 10,
                          output = "digital",
                          channels = AS7341_channels.named_tb)

attr(ams_AS7341.spct, "sensor.properties") <- sensor.properties

what_measured(ams_AS7341.spct) <-
  paste("ams AS7341 Spectral Sensor with 11 VIS channels and 2 NIR channels.",
        "SMD electronic component from ams-OSRAM. 2023-current.")
how_measured(ams_AS7341.spct) <-
  "Digitized from plot in data sheet from ams-OSRAM with DigitizeIt."
comment(ams_AS7341.spct) <-
  "Data are approximate, not specifications. Provided as examples only"

autoplot(ams_AS7341.spct,
         annotations = c("peak.labels", "colour.guide"))

save(ams_AS7341.spct, file = "./data-raw/ams/ams-AS7341.rda")
