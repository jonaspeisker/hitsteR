library(devtools)
load_all()
source(".Renviron")
set_spotify_credentials(my_spotify_client_id, my_spotify_client_secret)
# set my_client_id and my_client_secret in .Renviron
# https://developer.spotify.com/my-applications/#!/applications

# my_auth <-
#   spotifyr::get_spotify_authorization_code(
#     c("playlist-read-private","playlist-read-collaborative"))

# access_token <- spotifyr::get_spotify_access_token()
# 
# my_auth <- 
#   spotifyr::get_spotify_authorization_code(
#     c("playlist-read-private","playlist-read-collaborative"))

# scopes <- spotifyr::scopes()
# scopes[grepl("user-read", scopes) | grepl("playlist", scopes)]

# download track info
track_metadata_raw <- get_track_metadata(playlist_id = "6i2Qd6OpeRBAzxfscNXeWp")

# clean track info
track_metadata <- clean_track_metadata(track_metadata_raw)

# make single card layout
make_cards(tracks = track_metadata, color = TRUE, dir = "inst/extdata")

# make all examples in /output
make_examples()

# todo
- print message based on cairo status code
- Rmd readme
- add logo
- make website
