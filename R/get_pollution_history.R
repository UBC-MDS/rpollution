#' @import jsonlite
#' @import httr
library(jsonlite)
library(httr)
library(tidyverse)

#' Returns a dataframe of pollution history for a location between
#' a specified date range.
#'
#' Given a specified date range, the function makes an API request
#' to the OpenWeather Air Pollution API and fetches historic
#' pollution data for a given location.
#'
#' Note: Historical data is accessible from 27th November 2020
#'
#' @param start_date The start date as a UNIX timestamp, e.g. 1606488670
#' @param end_date The end date as a UNIX timestamp, e.g. 1606747870
#' @param lat Latitude coordinate for a given location as a double
#' @param lon Longitude coordinate for a given location as a double
#' @param api_key The API key for OpenWeather as a string
#'
#' @return tibble with data containing pollution history
#' @export
#'
#' @examples
#' get_pollution_history(1606488670, 1606747870, 49.28, 123.12, "APIKEY_example")
get_pollution_history <- function(start_date, end_date, lat, lon, api_key) {

  if(!is.numeric(start_date)) {
    stop("start_date input should be an int")
  }

  if( !is.numeric(end_date) | end_date != round(end_date)) {
    stop("end_date input should be an int")
  }

  if(!is.numeric(lat)) {
    stop("latitude input should be a float or an integer")
  }

  if(!is.numeric(lon)) {
    stop("longitude input should be a float or an integer")
  }


  api_url <- "http://api.openweathermap.org/data/2.5/air_pollution/history?"

  query <- list(lat = lat,
                lon = lon,
                start = start_date,
                end = end_date,
                appid = api_key
                )

  tryCatch({
    res <- GET(api_url, query = query)

    # Stop if response status is not 200
    httr::stop_for_status(res)

    data <- fromJSON(content(res, as = "text", encoding = "UTF-8"),
                     flatten = TRUE)

    as_tibble(data$list)
  },
   error = function(e){
     "An error occurred fetching data from the API"
   })
}
