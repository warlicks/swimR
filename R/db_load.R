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