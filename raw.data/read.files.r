# read all available sensor data
# assumes that all files with ".csv" are sensor-data files
# uses column names from .csv file
# STEPS
# 1) clear the workspace and set wd to raw.data
# 2) get list of names of .csv files
# 3) loop
# 3a) read one file and generate data.frame and save it to data directory
# 3b) read top of csv fila and append it to a copy of the roxygen template
# 3c) move .r file to R directory
# 4) set wd to package home
#
library(photobiology)
rm(list = ls())
setwd("raw.data")
file.list <- system('ls *.csv', intern=TRUE)
for (file.name in file.list) {
  # data object
  cat(file.name, "\n")
  df.name <- paste(sub(pattern=".csv", replacement="", x=file.name), "spct", sep=".")
  df.name <- gsub(pattern="-", replacement="_", x=df.name)
  temp.dt <- read.csv(file.name, header=TRUE, comment.char="#")
  if (ncol(temp.dt) > 2) {
    temp.dt <- temp.dt[ , 1:2]
  }
  cat(names(temp.dt), "\n")
  setGenericSpct(temp.dt)
  # This loop reduces the number of rows by deleting individual observations
  # This needs to be improved by making the test local to each pair of succesive
  # spectral observations and also take into account steepness of slope. We never
  # remove first or last observation.
  while (length(temp.dt$w.length) > 300) {
         # && max(diff(temp.dt$w.length)) < 5 || min(diff(temp.dt$w.length) < 0.03))
#    temp.dt <- temp.dt[-seq(2, length(temp.dt$w.length) - 1, by = 2), ]
    selector <- seq(2, length(temp.dt$w.length) - 1, by = 2)
#    selector <- selector[c(diff(temp.dt$w.length[-selector]) < 3, TRUE)]
    if (length(selector) < 1) {
      break()
    }
    temp.dt <- temp.dt[-selector]
  }
  setResponseSpct(temp.dt)
  normalize(temp.dt)
  cat(class(temp.dt), "\n\n")
  assign(df.name, temp.dt)
  save(list=df.name, file=paste("../data/", df.name, ".rda", sep=""))
  # .r file with Roxygen2 doccumentation
  r.file.name <- sub(".spct", ".r", df.name, fixed=TRUE)
  shell(paste('cp sensor.data.template.r', r.file.name))
  # the line below does not work under Windows if one uses system instead of shell
  shell(paste("grep -U ^#", file.name, '>>', r.file.name))
  shell(paste('echo NULL >>', r.file.name))
  shell(paste('mv', r.file.name, './../R'))
}
setwd("./..")

