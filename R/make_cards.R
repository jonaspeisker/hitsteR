#' Make playing cards.
#'
#' This function makes a pdf of cards with song info on one side and a QR code to the Spotify URL on the other side.
#'
#' @param tracks data.frame containing the columns artist, year, and track_name
#' @param file_name a file name ending in .pdf to write the output to (default: NULL, set name automatically based on parameters)
#' @param dir an existing path to write the file (default: "./", the current working directory)
#' @param card_size "small" (3.8 cm) or "original" (6.5 cm) (default: "small")
#' @param paper_size size "a4" or "letter" (default: "a4")
#' @param color color font based on year (default: FALSE)
#'
#' @returns PDF file
#' @export

make_cards <- function(
    tracks,
    file_name = NULL,
    dir = "./",
    card_size = "small",
    paper_size = "a4",
    color = FALSE) {
  
  # set paper size
  if (paper_size == "a4") {
    paper_width <- 21
    paper_height <- 29.7
  } else if (paper_size == "letter"){
    paper_width <- 21.6
    paper_height <- 27.9
  } else {
    stop("Paper size should be 'a4' or 'letter'.")
  }
  
  # set card size
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
  
  # check whether path exists and dir is entered
  if (!dir.exists(dir)) {
    stop("Directory does not exist.")
  } else {
    dir <- ifelse(endsWith(dir, "/"), dir, paste0(dir, "/"))
  }

  # check file format
  if (!endsWith(file_name, ".pdf")) {
    stop("File name should end with .pdf.")
  }
  
  # set file name
  if (is.null(file_name)) {
    out <- paste0(
      dir,
      "hitster_", card_size, "_", paper_size, 
      ifelse(color, "_color", "_bw"), ".pdf"
      )
  } else if (is.character(file_name)) {
    out <- paste0(dir, file_name)
  } else {
    stop("File name should be NULL or a string.")
  }
  
  # set color
  if (color == FALSE) {
    tracks$font_color <- "black"
  } else if (color == TRUE) {
    tracks$font_color <- scico::scico(
      nrow(tracks), 
      begin=0, end=1, 
      palette = "batlow"
      )
  } else {
    stop("Color should be boolean.")
  }

  # determine number of cards along the axes
  n_cards_x <- paper_width %/% card_width
  n_cards_y <- paper_height %/% card_width
  cards_per_page <- n_cards_x * n_cards_y
  pages <- ceiling(nrow(tracks) / cards_per_page)
  # determine margins on each side of the axes
  margin_x <- (paper_width %% card_width) / 2
  margin_y <- (paper_height %% card_width) / 2
  
  # left hand page (track info)
  # grid coords
  gx_left <- grid::unit(seq(margin_x, paper_width, card_width), "cm")
  gy_left <- grid::unit(seq(margin_y, paper_height, card_width), "cm")
  # coords of card centroids
  x_left <- rep(
    gx_left[-1] - grid::unit(card_width/2, "cm"), 
    times = length(gy_left)-1
    )
  y_left <- rep(
    gy_left[-1] - grid::unit(card_width/2, "cm"), 
    each = length(gx_left)-1
    )
  # data.frame(x_left,y_left)
  
  # right hand page (QR codes, mirrored horizontally)
  # grid coords
  gx_right <- grid::unit(seq(paper_width - margin_x, 0, -card_width), "cm")
  gy_right <- gy_left
  # coords of card centroids
  x_right <- rep(
    gx_right[-1] + grid::unit(card_width/2, "cm"), 
    times = length(gy_right)-1
    )
  y_right <- rep(
    gy_right[-1] - grid::unit(card_width/2, "cm"), 
    each = length(gx_right)-1
    )
  # data.frame(x_right,y_right)
  
  # create viewports for artist (top third of card)
  artist_vp_list <- mapply(
    FUN = make_viewport,
    x_arg = x_left,
    y_arg = y_left,
    y_offset = grid::unit(card_width, "cm") / 3,
    cw = grid::unit(card_width, "cm"),
    SIMPLIFY = FALSE
  )

  # create viewports for year (middle third of card)
  year_vp_list <- mapply(
    FUN = make_viewport,
    x_arg = x_left,
    y_arg = y_left,
    y_offset = grid::unit(0, "cm"),
    cw = grid::unit(card_width, "cm"),
    SIMPLIFY = FALSE
    )
  
  # create viewports for track title (bottom third of card)
  title_vp_list <- mapply(
    FUN = make_viewport,
    x_arg = x_left,
    y_arg = y_left,
    y_offset = -1 * grid::unit(card_width, "cm") / 3,
    cw = grid::unit(card_width, "cm"),
    SIMPLIFY = FALSE
  )
  
  #### make pdf ####
  Cairo::Cairo(
    width = paper_width, 
    height = paper_height, 
    file = out, 
    type = "pdf", 
    units = "cm"
  )
  
  for (page in 1:pages) {
    # make left hand page with track info
    grid::grid.newpage()
    # make lines for cutting
    grid::grid.grill(v=gx_left, h=gy_left, gp=grid::gpar(col="grey"))
    # iterate over cards on each page
    for (i in 1:cards_per_page) {
      track_num <- i + cards_per_page * (page - 1)
      
      # create viewport for artist (top third of card)
      artist_grob <- gridtext::textbox_grob(
        vp = artist_vp_list[[i]],
        text = tracks$artist[track_num],
        width = grid::unit(card_width, "cm"), 
        height = grid::unit(card_width, "cm") / 3, 
        hjust = 1, vjust = 1, halign = 0.5, valign = 0.5,
        margin = grid::unit(rep(2,4), "pt"),
        gp = grid::gpar(
          lineheight=0.9, 
          fontsize=small_font_size, 
          col=tracks$font_color[track_num]
          )#,
        #box_gp = grid::gpar(col = "black", fill = "lightblue")
      )
      grid::grid.draw(artist_grob)
      
      # create viewport for year (middle third of card)
      year_grob <- gridtext::textbox_grob(
        vp = year_vp_list[[i]],
        text = tracks$year[track_num],
        width = grid::unit(card_width, "cm"), 
        height = grid::unit(card_width, "cm") / 3, 
        hjust = 1, vjust = 1, halign = 0.5, valign = 0.5,
        margin = grid::unit(rep(2,4), "pt"),
        gp = grid::gpar(
          lineheight=0.9, 
          fontsize=large_font_size, 
          col=tracks$font_color[track_num]
          )#,
        #box_gp = grid::gpar(col = "black", fill = "cornsilk")
      )
      grid::grid.draw(year_grob)
      
      # create viewport for track title (bottom third of card)
      title_grob <- gridtext::textbox_grob(
        vp = title_vp_list[[i]],
        text = tracks$track_name[track_num],
        width = grid::unit(card_width, "cm"), 
        height = grid::unit(card_width, "cm") / 3, 
        hjust = 1, vjust = 1, halign = 0.5, valign = 0.5,
        margin = grid::unit(rep(2,4), "pt"),
        gp = grid::gpar(
          lineheight=0.9, 
          fontsize=small_font_size, 
          col=tracks$font_color[track_num]
          )#,
        #box_gp = grid::gpar(col = "black", fill = "lightgreen")
      )
      grid::grid.draw(title_grob)
    }
    
    # make right hand page with qr code
    grid::grid.newpage()
    grid::grid.grill(v = gx_right, h = gy_right, gp=grid::gpar(col="grey"))
    for (i in 1:cards_per_page) {
      track_num <- i + cards_per_page * (page - 1)
      qr <- ggqr::qrGrob(
        label = tracks$url[track_num], 
        x = x_right[i], 
        y = y_right[i], 
        hjust = 0.5, vjust = 0.5, 
        size = grid::unit(card_width*0.8, "cm")
      )
      grid::grid.draw(qr)
    }
  }
  grDevices::dev.off()
  cat("Wrote file to", out)
}
