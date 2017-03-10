#'
#'
#'
#' @param team - 
#'
#' 
#' TO DO:  
#'  * Adjust Cases of Filters

top_times <- function(db_path, 
					  conference = NULL, 
					  team_name = NULL,
					  team_code = NULL, 
					  individual = NULL, 
					  event = 'All') 
{
	# Set Up Basic Query Structure
	top_time_query <- '
	Select
		ATHLETE_NAME,
		TEAM_NAME,
		TEAM_CODE,
		E.NAME,
		"EVENT",
		SWIM_TIME_TEXT,
		SWIM_TIME_VALUE

	FROM RESULT A
		INNER JOIN ATHLETE B ON A.Athlete_ID = B.ID
		INNER JOIN EVENT C ON A.EVENT_ID = C.ID
		INNER JOIN TEAM D ON B.TEAM_ID = D.ID
		INNER JOIN CONFERENCE E ON D.CONFERENCE_ID = E.ID

	WHERE
		CONFERENCE_NAME
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

	## Individual Swimmers
	if(is.null(individual)){
		prepared_query <- sub('ATHELTE_FILLER', "", prepared_query)	
	
	} else {
		### Check for names & IDS
		names <- subset(individual, 
						grepl('[a-z]+,\\s[a-z]+', 
							individual, 
							ignore.case = TRUE) == TRUE
					)
		id <- subset(individual, 
					grepl('[a-z]+,\\s[a-z]+', 
						individual, 
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

	## Final Query Prep
	prepared_query <- sub('WHERE\\s AND', "WHERE", prepared_query)

	return(prepared_query)
}



