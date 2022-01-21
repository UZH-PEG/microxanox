#' Create object of type `temporal_ssfind_result` which is returned by the
#' function `run_temporal_ssfind_parameter()`.
#' 
#' @param parameter  not used - for consistency.
#' @param result a `data.frame` containing the results of the simulation
#'
#' @return the `result` object.
#' 
#' @md
#' @export
#'
#' @examples
new_temporal_ssfind_results <- function(
  parameter = NULL,
  result
  ){
  # if (!inherits(parameter, "replication_ssfind_parameter")) {
  #   stop("`parameter` has to be of class replication_ssfind_parameter")
  # }

  if (!inherits(result, "temporal_ssfind_result")) {
    class(result) <- append(class(result), "temporal_ssfind_result")
  }

  return(result)
}