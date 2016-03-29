#' Reclassify habitat types
#'
#' Reclassify raw habitat types into fewer groups
#'
#' @param Habitat character The habitat type
#' @export
ReclassifyHabitat = function(Habitat = NULL) {
	if(is.null(Habitat)) {
		stop('Input parameter missing')
	}
	Habitat = stringr::str_trim(Habitat, side = 'both')
	switch(EXPR = tolower(Habitat),
			# Starling
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
			# Hare
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
			'13' = 'Stubble',
			'Default')
}

