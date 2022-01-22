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
