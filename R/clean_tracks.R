#' Clean dataframe of Spotify tracks
#'
#' This function unnests track artists and track names and formats the required artist, year, and track_name columns.
#'
#' @param tracks_df dataframe returned by get_tracks()
#'
#' @returns cleaned Dataframe with track info.
#' @export

clean_tracks <- function(tracks_df) {
  tracks <-
    tracks_df |>
    tidyr::unnest_wider(track.artists) |> 
    tidyr::unnest_wider(name, names_sep = "artist") |> 
    dplyr::mutate(
      artist1 = nameartist1,
      # only the first two artists are considered due to space limitations
      artist = ifelse(
        is.na(nameartist2), 
        nameartist1, 
        paste(nameartist1, nameartist2, sep = " & ")
      ),
      year = as.integer(substr(track.album.release_date, 1, 4)),
      track_name = track.name,
      url = track.external_urls.spotify,
      .keep = "none"
    ) |> 
    dplyr::arrange(year)
  
  return(tracks)
}
