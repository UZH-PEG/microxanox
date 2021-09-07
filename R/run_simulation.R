#' Function to run a simulation
#'
#' @param parameter An object of class \code{runsim_parameter} as returned by \code{new_runsim_parameter()}.
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
                                      
  l_f_f <- approxfun(
    x = log10a_forcing[,1],
    y = log10a_forcing[,2],
    method = "linear",
    rule = 2
  )
  
  ## assign the changed a_forcing2 into the global environment,
  ## from where the model gets it
  # assign("log10a_forcing_func",
  #        log10a_forcing_func,
  #        envir = .GlobalEnv)
  # 
  # assign("noise_sigma",
  #        parameter$noise_sigma,
  #        envir = .GlobalEnv)
  # 
  # assign("minimum_abundances",
  #        parameter$minimum_abundances,
  #        envir = .GlobalEnv)

  
  out <- as.data.frame(
    ode(
      y = parameter$strain_parameter$initial_state,
      times = times,
      func = parameter$dynamic_model,
      parms = parameter$strain_parameter,
      method = parameter$solver_method,
      events = list(
        func = parameter$event_definition,
        time = event_times
      ),
      log10a_forcing_func = l_f_f,
      noise_sigma = parameter$noise_sigma,
      minimum_abundances = parameter$minimum_abundances
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