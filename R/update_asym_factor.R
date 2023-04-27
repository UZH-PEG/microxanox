#' Used to update the asymmetry factor with logaO_series & log10aS_series accordingly
#' 
#' The `asy_factor` enables manipulating `aS` forcing in asymmetric manner to decrease (<1) or increase (>1) stress on cyanobacteria.
#' 
#' @param param         :parameter set of type `runsim_parameter`
#' @param asym_factor   :asym_factor to update `runsim_parameter`
#' 
#' @return updated parameterset
#' 
#' @md
#' @export


update_asym_factor <- function(param, 
                              asym_factor = 1
) {
  if (!inherits(parameter, "runsim_parameter")){
    stop("Provide parameter object of class `runsim_parameter`")
  }
  
  param$asym_factor <- asym_factor
  ## extract diffusivity series
  sym.axis <- mean(param$log10a_series) # symmetry axis is between log10a_series limits
  param$log10aO_series <- param$log10a_series
  # mirror the log10_series to obtain symmetry between aO <--> aS(x) at sym.axis (y)
  param$log10aS_series <- 2*sym.axis - (seq(sym.axis - (abs(axis - min(param$log10a_series)) * param$asym_factor),
                                        sym.axis + (abs(axis - min(param$log10a_series)) * param$asym_factor),
                                        length = length(param$log10a_series)))
  
  return (param)
}
  