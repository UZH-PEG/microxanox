#' Create initial state of the system, selecting them from various preset options.
#'
#' @param n_CB number of CB strains
#' @param n_PB number of PB strains
#' @param n_SB number of SB strains
#' @param values Allowed values are:
#' - `"bush_anoxic_fig2ab"`: initial conditions for Bush et al 2017 figure 2 a & b 
#' - `"bush_oxic_fig2cd"`: initial conditions for Bush et al 2017 figure 2 c & d 
#' - `"bush_ssfig3"`: initial conditions for Bush et al 2017 figure e
#' - `"NA"`: all initial values set to `NA`. Usable for e.g. setting own initial state
#'   
#' @return initial state \code{vector} aof the system s part of the strain_starter
#' @md
#' @export
#'
new_initial_state <- function(
  n_CB = 1,
  n_PB = 1,
  n_SB = 1,
  values = "bush_anoxic_fig2ab"
){
  
  if (is.na(values)) {
    values <- "NA"
  }
  
  switch(
    EXPR = values,
    "bush_oxic_fig2cd" = {
      CB <- 1e8
      PB <- 1e2
      SB <- 1e2
      SO <- 500
      SR <- 50
      O  <- 300
      P  <- 4
    },
    "bush_anoxic_fig2ab" = {
      CB <-  5e1
      PB <-  1e7
      SB <-  1e7
      SO <-  300
      SR <-  300
      O  <-  1e1
      P  <-  1e1
    },
    "bush_ssfig3" = {
      CB <-  NA
      PB <-  1e8
      SB <-  1e8
      SO <-  250
      SR <-  350
      O  <-  150
      P  <-  9.5
    },
    "NA" = {
      CB <-  as.numeric(NA)
      PB <-  as.numeric(NA)
      SB <-  as.numeric(NA)
      SO <-  as.numeric(NA)
      SR <-  as.numeric(NA)
      O  <-  as.numeric(NA)
      P  <-  as.numeric(NA)
    },
    stop("Not supported value for `values`!\n", "Only NA, 'NA', 'bush_oxic_figcd', 'bush_anoxic_figcd` and 'bush_ssfig3` are supported!")
  )
  
  result <- c(
    rep(CB, n_CB),
    rep(PB, n_PB),
    rep(SB, n_SB),
    ##
    SO,
    SR,
    O,
    P
  )
  names(result) <- c(
    paste0("CB_", 1:n_CB),
    paste0("PB_", 1:n_CB),
    paste0("SB_", 1:n_CB),
    ##
    "SO",
    "SR",
    "O",
    "P"
  )
  class(result) <- append( "initial_state", class(result))
  return(result)
}

