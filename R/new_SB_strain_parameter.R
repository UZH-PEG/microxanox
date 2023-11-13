#' Create new `SB_strain_parameter` object
#'
#' @param n number of strains
#' @param values Allowed values are:
#' - `"bush"`: default values from Bush et al (2017) \doi{10.1038/s41467-017-00912-x} will be used
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
#' @autoglobal
#'
#' @export
#'
new_SB_strain_parameter <- function(
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

  ## Add values for the case of Bush et al 2017
  if (values == "bush") {
    result$g_max_SB <- rep(0.1, n)
    result$k_SB_SO <- rep(5, n)
    result$k_SB_P <- rep(0.5, n)
    result$h_O_SB <- rep(100, n)
    result$y_SO_SB <- rep(3.33e7, n)
    result$y_P_SB <- rep(1.67e8, n)
    result$m_SB <- rep(0.04, n)
    result$i_SB <- rep(0, n)
  }

  if (values == "symmetric") {
    custom <- list(
      "g_max" = 0.1, # growth rate
      "k_B_P" = 0.5, # SC50 on Phosphorus
      "h_S_B" = 100, # IC50 on substrates produced by bacteria
      "y_P_B" = 1.67e8, # abundance (bacteria) to concentration (P) conversion factor
      "p_S_B" = 3e-8, # abundance (bacteria) to concentration (Substrate) conversion factor (=production of S)
      "m_B" = 0.04, # mortality rate
      "i_B" = 0
    ) # imigration of bacteria

    result$g_max_SB <- rep(custom$g_max, n)
    result$k_SB_SO <- rep(20, n)
    result$k_SB_P <- rep(custom$k_B_P, n)
    result$h_O_SB <- rep(custom$h_S_B, n)
    result$y_SO_SB <- rep(custom$p_S_B, n)
    result$y_P_SB <- rep(custom$y_P_B, n)
    result$m_SB <- rep(custom$m_B)
    result$i_SB <- rep(custom$i_B, n)
  }

  class(result) <- append("SB_strain_parameter", class(result))
  return(result)
}
