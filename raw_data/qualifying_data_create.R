# Load Packages ---
library(devtools)
library(dplyr)

# Load functions to help clean data ----
source("~/Documents/GitHub/swimR/raw_data/cut_times.R")
source("~/Documents/GitHub/swimR/raw_data/standard_clean.R")
source("~/Documents/GitHub/swimR/raw_data/time_convert.R")

# Load Event IDs ----
event_id <- read.csv('./raw_data/event_ids.csv')

# Gather Data From Swim Swam ----
D1Qualifying <- cut_times('https://swimswam.com/ncaa-releases-2016-2017-division-time-standards/')

D2Qualifying <- cut_times('https://swimswam.com/ncaa-division-ii-time-standards-released/', division = 2)

D3Qualifying <- cut_times('https://swimswam.com/ncaa-releases-division-iii-time-standards/', division = 3)

# Add Event ID Column To Qualifying Data ----
D1Qualifying <- D1Qualifying %>% 
	inner_join(., event_id, by = c('event' = 'event')) %>%
	select(event_id, event, gender, standard, swim_time, swim_time2)

D2Qualifying <- D2Qualifying %>% 
	inner_join(., event_id, by = c('event' = 'event')) %>%
	select(event_id, event, gender, standard, swim_time, swim_time2)

D3Qualifying <- D3Qualifying %>% 
	inner_join(., event_id, by = c('event' = 'event')) %>%
	select(event_id, event, gender, standard, swim_time, swim_time2)

setwd("~/Documents/GitHub/swimR")

use_data(D1Qualifying)
use_data(D2Qualifying)
use_data(D3Qualifying)