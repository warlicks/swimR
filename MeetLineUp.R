# Meet Lineup Algorithum 
# Written By: Sean Warlick
# Date Written: 10/15/2015
###############################################################################

# Library Load
###############################################################################
library(dplyr)
library(data.table)
library(magrittr)
library(chron)


# Set Working Directory
setwd("data")

# File Management and Data Load
###############################################################################
file.copy("Big Ten.csv", "Master.csv")  # This will later be moved to web scraping function
file.append("Master.csv", "PAC 12.csv") # This will later be moved to web scraping function

master_times<-fread("Master.csv", sep = ",")



# Data Cleaning
###############################################################################

master_times<- master_times %>%
	select(swim_date, team_short_name, team_code, gender, birth_date, full_name_computed, full_desc, event_id, swim_time, standard_name) %>%
	# Select Only Needed Columns
	arrange(team_code, event_id, swim_time, full_name_computed, swim_date) 
	# Neatly Arrange Data Set.
 
 # Need to conver swim times to time objects. Lubridate package not working try chron package and function times()

## For each team rank swimmers in each event. 
master_times<- master_times %>% 
	group_by(team_code, gender, event_id)  %>%
	mutate(team_event_rank = rank(swim_time))



# Process
	1) Top Time For Each Athlete In an event.
		a) Need to create unique athlete identifier. Name & BDay?
	2) Within a team, rank in the events.
	3) Rank individuals best events.  
		a)Difference From B Cut?  

