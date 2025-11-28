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
oo_dump_flat <- get_oo_composers()

# save missing composers
composers_not_in_oo <- 
  history_tracks |> 
  stringdist_anti_join(oo_dump_flat, by = c("artist" ="complete_name")) %>% 
  distinct(artist)
composers_not_in_oo
write_csv(composers_not_in_oo, file = "data/composers_not_in_oo.csv")

# load 
composers <- 
  read_csv("data/composers.csv") |> 
  bind_rows(oo_dump_flat) |> 
  select(
    artist = complete_name,
    birth,
    death
  )
composers

# merge track with composer info
history_tracks_merge <- 
  history_tracks |> 
  stringdist_left_join(composers, by = join_by(artist)) |>  
  mutate(
    artist = paste0(artist.x, " (", birth, "-", death, ")")
  ) %>% 
  select(-year)
history_tracks_merge |> 
  write_csv(file = "data/history_tracks_merge.csv")

# make single card layout
make_cards(
  tracks = history_tracks_merge, 
  color = TRUE,
  file = "output/history_hitster_small_a4_color.pdf"
  )

# make all examples in /output
make_examples()



