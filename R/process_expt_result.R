#' A function to process the output of the \code{"get_final_states"} function
#'
#' @param ss_expt TODO
#' @param temp_result The experimental results produced by ss_by_a_N
#' @return Processed experimental results.
#' 
#' @importFrom dplyr select mutate bind_rows arrange group_by summarise_all
#' @importFrom tibble tibble
#' @importFrom tidyr unnest
#' @importFrom stringr str_replace_all
#' 
#' @export
process_ss_result <- function(ss_expt, temp_result)
{
  # print(temp_result)
  result <- temp_result %>%
    tibble::tibble() %>%
    tidyr::unnest(cols = 1) %>%
    dplyr::mutate(initial_N_CB = ss_expt$N_CB,
           a_O = ss_expt$a_O)
  
  mm_result_wide <- result %>%
    dplyr::group_by(a) %>%
    dplyr::summarise_all(list(min = min, max = max))
  
  
  a_up <- mm_result_wide %>%
    dplyr::select(a, dplyr::ends_with("min")) %>%
    dplyr::arrange(a)
  names(a_up) <- stringr::str_replace_all(names(a_up), "_min", "")
  a_down <- mm_result_wide %>%
    dplyr::select(a, ends_with("max")) %>%
    dplyr::arrange(-a)
  names(a_down) <- stringr::str_replace_all(names(a_down), "_max", "")
  
  a_up_down <- dplyr::bind_rows(a_up, a_down) 
  #%>%
  #  mutate(N_CB = ifelse(N_CB < 1, 1, N_CB),
  #         N_SB = ifelse(N_SB < 1, 1, N_SB),
  #         N_PB = ifelse(N_PB < 1, 1, N_PB))
  
  a_up_down
  
}
