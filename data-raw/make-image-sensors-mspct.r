# collect imaging_sensors.mspct
library(photobiology)
library(ggspectra)
library(dplyr)

rm(list = ls())

photon_as_default()

plotting <- FALSE

# read DigitizeIt CSV file
# the data in these figures are either actual or normalized quantum efficiencies
file.list <- list.files("./data-raw/LUCID", ".*\\.csv", full.names = TRUE)

sensor.properties <-
  list(TRI071S_M = list(model = "IMX428",
                        supplier = "Sony",
                        type = "CMOS image sensor",
                        signal.interface = "SLV",
                        module.model = "Triton TRI071S-M",
                        module.supplier = "LUCID",
                        module.type = "VIS camera",
                        module.interface = "Ethernet 1G POE",
                        channels = "Monochrome"),
       TRT033S_WC = list(model = "IMX992",
                         supplier = "Sony",
                         type = "image sensor",
                         signal.interface = "SLV",
                         module.model = "Triton2 TRT033S-WC",
                         module.supplier = "LUCID",
                         module.type = "VIS + SWIR camera",
                         module.interface = "Ethernet 2.5G POE",
                         channels = "Monochrome"),
       ATX081S_UC = list(model = "IMX487",
                         supplier = "Sony",
                         type = "CMOS image sensor",
                         signal.interface = "SLV",
                         module.model = "Atlas ATX081S-UC",
                         module.supplier = "LUCID",
                         module.type = "UV camera",
                         module.interface = "Ethernet 10G POE",
                         channels = "Monochrome"),
       TRI071S_C = list(model = "IMX428",
                        supplier = "Sony",
                        type = "image sensor",
                        signal.interface = "SLV",
                        module.model = "Triton TRI071S-C",
                        module.supplier = "LUCID",
                        module.type = "RGB camera",
                        module.interface = "Ethernet 1G POE",
                        channels = c("R", "G", "B"))
  )

image_sensors.mspct <- response_mspct()
for (file.name in rev(file.list)) {
  # data object
  cat(basename(file.name), "\n")
  df.name <- gsub(pattern = "\\.csv$",
                  replacement = "", x = basename(file.name),
                  fixed = FALSE) |> gsub("-", "_", x = _)
  temp.df <- read.csv(file.name, header = FALSE, skip = 1,
                      col.names = c("w.length", "s.q.response"),
                      colClasses = "numeric")
  temp.df <- distinct(temp.df)
  temp.df <- group_by(temp.df, w.length)
  temp.dt <- summarize(temp.df, s.q.response = mean(s.q.response))
  setResponseSpct(temp.dt)
  cat(class(temp.dt)[1], "\n\n")
  if (plotting) {
    print(autoplot(temp.dt, annotations = c("+", "title:what:how")))
    readline("Next: ")
  }
  if (nrow(temp.df) > 200) {
    temp.dt <- smooth_spct(temp.dt, method = "supsmu", strength = 2)
  }
  if (nrow(temp.dt) < 200) {
    temp.dt <- interpolate_spct(temp.dt, length.out = 500)
  }
  if (stepsize(temp.dt)[1] < 0.5) {
    temp.dt <- interpolate_spct(temp.dt, length.out = expanse(temp.dt))
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
  print(nrow(temp.dt))
  if (nrow(temp.dt) > 200) {
    temp.dt <- thin_wl(temp.dt, max.wl.step = 3, max.slope.delta = 0.001)
    if (plotting) {
      print(autoplot(temp.dt) + ggtitle(df.name, "Thinned"))
      readline("Next: ")
    }
  }
  camera.code <-
    paste(strsplit(df.name, "_", fixed = TRUE)[[1]][2:3], collapse = "_")
  this.sensor.properties <- sensor.properties[[camera.code]]
  sensor_properties(temp.dt) <- this.sensor.properties

  what_measured(temp.dt) <-
    with(this.sensor.properties,
    paste(module.type, module.model, "from", module.supplier,
          "with", supplier, "image sensor", model))

  how_measured(temp.dt) <-
    "Digitized from on-line plot from LUCID."
  comment(temp.dt) <-
    "Data are approximate due to digitalization, smoothing and \"wavelength-thinning\"."

  print(nrow(temp.dt))
  image_sensors.mspct[[df.name]] <- temp.dt
}

LUCID_TRI071S_C.channels <-
  grepv("LUCID_TRI071S_C_IMX428", names(image_sensors.mspct))

LUCID_TRI071S_C.mspct <- image_sensors.mspct[LUCID_TRI071S_C.channels]
names(LUCID_TRI071S_C.mspct) <-
  gsub("LUCID_TRI071S_C_IMX428_", "", names(LUCID_TRI071S_C.mspct))
LUCID_TRI071S_C.spct <- rbindspct(LUCID_TRI071S_C.mspct, idfactor = "channel")

autoplot(LUCID_TRI071S_C.spct)

image_sensors.mspct <-
  image_sensors.mspct[setdiff(names(image_sensors.mspct),
                              LUCID_TRI071S_C.channels)]
autoplot(image_sensors.mspct, norm = "max",
         annotations = c("peak.labels", "colour.guide"))

image_sensors.mspct[["LUCID_TRI071S_C_IMX428"]] <- LUCID_TRI071S_C.spct

autoplot(image_sensors.mspct, norm = "max",
         annotations = c("peak.labels", "colour.guide"))

save(image_sensors.mspct, file = "./data/image-sensors-mspct.rda")

