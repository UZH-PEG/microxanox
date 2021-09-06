#' Creates a set of parameters and starting conditions for a simulation
#' A function to assist with the initialisation of a simulation, by providing various reference sets of parameter values and initial conditions.
#' The default is to create the parameter set used in Bush et al. (2017) and the anoxic favourable initial conditions used in the simulations for Figure 2a&b of that publication.
#' @param n_CB number of CB strains.
#' @param values_CB to be used for CB strains parameter or \code{"bush"}, in which case the default from Bush et al (2017) will be used.
#' @param n_PB number of PB strains.
#' @param values_PB to be used for PB strains parameter or \code{"bush"}, in which case the default from Bush et al (2017) will be used.
#' @param n_SB number of SB strains.
#' @param values_SB to be used for SB strains parameter or \code{"bush"}, in which case the default from Bush et al (2017) will be used.
#' @param values_other values to be used for other parameter or \code{"bush"}, in which case the default from Bush et al (2017) will be used.
#' @param values_initial_state values to be used for initial values or \code{"bush_anoxic"} or \code{"bush_oxic"}, in which case the default from Bush et al (2017) will be used.
#'
#' @return \code{list} with additional class \code{strain_parameter}
#' @md
#' @export
#'
new_strain_parameter <- function(n_CB = 1,
                                 values_CB = "bush",
                                 n_PB = 1,
                                 values_PB = "bush",
                                 n_SB = 1,
                                 values_SB = "bush",
                                 values_other = "bush",
                                 values_initial_state = "bush_anoxic_fig2ab") {
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

    parms$initial_state <- new_initial_state(n_CB = n_CB, n_PB = n_PB, n_SB = n_SB, values = values_initial_state)

    parms$ss_expt <- NULL
    
    class(parms) <- append("strain_parameter", class(parms))

    return(parms)
}