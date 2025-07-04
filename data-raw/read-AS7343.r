# Spectral and multichannel sensors
#

library(photobiology)
library(ggspectra)
library(dplyr)

rm(list = ls())

energy_as_default()

plotting <- TRUE

file.list <- list.files("./data-raw/ams", "*.csv", full.names = TRUE)

ams_AS7343.mspct <- response_mspct()
for (file.name in file.list) {
  # data object
  cat(basename(file.name), "\n")
  df.name <- gsub(pattern = "^AS7343-|\\.csv$",
                       replacement = "", x = basename(file.name),
                       fixed = FALSE)
  temp.df <- read.csv(file.name, header = FALSE, skip = 1,
                      col.names = c("w.length", "s.e.response"),
                      colClasses = "numeric")
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
  if (is_energy_based(temp.dt))
    cat("energy based\n")
  else if (is_photon_based(temp.dt))
    cat("photon based\n")
  else
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
  sensors.mspct[[df.name]] <- temp.dt
}

ams_AS7343_channels <- names(sensors.mspct)
ams_AS7343.spct <- rbindspct(sensors.mspct, idfactor = "channel")
autoplot(ams_AS7343.spct)

what_measured(ams_AS7343.spct) <-
  paste("ams AS7343L Spectral Sensor with 11 VIS channels and 2 NIR channels.",
        "SMD electronic component from ams-OSRAM. 2023-current.")
how_measured(ams_AS7343.spct) <-
  "Digitized from plot in data sheet from ams-OSRAM with DigitizeIt."
comment(ams_AS7343.spct) <-
  "Data are approximate, not specifications. Provided as examples only"

save(ams_AS7343.spct, file = "./data/ams-AS7343.rda")
