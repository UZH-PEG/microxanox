#' Convenience function to plot the dynamics of a model run,
#' with strains within functional groups.
#'
#' @param simulation_result Object returned by the run_simulation function
#' @param every_n Plot data of every other n sample.
#' @return Nothing.
#' 
#' @importFrom stats filter
#' @importFrom dplyr mutate
#' @importFrom ggplot2 ggplot aes facet_wrap xlab ylab
#' 
#' @export
plot_dynamics <- function(simulation_result, every_n = 1) {
  
  colfunc_CB <- colorRampPalette(c("#024F17", "#B5FFC9"))
  colfunc_SB <- colorRampPalette(c("#7D1402", "#FCBEB3"))
  colfunc_PB <- colorRampPalette(c("#6E0172", "#F9AEFC"))
  
  temp <- simulation_result$result %>%
    dplyr::filter(row_number() %% every_n == 0 ) %>%
    mutate(a = 10^a) %>%
    gather(species, quantity, 2:ncol(.)) %>% 
    mutate(var_type=ifelse(grepl("B_", species), "Organism", "Substrate"),
           functional_group = case_when(str_detect(species, "CB_") ~ "CB",
                                        str_detect(species, "SB_") ~ "SB",
                                        str_detect(species, "PB_") ~ "PB"),
           log10_quantity=log10(quantity))
  
  num_CB_strains <- nrow(simulation_result$parameter_values$CB)
  num_SB_strains <- nrow(simulation_result$parameter_values$SB)
  num_PB_strains <- nrow(simulation_result$parameter_values$PB)
  
  p1 <- temp %>%
    dplyr::filter(functional_group == "CB") %>%
    ggplot(aes(x=time, y=log10_quantity, col=species)) +
    geom_line() +
    ylab('log10(quantity [cells])') +
    xlab('time [hours]') +
    scale_colour_manual(values = colfunc_CB(num_CB_strains)) +
    guides(colour = guide_legend(ncol = 3))
  
  p2 <- temp %>%
    dplyr::filter(functional_group == "SB") %>%
    ggplot(aes(x=time, y=log10_quantity, col=species)) +
    geom_line() +
    ylab('log10(quantity [cells])') +
    xlab('time [hours]') +
    scale_colour_manual(values = colfunc_SB(num_SB_strains))+
    guides(colour = guide_legend(ncol = 3))
  
  p3 <- temp %>%
    dplyr::filter(functional_group == "PB") %>%
    ggplot(aes(x=time, y=log10_quantity, col=species)) +
    geom_line() +
    ylab('log10(quantity [cells])') +
    xlab('time [hours]') +
    scale_colour_manual(values = colfunc_PB(num_PB_strains))+
    guides(colour = guide_legend(ncol = 3))
  
  p4 <- temp %>%
    dplyr::filter(var_type == "Substrate") %>%
    ggplot(aes(x=time, y=log10_quantity, col=species)) +
    geom_line() +
    ylab('log10(quantity [micromoles])') +
    xlab('time [hours]') 
  p4
  
  p1 / p2 / p3 / p4
  
}
