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
library(stringr)


# Set Working Directory
setwd("data")

# File Management and Data Load
###############################################################################
file.copy("Big Ten.csv", "Master.csv")  # This will later be moved to web scraping function
file.append("Master.csv", "PAC 12.csv") # This will later be moved to web scraping function

master_times <- fread("Master.csv", sep = ",")
cut_times <- cut_times<-read.csv("ncaa_times_2016.csv", quote = " \" ")

# General Data Cleaning
###############################################################################

master_times <- master_times %>%
	select(swim_date, team_short_name, team_code, gender, birth_date, full_name_computed, full_desc, event_id, swim_time, standard_name) %>%
	# Select Only Needed Columns

	mutate(event = substring(full_desc, 1, (unlist(gregexpr("SCY", full_desc)) - 1))) %>%
	# To make easy joins eliminate SCY and the gender from the event name.

	mutate(event = str_trim(event, side = "right")) %>%
	# Trim whitespace from event name.
	
	mutate(swim_time2 = ifelse(nchar(master_times$swim_time) <= 5, paste("00:", master_times$swim_time, sep = ""), master_times$swim_time)) %>% 
	# We need to reformat swim_time to be consitent and allow ms() to work.
	
	mutate(swim_time2 = as.duration(ms(swim_time2))) %>%
	# Format swim_time2 as duration element. Duration is in seconds.
	
	arrange(team_code, event_id, swim_time, full_name_computed, swim_date)
	# Neatly Arrange Data Set.

# Prepare Cut Times Data Set
###############################################################################
cut_times <- cut_times %>%
	mutate(time2 = as.duration(ms(time)))

# Create Athlete ID.
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

 
# Team Ranking in Each Event
###############################################################################
## For each team we will rank the swimmers in each event.

master_times <- master_times %>% 
	group_by(team_code, gender, event_id)  %>%
	mutate(team_event_rank = rank(swim_time))

# Determine Each Swimmers Best Events
###############################################################################

## Create Data Set For B Cuts ----
b_cuts <- cut_times %>% 
	filter(standard == "B") %>%
	select(event, gender, time2)


## Join B Cut Data
master_times <- right_join(master_times, as.data.table(b_cuts), by = c("event", "gender")) 
	# We need to do a right join to deal with 1000 Freestyle

## Rank Each Swimmers Best Events
master_times <- master_times %>%
	mutate(b_cut_diff = ((swim_time2 - time2) / time2)) %>%
		# Caclucate percentage off of B Cut
	group_by(athlete_id) %>%
	mutate(swimmer_event_rank = rank(b_cut_diff))
		# Rank By Difference From B Cut
