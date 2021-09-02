new_runsim_parameter <- function(
  ..., help = FALSE
){
  if (help) {
    p <- list(
      dynamic_model = NULL, # default_dynamic_model,
      event_definition = NULL, # default_event_definition,
      parameter_values = NULL, # default_parameter_values,
      event_interval = NULL, # default_event_interval,
      noise_sigma = NULL, # default_noise_sigma,
      minimum_abundances = NULL, # default_minimum_abundances,
      sim_duration = NULL, # default_sim_duration,
      sim_sample_interval = NULL, # default_sim_sample_interval,
      log10a_series = NULL, # default_log10a_series,
      initial_state = NULL, # default_initial_state,
      solver_method = NULL # "radau",
    )
  } else {
    p <- list(
      dynamic_model = NULL, # default_dynamic_model,
      event_definition = NULL, # default_event_definition,
      parameter_values = NULL, # default_parameter_values,
      event_interval = NULL, # default_event_interval,
      noise_sigma = NULL, # default_noise_sigma,
      minimum_abundances = NULL, # default_minimum_abundances,
      sim_duration = NULL, # default_sim_duration,
      sim_sample_interval = NULL, # default_sim_sample_interval,
      log10a_series = NULL, # default_log10a_series,
      initial_state = NULL, # default_initial_state,
      solver_method = NULL # "radau",
    )
    class(p) <- append(class(p), "runsim_parameter")
    if (...length() > 0) {
      valid <- ...names() %in% names(p)
      if (!all(valid)) {
        stop(paste0("Non defined parameter supplied: ", paste(...names()[!valid], collapse = ", ")))
      } else {
        for (nm in 1:...length()) {
          p[[...names()[[nm]]]] <- ...elt(nm)
        }
      }
    }
    
  }
  return(p)
}