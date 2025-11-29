#build documentation
library(devtools)

load_all()
document()
install()
build_vignettes()
build_readme()
check()
# .httr-oauth
# tests/testthat/.httr-oauth
# "output/history_hitster_small_a4_color.pdf"