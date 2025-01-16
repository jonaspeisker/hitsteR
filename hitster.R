library(tidyverse)
library(spotifyr)
library(grid)
library(gridtext)
# remotes::install_github('coolbutuseless/ggqr')
library(ggqr)
library(Cairo)

# set my_client_id and my_client_secret in .Renviron
# https://developer.spotify.com/my-applications/#!/applications
source(".Renviron")
source("hitster_fun.R")

# download and clean track info
my_tracks <- get_tracks()

# make card layout
make_cards(tracks = my_tracks)
