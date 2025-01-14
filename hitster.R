library(tidyverse)
library(spotifyr)
library(grid)
library(gridtext)
# remotes::install_github('coolbutuseless/ggqr', force = TRUE)
library(ggqr)
library(Cairo)

#### settings ####
# set ID of the playlist you want to turn into a game 
# https://developer.spotify.com/documentation/web-api/concepts/spotify-uris-ids
# for playlist "Top 100 Greatest Songs of All Time"
# https://open.spotify.com/playlist/6i2Qd6OpeRBAzxfscNXeWp?si=b7546d23b6284203
playlist_id  <-  "6i2Qd6OpeRBAzxfscNXeWp"

# set my_client_id and my_client_secret in login.R
# https://developer.spotify.com/my-applications/#!/applications
source(".Renviron")

# set card size, possible values: 
# small (3.8 cm), 12 cards per DIN A4 page
# original (6.5 cm), 35 cards per page
card_size <- "small"

#### get tracks from Spotify ####
Sys.setenv(SPOTIFY_CLIENT_ID = my_client_id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = my_client_secret)
access_token <- get_spotify_access_token()
# scopes <- scopes()
# scopes[grepl("user-read", scopes) | grepl("playlist", scopes)]
my_auth <- 
  get_spotify_authorization_code(
    c("playlist-read-private","playlist-read-collaborative"))

# iterate over pages since the API only returns 100 entries at a time
songs_raw <- tibble()
for (page in seq(0, 200, 100)) {
  tmp <- get_playlist_tracks(playlist_id, offset = page)
  songs_raw <- bind_rows(songs_raw, tmp)
}

# clean data and paste together artist names
# only the first two artists are considered
songs <-
  songs_raw %>%
  unnest_wider(track.artists) %>% 
  unnest_wider(name, names_sep = "artist") %>%
  mutate(
    artist = if_else(
      is.na(nameartist2), 
      nameartist1, 
      paste(nameartist1, nameartist2, sep = " & ")
    ),
    year = substr(track.album.release_date, 1, 4),
    song = track.name,
    url = track.external_urls.spotify,
    .keep = "none"
  ) 

#### set up plotting parameters ####
# paper size DIN A4: 21.0 cm x 29.7 cm
paper_width <- 21
paper_height <- 29.7
card_width <- case_when(
  card_size == "small" ~ 3.8,
  card_size == "original" ~ 6.5
  )
small_font_size <- case_when(
  card_size == "small" ~ 9,
  card_size == "original" ~ 12
)
large_font_size <- case_when(
  card_size == "small" ~ 32,
  card_size == "original" ~ 60
)
# number of cards along the axes
n_cards_x <- paper_width %/% card_width
n_cards_y <- paper_height %/% card_width
cards_per_page <- n_cards_x * n_cards_y
pages <- ceiling(nrow(songs) / cards_per_page)
# margins on each side of the axes
margin_x <- (paper_width %% card_width) / 2
margin_y <- (paper_height %% card_width) / 2

# left hand page
# grid coords
gx_left <- unit(seq(margin_x, paper_width, card_width), "cm")
gy_left <- unit(seq(margin_y, paper_height, card_width), "cm")
# content coords
x_left <- rep(gx_left[-1] - unit(card_width/2, "cm"), times = length(gy_left)-1)
y_left <- rep(gy_left[-1] - unit(card_width/2, "cm"), each = length(gx_left)-1)
# data.frame(x_left,y_left)

# right hand page (mirrored on y axis)
gx_right <- unit(seq(paper_width - margin_x, 0, -card_width), "cm")
gy_right <- gy_left
x_right <- rep(gx_right[-1] + unit(card_width/2, "cm"), times = length(gy_right)-1)
y_right <- rep(gy_right[-1] - unit(card_width/2, "cm"), each = length(gx_right)-1)
# data.frame(x_right,y_right)

#### make pdf ####
Cairo(
  width = paper_width, 
  height = paper_height, 
  file = paste0("output/hitster_", card_size, ".pdf"), 
  type = "pdf", 
  units = "cm"
)
for (page in 1:pages) {
  # make left hand page with song info
  grid.newpage()
  # make lines for cutting
  grid.grill(v = gx_left, h = gy_left, gp=gpar(col="grey"))
  # iterate over cards on each page
  for (i in 1:cards_per_page) {
    song_num <- i + cards_per_page * (page - 1)
    
    # create viewport for artist
    artist_vp <- viewport(
      x = x_left[i], y = y_left[i] + unit(card_width, "cm") / 3,
      width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
      clip = "on" # avoid text on the neighboring cards
      )
    artist_grob <- textbox_grob(
      vp = artist_vp,
      text = songs$artist[song_num],
      width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
      hjust = 1, vjust = 1, halign = 0.5, valign = 0.5,
      margin = unit(rep(2,4), "pt"),
      gp = gpar(lineheight=0.9, fontsize=small_font_size)#,
      # box_gp = gpar(col = "black", fill = "lightblue")
    )
    grid.draw(artist_grob)

    # create viewport for year        
    year_vp <- viewport(
      x = x_left[i], y = y_left[i],
      width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
      clip = "on" # avoid text on the neighboring cards
    )
    year_grob <- textbox_grob(
      vp = year_vp,
      text = songs$year[song_num],
      width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
      hjust = 1, vjust = 1, halign = 0.5, valign = 0.5,
      margin = unit(rep(2,4), "pt"),
      gp = gpar(lineheight=0.9, fontsize=large_font_size)#,
      # box_gp = gpar(col = "black", fill = "cornsilk")
    )
    grid.draw(year_grob)
    
    # create viewport for song title
    title_vp <- viewport(
      x = x_left[i], y = y_left[i] - unit(card_width, "cm") / 3,
      width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
      clip = "on" # avoid text on the neighboring cards
    )
    title_grob <- textbox_grob(
      vp = title_vp,
      text = songs$song[song_num],
      width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
      hjust = 1, vjust = 1, halign = 0.5, valign = 0.5,
      margin = unit(rep(2,4), "pt"),
      gp = gpar(lineheight=0.9, fontsize=small_font_size)#,
      # box_gp = gpar(col = "black", fill = "lightgreen")
    )
    grid.draw(title_grob)
  }
  
  # make right hand page with qr code
  grid.newpage()
  grid.grill(v = gx_right, h = gy_right, gp=gpar(col="grey"))
  for (i in 1:cards_per_page) {
    song_num <- i + cards_per_page * (page - 1)
    qr <- qrGrob(
      label = songs$url[song_num], 
      x = x_right[i], y = y_right[i], 
      hjust = 0.5, vjust = 0.5, 
      size = unit(card_width*0.8, "cm")
    )
    grid.draw(qr)
  }
}
dev.off()