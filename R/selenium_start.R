#' Start Selenium Server From R
#'
#' Start Selenium Server From R
#'
#' To Do:
#' * [ ] Set up function to work with chosen directory.  
#' * [ ] Document Function. 
# Example from Old RSelenium Package
  #if (.Platform$OS.type == "unix") {
   # initArgs <- list(command = "java", args = selArgs, wait = FALSE, stdout = FALSE, stderr = FALSE)
  #}

  do.call(system2, initArgs)

selenium_start <- function(){
  args <- list(command = "java", args = "-jar selenium-server-standalone-2.53.1.jar -port 4440", wait = FALSE, stdout = FALSE, stderr = FALSE)
  test <- do.call(system2, args)

}
