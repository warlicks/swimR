#' Clean up dates in USA Swimming data download  
#'
#' Clean up dates
#' @param x a data frame in the format downloaded from USA swimmings top times report.
#' @keywords internal


clean_swim_date <- function(x){
	# Replace / with -
	x <- dplyr::mutate(x, swim_date = gsub("/", "-", swim_date))
	
	# Convert to date format
	x <- dplyr::mutate(x, swim_date = as.Date(swim_date, "%m-%d-%Y"))
	
	# Coerce back to character
	x <- dplyr::mutate(x, swim_date = as.character(swim_date))

	return(x)
}