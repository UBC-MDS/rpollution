#' @import jsonlite
#' @import httr
#' @import plotly
library(jsonlite)
library(httr)
library(plotly)
library(tibble)
library(tidyr)

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
#' get_air_pollution(49.28, 123.12, "APIKEY_example", "example_title")
get_air_pollution <- function(lat, lon, api_key, fig_title) {
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

  api_url <- "http://api.openweathermap.org/data/2.5/air_pollution"

  query <- list(
    lat = lat,
    lon = lon,
    appid = api_key
  )

  res <- GET(api_url, query = query)
  raw_data <- fromJSON(content(res, as = "text", encoding = "UTF-8"),
                   flatten = TRUE)
  data <- tibble(raw_data$list) |>
    mutate(lon = raw_data$coord$lon, lat = raw_data$coord$lat) |>
    select(-dt, -main.aqi) |>
    rename(
      CO = components.co,
      NO = components.no,
      SO2 = components.so2,
      PM2.5 = components.pm2_5,
      PM10 = components.pm10,
      NH3 = components.nh3,
      NO2 = components.no2,
      O3 = components.o3
    ) |>
    pivot_longer(c(CO, NO, NO2, O3, SO2, PM2.5, PM10, NH3))

  g <- list(
    # scope = 'usa',
    projection = list(type = 'natural earth'),
    showland = TRUE,
    landcolor = toRGB("gray95"),
    subunitcolor = toRGB("gray85"),
    countrycolor = toRGB("gray85"),
    countrywidth = 0.5,
    subunitwidth = 0.5
  )

  fig <- plot_geo(data, lat = ~lat, lon = ~lon)
  fig <- fig %>% add_markers(
    color = ~name, size = ~value
  )
  # fig <- fig %>% colorbar(title = "Incoming flights<br />February 2011")
  # fig <- fig %>% layout(
  #   title = 'Most trafficked US airports<br />(Hover for airport)', geo = g
  # )

  fig

  # tryCatch(
  #   {
  #     res <- GET(api_url, query = query)
  #
  #     # Stop if response status is not 200
  #     httr::stop_for_status(res)
  #
  #     data <- fromJSON(content(res, as = "text", encoding = "UTF-8"),
  #                      flatten = TRUE
  #     )
  #
  #     data = tibble(data$list)
  #     data
  #   },
  #   error = function(e) {
  #     "An error occurred fetching data from the API"
  #   }
  # )

  # data

  # data = data.melt(
  #   id_vars=["lon", "lat"],
  #   value_vars=["co", "no", "no2", "o3", "so2", "pm2_5", "pm10", "nh3"],
  # )
  #
  # data = data.replace(
  #   {
  #     "co": "CO",
  #     "no": "NO",
  #     "no2": "NO2",
  #     "o3": "O3",
  #     "so2": "SO2",
  #     "pm2_5": "PM2.5",
  #     "pm10": "PM10",
  #     "nh3": "NH3",
  #   }
  # )
  #
  # fig = px.scatter_geo(
  #   data,
  #   lon="lon",
  #   lat="lat",
  #   color="variable",
  #   size="value",
  #   projection="natural earth",
  #   labels={
  #     "lon": "Longitude",
  #     "lat": "Latitude",
  #     "variable": "Pollutant",
  #     "value": "Conc. (µg/m^3)",
  #   },
  #   title=fig_title,
  # )
  #
  # fig.update_layout(
  #   legend={"yanchor": "middle", "y": 0.72, "xanchor": "right", "x": 1.2},
  #   title={"y": 0.85, "x": 0.47, "xanchor": "center", "yanchor": "top"},
  # )
  #
  # return fig




}
