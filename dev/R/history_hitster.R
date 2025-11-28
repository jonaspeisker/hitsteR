library(tidyverse)
library(scico)
library(fuzzyjoin)

source(".Renviron")
set_spotify_credentials(my_spotify_client_id, my_spotify_client_secret)

#### get track info from spotify ####
history_tracks_raw <- get_track_metadata("3mBfXpoqUJEa5MegTG7hJK")

# only keep first artist (composer)
history_tracks <- clean_track_metadata(history_tracks_raw, artists_n = 1)

#### get composer info from open opus api ####
oo_composers <- get_oo_composers()

# save missing composers
composers_not_in_oo <- 
  history_tracks |> 
  stringdist_anti_join(oo_composers, by = c("artist" ="complete_name")) %>% 
  distinct(artist)
composers_not_in_oo
composers_not_in_oo |> 
  write_csv(file = "dev/data/composers_not_in_oo.csv")

# load 
composers <- 
  read_csv("dev/data/composers_not_in_oo_filled.csv") |> 
  bind_rows(oo_composers) |> 
  rename(
    artist = complete_name
  )
composers

# merge track with composer info
history_tracks_merge <- 
  history_tracks |> 
  stringdist_left_join(
    composers, by = join_by(artist), 
    distance_col = "dist"
    ) |>  
  mutate(
    artist = paste0(artist.x, " (", birth, "-", death, ")"),
    # impute year of composition
    year = round((birth + death) / 2)
  ) %>% 
  select(url, artist, year, track_name)
history_tracks_merge |> 
  write_csv(file = "dev/data/history_tracks_merge.csv")

# make single card layout
make_cards(
  tracks = history_tracks_merge, 
  color = TRUE,
  file = "dev/examples/history_hitster_small_a4_color.pdf"
  )



