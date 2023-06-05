#' Used to find the stable states for a parameter set by increasing and decreasing
#' the oxygen diffusivity in a stepwise fashion. If increasing `parameter$sim_duration`
#' while keeping the length of `parameter$log10_series` doesn't change response dynanimcs,
#' stable states have been found.
#'
#' @param parameter an object of class `runsim_parameter` as returned by
#'   `new_runsim_parameter()`.
#' @return A data frame of final states and oxygen diffusivity values
#' @md
#' @importFrom stats approx approxfun
#' @importFrom deSolve ode
#' @importFrom dplyr rename slice
#' 
#' @global time
#' 
#' @export


run_temporal_ssfind <- function(parameter) {
  
  ## recalculate the wait time (length of a step)
  wait_time <- parameter$sim_duration / length(parameter$log10a_series)
  
  ## make function for the increasing ox diff steps
  up_l_f_f <- approxfun(x = wait_time * c(0:length(parameter$log10a_series)), 
                        y = (c(parameter$log10a_series, parameter$log10a_series[length(parameter$log10a_series)])),
                        method = "constant", rule = 1)
  
  ## make function for the decreasing ox diff steps
  down_l_f_f <- approxfun(x = wait_time * c(0:length(parameter$log10a_series)), 
                          y = c(rev(parameter$log10a_series), parameter$log10a_series[1]),
                          method = "constant", rule = 1)
  
  ## make times at which observations are made (i.e. at the end of a step)
  times <- c(0,
             seq(parameter$sim_sample_interval - 1,
                 parameter$sim_duration,
                 by = parameter$sim_sample_interval))
  
  ## make times at which events occur
  event_times <- c(0, seq(parameter$event_interval-1,
                          max(times),
                          by = parameter$event_interval))
  
  ## run a simulation for increasing ox diff
  up_res <- as.data.frame(
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
      log10a_forcing_func = up_l_f_f,
      noise_sigma = parameter$noise_sigma,
      minimum_abundances = parameter$minimum_abundances
    )
  )
  ## organise results
  up_res <- up_res %>%
    filter(time %in% times) %>%
    slice(-1) %>%
    mutate(direction = "up")
  
  ## run a simulation for decreasing ox diff
  down_res <- as.data.frame(
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
      log10a_forcing_func = down_l_f_f,
      noise_sigma = parameter$noise_sigma,
      minimum_abundances = parameter$minimum_abundances
    )
  )
  ## organise results
  down_res <- down_res %>%
    filter(time %in% times) %>%
    slice(-1) %>%
    mutate(direction = "down")
  
  ## combine results
  result <- rbind(up_res, down_res) %>%
    rename(a_O = a)
  
  result <- new_temporal_ssfind_results(result = result)
  return(result)
}





