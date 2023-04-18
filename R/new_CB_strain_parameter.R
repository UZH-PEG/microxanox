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
  
  # Check for supported values of the argument "values"
  if (is.na(values)) {
    values <- "NA"
  }
  if (!(values %in% c("NA", "bush", "symmetric"))) {
    stop("Not supported value for `values`!\n", "Only NA, 'NA', 'bush' and 'symmetric' supported!")
  }
  
  ## Create object
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
  
  ## Add values for the case of Bush et al 2017
  if (values == "bush") {
    result$g_max_CB = rep(0.05, n)
    result$k_CB_P = rep(0.2, n)
    result$h_SR_CB = rep(300, n)
    result$y_P_CB = rep(1.67e8, n)
    result$Pr_CB = rep(6e-9, n)
    result$m_CB = rep(0.02, n)
    result$i_CB = rep(0, n)
  }
  
  if (values == "symmetric") {
    custom <- list( "g_max" = 0.1,  # growth rate
                    "k_B_P" = 0.5,  # SC50 on Phosphorus
                    "h_S_B" = 100,  # IC50 on substrates produced by bacteria
                    "y_P_B" = 1.67e8,  # abundance (bacteria) to concentration (P) conversion factor
                    "p_S_B" = 3e-8,  # abundance (bacteria) to concentration (Substrate) conversion factor (=production of S)
                    "m_B" = 0.04,    # mortality rate
                    "i_B" = 0)     # imigration of bacteria
    
    result$g_max_CB = rep(custom$g_max, n)
    result$k_CB_P = rep(custom$k_B_P, n)
    result$h_SR_CB = rep(custom$h_S_B, n)
    result$y_P_CB = rep(custom$y_P_B, n)
    result$Pr_CB = rep(custom$p_S_B, n)
    result$m_CB = rep(custom$m_B, n)
    result$i_CB = rep(custom$i_B, n)
  }
  
  class(result) <- append( "CB_strain_parameter", class(result))
  return(result)
}
