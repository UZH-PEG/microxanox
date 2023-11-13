#' Create object of type `runsim_result` which is returned by the
#' function `run_sim()`.
#'
#' @param parameter object of class `runsim_parameter` which has been used
#'   to run the simulation
#' @param result a `data.frame` containing the results of the simulation
#'
#' @return object of the class `runsim_result`. This object of class
#'   `runsim_result` is identical to an object of class `runsim_parameter`
#'   plus an additional field `result` which contains the result of the simulation.
#' @md
#'
#' @autoglobal
#'
#' @export
#'
#' @examples
new_runsim_results <- function(
    parameter,
    result) {
  if (!inherits(parameter, "runsim_parameter")) {
    stop("`parameter` has to be of class runsim_parameter")
  }

  p <- parameter
  p$result <- result
  if (!inherits(p, "runsim_result")) {
    class(p) <- append(class(p), "runsim_result")
  }

  return(p)
}
