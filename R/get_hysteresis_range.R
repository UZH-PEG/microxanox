#' Get the range of environmental conditions for which alternate stable states exist
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @param a An environmental driver, here it is usually oxygen diffusivity
#' @return Growth rate
#' @export
get_hysteresis_range <- function(up, down, a)
{
  temp1 <- abs(log10(up) - log10(down)) > 0.1
  if(sum(temp1)==0)
    res <- 0
  if(sum(temp1)!=0)
    res <- max(a[temp1]) - min(a[temp1])
  res
}
