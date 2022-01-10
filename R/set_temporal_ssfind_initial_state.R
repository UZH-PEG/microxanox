#' Convenience function for setting initial states during the process of finding
#' stable states using the function `run_temporal_ssfind_experiment`
#' Should only be used internally.
#' @param p parameters for the simulation
#' @param initial_total_CB Total initial abundance of CB
#' @param initial_total_PB Total initial abundance of PB
#' @param initial_total_SB Total initial abundance of SB
#' @return The passed parameter object but with initial states set (overwritten by the new ones)
#' @md
#' 
set_temporal_ssfind_initial_state <- function(p,
                                              initial_total_CB,
                                              initial_total_PB,
                                              initial_total_SB) {
  
  CBs <- unlist(rep(initial_total_CB /
                      length(grep("CB", names(p$strain_parameter$initial_state))), 
                    length(grep("CB", names(p$strain_parameter$initial_state)))))
  names(CBs) <- NULL
  p$strain_parameter$initial_state[grep("CB", names(p$strain_parameter$initial_state))] <- CBs
  
  
  PBs <- unlist(rep(initial_total_PB/length(grep("PB", names(p$strain_parameter$initial_state))), 
                    length(grep("PB", names(p$strain_parameter$initial_state)))))
  names(PBs) <- NULL
  p$strain_parameter$initial_state[grep("PB", names(p$strain_parameter$initial_state))] <- PBs
  
  SBs <- unlist(rep(initial_total_SB/length(grep("SB", names(p$strain_parameter$initial_state))), 
                    length(grep("SB", names(p$strain_parameter$initial_state)))))
  names(SBs) <- NULL
  p$strain_parameter$initial_state[grep("SB", names(p$strain_parameter$initial_state))] <- SBs
  
  p
}


