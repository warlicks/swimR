library(ggvis)


home_team <- "IOWA"
visiting_team <- "OSU"
meet_gender <- "F"


# Create Data Set For the Swim Meet
###############################################################################
meet_data <- master_times %>% 
 filter(team_code %in% c(home_team, visiting_team) & gender == meet_gender) %>%
 	# To make the data set manageable we will filter to just the two teams competing and the appropriate gender
  mutate(event_count = 0)
  	# We will initilize a variable to keep track of how many events an athlete has swam
	
# Scoring Rules
###############################################################################
# Scoring Rules are based on 2015-16 and 2016-17 NCAA Rules for dual meets  with 6 or more lanes. 

place<-c(1, 2, 3, 4, 5, 6)
points<-c(9, 4, 3, 2, 1, 0)

scoring_rules<-as.data.frame(cbind(place, points))

# Start of Algorithum

test_events <- c("50 Freestyle", "100 Freestyle", "200 Freestyle", "500 Freestyle", "100 Butterfly") # Testing

meet_line_up <- c() # Storage for meet line up. 
event_score <- c() # Storage for scoring


for (i in test_events){

	meet_data2 <- meet_data %>%
		filter(swimmer_event_rank <= 3 & event_count <= 3 
			& event == i) %>%
		group_by(team_code) %>%
		mutate(team_event_rank2 = rank(swim_time)) %>%
		filter(team_event_rank2 <= 3) %>%
		select(full_name_computed, athlete_id, team_code, event, swim_time, swim_time2, team_event_rank2)

	meet_data2 <- meet_data2 %>%
		ungroup() %>%
		mutate(predicted_finish = rank(swim_time)) %>%
		inner_join(scoring_rules, by = c("predicted_finish" = "place"))
	
	meet_line_up <- rbind(meet_line_up, meet_data2)

	event_total <- meet_data2 %>%
	group_by(team_code) %>%
	mutate(event_score = sum(points)) %>%
	distinct(team_code) %>%
	select(team_code, event, event_score)

	event_score <- rbind(event_score, event_total)

	meet_data$event_count <- ifelse(meet_data$athlete_id %in% meet_data2$athlete_id, meet_data$event_count + 1, meet_data$event_count)
}

event_score <- event_score %>% 
		group_by (team_code) %>% 
		mutate(cummulative_score = cumsum(event_score))

event_score %>% 
	ggvis(~team_code, ~event_score) %>% 
	layer_bars()