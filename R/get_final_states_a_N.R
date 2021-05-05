#' Get the steady state solutions for a set of oxygen diffusivity and initial states.
#' Probably best to not use this directly, but rather via the function \code{"ss_by_a_N}
#' 
#'
#' @param x A vector of oxygen diffusivity and initial conditions.
#' @return A vector of steady states
#' @export
get_final_states_a_N <- function(x, ssfind_parameters) { 
  
  #give N_CB, N_SB, N_PB and a_O values and put these into state and parameters
  
  ssfind_parameters$a_O <- x["a_O"]
  print(ssfind_parameters$a_O)
  
  CBs <- unlist(rep(x["N_CB"] / length(grep("CB", names(ssfind_parameters$initial_state))),
      length(grep("CB", names(ssfind_parameters$initial_state)))))
  names(CBs) <- NULL
  ssfind_parameters$initial_state[grep("CB", names(ssfind_parameters$initial_state))] <- CBs
    
  PBs <- unlist(rep(x["N_PB"] / length(grep("PB", names(ssfind_parameters$initial_state))),
                    length(grep("PB", names(ssfind_parameters$initial_state)))))
  names(PBs) <- NULL
  ssfind_parameters$initial_state[grep("PB", names(ssfind_parameters$initial_state))] <- PBs
  
  SBs <- unlist(rep(x["N_SB"] / length(grep("SB", names(ssfind_parameters$initial_state))),
                    length(grep("SB", names(ssfind_parameters$initial_state)))))
  names(SBs) <- NULL
  ssfind_parameters$initial_state[grep("SB", names(ssfind_parameters$initial_state))] <- SBs
  
  #ssfind_init_state["N_CB"] <-  x["N_CB"]   
  #ssfind_init_state["N_PB"] <-  x["N_PB"]   
  #ssfind_init_state["N_SB"] <-  x["N_SB"]   
  #ssfind_parameters["a_O"] <- x["a_O"]      
  
  ## update forcing series
  ss_log10a_series <- c(log10(ssfind_parameters[["a_O"]]),
                        log10(ssfind_parameters[["a_O"]]))
  
  #print(ssfind_parameters$initial_state)
  
  simres <- run_simulation(dynamic_model = bushplus_dynamic_model,
                           initial_state = ssfind_parameters$initial_state,
                           parameter_values = ssfind_parameters,
                           sim_duration = ssfind_simulation_duration,
                           sim_sample_interval = ssfind_simulation_sampling_interval,
                           event_interval = ssfind_event_interval,
                           log10a_series = ss_log10a_series,
                           minimum_abundances = ssfind_minimum_abundances)
  #print(simres$result[2,-1])
  simres$result[2,-1] 
  
}