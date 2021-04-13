#' Get the steady state solutions for a set of oxygen diffusivity and initial states.
#'
#' @param x A vector of oxygen diffusivity and initial conditions.
#' @return A vector of steady states
#' @export
get_final_states_a_N <- function(x) { 
  
  #give N_CB, N_SB, N_PB and a_O values and put these into state and parameters
  ssfind_init_state["N_CB"] <-  x["N_CB"]   
  ssfind_init_state["N_PB"] <-  x["N_PB"]   
  ssfind_init_state["N_SB"] <-  x["N_SB"]   
  ssfind_parameters["a_O"] <- x["a_O"]      
  
  ## update forcing series
  ss_log10a_series <- c(log10(ssfind_parameters["a_O"]),
                        log10(ssfind_parameters["a_O"]))
  
  simres <- run_simulation(dynamic_model = bushplus_dynamic_model,
    initial_state = ssfind_init_state,
                           parameter_values = ssfind_parameters,
                           sim_duration = ssfind_simulation_duration,
                           sim_sample_interval = ssfind_simulation_sampling_interval,
                           event_interval = ssfind_event_interval,
                           log10a_series = ss_log10a_series,
                           minimum_abundances = ssfind_minimum_abundances)
  #print(simres$result[2,-1])
  simres$result[2,-1] 
  
}