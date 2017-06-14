#' Query Database for Meet Results
#'
#' Extract Meet Results
#'
#' \code{report_meet_results} queries a SQL database and returns the results all results based on the specified arguments.  The function is flexiable and can gather results swimmers across all of Division 1, within a specific conference or within a team.  It can also produce an individual swimmer's result in each event they have competed in.  
#'
#' The function is similar to \code{\link{report_top_times}}, however it does not restrict the results to only the best result given the provided arguments.  
#'
#' @importFrom magrittr %>%
#'
#' @param con a database connection.
#' @param conference a character vector with the name of an NCAA swimming conference.  If not provided the output include all conferences.
#' @param team_name a character vector with the name of an NCAA swimming conference.  If not provided the output include all teams.
#' @param gender a character vector.  Indicates the output should include men, women or both.  Defaults to "Both".  Other options are "M" for men and "F" for women.
#' @param athlete a character vector with the name or athlete id of a swimmier.  If not provided the results include all swimmers.  The athlete id follows the USA Swimming standard.
#' @param event a character vector with the name of swimming envent.  If not provided the results include all events.
#' 
#'
#' @return a data frame of ranked swimming results.
#'
#' @export

report_meet_results <- function(con,
							conference = 'All',
							team_name = 'All',
							gender = 'Both',
							athlete = NULL,
							event = 'All') {

	# Set up query using the result_query()
	prepared_query <- result_query(conference,
								team_name,
								gender,
								athlete,
								event)
	# Execute Query
	query_resutls <- DBI::dbSendQuery(con, prepared_query)

	## Fetch Results
	results_df <- DBI::dbFetch(query_resutls)
	DBI::dbClearResult(query_resutls)

	results_df <- results_df %>% 
		arrange(TEAM_NAME, 
		        MEET_DATE, 
		        EVENT_NAME, 
		        SWIM_TIME_VALUE, 
		        ATHLETE_NAME)
	return(results_df)
}