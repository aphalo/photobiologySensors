# read all available sensor data
# assumes that all files with ".csv" are sensor-data files
# uses column names from .csv file
# STEPS
# 1) clear the workspace and set wd to data-raw
# 2) get list of names of .csv files
# 3) loop
#    read one file and generate a response.spct and add it to a list
# 4) generate the indexing vectors
# 5) save all objects to a single .rda file in ./data
#
library(photobiology)
library(dplyr)
rm(list = ls())
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
}

all_sensors <- names(sensors.mspct)

Skye_sensors <- grep("^SK", all_sensors, value = TRUE)
sglux_sensors <- grep("^SG|^TOCON", all_sensors, value = TRUE)
LICOR_sensors <- grep("LI_", all_sensors, value = TRUE)
KIPP_sensors <- grep("^CUV|^PQS|^UVS", all_sensors, value = TRUE)
SolarLight_sensors <- grep("^SL_", all_sensors, value = TRUE)
DeltaT_sensors <- grep("BF5", all_sensors, value = TRUE)
VitalTech_sensors <- grep("^BW", all_sensors, value = TRUE)
ThiesClima_sensors <- grep("^E1c", all_sensors, value = TRUE)
ideal_sensors <- grep("flat", all_sensors, value = TRUE)
Berger_sensors <- grep("Berger", all_sensors, value = TRUE)
Solarmeter_sensors <- grep("^SM", all_sensors, value = TRUE)

uvc_sensors <- c("SG01D_C")
uvb_sensors <- c("SG01D_B", "SM60", "SKU430a", "UVS_B")
erythemal_sensors <- c("UVS_E", "E1c", "SKU440a", "SL_501_high_UVA", "SL_501_low_UVA",  "SL_501_typical", "BW_20", "Berger_UV_Biometer")
uva_sensors <- c("SG01D_A", "SKU421", "SKU421a", "UVS_A")
uv_sensors <- unique(c(uvc_sensors, uvb_sensors, uva_sensors, erythemal_sensors, "SG01L", "CUV_5"))
par_sensors <- c("SKP215", "SKE510", "SKP210", "PQS1", "LI_190", "BF5")
photometric_sensors <- vis_sensors <- c("SKL310", "LI_210")
pyranometer_sensors <- shortwave_sensors <- c("SKS1110", "LI_200")
red_sensors <- c("SKR110_R")
far_red_sensors <- c("SKR110_FR")
blue_sensors <- c("TOCON_blue4")
multichannel_sensors <- c("SKR110_R", "SKR110_FR")

save(sensors.mspct,
     Skye_sensors, sglux_sensors, LICOR_sensors, KIPP_sensors,
     SolarLight_sensors, Solarmeter_sensors, DeltaT_sensors,
     VitalTech_sensors, ThiesClima_sensors, ideal_sensors,
     Berger_sensors,
     uvc_sensors, uvb_sensors, erythemal_sensors, uva_sensors, uv_sensors,
     par_sensors,
     vis_sensors, photometric_sensors,
     shortwave_sensors, pyranometer_sensors,
     red_sensors, far_red_sensors, blue_sensors,
     multichannel_sensors,
     file = "./data/sensors.mspct.rda")

tools::resaveRdaFiles("data", compress="auto")
print(tools::checkRdaFiles("data"))

