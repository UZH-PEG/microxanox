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



default_event_definition_strains <- function(times=times, y=state, parms = parameters) {
  with(
    as.list(y),
    {
      ## here adding a bit of noise to the abiotics
      SO <- SO + rnorm(1, 0, noise_sigma*SO)*noise_sigma*SO
      SR <- SR + rnorm(1, 0, noise_sigma*SR)*noise_sigma*SR
      O <- O + rnorm(1, 0, noise_sigma*O)*noise_sigma*O
      P <- P + rnorm(1, 0, noise_sigma*P)*noise_sigma*P
      
      
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