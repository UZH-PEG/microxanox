new_runsim_results <- function(
  parameter, result, help = FALSE
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
      solver_method = NULL, # "radau",
      result = "The result dataframe"
    )
  } else {
    p <- parameter
    p$result <- result
    class(p) <- append(class(p), "runsim_result")

  }
  return(p)
}