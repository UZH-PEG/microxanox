#' Function that returns default initial states.
#' This particular set favours the anoxic state.
#' 
#'
#' @return A named vector of parameter values 
#' @export
#'
return_default_initial_state <- function() {
    
    default_initial_state <- c(N_CB = 5e1,
                               N_PB = 1e7,
                               N_SB = 1e7,
                               SO = 300,
                               SR = 300,
                               O = 1e1,
                               P = 1e1)
    
  return(default_initial_state)
  
}