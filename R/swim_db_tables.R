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
#' @return The function prints a message to the terminal indicating if the table was correctly created.
#'
#' @export

swim_db_tables <- function(con){

	# Connect to Database
	#driver <- RSQLite::SQLite()
	#con    <- DBI::dbConnect(driver, "swim_test6.sqlite")
	
	# Create the Tables
	
	## Conference Table
	create_conference(con)
	
	## Team Table
	create_team(con)

	## Athlete Table
	create_athlete(con)

	## Meet Table 
	create_meet(con)

	## Create and Load Event Table.  
	## We populate this table when we build it since ith is the same data every time. 
	event <- create_event(con)
	if (event == TRUE){
		insert_event(con)	
	}	
	
	## Create and load qualifying time table.
	## We populate the qualifying when it is built since it is same data.
	qualifying <- create_qualifying(con)
	if(qualifying == TRUE){
		insert_qualifying(con)
	}
	
	#Create result table
	create_result(con)
}