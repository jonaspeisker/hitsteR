# hitsteR

[![Language: R](https://img.shields.io/badge/Language-R-blue?logo=r)][r]
[![License: GPLv3](https://img.shields.io/badge/License-GPLv3-blue.svg)][gplv3]

A simple R script to make a game similar to [Hitster][hitster] and [QRSong!][qrsong]. It takes a Spotify playlist as input and generates a pdf with artist, year, and song title on one side and a QR code to play the song on the other side.

## Steps

1. Create a Spotify playlist or select a public one that you want to turn into a game. The years of the songs should be approximately uniformly distributed over several decades. 
1. Create a file login.R which assigns your [Spotify client ID][spotify-dev] and client secret to `my_client_id` and `my_client_secret`, respectively. 
2. Set the [Spotify ID][playlist-id] of the playlist.
3. Run the script.
4. Print the pdf saved in output/ double-sided, mirrored on the long edge. For best results use heavy paper or laminate the pages.
5. Cut pages along the marks.
6. Enjoy!

## Options

- `card_size`
  - `"small"` (3.8 cm), 12 cards per DIN A4 page
  - `"original"` (6.5 cm), 35 cards

## License

HitsteR is licensed under the [GNU General Public License][gplv3], version 3.

[r]:       https://www.r-project.org/
[gplv3]:   https://www.gnu.org/licenses/gpl-3.0.html
[hitster]: https://boardgamegeek.com/boardgame/318243/hitster
[qrsong]:  https://www.qrsong.io/
[howplay]: https://hitstergame.com/en-us/how-to-play-premium/
[spotify-dev]: https://developer.spotify.com/my-applications/#!/applications
[playlist-id]: https://developer.spotify.com/documentation/web-api/concepts/spotify-uris-ids
