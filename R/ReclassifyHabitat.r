#' Reclassify habitat types
#'
#' Reclassify raw habitat types into few groups
#'
#' @param Habitat character The habitat type
#' @param type character The project - either starling or hare
#' @export
ReclassifyHabitat = function(Habitat = NULL, type = NULL) {
	if(any(is.null(Habitat), is.null(type))){
		stop('Input parameter missing')
	}
	Habitat = stringr::str_trim(Habitat, side = 'both')
	if(tolower(type) == 'starling') {
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
	if(tolower(type) == 'hare'){
		switch(EXPR = as.character(Habitat),
			'1' = 'Beans',
			'2' = 'Oat',
			'3' = 'Wheat',
			'4' = 'Rape',
			'5' = 'WinterBarley',
			'6' = 'Barley',
			'7' = 'SetAside',
			'8' = 'Grasing',
			'9' = 'HayGrass',
			'10' = 'Remise',
			'11' = 'Vildtager',
			'12' = 'WinterWheat',
			'13' = 'Stubble')
	}
}

