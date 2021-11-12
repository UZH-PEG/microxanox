#' Create object of type `runsim_result` which is used as the result of the
#' function `run_sim()`.
#'
#' @param parameter object of class `runsim_parameter` which has been used
#'   to run the simulation
#' @param result a dataframe containing the results of the simulation
#' @param help if `TRUE`, the parameter will be listed and explained.
#'
#' @return object of the class `runsim_result`. ' This object of class
#'   `runsim_result` is identical to the parameter object plus an additional
#'   field `result` which contains the result of the simulation. It contains 
#'   the following columns:
#'   - time: timestep of the simulation
#'   - CB_n: n ranges from 1 to number of CB strains. XXX of cyano bacteria. 
#'   - PB_n: n ranges from 1 to number of CB strains. XXX of phototrophic bacteria
#'   - SB_n: n ranges from 1 to number of CB strains. XXX of sulphur bacteria
#'   - SO  : XXX
#'   - SR  : XXX
#'   - O   : oxygen XXX
#'   - P   : phosphorous XXX
#'   - a   : XXX
#' @md
#' @export
#'
#' @examples
new_runsim_results <- function(
  parameter, 
  result, 
  help = FALSE
){
  if (help) {
    p <- list(
      dynamic_model = NA, # default_dynamic_model,
      event_definition = NA, # default_event_definition,
      strain_parameter = NA, # default_parameter_values,
      event_interval = NA, # default_event_interval,
      noise_sigma = NA, # default_noise_sigma,
      minimum_abundances = NA, # default_minimum_abundances,
      sim_duration = NA, # default_sim_duration,
      sim_sample_interval = NA, # default_sim_sample_interval,
      log10a_series = NA, # default_log10a_series,
      initial_state = NA, # default_initial_state,
      solver_method = "radau", # "radau",
      result = "The result dataframe"
    )
  } else {
    if (!inherits(parameter, "runsim_parameter")) {
      stop("`parameter` has to be of class runsim_parameter")
    }
    
    p <- parameter
    p$result <- result
    if (!inherits(p, "runsim_result")) {
      class(p) <- append(class(p), "runsim_result")
    }

  }
  return(p)
}