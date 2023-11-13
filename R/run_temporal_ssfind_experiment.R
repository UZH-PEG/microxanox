#' Run a stable state finding experiment via the temporal method (e.g. get the stable states for
#' different levels of oxygen diffusivity when oxygen diffusivity is varied in a stepwise fashion).
#'
#' Calls the function `run_temporal_ssfind` for each parameter set.
#' @param parameter an object of class `runsim_parameter` as returned by
#'   `new_runsim_parameter()`.
#' @param var_expt An object that describes different levels of diversity that
#'   should be examined. This object is **not** created in the 'microxanox' package.
#' @param total_initial_abundances An object containing the total abundance in
#'   each functional group.
#' @param cores Number of cores to use. If more than one, then `multidplyr` is used
#' @return an `tibble` object containing the stable state result, as well as the simulation parameters.
#' @md
#' @importFrom dplyr collect rowwise
#' @importFrom multidplyr new_cluster cluster_library partition
#'
#' @autoglobal
#'
#' @export


run_temporal_ssfind_experiment <- function(parameter,
                                           var_expt,
                                           total_initial_abundances,
                                           cores = 1) {
  if (cores == 1) {
    ## For each row of var_expt, add strain variation, set initial state,
    ## and get stable states.
    result <- var_expt %>%
      mutate(
        ssfind_pars = list({
          p <- parameter
          p$strain_parameter <- pars
          p <- set_temporal_ssfind_initial_state(
            p,
            total_initial_abundances,
            total_initial_abundances,
            total_initial_abundances
          )
          p
        })
      ) %>%
      mutate(ssfind_result = list(run_temporal_ssfind(ssfind_pars)))
  }

  if (cores > 1) {
    ## For each row of var_expt, add strain variation, set initial state,
    ## and get stable states.
    cluster <- multidplyr::new_cluster(cores)
    multidplyr::cluster_library(cluster, c("microxanox", "dplyr"))
    var_expt <- var_expt %>%
      mutate(
        parameter = list(parameter),
        total_initial_abundances = list(total_initial_abundances)
      )
    result <- var_expt %>%
      multidplyr::partition(cluster) %>%
      mutate(
        ssfind_pars = list({
          p <- parameter
          p$strain_parameter <- pars
          p <- set_temporal_ssfind_initial_state(
            p,
            total_initial_abundances,
            total_initial_abundances,
            total_initial_abundances
          )
          p
        })
      ) %>%
      mutate(ssfind_result = list(run_temporal_ssfind(ssfind_pars))) %>%
      collect() %>%
      rowwise()
  }

  return(result)
}
