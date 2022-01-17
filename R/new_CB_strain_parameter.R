#' Create CB strain parameter values
#'
#' @param n number of strains
#' @param values Allowed values are:
#' - `"bush"`: default values from Bush et al (2017) \url{https://doi.org/10.1038/s41467-017-00912-x} will be used
#' - `"NA"`: all parameter will be set to `NA`. Usable for e.g. setting own parameter
#'  
#' @return object of class \code{CB_strain_parameter}. The object contains a
#'   `data.frame` with 8 columns and `n` rows. The columns are:
#' 
#' columns: 
#' - strain_name: the name of the strain
#' - g_max_CB:
#' - k_CB_P:
#' - h_SR_CB:
#' - y_P_CB:
#' - Pr_CB:
#' - m_CB:
#' - i_CB:
#' 
#' @md
#' @export
#'
new_CB_strain_parameter <- function(
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
  nm <- paste0("CB_", 1:n)
  result <- data.frame(
    strain_name = nm,
    g_max_CB = x,
    k_CB_P = x,
    h_SR_CB = x,
    y_P_CB = x,
    Pr_CB = x,
    m_CB = x,
    i_CB = x
  )
  if (values == "bush") {
    result$g_max_CB = rep(0.05, n)
    result$k_CB_P = rep(0.2, n)
    result$h_SR_CB = rep(300, n)
    result$y_P_CB = rep(1.67e8, n)
    result$Pr_CB = rep(6e-9, n)
    result$m_CB = rep(0.02, n)
    result$i_CB = rep(0, n)
  }
  class(result) <- append( "CB_strain_parameter", class(result))
  return(result)
}
