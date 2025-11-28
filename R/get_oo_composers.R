#' Get composer information from Open Opus API 
#'
#' This function returns a dataframe with the name, birth year, and death year of classical composers in the Open Opus database.
#'
#'
#' @returns Dataframe with composer info.
#' @export

get_oo_composers <- function() {
  # Perform request
  res <- 
    httr2::request("https://api.openopus.org/work/dump.json") |>
    httr2::req_perform()
  httr2::resp_check_status(res)
  
  # Parse JSON (httr2 provides text/JSON helpers)
  oo_flat <- 
    httr2::resp_body_json(res, simplifyVector = TRUE)[["composers"]] |>
    dplyr::arrange(birth) |>  
    dplyr::mutate(
      complete_name,
      epoch,
      birth = as.integer(substr(birth, 1, 4)),
      death = as.integer(substr(death, 1, 4)),
      .keep = "none"
    )
  
  message("Got name, birth, and death year of ", nrow(oo_flat), " composers.")
  return(oo_flat)
}
