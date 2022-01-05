#' Create object of type `ss_by_a_N_result` which is returned by the
#' function `ss_by_a_N()`.
#'
#' @param parameter object of class `ss_by_a_N_parameter` which has been used
#'   to run the simulation
#' @param result a `data.frame` containing the results of the simulation
#'
#' @return object of the class `ss_by_a_N_result`. This object of class
#'   `ss_by_a_N_result` is identical to an object of class `ss_by_a_N_parameter` 
#'   plus an additional field `result` which contains the result of the simulation. 
#' @md
#' @export
#'
#' @examples
new_ss_by_a_N_results <- function(
  parameter, 
  result 
  ){
  if (!inherits(parameter, "ss_by_a_N_parameter")) {
    stop("`parameter` has to be of class ss_by_a_N_parameter")
  }
  
  p <- parameter
  p$result <- result
  if (!inherits(p, "ss_by_a_N_result")) {
    class(p) <- append(class(p), "ss_by_a_N_result")
  }
  
  return(p)
}