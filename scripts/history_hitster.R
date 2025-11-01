library(tidyverse)
library(httr)
library(jsonlite)
library(spotifyr)
library(grid)
library(gridtext)
# remotes::install_github('coolbutuseless/ggqr')
library(ggqr)
library(Cairo)
library(scico)
library(fuzzyjoin)

# set my_client_id and my_client_secret in .Renviron
# https://developer.spotify.com/my-applications/#!/applications
source(".Renviron")
source("functions/get_tracks.R")
source("functions/make_cards.R")
source("functions/make_examples.R")

#### get track info from spotify ####
history_tracks <- get_tracks("3mBfXpoqUJEa5MegTG7hJK")

#### get composer info from open opus api ####
oo_base <- "https://api.openopus.org"
oo_dump <- GET(paste0(oo_base, "/work/dump.json"), encode = "json")  
oo_dump_flat <- 
  fromJSON(content(oo_dump, as = "text", encoding = "UTF-8"), flatten = TRUE) %>% 
  .$composers %>% tibble() %>% 
  arrange(birth) %>% 
  mutate(
    birth = as.integer(substr(birth, 1, 4)),
    death = as.integer(substr(death, 1, 4)),
  )
oo_dump_flat

# save missing composers
composers_not_in_oo <- 
  history_tracks %>% 
  stringdist_anti_join(oo_dump_flat, by = c("artist1" ="complete_name")) %>% 
  distinct(artist1)
composers_not_in_oo
write_csv(composers_not_in_oo, file = "data/composers_not_in_oo.csv")

# load 
composers <- 
  read_csv("data/composers.csv") %>% 
  bind_rows(oo_dump_flat) %>% 
  select(
    artist1 = complete_name,
    birth,
    death
  )
composers

# merge track with composer info
history_tracks_merge <- 
  history_tracks %>% 
  stringdist_left_join(composers, by = join_by(artist1))

# make single card layout
make_cards(tracks = my_tracks, color = TRUE)

# make all examples in /output
make_examples()



