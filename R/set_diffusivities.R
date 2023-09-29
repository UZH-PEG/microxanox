#' Used to update the asymmetry factor with logaO_series & log10aS_series accordingly
#' 
#' The `set_diffusivities` enables manipulating `aS` forcing in asymmetric manner to decrease (<1) or increase (>1) stress on cyanobacteria. If the vector in 
#' `parameter$log10a_series` has multiple local minima, maxima respectively, it  is directly mirrored. ATTENTION: Mean value of the series has to be the axis at which the
#' vector is mirrored!
#' 
#' @param param         :parameter set of type `runsim_parameter`
#' @param asym_factor   :asym_factor to update `runsim_parameter`
#' 
#' @return updated parameterset
#' 
#' @md
#' @export


set_diffusivities <- function(param, 
                              asym_factor = 1
) {
  if (!inherits(param, "runsim_parameter")){
    stop("Provide parameter object of class `runsim_parameter`")
  }
  # check whether vector is used for time dynamics
  if (length(which(param$log10a_series == max(param$log10a_series))) > 1 | length(which(param$log10a_series == min(param$log10a_series))) > 1){
    param$log10aO_series <- log10a_series
    param$log10aS_series <- 2 * mean(param$log10a_series) - param$log10a_series
  } 
  else {
  param$asym_factor <- asym_factor
  ## extract diffusivity series
  sym.axis <- mean(param$log10a_series) # symmetry axis is between log10a_series limits
  param$log10aO_series <- param$log10a_series
  # mirror the log10_series to obtain symmetry between aO <--> aS(x) at sym.axis (y)
  param$log10aS_series <- 2*sym.axis - (seq(sym.axis - (abs(sym.axis - min(param$log10a_series)) * param$asym_factor),
                                            sym.axis + (abs(sym.axis - min(param$log10a_series)) * param$asym_factor),
                                            length = length(param$log10a_series)))
  }
  
  return (param)
}
  