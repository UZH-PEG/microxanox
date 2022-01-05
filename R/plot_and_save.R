#' TODO
#'
#' TODO
#' @param CB_var_gmax TODO
#' @param CB_var_h TODO
#' @param SB_var_gmax TODO
#' @param SB_var_h TODO
#' @param PB_var_gmax TODO
#' @param PB_var_h TODO
#' @param sim_res TODO
#' @param file_path_and_prefix TODO
#'
#' @return NULL
#'
#' @examples
plot_and_save <- function(CB_var_gmax, CB_var_h,
                          SB_var_gmax, SB_var_h,
                          PB_var_gmax, PB_var_h,
                          sim_res,
                          file_path_and_prefix) {
  plot_dynamics(sim_res)
  ggplot2::ggsave(paste0(
    file_path_and_prefix,
    "-CB_", round(CB_var_gmax, 3), "_", round(CB_var_h, 3),
    "-SB_", round(SB_var_gmax, 3), "_", round(SB_var_h, 3),
    "-PB_", round(PB_var_gmax, 3), "_", round(PB_var_h, 3),
    ".pdf"
  ),
  width = 10
  )
  NULL
}
