% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_replication_ssfind_parameter.R
\name{get_ssbyaN_parameter}
\alias{get_ssbyaN_parameter}
\title{Extract \code{runsim_parameter} from \code{replication_ssfind_parameter}}
\usage{
get_ssbyaN_parameter(result, i)
}
\arguments{
\item{result}{object of class \code{replication_ssfind_parameter} as generated by \code{new_replication_ssfind_parameter()}}

\item{i}{Index of the individual simulation to extract the parameter for}
}
\value{
an object of class \code{replication_ssfind_parameter}
}
\description{
Extract the parameter to run an individual simulation from either a parameter set for a
steady state determination (\code{run_replication_ssfind_parameter()}) or the result set returned.
}
