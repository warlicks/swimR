#' Parse & Format Dates For {RSelenium}'s \code{remoteDriver}
#'
#' \code{start_dateParse} is an internal function used in \code{individual_swims}.
#'
#'\code{start_dateParse} is an internal function used in \code{individual_swims}.  It prepares the \emph{start_date} and \emph{end_date} argument in \code{individual_swims} so that \strong{RSelenium} can pass it to the date fields on \href{http://www.usaswimming.org/DesktopDefault.aspx?TabId=1971&Alias=Rainbow&Lang=en}{USA Swimming's Top Times Report} form.  It converts each character in \emph{start_date} into an element of a list.
#'
#' @param date
#'
#' @return a list.  Each character from the start date is an element of the list.
#'
#' @seealso \code{\link[RSelenium]{remoteDriver}} \code{\link{individual_swims}}
#'
date_parse <- function(date){

	frame <- as.data.frame(
		t(
		unlist(
		strsplit(date, "-")
		)
		), stringsAsFactors = FALSE) # Split Date Elements & put in data frame.
	names(frame) <- c('yr', 'mnth', 'day') # Assign Names

	mnth <- unlist(strsplit(frame$mnth, NULL))
	day <- unlist(strsplit(frame$day, NULL))
	year <- unlist(strsplit(frame$yr, NULL))



	seq <- list(mnth[1], mnth[2], '/', day[1], day[2], '/', year[1], year[2], year[3], year[4])
	return(seq)
}