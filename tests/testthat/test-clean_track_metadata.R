test_that("cleaning metadata works", {
  clean_df <- clean_track_metadata(track_metadata_raw)
  expect_s3_class(clean_df, "data.frame")
})
