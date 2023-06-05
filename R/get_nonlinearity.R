#' Get the amount of non-linearity in a state-environment relationship.
#' 
#' Method described in Emancipator & Knoll (1993) Clinical Chemistry 39, 766-772, 
#' \url{https://doi.org/10.1093/clinchem/39.5.766}
#' @param x Environmental driver state variable
#' @param y Ecosystem state variable
#' @return Measure of non-linearity
#' 
#' @importFrom stats lm predict
#' 
#' @export
#'
get_nonlinearity <- function(x, y)
{
  ## if all state variable values are zero, set the result value to NA
  if(sum(y)==0)
    L <- NA
  
  ## if not all zero, calculate the metric
  if(!(sum(y)==0)) {
    lin_pred <- predict(lm(y ~ x))
    gam_pred <- predict(mgcv::gam(y ~ s(x)))
    L <- sqrt(sum((lin_pred-gam_pred)^2))/length(x)
  }
  
  L
}
