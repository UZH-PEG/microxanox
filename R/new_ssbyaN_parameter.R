#' Create parameter to run the simulation by using the function `ss_by_a_N()`
#'
#' @param ... named parameter for the simulation to be set. 
#'   An error will be raised, if they are not part of the parameter set.
#'
#' @return object of the class `ss_by_a_N_parameter`. This object of class
#'   `ss_by_a_N_parameter` is identical to an object of class `runsim_paramweter` 
#'   plus an additional field `ss_expt` which contains a `data.frame` with XXXX 
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
#' @examples
new_ss_by_a_N_parameter <- function(
  ...
){
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
  return(p)
}