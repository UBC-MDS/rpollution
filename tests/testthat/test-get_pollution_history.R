library(httptest)

context("get pollution history")

#' Tests get_pollution_history function with mock http requests
with_mock_api({
  test_that("Function returns air pollution history as a tibble", {
    data <- get_pollution_history(1606488670,1606747870, 49.28 , 123.12,
                                  "api_key")
    expect_true(is_tibble(data))
    expect_equal(colnames(data), c("dt",
                                  "main.aqi",
                                  "components.co",
                                  "components.no",
                                  "components.no2",
                                  "components.o3",
                                  "components.so2",
                                  "components.pm2_5",
                                  "components.pm10",
                                  "components.nh3"))
  })

  test_that("Function returns a failing API error", {
    m <- get_pollution_history(1606487670,
                               1606747870,
                               49.28 ,
                               123.12,
                               "error_api_key")
    print(m)
    expect_equal(get_pollution_history(1606487670,
                                       1606747870,
                                       49.28 ,
                                       123.12,
                                       "error_api_key"),
                 "An error occurred fetching data from the API")
  })

  test_that("Errors are thrown with incorrect inputs", {
    expect_error(get_pollution_history("start_date",
                                       1606747870,
                                       49.28 ,
                                       123.12,
                                       "api_key"),
                 "start_date input should be an int")

    expect_error(get_pollution_history(1606488670,
                                       1606747870.7389,
                                       49.28 ,
                                       123.12,
                                       "api_key"),
                 "end_date input should be an int")

    expect_error(get_pollution_history(1606488670,
                                       1606747870,
                                       "49.28",
                                       123.12,
                                       "api_key"),
                 "latitude input should be a float or an integer")

    expect_error(get_pollution_history(1606488670,
                                       1606747870,
                                       49.28 ,
                                       "123.12",
                                       "api_key"),
                 "longitude input should be a float or an integer")
    })
})


