# Author: Sean Warlick
# Date: October 12, 2015
# Source Code for swimR
# Internal Functions to build database
###############################################################################
#' Code to create each table in the database. 
#'
#' @parm con is a database connection object of class \link[DBI]{
#' DBIConnection-class}
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
	if(DBI::dbExistsTable(con, 'TEAM') == FALSE){
		create <- DBI::dbSendStatement(con, statement)

		# Check That Create Table worked
		if(DBI::dbExistsTable(con, 'TEAM') == FALSE) {
			warning("Team Table Was Not Created")
		}
	} else {
		print('Team Table Already Built')
	}
	

}

#' Code to create each table in the database. 
#'
#' @parm con is a database connection object of class \link[DBI]{
#' DBIConnection-class}
#'
#' @keywords internal
#'

create_athlete <- function(con){
	# Define the Create table statement 
	statement <- "
		CREATE TABLE ATHLETE (
			ID VARCHAR(15) NOT NULL PRIMARY KEY UNIQUE,
			TEAM_ID INTEGER NOT NULL,
			ATHLETE_NAME VARCHAR(50) NOT NULL,
			GENDER CHAR(2),
			BIRTHDATE Char(10)
		)
	"
	# Execute the statement
	if(DBI::dbExistsTable(con, 'ATHLETE') == FALSE){
		create <- DBI::dbSendStatement(con, statement)
		
		# Check That Create Table worked
		if(DBI::dbExistsTable(con, 'ATHLETE') == FALSE) {
			warning("Athlete Table Was Not Created")
		}
	} else {
		print('Team Table Already Built')
	}
}