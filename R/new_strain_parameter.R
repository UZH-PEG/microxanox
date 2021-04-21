#' Creates empty parameter
#'
#' @param n number of strains or \code{"bush"}, in which case the default from Bush et al 2017 will be used
#'
#' @return \code{list} with additional class \code{strain_parameter}
#' @export
#'
new_strain_parameter <- function(
  n = 1
){
  parms <- list()

# strain parameter --------------------------------------------------------

  parms$CB <- new_CB_strain_parameter(n = n)
  parms$PB <- new_PB_strain_parameter(n = n)
  parms$SB <- new_SB_strain_parameter(n = n)
  
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

  if (n == "bush"){
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
  
  class(parms) <- append("strain_parameter", class(parms))
  
  return(parms)
}


#' Create empty CB strain parameter
#'
#' @param n number of strains or \code{"bush"}, in which case the default from Bush et al 2017 will be used
#'
#' @return data.frame with additional class \code{CB_strain_parameter}
#' @export
#'
new_CB_strain_parameter <- function(
  n = 1
){
  if (n == "bush") {
    bush <- TRUE
    n <- 1
  } else {
    bush <- FALSE
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
  if (bush) {
    result$g_max_CB = 0.05
    result$k_CB_P = 0.2
    result$h_SR_CB = 300
    result$y_P_CB = 1.67e8
    result$Pr_CB = 6e-9
    result$m_CB = 0.02
    result$i_CB = 0
  }
  class(result) <- append( "CB_strain_parameter", class(result))
  return(result)
}

#' Create empty PB strain parameter
#'
#' @param n number of strains or \code{"bush"}, in which case the default from Bush et al 2017 will be used
#'
#' @return data.frame with additional class \code{PB_strain_parameter}
#' @export
#'
new_PB_strain_parameter <- function(
  n = 1
){
  if (n == "bush") {
    bush <- TRUE
    n <- 1
  } else {
    bush <- FALSE
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
  if (bush) {
    result$g_max_PB = 0.07
    result$k_PB_SR = 10
    result$k_PB_P = 0.5
    result$h_O_PB = 0.5
    result$y_SR_PB = 1.25e7  ## Y_S_PB in the main text
    result$y_P_PB = 1.67e8
    result$m_PB = 0.028
    result$i_PB = 0
  }
  class(result) <- append( "PB_strain_parameter", class(result))
  return(result)
}

#' Create empty SB strain parameter
#'
#' @param n number of strains or \code{"bush"}, in which case the default from Bush et al 2017 will be used
#'
#' @return data.frame with additional class \code{SB_strain_parameter}
#' @export
#'
new_SB_strain_parameter <- function(
  n = 1
){
  if (n == "bush") {
    bush <- TRUE
    n <- 1
  } else {
    bush <- FALSE
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
  if (bush) {
    result$g_max_SB = 0.1
    result$k_SB_SO = 5
    result$k_SB_P = 0.
    result$h_O_SB = 100
    result$y_SO_SB = 3.33e7
    result$y_P_SB = 1.67e8
    result$m_SB = 0.04
    result$i_SB = 0
  }
  class(result) <- append( "SB_strain_parameter", class(result))
  return(result)
}




new_initial_state <- function(
  n = 1
){
  x <- rep(as.numeric(NA), n)
  result <- data.frame(
    CB = x,
    PB = x,
    SB = x,
    SO = x,
    SR = x,
    O  = x,
    P  = x
  )
  return(result)
}

