#' Create variability in strain parameters
#'
#' Add variability as defined in the argument `variability` to the variables as follows:
#'   - `strain_parameter$CB$g_max_CB <- variablility(strain_parameter$CB$g_max_CB, CB_var_gmax)`
#'   - `strain_parameter$CB$h_SR_CB  <- variablility(strain_parameter$CB$h_SR_CB,  CB_var_h   )`
#'   - `strain_parameter$SB$g_max_SB <- variablility(strain_parameter$SB$g_max_SB, SB_var_gmax)`
#'   - `strain_parameter$SB$h_O_SB   <- variablility(strain_parameter$SB$h_O_SB,   SB_var_h   )`
#'   - `strain_parameter$PB$g_max_PB <- variablility(strain_parameter$PB$g_max_PB, PB_var_gmax)`
#'   - `strain_parameter$PB$h_O_PB   <- variablility(strain_parameter$PB$h_O_PB,   PB_var_h   )`
#' @param strain_parameter object of class `strain_parameter`
#' @param CB_var_gmax the argument var for the function `variablility` for the
#'   variable `strain_parameter$CB$g_max_CB`
#' @param CB_var_h the argument var for the function `variablility` for the
#'   variable `strain_parameter$CB$h_SR_CB`
#' @param SB_var_gmax the argument var for the function `variablility` for the
#'   variable `strain_parameter$CB$g_max_SB`
#' @param SB_var_h the argument var for the function `variablility` for the
#'   variable `strain_parameter$CB$h_O_SB`
#' @param PB_var_gmax the argument var for the function `variablility` for the
#'   variable `strain_parameter$CB$g_max_PB`
#' @param PB_var_h the argument var for the function `variablility` for the
#'   variable `strain_parameter$CB$h_O_PB`
#' @param variablility function of which takes two arguments, i.e.
#'   `strain_parameter` and `var` and returns an object of the class `strain
#'   parameter`. The function will be applied to add variability to the above
#'   mentioned variables. Everything else is up to the function.
#'
#' @return the value of strain_parameter with added strain variability
#' @export
#'
#' @md
#' @examples
#' add_strain_var(new_strain_parameter(n_CB = 3, n_PB = 3, n_SB = 3), 2)
add_strain_var <- function(
  strain_parameter,
  CB_var_gmax = 0,
  CB_var_h = 0,
  SB_var_gmax = 0,
  SB_var_h = 0,
  PB_var_gmax = 0,
  PB_var_h = 0,
  variablility = function(strain_parameter, var){ strain_parameter * 2^(seq(-var, var, length = length(strain_parameter))) }
){
  strain_parameter$CB$g_max_CB <- variablility(strain_parameter$CB$g_max_CB, CB_var_gmax)
  strain_parameter$CB$h_SR_CB  <- variablility(strain_parameter$CB$h_SR_CB,  CB_var_h    )
  strain_parameter$SB$g_max_SB <- variablility(strain_parameter$SB$g_max_SB, SB_var_gmax)
  strain_parameter$SB$h_O_SB   <- variablility(strain_parameter$SB$h_O_SB,   SB_var_h     )
  strain_parameter$PB$g_max_PB <- variablility(strain_parameter$PB$g_max_PB, PB_var_gmax)
  strain_parameter$PB$h_O_PB   <- variablility(strain_parameter$PB$h_O_PB,   PB_var_h     )

  return(strain_parameter)
}
