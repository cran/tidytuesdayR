#' @title Listing all available TidyTuesdays
#'
#' @description
#' The TidyTuesday project is a constantly growing repository of data sets.
#' Knowing what type of data is available for each week requires going to the
#' source. However, one of the hallmarks of 'tidytuesdayR' is that you never
#' have to leave your R console. These functions were
#' created to help maintain this philosophy.
#'
#'
#' @details
#' To find out the available datasets for a specific year, the user
#' can use the function `tt_datasets()`. This function will either populate the
#' Viewer or print to console all the available data sets and the week/date
#' they are associated with.
#'
#' To get the whole list of all the data sets ever released by TidyTuesday, the
#' function `tt_available()` was created. This function will either populate the
#' Viewer or print to console all the available data sets ever made for
#' TidyTuesday.
#'
#' @name tt_available
#'
#' @examplesIf interactive()
#' # check to make sure there are requests still available
#' if (rate_limit_check(quiet = TRUE) > 30) {
#'   ## show data available from 2018
#'   tt_datasets(2018)
#'
#'   ## show all data available ever
#'   tt_available()
#' }
#'
NULL

#' @rdname tt_available
#' @inheritParams shared-params
#' @export
#' @returns `tt_available()` returns a `tt_dataset_table_list`, which is a
#' list of `tt_dataset_table`. This class has special printing methods to show
#' the available data sets.
tt_available <- function(auth = gh::gh_token()) {
  tt_year <- sort(tt_years(auth = auth), decreasing = TRUE, )
  names(tt_year) <- tt_year
  datasets <- purrr::map(tt_year, ~ tt_datasets(.x, auth = auth))
  structure(datasets, class = c("tt_dataset_table_list"))
}

#' @rdname tt_available
#' @inheritParams shared-params
#' @export
#' @returns `tt_datasets()` returns a `tt_dataset_table` object. This class has
#'  special printing methods to show the available datasets for the year.
tt_datasets <- function(year, auth = gh::gh_token()) {
  tt_check_year(year, auth = auth)

  ##############################################################################
  ## This portion changes if the dataset tables move, but it doesn't make sense
  ## to abstract it into a separate function.
  readme_html <- gh_get_readme_html(file.path("data", year), auth = auth)
  datasets <- rvest::html_table(readme_html)[[1]]
  ##############################################################################

  structure(datasets,
    .html = readme_html,
    class = "tt_dataset_table"
  )
}

#' Printing Utilities for Listing Available Datasets
#'
#' printing utilities for showing the available datasets for a specific year or
#' all time
#' @inheritParams base::print
#' @param is_interactive Whether the function is being used interactively.
#' @returns `x`, invisibly
#' @name tt_print
#' @examplesIf interactive()
#' # check to make sure there are requests still available
#' if (rate_limit_check(quiet = TRUE) > 30) {
#'   available_datasets_2018 <- tt_datasets(2018)
#'   print(available_datasets_2018)
#'
#'   all_available_datasets <- tt_available()
#'   print(all_available_datasets)
#' }
NULL

#' @rdname tt_print
#' @export
print.tt_dataset_table <- function(x, ..., is_interactive = interactive()) {
  if (is_interactive) {
    tmpHTML <- save_tt_object(x, fn = make_tt_dataset_html)
    html_viewer(tmpHTML)
  } else {
    print(data.frame(unclass(x)))
  }
  invisible(x)
}

make_tt_dataset_html <- function(x, file = tempfile(fileext = ".html")) {
  readme <- attr(x, ".html")
  xml2::write_html(readme, file = file)
  invisible(readme)
}

save_tt_object <- function(x, fn) {
  tmpHTML <- tempfile(fileext = ".html")
  fn(x, file = tmpHTML)
  return(tmpHTML)
}

#' @rdname tt_print
#' @export
print.tt_dataset_table_list <- function(x, ..., is_interactive = interactive()) {
  if (is_interactive) {
    tmpHTML <- save_tt_object(x, fn = make_tt_dataset_list_html)
    html_viewer(tmpHTML)
  } else {
    names(x) |>
      purrr::map(
        function(.x, x) {
          list(
            table = data.frame(unclass(x[[.x]])), year = .x
          )
        },
        x = x
      ) |>
      purrr::walk(
        function(.x) {
          cat(paste0("Year: ", .x$year, "\n\n"))
          print(.x$table)
          cat("\n\n")
        }
      )
  }
  invisible(x)
}

make_tt_dataset_list_html <- function(x, file = tempfile(fileext = ".html")) {
  readme <- names(x) |>
    purrr::map_chr(
      function(.x, x) {
        year_table <- attr(x[[.x]], ".html") |>
          rvest::html_element("table")
        paste(
          "<h2>", .x, "</h2>",
          as.character(year_table),
          ""
        )
      },
      x = x
    ) |>
    paste(collapse = "")

  readme <- paste(
    "<article class='markdown-body entry-content' itemprop='text'>",
    paste("<h1>TidyTuesday Datasets</h1>", readme), "</article>"
  ) |>
    xml2::read_html() |>
    github_page()

  xml2::write_html(readme, file = file)
  invisible(readme)
}

github_page <- function(page_content) {
  header <- paste0(
    "<head><link crossorigin=\"anonymous\" ",
    "media=\"all\" rel=\"stylesheet\" ",
    "href=\"https://cdnjs.cloudflare.com/ajax/libs/",
    "github-markdown-css/3.0.1/github-markdown.min.css\"></head>"
  )

  body <- page_content |>
    rvest::html_elements("body") |>
    as.character() |>
    enc2native()

  xml2::read_html(paste0(header, body))
}
