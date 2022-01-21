#' 
#' @rdname get_stability_measures
#' 
#' @global Quantity starts_with direction up down a_O a 
#' 
#' @importFrom tidyr gather spread
#' @importFrom dplyr summarise pull filter across
#' @importFrom stats na.omit
#' 
#' @export
get_stability_measures.temporal_ssfind_result <- function(
  ss_object,
  threshold_diff_log10scale = 3
) {
  if (inherits(ss_object, "replication_ssfind_result")) {
    result <- ss_object$result
  } else {
    result <- ss_object
  }
  
  ## The following is preparing the data
  these <- grep("B_", names(result))
  these <- c(these, which(names(result) %in% c("SO", "SR", "O", "P")))
  temp <- result %>%
    dplyr::filter(dplyr::across(these, ~ .x >-0.001)) %>% ## there are rarely negative abundances greater than -0.001. This line and the na.omit removes them 
    tidyr::gather(key = "Species", value = Quantity, these) %>%
    select(-time) %>%
    tidyr::spread(key = direction, value=Quantity, drop=T) %>%
    na.omit() 
  
  ## then get the stability measures
  res <- temp %>%
    dplyr::group_by(Species) %>%
    dplyr::summarise(hyst_tot_raw = get_hysteresis_total(up, down),
                     hyst_range_raw = get_hysteresis_range(up, down, a_O, 10^threshold_diff_log10scale),
                     hyst_min_raw = get_hysteresis_min(up, down, a_O, 10^threshold_diff_log10scale),
                     hyst_max_raw = get_hysteresis_max(up, down, a_O, 10^threshold_diff_log10scale),
                     nl_up_raw = get_nonlinearity(a_O, up),
                     nl_down_raw = get_nonlinearity(a_O, down),
                     hyst_tot_log = get_hysteresis_total(log10(up+1), log10(down+1)),
                     hyst_range_log = get_hysteresis_range(log10(up+1), log10(down+1), a_O, threshold_diff_log10scale),
                     hyst_min_log = get_hysteresis_min(log10(up+1), log10(down+1), a_O, threshold_diff_log10scale),
                     hyst_max_log = get_hysteresis_max(log10(up+1), log10(down+1), a_O, threshold_diff_log10scale),
                     nl_up_log = get_nonlinearity(a_O, log10(up+1)),
                     nl_down_log = get_nonlinearity(a_O, log10(down+1))
    ) 
  
  res
  
}

#' `tibble` is the same as `temporal_ssfind_result`
#' @rdname get_stability_measures
#' 
#' @export
get_stability_measures.tbl_df <- function(
  ss_object
) {
  get_stability_measures.temporal_ssfind_result(ss_object)
}

#' `data.frame` is the same as `temporal_ssfind_result`
#' @rdname get_stability_measures
#' 
#' @export
get_stability_measures.data.frame <- function(
  ss_object
) {
  get_stability_measures.temporal_ssfind_result(ss_object)
}


#' 
#' @export
get_stability_measures_temporal_ssfind_result <- function(
  ss_object
) {
  get_stability_measures.temporal_ssfind_result(ss_object)
}