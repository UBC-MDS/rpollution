#' @import jsonlite
#' @import httr
library(jsonlite)
library(httr)
library(ggplot2)

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

  if (!is.numeric(lat)) {
    stop("latitude input should be a float or an integer")
  }
  if (!is.numeric(lon)) {
    stop("longitude input should be a float or an integer")
  }
  if (!is.character(api_key)) {
    stop("API Key should be a string")
  }
  if (lat < -90.0 | lat > 90.0){
    stop("Enter valid latitude values (Range should be -90<Latitude<90)")
  }
  if (lon < -180.0 | lon > 180.0){
    stop("Enter valid longitude values (Range should be -180<Longitude<180)")
  }

  api_url <- "http://api.openweathermap.org/data/2.5/air_pollution/forecast?"

  query <- list(lat = lat,
                lon = lon,
                appid = api_key
  )

  api_error <- tryCatch(
    {
      res <- GET(api_url, query = query)

      # Stop if response status is not 200
      httr::stop_for_status(res)

      data <- fromJSON(content(res, as = "text", encoding = "UTF-8"),
                       flatten = TRUE
                       )
      data <- data$list
    },
    error = function(e) {
      e
      }
    )
  if(!inherits(api_error, "error")){
    if(nrow(data) > 1){
      chart_error <- tryCatch(
        {
          data$dt <- as.POSIXct(as.numeric(as.character(data$dt)), origin="1970-01-01", tz="GMT")
          colnames(data) <- c('dt', 'main.aqi','co', 'no', 'no2', 'o3', 'so2',
                              'pm2_5', 'pm10', 'nh3')

          data <- tidyr::pivot_longer(data = data,
                                      cols = c('co', 'no', 'no2', 'o3', 'so2',
                                               'pm2_5', 'pm10', 'nh3'),
                                      names_to = "Pollutants",
                                      values_to = "Concentration")

          chart <- ggplot2::ggplot(data, aes(
            x = dt,
            y = Concentration,
            color = Pollutants)) + geom_line() +
            labs(
              x = "Date time",
              y = "Concentration",
              color = "Pollutants",
              title = "Pollutant concentration for the next 5 days"
            ) + facet_wrap(~Pollutants, scales = 'free')

        },
        error = function(er) {
          er
          }
        )
      if(!inherits(chart_error,"error")){
        return(chart)
      }
      else{
        print(chart)
        stop("An error occured in plotting")
      }
      }
    else{
      stop("Insufficient data to forecast/plot.")
    }
  }
  else{
    print('HERE????')
    print(api_error)
    "An error occurred fetching data from the API"
  }
}
