#' Clean Up USA Swimming Top Times Report
#'
#'\code{clean_swim} prepares the data for easy use.
#'
#' \code{clean_swim} prepares the data for easy use. It starts by selecting only needed columns.  The function also creates a unique ID for each athlete.  Swim times are also convertd from character strings to numeric variable repersenting seconds.
#'
#' All of the operations are performed based on column name.  The column names for the provided data frame need to match the column names from the file downloaded by \code{\link{individual_swims}}.
#'
#' In order to make the data more usable, only needed columns are kept from the orignal data frame.  In addition two columns, \strong{athlete_id} and \strong{swim_time2} are created by the function.  A complete listing of the columns returned by the function can be found below.
#'
#' In order to identify unique athletes a unique identifier is created for each athlete.  The unique id follows the format used by USA Swimming. Bithdate First; 3 letters of first name; first 4 leters of last name. (mm/dd/yyjansmit).  It is stored in the column \strong{athlete_id} .
#'
#' In the top time report downloaded by \code{\link{individual_swims}}, the athlete's time in a races is stored as a character string.  For shorter races, those under a minute, the string has the format "SS.ss".  For races over a minute the character string has the format "MM:SS.ss".
#'
#' Since we typically want to work an athletes time, we need to convert swim time to a numeric format.  In \code{clean_swim} a new column \strong{swim_time2} is created to store converted time.  The athlete's time is repersented in seconds.
#'
#' @param data A data frame with the same column names as the file downloaded by \code{individual_swims}
#'
#' @export
#'
#' @return The function returns a data frame with the following columns:

clean_swim <- function(data){

	# Select only needed data ----
	data <- dplyr::select(data, meet_name, swim_date, team_short_name, 
						  team_code, gender, birth_date, full_name_computed, 
						  full_desc, event_id, swim_time, standard_name)

	## Error Checking
	if(ncol(data) != 11){
		warning("Please check data structure.  Incorrect number of columns.")
		stop()
	}

	# Check that Gender was not read as a logical value.
	## When there are only women in the results, R reads "F" in as FALSE.  
	## When loaded to the DB these results end up as a "0".  

	if (class(data$gender) == "logical"){
		data <- dplyr::mutate(data, gender = as.character(substr(gender, 1, 1)))
	}

	# Create Unique ID for each athlete ----
	data <- id_create(data)

	# Convert time variable to a format that can be used for calculations ----
	data <- time_convert(data)

	# Convert dates in swim date to a format recognizeable by SQLite. 
	data <- clean_swim_date(data)

	return(data)
}
