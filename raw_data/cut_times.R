#' \code{cut_times} collects NCAA qualifying time from the internet.  
#'
#' \code{cut_times} collects NCAA qualifying time from the internet.  
#'
#' \code{cut_times} collects NCAA qualifying time from the internet.  The function was developed using \strong{SwimSwam} as the source of the data.  It is possible that the funtion will work with other sources on the internet, however it has not been tested.  
#'
#' @param url A character string providing the address of the website where the table of qualifying standards can be found.
#'
#' @param division An interger indicated which NCAA divsion the qualifying times apply to.  1 for NCAA Division I, 2 for NCAA Division II and 3 for NCAA Divsion III
#' 
#' @return returns a data frame with 6 columns.  

# Define the function ----
cut_times <- function(url, division = 1){
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


	# Clean Up Event Names ----
	event_name <- event_name %>% 
		dplyr::slice(3:end) %>% 
		dplyr::rename(event = X3)
 	
 	# Clean Up times for each gender/standard & return a data frame
	men_a <- standard_clean(men_a, event_name, division)
	men_b <- standard_clean(men_b, event_name, division)
	women_a <- standard_clean(women_a, event_name, division)
	women_b <- standard_clean(women_b, event_name, division)

	# Combine into a single data frame. 
	qualifying_standard <- dplyr::bind_rows(men_a, men_b, women_a, women_b) %>%
		dplyr::select(event, gender, standard, swim_time, swim_time2)

	return(qualifying_standard)

}