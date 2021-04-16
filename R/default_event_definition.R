#' A function that contains the events that should alter the state variables
#'
#' @param times The time point in the simulation
#' @param y Current state variable values
#' @param parms Model parameters
#' @return A vector of the state variables
#' @export
default_event_definition <- function(times=times, y=state, parms = parameters) {
  with(
    as.list(y),
    {
    ## here adding a bit of noise to the abiotics
    SO <- SO + rnorm(1, 0, noise_sigma*SO)*noise_sigma*SO
    SR <- SR + rnorm(1, 0, noise_sigma*SR)*noise_sigma*SR
    O <- O + rnorm(1, 0, noise_sigma*O)*noise_sigma*O
    P <- P + rnorm(1, 0, noise_sigma*P)*noise_sigma*P
    
    ## here adding minimum to N_CB, N_PB, and N_SB
    if(N_CB < minimum_abundances["CB"])
      N_CB <- minimum_abundances["CB"]
    if(N_PB<minimum_abundances["PB"])
      N_PB <- minimum_abundances["PB"]
    if(N_SB<minimum_abundances["SB"])
      N_SB <- minimum_abundances["SB"]
    
    return(c(N_CB, N_PB, N_SB, SO, SR, O, P))
    }
  )
}