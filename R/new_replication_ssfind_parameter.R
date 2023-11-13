#' Create parameter set to run a set of simulations to find stable states. Is passed to the function `run_replication_ssfind_parameter()` to run such a set of simulations.
#'
#' @param ... named parameter for the simulation to be set.
#'   An error will be raised, if they are not part of the parameter set.
#'
#' @return object of the class `replication_ssfind_parameter`. This object of class
#'   `replication_ssfind_parameter` is identical to an object of class `runsim_parameter`
#'   plus an additional field `ss_expt` which contains a `data.frame` with
#'   columns named
#'   - `N_CB`
#'   - `N_PB`
#'   - `N_SB`
#'   - `a_0`
#'   which contain the initial states. If more than one strain is present, the same
#'   initial state is assumed for each.
#' @md
#' @export
#'
#' @autoglobal
#'
#' @examples
new_replication_ssfind_parameter <- function(
    ...) {
  p <- new_runsim_parameter()
  p$ss_expt <- NA
  if (!inherits(p, "replication_ssfind_parameter")) {
    class(p) <- append(class(p), "replication_ssfind_parameter")
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
  return(p)
}
