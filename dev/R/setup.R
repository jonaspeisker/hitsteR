# install.packages(c("devtools", "roxygen2","usethis", "testthat", "available"))
library(devtools)

# make package
available::available("hitsteR")
setwd("~/Dokumente/")
create_package("hitsteR")

# add vignette and readme
use_vignette("hitster", "Making a song guessing game in R")
use_readme_rmd()

# make folder for dev files
dir.create("dev")
use_build_ignore("dev")

# import packages
use_package("R", type = "Depends", min_version = "4.1")
use_package("dplyr", "Imports")
use_package("tidyr", "Imports")
use_package("spotifyr", "Imports")
use_package("Cairo", "Imports")
use_package("grid", "Imports")
use_package("gridtext", "Imports")
use_package("scico", "Imports")
use_dev_package(
  package = "ggqr",
  type = "Imports",
  remote = "github::coolbutuseless/ggqr"
  )
use_package("jsonlite", "Imports")
use_package("httr", "Imports")
use_package("grDevices", "Imports")

# setup test environment
use_testthat()
use_test("get_tracks")
use_test("make_cards")
use_test("set_spotify_credentials")
use_test("clean_track_metadata")

# add license
use_gpl_license(version = 3, include_future = TRUE)

# add data
use_data(track_metadata_raw, overwrite = TRUE)
use_data(track_metadata, overwrite = TRUE)

# add github actions
use_github_action("check-standard")
use_github_action("test-coverage")
# touch .github/pkg.lock


