#' Convenience function to plot the dynamics of a model run,
#' with strains within functional groups.
#'
#' @param simulation_result Object returned by the run_simulation function
#' @param every_n Plot data of every other n sample.
#' @return returns the ggplot object of the plot. If it is assigned to a 
#'    variable, the plot needs to be plotted, otherwise it is plotted.
#' 
#' @global a species quantity a functional_group log10_quantity var_type . time
#' 
#' @importFrom dplyr filter mutate row_number case_when
#' @importFrom ggplot2 ggplot aes facet_wrap xlab ylab geom_line scale_colour_manual guides guide_legend
#' @importFrom tidyr gather
#' @importFrom grDevices colorRampPalette
#' @importFrom stringr str_detect
#' @import patchwork
#' 
#' @export
plot_dynamics <- function(simulation_result, every_n = 1) {
  
  colfunc_CB <- grDevices::colorRampPalette(c("#024F17", "#B5FFC9"))
  colfunc_SB <- grDevices::colorRampPalette(c("#7D1402", "#FCBEB3"))
  colfunc_PB <- grDevices::colorRampPalette(c("#6E0172", "#F9AEFC"))
  
  temp <- simulation_result$result %>%
    dplyr::filter(dplyr::row_number() %% every_n == 0 ) %>%
    dplyr::mutate(a = 10^a) %>%
    tidyr::gather(species, quantity, 2:ncol(.)) %>% 
    dplyr::mutate(var_type=ifelse(grepl("B_", species), "Organism", "Substrate"),
           functional_group = dplyr::case_when(str_detect(species, "CB_") ~ "CB",
                                        str_detect(species, "SB_") ~ "SB",
                                        str_detect(species, "PB_") ~ "PB"),
           log10_quantity=log10(quantity))
  
  num_CB_strains <- nrow(simulation_result$strain_parameter$CB)
  num_SB_strains <- nrow(simulation_result$strain_parameter$SB)
  num_PB_strains <- nrow(simulation_result$strain_parameter$PB)
  
  p1 <- temp %>%
    dplyr::filter(functional_group == "CB") %>%
    ggplot2::ggplot(aes(x=time, y=log10_quantity, col=species)) +
    ggplot2::geom_line() +
    ylab('log10(quantity [cells])') +
    xlab('time [hours]') +
    ggplot2::scale_colour_manual(values = colfunc_CB(num_CB_strains)) +
    ggplot2::guides(colour = ggplot2::guide_legend(ncol = 3))
  
  p2 <- temp %>%
    dplyr::filter(functional_group == "SB") %>%
    ggplot2::ggplot(aes(x=time, y=log10_quantity, col=species)) +
    ggplot2::geom_line() +
    ylab('log10(quantity [cells])') +
    xlab('time [hours]') +
    ggplot2::scale_colour_manual(values = colfunc_SB(num_SB_strains))+
    ggplot2::guides(colour = guide_legend(ncol = 3))
  
  p3 <- temp %>%
    dplyr::filter(functional_group == "PB") %>%
    ggplot2::ggplot(aes(x=time, y=log10_quantity, col=species)) +
    ggplot2::geom_line() +
    ylab('log10(quantity [cells])') +
    xlab('time [hours]') +
    ggplot2::scale_colour_manual(values = colfunc_PB(num_PB_strains))+
    ggplot2::guides(colour = guide_legend(ncol = 3))
  
  p4 <- temp %>%
    dplyr::filter(var_type == "Substrate") %>%
    ggplot(aes(x=time, y=log10_quantity, col=species)) +
    ggplot2::geom_line() +
    ggplot2::ylab('log10(quantity [micromoles])') +
    ggplot2::xlab('time [hours]') 
  p4
  
  return(p1 / p2 / p3 / p4)
  
}
