#' Find the stable states for a parameter set
#'
#' @param parameter an object of class `runsim_parameter` as returned by
#'   `new_runsim_parameter()`.
#' @return an object ...
#' @md
#' @importFrom stats approx approxfun
#' @importFrom deSolve ode
#' 
#' @export


run_temporal_ssfind_method <- function(p) {
  
  wait_time <- p$sim_duration / length(p$log10a_series)
  
  up_l_f_f <- approxfun(x = wait_time * c(0:length(p$log10a_series)), 
                        y = (c(p$log10a_series, p$log10a_series[length(p$log10a_series)])),
                        method = "constant", rule = 1)
  
  down_l_f_f <- approxfun(x = wait_time * c(0:length(p$log10a_series)), 
                          y = c(rev(p$log10a_series), p$log10a_series[1]),
                          method = "constant", rule = 1)
  
  #x <- seq(1, wait_time * length(p$log10a_series), 100)
  #plot(x, up_l_f_f(x), type = "l")
  #plot(x, down_l_f_f(x), type = "l")
  
  
  times <- c(0,
             seq(p$sim_sample_interval - 1,
                 p$sim_duration,
                 by = p$sim_sample_interval))
  
  event_times <- c(0, seq(p$event_interval-1,
                          max(times),
                          by = p$event_interval))
  
  
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
  up_res <- up_res %>%
    filter(time %in% times) %>%
    slice(-1) %>%
    mutate(direction = "up")
  
  #plot(up_res$time, log10(up_res$CB_1), type = "l")
  #plot(up_res$a, log10(up_res$CB_1), type = "l")
  
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
  down_res <- down_res %>%
    filter(time %in% times) %>%
    slice(-1) %>%
    mutate(direction = "down")
  
  #plot(down_res$time, log10(down_res$CB_1), type = "l")
  #plot(down_res$a, log10(down_res$CB_1), type = "l")
  
  result <- rbind(up_res, down_res) %>%
    rename(a_O = a)
  
  return(result)
}





