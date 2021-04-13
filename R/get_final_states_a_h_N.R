#' Function to get the steady states for combinations of a (oxygen diffusivity), inhibition strength and initial states.
#'
#' @param expt A data frame of oxygen diffusivities and initial conditions combinations, for example created with expand.grid.
#' @return Experimental result.
#' @export

get_final_states_a_h_N <- function(x) { 
  
  
  #give N_CB, N_SB, N_PB and a_O values and put these into state and parameters
  ssfind_init_state["N_CB"] <-  x["N_CB"]   
  ssfind_init_state["N_PB"] <-  x["N_PB"]   
  ssfind_init_state["N_SB"] <-  x["N_SB"]   
  
  ssfind_parameters_use <- ssfind_parameters
  ssfind_parameters_use["a_O"] <- x["a_O"]      
  ssfind_parameters_use["h_SR_CB"] <- ssfind_parameters_use["h_SR_CB"] * x["inhib_const_mult"]
  ssfind_parameters_use["h_O_PB"] <- ssfind_parameters_use["h_O_PB"] * x["inhib_const_mult"]
  ssfind_parameters_use["h_O_SB"] <- ssfind_parameters_use["h_O_SB"] * x["inhib_const_mult"]
  
  ## update forcing series
  ss_log10a_series <- c(log10(ssfind_parameters_use["a_O"]),
                        log10(ssfind_parameters_use["a_O"]))
  
  simres <- run_simulation(initial_state = ssfind_init_state,
                           parameter_values = ssfind_parameters_use,
                           sim_duration = ssfind_simulation_duration,
                           sim_sample_interval = ssfind_simulation_sampling_interval,
                           event_interval = ssfind_event_interval,
                           log10a_series = ss_log10a_series,
                           minimum_abundances = ssfind_minimum_abundances)
  #print(simres$result[2,-1])
  full_result <- bind_cols(simres$result[2,-1],
                           inhib_const_mult = x["inhib_const_mult"])
  
}