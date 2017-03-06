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
	require(dplyr, quietly = TRUE, warn.conflicts = FALSE)

	# Connect to Database
	#driver <- RSQLite::SQLite()
	#con <- DBI::dbConnect(driver, db_name)

	# Set Up SQL
	insert_statement <- "
	    INSERT OR IGNORE INTO Conference (Name)
		Values(:a)
	"

	# Set Up Records
	records = list(a = conference_name)

	# Execute SQL
	conf_insert <- DBI::dbSendStatement(con, insert_statement, params = records)
	
	# Check Number of Rows Inserted
	conf_row <- DBI::dbGetRowsAffected(conf_insert)
	print(paste(conf_row, 'rows inserted into the conference table'))
	
	# Clear Result & Close Connection
	DBI::dbClearResult(conf_insert)
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
	require(dplyr, quietly = TRUE, warn.conflicts = FALSE)

	# Connect to Database
	#driver <- RSQLite::SQLite()
	#con <- DBI::dbConnect(driver, db_name)

	# Grab conference ID from last insert
	conference_query <- "Select id From Conference Where Name = :a"
	conf_id <- DBI::dbSendQuery(con, conference_query, list(a = conference_name))
	conf_id_dt <- DBI::dbFetch(conf_id)
	DBI::dbClearResult(conf_id)

	# Replicate so conference exists for each team record
	conf <- rep(conf_id_dt$ID[1], length = nrow(data))
	records = list(a = conf, b = data$team_code, c = data$team_short_name)

	# Set up package
	insert_statement <- "
	    INSERT OR IGNORE INTO Team (Conference_Id, Team_Code, Team_Name)
		Values(:a, :b, :c)
	"
	
	# Execute SQL 
	team_insert <- DBI::dbSendStatement(con, insert_statement, params = records)
	
	# Find number of rows inserted
	team_row <- DBI::dbGetRowsAffected(team_insert)
	print(paste(team_row, 'rows inserted into the team table'))

	# Clear Result
	DBI::dbClearResult(team_insert)
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
	require(dplyr, quietly = TRUE, warn.conflicts = FALSE)

	# Get apprpriate team_id for each record
	team_id_query <- "Select id From Team Where Team_Code = :a"
	team_id <- DBI::dbSendQuery(con, team_id_query, list(a = data$team_code))
	team_id_dt <- DBI::dbFetch(team_id)
	DBI::dbClearResult(team_id)
	
	# Set SQL Insert Statement
	insert_statement <- "
	    INSERT OR IGNORE INTO Athlete (ID, Team_ID, Athlete_Name, Gender, Birthdate)
		Values(:a, :b, :c, :d, :e)
	"
	## Set Up Records to Run
	records = list(a = data$athlete_id, 
		           b = team_id_dt$ID, 
		           c = data$full_name_computed, 
		           d = data$gender, 
		           e = data$birth_date)
	
	## Execute query
	athlete_insert <- DBI::dbSendStatement(con, 
										   insert_statement, 
										   params = records)
	athlete_row <- DBI::dbGetRowsAffected(athlete_insert)
	DBI::dbClearResult(athlete_insert)

	# Print Records
	print(paste(athlete_row, 'rows inserted into the athlete table'))

}

#' Insert Meet Data into database.
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
	
	# Execute query
	meet_insert <- DBI::dbSendStatement(con, 
		                                insert_statement, 
		                                params = records)

	# Get Number of Rows inserted
	meet_rows <- DBI::dbGetRowsAffected(meet_insert)
	DBI::dbClearResult(meet_insert)

	# Record Keeping
	print(paste(meet_rows, 'inserted into meet table'))	
}

#' Insert Result Data into database.
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
	DBI::dbClearResult(meet_id)

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
	records <- list(a = meet_id_dt$ID, 
		            b = data$athlete_id, 
		            c = data$event_id, 
		            d = data$swim_time, 
		            e = data$swim_time2)

	# Execute Insert
	result_insert <- DBI::dbSendStatement(con, 
										  insert_statement, 
										  params = records)
	result_rows <- DBI::dbGetRowsAffected(result_insert)
	DBI::dbClearResult(result_insert)

	# Print Records
	print(paste(result_rows, 'rows inserted into the result table'))	
}

#' Insert Event Data into database.
#' An Internal function.
#' @param con a database connection of class
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


#' Insert Event Data into database.  
#' An Internal function.
#' @param con a database connection of class
#'
#' @param data
#'
#' @keywords internal
#'

insert_qualifying <- function(con){
	# Set Up SQL statement
	insert_statement <- "
	Insert or Ignore Into Qualifying (
		EVENT_ID,
		GENDER,
		STANDARD,
		Q_TIME_TEXT,
		Q_TIME_VALUE
	)
	Values(:a, :b, :c, :d, :e)	
	"

	# Set up records to run
	
	## Load data from within package
	q_data <- D1Qualifying

	records <- list(a = q_data$event_id, 
		            b = substr(q_data$gender, 1, 1), 
		            c = substr(q_data$standard, 1, 1), 
		            d = q_data$swim_time, 
		            e = q_data$swim_time2)

	# Execute Insert
	records_inserted <- DBI::dbExecute(con, insert_statement, params = records)
	if (records_inserted == 52) {
		print('Qualifying Table Correctly Populated')
	} else{
		print("Check The Contents of Qualifying Table")
	}

}
