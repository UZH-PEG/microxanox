#' Growth inhibition function
#'
#' @param X Concentration of substance X
#' @param h_X Concentration of substance X at which the inhibition factor is 0.5 (i.e. the concerned rate is halved)
#' @return Inhibition factor
#' @export
inhibition <- function(
  X, 
  h_X
) {
  1 / (1 + (X / h_X))
}