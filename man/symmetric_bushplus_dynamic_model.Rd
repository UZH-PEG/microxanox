% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/symmetric_bushplus_dynamic_model.R
\name{symmetric_bushplus_dynamic_model}
\alias{symmetric_bushplus_dynamic_model}
\title{The rate equations, modified from publication of Bush et al 2017
\doi{10.1093/clinchem/39.5.766}. Equations of antagonistic
environmental variables are identical, while the oxygen and sulfide
diffusivities are forced in antisymmetric manner.
Possibility to simulate multiple strain per functional group as published in
\doi{10.1111/ele.14217} by Limberger et al 2023 remains.}
\usage{
symmetric_bushplus_dynamic_model(
  t,
  state,
  parameters,
  log10aO_forcing_func,
  log10aS_forcing_func,
  ...
)
}
\arguments{
\item{t}{The current time in the simulation}

\item{state}{A vector containing the current (named) values of each state
variable}

\item{parameters}{An object of class \code{runsim_parameter} as returned by
`new_runsim_parameter()``}

\item{log10aO_forcing_func}{function to change oxygen diffusivity \code{aO} depending on \code{t}}

\item{log10aS_forcing_func}{function to change sulfide diffusivity \code{aS} depending on \code{t}}

\item{...}{not used. Needed to catch additional parameters.}
}
\value{
a list containing two elements, namely the rate of change of the
strains, and also the current values of oxygen diffusivity \code{aO}, as well as sulfide diffusivity \code{aS}.
}
\description{
The rate equations, modified from publication of Bush et al 2017
\doi{10.1093/clinchem/39.5.766}. Equations of antagonistic
environmental variables are identical, while the oxygen and sulfide
diffusivities are forced in antisymmetric manner.
Possibility to simulate multiple strain per functional group as published in
\doi{10.1111/ele.14217} by Limberger et al 2023 remains.
}
