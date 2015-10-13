url<-"http://usaswimming.org/DesktopDefault.aspx?TabId=1971&Alias=Rainbow&Lang=en"

individual_swims<-function(LCM, SCM, SCY, top){
	require(RSelenium)
	startServer()

	remDr<-remoteDriver(browserName = "firefox")

	remDr$open(silent = TRUE)

	remDr$navigate(url)

	time_type<-remDr$findElement(using = "id", value = "ctl82_rbIndividual")
	time_type$clickElement() #Make Sure Indivual Times are Selected

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

	altitude<-remDr$findElement(using = "id", value = "ctl82_cbUseAltitudeAdjTime")
	altitude$clickElement()

	search<-remDr$findElement(using = "id", value ="ctl82_btnCreateReport")
	search$clickElement()

	#Change The Output To CSV & Save!
	output_select<-remDr$findElement(using = "id", value = "ctl82_ucReportViewer_ddViewerType")
	output_select$sendKeysToElement(list("E", "E", "E"))
	change_output<-remDr$findElement(using = "id", value = "ctl82_ucReportViewer_lbChangeOutputType" )
	change_output$clickElement()
}
