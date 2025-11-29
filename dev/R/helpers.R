#build documentation
library(devtools)

load_all()
document()
check()

install()
build_vignettes()
build_readme()
# .httr-oauth
# tests/testthat/.httr-oauth
# "output/history_hitster_small_a4_color.pdf"