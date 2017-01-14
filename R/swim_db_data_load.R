# Author: Sean Warlick
# Date: January 12, 2017
# Source Code for swimR
# Internal Functions to load data into swim database
###############################################################################
#' Load Data Frame Into Swim Database
#'
#'
#' @export
swim_db_data_load <- function(con, data, conference_name){
	
	c <- insert_conference(con, conference_name)
	print(c)

	t <- insert_team(con, data, conference_name)
	print(t)

	a <- insert_athlete(con, data)
	print(a)

	m <- insert_meet(con, data)
	print(m)



}