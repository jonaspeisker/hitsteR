test_that("set_spotify_credentials() works", {
  expect_error(
    set_spotify_credentials("", ""),
    "malformed")
  expect_error(
    set_spotify_credentials("asd", "123"),
    "malformed")
  }
)
