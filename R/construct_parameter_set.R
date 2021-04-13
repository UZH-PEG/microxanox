#' Construct set of parameter values
#'
#' @param CB_strain_parms Data frame of parameter values of CB strains
#' @param PB_strain_parms Data frame of parameter values of PB strains
#' @param SB_strain_parms Data frame of parameter values of SB strains
#' @param all_other_parms Vector of all other parameters
#' @return A vector of a full set of parameter values
#' @export

construct_parameter_set <- function(CB_strain_params,
                                    PB_strain_params,
                                    SB_strain_params,
                                    all_other_parms)
{
  
  temp_CB <- CB_strain_params %>%
    pivot_longer(cols = 2:8, names_to = "temp_param_name", values_to = "value") %>%
    mutate(param_name = paste(temp_param_name, parse_number(strain_name), sep="_")) %>%
    select(param_name, value)
  temp_PB <- PB_strain_params %>%
    pivot_longer(cols = 2:9, names_to = "temp_param_name", values_to = "value") %>%
    mutate(param_name = paste(temp_param_name, parse_number(strain_name), sep="_")) %>%
    select(param_name, value)
  temp_SB <- SB_strain_params %>%
    pivot_longer(cols = 2:9, names_to = "temp_param_name", values_to = "value") %>%
    mutate(param_name = paste(temp_param_name, parse_number(strain_name), sep="_")) %>%
    select(param_name, value)
  temp_strain_params <- bind_rows(temp_CB, temp_PB, temp_SB)
  strain_params <- temp_strain_params$value
  names(strain_params) <- temp_strain_params$param_name
  strain_params <- c(strain_params, all_other_params)
  
  strain_params
  
}