#' Query Database for Event Rankings
#'
#' Extract Top Times
#'
#' \code{report_top_times} queries a SQL database to produce a ranking of swimmers in the specified events.  The function is flexiable and can rank swimmers across all of Division 1, within a specific conference or within a team.  It can also produce a ranking of an individual swimmer's resutls.
#'
#' @importFrom magrittr %>%
#'
#' @param con a database connection.
#' @param conference a character vector with the name of an NCAA swimming conference.  If not provided the output include all conferences.
#' @param team_name A character vector with the name of an NCAA swimming conference.  If not provided the output include all teams.
#' @param team_code a character vector with the team code of an NCAA swimming team  If not provided the output include all teams.
#' @param gender a character vector.  Indicates the output should include men, women or both.  Defaults to "Both".  Other options are "M" for men and "F" for women.
#' @param athlete a character vector with the name or athlete id of a swimmier.  If not provided the results include all swimmers.  The athlete id follows the USA Swimming standard.
#' @param event a character vector with the name of swimming envent.  If not provided the results include all events.
#' @param multiple_results a boolean indicator that determines if multiple results for the same athlete in a single event should be included in the output.
#' @param top an integer indicating how many results to return per event.
#'
#' @return a data frame of ranked swimming results.
#'
#' @export


report_top_times <- function(con,
							conference = NULL,
							team_name = NULL,
							team_code = NULL,
							gender = 'Both',
							athlete = NULL,
							event = 'All',
							multiple_results = TRUE,
							top = 3){
	# Prepare Query
	prepared_query <- query_prep(conference,
								team_name,
								team_code,
								gender,
								athlete,
								event)
	#print(prepared_query)

	# Execute Query
	query_resutls <- DBI::dbSendQuery(con, prepared_query)

	## Fetch Results
	top_times_df <- DBI::dbFetch(query_resutls)
	DBI::dbClearResult(query_resutls)

	## Prepare Group By
	aggregate_groups <- c('EVENT')


	if(!is.null(conference)){
		aggregate_groups <- append(aggregate_groups, 'CONFERENCE')
	}
	if(!is.null(team_name)){
		aggregate_groups <- append(aggregate_groups, 'TEAM_NAME')
	}
	if(!is.null(team_code)){
		aggregate_groups <- append(aggregate_groups, 'TEAM_NAME')
	}
	if(gender == 'Both'){
		aggregate_groups <- append(aggregate_groups, 'GENDER')
	}
	if(!is.null(athlete)){
		aggregate_groups <- append(aggregate_groups, 'ATHLETE_NAME')
	}

	# Select each athletes top time if we only want 1 entry per athlete.
	if(multiple_results == FALSE){
		#top_times_df <- top_times_df %>%
		top_times_df <- dplyr::group_by(top_times_df, ATHLETE_NAME, EVENT)
		top_times_df <- dplyr::mutate(top_times_df,
							ATHLETE_RANK = dense_rank(SWIM_TIME_VALUE)
						)
		top_times_df <- dplyr::filter(top_times_df, ATHLETE_RANK == 1)
		top_times_df <- dplyr::ungroup(top_times_df)
	}

	#top_times_df <- top_times_df %>%
	top_times_df <- dplyr::group_by_(top_times_df, .dots = aggregate_groups)
	top_times_df <- dplyr::mutate(top_times_df,
						RANK = dense_rank(SWIM_TIME_VALUE)
					)
	top_times_df <- dplyr::filter(top_times_df, RANK <= top)


	return(top_times_df)
}
