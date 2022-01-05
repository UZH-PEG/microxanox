#' A function that contains events that should alter the state variables.
#' (It is named definition "1", in case other definitions are created.)
#'
#' @param times the time point in the simulation
#' @param y current state variable values
#' @param parms object of class `strain_parameter`
#' @param log10a_forcing_func TODO
#' @param noise_sigma TODO
#' @param minimum_abundances TODO
#' 
#' @return a vector of the new state variables
#' @md
#' @export
event_definition_1 <- function(
  times = times, 
  y = state, 
  parms = parameters, 
  log10a_forcing_func, 
  noise_sigma, 
  minimum_abundances
) {
  with(
    as.list(y),
    {
      ## here adding a bit of noise to the abiotics
      SO <- SO + rnorm(1, 0, noise_sigma*SO)*noise_sigma*SO
      SR <- SR + rnorm(1, 0, noise_sigma*SR)*noise_sigma*SR
      O <- O + rnorm(1, 0, noise_sigma*O)*noise_sigma*O
      P <- P + rnorm(1, 0, noise_sigma*P)*noise_sigma*P
      
      ## and below setting the abundance to the minimum, in case it happens to be below it
      CB <- y[grep("CB", names(y))]
      names_CB <- names(CB)[order(names(CB))]
      CB <- as.numeric(CB[order(names(CB))])
      CB[CB < minimum_abundances["CB"]] <- minimum_abundances["CB"]
      
      PB <- y[grep("PB", names(y))]
      names_PB <- names(PB)[order(names(PB))]
      PB <- as.numeric(PB[order(names(PB))])
      PB[PB < minimum_abundances["PB"]] <- minimum_abundances["PB"]
      
      SB <- y[grep("SB", names(y))]
      names_SB <- names(SB)[order(names(SB))]
      SB <- as.numeric(SB[order(names(SB))])
      SB[SB < minimum_abundances["SB"]] <- minimum_abundances["SB"]
      
      result <- c(CB,
                  PB,
                  SB,
                  SO = SO,
                  SR = SR,
                  O = O,
                  P = P)
      
      names(result) <- c(names_CB,
                         names_PB,
                         names_SB,
                         "SO",
                         "SR",
                         "O",
                         "P")
      result
    }
  )
}