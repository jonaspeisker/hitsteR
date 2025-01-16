# hitsteR

[![Language: R](https://img.shields.io/badge/Language-R-blue?logo=r)][r]
[![License: GPLv3](https://img.shields.io/badge/License-GPLv3-blue.svg)][gplv3]

R functions to make a game similar to [Hitster][hitster] and [QRSong!][qrsong]. Based on a Spotify playlist, it generates a pdf with artist, year, and song title on one side and a QR code to play the song on the other side.

## Steps

1. Create a Spotify playlist or select a public one that you want to turn into a game. The years of the songs should be approximately uniformly distributed over several decades. 
1. Assign your [Spotify client ID and client secret][spotify-dev] to `my_client_id` and `my_client_secret` in .Renviron. 
3. Run the hitster.R to download and clean the track info with get_tracks() and create a pdf of playing cards with make_cards().
4. Print the pdf double-sided and mirrored on the long edge. For best results use heavy paper or laminate the pages.
5. Cut pages along the marks.
6. Enjoy!

## Functions

- get_tracks(playlist_id): download track info from Spotify and prepare it for plotting 
  - playlist_id: a [Spotify playlist ID][playlist-id] (default: [Top 100 Greatest Songs of All Time](https://open.spotify.com/playlist/6i2Qd6OpeRBAzxfscNXeWp?si=b7546d23b6284203))

- make_cards(tracks, file, card_size, paper_size, color): make a pdf of playing cards
  - tracks: a data frame created with get_tracks()
  - file: a valid path to a pdf file (default: NULL, save file in output/)
  - card_size: "small" (3.8 cm) or "original" (6.5 cm) (default: "small")
  - paper_size: "a4" or "letter" (default: "a4"),
  - color: color font based on year (default: FALSE), planned

## License

HitsteR is licensed under the [GNU General Public License][gplv3], version 3.

[r]:       https://www.r-project.org/
[gplv3]:   https://www.gnu.org/licenses/gpl-3.0.html
[hitster]: https://boardgamegeek.com/boardgame/318243/hitster
[qrsong]:  https://www.qrsong.io/
[howplay]: https://hitstergame.com/en-us/how-to-play-premium/
[spotify-dev]: https://developer.spotify.com/my-applications/#!/applications
[playlist-id]: https://developer.spotify.com/documentation/web-api/concepts/spotify-uris-ids
