
startDateParse <- function(start_date){

	start_frame <- as.data.frame(
		t(
		unlist(
		strsplit(start_date, "-")
		)
		), stringsAsFactors = FALSE) # Split Date Elements & put in data frame. 
	names(start_frame) <- c('yr', 'mnth', 'day') # Assign Names

	mnth <- unlist(strsplit(start_frame$mnth, NULL))
	day <- unlist(strsplit(start_frame$day, NULL))
	year <- unlist(strsplit(start_frame$yr, NULL))



	seq <- list(mnth[1], mnth[2], '/', day[1], day[2], '/', year[1], year[2], year[3], year[4])
	return(seq)
}