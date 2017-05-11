#' Determine the number NCAA Swimming Championship qualifiers
#'
#' Determine the number NCAA Swimming Championship qualifiers
#'
#' \code{report_top_times} queries a SQL database to produce a ranking of swimmers in the specified events.  The function is flexiable and can rank swimmers across all of Division 1, within a specific conference or within a team.  It can also produce an individual swimmer's best result in each event they have competed in.
#' 
#' When producing the count the function aggregates along the specified
#' arguments.  If left at the defult the argument is not included in the
#' aggregate grouping.  
#'
#' @importFrom magrittr %>%
#'
#' @param con a database connection.
#' @param conference a character vector with the name of an NCAA swimming conference.  If not provided the output include all conferences.
#' @param team_name A character vector with the name of an NCAA swimming conference.  If not provided the output include all teams.
#' @param gender a character vector.  Indicates the output should include men, women or both.  Defaults to "Both".  Other options are "M" for men and "F" for women.
#' @param athlete a character vector with the name or athlete id of a swimmier.  If not provided the results include all swimmers.  The athlete id follows the USA Swimming standard.
#' @param event a character vector with the name of swimming envent.  If not provided the results include all events.
#'
#'
#' @return a data frame providing a count of ncaa qualifiers aggregated 
#' according to the arguments provided.  
#'
#' @export

report_ncaa_qualifiers <- function(con,
							conference = 'All',
							team_name = 'All',
							gender = 'Both',
							athlete = NULL,
							event = 'All'){

	prepared_query <- best_time_query(conference,
								team_name,
								gender,
								athlete,
								event)
	# Execute Query
	query_resutls <- DBI::dbSendQuery(con, prepared_query)

	## Fetch Results
	top_times_df <- DBI::dbFetch(query_resutls)
	DBI::dbClearResult(query_resutls)

	# Filter to just NCAA qualifiers
	ncaa_qualifers <- dplyr::filter(top_times_df, SWIM_TIME_VALUE <= B_CUT)
	ncaa_qualifers <- dplyr::mutate(ncaa_qualifers, 
	                                STANDARD = case_when(
	                                		"SWIM_TIME_VALUE" <= "A_CUT" ~ 'A',
	                                		"SWIM_TIME_VALUE" > "A_CUT" ~ 'B'
	                                			)
									)

	# Set Up Group By
	aggregate_groups <- c('GENDER', 'STANDARD')
	if(conference != 'All'){
		aggregate_groups <- append(aggregate_groups, 'CONFERENCE_NAME')
	}
	if(team_name != 'ALL'){
		aggregate_groups <- append(aggregate_groups, 'TEAM_NAME')
	}

	if(event != 'All'){
		aggregate_groups <- append(aggregate_groups, 'EVENT_NAME')
	} 

	ncaa_qualifers <- dplyr::group_by_(ncaa_qualifers, 
	                                   .dots = aggregate_groups)
	ncaa_qualifers <- dplyr::summarise(ncaa_qualifers, n())
}