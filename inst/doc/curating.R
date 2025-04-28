## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----tt_curate_data-----------------------------------------------------------
# library(tidytuesdayR)
# tt_curate_data()

## ----tt_clean-----------------------------------------------------------------
# library(tidytuesdayR)
# tt_clean()

## ----cleaning-----------------------------------------------------------------
# library(tidyverse)
# library(janitor)
# 
# states <- state.x77 |>
#   tibble::as_tibble(rownames = "state") |>
#   janitor::clean_names() |>
#   dplyr::mutate(
#     dplyr::across(
#       c("population", "income", "frost", "area"),
#       as.integer
#     )
#   )

## ----tt_save_dataset----------------------------------------------------------
# tt_save_dataset(states)

## ----tt_intro-----------------------------------------------------------------
# tt_intro()

## ----states-population--------------------------------------------------------
# library(tidyverse)
# state_outlines <- ggplot2::map_data("state")
# states |>
#   dplyr::select(state, population) |>
#   dplyr::mutate(region = tolower(state)) |>
#   dplyr::left_join(state_outlines, by = "region") |>
#   ggplot(aes(long, lat, group = state, fill = population)) +
#   geom_polygon() +
#   coord_map() +
#   theme_void()
# ggsave(
#   usethis::proj_path("tt_submission", "states_population.png"),
#   width = 5, height = 3, units = "in",
#   bg = "white"
# )

## ----tt-meta------------------------------------------------------------------
# tt_meta(
#   title = "The 50 US States",
#   article_title = "U.S. Department of Commerce, Bureau of the Census",
#   article_url = "https://www.census.gov/",
#   source_title = "The R datasets package",
#   source_url = "https://www.r-project.org/",
#   image_filename = "states_population.png",
#   image_alt = "A map of the continental United States, with each state colored in shades of blue by population as of 1975. California and New York are the lightest, indicating the highest population. Maine, New Hampshire, Vermont, and the Plains States are all quite dark, indicating low population.",
#   attribution = "Jon Harmon, Data Science Learning Community",
#   github = "jonthegeek",
#   bluesky = "jonthegeek.com",
#   linkedin = "jonthegeek",
#   mastodon = "fosstodon.org/@jonthegeek"
# )

## ----tt_submit----------------------------------------------------------------
# tt_submit()

