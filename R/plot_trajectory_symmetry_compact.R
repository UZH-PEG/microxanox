#' Visualizes the symmetry of upards and downwards trajectories in the same figure, 
#' symmetry measures of shift are computed by the function \code{get_symmetry_measurements()}
#'
#' @param res Results from \code{run_temporal_ssfind()} or from \code{run_temporal_ssfind_symmetric()}
#' @param typ Type of environmental variable. Either `substrate` or `bacteria`.
#' @param plot_log10 Logical. If \code{TRUE}, logarithmic plot of the data is done.
#' @return ggplot object, with antagonistic shifts of related trajectory visualized as arrows.
#'
#' @autoglobal
#'
#' @importFrom dplyr rename mutate select filter recode starts_with
#' @importFrom tidyr gather spread
#' @importFrom ggplot2 geom_path geom_point geom_segment scale_color_manual labs arrow scale_x_continuous sec_axis unit
#'
#' @export

plot_trajectory_symmetry_compact <- function (res, typ = "substrate", plot_log10 = FALSE) 
{
  measures <- get_symmetry_measurements(res)
  if ("a_O" %in% colnames(res)) {
    res <- res %>% rename(aO = a_O) %>% mutate(recovery = ifelse(direction == 
                                                                   "up", "oxic", "anoxic")) %>% select(-direction)
    sym.flag <- F
  } else {
    res <- res %>% select(-starts_with("PB"), -SO)
    sym.flag <- T
  }
  if (!(typ %in% c("bacteria", "substrate"))) {
    stop("Type must be either 'bacteria' 'or substrate'")
  }
  measures <- measures %>% mutate(species = rownames(.)) %>% 
    gather(key = "measure", value = "value", 
           -species) %>% mutate(type = ifelse(species %in% c("SO", 
                                                             "SR", "P", "O"), "substrate", 
                                              "bacteria")) %>% filter(type == typ, !(species %in% 
                                                                                       c("P", "SO"))) %>% spread(key = measure, 
                                                                                                                 value = value)
  
  
  res_ox <- res %>% {
    if (sym.flag) 
      select(., starts_with("CB"), "O", 
             "aO", "aS", "recovery")
    else select(., starts_with("CB"), "O", 
                "aO", "recovery")
  } %>% {
    if (sym.flag) 
      gather(data = ., key = "species", value = "state", 
             -c(aO, aS, recovery))
    else gather(data = ., key = "species", value = "state", 
                -c(aO, recovery))
  } %>% mutate(type = ifelse(species == "O", "substrate", 
                             "bacteria"))
  res_anox <- res %>% {
    if (sym.flag) 
      select(., starts_with("SB"), "SR", 
             "aO", "aS", "recovery")
    else select(., starts_with("SB"), "SR", 
                "aO", "recovery")
  } %>% {
    if (sym.flag) 
      gather(data = ., key = "species", value = "state", 
             -c(aO, aS, recovery))
    else gather(data = ., key = "species", value = "state", 
                -c(aO, recovery))
  } %>% mutate(type = ifelse(species == "SR", "substrate", 
                             "bacteria"))
  plt.seg <- data.frame(species = c(measures$species,rev(measures$species)) , 
                        x = c(measures$anox_TP[1], measures$ox_TP[2], measures$anox_TP[2], measures$ox_TP[1]), 
                        y = c(measures$state_anox_TP[1], measures$state_ox_TP[2], measures$state_anox_TP[2], measures$state_ox_TP[1]), 
                        xend = c(measures$anox_TPafter[1], measures$ox_TPafter[2], measures$anox_TPafter[2], measures$ox_TPafter[1]),  
                        yend = c(measures$state_anox_TPafter[1], measures$state_ox_TPafter[2], measures$state_anox_TPafter[2],measures$state_ox_TPafter[1]))
  
  plt.traj <- rbind(res_ox, res_anox)
  na_mask <- which((plt.traj$recovery == "anoxic" & plt.traj$aO <= 
                      measures$ox_TP & plt.traj$aO >= measures$ox_TPafter) | 
                     (plt.traj$recovery == "oxic" & plt.traj$aO >= measures$anox_TP & 
                        plt.traj$aO < measures$anox_TPafter))
  plt.traj[na_mask + 1, "state"] <- NA
  if (plot_log10) {
    plt.traj$state <- log10(abs(plt.traj$state))
    plt.seg[, c("y", "yend")] <- log10(plt.seg[, 
                                               c("y", "yend")])
  }
  plt.seg <- plt.seg %>% mutate(plot_species = recode(species, 
                                                      O = "Oxygen", CB_1 = "Cyanobacteria", SR = "Sulfide", 
                                                      SB_1 = "Sulfur-reducing bacteria"))
  plt.traj <- plt.traj %>% mutate(plot_species = recode(species, 
                                                        O = "Oxygen", CB_1 = "Cyanobacteria", SR = "Sulfide", 
                                                        SB_1 = "Sulfur-reducing bacteria"))
  
  ### change here ###
  p <- ggplot(data = plt.traj %>% filter(type == typ)) + geom_segment(data = plt.seg, 
                                                                      mapping = aes(x = x, y = y, xend = xend, yend = yend, 
                                                                                    color = plot_species), lineend = "round", linejoin = "round", 
                                                                      linewidth = 0.5, linetype = "dotted", arrow = arrow(length = unit(0.3, 
                                                                                                                                        "cm"))) + geom_path(mapping = aes(x = aO, y = state, 
                                                                                                                                                                          color = plot_species)) + scale_color_manual(values = c("#e85050", 
                                                                                                                                                                                                                                 "#5da1df")) + 
    labs(x = expression(Log[10](Oxygen ~ diffusivity) ~ "[" * 
                          hr^-1 * "]"), y = expression(Log[10](Concentration) ~ 
                                                         "[mM]"), color = "type")
  
  if (sym.flag) {
    if (length(unique(plt.traj$aS)) > 1) {
      t_func <- function(a) {
        approx(x = unique(plt.traj$aO), y = unique(plt.traj$aS), 
               xout = a, method = "linear", rule = 1)$y
      }
      p <- p + scale_x_continuous(expand = c(0, 0), sec.axis = sec_axis(trans = . ~ 
                                                                          t_func(.), name = expression(Log[10](Sulfide ~ 
                                                                                                                 Diffusivity) ~ "[" * hr^-1 * "]")))
    }
  }
  return(p)
}