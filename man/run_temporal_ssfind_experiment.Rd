% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_temporal_ssfind_experiment.R
\name{run_temporal_ssfind_experiment}
\alias{run_temporal_ssfind_experiment}
\title{Run a stable state finding experiment via the temporal method (e.g. get the stable states for
different levels of oxygen diffusivity when oxygen diffusivity is varied in a stepwise fashion).}
\usage{
run_temporal_ssfind_experiment(
  parameter,
  var_expt,
  total_initial_abundances,
  cores = 1
)
}
\arguments{
\item{parameter}{an object of class \code{runsim_parameter} as returned by
\code{new_runsim_parameter()}.}

\item{var_expt}{An object that describes different levels of diversity that
should be examined. This object is \strong{not} created in the 'microxanox' package.}

\item{total_initial_abundances}{An object containing the total abundance in
each functional group.}

\item{cores}{Number of cores to use. If more than one, then \code{multidplyr} is used}
}
\value{
an \code{tibble} object containing the stable state result, as well as the simulation parameters.
}
\description{
Calls the function \code{run_temporal_ssfind} for each parameter set.
}
