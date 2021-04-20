#' Creates empty parameter
#'
#' @param CB_strain_parameter TODO
#' @param PB_strain_parameter TODO 
#' @param SB_strain_parameter TODO
#' @param a_S TODO
#' @param a_O TODO 
#' @param a_P TODO 
#' @param back_SR TODO 
#' @param back_SO TODO 
#' @param back_O TODO 
#' @param back_P TODO 
#' @param c TODO 
#'
#' @return \code{list} with additional class \code{strain_parameter}
#' @export
#'
new_strain_parameter <- function(
  ## strain parameter
  CB_strain_parameter = new_CB_strain_parameter(),
  PB_strain_parameter = new_PB_strain_parameter(),
  SB_strain_parameter = new_SB_strain_parameter(),
  ## substrate diffusivity
  a_S = 0.001,
  a_O = 8e-4,
  a_P = 0.01,
  ## background substrate concentration
  back_SR = 300,
  back_SO = 300,
  back_O = 300,
  back_P = 9.5,
  ## oxidisation rate of reduced sulphur
  c = 4e-5
){
  parms <- list()

# strain parameter --------------------------------------------------------

  parms$CB <- CB_strain_parameter
  parms$PB <- PB_strain_parameter
  parms$SB <- SB_strain_parameter
  
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
  
  class(parms) <- append("strain_parameter", class(parms))
  
  return(parms)
}


#' Create empty CB strain parameter
#'
#' @return data.frame with additional class \code{CB_strain_parameter}
#' @export
#'
new_CB_strain_parameter <- function(){
  result <- data.frame(
    strain_name = c("CB_1"),
    g_max_CB = as.numeric(NA),
    k_CB_P = as.numeric(NA),
    h_SR_CB = as.numeric(NA),
    y_P_CB = as.numeric(NA),
    Pr_CB = as.numeric(NA),
    m_CB = as.numeric(NA),
    i_CB = as.numeric(NA)
  )
  class(result) <- append( "CB_strain_parameter", class(result))
  return(result)
}

#' Create empty PB strain parameter
#'
#' @return data.frame with additional class \code{PB_strain_parameter}
#' @export
#'
new_PB_strain_parameter <- function(){
  result <- data.frame(
    strain_name = c("PB_1"),
    g_max_PB = as.numeric(NA),
    k_PB_SR = as.numeric(NA),
    k_PB_P = as.numeric(NA),
    h_O_PB = as.numeric(NA),
    y_SR_PB = as.numeric(NA),
    y_P_PB = as.numeric(NA),
    m_PB = as.numeric(NA),
    i_PB = as.numeric(NA)
  )
  class(result) <- append( "PB_strain_parameter", class(result))
  return(result)
}

#' Create empty SB strain parameter
#'
#' @return data.frame with additional class \code{SB_strain_parameter}
#' @export
#'
new_SB_strain_parameter <- function(){
  result <- data.frame(
    strain_name = c("SB_1"),
    g_max_SB = as.numeric(NA),
    k_SB_SO = as.numeric(NA),
    k_SB_P = as.numeric(NA),
    h_O_SB = as.numeric(NA),
    y_SO_SB = as.numeric(NA),  
    y_P_SB = as.numeric(NA),
    m_SB = as.numeric(NA),
    i_SB = as.numeric(NA)
  )
  class(result) <- append( "SB_strain_parameter", class(result))
  return(result)
}
