library(httptest)

#' Tests get_pollution_forecast function with mock http requests
with_mock_api({
  test_that("Function chart contains wrong data", {
    fig <- get_air_pollution(
      lat = 50.0,
      lon = 50.0,
      api_key = "api_key",
      fig_title = "Air pollution"
    )

    fig_id <- fig[['x']][["cur_data"]]

    # Check that a plotly object is returned
    expect_equal(class(fig)[1],"plotly")

    # Check that the plot is a geographic scatter plot
    expect_equal(fig[['x']][['layout']][['mapType']],"geo")

    # Check that the plot title is correct
    expect_equal(
      fig[["x"]][["layoutAttrs"]][[fig_id]][["title"]][["text"]],
      "Air pollution"
    )

    #Check that the legend title is correct
    expect_equal(
      fig[["x"]][["layoutAttrs"]][[fig_id]][["legend"]][["title"]][["text"]],
      "Pollutant"
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

    expect_error(
      get_air_pollution(
       -100,
        123.12,
        "api_key"
      ),
      "Enter valid latitude values (Range should be -90<Latitude<90)",
      fixed = TRUE
    )

    expect_error(
      get_air_pollution(
        49.28,
        200,
        "api_key"
      ),
      "Enter valid longitude values (Range should be -180<Longitude<180)",
      fixed = TRUE
    )

    expect_error(
      get_air_pollution(
        50,
        50,
        "api_key",
        123
      ),
      "Figure title should be a string",
      fixed = TRUE
    )

  })
})
