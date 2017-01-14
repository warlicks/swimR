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
	team_id_query <- "Select id From Team Where Team_Code = a:"
	team_id <- DBI::dbSendQuery(con, team_id_query, list(a = data$team_code))
	team_id_dt <- DBI::dbFetch(team_id)
	
	# Set SQL Insert Statement
	insert_statement <- "
	    INSERT OR IGNORE INTO Athlete (ID, Team_ID, Athlete_Name, Gender, Birthdate)
		Values(:a, :b, :c, :d, :e)
	"
	## Set Up Records to Run
	records = list(a = data$athlete_id, b = team_id_dt$ID, c = data$athlete_name, d = data$Gender, e = data$Birthdate)
	
	## Execute query
	DBI::dbExecute(con, insert_statement, params = records)
}