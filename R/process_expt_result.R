#' A function to process the output of the ss_by_a_N (find steady states) function
#'
#' @param temp_result The experimental results produced by ss_by_a_N
#' @return Processed experimental results.
#' 
#' @importFrom dplyr select mutate bind_rows arrange
#' 
#' @export
process_expt_result <- function(temp_result)
{
  # print(temp_result)
  result <- temp_result %>%
    tibble() %>%
    unnest(cols = 1) %>%
    mutate(initial_N_CB = expt$N_CB,
           a_O = expt$a_O)
  
  mm_result_wide <- result %>%
    group_by(a) %>%
    summarise_all(list(min = min, max = max))
  
  
  a_up <- mm_result_wide %>%
    select(a, ends_with("min")) %>%
    arrange(a)
  names(a_up) <- str_replace_all(names(a_up), "_min", "")
  a_down <- mm_result_wide %>%
    select(a, ends_with("max")) %>%
    arrange(-a)
  names(a_down) <- str_replace_all(names(a_down), "_max", "")
  
  a_up_down <- bind_rows(a_up, a_down) 
  #%>%
  #  mutate(N_CB = ifelse(N_CB < 1, 1, N_CB),
  #         N_SB = ifelse(N_SB < 1, 1, N_SB),
  #         N_PB = ifelse(N_PB < 1, 1, N_PB))
  
  a_up_down
  
}
