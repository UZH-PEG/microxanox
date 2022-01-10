#' Create new `SB_strain_parameter` object
#'
#' @param n number of strains 
#' @param values Allowed values are:
#' - `"bush"`: default values from Bush et al (2017) \url{https://doi.org/10.1038/s41467-017-00912-x} will be used
#' - `"NA"`: all parameter will be set to `NA`. Usable for e.g. setting own parameter
#'
#' @return object of class \code{SB_strain_parameter}. The object contains a
#'   `data.frame` with 8 columns and `n` rows. The columns are:
#' 
#' columns: 
#' - strain_name: the name of the strain
#' - g_max_SB:
#' - k_PB_SO:
#' - k_SB_P:
#' - h_O_SB:
#' - y_SO_SB:
#' - y_PB_SB:
#' - m_SB:
#' - i_SB:
#' 
#' @md
#' 
#' @export
#'
new_SB_strain_parameter <- function(
  n = 1,
  values = "bush"
){
  if (is.na(values)) {
    values <- "NA"
  }
  
  if (!(values %in% c("NA", "bush"))) {
    stop("Not supported value for `values`!\n", "Only NA, 'NA' and 'bush' supported!")
  }
  
  x <- rep(as.numeric(NA), n)
  nm <- paste0("SB_", 1:n)
  result <- data.frame(
    strain_name = nm,
    g_max_SB = x,
    k_SB_SO = x,
    k_SB_P = x,
    h_O_SB = x,
    y_SO_SB = x,  
    y_P_SB = x,
    m_SB = x,
    i_SB = x
  )
  if (values == "bush") {
    result$g_max_SB = rep(0.1, n)
    result$k_SB_SO = rep(5, n)
    result$k_SB_P = rep(0.5, n)
    result$h_O_SB = rep(100, n)
    result$y_SO_SB = rep(3.33e7, n)
    result$y_P_SB = rep(1.67e8, n)
    result$m_SB = rep(0.04, n)
    result$i_SB = rep(0, n)
  }
  class(result) <- append( "SB_strain_parameter", class(result))
  return(result)
}
