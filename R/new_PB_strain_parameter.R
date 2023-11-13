#' Create PB strain parameter
#'
#' @param n number of strains
#' @param values Allowed values are:
#' - `"bush"`: default values from Bush et al (2017) \doi{10.1038/s41467-017-00912-x} will be used
#' - `"NA"`: all parameter will be set to `NA`. Usable for e.g. setting own parameter
#'
#' @return object of class \code{PB_strain_parameter}. The object contains a
#'   `data.frame` with 8 columns and `n` rows. The columns are:
#'
#' columns:
#' - strain_name: the name of the strain
#' - g_max_PB:
#' - k_PB_SR:
#' - k_PB_P:
#' - h_O_PB:
#' - y_SR_PB:
#' - y_P_PB:
#' - m_PB:
#' - i_CB:
#'
#' @md
#'
#' @autoglobal
#'
#' @export
#'
new_PB_strain_parameter <- function(
    n = 1,
    values = "bush") {
  # Check for supported values of the argument "values"
  if (is.na(values)) {
    values <- "NA"
  }
  if (!(values %in% c("NA", "bush", "symmetric"))) {
    stop("Not supported value for `values`!\n", "Only NA, 'NA', 'bush' and 'symmetric' supported!")
  }

  ## Create object
  x <- rep(as.numeric(NA), n)
  nm <- paste0("PB_", 1:n)
  result <- data.frame(
    strain_name = nm,
    g_max_PB = x,
    k_PB_SR = x,
    k_PB_P = x,
    h_O_PB = x,
    y_SR_PB = x,
    y_P_PB = x,
    m_PB = x,
    i_PB = x
  )

  ## Add values for the case of Bush et al 2017
  if (values == "bush") {
    result$g_max_PB <- rep(0.07, n)
    result$k_PB_SR <- rep(10, n)
    result$k_PB_P <- rep(0.5, n)
    result$h_O_PB <- rep(100, n)
    result$y_SR_PB <- rep(1.25e7, n) ## Y_S_PB in the main text
    result$y_P_PB <- rep(1.67e8, n)
    result$m_PB <- rep(0.028, n)
    result$i_PB <- rep(0, n)
  }

  ## Only for consistency - is not actually used anyway
  if (values == "symmetric") {
    result$g_max_PB <- rep(0.07, n)
    result$k_PB_SR <- rep(10, n)
    result$k_PB_P <- rep(0.5, n)
    result$h_O_PB <- rep(100, n)
    result$y_SR_PB <- rep(1.25e7, n) ## Y_S_PB in the main text
    result$y_P_PB <- rep(1.67, n)
    result$m_PB <- rep(0.028, n)
    result$i_PB <- rep(0, n)
  }

  class(result) <- append("PB_strain_parameter", class(result))
  return(result)
}
