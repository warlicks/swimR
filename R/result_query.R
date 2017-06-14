#' Collect College Swimming Meet Results
#'
#'
#'
#' @param conference a character vector with the name of an NCAA swimming conference.  If not provided the output include all conferences.
#' @param team_name a character vector with the name of an NCAA swimming conference.  If not provided the output include all teams.
#' @param gender a character vector.  Indicates the output should include men, women or both.  Defaults to "Both".  Other options are "M" for men and "F" for women.
#' @param athlete a character vector with the name or athlete id of a swimmier.  If not provided the results include all swimmers.  The athlete id follows the USA Swimming standard.
#' @param event a character vector with the name of swimming envent.  If not provided the results include all events.
#'
#' @return a character string containing the prepared SQL query
#' @keywords internal
#'
#' @examples
#' meet_results <- result_query(team_name = 'Iowa',
#'                              gender = 'F',
#'                              event = '100 Free')
#'
#'
result_query <- function(conference = 'All',
					  	team_name = 'All',
					  	gender = 'Both',
					  	athlete = NULL,
					  	event = 'All')
{
	result_sql_query <- '
	Select
		MEET_DATE,
		MEET_NAME,
		TEAM_NAME,
		ATHLETE_NAME,
		A.GENDER,
		E.EVENT AS EVENT_NAME,
		SWIM_TIME_VALUE,
		SWIM_TIME_TEXT,
		CASE
			WHEN SWIM_TIME_VALUE <= Q1.Q_TIME_VALUE THEN \'A_CUT\'
			WHEN SWIM_TIME_VALUE <= Q2.Q_TIME_VALUE AND
				 SWIM_TIME_VALUE > Q1.Q_TIME_VALUE THEN \'B_CUT\'
			ELSE NULL
		END CUT_TIME

	FROM MEET M
		INNER JOIN RESULT R ON M.ID = MEET_ID
		INNER JOIN EVENT E ON E.ID = R.EVENT_ID
		INNER JOIN ATHLETE A ON A.ID = R.ATHLETE_ID
		INNER JOIN TEAM T ON T.ID = A.TEAM_ID
		INNER JOIN QUALIFYING Q1 On R.EVENT_ID = Q1.EVENT_ID AND Q1.GENDER = A.GENDER
		INNER JOIN QUALIFYING Q2 On R.EVENT_ID = Q2.EVENT_ID AND Q2.GENDER = A.GENDER
		INNER JOIN CONFERENCE C ON T.CONFERENCE_ID = C.ID

	WHERE
		Q1.STANDARD = \'A\'
		AND Q2.STANDARD = \'B\'
		CONFERENCE_FILLER
		TEAM_FILLER
		ATHELTE_FILLER
		EVENT_FILLER

	ORDER BY
		TEAM_NAME,
		MEET_DATE,
		EVENT_NAME,
		SWIM_TIME_VALUE
	'
	# Update query based on arguments
	###########################################################################

	## Conference Argument
	if(conference == 'All'){
		prepared_query <- sub('CONFERENCE_FILLER', "", result_sql_query)
	} else {
		conf_string <- paste("And C.NAME IN ('",
							 paste(conference, collapse = "', '"),
							 "')",
							sep = "")

		prepared_query <- sub('CONFERENCE_FILLER', conf_string,
		                      result_sql_query)
	}

	## GENDER Argument
	if(gender == 'Both'){
		prepared_query <- sub('GENDER_FILLER', "", prepared_query)

	} else {
		gender_string <- paste("AND B.GENDER = '", gender, "'", sep = "")

		prepared_query <- sub('GENDER_FILLER', gender_string, prepared_query)
	}

	## Team name argument
	if(team_name == 'All'){
		prepared_query <- sub('TEAM_FILLER', "", prepared_query)

	} else {
		team_string <- paste("AND TEAM_NAME IN ('",
				            paste(team_name, collapse = "', '"),
				            "')",
						    sep = "")

		prepared_query <- sub('TEAM_FILLER', team_string, prepared_query)
	}

	## Althlete Argument
	if(is.null(athlete)){
		prepared_query <- sub('ATHELTE_FILLER', "", prepared_query)

	} else {
		### Check for names & IDS
		#### USE REGEX TO FIND NAMES AND IDS
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
		#print(names) # Debugging
		#print(id) # Debugging

		### Prepare Where Clasue
		#### WHEN BOTH ID AND NAME ARE USED
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
		##### WHEN ONLY NAMES USED
		} else if(length(names) >= 1 & length(id) < 1){
			athlete_string <- paste("AND ATHLETE_NAME In ('",
			 						paste(names, collapse = "', '"),
			 						"')",
								sep = "")
			prepared_query <- sub('ATHELTE_FILLER',
								   athlete_string,
								   prepared_query)
		##### WHEN ONLY ID USED
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

	## Return Prepared Query
	return(prepared_query)
}