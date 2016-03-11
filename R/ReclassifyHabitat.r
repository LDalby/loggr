#' Reclassify habitat types
#'
#' Reclassify raw habitat types into few groups
#'
#' @param Habitat character The habitat type
#' @export
ReclassifyHabitat = function(Habitat) {
	Habitat = stringr::str_trim(Habitat, side = 'both')
	switch(EXPR = tolower(Habitat),
		'winter wheat' = 'wintercrop',
		'winter rye' = 'wintercrop',
		'bar mark' = 'baresoil',
		'fold' = 'grazed',
		'eng/mose' = 'tallgrass',
		'high grass' = 'tallgrass',
		'skov' = 'forest',	
		'spring barley' = 'springcrop',  
		'spring oat' = 'springcrop',
		'farm' = 'farm',
		'grass' = 'grass',
		# Default
		'SomeFunkyCrop')
}

