get_tracks <- function(playlist_id = "6i2Qd6OpeRBAzxfscNXeWp"){
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

make_cards <- function(
    tracks,
    file = NULL,
    card_size = "small",
    paper_size = "a4",
    color = FALSE
) {
  require(grid)
  require(gridtext)
  require(ggqr)
  require(Cairo)
  require(scico)
  
  if (paper_size == "a4") {
    paper_width <- 21
    paper_height <- 29.7
  } else if (paper_size == "letter"){
    paper_width <- 21.6
    paper_height <- 27.9
  } else {
    stop("Paper size should be 'a4' or 'letter'.")
  }
  
  if (card_size == "small") {
    card_width <- 3.8
    small_font_size <- 9
    large_font_size <- 32
  } else if (card_size == "original") {
    card_width <- 6.5
    small_font_size <- 12
    large_font_size <- 60
  } else {
    stop("Card size should be 'small' or 'original'.")
  }
  
  if (is.null(file)) {
    out <- paste0("output/hitster_", card_size, "_", paper_size, ifelse(color, "_color", "_bw"), ".pdf")
  } else if (is.character(file)) {
    out <- file
  } else {
    stop("File should be NULL or a string.")
  }
  
  if (color == FALSE) {
    tracks$font_color <- "black"
  } else if (color == TRUE) {
    tracks$font_color <- scico(nrow(tracks), begin=0, end=1, palette = "batlow")
  } else {
    stop("Color should be boolean.")
  }
  
  # number of cards along the axes
  n_cards_x <- paper_width %/% card_width
  n_cards_y <- paper_height %/% card_width
  cards_per_page <- n_cards_x * n_cards_y
  pages <- ceiling(nrow(tracks) / cards_per_page)
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
    file = out, 
    type = "pdf", 
    units = "cm"
  )
  for (page in 1:pages) {
    # make left hand page with track info
    grid.newpage()
    # make lines for cutting
    grid.grill(v = gx_left, h = gy_left, gp=gpar(col="grey"))
    # iterate over cards on each page
    for (i in 1:cards_per_page) {
      track_num <- i + cards_per_page * (page - 1)
      
      # create viewport for artist
      artist_vp <- viewport(
        x = x_left[i], y = y_left[i] + unit(card_width, "cm") / 3,
        width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
        clip = "on" # avoid text on the neighboring cards
      )
      artist_grob <- textbox_grob(
        vp = artist_vp,
        text = tracks$artist[track_num],
        width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
        hjust = 1, vjust = 1, halign = 0.5, valign = 0.5,
        margin = unit(rep(2,4), "pt"),
        gp = gpar(lineheight=0.9, fontsize=small_font_size, col=tracks$font_color[track_num])#,
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
        text = tracks$year[track_num],
        width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
        hjust = 1, vjust = 1, halign = 0.5, valign = 0.5,
        margin = unit(rep(2,4), "pt"),
        gp = gpar(lineheight=0.9, fontsize=large_font_size, col=tracks$font_color[track_num])#,
        # box_gp = gpar(col = "black", fill = "cornsilk")
      )
      grid.draw(year_grob)
      
      # create viewport for track title
      title_vp <- viewport(
        x = x_left[i], y = y_left[i] - unit(card_width, "cm") / 3,
        width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
        clip = "on" # avoid text on the neighboring cards
      )
      title_grob <- textbox_grob(
        vp = title_vp,
        text = tracks$track[track_num],
        width = unit(card_width, "cm"), height = unit(card_width, "cm") / 3, 
        hjust = 1, vjust = 1, halign = 0.5, valign = 0.5,
        margin = unit(rep(2,4), "pt"),
        gp = gpar(lineheight=0.9, fontsize=small_font_size, col=tracks$font_color[track_num])#,
        # box_gp = gpar(col = "black", fill = "lightgreen")
      )
      grid.draw(title_grob)
    }
    
    # make right hand page with qr code
    grid.newpage()
    grid.grill(v = gx_right, h = gy_right, gp=gpar(col="grey"))
    for (i in 1:cards_per_page) {
      track_num <- i + cards_per_page * (page - 1)
      qr <- qrGrob(
        label = tracks$url[track_num], 
        x = x_right[i], y = y_right[i], 
        hjust = 0.5, vjust = 0.5, 
        size = unit(card_width*0.8, "cm")
      )
      grid.draw(qr)
    }
  }
  dev.off()
}