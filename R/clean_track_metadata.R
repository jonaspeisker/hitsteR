#' Clean dataframe of Spotify tracks
#'
#' This function unnests track artists and track names and formats the required artist, year, and track_name columns.
#'
#' @param tracks_df dataframe returned by get_track_metadata()
#'
#' @returns cleaned dataframe
#' @export

clean_track_metadata <- function(tracks_df) {
  tracks <-
    tracks_df |>
    tidyr::unnest_longer(track.artists) |> 
    tidyr::unnest_wider(track.artists) |>
    dplyr::rename(
      artist_name = name,
      url = track.external_urls.spotify
      ) |>
    dplyr::group_by(url) |>
    dplyr::summarise(
      artist = paste(artist_name, collapse = " & "),
      year = 
        track.album.release_date |> 
        dplyr::first() |> 
        substr(1, 4) |> 
        as.integer(),
      track_name = dplyr::first(track.name),
      .groups = "drop"
    ) |>
    dplyr::arrange(year)
  message("Cleaned data of ", nrow(tracks), " tracks.")
  return(tracks)
}
