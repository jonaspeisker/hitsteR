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

test_df <- tidyr::tibble(
  track.name = c(" Song A ", "Song B", "Song C "),
  track.artists = c(
    list(c(data.frame(name = "Artist 1 "), data.frame(name = "Artist 2"))), 
    list(c(data.frame(name = "Artist 1 "), data.frame(name = "Artist 2"))), 
    list(c(
      data.frame(name = "Artist 1 "), 
      data.frame(name = "A veeeeeeeeery looooong Artist 2")
      )) 
  ),
  track.external_urls.spotify = 
    c("spotify.com/1", "spotify.com/2", "spotify.com/3"),
  track.album.release_date = c("2015-01-01", "2016-01-01", "2017-01-01")
)

test_that("clean_track_metadata trims whitespace", {
  out <- clean_track_metadata(test_df)
  
  expect_s3_class(out, "data.frame")
  # track_name should be trimmed
  expect_false(any(grepl("^\\s|\\s$", out$track_name[!is.na(out$track_name)])))
  # artists should be collapsed
  expect_equal(nrow(out), 3)
})

test_that("clean_track_metadata selects the correct number of authors", {
  out <- clean_track_metadata(test_df, artists_n = 1)
  
  expect_s3_class(out, "data.frame")
  # artists should be collapsed
  expect_equal(out$artist, rep("Artist 1", 3))
})

test_that("clean_track_metadata omits long artists", {
  out <- clean_track_metadata(test_df, artists_char = 34)
  
  expect_s3_class(out, "data.frame")
  # artists should be collapsed
  expect_equal(
    out$artist, 
    c("Artist 1 & Artist 2", "Artist 1 & Artist 2", "Artist 1")
    )
})
