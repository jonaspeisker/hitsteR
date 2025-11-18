#' Helper for make_cards()
#' @keywords internal

make_viewport <- function(x_arg, y_arg, y_offset, cw){
  grid::viewport(
    x = x_arg, 
    y = y_arg + y_offset,
    width = grid::unit(cw, "cm"), 
    height = grid::unit(cw, "cm") / 3, 
    clip = "on"
  )
}
