#' Convenience function to plot the dynamics of a model run,
#' with strains within functional groups
#'
#' @param simulation_result Object returned by the run_simulation function.
#' @param every_n Plot data of every other n sample.
#' @return Nothing.
#' @export
plot_dynamics_strains <- function(simulation_result, every_n = 1) {
  
  simulation_result$result %>%
    filter(row_number() %% every_n == 0) %>%
    mutate(a = 10^a) %>%
    gather(species, quantity, 2:ncol(.)) %>% 
    mutate(var_type=ifelse(grepl("B_", species), "Organism", "Substrate"), 
           trans_quantity=log10(quantity)) %>% 
    ggplot(aes(x=time, y=trans_quantity, col=species)) +
    facet_wrap(~var_type, scales = "free", ncol = 1) + 
    geom_line() +
    ylab('log(quantity)') +
    xlab('time [hours]') +
    labs(color = "Organism/Substrate")
  
  
  
  # sim_res$result %>%
  #   filter(row_number() %% every_n == 0) %>%
  #   gather(species, quantity, 2:ncol(.)) %>% 
  #   filter(species!='a') %>%
  #   mutate(var_type=ifelse(str_sub(species, 1, 1)=="N", "Organism", "Substrate"),
  #          trans_quantity=log10(quantity)) %>%
  #   ggplot(aes(x=time, y=trans_quantity, col=species)) +
  #   ylab('log(quantity)') +
  #   facet_wrap(~var_type, scales = "free", ncol = 1) + #create one plot for organisms and one for substrate
  #   geom_line()+
  #   labs(color = "Organism/Substrate")
  
}
