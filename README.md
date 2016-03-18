# loggr
[![Travis-CI Build Status](https://travis-ci.org/LDalby/loggr.svg?branch=master)](https://travis-ci.org/LDalby/loggr)

*loggr* is in very early development. Use with caution.


## Installation
Installing the latest version of *loggr* requires having the [*devtools*](https://cran.r-project.org/web/packages/devtools/index.html) package installed. Make sure you have that (on Win you need to install [*RTools*](https://cran.r-project.org/bin/windows/Rtools/) first) and then simply run the lines below:
```s
library(devtools)
install_github('LDalby/loggr')
```

## Use
A short example of using the CleanRawFile function to clean output from HOBO data loggers. In this example you have a bunch of data logger files sitting in a folder containing only logger files. It is assumed that the last 12 characters of the file name is date and extension. If this is not the case the code will break...

The *beginendfile* file is a file with the three columns: BiotopID, start & stop. It is indicating the start and stop dates for each logger. To avoid the data which may have been recorded before deployment of the device. 

```s
# Clean HOBO loggers
library(loggr)
pathtologgers = INSERT PATH TO DIRECTORY
files = dir(pathtologgers)
LoggerList = vector('list', length(files))
beginendfile = fread(INSERT PATH TO START STOP)
for (i in seq_along(files)) {
	path = paste0(pathtologgers, files[i])
	temp = CleanRawFile(file = path, type = 'hobo')
	id = stringr::str_sub(files[i], end = -12)
	temp[, ID:=id]
	start = beginendfile[BiotopID == id, start]
	stop = beginendfile[BiotopID == id, stop]
	LoggerList[[i]] = temp[Date >= mdy(start) & Date <= mdy(stop),]
}
final = do.call('rbind', LoggerList)
write.table(final, file = PATH AND FILE NAME, sep = '\t',
	row.names = FALSE, quote = FALSE)
```
