#' Plot the temporal dynamics of a model run of a symmetric parameter set
#' 
#' This is a convenience function to plot the dynamics of a model run particularly
#' for a symmetric model
#' with strains within functional groups displayed.
#' @param temporal_results Results from \code{run_temporal_ssfind()} or from \code{run_temporal_ssfind_symmetric()}
#' @return returns the ggplot object of the plot. If it is assigned to a 
#'    variable, the plot needs to be plotted, otherwise it is plotted.
#' 
#' @global
#' 
#' @importFrom dplyr filter mutate row_number case_when
#' @importFrom ggplot2 ggplot aes facet_wrap xlab ylab geom_line scale_colour_manual guides guide_legend
#' @importFrom tidyr gather
#' @importFrom grDevices colorRampPalette
#' @importFrom stringr str_detect
#' @import patchwork
#' 
#' @export
plot_temporal_ss <- function(temporal_results){

  # wrangling if non symmetric simulation is put in 
  if ("direction" %in% colnames(temporal_results)) {
    
    temporal_results <- temporal_results %>% 
      mutate(aO = a_O) %>% 
      mutate(recovery = ifelse(direction == "up", "oxic", "anoxic"))
  }
  
  p_organisms <- temporal_results %>%
    select(aO, recovery,
           starts_with("CB"),
           starts_with("SB")) %>%
    gather(key = species, value = Quantity, 3:ncol(.)) %>%
    ggplot() + 
    geom_path(aes(x = aO, y = log10(Quantity + 1), col = species, linetype = recovery), linewidth = 1) + 
    scale_color_manual(values = c("#38761d", "#cc0000" )) + 
    # geom_vline(xintercept = log10(0.1), linetype = "dotted", color = "black", linewidth = 2) +
    ylab(expression(Log[10](Abundance+1))) +
    xlab(expression(Log[10](Oxygen~diffusivity))) +
    ylim(0,10) +
    #theme_bw() +
    labs(title="Organisms")
  
  p_substrates <- temporal_results %>%
    select(aO, recovery, SR, O, P) %>%
    gather(key = substrate, value = Quantity, 3:ncol(.)) %>%
    ggplot() + 
    geom_path(aes(x = aO, y = log10(Quantity + 1), col = substrate, linetype = recovery), linewidth = 1) + 
    scale_color_manual(values = c("#38761d", "#2986cc", "#cc0000")) +
    # geom_vline(xintercept = log10(0.1), linetype = "dotted", color = "black", linewidth = 2) +
    ylab(expression(Log[10](Quantity))) +
    xlab(expression(Log[10](Oxygen~diffusivity))) +
    #vylim(0,10) +
    # theme_bw() +
    labs(title="Substrates")
  
  if ("aS" %in% colnames(temporal_results)){
    # transformtion function
    t_func <- function(a) 
      {approx(x = unique(temporal_results$aO), 
              y = unique(temporal_results$aS),
              xout =  a,
              method = "linear", rule = 1)$y # [1:length(temporal_results$aO)] # slice a random 0 element
      }
    
    p_substrates <- p_substrates + scale_x_continuous(expand = c(0,0), 
                                                      sec.axis = sec_axis(trans = . ~ t_func(.),
                                                                          name = expression(Log[10](Sulfide~diffusivity)))
                                                      )
    
    p_organisms <- p_organisms + scale_x_continuous(expand = c(0,0), 
                                                    sec.axis = sec_axis(trans = . ~ t_func(.),
                                                                        name = expression(Log[10](Sulfide~diffusivity)))
                                                    )
  }
  
  
  return (ggpubr::ggarrange(p_organisms, p_substrates, ncol = 1, nrow = 3))
}
