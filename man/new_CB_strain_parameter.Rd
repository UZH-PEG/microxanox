% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/new_CB_strain_parameter.R
\name{new_CB_strain_parameter}
\alias{new_CB_strain_parameter}
\title{Create CB strain parameter values}
\usage{
new_CB_strain_parameter(n = 1, values = "bush")
}
\arguments{
\item{n}{number of strains}

\item{values}{Allowed values are:
\itemize{
\item \code{"bush"}: default values from Bush et al (2017) \doi{10.1038/s41467-017-00912-x} will be used
\item \code{"NA"}: all parameter will be set to \code{NA}. Usable for e.g. setting own parameter
}}
}
\value{
object of class \code{CB_strain_parameter}. The object contains a
\code{data.frame} with 8 columns and \code{n} rows. The columns are:

columns:
\itemize{
\item strain_name: the name of the strain
\item g_max_CB:
\item k_CB_P:
\item h_SR_CB:
\item y_P_CB:
\item Pr_CB:
\item m_CB:
\item i_CB:
}
}
\description{
Create CB strain parameter values
}
