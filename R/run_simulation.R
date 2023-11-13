#' Run the simulation
#'
#' This function takes the `parameter` object and runs a simulation based on these.
#' It returns an object of class `runsim_result` which contains an additional
#' entry, i.e. `result` which contains the results of the simulation. The
#' simulation can be re-run using the returned object as input `parameter`.
#' @param parameter an object of class `runsim_parameter` as returned by
#'   `new_runsim_parameter()`.
#' @return an object of class `runsim_result`, obtained from running the
#'   simulation as defined in `parameter`.`
#' @md
#' @importFrom stats approx approxfun
#' @importFrom deSolve ode
#'
#' @autoglobal
#'
#' @export


run_simulation <- function(
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
    ncol = 2,
    byrow = F,
    data = c(
      ceiling(
        seq(
          0,
          max(times),
          length = length(parameter$log10a_series)
        )
      ),
      parameter$log10a_series
    )
  )

  ## Make the function to give the oxygen diffusivity at a particular time
  l_f_f <- approxfun(
    x = log10a_forcing[, 1],
    y = log10a_forcing[, 2],
    method = "linear",
    rule = 2
  )

  if (is.null(parameter$event_definition)) {
    events <- NULL
  } else {
    events <- list(
      func = parameter$event_definition,
      time = event_times
    )
  }
  ## Run the simulation
  out <- as.data.frame(
    deSolve::ode(
      y = parameter$strain_parameter$initial_state,
      times = times,
      func = parameter$dynamic_model,
      parms = parameter$strain_parameter,
      method = parameter$solver_method,
      events = events,
      log10a_forcing_func = l_f_f,
      noise_sigma = parameter$noise_sigma,
      minimum_abundances = parameter$minimum_abundances
    )
  )

  result <- new_runsim_results(parameter, out)

  return(result)
}
