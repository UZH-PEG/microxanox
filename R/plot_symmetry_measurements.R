#' Visualizes the symmetry measures obtained by the function \code{get_symmetry_measures()}
#'
#' @param res Results from \code{run_temporal_ssfind()} or from \code{run_temporal_ssfind_symmetric()}
#' @param species Environmental varibale of which the symmetry measures shoudl be plotted
#' @return ggplot object, with shifts visualized as arrows and hysteresis area ribbon
#'
#' @autoglobal
#'
#' @importFrom dplyr rename mutate select filter starts_with
#' @importFrom ggplot2 geom_path geom_point geom_segment geom_ribbon scale_color_manual labs arrow scale_fill_manual unit
#' @importFrom stats median
#'
#' @export
plot_symmetry_measures <- function(res,
                                   species) {
  measures <- get_symmetry_measurements(res)
  ## check whether bush or symmetry simulation prepare dataframe scale_fill_manual scale_color_manual labs
  if ("a_O" %in% colnames(res)) {
    res <- res %>%
      rename(aO = a_O) %>%
      mutate(recovery = ifelse(direction == "up", "oxic", "anoxic")) %>%
      select(-direction)
  } else {
    res <- res %>%
      select(-starts_with("PB"), -aS, -SO)
  }
  if (!(species %in% colnames(res))) {
    stop(paste("Please select a species of", paste(colnames(res), collapse = ", "), "."))
  }
  # speciesmeasures <- gather(measures[species,], key = "measure", value = "value")
  ## data wrangling to plotting-mature frame with xy coords in seperate columns

  plot_df <- data.frame(
    aO = as.numeric(select(measures[species, ], c(1, 2, 5, 6))),
    state = as.numeric(select(measures[species, ], c(3, 4, 7, 8))),
    measure = as.character(colnames(measures)[c(1, 2, 5, 6)])
  )
  ribbon_temp <- res %>%
    filter((aO >= median(measures$ox_TP)), (aO <= median(measures$anox_TP))) %>%
    select(c(species, recovery, aO))
  ribbon_df <- data.frame(
    oxic = rev(ribbon_temp %>% filter(recovery == "oxic") %>% pull(species)),
    anoxic = ribbon_temp %>% filter(recovery == "anoxic") %>% pull(species),
    aO = ribbon_temp %>% filter(recovery == "anoxic") %>% pull(aO)
  )

  p <- ggplot() +
    # plot the data
    geom_path(mapping = aes(x = res$aO, , y = res[, species], linetype = res$recovery)) +
    # plot the tipping points
    geom_point(data = slice(plot_df, c(1, 3)), mapping = aes(x = aO, y = state, color = measure)) +
    # plot extent of shifts
    geom_segment(
      data = slice(plot_df, c(1, 2)),
      mapping = aes(x = aO[1], y = state[1], xend = aO[2], yend = state[2], group = "recovery"),
      color = "#5da1df",
      lineend = "round", linejoin = "round", linewidth = 0.5,
      arrow = arrow(length = unit(0.5, "cm"))
    ) +
    geom_segment(
      data = slice(plot_df, c(3, 4)),
      mapping = aes(x = aO[1], y = state[1], xend = aO[2], yend = state[2], group = "collapse"),
      color = "#e85050",
      lineend = "round", linejoin = "round", linewidth = 0.5,
      arrow = arrow(length = unit(0.5, "cm"))
    ) +
    geom_ribbon(
      data = ribbon_df,
      mapping = aes(x = aO, ymin = oxic, ymax = anoxic, fill = "hysteresis area"), alpha = 0.3
    ) +
    scale_fill_manual(values = c("grey")) +
    scale_color_manual(values = c("#e85050", "#5da1df")) +
    labs(x = "aO", y = species, fill = "measures", color = "measures", linetype = "recovery")

  return(p)
}
