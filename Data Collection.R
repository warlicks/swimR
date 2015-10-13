# Author: Sean Warlick
# Date: October 12, 2015
# Source Code For Functions to Pull Individual and Relay Data for NCAA Swimming
# from USA Swimming's Website. 
###############################################################################

url<-"http://usaswimming.org/DesktopDefault.aspx?TabId=1971&Alias=Rainbow&Lang=en"

individual_swims<-function(LCM, SCM, SCY, top){
	require(RSelenium) # Rselenium Provides Tools Fill Out Search Form. 
	
	startServer() # Star Selenium Server

	remDr<-remoteDriver(browser = "firefox")

	remDr$open(silent = TRUE)

	remDr$navigate(url)

	time_type<-remDr$findElement(using = "id", value = "ctl82_rbIndividual")
	time_type$clickElement() #Make Sure Indivual Times are Selected

	# Figuring Out How To Select Conference
	if(Conference == "Big Ten"){
		conference_select<-list("B", "B", "B")
	} else {
	  if(Conference == "PAC 12"){
	  	conference_select<-list("P")
	  } else {
		warning("Conference Not Found.  Please Use One Of The Following:")
		print(conference_list)
	  }
	} # WILL OVERHAUL THIS TO ITERATIVELY PULL EACH CONFERENCE!

	conference<-remDr$findElement(using = "id", value = "ctl82_ddConference")
	conference$sendKeysToElement(conference_select)

	# Select The Courses
	# NEED TO MODIFY THIS IF PLACED IN LOOP SO THAT THEY DON'T GET TURNED BACK ON
	if(LCM == FALSE){
		lcm<-remDr$findElement(using = "id", value = "ctl82_cblCourses_0")
		lcm$clickElement()
	} # Uncheck LCM Button

	if(SCM == FALSE){
		scm<-remDr$findElement(using = "id", value = "ctl82_cblCourses_1")
		scm$clickElement()	
	} # Uncheck SCM Button

	if(SCY == FALSE){
		scy<-remDr$findElement(using = "id", value = "ctl82_cblCourses_2")
		scy$clickElement()	
	} # Uncheck SCY Button

	# Select How Many Times To Display
	if(top > 500){
		warning("Can Not Excede Top 500 Times")
		stop()
	} # Create Warning and Stop Execution if we excede USA Swimmings Max Value

	show_top<-remDr$findElement(using = "id", value = "ctl82_txtShowTopX")
	show_top$clearElement()
	show_top$sendKeysToElement(list(as.character(top)))

	# Turn Off Altitude Adjustment
	#if(){
	#	altitude<-remDr$findElement(using = "id", value = "ctl82_cbUseAltitudeAdjTime")
	#	altitude$clickElement()
	#} This Will Be USED WHEN I CREATE LOOP TO PULL ALL CONFERENCES

	altitude<-remDr$findElement(using = "id", value = "ctl82_cbUseAltitudeAdjTime")
	altitude$clickElement()

	search<-remDr$findElement(using = "id", value ="ctl82_btnCreateReport")
	search$clickElement()

	# Change The Output To CSV & Save!
	output_select<-remDr$findElement(using = "id", value = "ctl82_ucReportViewer_ddViewerType")
	output_select$sendKeysToElement(list("E", "E", "E"))
	change_output<-remDr$findElement(using = "id", value = "ctl82_ucReportViewer_lbChangeOutputType" )
	
	Sys.sleep(5) # Need to pause to get the export click to work

	change_output$clickElement()

	Sys.sleep(15) # Give Time for Down Load


	# File Management
	file<-list.files(path = "/Users/SeanWarlick/Downloads", pattern = "*.csv")

	file.rename(file, paste(Conference, ".csv", sep ="")) #Give Meaningful Name

	file_rename<-list.files(path = "/Users/SeanWarlick/Downloads", pattern = "*.csv") # Store New Name For Ease

	file.copy(from = paste("/Users/SeanWarlick/Downloads/", file_rename, sep = ""), to = "/Users/SeanWarlick/Documents/GitHub/swimming_app/data") # Copy File to Data Location

	file.remove(paste("/Users/SeanWarlick/Downloads/", file_rename, sep = "")) # Remove File From Download. 

	# IF I PUT THIS IN A LOOP THIS WILL BE THE END OF THE LOOP

	remDr$close()

	#Combine To One File
	setwd("")
	list.files()

}

