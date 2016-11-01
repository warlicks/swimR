#' NCAA Qualifying Times
#'
#' A Dataset containing the qualifying times for the 2017 NCAA Division I 
#' Swimming Championships.
#' 
#' @format A data frame with 52 rows and 5 columns:
#' \describe{
#'   \item{event_id}{A numeric id so that standars can be easily joined to top time report.}
#'	 \item{event}{A swimming event contested at NCAA Division I Championships. }
#'	 \item{gender}{Indicates if the qualifying time is for men or women.}
#'	 \item{standard}{Indicates if the qualifying time is an Automatic (A) or Provisional (B).}
#'   \item{swim_time}{The qualifying time for the given event and standard.}
#'   \item{swim_time2}{The qualifying time the given event and standard in seconds.}
#' }
#'
#' @seealso \code{\link{D1Qualifying}} \code{\link{D2Qualifying}}
#' @source \url{https://swimswam.com/ncaa-releases-2016-2017-division-time-standards/}  
"D1Qualifying"

#' NCAA Qualifying Times
#'
#' A Dataset containing the qualifying times for the 2017 NCAA Division II 
#' Swimming Championships.
#' 
#' @format A data frame with 56 rows and 5 columns:
#' \describe{
#'   \item{event_id}{A numeric id so that standars can be easily joined to top time report.}
#'	 \item{event}{A swimming event contested at NCAA Division II Championships. The 1000 Yard Free is contested at NCAA Division II Championships, but not at Division I or Division III}
#'	 \item{gender}{Indicates if the qualifying time is for men or women.}
#'	 \item{standard}{Indicates if the qualifying time is an Automatic (A) or Provisional (B).}
#'   \item{swim_time}{The qualifying time for the given event and standard.}
#'   \item{swim_time2}{The qualifying time the given event and standard in seconds.}
#' }
#'
#' @seealso \code{\link{D1Qualifying}} \code{\link{D3Qualifying}}
#' @source \url{https://swimswam.com/ncaa-division-ii-time-standards-released/}  
"D2Qualifying"

#' NCAA Qualifying Times
#'
#' A Dataset containing the qualifying times for the 2017 NCAA Division III 
#' Swimming Championships.
#' 
#' @format A data frame with 52 rows and 5 columns:
#' \describe{
#'   \item{event_id}{A numeric id so that standars can be easily joined to top time report.}
#'	 \item{event}{A swimming event contested at NCAA Division III Championships.}
#'	 \item{gender}{Indicates if the qualifying time is for men or women.}
#'	 \item{standard}{Indicates if the qualifying time is an Automatic (A) or Provisional (B).}
#'   \item{swim_time}{The qualifying time for the given event and standard.}
#'   \item{swim_time2}{The qualifying time the given event and standard in seconds.}
#' }
#'
#' @seealso \code{\link{D1Qualifying}} \code{\link{D2Qualifying}}
#' @source \url{https://swimswam.com/ncaa-releases-division-iii-time-standards/}  
"D3Qualifying"