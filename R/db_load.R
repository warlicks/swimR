#' Load Swimming Results Into A Database
#'
#' Create and/or Load Data into a SQLite Database
#'
#' \code{db_load} is used to create and load a USA Swimmings Top Times Report into  SQLite database.  The function utilizes \code{\link[DBI]{DBI}} create the connection to the database, creation of the tables and insertion of the data.  
#'
#' The function is designed so that each team has its own table.  The team name is provided in the function call.  If the table does not exist it is created and the data is loaded.  If the table does exist the data is appended to the existing table.  The function currently does not check for duplicate entries.  
#'
#' In version of \strong{\code{swimR}}, the database is not designed around a particular schema.  primary keys are not currently implemented.  The tables are not currently set to be joined, but rather unioned.  
#'
#' @param db_name A character string providing the filename of the SQLite Database.
#'
#' @param data A data frame in the format of a USA Swimming Top Times Report.
#'
#' @param team A character string providing the team name for the team of interest.  The team name coresponds to the table name.  

db_load <- function(db_name, data, team){

	data_import <-dplyr::filter(data, team_short_name == team)

	# Connect to SQLite database give in db_name.
	# If it doesn't exist, the function wil create the database.
	
	driver = RSQLite::SQLite()
	con <- DBI::dbConnect(driver, db_name)
	
	
	team_table <- DBI::dbExistsTable(con, team) # Check for a table for the current team exists.

	if (team_table) {
		append_sql <- DBI::sqlAppendTable(con, team, data_import)
		DBI::dbExecute(con, append_sql)
	} else {
		DBI::dbWriteTable(con, team, data_import)
	}

}