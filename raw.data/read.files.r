# read all available filter data
# assumes that all files with ".txt" are filter-data files
# assumes that all files with exactly four columns have two replicate measurements that need
# to be averaged
# STEPS
# 1) clear the workspace
# 2) read .txt files
# 3) save all the data.frames created into a single Rda file in data folder
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
  system(paste('cp sensor.data.template.r', r.file.name))
  system(paste("grep -U ^#", file.name, '>>', r.file.name))
  system(paste('echo "NULL/n" >>', r.file.name))
}
setwd("./..")

