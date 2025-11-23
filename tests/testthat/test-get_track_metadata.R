test_that("playlist id check work", {
  expect_error(
    get_track_metadata(""),
    "malformed")
  expect_error(
    get_track_metadata("asd123"),
    "malformed")
  }
)
