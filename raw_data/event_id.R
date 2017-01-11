# This file takes the event id & event name from USA swimmings top times report and prepares them so they can be added to the NCAA qualifying times data pulled from SwimSwam. This will make for easier joins. 

# Load needed functions & packages ----
source("./R/event_naming.R")
library(dplyr)
library(stringr)

# Read In Data ----
data <- read.csv("./raw_data/event_list.csv")
# Data Munging ----
data2 <- event_naming(data) # Trim event names

event_ids <- data2 %>% select(event_id, event) %>% distinct() # Select only 1 of each event

# Change event names to match event names from Swim Swam. 
event_ids$event <- str_replace(event_ids$event, 'Free.+', 'Free')
event_ids$event <- str_replace(event_ids$event, 'Butterfly', 'Fly')
event_ids$event <- str_replace(event_ids$event, 'Back.*', 'Back')
event_ids$event <- str_replace(event_ids$event, 'Breast.*', 'Breast')
event_ids$event <- str_replace(event_ids$event, 'Ind.+\\sMed.+', 'IM')

# Write File Out To Use In qualifying_data_create ----
write.csv(event_ids, 'event_ids.csv', row.names = FALSE)