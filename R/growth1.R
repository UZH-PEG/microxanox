
#' Growth rate function on one resource X
#'
#' @param X Concentration of resource X
#' @param g_max Maximum growth rate
#' @param k_X Half saturation constant for resource X
#' @return Growth rate
#' @export
growth1 <- function(X, g_max, k_X) {
  g_max * ( X / (k_X + X) )  
}
