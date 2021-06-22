#' Function to get the steady states for combinations of a (oxygen diffusivity) and initial states.
#'
#' @param ss_expt A data frame of oxygen diffusivities and initial conditions combinations,
#' for example created with \code{"expand.grid"}.
#' @param param A set of parameter values and initial states
#' @param mc.cores the number of cores to be used. If 0, the old sequential version is used.
#'   The default is read from the option \code{mc.cores}, i.e. using \code{getOption("mc.cores", 0)}
#' @return Processed data about steady states
#' @export

ss_by_a_N <- function(ss_expt, param, mc.cores = getOption("mc.cores", 0)) {

  if (mc.cores == 0) {
    temp_result <- apply(ss_expt, 1, function(x) get_final_states_a_N(x, param))
  } else {
    temp_result <- parallel::mclapply(
      1:nrow(ss_expt),
      function(i) {
        get_final_states_a_N(ss_expt[i, ], param)
      }, mc.preschedule = FALSE,
      mc.cores = mc.cores
    )
    temp_result <- tibble::as_tibble(
      do.call(rbind, temp_result)
    )
  }

  result <- temp_result %>%
    tibble::tibble() %>%
    tidyr::unnest(cols = 1) %>%
    dplyr::mutate(initial_N_CB = ss_expt$N_CB,
                  initial_N_PB = ss_expt$N_PB,
                  initial_N_SB = ss_expt$N_SB,
                  a_O = ss_expt$a_O)

   result
}