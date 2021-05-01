

#' The rate equations, as published in the paper, but with forcing of oxygen diffusivity \code{"a_0"} potential added,
#' and the possibility to simulate multiple strains per functional group
#'
#' @param t The current time in the simulation
#' @param state A vector containing the current (named) values of each state variable
#' @param parameters A vector containing the current (named) values of each parameter
#' @return Growth rate
#' @export
bushplus_dynamic_model <- function(t, state, parameters) {

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
         
         ### CB
         # g_max_CB <- parameters[grep("g_max_CB", names(parameters))]
         # g_max_CB <- as.numeric(g_max_CB[order(names(g_max_CB))])
         # k_CB_P <- parameters[grep("k_CB_P", names(parameters))]
         # k_CB_P <- as.numeric(k_CB_P[order(names(k_CB_P))])
         # h_SR_CB <- parameters[grep("h_SR_CB", names(parameters))]
         # h_SR_CB <- as.numeric(h_SR_CB[order(names(h_SR_CB))])
         # y_P_CB <- parameters[grep("y_P_CB", names(parameters))]
         # y_P_CB <- as.numeric(y_P_CB[order(names(y_P_CB))])
         # Pr_CB <- parameters[grep("Pr_CB", names(parameters))]
         # Pr_CB <- as.numeric(Pr_CB[order(names(Pr_CB))])
         # m_CB <- parameters[grep("m_CB", names(parameters))]
         # m_CB <- as.numeric(m_CB[order(names(m_CB))])
         # i_CB <- parameters[grep("i_CB", names(parameters))]
         # i_CB <- as.numeric(i_CB[order(names(i_CB))])
         
         ### PB
         # g_max_PB <- parameters[grep("g_max_PB", names(parameters))]
         # g_max_PB <- as.numeric(g_max_PB[order(names(g_max_PB))])
         # k_PB_SR <- parameters[grep("k_PB_SR", names(parameters))]
         # k_PB_SR <- as.numeric(k_PB_SR[order(names(k_PB_SR))])
         # k_PB_P <- parameters[grep("k_PB_P", names(parameters))]
         # k_PB_P <- as.numeric(k_PB_P[order(names(k_PB_P))])
         # h_O_PB <- parameters[grep("h_O_PB", names(parameters))]
         # h_O_PB <- as.numeric(h_O_PB[order(names(h_O_PB))])
         # y_SR_PB <- parameters[grep("y_SR_PB", names(parameters))]
         # y_SR_PB <- as.numeric(y_SR_PB[order(names(y_SR_PB))])
         # y_P_PB <- parameters[grep("y_P_PB", names(parameters))]
         # y_P_PB <- as.numeric(y_P_PB[order(names(y_P_PB))])
         # m_PB <- parameters[grep("m_PB", names(parameters))]
         # m_PB <- as.numeric(m_PB[order(names(m_PB))])
         # i_PB <- parameters[grep("i_PB", names(parameters))]
         # i_PB <- as.numeric(i_PB[order(names(i_PB))])
         
         ### SB
         # g_max_SB <- parameters[grep("g_max_SB", names(parameters))]
         # g_max_SB <- as.numeric(g_max_SB[order(names(g_max_SB))])
         # k_SB_SO <- parameters[grep("k_SB_SO", names(parameters))]
         # k_SB_SO <- as.numeric(k_SB_SO[order(names(k_SB_SO))])
         # k_SB_P <- parameters[grep("k_SB_P", names(parameters))]
         # k_SB_P <- as.numeric(k_SB_P[order(names(k_SB_P))])
         # h_O_SB <- parameters[grep("h_O_SB", names(parameters))]
         # h_O_SB <- as.numeric(h_O_SB[order(names(h_O_SB))])
         # y_SO_SB <- parameters[grep("y_SO_SB", names(parameters))]
         # y_SO_SB <- as.numeric(y_SO_SB[order(names(y_SO_SB))])
         # y_P_SB <- parameters[grep("y_P_SB", names(parameters))]
         # y_P_SB <- as.numeric(y_P_SB[order(names(y_P_SB))])
         # m_SB <- parameters[grep("m_SB", names(parameters))]
         # m_SB <- as.numeric(m_SB[order(names(m_SB))])
         # i_SB <- parameters[grep("i_SB", names(parameters))]
         # i_SB <- as.numeric(i_SB[order(names(i_SB))])
         
         # rates of change
         CB_growth_rate <- growth1(state["P"], parameters$CB$g_max_CB, parameters$CB$k_CB_P) * inhibition(state["SR"], parameters$CB$h_SR_CB) * CB
         CB_mortality_rate <- parameters$CB$m_CB * CB
         CB_rate <- CB_growth_rate - CB_mortality_rate + parameters$CB$i_CB
         
         PB_growth_rate <- growth2(state["P"], state["SR"], parameters$PB$g_max_PB, parameters$PB$k_PB_P, parameters$PB$k_PB_SR) * inhibition(state["O"], parameters$PB$h_O_PB) * PB
         PB_mortality_rate <- parameters$PB$m_PB * PB
         PB_rate <- PB_growth_rate - PB_mortality_rate + parameters$PB$i_PB
         
         SB_growth_rate <- growth2(state["P"], state["SO"], parameters$SB$g_max_SB, parameters$SB$k_SB_P, parameters$SB$k_SB_SO) * inhibition(state["O"], parameters$SB$h_O_SB) * SB
         SB_mortality_rate <- parameters$SB$m_SB * SB
         SB_rate <- SB_growth_rate - SB_mortality_rate + parameters$SB$i_SB
         
         SO_rate <- sum(1 / parameters$PB$y_SR_PB * PB_growth_rate) -
           sum(1 / parameters$SB$y_SO_SB * SB_growth_rate) +
           parameters$c * state["O"] * state["SR"] +
           parameters$a_S * (parameters$back_SO -state[["SO"]])
         
         SR_rate <- - sum(1 / parameters$PB$y_SR_PB * PB_growth_rate) +
           sum(1 / parameters$SB$y_SO_SB * SB_growth_rate) -
           parameters$c * state["O"] * state["SR"] +
           parameters$a_S * (parameters$back_SR - state["SR"])
         
         O_rate <- sum(parameters$CB$Pr_CB * CB_growth_rate) -
           parameters$c * state["O"] * state["SR"] +
           10^log10a_forcing_func(t) * (parameters$back_O - state["O"])
         
         P_rate <- - sum(1 / parameters$CB$y_P_CB * CB_growth_rate) -
           sum(1 / parameters$PB$y_P_PB * PB_growth_rate) -
           sum(1 / parameters$SB$y_P_SB * PB_growth_rate) +
           parameters$a_P * (parameters$back_P - state["P"])
         
         # print(CB_growth_rate)
         # print(CB_mortality_rate)
         # print(parameters$CB$m_CB)
         # print(CB)
         # print(CB_rate)
         
         # return the rate of change
         result <- list(c(CB_rate,
                          PB_rate,
                          SB_rate,
                          SO_rate = SO_rate,
                          SR_rate = SR_rate,
                          O_rate = O_rate,
                          P_rate = P_rate),
                        a=log10a_forcing_func(t))
         names(result[[1]]) <- c(parameters$CB$strain_name,
                                 parameters$PB$strain_name,
                                 parameters$SB$strain_name,
                                 "SO_rate",
                                 "SR_rate",
                                 "O_rate",
                                 "P_rate")
         result

}

