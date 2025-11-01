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
source("functions/get_tracks.R")
source("functions/make_cards.R")
source("functions/make_examples.R")

# download and clean track info
my_tracks <- get_tracks(playlist_id = "6i2Qd6OpeRBAzxfscNXeWp")

# make single card layout
make_cards(tracks = my_tracks, color = TRUE)

# make all examples in /output
make_examples()
