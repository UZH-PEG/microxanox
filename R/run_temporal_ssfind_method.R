#' Finds the stable states for a parameter set by increasing and decreasing
#' the oxygen diffusivity in a stepwise fashion.
#'
#' @param parameter an object of class `runsim_parameter` as returned by
#'   `new_runsim_parameter()`.
#' @return A data frame of final states and oxygen diffusivity values
#' @md
#' @importFrom stats approx approxfun
#' @importFrom deSolve ode
#' 
#' @export


run_temporal_ssfind_method <- function(p) {
  
  ## recalculate the wait time (length of a step)
  wait_time <- p$sim_duration / length(p$log10a_series)
  
  ## make function for the increasing ox diff steps
  up_l_f_f <- approxfun(x = wait_time * c(0:length(p$log10a_series)), 
                        y = (c(p$log10a_series, p$log10a_series[length(p$log10a_series)])),
                        method = "constant", rule = 1)
  
  ## make function for the decreasing ox diff steps
  down_l_f_f <- approxfun(x = wait_time * c(0:length(p$log10a_series)), 
                          y = c(rev(p$log10a_series), p$log10a_series[1]),
                          method = "constant", rule = 1)
  
  ## make times at which observations are made (i.e. at the end of a step)
  times <- c(0,
             seq(p$sim_sample_interval - 1,
                 p$sim_duration,
                 by = p$sim_sample_interval))
  
  ## make times at which events occur
  event_times <- c(0, seq(p$event_interval-1,
                          max(times),
                          by = p$event_interval))
  
  ## run a simulation for increasing ox diff
  up_res <- as.data.frame(
    deSolve::ode(
      y = p$strain_parameter$initial_state,
      times = times,
      func = p$dynamic_model,
      parms = p$strain_parameter,
      method = p$solver_method,
      events = list(
        func = p$event_definition,
        time = event_times
      ),
      log10a_forcing_func = up_l_f_f,
      noise_sigma = p$noise_sigma,
      minimum_abundances = p$minimum_abundances
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
      y = p$strain_parameter$initial_state,
      times = times,
      func = p$dynamic_model,
      parms = p$strain_parameter,
      method = p$solver_method,
      events = list(
        func = p$event_definition,
        time = event_times
      ),
      log10a_forcing_func = down_l_f_f,
      noise_sigma = p$noise_sigma,
      minimum_abundances = p$minimum_abundances
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
  
  return(result)
}





