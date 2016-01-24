#' Expand grid of availability points
#'
#' Expand a grid of availability points over an area defined by a spatial 
#' polygon (or other spatial object)
#'
#' @param polygon SpatialPolygon Object defining the area over which the grid
#' will be expanded. Typically this will be a shape file of study area with 
#' different habitat categories defined.
#' @param gridsize numeric Size of the grid (in meters)
#' @export
ExpandAvailGrid = function(polygons = NULL, gridsize = NULL) {
	if(any(is.null(polygons), is.null(gridsize))){
		stop('Input parameter missing')
	}
	utm32 = sp::CRS("+proj=utm +zone=32 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
	longlat = sp::CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')
	polygonsUtm = sp::spTransform(polygons, utm32)
	bounds = sp::bbox(polygonsUtm)
	xvals = seq(bounds[1,1], bounds[1,2], by = gridsize)
	yvals = seq(bounds[2,1], bounds[2,2], by = gridsize)
	availPoints = expand.grid(xvals, yvals)
	sp::coordinates(availPoints) = ~Var1+Var2
	sp::proj4string(availPoints) = utm32
	avll = sp::spTransform(availPoints, longlat)
	return(avll)
}
