#' The rate equations, as published in the paper, but with forcing of oxygen diffusivity (a_0) potential added
#'
#' @param t The current time in the simulation
#' @param state A vector containing the current (named) values of each state variable
#' @param parameters A vector containing the current (named) values of each parameter
#' @return Growth rate
#' @export
bushplus_dynamic_model <- function(t, state, parameters) {

  with(as.list(c(state, parameters)),
       {

         # rates of change
         N_CB_growth_rate <- growth1(P, g_max_CB, k_CB_P) * inhibition(SR, h_SR_CB) * N_CB
         N_CB_mortality_rate <- m_CB * N_CB
         N_CB_rate <- N_CB_growth_rate - N_CB_mortality_rate + i_CB

         N_PB_growth_rate <- growth2(P, SR, g_max_PB, k_PB_P, k_PB_SR) * inhibition(O, h_O_PB) * N_PB
         N_PB_mortality_rate <- m_PB * N_PB
         N_PB_rate <- N_PB_growth_rate - N_PB_mortality_rate + i_PB

         N_SB_growth_rate <- growth2(P, SO, g_max_SB, k_SB_P, k_SB_SO) * inhibition(O, h_O_SB) * N_SB
         N_SB_mortality_rate <- m_SB * N_SB
         N_SB_rate <- N_SB_growth_rate - N_SB_mortality_rate + i_SB

         SO_rate <- 1 / Y_SR_PB * N_PB_growth_rate -
           1 / Y_SO_SB * N_SB_growth_rate +
           c * O * SR +
           a_S * (back_SO - SO)

         SR_rate <- - 1 / Y_SR_PB * N_PB_growth_rate +
           1 / Y_SO_SB * N_SB_growth_rate -
           c * O * SR +
           a_S * (back_SR - SR)

         O_rate <- Pr_CB * N_CB_growth_rate -
           c * O * SR +
           10^log10a_forcing_func(t) * (back_O - O)

         P_rate <- - 1 / y_P_CB * N_CB_growth_rate -
           1 / y_P_PB * N_PB_growth_rate -
           1 / y_P_SB * N_PB_growth_rate +
           a_P * (back_P - P)


         # return the rate of change
         list(c(N_CB_rate,
                N_PB_rate,
                N_SB_rate,
                SO_rate,
                SR_rate,
                O_rate,
                P_rate),
              a=log10a_forcing_func(t))

       })

}


