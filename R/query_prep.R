#' Prepare SQL Query
#'
#' The function prepares a SQL query based on the parameters provided.
#'
#' @param conference a character vector with the name of an NCAA swimming conference.  If not provided the results include all conferences.
#' @param team_name A character vector with the name of an NCAA swimming conference.  If not provided the results include all teams
#' @param team_name a character vector with the team code of an NCAA swimming team  If not provided the results include all teams
#' @param athlete a character vector with the name or athlete id of a swimmier.  If not provided the results include all swimmers.  The athlete id follows the USA Swimming standard.
#' @param gender a character vector.  Indicates the output should include men, women or both.  Defaults to "Both".  Other options are "M" for men and "F" for women.
#' @param event a character vector with the name of swimming envent.  If not provided the results include all events.
#'
#' @keywords internal
#'

query_prep <- function(conference = NULL,
					  team_name = NULL,
					  team_code = NULL,
					  gender = 'Both',
					  athlete = NULL,
					  event = 'All')
{
	# Set Up Basic Query Structure
	top_time_query <- '
	Select
		ATHLETE_NAME,
		GENDER,
		TEAM_NAME,
		TEAM_CODE,
		E.NAME As "CONFERENCE",
		"EVENT",
		SWIM_TIME_TEXT,
		SWIM_TIME_VALUE

	FROM Result A
		INNER JOIN ATHLETE B ON A.Athlete_ID = B.ID
		INNER JOIN EVENT C ON A.EVENT_ID = C.ID
		INNER JOIN TEAM D ON B.TEAM_ID = D.ID
		INNER JOIN CONFERENCE E ON D.CONFERENCE_ID = E.ID

	WHERE
		CONFERENCE_NAME
		GENDER_FILLER
		TEAM_FILLER
		CODE_FILLER
		ATHELTE_FILLER
		EVENT_FILLER
	'

	# Update query based on arguments

	## Conference Argument
	if(is.null(conference)){
		prepared_query <- sub('CONFERENCE_NAME', "", top_time_query)
	} else {
		conf_string <- paste("E.NAME IN ('",
							 paste(conference, collapse = "', '"),
							 "')",
							sep = "")

		prepared_query <- sub('CONFERENCE_NAME', conf_string, top_time_query)
	}

	## GENDER Argument
	if(gender == 'Both'){
		prepared_query <- sub('GENDER_FILLER', "", prepared_query)

	} else {
		gender_string <- paste("AND GENDER = '", gender, "'", sep = "")
		prepared_query <- sub('GENDER_FILLER', gender_string, prepared_query)
	}

	## Check that both team name and team code aren't populated
	if(is.null(team_name) == FALSE & is.null(team_code) == FALSE){
		stop('Both team_name and team_code are populated.  Pick only 1')
	}
	## Team name argument
	if(is.null(team_name)){
		prepared_query <- sub('TEAM_FILLER', "", prepared_query)

	} else {
		team_string <- paste("AND TEAM_NAME IN ('",
				            paste(team_name, collapse = "', '"),
				            "')",
						    sep = "")

		prepared_query <- sub('TEAM_FILLER', team_string, prepared_query)
	}

	## Team code argument
	if(is.null(team_code)){
		prepared_query <- sub('CODE_FILLER', "", prepared_query)

	} else {
		team_string2 <- paste("AND TEAM_CODE IN ('",
				            paste(team_code, collapse = "', '"),
				            "')",
						    sep = "")

		prepared_query <- sub('CODE_FILLER', team_string2, prepared_query)
	}

	## athlete Swimmers
	if(is.null(athlete)){
		prepared_query <- sub('ATHELTE_FILLER', "", prepared_query)

	} else {
		### Check for names & IDS
		names <- subset(athlete,
						grepl('[a-z]+,\\s[a-z]+',
							athlete,
							ignore.case = TRUE) == TRUE
					)
		id <- subset(athlete,
					grepl('[a-z]+,\\s[a-z]+',
						athlete,
						ignore.case = TRUE) == FALSE
					)
		print(names)
		print(id)

		### Prepare Where Clasue
		if(length(names) >= 1 & length(id) >= 1){
			athlete_string <- paste("AND ATHLETE_NAME In ('",
			 						paste(names, collapse = "', '"),
			 						"')",
									" OR ATHLETE_CODE In('",
									paste(id, collapse = "', '"),
									"')",
								sep = "")

			prepared_query <- sub('ATHELTE_FILLER',
								  athlete_string,
								  prepared_query)

		} else if(length(names) >= 1 & length(id) < 1){
			athlete_string <- paste("AND ATHLETE_NAME In ('",
			 						paste(names, collapse = "', '"),
			 						"')",
								sep = "")
			prepared_query <- sub('ATHELTE_FILLER',
								   athlete_string,
								   prepared_query)

		} else if(length(names) < 1 & length(id) >= 1){
			athlete_string <- paste("AND ATHLETE_ID In ('",
			 						paste(names, collapse = "', '"),
			 						"')",
								sep = "")
			prepared_query <- sub('ATHELTE_FILLER',
								   athlete_string,
								   prepared_query)
		}
	}

	## Events
	if (event == 'All') {
		prepared_query <- sub('EVENT_FILLER', "", prepared_query)

	} else {
	### Prepare Events so they match event names in the DB
		event2 <- c()
		for (i in event) {
			m <- match.arg(i, unique(D2Qualifying$event))
			event2 <- append(event2, m)
		}

		event_string <- paste("AND EVENT IN ('",
							  paste(event2, collapse = "', '"),
							  "')",
					 sep = "")

		prepared_query <- sub('EVENT_FILLER', event_string, prepared_query)
	}

	## Final Query Prep
	prepared_query <- gsub('WHERE\\s+AND', 
	                       "WHERE", 
	                       prepared_query, 
	                       perl = TRUE)

	return(prepared_query)
}



