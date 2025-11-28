#build documentation
library(devtools)
library(testthat)
# source(".Renviron")

load_all()
install()
document()
build_vignettes()
build_readme()
check()
# .httr-oauth
# tests/testthat/.httr-oauth