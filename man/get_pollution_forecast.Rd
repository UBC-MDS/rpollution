% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_pollution_forecast.R
\name{get_pollution_forecast}
\alias{get_pollution_forecast}
\title{Returns a time series plot showing predicted pollutant levels for the next 5 days.}
\usage{
get_pollution_forecast(lat, lon, api_key)
}
\arguments{
\item{lat}{A double type containing geographical latitude coordinate for the location}

\item{lon}{A double type containing geographical longitude coordinate for the location}

\item{api_key}{A character type OpenWeather API key}
}
\value{
A ggplot object
}
\description{
Performs an API request to OpenWeather Air Pollution API,
retrieves weather forecast for the next 5 days, and
creates a time series graph of the pollutants with their concentration levels.
}
\examples{
get_pollution_forecast(50, 50, "APIKEY_example")
}
