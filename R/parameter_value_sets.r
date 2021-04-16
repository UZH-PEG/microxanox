#' Function that returns default parameter value set
#'
#' @return TODO
#' @export
#'
load_default_parameter_values <- function() {
  default_parameter_values <- c(
    
    ## maximum specific growth rates
    g_max_CB = 0.05,
    g_max_PB = 0.07,
    g_max_SB = 0.1,
    
    ## half-saturation constants
    k_PB_SR = 10,
    k_SB_SO = 5,
    k_CB_P = 0.2,
    k_PB_P = 0.5,
    k_SB_P = 0.5,
    
    ## half-inhibition constant
    h_SR_CB = 300,
    h_O_PB = 100,
    h_O_SB = 100,
    
    ## yield (cells per micromole)
    Y_SO_SB = 3.33e7,  
    Y_SR_PB = 1.25e7, ## Y_S_PB in the main text
    y_P_CB = 1.67e8,
    y_P_PB = 1.67e8,
    y_P_SB = 1.67e8,
    
    ## oxygen production per microbial cell
    P_CB = 6e-9,
    
    ## mortality rate
    m_CB = 0.02,
    m_PB = 0.028,
    m_SB = 0.04,
    
    ## substrate diffusivity
    a_S = 0.001,
    a_O = 8e-4,
    a_P = 0.01,
    
    ## background substrate concentration
    back_SR = 300,
    back_SO = 300,
    back_O = 300,
    back_P = 9.5,
    
    ## immigration rates (cells per time)
    i_CB <- 0,
    i_PB <- 0,
    i_SB <- 0,
    
    ## oxidisation rate of reduced sulphur
    c = 4e-5
  )
  
  return(default_parameter_values)
  
}