#' Run the symmetric simulation
#'
#' This function takes the `parameter` object and runs a simulation based on these.
#' It returns an object of class `runsim_result` which contains an additional
#' entry, i.e. `result` which contains the results of the simulation. The
#' simulation can be re-run using the returned object as input `parameter`.
#' @param parameter an object of class `runsim_parameter` as returned by
#'   `new_runsim_parameter()`. Needs to hold key sym_axis.
#' @return an object of class `runsim_result`, obtained from running the
#'   simulation as defined in `parameter`.`
#' @md
#' @importFrom stats approx approxfun
#' @importFrom deSolve ode
#'
#' @autoglobal
#'
#' @export


run_simulation_symmetric <- function(
    parameter) {
  if (!inherits(parameter, "runsim_parameter")) {
    stop("parameter has to be an object of type `runsim_parameter`!")
  }

  if (parameter$sim_sample_interval > parameter$sim_duration) {
    stop("Simulation sample interval is greater than simulation duration... it should be shorter.")
  }

  ## make the times at which observations will be recorded
  times <- seq(
    0,
    parameter$sim_duration,
    by = parameter$sim_sample_interval
  )

  ## make the times at which events will occur
  event_times <- seq(min(times),
    max(times),
    by = parameter$event_interval
  )


  ## create the series of oxygen diffusivity values
  log10a_forcing <- matrix(
    ncol = 3,
    byrow = F,
    data = c(
      ceiling(
        seq(
          0,
          max(times),
          length = length(parameter$log10a_series)
        )
      ),
      parameter$log10aO_series, # oxygen diffusivities
      parameter$log10aS_series # mirrored sulfur diffusivities at sym_axis
    )
  )

  ## Make the function to give the oxygen diffusivity at a particular time
  l_f_f_O <- approxfun(
    x = log10a_forcing[, 1],
    y = log10a_forcing[, 2],
    method = "linear",
    rule = 2
  )


  ## Make the function to give the sulfur diffusivity at a particular time
  l_f_f_S <- approxfun(
    x = log10a_forcing[, 1],
    y = log10a_forcing[, 3],
    method = "linear",
    rule = 2
  )


  ## Run the simulation
  out <- as.data.frame(
    deSolve::ode(
      y = parameter$strain_parameter$initial_state,
      times = times,
      func = parameter$dynamic_model,
      parms = parameter$strain_parameter,
      method = parameter$solver_method,
      events = list(
        func = parameter$event_definition,
        time = event_times
      ),
      log10aO_forcing_func = l_f_f_O,
      log10aS_forcing_func = l_f_f_S,
      noise_sigma = parameter$noise_sigma,
      minimum_abundances = parameter$minimum_abundances
    )
  )


  result <- new_runsim_results(parameter, out)

  return(result)
}
