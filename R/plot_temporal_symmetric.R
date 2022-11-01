#' Plot the temporal dynamics of a model run of a symmetric parameter set
#' 
#' This is a convenience function to plot the dynamics of a model run particularly
#' for a symmetric model
#' with strains within functional groups displayed.
#' @param temporal_results Results from \code{run_temporal_ssfind()}
#' @param zoom If \code{TRUE}, zoommin to an area (only as an example - no real use)
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
sym_plot_temporal_ss <- function(
    temporal_results, 
    zoom = FALSE
){
  
  
  p_organisms <- temporal_results %>%
    select(a_O, direction,
           starts_with("CB"),
           starts_with("SB")) %>%
    gather(key = species, value = Quantity, 3:ncol(.)) %>%
    ggplot() + 
    geom_path(aes(x = a_O, y = log10(Quantity + 1), col = species, linetype = direction), size = 1) + 
    scale_color_manual(values = c("#38761d", "#cc0000" )) + 
    geom_vline(xintercept = log10(0.1), linetype = "dotted", color = "black", size = 2) +
    ylab(expression(Log[10](Abundance+1))) +
    xlab(expression(Log[10](Oxygen~diffusivity))) +
    ylim(0,10) +
    theme_bw() +
    labs(title="Organisms")
  
  p_substrates <- temporal_results %>%
    select(a_O, direction, SR, O, P) %>%
    gather(key = substrate, value = Quantity, 3:ncol(.)) %>%
    ggplot() + 
    geom_path(aes(x = a_O, y = log10(Quantity + 1), col = substrate, linetype = direction), size = 1) + 
    scale_color_manual(values = c("#38761d", "#2986cc", "#cc0000")) +
    geom_vline(xintercept = log10(0.1), linetype = "dotted", color = "black", size = 2) +
    ylab(expression(Log[10](Quantity))) +
    xlab(expression(Log[10](Oxygen~diffusivity))) +
    #vylim(0,10) +
    theme_bw() +
    labs(title="Substrates")
  
  if (zoom == TRUE){
    p_organisms <- p_organisms + xlim(-2, 0)
    p_substrates <- p_substrates + xlim(-2,0)
    # print("zoom true")
  }
  
  
  return (p_organisms / p_substrates)
}
