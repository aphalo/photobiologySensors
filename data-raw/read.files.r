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

energy_as_default()

file.list <- list.files("./data-raw", "*.csv", full.names = TRUE)
sensors.mspct <- response_mspct()
for (file.name in file.list) {
  # data object
  cat(basename(file.name), "\n")
  df.name <- paste(sub(pattern = ".csv",
                       replacement = "", x = basename(file.name),
                       fixed = TRUE),
                   "spct", sep=".")
  df.name <- sub(".spct", "", df.name, fixed=TRUE)
  df.name <- gsub(pattern = "-", replacement = "_", x = df.name)
  df.name <- sub("Solar_Light_501", "SolarLight_501_Biometer", df.name, fixed=TRUE)
  df.name <- sub("LI_COR", "LICOR", df.name, fixed=TRUE)
  # df.name <- sub("Skye_SK", "SK", df.name, fixed=TRUE)
  # df.name <- sub("sglux_SG", "SG", df.name, fixed=TRUE)
  # df.name <- sub("sglux_TOCON", "TOCON", df.name, fixed=TRUE)
  # df.name <- sub("Solar_Light_", "SL_", df.name, fixed=TRUE)
  # df.name <- sub("DeltaT_", "", df.name, fixed=TRUE)
  # df.name <- sub("KIPP_", "", df.name, fixed=TRUE)
  # df.name <- sub("Solarmeter_", "", df.name, fixed=TRUE)
  # df.name <- sub("Thies_", "", df.name, fixed=TRUE)
  # df.name <- sub("Vital_", "", df.name, fixed=TRUE)
  if (grepl(".old", df.name)) {
    next()
  }
  temp.df <- read.csv(file.name, header = TRUE, comment.char = "#")
  if (ncol(temp.df) > 2) {
    temp.df <- temp.df[ , 1:2]
  }
  if (grepl("Analytik", df.name)) {
    temp.df$s.e.response <- 10^temp.df$s.e.response
  }
  temp.df <- group_by(temp.df, w.length)
  if (exists("s.e.response", temp.df, inherits = FALSE)) {
    temp.dt <- summarize(temp.df, s.e.response = mean(s.e.response))
  } else {
    temp.dt <- summarize(temp.df, s.q.response = mean(s.q.response))
  }
  cat(names(temp.dt), "\n")
  setResponseSpct(temp.dt)
  if (is_energy_based(temp.dt))
    cat("energy based\n")
  else if (is_photon_based(temp.dt))
    cat("photon based\n")
  else
    cat("wrong base\n")
  #
  if (stepsize(temp.dt)[1] < 0.5) {
    temp.dt <- interpolate_spct(temp.dt, length.out = expanse(temp.dt) * 2)
  }
  cat(class(temp.dt), "\n\n")
  sensors.mspct[[df.name]] <- temp.dt
}

all_sensors <- names(sensors.mspct)

skye_sensors <- grep("Skye_", all_sensors, value = TRUE)
sglux_sensors <- grep("sglux_", all_sensors, value = TRUE)
licor_sensors <- grep("LICOR_", all_sensors, value = TRUE)
kipp_sensors <- grep("KIPP_", all_sensors, value = TRUE)
solarlight_sensors <- grep("^SL_", all_sensors, value = TRUE)
deltat_sensors <- grep("DeltaT", all_sensors, value = TRUE)
vitaltech_sensors <- grep("Vital_", all_sensors, value = TRUE)
thiesclima_sensors <- grep("Thies_", all_sensors, value = TRUE)
ideal_sensors <- grep("flat", all_sensors, value = TRUE)
berger_sensors <- grep("Berger", all_sensors, value = TRUE)
solarmeter_sensors <- grep("Solarmeter_", all_sensors, value = TRUE)
solarlight_sensors <- grep("SolarLight_", all_sensors, value = TRUE)
analytik_sensors <- grep("Analytik_", all_sensors, value = TRUE)

uvc_sensors <- c("sglux_SG01D_C", "Analytik_Jena_UVX25")
uvb_sensors <- c("sglux_SG01D_B", "Solarmeter_SM60", "Skye_SKU430a", "KIPP_UVS_B", "Analytik_Jena_UVX31")
erythemal_sensors <- c("KIPP_UVS_E", "Thies_E1c", "Skye_SKU440a", "SolarLight_501_Biometer_high_UVA", "SolarLight_501_Biometer_low_UVA",  "SolarLight_501_Biometer_typical", "Vital_BW_20", "Berger_UV_Biometer")
uva_sensors <- c("sglux_SG01D_A", "Skye_SKU421", "Skye_SKU421a", "KIPP_UVS_A", "Analitik_Jena_UVX36")
uv_sensors <- unique(c(uvc_sensors, uvb_sensors, uva_sensors, erythemal_sensors, "sglux_SG01L", "KIPP_CUV_5"))
par_sensors <- c("Skye_SKP215", "Skye_SKE510", "Skye_SKP210", "KIPP_PQS1", "LICOR_LI_190", "DeltaT_BF5")
photometric_sensors <- vis_sensors <- c("Skye_SKL310", "LICOR_LI_210")
pyranometer_sensors <- shortwave_sensors <- c("Skye_SKS1110", "LICOR_LI_200")
red_sensors <- c("Skye_SKR110_R")
far_red_sensors <- c("Skye_SKR110_FR")
blue_sensors <- c("sglux_TOCON_blue4")
multichannel_sensors <- c("Skye_SKR110_R", "Skye_SKR110_FR")

collected_names <- unique(c(skye_sensors, sglux_sensors, licor_sensors, kipp_sensors,
                               solarlight_sensors, solarmeter_sensors, deltat_sensors,
                               vitaltech_sensors, thiesclima_sensors, ideal_sensors,
                               berger_sensors, analytik_sensors,
                               uvc_sensors, uvb_sensors, erythemal_sensors, uva_sensors, uv_sensors,
                               par_sensors,
                               vis_sensors, photometric_sensors,
                               shortwave_sensors, pyranometer_sensors,
                               red_sensors, far_red_sensors, blue_sensors,
                               multichannel_sensors))

length(collected_names) == length(names(sensors.mspct))

length(collected_names)
length(names(sensors.mspct))

setdiff(collected_names, names(sensors.mspct))

save(sensors.mspct,
     skye_sensors, sglux_sensors, licor_sensors, kipp_sensors,
     solarlight_sensors, solarmeter_sensors, deltat_sensors,
     vitaltech_sensors, thiesclima_sensors, ideal_sensors,
     berger_sensors, analytik_sensors,
     uvc_sensors, uvb_sensors, erythemal_sensors, uva_sensors, uv_sensors,
     par_sensors,
     vis_sensors, photometric_sensors,
     shortwave_sensors, pyranometer_sensors,
     red_sensors, far_red_sensors, blue_sensors,
     multichannel_sensors,
     file = "./data/sensors.mspct.rda")

tools::resaveRdaFiles("data", compress="auto")
print(tools::checkRdaFiles("data"))

