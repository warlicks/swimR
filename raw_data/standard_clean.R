standard_clean <- function(data, event_data, division){
	# Set Up slice to deal with D2 swimming 1000
	if(division == 2){
		end<-16
	} else { 
		end <- 15
	}

	# Data manipulation
	data <- dplyr::mutate(data, gender = data[1, ], standard = data[2, ]) %>%
	dplyr::select(swim_time = dplyr:::starts_with("X"), gender, standard) %>%
	dplyr::slice(3:end) %>%
	dplyr::bind_cols(., event_data)
	
	data <- swimR:::time_convert(data)
	
	return(data)
}