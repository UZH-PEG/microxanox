#' Get various measures of the stability, specifically non-linearity and hysteresis measures, of an ecosystem response to environmental change.
#' Takes steady state data as the input. 
#'
#' @param ss_object An object of class \code{ss_by_a_N_result} as returned by the ss_by_a_N() function or
#'   the \code{result} e;ement of that object, i.e. \code{x$result}.
#' @return A data frame of stability measures of each state variable
#' @importFrom tidyr gather spread
#' @importFrom dplyr summarise
#' 
#' @export
get_stability_measures <- function(ss_object) {
  if (inherits(ss_object, "ss_by_a_N_result")) {
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
  
  result$init_varying <- pull(result[,init_varying],1)
  
  min_iniN <- min(result$init_varying)
  max_iniN <- max(result$init_varying)
  
  ## The following is preparing the data
  these <- grep("B_", names(result))
  #these <- these[c(-(length(these)-1), -length(these))]
  these <- c(these, which(names(result) %in% c("SO", "SR", "O", "P")))
  temp <- result %>%
    #rbind(result) %>%
    mutate(direction = ifelse(init_varying == min_iniN, "up", "down")) %>%
    filter(across(these, ~ .x >-0.001)) %>% ## there are rarely negative abundances greater than -0.001. This line and the na.omit removes them 
    tidyr::gather(key = "Species", value = Quantity, these) %>%
    dplyr::select(-starts_with("initial_N_"), -init_varying) %>%
    tidyr::spread(key = direction, value=Quantity, drop=T) %>%
    na.omit()  ## 31000 to 30969
  

  ## then get the stability measures
  res <- temp %>%
    dplyr::group_by(Species) %>%
    dplyr::summarise(hyst_tot = get_hysteresis_total(log10(up+1), log10(down+1)),
                     hyst_range = get_hysteresis_range(log10(up+1), log10(down+1), a),
                     hyst_min = get_hysteresis_min(log10(up+1), log10(down+1), a),
                     hyst_max = get_hysteresis_max(log10(up+1), log10(down+1), a),
                     nl_up = get_nonlinearity(a, log10(up+1)),
                     nl_down = get_nonlinearity(a, log10(down+1))
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
    dplyr::summarise(hyst_tot = 0,
                     hyst_range = 0,
                     hyst_min = 0,
                     hyst_max = 0,
                     nl_up = get_nonlinearity(a, log10(Quantity+1)),
                     nl_down = get_nonlinearity(a, log10(Quantity+1)))
  }
  
  res
  
}

#' Get the total hysteresis of a system variable.
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @return A numeric value--the total hysteresis.
#' @export
get_hysteresis_total <- function(up, down) {
  
  if(sum((up+down)) == 0)
    res = NA
  else(
    res = mean(abs(up - down))
  )
  res
}


#' Get the range of environmental conditions for which alternate stable states exist
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @param a An environmental driver, here it is usually oxygen diffusivity
#' @return A numeric value, which is the extent of the range of conditions for which alternate stable states exist.
#' @export
get_hysteresis_min <- function(up, down, a)
{
  
  temp1 <- abs(up - down) > 0.1
  
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
  res
}

#' Get the range of environmental conditions for which alternate stable states exist
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @param a An environmental driver, here it is usually oxygen diffusivity
#' @return A numeric value, which is the extent of the range of conditions for which alternate stable states exist.
#' @export
get_hysteresis_max <- function(up, down, a)
{
  
  temp1 <- abs(up - down) > 0.1
  
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
  res
}



#' Get the range of environmental conditions for which alternate stable states exist
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @param a An environmental driver, here it is usually oxygen diffusivity
#' @return A numeric value, which is the extent of the range of conditions for which alternate stable states exist.
#' @export
get_hysteresis_range <- function(up, down, a)
{
  
  temp1 <- abs(up - down) > 0.1
  
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
  res
}


