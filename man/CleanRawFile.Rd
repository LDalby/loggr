% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CleanRawFile.r
\name{CleanRawFile}
\alias{CleanRawFile}
\title{Clean raw file from a logging device}
\usage{
CleanRawFile(file = NULL, outfile = NULL, HDOPmax = 3.02, type = NULL)
}
\arguments{
\item{file}{character Path to the raw data file}

\item{outfile}{character Path to the cleaned file (incl name of file). 
Only used if type = GiPsS-5}

\item{HDOPmax}{numeric The maximum value of HDOP allowed. Rows with values
above this will be removed from the returned data.table and the cleaned file
written to disk. Only used if type = GiPsS-5}

\item{type}{character Type of the data logger. Either gipsy-5, hobo or b5}
}
\description{
General clean up and subset of raw file from logger. Currently 
implemented for GiPSy-5 micro and B5 GPS loggers and for HOBO data loggers
}

