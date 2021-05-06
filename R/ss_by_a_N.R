#' Function to get the steady states for combinations of a (oxygen diffusivity) and initial states.
#'
#' @param ss_expt A data frame of oxygen diffusivities and initial conditions combinations,
#' for example created with \code{"expand.grid"}.
#' @param param A set of parameter values and inital states
#' @return Experimental result.
#' @export

ss_by_a_N <- function(ss_expt, param)
{
  temp_result <- apply(ss_expt, 1, function(x) get_final_states_a_N(x, param))
  result <- process_ss_result(ss_expt, temp_result)
  result
}