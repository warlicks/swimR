best_time_query <- function(conference = 'All',
					  team_name = 'All',
					  gender = 'Both',
					  athlete = NULL,
					  event = 'All')
{
	best_times_sql <- 
	"
	Select 
		ATHLETE_NAME,
		B.GENDER As GENDER,
		TEAM_NAME,
		MEET_DATE,
		E.NAME As CONFERENCE_NAME,
		\"EVENT\" AS EVENT_NAME,
		SWIM_TIME_TEXT,
		SWIM_TIME_VALUE,
		F.Q_TIME_VALUE AS A_CUT,
		G.Q_TIME_VALUE AS B_CUT

	FROM Result A
		INNER JOIN ATHLETE B ON A.Athlete_ID = B.ID
		INNER JOIN EVENT C ON A.EVENT_ID = C.ID
		INNER JOIN TEAM D ON B.TEAM_ID = D.ID
		INNER JOIN MEET M ON A.MEET_ID = M.ID
		INNER JOIN CONFERENCE E ON D.CONFERENCE_ID = E.ID
		Inner JOIN QUALIFYING F ON C.ID = F.EVENT_ID AND B.GENDER = F.GENDER
		INNER JOIN QUALIFYING G ON C.ID = G.EVENT_ID AND B.GENDER = G.GENDER 

		INNER JOIN( /* BEST TIME QUERY*/
			Select
			A.ID AS ATHLETE_ID,
			EVENT_ID AS EVENT_ID,
			MIN(SWIM_TIME_VALUE) as best_time

		FROM ATHLETE A
			INNER JOIN RESULT B ON A.ID = B.ATHLETE_ID

		GROUP BY
			ATHLETE_ID,
			EVENT_ID
	   ) BT On A.ATHLETE_ID = BT.ATHLETE_ID 
		AND A.EVENT_ID = BT.EVENT_ID 
		AND BT.BEST_TIME = A.SWIM_TIME_VALUE
		
	WHERE
		F.STANDARD = 'A'
		AND G.STANDARD = 'B'
		CONFERENCE_FILLER
		GENDER_FILLER
		TEAM_FILLER
		ATHELTE_FILLER
		EVENT_FILLER

	"
	# Update query based on arguments

	## Conference Argument
	if(conference == 'All'){
		prepared_query <- sub('CONFERENCE_FILLER', "", best_times_sql)
	} else {
		conf_string <- paste("And E.NAME IN ('",
							 paste(conference, collapse = "', '"),
							 "')",
							sep = "")

		prepared_query <- sub('CONFERENCE_FILLER', conf_string, best_times_sql)
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