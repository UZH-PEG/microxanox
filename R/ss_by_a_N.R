#' Function to get the steady states for combinations of a (oxygen diffusivity) and initial states.
#'
#' @param ss_expt A data frame of oxygen diffusivities and initial conditions combinations,
#' for example created with \code{"expand.grid"}.
#' @param param A set of parameter values and initial states
#' @return Processed data about steady states
#' @export

ss_by_a_N <- function(ss_expt, param)
{
  temp_result <- apply(ss_expt, 1, function(x) get_final_states_a_N(x, param))
  
  result <- temp_result %>%
    tibble::tibble() %>%
    tidyr::unnest(cols = 1) %>%
    dplyr::mutate(initial_N_CB = ss_expt$N_CB,
                  initial_N_PB = ss_expt$N_PB,
                  initial_N_SB = ss_expt$N_SB,
                  a_O = ss_expt$a_O)

   result
}