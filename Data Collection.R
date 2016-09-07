# Author: Sean Warlick
# Date: October 12, 2015
# Source Code For Functions to Pull Individual and Relay Data for NCAA Swimming
# from USA Swimming's Website. 
###############################################################################




individual_swims<-function(Conference, LCM = FALSE, SCM = FALSE, SCY = TRUE, top){
	require(RSelenium) # Rselenium Provides Tools Fill Out Search Form. 

	url<-"http://usaswimming.org/DesktopDefault.aspx?TabId=1971&Alias=Rainbow&Lang=en"
	
	selserv <- startServer(args = c("-port 4445")) # Star Selenium Server

	remDr <- remoteDriver(remoteServerAddr = 'localhost', port = 4445, browser = "firefox", extraCapabilities = fprof)

	remDr$open(silent = TRUE)

	remDr$navigate(url)

	time_type <- remDr$findElement(using = "id", value = "ctl82_rbIndividual")
	time_type$clickElement() #Make Sure Indivual Times are Selected

	conference_select <- key_press(Conference)

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

	altitude <- remDr$findElement(using = "id", value = "ctl82_cbUseAltitudeAdjTime")
	altitude$clickElement()

	#output_select <- remDr$findElement(using = "id", value = "ctl82_ddOutputType")
	#output_select$sendKeysToElement(list('R'))

	search <- remDr$findElement(using = "id", value = "ctl82_btnCreateReport")
	search$clickElement()
    

 #    Sys.sleep(20) # Need to pause to get the export click to work
	
	# report_frame <- remDr$findElement(using = "tag name", value = "iframe")

	# report_frame$click(buttonId = "RIGHT")

	# Change The Output To CSV & Save!
	output_select <- remDr$findElement(using = "id", value = "ctl82_ucReportViewer_ddViewerType")
	output_select$sendKeysToElement(list("E", "E", "E"))
	change_output <- remDr$findElement(using = "id", value = "ctl82_ucReportViewer_lbChangeOutputType" )
	
	Sys.sleep(10) # Need to pause to get the export click to work

	change_output$clickElement()


	Sys.sleep(30) # Give Time for Down Load


	# # File Management
	# file <- list.files(path = "/Users/SeanWarlick/Downloads", pattern = "*.csv")

	# file.rename(file, paste(Conference, ".csv", sep = "")) #Give Meaningful Name


	remDr$close()

	# #Combine To One File
	# setwd("")
	# list.files()

}

