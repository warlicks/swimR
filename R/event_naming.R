#' Create Clean Event Names
#'
#' An Internal Function used in \code{\link{data_clean}}
#'
#' @param data A data frame passed from \code{data_clean}.  

event_naming <- function(data){

	data <- data %>% dplyr::mutate(event = substring(full_desc, 1, (unlist(gregexpr("SCY", full_desc)) - 1))) %>% 

	dplyr::mutate(event = stringr::str_trim(event, side = "right"))
}
