#' Get playlist tracks from Spotify API 
#'
#' This function returns a dataframe with the name, artists, and recording year of all tracks in a playlist.
#'
#' @param playlist_id Spotify playlist ID string.
#'
#' @returns Dataframe with track info.
#' @export
#'
#' @examples
#' get_tracks("6i2Qd6OpeRBAzxfscNXeWp")
get_tracks <- function(playlist_id){
  access_token <- spotifyr::get_spotify_access_token()
  # scopes <- spotifyr::scopes()
  # scopes[grepl("user-read", scopes) | grepl("playlist", scopes)]
  my_auth <- 
    spotifyr::get_spotify_authorization_code(
      c("playlist-read-private","playlist-read-collaborative"))
  
  # iterate over pages since the API only returns 100 entries at a time
  tracks_raw <- data.frame()
  for (page in seq(0, 200, 100)) {
    tmp <- spotifyr::get_playlist_tracks(playlist_id, offset = page)
    tracks_raw <- rbind(tracks_raw, tmp)
  }
  cat("Got raw data on ", nrow(tracks_raw), " tracks.")
  
  return(tracks_raw)
}
