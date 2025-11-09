clean_tracks <- function(tracks_df) {
  require(tidyr)
  require(dplyr)
  
  # clean data and paste together artist names
  # only the first two artists are considered due to space limitations
  tracks <-
    tracks_df %>%
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
  
  return(tracks)
}