#' 
#' An interal function used 
#'
#' @param conf A Character String


key_press <- function(Conference){

	require(rvest)
	require(dplyr)

	first_letter <- substr(Conference, 1, 1) # Get First Letter of Conf Name

	# Get HTML Source For Top Times Search ----
	time_search <- read_html('http://www.usaswimming.org/DesktopDefault.aspx?TabId=1971&Alias=Rainbow&Lang=en')

	# Parse HTML ----
	conference_list <- time_search %>% 
		html_nodes("select") %>% 
		.[1] %>% 
		html_children() %>% 
		html_text() %>%
		as.data.frame()

	names(conference_list) <- "conference" #Change Variable Name


	# Find all Confernces that start with the first letter of input. ----
	short_list <- conference_list %>% 
		mutate(conference2 = substr(conference, 1, 1)) %>%
		filter(conference2 == first_letter)

	# Identify where in the conference name vector the input lies ----
	position <- which(short_list$conference == Conference)

	# Prepare key input ----
	key <- rep(first_letter, position) # Repetition based on position in list


	## Convert to list for use in Data Collection Function
	key <- as.list(as.data.frame(t(key), stringsAsFactors = FALSE)) 
	key <- unname(key) #Remove Names From List
	return(key)
}

get_conferences <- function(){
	time_search <- read_html('http://www.usaswimming.org/DesktopDefault.aspx?TabId=1971&Alias=Rainbow&Lang=en')

	# Parse HTML ----
	conference_list <- time_search %>% 
		html_nodes("select") %>% 
		.[1] %>% 
		html_children() %>% 
		html_text() %>%
		as.data.frame()

	print(conference_list)
}