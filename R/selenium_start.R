#' Start Selenium Standalone Server From R
#'
#' Start Selenium Standalone Server From R
#'
#' The function is based \code{\link[RSelenium]{startServer}}, which is now depricated.  In particular returned value is based on the source code of the former function.  
#'
#' While the function replicates some of the features of \code{\link[RSelenium]{startServer}}, it is not as robust.  Currently the function is designed and has only been tested on macOS.   
#'
#' @param dir A directory where the Selenium Standalone Server file is located
#'
#' @return Returns a list of two functions.  \code{getPID} provides the process id for the running Selenium server.  \code{stop} function utilizes the process id to stop the Selenium server.
#' 
#' @export

start_selenium <- function(dir = NULL){
	# Set directory to current working directory if no specified
	if(is.null(dir)){
		dir = getwd()
	}
	
	# Create file path
	file_path = file.path(path.expand(dir), 
		                  "selenium-server-standalone-2.53.1.jar")
	
	# Check that standalone server exists in the provided file path. 
	if(!file.exists(file_path)){
		stop("Selenium Standalone Server Not Found.  Please Check Loacation of Selenium Standalone Server ")
	}
	
	# Put together command options
	options = paste("-jar", file_path, "-port 4440", sep = " ")
	
	cmd <- list(command = "java", 
			   args = options, 
			   wait = FALSE, stdout = FALSE, stderr = FALSE)
	
	# Execute Command
	do.call(system2, cmd)

	# Find process ID & process name using the following cmd line instructions
	sPids <- system('ps -Ao"pid"', intern = TRUE)
    sArgs <- system('ps -Ao"args"', intern = TRUE)

    #
    idx <- grepl(file_path, sArgs)
    selPID <- as.integer(sPids[idx])

    list(
	    stop = function(){
	      tools::pskill(selPID)
	    },
	    getPID = function(){
	      return(selPID)
    	}
  )
}
