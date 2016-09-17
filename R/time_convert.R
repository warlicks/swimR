#' Convert time to duration for calculations.
#'
#' An internal function used in \code{\link{data_clean}}
#'
#' \code{time_convert} is an internal function used in \code{\link{data_clean}} to convert the athletes time from a character type to a variable type that can be used in calculations.  It utilizes \code{\link[lubridate]{lubridate}} to perform the conversion.  

#' @param data The data frame provided in \code{\link{data_clean}}
#' @returns The original data frame with an additiona column for the athletes time of class duration.
#' @seealso \code{\link[lubridate]{duration}}}

time_convert <- function(data){

	# Fix formattig for times 

	## Times Under a Minute
	data <- dplyr::mutate(data, 
		swim_time2 = ifelse(nchar(data[["swim_time"]]) <= 5, 
			paste("00:", data[["swim_time"]], sep = ""), 
			data[["swim_time"]]
		)
	)

	## Times under 10 minutes
	data <- dplyr::mutate(data, 
		swim_time3 = ifelse(nchar(data[["swim_time"]]) == 7, 
			paste("0", data2[["swim_time"]], sep = ""), 
			data[["swim_time2"]]
		)
	)

	# Convert time to duration for comparision ----
	data <- dplyr::mutate(data, 
		swim_time2 = lubridate::ms(data[["swim_time3"]]) 
	)

	data <- dplyr::mutate(data, swim_time2 = lubridate::period_to_seconds(swim_time2)) # Convert to total seconds

	# Clean Up Data
	data <- dplyr::select(data, -swim_time3)

	return(data)
	
}