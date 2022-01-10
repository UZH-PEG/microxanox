#' Returns object of class `strain_parameter`
#' 
#' Creates a set of parameters and starting conditions for a simulation. This
#' function assists with the initialization of a simulation, by providing
#' various reference sets of parameter values and initial conditions. The
#' default is to create the parameter set used in Bush et al. (2017)
#' \url{https://doi.org/10.1093/clinchem/39.5.766} and the anoxic favorable
#' initial conditions used in the simulations for Figure 2a&b of that
#' publication.
#' @param n_CB number of CB strains, default 1.
#' @param values_CB Allowed values are:
#' - `"bush"`: default values from Bush et al (2017) \url{https://doi.org/10.1093/clinchem/39.5.766} will be used for the parameter for CB
#' - `"NA"`: all initial values set to `NA`. Usable for e.g. setting own parameter
#' @param n_PB number of PB strains, default 1.
#' @param values_PB Allowed values are:
#' - `"bush"`: default values from Bush et al (2017) \url{https://doi.org/10.1093/clinchem/39.5.766} will be used for the parameter for PB
#' - `"NA"`: all parameter will be set to `NA`. Usable for e.g. setting own parameter
#' @param n_SB number of SB strains, default 1.
#' @param values_SB Allowed values are:
#' - `"bush"`: default values from Bush et al (2017) \url{https://doi.org/10.1093/clinchem/39.5.766} will be used for the parameter for SB
#' - `"NA"`: all parameter will be set to `NA`. Usable for e.g. setting own parameter
#' @param values_other  Allowed values are:
#' - `"bush"`: default values from Bush et al (2017) \url{https://doi.org/10.1093/clinchem/39.5.766}will be used for additional parameter
#' - `"NA"`: all parameter will be set to `NA`. Usable for e.g. setting own parameter
#' values to be used for other parameter or \code{"bush"},
#'   in which case the default from Bush et al (2017) will be used.
#' @param values_initial_state values to be used for initial values or
#'   \code{"bush_anoxic"} or \code{"bush_oxic"}, in which case the default from
#'   Bush et al (2017) \url{https://doi.org/10.1093/clinchem/39.5.766}will be used.
#' 
#' @return Object of class `strain_parameter`. The object contains the following fields:
#' The additional parameter are:
#'  ## Strain parameter
#'  - `CB`: strain parameter from Cyano Bacteria
#'  - `PB`: strain parameter for the Phototrophic bacteria
#'  - `SB`: strain parameter for the Sulphur bacteria
#'  ## substrate diffusivity
#'  - `a_S`: substrate diffusivity of sulphur <- 0.001
#'  - `a_O`: substrate diffusivity of oxygen <- 8e-4
#'  - `a_P`: substrate diffusivity of phosphorous <- 0.01
#'  ## background substrate concentration
#'  - `back_SR`: background substrate concentration of XXX <- 300
#'  - `back_SO`: background substrate concentration of XXX <- 300
#'  - `back_O`: background substrate concentration of oxygen <- 300
#'  - `back_P`: background substrate concentration of phosphorous <- 9.5
#'  ## oxidisation rate of reduced sulphur
#'  - `c`: <- 4e-5
#' @md
#' @export
#'
new_strain_parameter <- function(
  n_CB = 1,
  values_CB = "bush",
  n_PB = 1,
  values_PB = "bush",
  n_SB = 1,
  values_SB = "bush",
  values_other = "bush",
  values_initial_state = "bush_anoxic_fig2ab"
){
  if (is.na(values_other)) {
    values_other <- "NA"
  }
  
  if (!(values_other %in% c("NA", "bush"))) {
    stop("Not supported value for `values_other`!\n", "Only NA, 'NA' and 'bush' supported!")
  }
  
  parms <- list()
  
  # strain parameter --------------------------------------------------------
  
  parms$CB <- new_CB_strain_parameter(n = n_CB, values = values_CB)
  parms$PB <- new_PB_strain_parameter(n = n_PB, values = values_PB)
  parms$SB <- new_SB_strain_parameter(n = n_SB, values = values_SB)
  
  # other parameter ---------------------------------------------------------
  
  ## substrate diffusivity
  parms$a_S <- as.numeric(NA)
  parms$a_O <- as.numeric(NA)
  parms$a_P <- as.numeric(NA)
  
  ## background substrate concentration
  parms$back_SR <- as.numeric(NA)
  parms$back_SO <- as.numeric(NA)
  parms$back_O <- as.numeric(NA)
  parms$back_P <- as.numeric(NA)
  
  ## oxidisation rate of reduced sulphur
  parms$c <- as.numeric(NA)
  
  if (values_other == "bush") {
    ## substrate diffusivity
    parms$a_S <- 0.001
    parms$a_O <- 8e-4
    parms$a_P <- 0.01
    ## background substrate concentration
    parms$back_SR <- 300
    parms$back_SO <- 300
    parms$back_O <- 300
    parms$back_P <- 9.5
    ## oxidisation rate of reduced sulphur
    parms$c <- 4e-5
  }
  
  parms$initial_state <- new_initial_state(
    n_CB = n_CB, 
    n_PB = n_PB, 
    n_SB = n_SB, 
    values = values_initial_state
  )
  
  parms$ss_expt <- NULL
  
  class(parms) <- append("strain_parameter", class(parms))
  
  return(parms)
}