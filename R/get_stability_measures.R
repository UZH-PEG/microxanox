#' Get the range of environmental conditions for which alternate stable states exist
#'
#' @param ss_object An environmental driver, here it is usually oxygen diffusivity
#' @return Growth rate
#' @export
get_stability_measures <- function(ss_object) {
  
  ## The following is preparing the data
  these <- grep("_", names(ss_object))
  these <- these[c(-(length(these)-1), -length(these))]
  these <- c(these, which(names(ss_object) %in% c("SO", "SR", "O", "P")))
  temp <- ss_object %>%
    #rbind(ss_object) %>%
    mutate(direction = c(rep("up", nrow(ss_object)/2),
                         rep("down", nrow(ss_object)/2))) %>%
    gather(key = "Species", value = Quantity, these) %>%
    select(-initial_N_CB) %>%
    spread(key = direction, value=Quantity, drop=T)
  
  res <- temp %>%
    group_by(Species) %>%
    summarise(hyst_tot = get_hysteresis_total(log10(up+1), log10(down+1)),
              hyst_range = get_hysteresis_range(log10(up+1), log10(down+1), a),
              nl_up = get_nonlinearity(a, log10(up+1)),
              nl_down = get_nonlinearity(a, log10(down+1))
    )
  res
  
  
}

#' Get the range of environmental conditions for which alternate stable states exist
#'
#' @param up State variable values as the environmental condition increases
#' @param down State variable values as the environmental condition decreases
#' @return Growth rate
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
#' @return Growth rate
#' @export
get_hysteresis_range <- function(up, down, a)
{
  
  temp1 <- abs(up - down) > 0.1
  
  if(sum((up+down)) == 0)
    res = NA
  else(
    if(sum(temp1)==0)
      res <- 0
    else(
      res <- max(a[temp1]) - min(a[temp1])
    )
  )
  res
}


