#' Creates empty parameter
#' 
#' The default is to create the parameter set used in Bush et al. (2017)
#' @param n_CB number of CB strains 
#' @param values_CB to be used for CB strains parameter or \code{"bush"}, in which case the default from Bush et al (2017) will be used
#' @param n_PB number of PB strains 
#' @param values_PB to be used for PB strains parameter or \code{"bush"}, in which case the default from Bush et al (2017) will be used
#' @param n_SB number of SB strains 
#' @param values_SB to be used for SB strains parameter or \code{"bush"}, in which case the default from Bush et al (2017) will be used
#' @param values_other values to be used for other parameter or \code{"bush"}, in which case the default from Bush et al (2017) will be used
#' @param values_initial_state values to be used for initial values or \code{"bush"}, in which case the default from Bush et al (2017) will be used
#'
#' @return \code{list} with additional class \code{strain_parameter}
#' @export
#'
new_strain_parameter <- function(
  n_CB = 1,
  values_CB = "bush",
  n_PB = 1,
  values_PB = "bush",
  n_SB = 1,
  values_SB = "bush",
  values_other = "bush",
  values_initial_state = "bush"
){
  if (is.na(values_other)) {
    values_other <- "NA"
  }
  
  if (!(values_other %in% c("NA", "bush"))) {
    stop("Not supported value for `values_other`!\n", "Only NA, 'NA' and 'bush' supported!")
  }
  
  if (is.na(values_initial_state)) {
    values_initial_state <- "NA"
  }
  
  if (!(values_initial_state %in% c("NA", "bush"))) {
    stop("Not supported value for `values_initial`!\n", "Only NA, 'NA' and 'bush' supported!")
  }
  
  parms <- list()

# strain parameter --------------------------------------------------------

  parms$CB <- new_CB_strain_parameter(n = n_CB, values = values_CB)
  parms$PB <- new_PB_strain_parameter(n = n_PB, values = values_PB)
  parms$SB <- new_SB_strain_parameter(n = n_SB, values = values_SB)
  
  # other parameter ---------------------------------------------------------

  ## substrate diffusivity
  parms$a_S = as.numeric(NA)
  parms$a_O = as.numeric(NA)
  parms$a_P = as.numeric(NA)
  
  ## background substrate concentration
  parms$back_SR = as.numeric(NA)
  parms$back_SO = as.numeric(NA)
  parms$back_O = as.numeric(NA)
  parms$back_P = as.numeric(NA)
  
  ## oxidisation rate of reduced sulphur
  parms$c = as.numeric(NA)

  if ( values_other == "bush" ) {
    ## substrate diffusivity
    parms$a_S = 0.001
    parms$a_O = 8e-4
    parms$a_P = 0.01
    ## background substrate concentration
    parms$back_SR = 300
    parms$back_SO = 300
    parms$back_O = 300
    parms$back_P = 9.5
    ## oxidisation rate of reduced sulphur
    parms$c = 4e-5
  }  
  
  parms$initial_state <- new_initial_state_anoxic(n_CB = n_CB, n_PB = n_PB, n_SB = n_SB, values = values_initial_state)
  
  class(parms) <- append("strain_parameter", class(parms))
  
  return(parms)
}


#' Create CB strain parameter
#'
#' @param n number of strains 
#' @param values values to be used or \code{"bush"}, in which case the default from Bush et al (2017) will be used
#'
#' @return data.frame with additional class \code{CB_strain_parameter}
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
    stop("Not supported value for `valiues`!\n", "Only NA, 'NA' and 'bush' supported!")
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
#' @param values values to be used or \code{"bush"}, in which case the default from Bush et al (2017) will be used
#' 
#' @return data.frame with additional class \code{PB_strain_parameter}
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
    stop("Not supported value for `valiues`!\n", "Only NA, 'NA' and 'bush' supported!")
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
#' @return data.frame with additional class \code{SB_strain_parameter}
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
    stop("Not supported value for `valiues`!\n", "Only NA, 'NA' and 'bush' supported!")
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



#' Create initial condition
#'
#' @param n_CB number of CB strains 
#' @param N_PB number of PB strains 
#' @param N_SB number of SB strains 
#' @param values values to be used or \code{"bush"}, in which case the default from Bush et al (2017) will be used
#'
#' @return
#' @export
#'
new_initial_state_anoxic <- function(
  n_CB = 1,
  n_PB = 1,
  n_SB = 1,
  values = "bush"
){
  if (is.na(values)) {
    values <- "NA"
  }
  
  if (!(values %in% c("NA", "bush"))) {
    stop("Not supported value for `valiues`!\n", "Only NA, 'NA' and 'bush' supported!")
  }
  
  if (values == "bush") {
    CB <-  5e1
    PB <-  1e7
    SB <-  1e7
    SO <-  300
    SR <-  300
    O  <-  1e1
    P  <-  1e1
  } else {
    CB <-  as.numeric(NA)
    PB <-  as.numeric(NA)
    SB <-  as.numeric(NA)
    SO <-  as.numeric(NA)
    SR <-  as.numeric(NA)
    O <-  as.numeric(NA)
    P <-  as.numeric(NA)
  }
  
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

