# Author: Sean Warlick
# Date: October 12, 2015
# Source Code swimR package.
# Top level funtion to build storage database. 
###############################################################################
#' Create tables to store data in swimming database.
#' 
#' Create tables to store data in swimming database.
#'
#'\code{swim_db_tables} is used to create tables in a SQLite database.  These tables are designed to store results from USA Swimmings Top Times Report.  The function utilizes \code{\link[DBI]{DBI}} create the connection to the database, creation of the tables and insertion of the data.  
#'
#' If the database provided in /emph{db_name} does not exist the fuction will create the SQLite database.

#' @param con A character string providing the name of a SQLiteConnection to the desired database.
#'
#' @export

swim_db_tables <- function(con){

	# Create the Tables
	create_conference(con)
	create_team(con)
	create_athlete(con)
	create_meet(con)
	create_event(con)
	create_result(con)
}