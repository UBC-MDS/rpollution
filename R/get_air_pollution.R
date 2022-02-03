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
#' @return plotly object
#' @export
#'
#' @examples
#' get_air_pollution(49.28, 123.12, "APIKEY_example", "example title")
get_air_pollution <- function(lat, lon, api_key, fig_title = "") {
  if (!is.numeric(lat)) {
    stop("Latitude input should be a float or an integer")
  }

  if (!is.numeric(lon)) {
    stop("Longitude input should be a float or an integer")
  }

  if (!is.character(api_key)) {
    stop("API Key should be a string")
  }

  if (lat < -90.0 | lat > 90.0) {
    stop("Enter valid latitude values (Range should be -90<Latitude<90)")
  }

  if (lon < -180.0 | lon > 180.0) {
    stop("Enter valid longitude values (Range should be -180<Longitude<180)")
  }

  if (!is.character(fig_title)) {
    stop("Figure title should be a string")
  }

  api_url <- "http://api.openweathermap.org/data/2.5/air_pollution"

  query <- list(
    lat = lat,
    lon = lon,
    appid = api_key
  )

  tryCatch(
    {
      res <- httr::GET(api_url, query = query)

      # Stop if response status is not 200
      httr::stop_for_status(res)

      raw_data <- jsonlite::fromJSON(httr::content(res, as = "text", encoding = "UTF-8"),
        flatten = TRUE
      )

      data <- tibble::tibble(raw_data[["list"]]) %>%
        dplyr::mutate(lon = raw_data$coord$lon, lat = raw_data$coord$lat) %>%
        dplyr::select(-dt, -main.aqi) %>%
        dplyr::rename(
          CO = components.co,
          NO = components.no,
          SO2 = components.so2,
          PM2.5 = components.pm2_5,
          PM10 = components.pm10,
          NH3 = components.nh3,
          NO2 = components.no2,
          O3 = components.o3
        ) %>%
        tidyr::pivot_longer(c(
          CO,
          NO,
          NO2,
          O3,
          SO2,
          PM2.5,
          PM10,
          NH3
        ))

      g <- list(
        projection = list(type = "natural earth")
      )

      fig <- plotly::plot_geo(data, lat = ~lat, lon = ~lon)
      fig <- fig %>% plotly::add_markers(
        color = ~name,
        size = ~value,
        text = ~ paste(
          "Pollutant =",
          name,
          "\n",
          "Conc. (ug/m^3) =",
          value,
          "\n",
          "Latitude =",
          lat,
          "\n",
          "Longitude =",
          lon
        ),
        hoverinfo = "text"
      )

      fig <- fig %>%
        plotly::layout(
          title = list(
            text = fig_title,
            x = 0,
            y = 1,
            xref = "paper",
            yref = "paper",
            yanchor = "bottom",
            xanchor = "left"
          ),
          legend = list(
            yanchor = "center",
            y = 0.5,
            title = list(text = "Pollutant")
          )
        )

      fig
    },
    error = function(e) {
      "An error occurred fetching data from the API"
    }
  )
}
