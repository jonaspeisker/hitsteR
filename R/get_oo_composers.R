#' Get composer information from Open Opus API 
#'
#' This function returns a dataframe with the name, birth year, and death year of classical composers in the Open Opus database.
#'
#'
#' @returns Dataframe with composer info.
#' @export

get_oo_composers <- function() {
  response <- httr::GET("https://api.openopus.org/work/dump.json", encode = "json")
  stopifnot(response$status_code == 200)
  
  oo_flat <- 
    jsonlite::fromJSON(
      httr::content(response, as = "text", encoding = "UTF-8"), 
      flatten = TRUE
    ) |>
    dplyr::pull(composers) |> 
    data.frame() |>  
    dplyr::arrange(birth) |>  
    dplyr::mutate(
      birth = as.integer(substr(birth, 1, 4)),
      death = as.integer(substr(death, 1, 4)),
    )
  
  message("Got composer names, birth, and death years from Open Opus.")
  return(oo_flat)
}
