#' Create Unique ID for each athlete.
#'
#' An internal function used by \code{\link{data_clean}}
#'
#' \code{id_create} is an internal function used by \code{\link{data_clean}}.  It creates an unique id for each athlete.  The athlete id follows the format used by USA Swimming. Bithdate First; 3 letters of first name; first 4 leters of last name. (mm/dd/yyjansmit)

#' @param data The data frame provided in \code{\link{data_clean}}
#' @return The function creates a new column 

id_create <- function(data){

	# Prepare First Name ----
	## Split name variable. Returned as a list
	name_list<- strsplit(data$full_name_computed, ", ")

	first_name <- c() # Create vector for first names

	## Extract names from the created list. 
	for(i in 1:length(name_list)){
		first_name[i] <- name_list[[i]][2]
	}

	first_name <- substr(first_name, 1, 3) # Substring First Name
	first_name <- tolower(first_name) # move to lower case for neatness

	# Extract Last Name ----
	last_name <- substr(data$full_name_computed, 1, 4)
	last_name <- tolower(last_name) # Move to lower case for neatness

	# Create complete id ----
	return(dplyr::mutate(data, athlete_id = paste(data$birth_date, first_name, last_name, sep = "")))
}