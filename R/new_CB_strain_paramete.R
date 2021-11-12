#' Create CB strain parameter
#'
#' @param n number of strains
#' @param values Allowed values are:
#' - `"bush"`: default values from Bush et al (2017) will be used
#' - `"NA"`: all parameter will be set to `NA`. Usable for e.g. setting own parameter
#'  
#' @return object of class \code{CB_strain_parameter}. The object contains a
#'   `data.frame` with 8 columns and `n` rows. The columns are:
#' 
#' columns: 
#' - strain_name: the name of the strain
#' - g_max_CB:
#' - k_CB_P:
#' - h_SR_CB:
#' - y_P_CB:
#' - Pr_CB:
#' - m_CB:
#' - i_CB:
#' 
#' @md
#' @export
#'
new_CB_strain_parameter <- function(
  n = 1,
  values = "bush"
){
  if (is.na(values)) {
    values <- "NA"
  }
  
  if (!(values %in% c("NA", "bush"))) {
    stop("Not supported value for `values`!\n", "Only NA, 'NA' and 'bush' supported!")
  }
  
  x <- rep(as.numeric(NA), n)
  nm <- paste0("CB_", 1:n)
  result <- data.frame(
    strain_name = nm,
    g_max_CB = x,
    k_CB_P = x,
    h_SR_CB = x,
    y_P_CB = x,
    Pr_CB = x,
    m_CB = x,
    i_CB = x
  )
  if (values == "bush") {
    result$g_max_CB = rep(0.05, n)
    result$k_CB_P = rep(0.2, n)
    result$h_SR_CB = rep(300, n)
    result$y_P_CB = rep(1.67e8, n)
    result$Pr_CB = rep(6e-9, n)
    result$m_CB = rep(0.02, n)
    result$i_CB = rep(0, n)
  }
  class(result) <- append( "CB_strain_parameter", class(result))
  return(result)
}

#' Create PB strain parameter
#'
#' @param n number of strains
#' @param values values to be used or \code{"bush"}, in which case the default
#'   from Bush et al (2017) will be used
#'
#' @return object of class \code{PB_strain_parameter}. The object contains a
#'   `data.frame` with 8 columns and `n` rows. The columns are:
#' 
#' columns: 
#' - strain_name: the name of the strain
#' - g_max_PB:
#' - k_PB_SR:
#' - k_PB_P:
#' - h_O_PB:
#' - y_SR_PB:
#' - y_P_PB:
#' - m_PB:
#' - i_CB:
#' 
#' @md 
#' @export
#'
new_PB_strain_parameter <- function(
  n = 1,
  values = "bush"
){
  if (is.na(values)) {
    values <- "NA"
  }
  
  if (!(values %in% c("NA", "bush"))) {
    stop("Not supported value for `values`!\n", "Only NA, 'NA' and 'bush' supported!")
  }
  
  x <- rep(as.numeric(NA), n)
  nm <- paste0("PB_", 1:n)
  result <- data.frame(
    strain_name = nm,
    g_max_PB = x,
    k_PB_SR = x,
    k_PB_P = x,
    h_O_PB = x,
    y_SR_PB = x,
    y_P_PB = x,
    m_PB = x,
    i_PB = x
  )
  if (values == "bush") {
    result$g_max_PB = rep(0.07, n)
    result$k_PB_SR = rep(10, n)
    result$k_PB_P = rep(0.5, n)
    result$h_O_PB = rep(100, n)
    result$y_SR_PB = rep(1.25e7, n)  ## Y_S_PB in the main text
    result$y_P_PB = rep(1.67e8, n)
    result$m_PB = rep(0.028, n)
    result$i_PB = rep(0, n)
  }
  class(result) <- append( "PB_strain_parameter", class(result))
  return(result)
}

#' Create SB strain parameter
#'
#' @param n number of strains 
#' @param values values to be used or \code{"bush"}, in which case the default from Bush et al (2017) will be used
#'
#' @return object of class \code{PB_strain_parameter}. The object contains a
#'   `data.frame` with 8 columns and `n` rows. The columns are:
#' 
#' columns: 
#' - strain_name: the name of the strain
#' - g_max_SB:
#' - k_PB_SO:
#' - k_SB_P:
#' - h_O_SB:
#' - y_SO_SB:
#' - y_PB_SB:
#' - m_SB:
#' - i_SB:
#' 
#' @md
#' 
#' @export
#'
new_SB_strain_parameter <- function(
  n = 1,
  values = "bush"
){
  if (is.na(values)) {
    values <- "NA"
  }
  
  if (!(values %in% c("NA", "bush"))) {
    stop("Not supported value for `values`!\n", "Only NA, 'NA' and 'bush' supported!")
  }
  
  x <- rep(as.numeric(NA), n)
  nm <- paste0("SB_", 1:n)
  result <- data.frame(
    strain_name = nm,
    g_max_SB = x,
    k_SB_SO = x,
    k_SB_P = x,
    h_O_SB = x,
    y_SO_SB = x,  
    y_P_SB = x,
    m_SB = x,
    i_SB = x
  )
  if (values == "bush") {
    result$g_max_SB = rep(0.1, n)
    result$k_SB_SO = rep(5, n)
    result$k_SB_P = rep(0.5, n)
    result$h_O_SB = rep(100, n)
    result$y_SO_SB = rep(3.33e7, n)
    result$y_P_SB = rep(1.67e8, n)
    result$m_SB = rep(0.04, n)
    result$i_SB = rep(0, n)
  }
  class(result) <- append( "SB_strain_parameter", class(result))
  return(result)
}



#' Create initial state of the system
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

