#' Create object of type `replication_ssfind_result` which is returned by the
#' function `run_replication_ssfind()`.
#'
#' @param parameter object of class `replication_ssfind_parameter` which has been used
#'   to run the simulation
#' @param result a `data.frame` containing the results of the simulation
#'
#' @return object of the class `replication_ssfind_result`. This object of class
#'   `replication_ssfind_result` is identical to an object of class `replication_ssfind_parameter`
#'   plus an additional field `result` which contains the result of the simulation.
#' @md
#'
#' @autoglobal
#'
#' @export
#'
#' @examples
new_replication_ssfind_results <- function(
    parameter,
    result) {
  if (!inherits(parameter, "replication_ssfind_parameter")) {
    stop("`parameter` has to be of class replication_ssfind_parameter")
  }

  p <- parameter
  p$result <- result
  if (!inherits(p, "replication_ssfind_result")) {
    class(p) <- append("replication_ssfind_result", class(p))
  }

  return(p)
}
