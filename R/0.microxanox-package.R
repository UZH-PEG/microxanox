#' R/microxanox: Microbial oxic and anoxic ecosystem simulations
#'
#' Ecosystems containing microbes can be oxic (oxygen present) or
#' anoxic (oxygen absent). Under some conditions these states can be both stable even with
#' identical biotic and abiotic circumstances, i.e. they can be
#' alternate stable states, implying history alone can determine the
#' present state. The biological reason is that the microbes can alter
#' the environmental conditions in a way that favour themselves, while
#' making them less suitable for other organisms. This creates mutual
#' inhibition. Which state occurs also depends on numerous
#' abiotic and biotic factors. This package facilitates simulation studies
#' of the influence of several of these factors, and is based on work described in (Bush et al) 2017 (DOI: 10.1038/s41467-017-00912-x)
#'
#' Vignettes include:
#'
#' - A user guide.
#' - A reproduction of some results of Bush et al 2017, on which the simulation is based. It shows the alternate stable states. It also extends the original study by adding temporal forcing and therefore temporal switching between states, and also effects of biotic composition on the response to environmental change.
#'
#'
#' @name microxanox-package
#' @aliases microxanox
#' @docType package
#' @importFrom magrittr %>%
utils::globalVariables(c("Species", "pars", "ssfind_pars"))
NULL
