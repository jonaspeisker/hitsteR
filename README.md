# hitsteR

A simple R script to make a game similar to [Hitster](https://hitstergame.com/en-gb/) and [QRSong!](https://www.qrsong.io/). It takes a Spotify playlist as input and generates a pdf with artist, year, and song title on one side and a QR code to play the song on the other side.

1. Create a Spotify playlist or select a public one that you want to turn into a game. The years of the songs should be approximately uniformly distributed over several decades. 
1. Create a file login.R which assigns your [Spotify client ID](https://developer.spotify.com/my-applications/#!/applications) and client secret to `my_client_id` and `my_client_secret`, respectively. 
2. Set the [Spotify ID](https://developer.spotify.com/documentation/web-api/concepts/spotify-uris-ids) of the playlist.
3. Run the script.
4. Print the pdf saved in output/ double-sided, mirrored on the long edge. For best results use heavy paper or laminate the pages.
5. Cut pages along the marks.
6. Enjoy!