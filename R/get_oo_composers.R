#' Get composer information from Open Opus API 
#'
#' This function returns a dataframe with the name, birth year, and death year of classical composers in the Open Opus database.
#'
#'
#' @returns Dataframe with composer info.
#' @export

get_oo_composers <- function() {
  oo_base <- "https://api.openopus.org"
  oo_dump <- httr::GET(paste0(oo_base, "/work/dump.json"), encode = "json")  
  oo_dump_flat <- 
    jsonlite::fromJSON(
      httr::content(oo_dump, as = "text", encoding = "UTF-8"), 
      flatten = TRUE) |>
    dplyr::pull(composers) |> data.frame() |>  
    dplyr::arrange(birth) |>  
    dplyr::mutate(
      birth = as.integer(substr(birth, 1, 4)),
      death = as.integer(substr(death, 1, 4)),
    )
  return(oo_dump_flat) 
}