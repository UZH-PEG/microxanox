#' Function to run a simulation
#'
#' @param dynamic_model A function that defines the dynamical model to use.
#' @param event_definition A function that defines events that periodically take place.
#' @param event_interval The amount of time between events.
#' @param parameter_values A named vector of parameter values.
#' @param noise_sigma The amount of noise added to a state variable.
#' @param minimum_abundances The minimum abundances that a group of organisms can have; if less than this, then the abundance is increased to the minimum.
#' @param sim_duration The duration of the simulation.
#' @param sim_sample_interval The amount of time between samples.
#' @param log10a_series The time series of values of the log of parameter a (oxygen diffusivity).
#' @param initial_state The initial values of all state variables.
#' @param solver_method The method used in the ODE solver.
#' @return A list containing the time series of state variables and all arguments passed.
#' 
#' @importFrom stats approx approxfun
#' @importFrom deSolve ode
#' 
#' @export


run_simulation <- function(
  parameter
  # dynamic_model = default_dynamic_model,
  #                          event_definition = default_event_definition,
  #                          parameter_values = default_parameter_values,
  #                          event_interval = default_event_interval,
  #                          noise_sigma = default_noise_sigma,
  #                          minimum_abundances = default_minimum_abundances,
  #                          sim_duration = default_sim_duration,
  #                          sim_sample_interval = default_sim_sample_interval,
  #                          log10a_series = default_log10a_series,
  #                          initial_state = default_initial_state,
  #                          solver_method = "radau")
){
  if (!inherits(parameter, "runsim_parameter")) {
    stop("parameter has to be an object of type `runsim_parameter`!")
  }
  
  if(parameter$sim_sample_interval > parameter$sim_duration){
    stop("Simulation sample interval is greater than simualution duration... it should be shorter.")
  } 
  
  times <- seq(
    0,
    parameter$sim_duration,
    by = parameter$sim_sample_interval
  )
  
  event_times <- seq(min(times),
                     max(times),
                     by = parameter$event_interval)  
  
  log10a_forcing <- matrix(
    ncol = 2,
    byrow = F,
    data = c(
      ceiling(
        seq(
          0,
          max(times),
          length=length(parameter$log10a_series)
        )
      ),
      parameter$log10a_series
    )
  )
                                      
  log10a_forcing_func <- approxfun(
    x = log10a_forcing[,1],
    y = log10a_forcing[,2],
    method = "linear",
    rule = 2
  )
  
  ## assign the changed a_forcing2 into the global environment,
  ## from where the model gets it
  assign("log10a_forcing_func",
         log10a_forcing_func,
         envir = .GlobalEnv)
  
  assign("noise_sigma",
         parameter$noise_sigma,
         envir = .GlobalEnv)
  
  assign("minimum_abundances",
         parameter$minimum_abundances,
         envir = .GlobalEnv)
  
  
  out <- as.data.frame(
    ode(
      y = parameter$initial_state,
      times = times,
      func = parameter$dynamic_model,
      parms = parameter$parameter_values,
      method = parameter$solver_method,
      events = list(
        func = parameter$event_definition,
        time = event_times
      )
    )
  )
  
  result <- new_runsim_results(parameter, out)

  return(result)
    # list(
    #   result = out,
    #   dynamic_model = parameter$dynamic_model,
    #   event_definition = parameter$event_definition,
    #   parameter_values = parameter$parameter_values,
    #   event_interval = parameter$event_interval,
    #   noise_sigma = parameter$noise_sigma,
    #   minimum_abundances = parameter$minimum_abundances,
    #   sim_duration = parameter$sim_duration,
    #   sim_sample_interval = parameter$sim_sample_interval,
    #   log10a_forcing = log10a_forcing,
    #   log10a_forcing_func = log10a_forcing_func,
    #   initial_state = parameter$initial_state,
    #   solver_method = parameter$solver_method
    # )
              
}