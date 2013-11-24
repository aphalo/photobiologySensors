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
rm(list = ls())
setwd("raw.data")
file.list <- system('ls *.csv', intern=TRUE)
for (file.name in file.list) {
  # data object
  df.name <- paste(sub(pattern=".csv", replacement="", x=file.name), "data", sep=".")
  df.name <- gsub(pattern="-", replacement="_", x=df.name)
  assign(df.name, read.csv(file.name, header=TRUE, comment.char="#"))
  save(list=df.name, file=paste("../data/", df.name, ".rda", sep=""))
  # .r file with Roxygen2 doccumentation
  r.file.name <- sub(".csv", ".r", file.name, fixed=TRUE)
  shell(paste('cp sensor.data.template.r', r.file.name))
  # the line below does not work under Windows if one uses system instead of shell
  shell(paste("grep -U ^#", file.name, '>>', r.file.name))
  shell(paste('echo "NULL" >>', r.file.name))
  shell(paste('mv', r.file.name, './../R'))
}
setwd("./..")

