library(httptest)

#' Tests get_pollution_forecast function with mock http requests
with_mock_api({
  test_that("Function chart contains wrong data", {
    chart <- get_pollution_forecast(
      lat = 50.0,
      lon = 50.0,
      api_key = "api_key"
    )

    expect_equal(colnames(chart$data), c(
      "dt",
      "main.aqi",
      "Pollutants",
      "Concentration"
    ))
    expect_equal(nrow(chart$data), 16)
    expect_equal(chart$labels$x, "Date time")
    expect_equal(chart$labels$y, "Concentration")
    expect_equal(chart$labels$colour, "Pollutants")
    expect_equal(
      chart$labels$title,
      "Pollutant concentration for the next 5 days"
    )
  })

  test_that("Function returns a failing API error", {
    expect_equal(
      get_air_pollution(
        lat = 50.0,
        lon = 50.0,
        api_key = "error_api_key"
      ),
      "An error occurred fetching data from the API"
    )
  })

  test_that("Errors are thrown with incorrect inputs", {
    expect_error(
      get_air_pollution(
        "49.28",
        123.12,
        "api_key"
      ),
      "Latitude input should be a float or an integer"
    )

    expect_error(
      get_air_pollution(
        49.28,
        "123.12",
        "api_key"
      ),
      "Longitude input should be a float or an integer"
    )

    # expect_error(
    #   get_air_pollution(
    #    -100,
    #     123.12,
    #     "api_key"
    #   ),
    #   "Enter valid latitude values (Range should be -90<Latitude<90)"
    # )

    expect_error(
      get_air_pollution(
        49.28,
        200,
        "api_key"
      ),
      "Enter valid longitude values (Range should be -180<Longitude<180)"
    )

  })
})
