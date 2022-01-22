#' Returns a map depicting varying pollution levels for a specified location
#'
#' The function makes an API request to the OpenWeather Air Pollution API
#' and fetches pollution data for a given location, then transforms
#' the returned JSON object from the request into a ggplot chart.
#'
#' @param lat Latitude for a given location as a float/integer
#' @param lon Longitude for a given location as a float/integer
#' @param api_key The API key for OpenWeather as a string
#' @param fig_title The title of the returned ggplot as a string
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' get_pollution_history(49.28, 123.12, "APIKEY_example", "example_title")
get_air_pollution <- function(lat, lon, api_key, fig_title) {

}

#' Returns a time series plot showing predicted pollutant levels for the next 5 days.
#'
#' Performs an API request to OpenWeather Air Pollution API,
#' retrieves weather forecast for the next 5 days, and
#' creates a time series graph of the pollutants with their concentration levels.
#'
#' @param lat A double type containing geographical latitude coordinate for the location
#' @param lon A double type containing geographical longitude coordinate for the location
#' @param api_key A character type OpenWeather API key
#'
#' @return A ggplot object
#' @export
#'
#' @examples
#' get_pollution_forecast(50, 50, "APIKEY_example")
get_pollution_forecast <- function(lat, lon, api_key) {

}
