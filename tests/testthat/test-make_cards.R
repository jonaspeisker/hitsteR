test_that("make_cards() works", {
  expect_error(make_cards(track_metadata, card_size = "foobar"))
  expect_error(make_cards(track_metadata, page_size = "a3"))
  expect_error(make_cards(track_metadata, dir = "foo/bar"))
  expect_error(make_cards(track_metadata, file_name = "foo.bar"))
})
