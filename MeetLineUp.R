# Meet Lineup Algorithum 
# Written By: Sean Warlick
# Date Written: 10/15/2015
###############################################################################

# Library Load
###############################################################################
library(dplyr)
library(data.table)
library(magrittr)
library(lubridate)


# Set Working Directory
setwd("data")

# File Management and Data Load
###############################################################################
file.copy("Big Ten.csv", "Master.csv")  # This will later be moved to web scraping function
file.append("Master.csv", "PAC 12.csv") # This will later be moved to web scraping function

master_times <- fread("Master.csv", sep = ",")


# General Data Cleaning
###############################################################################

master_times <- master_times %>%
	select(swim_date, team_short_name, team_code, gender, birth_date, full_name_computed, full_desc, event_id, swim_time, standard_name) %>%
	# Select Only Needed Columns
	
	mutate(swim_time2 = ifelse(nchar(master_times$swim_time)<= 5, paste("00:", master_times$swim_time, sep = ""), master_times$swim_time)) %>% 
	# We need to reformat swim_time to be conssitent and allow ms() to work.
	
	mutate(swim_time2 = as.duration(ms(swim_time2))) %>%
	# Format swim_time2 as duration element. Duration is in seconds.
	
	arrange(team_code, event_id, swim_time, full_name_computed, swim_date)
	# Neatly Arrange Data Set.

# Creae Athlete ID.
###############################################################################
## Athlete ID will folow USAS pattern. Bithdate First; 3 letters of first name; first 4 leters of last name. (mm/dd/yyseawarl)

## Extract and Substring First Name ----
name_list<- strsplit(master_times$full_name_computed, ", ") 
	# Split name variable. Returned as a list

first_name <- c() # Create vector for first names

for(i in 1:length(name_list)){
	first_name[i] <- name_list[[i]][2]
} # Extract First Name From List

first_name <- substr(first_name, 1, 3) # Substring First Name
first_name <- tolower(first_name) # move to lower case for neatness

## Extract Last Name ----
last_name <- substr(master_times$full_name_computed, 1, 4)
last_name <- tolower(last_name) # Move to lower case for neatness

## Add Athlete_ID to data set ----
master_times <- master_times %>%
	mutate(athlete_id = paste(birth_date, first_name, last_name, sep = ""))

 
# Internal Event Ranking
###############################################################################
## For each team we will rank the swimmers in each event.

master_times <- master_times %>% 
	group_by(team_code, gender, event_id)  %>%
	mutate(team_event_rank = rank(swim_time))



# Process
	3) Rank individuals best events.  
		a)Difference From B Cut?  

