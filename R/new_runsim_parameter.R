#' Create parameter to run the simulation by using the function `run_sim()`
#'
#' @param ... named parameter for the simulation to be set. 
#'   An error will be raised, if they are not part of the parameter set.
#' @param help if \code{TRUE}, the parameter will be listed and explained.
#'
#' @return parameter object of the class `runsim_parameter`. 
#' The object contains the following elements:
#' - dynamic_model      : the dynamic model to be used. At the moment, only `bushplus_dynamic_model` is implemented. Fur further info, see the documen tation of `bushplus_dynamic_model`.
#' - event_definition   : A function which alters the state variables. At the moment only `event_definition_1()` is included. User defined functions with the same signature can be used.
#' - strain_parameter   : object of class `strain_parameter` as returned by `new_strain_parameter()`
#' - event_interval     : interval, in timesteps, in which the event occurs"
#' - noise_sigma        : XXX
#' - minimum_abundances : Minimum abundances. Smaller abundances will be set to this value duting `event_definition_1()`.
#' - sim_duration       : duration of the simulation
#' - sim_sample_interval: interval, at which the simulation will be sampled
#' - log10a_series      : XXX
#' - solver_method      : Used for the solver. Default is `"radau"`. For other options, see the documentatioom of `odeSolve::ode`.
#' @md
#' @export
#'
#' @examples
new_runsim_parameter <- function(
  ..., help = FALSE
){
  if (help) {
    p <- list(
      dynamic_model = "the dynamic model to be used. At the moment, only `bushplus_dynamic_model` is implemented.",
      event_definition = "A function which alters the state variables. At the moment only `event_definition_1()` is included. User defined functions with the same signature can be used.",
      strain_parameter = "object of class `strain_parameter` as returned by `new_strain_parameter()`",
      event_interval = "interval, in timesteps, in which the event occurs",
      noise_sigma = NA, # default_noise_sigma,
      minimum_abundances = "Minimum abundances. Smaller abundances will be set to this value duting `event_definition_1()`.",
      sim_duration = "duration of the simulation",
      sim_sample_interval = "interval, at which the simulation is sampled",
      log10a_series = NA, # default_log10a_series,
      solver_method = "Used for the solver. Default is `radau`. For other options, see the documentatioom of `odeSolve::ode`"
    )
  } else {
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
      solver_method = "radau" # "radau",
    )
    if (!inherits(p, "runsim_parameter")) {
      class(p) <- append(class(p), "runsim_parameter")
    }
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