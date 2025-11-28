# Install needed packages
# install.packages(c("hexSticker", "magick", "qrcode"))
library(tidyverse)
library(hexSticker)
library(ggqr)

sticker(
  ggqr::qrGrob("https://github.com/jonaspeisker/hitsteR"),
  package = "hitsteR",
  p_size = 20,
  p_color = "white",
  p_y = 1.55,
  s_x = 1,
  s_y = 0.9,
  h_fill = "#1DB954",   # Spotify-green background
  h_color = "#000000",  # Border color
  filename = "man/figures/logo.png",
  dpi = 300
)
