cut_times <- function(url, division = 1, yr = NA){
require(rvest)

	# Get HTML Source For Top Times Search ----
	webpage <- read_html(url)

	# Extract Table From the Webpage ----
	qualifying_times <- webpage  %>%
		rvest::html_nodes("table") %>%
		rvest::html_table()

	# Parse The List Returned by HTML Table ----
	men_a <- qualifying_times[[1]][1]
	men_b <- qualifying_times[[1]][2]
	event_name <- qualifying_times[[1]][3]
	women_a <- qualifying_times[[1]][4]
	women_b <- qualifying_times[[1]][5]


	# Clean Up Event Name Function ----
	event_name <- event_name %>% 
		slice(3:15) %>% 
		rename(event = X3)



	standards_clean <- function(data){
		data <- dplyr::mutate(data, gender = data[1, ], standard = data[2, ]) %>%
		dplyr::select(swim_time = starts_with("X"), gender, standard) %>%
		dplyr::slice(3:15) %>%
		dplyr::bind_cols(., event_name)
		data <- swimR:::time_convert(data)
		return(data)
	}

	men_a <- standards_clean(men_a)
	men_b <- standards_clean(men_b)
	women_a <- standards_clean(women_a)
	women_b <- standards_clean(women_b)

	qualifying_standard <- dplyr::bind_rows(men_a, men_b, women_a, women_b) %>%
		dplyr::select(event, gender, standard, swim_time, swim_time2)

	# Set Up Variables For File Naming ----
	
	## Set Up Year
	if(is.na(yr)){
		yr <- lubridate::year(Sys.Date())
	}

	## Set Up NCAA Division
	if(division == 1){
		division_name <- "DI"	
	} else if(division == 2) {
		division_name <- "DII"
	} else {
		division_name <- "DIII"
	}

	file_name <- paste(yr, division_name, "Qualifying", sep = "")
}