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
library(ggspectra)

library(dplyr)
rm(list = ls())

energy_as_default()

plotting <- TRUE

# read pre-built objects for complex ICs
load("data-raw/ic-sensors-mspct.rda")

sensors.mspct <- ic_sensors.mpsct

# read from .csv files data for simpler sensor
file.list <- list.files("./data-raw", "*.csv", full.names = TRUE)
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
  if (nrow(temp.df) > 200) {
    temp.dt <- smooth_spct(temp.dt, method = "supsmu")
  }
  if (nrow(temp.dt) > 10) {
    temp.dt <- normalize(temp.dt)
#    temp.df <- setNormalised(temp.dt)
  } else {
    temp.dt <- interpolate_spct(temp.dt, length.out = 50)
  }
  what_measured(temp.dt) <- paste(gsub("_", " ", df.name), "light sensor")
  how_measured(temp.dt) <- "Digitized from plots in suppliers' literature"
  comment(temp.dt) <-
    "Data are approximate, not specifications. Provided as examples only"
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

all_sensors <- sort(names(sensors.mspct))

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
apogee_sensors <- grep("apogee_", all_sensors, value = TRUE)
specmeters_sensors <- grep("Specmeters_", all_sensors, value = TRUE)
ams_sensors <- grep("ams_", all_sensors, value = TRUE)
vishay_sensors <- grep("Vishay_", all_sensors, value = TRUE)

uvc_sensors <- c("sglux_SG01D_C", "Analytik_Jena_UVX25")
uvb_sensors <- c("sglux_SG01D_B", "Solarmeter_SM60", "Skye_SKU430a", "KIPP_UVS_B",
                 "Analytik_Jena_UVX31", "Vishay_VEML6075_UVB")
erythemal_sensors <- c("KIPP_UVS_E", "Thies_E1c", "Skye_SKU440a",
                       "SolarLight_501_Biometer_high_UVA",
                       "SolarLight_501_Biometer_low_UVA",
                       "SolarLight_501_Biometer_typical",
                       "Vital_BW_20", "Berger_UV_Biometer")
uva_sensors <- c("apogee_su_200", "sglux_SG01D_A", "Skye_SKU421",
                 "Skye_SKU421a", "KIPP_UVS_A", "Analitik_Jena_UVX36",
                 "sglux_custom_UVA1")
uv_sensors <- unique(c(uvc_sensors, uvb_sensors, uva_sensors, erythemal_sensors,
                       "sglux_SG01L", "KIPP_CUV_5"))
par_sensors <- c("apogee_sq_500", "Skye_SKP215", "Skye_SKE510", "Skye_SKP210", "KIPP_PQS1", "LICOR_LI_190", "DeltaT_BF5", "Specmeters_3415F")
epar_sensors <- "apogee_sq_610"
photometric_sensors <- vis_sensors <- c("Skye_SKL310", "LICOR_LI_210")
pyranometer_sensors <- shortwave_sensors <- c("Skye_SKS1110", "LICOR_LI_200", "KIPP_CM21")
red_sensors <- c("Skye_SKR110_R", "apogee_s2_131_R")
far_red_sensors <- c("Skye_SKR110_FR", "apogee_s2_131_FR")
blue_sensors <- c("sglux_TOCON_blue4")
green_sensors <- "sglux_custom_green"
multichannel_sensors <-
  c("Skye_SKR110_R", "Skye_SKR110_FR",
    "apogee_s2_131_R", "apogee_s2_131_FR",
    "Vishay_VEML6075",
    "ams_AS7263", "ams_AS7331", "ams_AS7341", "ams_AS7343", "ams_TSL2591")
electronic_components <- grep("^ams_|TOCON|^Vishay_", all_sensors, value = TRUE)


collected_names <-
  unique(c(skye_sensors, sglux_sensors, licor_sensors, kipp_sensors,
           solarlight_sensors, solarmeter_sensors, deltat_sensors,
           vitaltech_sensors, thiesclima_sensors, ideal_sensors,
           berger_sensors, analytik_sensors, apogee_sensors,
           specmeters_sensors, ams_sensors, vishay_sensors,
           electronic_components,
           uvc_sensors, uvb_sensors, erythemal_sensors, uva_sensors, uv_sensors,
           par_sensors, epar_sensors,
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
     berger_sensors, analytik_sensors, apogee_sensors,
     specmeters_sensors, ams_sensors, vishay_sensors,
     electronic_components,
     uvc_sensors, uvb_sensors, erythemal_sensors, uva_sensors, uv_sensors,
     par_sensors, epar_sensors,
     vis_sensors, photometric_sensors,
     shortwave_sensors, pyranometer_sensors,
     red_sensors, far_red_sensors, blue_sensors, green_sensors,
     multichannel_sensors,
     file = "./data/sensors.mspct.rda")

tools::resaveRdaFiles("data", compress="auto")
print(tools::checkRdaFiles("data"))

