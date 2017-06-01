#' Count Number Of Athletes Competing In Each Event.
#'
#' The function queries the database to determine the number of athletes swimming
#' a given event.  Aggregation is done by event and gender.
#'
#' @param con a database connection.
#' @param team_name A character vector with the name of an NCAA swimming
#' team.
#' @param gender a character vector.  Indicates the output should include men,
#' women or both.  Defaults to "Both".  Other options are "M" for men and "F"
#' for women.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' df <- event_depth(con, team_name = 'Iowa', gender = 'Both')
#'
event_depth <- function(con, team_name, gender = 'Both'){
    # Define Basic SQL Query
    event_depth_query <- "
    Select Distinct
        "EVENT",
        GENDER,
        Count(Distinct ATHLETE_ID) AS ATHLETE_COUNT

    From Event E
        LEFT JOIN RESULT R On E.ID = R.EVENT_ID
        Inner Join Athlete A ON A.ID = R.ATHLETE_ID
        Inner Join TEAM T On T.ID = A.TEAM_ID

    Where
        TEAM_FILLER
        GENDER_FILLER

    Group By
        GENDER,
        \"EVENT\"
    "
    # Update Query Based on arguments in function call
    prepared_query <- sub("TEAM_FILLER", team_name, event_depth_query)

    if(gender == 'Both'){
        prepared_query <- sub('GENDER_FILLER', "", prepared_query)

    } else {
        gender_string <- paste("AND A.GENDER = '", gender, "'", sep = "")

        prepared_query <- sub('GENDER_FILLER', gender_string, prepared_query)
    }


    # Execute Query
    query_results <- DBI::dbSendQuery(con, prepared_query)

    ## Fetch Results
    event_depth_df <- DBI::dbFetch(query_results)
    DBI::dbClearResult(query_results)

    # Return Data Frame
    return(event_depth_df)
}


#' Count Number Of Athletes Competing In each Distance
#'
#' The function queries the database to determine the number of athletes swimming
#' a given distance  Aggregation is done by distance and gender.
#'
#' @param con a database connection.
#' @param team_name A character vector with the name of an NCAA swimming
#' team.
#' @param gender a character vector.  Indicates the output should include men,
#' women or both.  Defaults to "Both".  Other options are "M" for men and "F"
#' for women.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' df <- distance_depth(con, team_name = 'Iowa', gender = 'Both')

distance_depth <- function(con, team_name, gender = 'Both'){
    # Define Basic SQL Query
    distance_depth_query <- "
    Select DISTINCT
    	GENDER,
        SUBSTR(\"EVENT\", 1, (INSTR(\"EVENT\", \" \"))) As DISTANCE,
        Count(Distinct ATHLETE_ID)

    From Event E
        INNER JOIN RESULT R On E.ID = R.EVENT_ID
        Inner Join Athlete A ON A.ID = R.ATHLETE_ID
        Inner Join TEAM T On T.ID = A.TEAM_ID

    Where
    TEAM_FILLER
    GENDER_FILLER

    Group By
        GENDER,
        DISTANCE
    "

    # Update Query Based on arguments in function call
    prepared_query <- sub("TEAM_FILLER", team_name, distance_depth_query)

    if(gender == 'Both'){
        prepared_query <- sub('GENDER_FILLER', "", prepared_query)

    } else {
        gender_string <- paste("AND A.GENDER = '", gender, "'", sep = "")

        prepared_query <- sub('GENDER_FILLER', gender_string, prepared_query)
    }

    # Execute Query
    query_results <- DBI::dbSendQuery(con, prepared_query)

    ## Fetch Results
    distance_depth_df <- DBI::dbFetch(query_results)
    DBI::dbClearResult(query_results)

    # Return Data Frame
    return(distance_depth_df)
}