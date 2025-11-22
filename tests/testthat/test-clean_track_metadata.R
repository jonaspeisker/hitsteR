test_that("returned data has correct structure", {
  clean_df <- clean_track_metadata(track_metadata_raw)
  
  expect_s3_class(clean_df, "data.frame")
  expect_named(
    clean_df, 
    c("url", "artist", "year", "track_name"),
    ignore.order = TRUE
    )
  
  expect_type(clean_df$url, "character")
  expect_type(clean_df$artist, "character")
  expect_type(clean_df$year, "integer")
  expect_type(clean_df$track_name, "character")
  }
)
