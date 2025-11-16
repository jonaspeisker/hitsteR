#' Get playlist tracks from Spotify API 
#'
#' This function returns a dataframe with the name, artists, and recording year of all tracks in a playlist.
#'
#' @param playlist_id a [Spotify playlist ID](https://developer.spotify.com/documentation/web-api/concepts/spotify-uris-ids)
#'
#' @returns data.frame with raw track info.
#' @export

get_tracks <- function(playlist_id){
  # iterate over pages since the API only returns 100 entries at a time
  tracks_raw <- data.frame()
  for (page in seq(0, 200, 100)) {
    tmp <- spotifyr::get_playlist_tracks(playlist_id, offset = page)
    tracks_raw <- rbind(tracks_raw, tmp)
  }
  
  cat("Got raw data on ", nrow(tracks_raw), " tracks.")
  return(tracks_raw)
}
