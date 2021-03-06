% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tt_download_file.R
\name{tt_download_file}
\alias{tt_download_file}
\title{Reads in TidyTuesday datasets from Github repo}
\usage{
tt_download_file(tt, x, ..., auth = github_pat())
}
\arguments{
\item{tt}{tt_gh object from tt_load_gh function}

\item{x}{index or name of data object to read in. string or int}

\item{...}{pass methods to the parsing functions. These will be passed to
ALL files, so be careful.}

\item{auth}{github Personal Access Token. See PAT section for more
information}
}
\value{
tibble containing the contents of the file downloaded from git
}
\description{
Reads in the actual data from the TidyTuesday github
}
\section{PAT}{


A Github PAT is a personal Access Token. This allows for signed queries to
the github api, and increases the limit on the number of requests allowed
from 60 to 5000. Follow instructions at
<https://happygitwithr.com/github-pat.html> to set the PAT.
}

\examples{
\donttest{
if(interactive()){
tt_gh <- tt_load_gh("2019-01-15")

agencies <- tt_download_file(tt_gh, 1)
launches <- tt_download_file(tt_gh, "launches.csv")
}
}
}
\concept{tt_download_file}
