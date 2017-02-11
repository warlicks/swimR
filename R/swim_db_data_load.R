# Author: Sean Warlick
# Date: January 12, 2017
# Source Code for swimR
# Internal Functions to load data into swim database
###############################################################################
#' Load college swimming results into a database.  
#'
#' Load college swimming results into a database.  
#'
#' \code{swim_db_data_load()} allows users to easily load swimming results data into a  database.  It is specifically designed to load data from from USA Swimmings Top Times Report.  Conference data, team data, athlete data, meet data and result data is loaded into the database with the function.  
#'
#' The function is set up so only distinct data is stored.  If a the function encounters a duplicate record it skips the records and moves on to the next record.
#'
#' @param con A SQLiteConnection object. 
#'
#' @param data A data.frame containing swimming results.  The data.frame should follow the form of a USA Swimming Top Times report and been cleaned by \code{\link{clean_swim()}}.
#'
#' @param conference_name A character string providing the name of the conference repersented in /emph{data}.   
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