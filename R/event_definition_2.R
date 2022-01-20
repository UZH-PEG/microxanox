#' Event definition for the simulation.
#'
#' This function contains events that can alter the state variables.
#' In this event definition, the abundances of all functional groups have 1 added to their density at each event.
#' @param times the time points in the simulation when events happen
#' @param state current state variable values
#' @param parms object of class `strain_parameter`
#' @param log10a_forcing_func function to change oxygen diffusivity `a`
#'   depending on `t`
#' @param noise_sigma value of variation added to `SO`, `SR`, `O`, and `P` using
#'   the formula `rnorm(1, 0, noise_sigma * X) * noise_sigma * X`
#' @param minimum_abundances minimum abundances for CB, PB and SB. if the values
#'   are lower, they will be set to these `minimum_abundances`
#'
#' @return the state vector, i.e. a vector containing the state variables.
#'
#' @md
#' @export
event_definition_2 <- function(
  times,
  state,
  parms,
  log10a_forcing_func,
  noise_sigma,
  minimum_abundances
){
  with(
    as.list(state),
    {
      ## here adding a bit of noise to the abiotics
      # if(noise_sigma!=0) {
      SO <- SO + rnorm(1, 0, noise_sigma*SO)*noise_sigma*SO
      SR <- SR + rnorm(1, 0, noise_sigma*SR)*noise_sigma*SR
      O <-  O  + rnorm(1, 0, noise_sigma*O)*noise_sigma *O
      P <-  P  + rnorm(1, 0, noise_sigma*P)*noise_sigma *P
      
      ## and below setting the abundance to the minimum, in case it happens to be below it
      CB <- state[grep("CB", names(state))]
      names_CB <- names(CB)[order(names(CB))]
      CB <- as.numeric(CB[order(names(CB))])
      CB <- CB + 1
      
      PB <- state[grep("PB", names(state))]
      names_PB <- names(PB)[order(names(PB))]
      PB <- as.numeric(PB[order(names(PB))])
      PB <- PB + 1
      
      SB <- state[grep("SB", names(state))]
      names_SB <- names(SB)[order(names(SB))]
      SB <- as.numeric(SB[order(names(SB))])
      SB <- SB + 1
      
      # Assemble results
      result <- c(
        CB,
        PB,
        SB,
        SO = SO,
        SR = SR,
        O = O,
        P = P
      )
      
      # Name results
      names(result) <- c(
        names_CB,
        names_PB,
        names_SB,
        "SO",
        "SR",
        "O",
        "P"
      )
      
      return(result)
    }
  )
}