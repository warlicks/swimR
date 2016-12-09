# Author: Sean Warlick
# Date: October 12, 2015
# Source Code swimR package.
# Top level funtion to build storage database. 
###############################################################################
#' Create tables to store data in swimming database.
#' 
#' Create tables to store data in swimming database.
#'
#'\code{swimdb_tables} is used to create tables in a SQLite database.  These tables are designed to store results from USA Swimmings Top Times Report.  The function utilizes \code{\link[DBI]{DBI}} create the connection to the database, creation of the tables and insertion of the data.  
#'
#' If the database provided in /emph{db_name} does not exist the fuction will create the SQLite database.

#' @param db_name A character string providing the filename of the SQLite Database.
#'
#' @export

swimdb_tables <- function(db_name){

	# Connect to SQLite DB.  If it doesn't exit it will be created.

	driver <- RSQLite::SQLite()
	con    <- DBI::dbConnect(driver, db_name)

	# Create the Tables
	create_team(con)
	create_conference(con)
	create_athlete(con)
	create_meet(con)
	create_event(con)
	create_result(con)
}