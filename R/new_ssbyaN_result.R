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