#' Returns a dataframe of pollution history for a location between
#' a specified date range. 
#' 
#' Given a specified date range, the function makes an API request 
#' to the OpenWeather Air Pollution API and fetches historic 
#' pollution data for a given location.
#' 
#' Note: Historical data is accessible from 27th November 2020
#'
#' @param start_date A UNIX timestamp, e.g. 1606488670
#' @param end_date A UNIX timestamp, e.g. 1606747870
#' @param lat Latitude coordinate for a given location as a float
#' @param lon Longitude coordinate for a given location as a float
#' @param api_key The API key (string) for OpenWeather
#' #'
#' @return A tibble dataframe containing the historic data of pollution levels
#' @export
#'
#' @examples
#' get_pollution_history(1606488670, 1606747870, 49.28, 123.12, "APIKEY_example")
