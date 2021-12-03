#' Run a stable state finding experiment (e.g. get the stable states for different levels of diversity).
#'
#' @param parameter an object of class `runsim_parameter` as returned by
#'   `new_runsim_parameter()`.
#' @param var_expt An object that describes different levels of diversity that should be examined. This object is not created in the 'microxanox' package.
#' @param total_initial_abundances An object containing the total abundance in each functional group.
#' @return an object ...
#' @md
#' @importFrom multidplyr new_cluster cluster_library partition
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




