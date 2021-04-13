#' Function to get the steady states for combinations of a (oxygen diffusivity) and initial states.
#'
#' @param expt A data frame of oxygen diffusivities and initial conditions combinations, for example created with expand.grid.
#' @return Experimental result.
#' @export

ss_by_a_N <- function(expt)
{
  temp_result <- apply(expt, 1, function(x) get_final_states_a_N(x))
  result <- process_expt_result(temp_result)
  result
}