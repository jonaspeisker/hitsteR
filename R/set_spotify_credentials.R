#' Set Spotify API credentials
#'
#' This function checks the format of the supplied Spotify credentials and stories them in the environment variables SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET.
#'
#' @param spotify_client_id Spotify client ID
#' @param spotify_client_secret Spotify client secret
#' @export

set_spotify_credentials <- function(
    spotify_client_id, 
    spotify_client_secret
    ) {
  # test validity of input
  if (!grepl("^[A-Za-z0-9]{32}$", spotify_client_id)) {
    stop("API id looks malformed.")
  }
  if (!grepl("^[A-Za-z0-9]{32}$", spotify_client_secret)) {
    stop("API secret looks malformed.")
  }
  # set env vars
  Sys.setenv(SPOTIFY_CLIENT_ID = spotify_client_id)
  Sys.setenv(SPOTIFY_CLIENT_SECRET = spotify_client_secret)
  cat("Spotify credentials successfully set.")
}
