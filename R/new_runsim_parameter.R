#' Create parameter set with which to run a simulation.
#'
#' @param ... named parameter for the simulation to be set. 
#'   An error will be raised, if they are not part of the parameter set.
#'
#' @return parameter object of the class `runsim_parameter`. 
#' The object contains the following elements:
#' - dynamic_model      : the dynamic model to be used. At the moment, only `bushplus_dynamic_model` is implemented. Fur further info, see the documen tation of `bushplus_dynamic_model`.
#' - event_definition   : A function which alters the state variables. At the moment only `event_definition_1()` is included. User defined functions with the same signature can be used.
#' - strain_parameter   : object of class `strain_parameter` as returned by `new_strain_parameter()`
#' - event_interval     : interval, in timesteps, in which the event occurs"
#' - noise_sigma        : value of variation added to `SO`, `SR`, `O`, and `P` during the event
#' - minimum_abundances : Minimum abundances. Smaller abundances will be set to this value duting `event_definition_1()`.
#' - sim_duration       : duration of the simulation
#' - sim_sample_interval: interval, at which the simulation will be sampled
#' - log10a_series      : A vector of values of log10 oxygen diffusivity parameter at which stable states will be found.
#' - asym_factor:       : For symmetric simulations only: enables manipulating `aS` forcing in asymmetric manner to decrease (<1) or increase (>1) stress on cyanobacteria.
#' - solver_method      : Used for the solver. Default is `"radau"`. For other options, see the documentatioom of `odeSolve::ode`.
#' @md
#' @export
#'
#' @examples
new_runsim_parameter <- function(
  ...
){
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
    asym_factor = FALSE, # default_asym_factor
    solver_method = "radau" # "radau",
  )
  if (!inherits(p, "runsim_parameter")) {
    class(p) <- append(class(p), "runsim_parameter")
  }
  if (asym_factor) {
    ## extract diffusivity series
    sym.axis <- mean(parameter$log10a_series) # symmetry axis is between log10a_series limits
    p$log10aO_series <- parameter$log10a_series
    # mirror the log10_series to obtain symmetry between aO <--> aS(x) at sym.axis (y)
    p$log10aS_series <- 2*sym.axis - (seq(sym.axis - (abs(axis - min(log10a_series)) * parameter$asym_factor),
                                          sym.axis + (abs(axis - min(log10a_series)) * parameter$asym_factor),
                                          length = length(log10a_series)))
  }
  # } else {
  #   warning("This `runsim_parameter` can only be used for simulations in Bush et al. 2017 and Limberger et al 2023. If symmetry simulation is required, please provide parameter `asym_factor`.")
  # }
    
  
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
  
  return(p)
}