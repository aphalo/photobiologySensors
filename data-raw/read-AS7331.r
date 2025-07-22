# Spectral and multichannel sensors
#

library(photobiology)
library(ggspectra)
library(dplyr)

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
  temp.df <- read.csv2(file.name, header = FALSE, skip = 1,
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
  ams_AS7331.mspct[[df.name]] <- temp.dt
}

ams_AS7331_channels <- names(ams_AS7331.mspct)
ams_AS7331.spct <- rbindspct(ams_AS7331.mspct, idfactor = "channel")
autoplot(ams_AS7331.spct)

what_measured(ams_AS7331.spct) <-
  paste("ams AS7331 Spectral Sensor with 3 UV channels.",
        "SMD electronic component from ams-OSRAM. 2022-current.")
how_measured(ams_AS7331.spct) <-
  "Digitized from plot in data sheet from ams-OSRAM with DigitizeIt."
comment(ams_AS7331.spct) <-
  "Data are approximate, not specifications. Provided as examples only"

save(ams_AS7331.spct, file = "./data/ams-AS7331.rda")
