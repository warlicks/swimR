
# Building A Shinny App For College Swimming  


## Files  

1 "Data Collection.R"
  + Automation of code fills out web form to gather data.
  + Handles renaming and moving downloaded files to appropriate directory.  
2 "MeetLineUP.R"  
  + General Clean Up of Data.  
  + Team Rank in Each Event

## Next Steps

1 ~~Need to better document existing code in "Data Collection.R"~~  
2 ~~Explore Using *Formated HTML* output in combination with **rvest** to eliminate need to save the file from firefox.~~   
  + This will not work due to how USA Swimming displays the report.  

3 Begin working on meet line up algorithum.  
  + Next Step is to create rank a swimmers best events.  
    + Will Rank Swimmer's events based on "B Cut".  Creating Cut Time Dataset.
  + ~~Need to convert swim time from character variable.~~  

4 Modify Script to iterativly pull data from each conference.  
  + Will need to create a conference list and put portion of function in a `for()` loop.  

# Long Term Improvements  

* Write or modify function to pull relay data from USA swimming.  
* Modify Function to deal with fact that each data set will have a header, which makes it hard to read data in.  
