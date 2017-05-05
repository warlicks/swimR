#' Query For Counting Athletes Per Team
#'
#' Get a count of athletes by team.
#'
#' @importFrom magrittr %>%
#'
#' @param con A database connection.
#' @param team_name A character vector with the name of an NCAA swimming conference.
#'
#' @return a data frame with the count on athletes by gender
#' @export
athlete_count <- function(con, 
                          team_name){
	# Set Up Query
	athlete_query <- "
	Select
		GENDER,
		COUNT(DISTINCT A.ID) As C1

	From Athlete A
		Inner Join Team T 
			On A.TEAM_ID = T.ID
	
	Where 
		TEAM_FILLER

	Group By
		GENDER
	"
	# Prepare QUERY for selected team
	team_string <- paste('TEAM_NAME = ', "'", team_name, "'", sep = "")
	prepared_query <- gsub('TEAM_FILLER', team_string, athlete_query)

	# Execute Query
	query_resutls <- DBI::dbSendQuery(con, prepared_query)

	## Fetch Results
	athlete_counts <- DBI::dbFetch(query_resutls)
	DBI::dbClearResult(query_resutls)

	# Return Resutls
	return(athlete_counts)
}