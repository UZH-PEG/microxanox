


run_simulation <- function(dynamic_model = bushplus_dynamic_model_strains,
                           event_definition = default_event_definition_strains,
                           parameter_values = default_parameter_values,
                           event_interval = default_event_interval,
                           noise_sigma = default_noise_sigma,
                           minimum_abundances = default_minimum_abundances,
                           sim_duration = default_sim_duration,
                           sim_sample_interval = default_sim_sample_interval,
                           log10a_series = default_log10a_series,
                           initial_state = default_initial_state,
                           solver_method = "radau")
{
  
  
  times <- seq(0,
               sim_duration,
               by = sim_sample_interval)
  
  event_times <- seq(min(times),
                     max(times),
                     by = event_interval)  
  
  log10a_forcing <- matrix(ncol=2,
                               byrow=F,
                               data=c(ceiling(seq(0,
                                                  max(times),
                                                  length=length(log10a_series))),
                                      log10a_series))
                                      
  log10a_forcing_func <- approxfun(x = log10a_forcing[,1],
                              y = log10a_forcing[,2],
                              method = "linear",
                              rule = 2)
  
  ## assign the changed a_forcing2 into the global environment,
  ## from where the model gets it
  assign("log10a_forcing_func",
         log10a_forcing_func,
         envir = .GlobalEnv)
  
  assign("noise_sigma",
         noise_sigma,
         envir = .GlobalEnv)
  
  assign("minimum_abundances",
         minimum_abundances,
         envir = .GlobalEnv)
  
  
  out <- as.data.frame(ode(y = initial_state,
                           times = times,
                           func = dynamic_model,
                           parms = parameter_values,
                           method = solver_method,
                           events = list(func=event_definition,
                                         time=event_times)))
  
  return(list(result = out,
              dynamic_model = dynamic_model,
              event_definition = event_definition,
              parameter_values = parameter_values,
              event_interval = event_interval,
              noise_sigma = noise_sigma,
              minimum_abundances = minimum_abundances,
              sim_duration = sim_duration,
              sim_sample_interval = sim_sample_interval,
              log10a_forcing = log10a_forcing,
              log10a_forcing_func = log10a_forcing_func,
              initial_state = initial_state,
              solver_method = solver_method))
              
}