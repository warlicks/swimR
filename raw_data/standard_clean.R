#' An function to clean up qualifying time pulled from Swimswam.  It is an internal function used inside cut_times.
#'
#' It takes the data returned from the HTML table and mainipulates it into a data frame. 
#'

standard_clean <- function(data, event_data, division){
	# Set Up slice to deal with D2 swimming 1000 @ NCAA
	if(division == 2){
		end<-16
	} else { 
		end <- 15
	}

	# Data manipulation
	data <- dplyr::mutate(data, gender = data[1, ], standard = data[2, ]) %>% 
		# Create gender and standard columns
	dplyr::select(swim_time = dplyr:::starts_with("X"), gender, standard) %>%\	# Create Swim Time
	dplyr::slice(3:end) %>% # Select only needed rows by postion
	dplyr::bind_cols(., event_data) # Add event names as a colum in the data. 
	
	data <- swimR:::time_convert(data) # Convert time so second so we can do math. 
	
	return(data)
}