#' Create result object of the function \code{ss_by_a_N()}.
#'
#' This object of class \code{ss_by_a_N_result} is identical to the parameter object plus an additional field
#'   \code{result} which contains the result of the simulation.
#' @param parameter object of class \code{ss_by_a_N_parameter} which has been used to run the simulation
#' @param result a dataframe containing the results of the simulation
#' @param help if \code{TRUE}, the parameter will be listed and explained.
#'
#' @return parameter object of the class \code{ss_by_a_N_result}
#' @export
#'
#' @examples
new_ss_by_a_N_results <- function(
  parameter, result, help = FALSE
){
  if (help) {
    p <- list(
      result = "The result dataframe"
    )
  } else {
    if (!inherits(parameter, "ss_by_a_N_parameter")) {
      stop("`parameter` has to be of class ss_by_a_N_parameter")
    }
    
    p <- parameter
    p$result <- result
    class(p) <- append(class(p), "ss_by_a_N_result")

  }
  return(p)
}