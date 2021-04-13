#' Growth rate function on two resources X and Y
#'
#' @param X Concentration of resource X
#' @param Y Concentration of resource Y
#' @param g_max Maximum growth rate
#' @param k_X Half saturation constant for resource X
#' @param k_Y Half saturation constant for resource Y
#' @return Growth rate
#' @export
growth2 <- function(X, Y, g_max, k_X, k_Y)
  g_max * ( X / (k_X + X) ) * ( Y / (k_Y + Y))