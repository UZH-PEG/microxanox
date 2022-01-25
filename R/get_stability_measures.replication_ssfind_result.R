#' 
#' The function `get_stability_measures.replication_ssfind_result` extracts the `result`
#' `data.frame` or `tibble` from the object `x` and processes it. If one wants to extract. If 
#' one extracts the `results` manually, the function `get_stability_measures_replication_ssfind_result`
#' needs to be used.
#' @rdname get_stability_measures
#' 
#' @global Quantity starts_with direction up down a_O a 
#' 
#' @md
#' 
#' @importFrom tidyr gather spread
#' @importFrom dplyr summarise pull filter across
#' @importFrom stats na.omit
#' 
#' @export
get_stability_measures.replication_ssfind_result <- function(
  ss_object,
  threshold_diff_log10scale = 3,
  ...
){
  if (inherits(ss_object, "replication_ssfind_result")) {
    result <- ss_object$result
  } else {
    result <- ss_object
  }
  
  
  ## which initial condition varies?
  init_varying <- NA
  if(length(unique(result$initial_N_CB)) > 1)
    init_varying <- "initial_N_CB"
  if(length(unique(result$initial_N_SB)) > 1)
    init_varying <- "initial_N_SB"
  if(length(unique(result$initial_N_PB)) > 1)
    init_varying <- "initial_N_PB"
  
  if(!is.na(init_varying)) {
    
    result$init_varying <- dplyr::pull(result[,init_varying],1)
    
    min_iniN <- min(result$init_varying)
    max_iniN <- max(result$init_varying)
    
    ## The following is preparing the data
    these <- grep("B_", names(result))
    these <- c(these, which(names(result) %in% c("SO", "SR", "O", "P")))
    temp <- result %>%
      dplyr::mutate(direction = ifelse(init_varying == min_iniN, "up", "down")) %>%
      dplyr::filter(dplyr::across(these, ~ .x >-0.001)) %>% ## there are rarely negative abundances greater than -0.001. This line and the na.omit removes them 
      tidyr::gather(key = "Species", value = Quantity, these) %>%
      dplyr::select(-starts_with("initial_N_"), -init_varying) %>%
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
                       hyst_range_log = get_hysteresis_range(log10(up+1), log10(down+1), a, threshold_diff_log10scale),
                       hyst_min_log = get_hysteresis_min(log10(up+1), log10(down+1), a, threshold_diff_log10scale),
                       hyst_max_log = get_hysteresis_max(log10(up+1), log10(down+1), a, threshold_diff_log10scale),
                       nl_up_log = get_nonlinearity(a, log10(up+1)),
                       nl_down_log = get_nonlinearity(a, log10(down+1))
      ) 
  }
  
  if(is.na(init_varying)) {
    
    these <- grep("B_", names(result))
    these <- c(these, which(names(result) %in% c("SO", "SR", "O", "P")))
    Species <- names(result)[these]
    
    temp <- result %>%
      tidyr::gather(key = "Species", value = Quantity, these) %>%
      dplyr::select(-starts_with("initial_N_")) 
    
    res <- temp %>%
      dplyr::group_by(Species) %>%
      dplyr::summarise(
        hyst_tot_raw = 0,
        hyst_tot_log = 0,
        hyst_range_raw = 0,
        hyst_range_log = 0,
        hyst_min_raw = 0,
        hyst_min_log = 0,
        hyst_max_raw = 0,
        hyst_max_log = 0,
        nl_up_raw = get_nonlinearity(a_O, Quantity),
        nl_up_raw = get_nonlinearity(a_O, Quantity),
        nl_down_log = get_nonlinearity(a, log10(Quantity+1)),
        nl_down_log = get_nonlinearity(a, log10(Quantity+1))
      )
  }
  
  return(res)
}


#' The function `get_stability_measures.replication_ssfind_result` extracts the `result`
#' `data.frame` or `tibble` from the object `x` and processes it. If one wants to extract. If 
#' one extracts the `results` manually, the function `get_stability_measures_replication_ssfind_result`
#' needs to be used.
#' @rdname get_stability_measures
#' @md
#' @export
get_stability_measures_replication_ssfind_result <- function(
  ss_object
) {
  get_stability_measures.replication_ssfind_result(ss_object)
}

#' Get the total hysteresis of a system variable.
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @return The total hysteresis.
#' @export
get_hysteresis_total <- function(
  up, down
){
  if(sum((up+down)) == 0)
    res = NA
  else(
    res = mean(abs(up - down))
  )
  return(res)
}


#' Get the minimum of environmental conditions for which alternate stable states exist
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @param a An environmental driver, here it is usually oxygen diffusivity
#' @param threshold_diff Amount of different between up and down states to qualify as alternate stable states
#' @return A numeric value, which is the extent of the range of conditions for which alternate stable states exist.
#' @export
get_hysteresis_min <- function(
  up, 
  down, 
  a,
  threshold_diff
){
  temp1 <- abs(up - down) > threshold_diff ## hard coded difference sufficient to be alternate state
  
  if(sum((up+down)) == 0) {
    res = NA
    min_flip = NA
    max_flip = NA
  }
  else(
    if(sum(temp1)==0) {
      res <- 0
      min_flip = 0
      max_flip = 0
    }
    
    else({
      res <-  min(a[temp1])
    }
    )
  )
  return(res)
}

#' Get the maximum of environmental conditions for which alternate stable states exist
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @param a An environmental driver, here it is usually oxygen diffusivity
#' @param threshold_diff Amount of different between up and down states to qualify as alternate stable states
#' @return A numeric value, which is the extent of the range of conditions for which alternate stable states exist.
#' @export
get_hysteresis_max <- function(
  up, 
  down, 
  a,
  threshold_diff
){
  
  temp1 <- abs(up - down) > threshold_diff ## hard coded difference sufficient to be alternate state
  
  if(sum((up+down)) == 0) {
    res = NA
  }
  else(
    if(sum(temp1)==0) {
      res <- 0
    }
    
    else({
      res <- max(a[temp1])
    }
    )
  )
  return(res)
}



#' Get the range of environmental conditions for which alternate stable states exist
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @param a An environmental driver, here it is usually oxygen diffusivity
#' @param threshold_diff Amount of different between up and down states to qualify as alternate stable states
#' @return A numeric value, which is the extent of the range of conditions for which alternate stable states exist.
#' @export
get_hysteresis_range <- function(
  up, 
  down, 
  a,
  threshold_diff
){
  temp1 <- abs(up - down) > threshold_diff ## hard coded difference sufficient to be alternate state
  
  if(sum((up+down)) == 0) {
    res = NA
    #min_flip = NA
    #max_flip = NA
  }
  else(
    if(sum(temp1)==0) {
      res <- 0
      #min_flip = 0
      #max_flip = 0
    }
    
    else({
      res <- max(a[temp1]) - min(a[temp1])
      #min_flip = min(a[temp1])
      #max_flip = max(a[temp1])
    }
    )
  )
  return(res)
}


