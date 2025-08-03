# collect ic_sensors.mspct
library(photobiology)

file.paths <- c(list.files(path = "data-raw/ams/",
                         pattern = "^ams.*\\.[Rr]da$", full.names = TRUE),
                list.files(path = "data-raw/Vishay/",
                           pattern = "^Vishay.*\\.[Rr]da$", full.names = TRUE))

for (f in file.paths) {
  load(f)
}

ic_sensors.mpsct <- collect2mspct()

names(ic_sensors.mpsct) <- gsub("\\.spct$", "", names(ic_sensors.mpsct))

summary(ic_sensors.mpsct)

save(ic_sensors.mpsct, file = "data-raw/ic-sensors-mspct.rda")

