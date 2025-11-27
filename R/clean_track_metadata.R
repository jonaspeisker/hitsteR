#' Clean dataframe of Spotify tracks
#'
#' This function unnests track artists and track names and formats the required artist, year, and track_name columns.
#'
#' @param tracks_df dataframe returned by get_track_metadata()
#' @param artists_n number of artists to include (default: 10)
#' @param artists_char cumulative number of characters to include in the artist field (default: 34)
#'
#' @returns cleaned dataframe
#' @export

clean_track_metadata <- function(
    tracks_df, 
    artists_n = 10,
    artists_char = 34
    ) {
  tracks <-
    tracks_df |>
    tidyr::unnest_longer(track.artists) |> 
    tidyr::unnest_wider(track.artists) |>
    dplyr::rename(
      artist_name = name,
      url = track.external_urls.spotify
      ) |>
    dplyr::group_by(url) |>
    dplyr::filter(
      # only keep artists up to cumulative length
      cumsum(nchar(artist_name)) <= artists_char,
      # only keep first n artists
      1:dplyr::n() <= artists_n
    ) |> 
    dplyr::mutate(
      #trim white space
      track_name = trimws(track.name),
      artist_name = trimws(artist_name)
    ) |> 
    dplyr::summarise(
      artist = paste(artist_name, collapse = " & "),
      year = 
        track.album.release_date |> 
        dplyr::first() |> 
        substr(1, 4) |> 
        as.integer(),
      track_name = dplyr::first(track_name),
      .groups = "drop"
    ) |>
    dplyr::arrange(year)
  message("Cleaned data of ", nrow(tracks), " tracks.")
  return(tracks)
}
