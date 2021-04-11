#' Function to get the steady states for combinations of a (oxygen diffusivity), inhibition strength, and states.
#'
#' @param expt A data frame of oxygen diffusivities and initial conditions combinations, for example created with expand.grid.
#' @return Experimental result.
#' @export

ss_by_a_h_N <- function(expt)
{
  temp_result <- apply(expt, 1, function(x) get_final_states_a_h_N(x))
  result <- process_expt_result(temp_result)
  result
}


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

#' A function to process the output of the ss_by_a_h_N (find steady states) function
#'
#' @param temp_results The experimental results produced by ss_by_a_N
#' @return Processed experimental results.
#' @export
process_expt_result_a_h <- function(temp_result)
{
  # print(temp_result)
  result <- temp_result %>%
    tibble() %>%
    unnest(cols = 1) %>%
    mutate(initial_N_CB = expt$N_CB,
           a_O = expt$a_O)
  
  mm_result_wide <- result %>%
    group_by(a, inhib_const_mult) %>%
    summarise_all(list(min = min, max = max))
  
  
  a_up <- mm_result_wide %>%
    select(a, inhib_const_mult, ends_with("min")) %>%
    arrange(inhib_const_mult, a)
  names(a_up) <- str_replace_all(names(a_up), "_min", "")
  a_down <- mm_result_wide %>%
    select(a, inhib_const_mult, ends_with("max")) %>%
    arrange(inhib_const_mult, -a)
  names(a_down) <- str_replace_all(names(a_down), "_max", "")
  
  a_up_down <- bind_rows(a_up, a_down) %>%
    mutate(N_CB = ifelse(N_CB < 1, 1, N_CB),
           N_SB = ifelse(N_SB < 1, 1, N_SB),
           N_PB = ifelse(N_PB < 1, 1, N_PB))
  
  a_up_down
  
}
