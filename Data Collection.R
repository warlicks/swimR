# Author: Sean Warlick
# Date: October 12, 2015
# Source Code For Functions to Pull Individual and Relay Data for NCAA Swimming
# from USA Swimming's Website. 
###############################################################################

#'
#'
#'


individual_swims<-function(Conference, start_date = '2015-08-01', end_date = '2015-05-31', LCM = FALSE, SCM = FALSE, SCY = TRUE, top, downloadPath = getwd(), read = TRUE){
	require(RSelenium) # Rselenium Provides Tools Fill Out Search Form. 

	url<-"http://usaswimming.org/DesktopDefault.aspx?TabId=1971&Alias=Rainbow&Lang=en"
	
	selserv <- startServer(args = c("-port 4445")) # Star Selenium Server

	fprof <- profile(downloadPath)

	remDr <- remoteDriver(remoteServerAddr = 'localhost', port = 4445, browser = "firefox", extraCapabilities = fprof)

	remDr$open(silent = TRUE)

	remDr$navigate(url)

	time_type <- remDr$findElement(using = "id", value = "ctl82_rbIndividual")
	time_type$clickElement() #Make Sure Indivual Times are Selected

	# Select Conference
	conference_select <- key_press(Conference) # Set Up Key Strokes

	conference<-remDr$findElement(using = "id", value = "ctl82_ddConference")
	conference$sendKeysToElement(conference_select) # Pass Key Storkes


	# Select The Courses
	if(LCM == FALSE){
		lcm<-remDr$findElement(using = "id", value = "ctl82_cblCourses_0")
		lcm$clickElement()
	} # Uncheck LCM Button

	if(SCM == FALSE){
		scm<-remDr$findElement(using = "id", value = "ctl82_cblCourses_1")
		scm$clickElement()	
	} # Uncheck SCM Button

	if(SCY == FALSE){
		scy <- remDr$findElement(using = "id", value = "ctl82_cblCourses_2")
		scy$clickElement()	
	} # Uncheck SCY Button

	# Set Date Range
	date_button <- remDr$findElement(using = "id", value = "ctl82_rbDateRange")
	date_button$clickElement()

	## Start Date
	start_dateBox <- remDr$findElement(using = "id", value = "ctl00_ctl82_ucStartDate_radTheDate_dateInput")
	start_date <- startDateParse(start_date)
	start_dateBox$sendKeysToElement(start_date)

	# Select How Many Times To Display
	if(top > 500){
		warning("Can Not Excede Top 500 Times")
		stop()
	} # Create Warning and Stop Execution if we excede USA Swimmings Max Value

	show_top<-remDr$findElement(using = "id", value = "ctl82_txtShowTopX")
	show_top$clearElement()
	show_top$sendKeysToElement(list(as.character(top)))

	altitude <- remDr$findElement(using = "id", value = "ctl82_cbUseAltitudeAdjTime")
	altitude$clickElement()



	search <- remDr$findElement(using = "id", value = "ctl82_btnCreateReport")
	search$clickElement()
    

 #    Sys.sleep(20) # Need to pause to get the export click to work
	
	# report_frame <- remDr$findElement(using = "tag name", value = "iframe")

	# report_frame$click(buttonId = "RIGHT")

	# Change The Output To CSV & Save!
	output_select <- remDr$findElement(using = "id", value = "ctl82_ucReportViewer_ddViewerType")
	output_select$sendKeysToElement(list("E", "E", "E"))
	change_output <- remDr$findElement(using = "id", value = "ctl82_ucReportViewer_lbChangeOutputType" )
	
	Sys.sleep(5) # Need to pause to get the export click to work

	change_output$clickElement()


	Sys.sleep(30) # Give Time for Down Load
	remDr$close()

	# File Management ----
	currentwd <- getwd()
	setwd(downloadPath)
	
	file <- file.info(dir()) # Data Frame Used to find downloaded file.

	file_name <- row.names(file)[which(file$ctime == max(file$ctime))] # Use create time find name of downloaded file
	
	file.rename(file_name, paste(Conference, ".csv", sep = "")) #Give Meaningful Name

	if(read){
		data <- read.csv(paste(Conference, ".csv", sep = ""))
		return(data)
	}

	setwd(currentwd)

}

