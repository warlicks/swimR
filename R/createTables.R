# Author: Sean Warlick
# Date: October 12, 2015
# Source Code for swimR
# Internal Functions to build database
###############################################################################
#' Code to create each table in the database. 
#'
#' @parm con is a database connection object of class \link[DBI]{
DBIConnection-class}
#'
#' @keywords internal
#'

create_team <- function(con){
	# Define the Create table statement 
	statement <- "
		CREATE TABLE TEAM ( 
			ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
			TEAM_CODE Varchar(5) NOT NULL UNIQUE, 
		TEAMEAM_NAME VARCHAR(50) NOT NULL UNIQUE
		)
	"
	# Execute the statement
	create <- DBI::dbSendStatement(con, statement)
	
	# Send error if the function dosn't finish
	if(DBI::dbHasCompleted(create) == FALSE) {
		warning("Team Table Was Not Created")
	}
}

#' Code to create each table in the database. 
#'
#' @parm con is a database connection object of class \link[DBI]{
DBIConnection-class}
#'
#' @keywords internal
#'

create_athlete <- function(con){
	# Define the Create table statement 
	statement <- "
		CREATE TABLE ATHLETE (
			ID VARCHAR() NOT NULL PRIMARY KEY UNIQUE,
			TEAM_ID INTEGER NOT NULL,
			ATHLETE_NAME VARCHAR(50) NOT NULL,
			GENDER CHAR(2),
			BIRTHDATE DATE()
		)
	"
	# Execute the statement
	create <- DBI::dbSendStatement(con, statement)
	
	# Send error if the function dosn't finish
	if(DBI::dbHasCompleted(create) == FALSE) {
		warning("Athlete Table Was Not Created")
	}
}