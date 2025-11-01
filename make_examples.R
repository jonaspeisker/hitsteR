make_examples <- function(
    paper_size = c("a4", "letter"), 
    card_size = c("small", "original"), 
    color = c(TRUE,FALSE)
) {
  
  for (p in paper_size) {
    for (s in card_size) {
      for (c in color){
        make_cards(
          tracks = my_tracks, 
          file = NULL,
          paper_size = p,
          card_size = s,
          color=c
        )
      }
    }
  }
}
