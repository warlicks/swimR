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
	
	# Load Data Into Conference Table
	print('Loading data into conference table')
	insert_conference(con, conference_name)
	#print(paste(c, 'records inserted into the conference table'))
	print(paste(rep('-', 80), collapse = ""))

	# Load data into team table
	print('Loading Data into team team')
	insert_team(con, data, conference_name)
	#print(paste(t, 'records inserted into the team table'))
	print(paste(rep('-', 80), collapse = ""))

	## Load data into the athlete table
	print('Loading data into athlete table')
	insert_athlete(con, data)
	#print(paste(a, 'records inserted into the athlete table'))
	print(paste(rep('-', 80), collapse = ""))

	# Load meet data in to meet table
	print('Loading data into meet table')
	insert_meet(con, data)
	#print(paste(m, 'records inserted into the meet table'))
	print(paste(rep('-', 80), collapse = ""))
	
	# Load data into result table
	print('Loading data into result table')
	insert_result(con, data)
	#print(paste(r, 'records loaded into the meet table'))
	print(paste(rep('-', 80), collapse = ""))
}