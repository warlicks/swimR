# Author: Sean Warlick
# Date: January 12, 2017
# Source Code for swimR
# Internal Functions to load data into swim database
###############################################################################

#' Insert Team Data into database.
#' An Internal function.
#' @param con a
#'
#' @param conference_name
#'
#' @keywords internal

insert_conference <- function(con, conference_name){
	# Load needed package
	require(dplyr)

	conference_query <- "Select id From Conference Where Name = :a"
	DBI::dbSendQuery(con, conference_query, list(a = conference_name))

	insert_statement <- "
	    INSERT OR IGNORE INTO Conference (Name)
		Values(:a)
	"
	records = list(a = conference_name)
	
	DBI::dbExecute(con, insert_statement, params = records)
}


#' Insert Team Data into database.
#' An Internal function.
#' @param con a
#'
#' @param data
#'
#' @keywords internal

insert_team <- function(con, data, conference_name){
	# Load needed package
	require(dplyr)

	conference_query <- "Select id From Conference Where Name = :a"
	conf_id <- DBI::dbSendQuery(con, conference_query, list(a = conference_name))
	conf_id_dt <- DBI::dbFetch(conf_id)
	conf <- rep(conf_id_dt$ID[1], length = nrow(data))

	insert_statement <- "
	    INSERT OR IGNORE INTO Team (Conference_Id, Team_Code, Team_Name)
		Values(:a, :b, :c)
	"
	records = list(a = conf, b = data$team_code, c = data$team_short_name)
	
	DBI::dbExecute(con, insert_statement, params = records)
}

#' Insert Athlete Data into database.
#' An Internal function.
#' @param con a
#'
#' @param data
#'
#' @keywords internal

insert_athlete <- function(con, data){
	# Load needed package
	require(dplyr)

	# Get apprpriate team_id for each record
	team_id_query <- "Select id From Team Where Team_Code = :a"
	team_id <- DBI::dbSendQuery(con, team_id_query, list(a = data$team_code))
	team_id_dt <- DBI::dbFetch(team_id)
	
	# Set SQL Insert Statement
	insert_statement <- "
	    INSERT OR IGNORE INTO Athlete (ID, Team_ID, Athlete_Name, Gender, Birthdate)
		Values(:a, :b, :c, :d, :e)
	"
	## Set Up Records to Run
	records = list(a = data$athlete_id, b = team_id_dt$ID, c = data$full_name_computed, d = data$gender, e = data$birth_date)
	
	## Execute query
	DBI::dbExecute(con, insert_statement, params = records)
}

#' Insert Athlete Data into database.
#' An Internal function.
#' @param con a
#'
#' @param data
#'
#' @keywords internal

insert_meet <- function(con, data){
	
	# Set SQL Insert Statement
	insert_statement <- "
	    INSERT OR IGNORE INTO Meet (Meet_Name, Meet_Date)
		Values(:a, :b)
	"
	## Set Up Records to Run
	records = list(a = data$meet_name, b = data$swim_date)
	
	## Execute query
	DBI::dbExecute(con, insert_statement, params = records)
}

#' Insert Meet Result Data into database.
#' An Internal function.
#' @param con a
#'
#' @param data
#'
#' @keywords internal
#'
insert_result <- function(con, data){
	# Get Meet ID From Meet Table.
	meet_id_query <- "Select ID From Meet Where meet_name = :a"
	meet_id <- DBI::dbSendQuery(con, meet_id_query, list(a = data$meet_name))
	meet_id_dt <- DBI::dbFetch(meet_id)

	# Set Up SQL Insert Statement
	insert_statement <- "
	INSERT OR IGNORE INTO RESULT (
		Meet_ID,
		Athlete_ID,
		Event_ID,
		SWIM_TIME_TEXT,
		SWIM_TIME_VALUE
	)

	Values(:a, :b, :c, :d, :e)"

	# Set Up Records to Run
	records <- list(a = meet_id_dt$ID, b = data$athlete_id, c = data$event_id, d = data$swim_time, e = data$swim_time2)

	# Execute Insert
	DBI::dbExecute(con, insert_statement, params = records)
}

#' Insert Event Data into database.
#' An Internal function.
#' @param con a
#'
#' @param data
#'
#' @keywords internal
#'
insert_event <- function(con){
	#Get Event ID and event names from D2qualifying times. 
	event_ids <- D2Qualifying
	event_ids <- dplyr::select(event_ids, event_id, event) 
	event_ids <- dplyr::distinct(event_ids)
	
	# Set Up SQL Insert Statement
	insert_statement <- "
	INSERT OR IGNORE INTO Event (
		id,
		event
	)
	Values(:a, :b)"

	# Set Up Records to Run
	records <- list(a = event_ids$event_id, b = event_ids$event)

	# Execute Insert
	records_inserted <- DBI::dbExecute(con, insert_statement, params = records)
	if (records_inserted == 14) {
		print('Event Table Correctly Populated')
	} else{
		print("Check The Contents of Event Table")
	}
}














