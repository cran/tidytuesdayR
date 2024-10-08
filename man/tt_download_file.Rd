% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tt_download_file.R
\name{tt_download_file}
\alias{tt_download_file}
\title{Download a TidyTuesday dataset file}
\usage{
tt_download_file(tt, x, ..., auth = gh::gh_token())
}
\arguments{
\item{tt}{A \code{tt} object, output from \code{\link[=tt_load_gh]{tt_load_gh()}}.}

\item{x}{Index or name of file to download.}

\item{...}{Additional parameters to pass to the parsing functions. Note:
These arguments will be passed for all filetypes.}

\item{auth}{A GitHub token. See \code{\link[gh:gh_token]{gh::gh_token()}} for more details.}
}
\value{
tibble containing the contents of the file downloaded from git
}
\description{
Download an actual data file from the TidyTuesday github repository.
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
tt_gh <- tt_load_gh("2019-01-15")

agencies <- tt_download_file(tt_gh, 1)
launches <- tt_download_file(tt_gh, "launches.csv")
\dontshow{\}) # examplesIf}
}
\concept{tt_download_file}
