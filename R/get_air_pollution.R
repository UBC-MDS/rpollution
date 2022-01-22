#' Returns a map depicting varying pollution levels for a specified location
#'
#' The function makes an API request to the OpenWeather Air Pollution API
#' and fetches pollution data for a given location, then transforms
#' the returned JSON object from the request into a ggplot chart.
#'
#' @param lat Latitude for a given location as a double
#' @param lon Longitude for a given location as a double
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
