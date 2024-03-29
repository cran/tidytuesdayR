#' @title Get date of TidyTuesday, given the year and week
#' @description Sometimes we don't know the date we want, but we do know the
#' week. this function provides the ability to pass the year and week we are
#' interested in to get the correct date
#' @param year what year of TidyTuesday to use
#' @param week what week of Tidytuesday to use
#' @examples
#' \donttest{
#' if(interactive()){
#'  tt_date(2019, week = 42)
#'  }
#' }
tt_date <- function(year,week){
  tt_check_date(year, week)
}

#' @title given inputs generate valid TidyTuesday URL
#' @description Given multiple types of inputs, generate
#' @param x either a string or numeric entry indicating the full date of
#' @param week left empty unless x is a numeric year entry, in which case the
#' week of interest should be entered
#' @noRd
tt_check_date <- function(x, week) {
  if (valid_date(x)) {
    tt_check_date.date(x)
  } else if (valid_year(x)) {
    tt_check_date.year(x, week)
  } else {
    stop("Entries must render to a valid date or year")
  }
}

tt_check_date.date <- function(x) {
  tt_year <- lubridate::year(x)
  tt_formatted_date <- tt_date_format(x)
  tt_folders <- tt_weeks(tt_year)
  if (!as.character(tt_formatted_date) %in% tt_folders[["folders"]]) {
    stop(
      paste0(
        tt_formatted_date,
        " is not a date that has TidyTuesday data.\n\tDid you mean: ",
        tt_closest_date(tt_formatted_date, tt_folders$folders),
        "?"
      )
    )
  }
  tt_formatted_date
}

tt_check_date.year <- function(x, week) {

  tt_folders <- tt_weeks(x)

  if (!week %in% tt_folders$week_desc & week > 1) {
    stop(
      paste0(
        "'",week,"' is not a valid TidyTuesday week entry for ",x,".\n",
        "Please enter a valid value for week:\n\t",
        contiguous_weeks(tt_folders$week_desc)
      )
    )
  } else if (week < 1) {
    stop(
      "Week entry must be a valid positive integer value."
    )
  }

  tt_date <- tt_folders$folders[tt_folders$week_desc == week]

  if (!tt_date %in% tt_folders[["folders"]] |
      !tt_folders[["data"]][tt_folders[["folders"]] == tt_date]) {
    stop(
      paste0(
        "Week ",
        week,
        " of TidyTuesday for ",
        x,
        " does not have data available for download from github."
      )
    )
  }

  tt_date_format(tt_date)
}


#' @importFrom stats aggregate na.pass setNames
tt_weeks <- function(year) {
  tt_year <- tt_years()

  if (!as.character(year) %in% tt_year) {
    stop(
      paste0(
        "TidyTuesday did not exist for ",
        year,
        ". \n\t TidyTuesday has only existed from ",
        min(tt_year)
      ),
      " to ",
      max(tt_year)
    )
  }

  ttmf <- tt_master_file()

  tt_week <- aggregate(
    data_files ~ Week + Date,
    ttmf[ttmf$year == year,],
    FUN = function(x)
      ! anyNA(x),
    na.action = na.pass
  )

  list(
    week_desc = tt_week$Week,
    folders = tt_week$Date,
    data = tt_week$data_files
  )

}

tt_years <- function() {
  unique(tt_master_file()$year)
}

#' @importFrom lubridate as_date is.Date
valid_date <- function(x) {
  suppressWarnings({
    !is.na(lubridate::as_date(as.character(x))) | lubridate::is.Date(x)
  })
}

valid_year <- function(x) {
  suppressWarnings({
    !is.na(lubridate::as_date(paste0(as.character(x), "-01-01")))
  })
}

#' @importFrom lubridate year month day ymd
tt_date_format <- function(x) {
  lubridate::ymd(paste0(
    lubridate::year(x),
    "-",
    lubridate::month(x),
    "-",
    lubridate::day(x)
  ))
}

tt_closest_date <- function(inputdate, availabledates) {
  availabledates[
    which.min(abs(difftime(inputdate, availabledates, units = "days")))]
}

