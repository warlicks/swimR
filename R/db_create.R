# Author: Sean Warlick
# Date: October 12, 2015
# Source Code swimR package.
# Top level funtion to build storage database. 
###############################################################################
#'
#'
#' @param db_name A character string providing the filename of the SQLite Database.
#'
#' @export

db_build <- function(db_name){

	# Connect to SQLite DB.  If it doesn't exit it will be created.

	driver <- RSQLite::SQLite()
	con    <- DBI::dbConnect(driver, db_name)

	# Create the Tables
	create_team(con)
	create_athlete(con)

}