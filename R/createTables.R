# Author: Sean Warlick
# Date: October 12, 2015
# Source Code for swimR
# Internal Functions to build database tables
###############################################################################

#' Code to create each table in the database. 
#'
#' @param con is a database connection object of class \link[DBI]{
#' DBIConnection-class}
#'
#' @keywords internal
#'

create_team <- function(con){
	# Define the Create table statement 
	statement <- "
		CREATE TABLE TEAM ( 
			ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
			CONFERENCE_ID INTEGER,
			TEAM_CODE Varchar(5) NOT NULL UNIQUE, 
			TEAM_NAME VARCHAR(50) NOT NULL UNIQUE
		)
	"
	# Execute the statement
	if(DBI::dbExistsTable(con, 'TEAM')) {
		print('Team Table Already Built')
	} else {
		create <- DBI::dbExecute(con, statement)

		# Check That Create Table worked
		if(DBI::dbExistsTable(con, 'TEAM') == FALSE) {
			warning("Team Table Was Not Created")
		} else {
			print("TEAM Table Was Built")
		}
	}

	#dbDisconnect(con)

}

#' Code to create each table in the database. 
#'
#' @param con is a database connection object of class \link[DBI]{
#' DBIConnection-class}
#'
#' @keywords internal
#'

create_conference <- function(con){
	# Define the Create table statement 
	statement <- "
		CREATE TABLE CONFERENCE(
			ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
			NAME VARCHAR(100) UNIQUE
		)
	"
	# Execute the statement
	if(DBI::dbExistsTable(con, 'CONFERENCE')){
		print('Conference Table Already Built')
	} else {
		create <- DBI::dbExecute(con, statement)

		# Check That Create Table worked
		if(DBI::dbExistsTable(con, 'CONFERENCE') == FALSE) {
			warning("CONFERENCE Table Was Not Created")
		} else {
			print("CONFERENCE Table Was Built")
		}
	}
	#DBI::dbDisconnect(con)

}

#' Code to create each table in the database. 
#'
#' @param con is a database connection object of class \link[DBI]{
#' DBIConnection-class}
#'
#' @keywords internal
#'

create_athlete <- function(con){
	# Define the Create table statement 
	statement <- "
		CREATE TABLE ATHLETE(
			ID VARCHAR(15) NOT NULL PRIMARY KEY UNIQUE,
			TEAM_ID INTEGER NOT NULL,
			ATHLETE_NAME VARCHAR(50) NOT NULL,
			GENDER CHAR(2),
			BIRTHDATE Char(10)
		)
	"
	# Execute the statement
	if(DBI::dbExistsTable(con, 'ATHLETE')){
		print('Athlete Table Already Built')
	} else {
		create <- DBI::dbExecute(con, statement)
		
		# Check That Create Table worked
		if(DBI::dbExistsTable(con, 'ATHLETE') == FALSE) {
			warning("Athlete Table Was Not Created")
		}else {
			print("ATHLETE Table Was Built")
		}
	} 
}

#' Code to create each table in the database. 
#'
#' @param con is a database connection object of class \link[DBI]{
#' DBIConnection-class}
#'
#' @keywords internal
#'

create_meet <- function(con){
	# Define the Create table statement 
	statement <- "
		CREATE TABLE MEET(
			ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
			MEET_NAME VARCHAR(50) NOT NULL UNIQUE,
			MEET_DATE CHAR(10) NOT NULL
		)
	"
	# Execute the statement
	if(DBI::dbExistsTable(con, 'MEET')) {
		print('Meet Table Already Built')
	} else {
		create <- DBI::dbExecute(con, statement)
		
		# Check That Create Table worked
		if(DBI::dbExistsTable(con, 'MEET') == FALSE) {
			warning("Meet Table Was Not Created")
		} else {
			print("MEET Table Was Built")
		}
	} 
}


#' Code to create each table in the database. 
#'
#' @param con is a database connection object of class \link[DBI]{
#' DBIConnection-class}
#'
#' @keywords internal
#'

create_event <- function(con){
	# Define the Create table statement 
	statement <- "
		CREATE TABLE EVENT(
			ID INTEGER Not Null UNIQUE,
			EVENT CHAR(15) NOT NULL UNIQUE
		)
	"
	# Execute the statement
	if(DBI::dbExistsTable(con, 'EVENT')){
		print('Event Table Already Built')
	} else {
		create <- DBI::dbExecute(con, statement)
		
		# Check That Create Table worked
		if(DBI::dbExistsTable(con, 'EVENT') == FALSE) {
			warning("Event Table Was Not Created")
		} else {
			print("EVENT Table Was Built")
		}
	}
}


#' Code to create each table in the database. 
#'
#' @param con is a database connection object of class \link[DBI]{
#' DBIConnection-class}
#'
#' @keywords internal
#'

create_result <- function(con){
	# Define the Create table statement 
	statement <- "
		CREATE TABLE RESULT(
			ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
			MEET_ID NOT NULL, 
			ATHLETE_ID VARCHAR(15) NOT NULL,
			EVENT_ID INTEGER NOT NULL,
			SWIM_TIME_TEXT VARCHAR(10) NOT NULL,
			SWIM_TIME_VALUE NUMERIC NOT NULL	
		)
	"
	# Execute the statement
	if(DBI::dbExistsTable(con, 'RESULT')){
		print('Result Table Already Built')
	} else {
		create <- DBI::dbExecute(con, statement)
		
		# Check That Create Table worked
		if(DBI::dbExistsTable(con, 'RESULT') == FALSE) {
			warning("Result Table Was Not Created")
		} else {
			print("RESULT Table Was Built")
		}
	}
}