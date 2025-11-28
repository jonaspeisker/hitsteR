#build documentation
library(devtools)
# source(".Renviron")

load_all()
install()
document()
build_vignettes()
build_readme()
check()
# .httr-oauth
# tests/testthat/.httr-oauth
# "output/history_hitster_small_a4_color.pdf"