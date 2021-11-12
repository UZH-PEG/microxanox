#' Create parameter to run the simulation by using the function \code{ss_by_a_N()}
#'
#' @param ... named parameter for the simulation to be set. 
#'   An error will be raised, if they are not part of the parameter set.
#' @param help if \code{TRUE}, the parameter will be listed and explained.
#'
#' @return parameter object of the class \code{ss_by_a_N_parameter}
#' @export
#'
#' @examples
new_ss_by_a_N_parameter <- function(..., help = FALSE) {
    if (help) {
        p <- list(
            dynamic_model = NA, # default_dynamic_model,
            event_definition = NA, # default_event_definition,
            strain_parameter = NA, # default_parameter_values,
            event_interval = NA, # default_event_interval,
            noise_sigma = NA, # default_noise_sigma,
            minimum_abundances = NA, # default_minimum_abundances,
            sim_duration = NA, # default_sim_duration,
            sim_sample_interval = NA, # default_sim_sample_interval,
            log10a_series = NA, # default_log10a_series,
            initial_state = NA, # default_initial_state,
            solver_method = "radau", # "radau",
            ss_expt = "A data frame of oxygen diffusivities and initial conditions combinations, for example created with `expand.grid()`."
        )
    } else {
        p <- new_runsim_parameter()
        p$ss_expt <- NA
        if (!inherits(p, "ss_by_a_N_parameter")) {
            class(p) <- append(class(p), "ss_by_a_N_parameter")
        }
        if (...length() > 0) {
            valid <- ...names() %in% names(p)
            if (!all(valid)) {
                stop(paste0("Non defined parameter supplied: ", paste(...names()[!valid], collapse = ", ")))
            } else {
                for (nm in 1:...length()) {
                    p[[...names()[[nm]]]] <- ...elt(nm)
                }
            }
        }
    }
    return(p)
}