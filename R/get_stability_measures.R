#' Get various measures of the stability
#' 
#' The measures include non-linearity and hysteresis measures, of an ecosystem
#' response to environmental change. Takes steady state data as the input.
#' @param ss_object object from which to calculate the stability measures. At
#'   the moment `replication_ssfind_result` or `data.frame`.
#' @param threshold_diff_log10scale Amount of different between up and down
#'   states to qualify as alternate stable states, on log10 scale
#' @param ... additional arguments for methods
#' 
#' @return A data frame of stability measures of each state variable
#'
#' @md
#'
#' @rdname get_stability_measures
#' @export
#'
#'
get_stability_measures <- function(
  ss_object,
  threshold_diff_log10scale,
  ...
) {
  
  UseMethod("get_stability_measures")
  
}