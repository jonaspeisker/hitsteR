test_that("set_spotify_credentials() works", {
  expect_error(set_spotify_credentials("", ""))
  expect_error(set_spotify_credentials("asd", "123"))
})
