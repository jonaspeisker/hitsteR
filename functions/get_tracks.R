get_tracks <- function(playlist_id){
  require(tidyverse)
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
  tracks_raw <- tibble()
  for (page in seq(0, 200, 100)) {
    tmp <- get_playlist_tracks(playlist_id, offset = page)
    tracks_raw <- bind_rows(tracks_raw, tmp)
  }
  
  # clean data and paste together artist names
  # only the first two artists are considered
  tracks <-
    tracks_raw %>%
    unnest_wider(track.artists) %>% 
    unnest_wider(name, names_sep = "artist") %>%
    mutate(
      artist1 = nameartist1,
      artist = if_else(
        is.na(nameartist2), 
        nameartist1, 
        paste(nameartist1, nameartist2, sep = " & ")
      ),
      year = as.integer(substr(track.album.release_date, 1, 4)),
      track = track.name,
      url = track.external_urls.spotify,
      .keep = "none"
    ) %>% 
    arrange(year)
  print(paste0("Got ", nrow(tracks), " tracks."))
  print("Distribution of years:")
  print(quantile(tracks$year))
  return(tracks)
}