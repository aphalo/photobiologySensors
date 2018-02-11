# read all available sensor data
# assumes that all files with ".csv" are sensor-data files
# uses column names from .csv file
# STEPS
# 1) clear the workspace and set wd to data-raw
# 2) get list of names of .csv files
# 3) loop
# 3a) read one file and generate data.frame and save it to data directory
# 3b) read top of csv fila and append it to a copy of the roxygen template
# 3c) move .r file to R directory
# 4) set wd to package home
#
library(photobiology)
library(dplyr)
rm(list = ls())
# setwd("data-raw")
file.list <- list.files("./data-raw", "*.csv", full.names = TRUE)
sensors.mspct <- list()
for (file.name in file.list) {
  # data object
  cat(basename(file.name), "\n")
  df.name <- paste(sub(pattern = ".csv",
                       replacement = "", x = basename(file.name),
                       fixed = TRUE),
                   "spct", sep=".")
  df.name <- sub(".spct", "", df.name, fixed=TRUE)
  df.name <- gsub(pattern = "-", replacement = "_", x = df.name)
  df.name <- sub("LI_COR_LI", "LI", df.name, fixed=TRUE)
  df.name <- sub("Skye_SK", "SK", df.name, fixed=TRUE)
  df.name <- sub("sglux_SG", "SG", df.name, fixed=TRUE)
  df.name <- sub("sglux_TOCON", "TOCON", df.name, fixed=TRUE)
  df.name <- sub("Solar_Light_", "SL_", df.name, fixed=TRUE)
  df.name <- sub("DeltaT_", "", df.name, fixed=TRUE)
  df.name <- sub("KIPP_", "", df.name, fixed=TRUE)
  df.name <- sub("Solarmeter_", "", df.name, fixed=TRUE)
  df.name <- sub("Thies_", "", df.name, fixed=TRUE)
  df.name <- sub("Vital_", "", df.name, fixed=TRUE)
  if (grepl(".old", df.name)) {
    next()
  }
  temp.df <- read.csv(file.name, header = TRUE, comment.char = "#")
  if (ncol(temp.df) > 2) {
    temp.df <- temp.df[ , 1:2]
  }
  temp.df <- group_by(temp.df, w.length)
  if (exists("s.e.response", temp.df, inherits = FALSE)) {
    temp.dt <- summarize(temp.df, s.e.response = mean(s.e.response))
  } else {
    temp.dt <- summarize(temp.df, s.q.response = mean(s.q.response))
  }
  cat(names(temp.dt), "\n")
  setResponseSpct(temp.dt)
  #
  if (stepsize(temp.dt)[1] < 0.5) {
    temp.dt <- interpolate_spct(temp.dt, length.out = spread(temp.dt) * 2)
  }
  cat(class(temp.dt), "\n\n")
  sensors.mspct[[df.name]] <- temp.dt
#  save(list = df.name, file=paste("../data/", df.name, ".rda", sep=""))
  # .r file with Roxygen2 doccumentation
  # r.file.name <- sub(".spct", ".r", df.name, fixed=TRUE)
  # shell(paste('cp sensor.data.template.r', r.file.name))
  # # the line below does not work under Windows if one uses system instead of shell
  # shell(paste("grep -U ^#", file.name, '>>', r.file.name))
  # shell(paste('echo NULL >>', r.file.name))
  # shell(paste('mv', r.file.name, './../R'))
}

all_sensors <- names(sensors.mspct)

Skye_sensors <- grep("^SK", all_sensors, value = TRUE)
sglux_sensors <- grep("^SG|^TOCON", all_sensors, value = TRUE)
LICOR_sensors <- grep("LI_", all_sensors, value = TRUE)
KIPP_sensors <- grep("^CUV|^PQS|^UVS", all_sensors, value = TRUE)
SolarLight_sensors <- grep("^SL_", all_sensors, value = TRUE)
DeltaT_sensors <- grep("DeltaT", all_sensors, value = TRUE)
VitalTech_sensors <- grep("^BW", all_sensors, value = TRUE)
ThiesClima_sensors <- grep("^E1c", all_sensors, value = TRUE)
ideal_sensors <- grep("flat", all_sensors, value = TRUE)
Berger_sensors <- grep("Berger", all_sensors, value = TRUE)
Solarmeter_sensors <- grep("^SM", all_sensors, value = TRUE)

save(sensors.mspct,
     Skye_sensors, sglux_sensors, LICOR_sensors, KIPP_sensors,
     SolarLight_sensors, Solarmeter_sensors, DeltaT_sensors,
     VitalTech_sensors, ThiesClima_sensors, ideal_sensors,
     Berger_sensors,
     file = "./data/sensors.mspct.rda")

