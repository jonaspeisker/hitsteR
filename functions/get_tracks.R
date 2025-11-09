get_tracks <- function(playlist_id){
  require(spotifyr)
  
  # set credentials for Spotify API
  Sys.setenv(SPOTIFY_CLIENT_ID = my_client_id)
  Sys.setenv(SPOTIFY_CLIENT_SECRET = my_client_secret)
  access_token <- get_spotify_access_token()
  # scopes <- scopes()
  # scopes[grepl("user-read", scopes) | grepl("playlist", scopes)]
  my_auth <- 
    get_spotify_authorization_code(
      c("playlist-read-private","playlist-read-collaborative"))
  
  # iterate over pages since the API only returns 100 entries at a time
  tracks_raw <- data.frame()
  for (page in seq(0, 200, 100)) {
    tmp <- get_playlist_tracks(playlist_id, offset = page)
    tracks_raw <- rbind(tracks_raw, tmp)
  }
  print(paste0("Got raw data on ", nrow(tracks_raw), " tracks."))
  
  return(tracks_raw)
}
