test_that("make_cards() input checks work", {
  expect_error(
    make_cards(track_metadata, card_size = "foobar"),
    "Card size"
    )
  expect_error(
    make_cards(track_metadata, paper_size = "a3"),
    "Paper size"
    )
  expect_error(
    make_cards(track_metadata, dir = "foo/bar"),
    "does not exist"
    )
  expect_error(
    make_cards(track_metadata, file_name = "foo.bar"),
    "should end with"
    )
  expect_error(
    make_cards(track_metadata, file_name = TRUE),
    "name should be"
    )
  }
)
