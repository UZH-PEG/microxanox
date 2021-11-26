#' A function that will add variation among the strains within a functional group.
#' Variation is added to to the maximum growth rate and the inhibition strength.
#'
#' @param An object returned by the `new_strain_parameter function`. Contains parameter values and starting abundance of strains and other state variables.
#' @param CB_var_gmax Amount of variability added to the g_max_CB parameter
#' @param CB_var_h  Amount of variability added to the h_SR_CB parameter
#' @param SB_var_gmax  Amount of variability added to the g_max_SB parameter
#' @param SB_var_h  Amount of variability added to the h_O_SB parameter
#' @param PB_var_gmax  Amount of variability added to the g_max_PB parameter
#' @param PB_var_h  Amount of variability added to the h_O_PB parameter
#' @param method Method used to add strain variation.
#'
#' @return
#' @export
#'
#' @examples
add_strain_var <- function(
  x,
  CB_var_gmax = 0, 
  CB_var_h = 0,
  SB_var_gmax = 0, 
  SB_var_h = 0,
  PB_var_gmax = 0, 
  PB_var_h = 0,
  method = "even_v1.0"
)
  {
  
  even_v1.0 <- function(x,
                        var) {
    x * 2^(seq(-var, var, length = length(x)))
  }
  
  switch (method,
          "even_v1.0" = {
            x$CB$g_max_CB <- even_v1.0(x$CB$g_max_CB, CB_var_gmax)
            x$CB$h_SR_CB  <- even_v1.0(x$CB$h_SR_CB, CB_var_h    )
            x$SB$g_max_SB <- even_v1.0(x$SB$g_max_SB, SB_var_gmax)
            x$SB$h_O_SB   <- even_v1.0(x$SB$h_O_SB ,SB_var_h     )
            x$PB$g_max_PB <- even_v1.0(x$PB$g_max_PB, PB_var_gmax)
            x$PB$h_O_PB   <- even_v1.0(x$PB$h_O_PB, PB_var_h     )
          },
          stop("Method '", method, "' not implemented!")
  )
  
  # new_x$CB$g_max_CB <- x$CB$g_max_CB * 2^(seq(-CB_var_gmax, CB_var_gmax, length = length(new_x$CB$g_max_CB)))
  # new_x$CB$h_SR_CB  <- x$CB$h_SR_CB  * 2^(seq(-CB_var_h,    CB_var_h,    length = length(new_x$CB$h_SR_CB) ))
  # new_x$SB$g_max_SB <- x$SB$g_max_SB * 2^(seq(-SB_var_gmax, SB_var_gmax, length = length(new_x$SB$g_max_SB)))
  # new_x$SB$h_O_SB   <- x$SB$h_O_SB   * 2^(seq(-SB_var_h,    SB_var_h,    length = length(new_x$SB$h_O_SB)  ))
  # new_x$PB$g_max_PB <- x$PB$g_max_PB * 2^(seq(-PB_var_gmax, PB_var_gmax, length = length(new_x$PB$g_max_PB)))
  # new_x$PB$h_O_PB   <- x$PB$h_O_PB   * 2^(seq(-PB_var_h,    PB_var_h,    length = length(new_x$PB$h_O_PB)  ))
  return(x)
}

# 
# plot_and_save <- function(CB_var_gmax, CB_var_h,
#                           SB_var_gmax, SB_var_h,
#                           PB_var_gmax, PB_var_h,
#                           sim_res,
#                           file_path_and_prefix) {
#   plot_dynamics(sim_res)
#   ggsave(paste0(
#     file_path_and_prefix,
#     "-CB_", round(CB_var_gmax, 3), "_", round(CB_var_h, 3),
#     "-SB_", round(SB_var_gmax, 3), "_", round(SB_var_h, 3),
#     "-PB_", round(PB_var_gmax, 3), "_", round(PB_var_h, 3),
#     ".pdf"
#   ),
#   width = 10
#   )
#   NULL
# }
