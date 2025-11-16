library(hitsteR)
library(tidyverse)
library(spotifyr)
library(grid)
library(gridtext)
# remotes::install_github('coolbutuseless/ggqr')
library(ggqr)
library(Cairo)
library(scico)

# set my_client_id and my_client_secret in .Renviron
# https://developer.spotify.com/my-applications/#!/applications
source(".Renviron")

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
my_tracks_raw <- get_tracks(playlist_id = "6i2Qd6OpeRBAzxfscNXeWp")

# clean track info
my_tracks <- clean_tracks(my_tracks_raw)

# make single card layout
make_cards(tracks = my_tracks, color = TRUE)

# make all examples in /output
make_examples()
