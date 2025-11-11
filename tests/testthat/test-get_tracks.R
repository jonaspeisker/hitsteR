test_that("tracks are correctly retrieved from Spotity API", {
  result <- get_tracks(playlist_id = "6i2Qd6OpeRBAzxfscNXeWp")
  expect_s3_class(result, "data.frame")
  }
)
