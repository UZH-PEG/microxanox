#' The rate equations, as published in the Bush et al 2017
#' \url{https://doi.org/10.1093/clinchem/39.5.766} paper, but with forcing of
#' oxygen diffusivity `a_0` potential added, and the possibility to simulate
#' multiple strains per functional group
#'
#' @param t The current time in the simulation
#' @param state A vector containing the current (named) values of each state
#'   variable
#' @param parameters An object of class `runsim_parameter` as returned by
#'   `new_runsim_parameter()``
#' @param log10a_forcing_func function to change oxygen diffusivity `a` depending on `t`
#' @param ... not used. Needed to catch additional parameters.
#' 
#' @return a list containing two elements, namely the rate of change of the
#'   strains, and also the current values of oxygen diffusivity `a`.
#' @md
#' 
#' @export
symmetric_bushplus_dynamic_model <- function(
    t, 
    state, 
    parameters, 
    log10a_forcing_func,
    ...
){
  
  ## unpack state variables from the state object
  CB <- state[grep("CB", names(state))]
  names_CB <- names(CB)[order(names(CB))]
  CB <- as.numeric(CB[order(names(CB))])
  PB <- state[grep("PB", names(state))]
  names_PB <- names(PB)[order(names(PB))]
  PB <- as.numeric(PB[order(names(PB))])
  SB <- state[grep("SB", names(state))]
  names_SB <- names(SB)[order(names(SB))]
  SB <- as.numeric(SB[order(names(SB))])
  # print(c(CB, PB, SB))
  
  
  # rates of change of CB and SB
  CB_growth_rate <- growth1(state["P"], parameters$CB$g_max_CB, parameters$CB$k_CB_P) * inhibition(state["SR"], parameters$CB$h_SR_CB) * CB
  SB_growth_rate <- growth1(state["P"], parameters$SB$g_max_SB, parameters$SB$k_SB_P) * inhibition(state["O"], parameters$SB$h_O_SB) * SB
  
  CB_mortality_rate <- parameters$CB$m_CB * CB
  SB_mortality_rate <- parameters$SB$m_SB * SB
  
  CB_rate <- CB_growth_rate - CB_mortality_rate + parameters$CB$i_CB
  SB_rate <- SB_growth_rate - SB_mortality_rate + parameters$SB$i_SB
  
  # PB rates of change
  # PB_growth_rate <- growth2(state["P"], state["SR"], parameters$PB$g_max_PB, parameters$PB$k_PB_P, parameters$PB$k_PB_SR) * inhibition(state["O"], parameters$PB$h_O_PB) * PB
  # PB_mortality_rate <- parameters$PB$m_PB * PB
  # PB_rate <- PB_growth_rate - PB_mortality_rate + parameters$PB$i_PB
  PB_growth_rate <- 0 # no need to calculate in every step
  PB_rate <- 0
  
  # Substrate rates of change
  # SO_rate <- sum(1 / parameters$PB$y_SR_PB * PB_growth_rate) -
  #   sum(1 / parameters$SB$y_SO_SB * SB_growth_rate) +
  #   parameters$c * state["O"] * state["SR"] +
  #   parameters$a_S * (parameters$back_SO -state[["SO"]])
  SO_rate <- 0 # leaving the ODE will lead to drastic decrease,
  ## because only term != 0 is consumption by SB (inexisting in growth1)
  
  
  
  SR_rate <- sum(parameters$SB$y_SO_SB * SB_growth_rate) -
    parameters$c * state["O"] * state["SR"] + # = 0
    parameters$a_S * (parameters$back_SR - state["SR"])
  
  O_rate <- sum(parameters$CB$Pr_CB * CB_growth_rate) -
    parameters$c * state["O"] * state["SR"] + # = 0
    10^log10a_forcing_func(t) * (parameters$back_O - state["O"]) # look at to construct symmetry only based on log10a forc, looking at func only
  
  P_rate <- - sum(1 / parameters$CB$y_P_CB * CB_growth_rate) -
    #sum(1 / parameters$PB$y_P_PB * PB_growth_rate) -
    sum(1 / parameters$SB$y_P_SB * SB_growth_rate) +
    parameters$a_P * (parameters$back_P - state["P"])
  
  # Assemble results
  result <- list(
    c(
      CB_rate,
      PB_rate,
      SB_rate,
      SO_rate = SO_rate,
      SR_rate = SR_rate,
      O_rate = O_rate,
      P_rate = P_rate
    ),
    a = log10a_forcing_func(t)
  )
  
  # Name results
  names(result[[1]]) <- c(
    parameters$CB$strain_name,
    parameters$PB$strain_name,
    parameters$SB$strain_name,
    "SO_rate",
    "SR_rate",
    "O_rate",
    "P_rate"
  )
  
  return(result)
}
