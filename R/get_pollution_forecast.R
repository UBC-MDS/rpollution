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

  tryCatch(
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
      "An error occurred fetching data from the API"
    }
  )
  if(nrow(data) > 1){
    tryCatch(
      {
        data$dt <- as.POSIXct(as.numeric(as.character(d$dt)), origin="1970-01-01", tz="GMT")
        colnames(data) <- c('dt', 'main.api','co', 'no', 'no2', 'o3', 'so2',
                         'pm2_5', 'pm10', 'nh3')

        data <- tidyr::pivot_longer(data = d,
                                 cols = c('co', 'no', 'no2', 'o3', 'so2',
                                          'pm2_5', 'pm10', 'nh3'),
                                 names_to = "Pollutants",
                                 values_to = "Concentration")

        chart <- ggplot2::ggplot(d) + aes(
          x = dt,
          y = Concentration,
          color = Pollutants) + geom_line() +
          labs(
            x = "Date time",
            y = "Concentration",
            color = "Pollutants",
            title = "Pollutant concentration for the next 5 days"
          ) +
          facet_wrap(~Pollutants, scales = 'free')
      },
      error = function(e) {
        "An error occured in plotting"
      }
    )
    return(chart)
  }
  else{
    stop("Insufficient data to forecast/plot.")
  }

}
