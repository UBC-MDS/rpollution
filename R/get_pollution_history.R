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

}
