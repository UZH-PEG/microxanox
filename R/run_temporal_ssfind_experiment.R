#' Run a stable state finding experiment
#'
#' @param parameter an object of class `runsim_parameter` as returned by
#'   `new_runsim_parameter()`.
#' @param var_expt An object...
#' @param total_initial_abundances An object ...   
#' @return an object ...
#' @md
#' 
#' @export


run_temporal_ssfind_experiment <- function(parameter,
                                           var_expt,
                                           total_initial_abundances,
                                           cores = 1) {
  
  if(cores == 1)
  {
    ## Next chunck of code:
    ## For each line of var_expt, add strain variation, and get stable states.
    result <- var_expt %>%
      mutate(
        ssfind_pars = list({
          p <- parameter
          p$strain_parameter <- pars
          p <- set_temporal_ssfind_initial_state(p,
                                                 total_initial_abundances,
                                                 total_initial_abundances,
                                                 total_initial_abundances)
          p
        })
      ) %>%
      mutate(ssfind_result = list(run_temporal_ssfind_method(ssfind_pars))) 
  }
    
  if(cores > 1)
  {
    
    cluster <- multidplyr::new_cluster(cores)
    multidplyr::cluster_library(cluster, c("microxanox", "dplyr"))
    var_expt <- var_expt %>%
      mutate(parameter = list(parameter), 
             total_initial_abundances = list(total_initial_abundances))
    result <- var_expt %>%
      multidplyr::partition(cluster) %>%
      mutate(
        ssfind_pars = list({
          p <- parameter
          p$strain_parameter <- pars
          p <- set_temporal_ssfind_initial_state(p,
                                                 total_initial_abundances,
                                                 total_initial_abundances,
                                                 total_initial_abundances)
          p
        })
      ) %>%
      mutate(ssfind_result = list(run_temporal_ssfind_method(ssfind_pars))) %>%
      collect() %>%
      rowwise()

  }
  
  return(result)
}




