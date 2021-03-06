#' Clean raw file from a logging device
#'
#' General clean up and subset of raw file from logger. Currently 
#' implemented for GiPSy-5 micro and B5 GPS loggers and for HOBO data loggers
#'
#' @param file character Path to the raw data file
#' @param outfile character Path to the cleaned file (incl name of file). 
#'  Only used if type = GiPsS-5
#' @param type character Type of the data logger. Either gipsy-5, hobo or b5
#' @param HDOPmax numeric The maximum value of HDOP allowed. Rows with values
#' above this will be removed from the returned data.table and the cleaned file
#' written to disk. Only used if type = GiPsS-5
#' @export
CleanRawFile = function(file = NULL, outfile = NULL, HDOPmax = 3.02, type = NULL) {
	if(is.null(file)) {
		stop('Path to raw file missing')
	}
	if(is.null(type)) {
		stop('Logger type not specified. Use the type argument.\n See ?CleanRawFile')
	}
	if(tolower(type) == 'gipsy-5') {
		star = readLines(file)
		index = c(grep('EVENT', star), grep('Firmware', star))
		star = star[-index]
		res = sapply(star, FUN = TrimTab)
		temp = stringr::str_split(res, pattern = '\t')
		rbtemp = do.call('rbind', temp[-1])
		dt = data.table::as.data.table(rbtemp)
	# Clean up names and set types:
		data.table::setnames(dt, temp[[1]])
		data.table::setnames(dt, old = 'Alt.', new = 'Alt')
		dt[, Longitude:=as.numeric(Longitude)]
		dt[, Latitude:=as.numeric(Latitude)]
		dt[, Alt:=as.numeric(Alt)]
		dt[, Speed:=as.numeric(Speed)]
		dt[, NSat:=as.numeric(NSat)]
		dt[, Dop:=as.numeric(Dop)]
		dt[, GSVsum:=as.numeric(GSVsum)]
		dt[, Date:=lubridate::dmy_hms(paste(Date, Time, sep = ' '))]
		dt = dt[!is.na(Date)]  # in case of parsing error due to recording error.
		dt[, 'Position in file':=NULL]
		dt[, Time:=NULL]
	# Subset:
		no.obs = nrow(dt[Dop >= HDOPmax,])  # Save to cat out later
		dt = dt[Dop < HDOPmax,]
		if(!is.null(outfile)) {
			write.table(dt, file = outfile, row.names = FALSE, sep = '\t')
		}
		cat(paste0(no.obs, ' observations had HDOP values over ', HDOPmax, 
			' and where removed\n'))
		cat('Use the HDOPmax argument to control the cut-off value\n')
		if(is.null(outfile)) {
			cat('No outfile was provided, so no file written\n\n')
		}
		return(dt)
	}
	if(tolower(type) == 'hobo') 
	{
		temp = data.table::fread(file, skip = 1, verbose = FALSE,
			showProgress = FALSE, drop = c(1, 5:9))
		setnames(temp, c('DateTime', 'Temp', 'RH'))
		temp = temp[complete.cases(temp), .(DateTime, Temp, RH)]
		temp[, Time:=stringr::str_sub(DateTime, start = 10, end = 17)]
		temp[, Date:=stringr::str_sub(DateTime, end = 8)]
		temp[, AMPM:=stringr::str_sub(DateTime, start = -2)]
		temp[, Date:=lubridate::mdy(Date)]
		temp[, DateTime:=NULL]
		setcolorder(temp, c('Date', 'Time', 'AMPM', 'Temp', 'RH'))
		return(temp)
	}
	if(tolower(type) == 'b5') {
		dropcols = c('key-bin-checksum', 'start-timestamp', 'used-time-to-get-fix', 'battery-voltage')
		temp = data.table::fread(file, drop = dropcols)
		colnames = c('LoggerID', 'Longitude', 'Latitude', 'Altitude', 'FixType', 'Status', 'TimeStamp',
			'Battery', 'Temperature', 'Speed', 'Heading', 'SpeedAccuracy', 'AltitudeAccuracy')
		setnames(temp, colnames)
		temp[, TimeStamp:=lubridate::ymd_hms(TimeStamp)]
		temp = temp[!is.na(Longitude) & !is.na(Latitude),]
		return(temp)
	}
}

TrimTab = function(x) {
	locs = stringr::str_locate_all(x, '\t')[[1]]
	index = locs[which(diff(locs[,1]) == 1)]
	while(length(index) > 0) {
		stringr::str_sub(x, index[1], index[1]) = ''
		locs = stringr::str_locate_all(x, '\t')[[1]]
		index = locs[which(diff(locs[,1]) == 1)]
	}
	return(x)
}
