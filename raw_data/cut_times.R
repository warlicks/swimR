cut_times <- function(url, division = 1, yr = NA){
	require(rvest) # Using require b/c rvest::read_html does not work

	# Set Up slice to deal with D2 swimming 1000
	if(division == 2){
		end<-16
	} else { 
		end <- 15
	}
	
	# Get HTML Source For Top Times Search ----
	webpage <- read_html(url)

	# Extract Table From the Webpage ----
	web_table <- webpage  %>%
		rvest::html_nodes("table") %>%
		rvest::html_table()

	# Parse The List Returned by HTML Table ----
	men_a <- web_table[[1]][1]
	men_b <- web_table[[1]][2]
	event_name <- web_table[[1]][3]
	women_a <- web_table[[1]][4]
	women_b <- web_table[[1]][5]


	# Clean Up Event Name Function ----
	event_name <- event_name %>% 
		dplyr::slice(3:end) %>% 
		dplyr::rename(event = X3)

	men_a <- standard_clean(men_a, event_name, division)
	men_b <- standard_clean(men_b, event_name, division)
	women_a <- standard_clean(women_a, event_name, division)
	women_b <- standard_clean(women_b, event_name, division)

	qualifying_standard <- dplyr::bind_rows(men_a, men_b, women_a, women_b) %>%
		dplyr::select(event, gender, standard, swim_time, swim_time2)

	return(qualifying_standard)

	# # Set Up Variables For File Naming ----
	
	# ## Set Up Year
	# if(is.na(yr)){
	# 	yr <- (lubridate::year(Sys.Date()) + 1)
	# }

	# ## Set Up NCAA Division
	# if(division == 1){
	# 	division_name <- "DI"	
	# } else if(division == 2) {
	# 	division_name <- "DII"
	# } else {
	# 	division_name <- "DIII"
	# }

	# file_name <- paste(division_name, "Qualifying", yr, ".rdata", sep = "")
	# file_path <- paste("./data/", file_name, sep ="")

	# # Save File to /data
	# save(qualifying_standard, file = file_path)
}