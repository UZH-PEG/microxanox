#' Plot the dynamics of a model run of a symmetric parameter set
#'
#' This is a convenience function to plot the dynamics of a model run particularly
#' for a symmetric model with strains within functional groups displayed.
#' @param simulation_result Object returned by the run_simulation function
#' @param every_n Plot data of every other n sample.
#' @param plot_a if \code{TRUE}, diffusivities will be plotted in lower pane, default is \code{FALSE}.
#' @return returns the ggplot object of the plot. If it is assigned to a
#'    variable, the plot needs to be plotted, otherwise it is plotted.
#'
#' @autoglobal
#'
#' @importFrom dplyr filter mutate row_number case_when
#' @importFrom ggplot2 ggplot aes facet_wrap xlab ylab geom_line scale_colour_manual guides guide_legend ylim
#' @importFrom tidyr gather
#' @importFrom grDevices colorRampPalette
#' @importFrom stringr str_detect
#' @importFrom ggpubr ggarrange
#' @import patchwork
#'
#' @export
plot_dynamics_symmetric <- function(
    simulation_result,
    every_n = 1,
    plot_a = FALSE) {
  ## define colours
  colfunc_CB <- grDevices::colorRampPalette(c("#024F17", "#B5FFC9"))
  colfunc_SB <- grDevices::colorRampPalette(c("#7D1402", "#FCBEB3"))
  colfunc_PB <- grDevices::colorRampPalette(c("#6E0172", "#F9AEFC"))

  col_SR <- "#ea9999"
  col_O <- "#6edd3d"
  col_aO <- "#6ba405"
  col_aS <- "#6b3205"
  col_P <- "#6fa8dc"

  ## data wrangling
  temp <- simulation_result$result %>%
    dplyr::filter(dplyr::row_number() %% every_n == 0) %>%
    dplyr::mutate(aO = 10^aO, aS = 10^aS) %>%
    tidyr::gather(species, quantity, 2:ncol(.)) %>%
    dplyr::mutate(
      var_type = ifelse(grepl("B_", species), "Organism", "Substrate"),
      functional_group = dplyr::case_when(
        str_detect(species, "CB_") ~ "CB",
        str_detect(species, "SB_") ~ "SB",
        str_detect(species, "PB_") ~ "PB"
      ),
      log10_quantity = log10(abs(quantity))
    ) %>%
    dplyr::mutate(microbe = functional_group)

  temp_S <- temp %>%
    dplyr::filter(var_type == "Substrate") %>%
    dplyr::mutate(substrate = species)

  if (plot_a == FALSE) {
    temp_S <- temp_S %>%
      filter(species != "aO", species != "aS")
  }

  num_CB_strains <- nrow(simulation_result$strain_parameter$CB)
  num_SB_strains <- nrow(simulation_result$strain_parameter$SB)
  num_PB_strains <- nrow(simulation_result$strain_parameter$PB)

  # plotting
  p1 <- temp %>%
    dplyr::filter(functional_group == "CB") %>%
    mutate(species = factor(species, levels = unique(species))) %>%
    ggplot2::ggplot(aes(x = time, y = log10_quantity, col = microbe)) +
    ggplot2::geom_line() +
    # ylab('log10(quantity)') +
    ylab("log10(abundance)\n[cells / L]") +
    # ylim(0,10) +
    # xlab('time [hours]') +
    xlab(" ") +
    ggplot2::scale_colour_manual(values = colfunc_CB(num_CB_strains)) +
    ggplot2::guides(colour = ggplot2::guide_legend(ncol = 3))

  p2 <- temp %>%
    dplyr::filter(functional_group == "SB") %>%
    mutate(species = factor(species, levels = unique(species))) %>%
    ggplot2::ggplot(aes(x = time, y = log10_quantity, col = microbe)) +
    ggplot2::geom_line() +
    ylab("log10(abundance)\n[cells / L]") +
    # ylim(0,10) +
    # xlab('time [hours]') +
    xlab(" ") +
    ggplot2::scale_colour_manual(values = colfunc_SB(num_SB_strains)) +
    ggplot2::guides(colour = guide_legend(ncol = 3))

  p4 <- temp_S %>%
    dplyr::filter(species != "SO") %>%
    ggplot(aes(x = time, y = log10_quantity, col = substrate)) +
    ggplot2::geom_line() +
    ggplot2::ylab("log10(concentration)\n[\u00b5M]") +
    ggplot2::xlab("time [hours]")

  if (plot_a == FALSE) {
    p4 <- p4 + scale_color_manual(values = c(col_O, col_P, col_SR))
  } else {
    p4 <- p4 + scale_color_manual(values = c(col_aO, col_aS, col_O, col_P, col_SR))
  }



  return(p1 / p2 / p4)
}
