#' Clean raw file from a logging device
#'
#' General clean up and subset of raw file from logger. Currently only
#' implemented for GiPSy-5 micro GPS dataloggers.
#'
#' @param file character Path to the raw data file
#' @param outfile character Path to the cleaned file (incl name of file)
#' @export
CleanRawFile = function(file, outfile) {
	any(is.null(file), is.null(outfile))
	{
		stop('Input paramter missing. Please supply both file and outfile')
	}
	star = readLines(file)
	index = c(grep('EVENT', star), grep('Firmware', star))
	star = star[-index]
	res = sapply(star, FUN = TrimTab)
	writeLines(res, outfile)
}

TrimTab = function(x) {
	locs = stringr::str_locate_all(x, '\t')[[1]]
	index = locs[which(diff(locs[,1]) == 1)]
	while(length(index) > 0){
		stringr::str_sub(x, index[1], index[1]) = ''
		locs = stringr::str_locate_all(x, '\t')[[1]]
		index = locs[which(diff(locs[,1]) == 1)]
	}
	return(x)
}
