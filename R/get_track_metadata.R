#' Get metadata on all tracks in Spotify playlist 
#'
#' This function returns a data.frame with the name, artists, and recording year of all tracks in a playlist.
#'
#' @param playlist_id a [Spotify playlist ID](https://developer.spotify.com/documentation/web-api/concepts/spotify-uris-ids)
#'
#' @returns data.frame with raw track info.
#' @export

get_track_metadata <- function(playlist_id){
  
  if (!grepl("^[A-Za-z0-9]{22}$", playlist_id)) {
    stop("Playlist id looks malformed.")
  }
  
  # Get the playlist metadata (contains total number of tracks)
  playlist_metadata <- spotifyr::get_playlist(playlist_id)
  total_tracks <- playlist_metadata$tracks$total
  message("Playlist contains ", total_tracks, " tracks.")
  
  # Spotify returns 100 tracks per request
  offsets <- seq(0, total_tracks - 1, by = 100)
  tracks_list <- lapply(offsets, function(off) {
    spotifyr::get_playlist_tracks(playlist_id, offset = off)
  })
  # Combine into one data frame
  tracks_raw <- dplyr::bind_rows(tracks_list)
  
  message("Got raw data on ", nrow(tracks_raw), " tracks.")
  return(tracks_raw)
  
}
