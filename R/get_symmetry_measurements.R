#' Computes measures that make comparisons between collapse and recovery
#' trajectory and between antagonistic environmental variables possible.
#'
#' @param res Results from \code{run_temporal_ssfind()} or from \code{run_temporal_ssfind_symmetric()}
#' @return returns a frame containing symmetry measures for each variable, such as hysteresis area,
#'    shift magnitudes or distance between TP, as well as TP themselfes with their according state.
#'
#' @autoglobal
#'
#' @importFrom dplyr rename mutate select filter slice all_of starts_with
#' @importFrom DescTools AUC
#'
#' @autoglobal
#'
#' @export
get_symmetry_measurements <- function(res) {
  ## check whether bush or symmetry simulation prepare dataframe
  if ("a_O" %in% colnames(res)) {
    res <- res %>%
      rename(aO = a_O) %>%
      mutate(recovery = ifelse(direction == "up", "oxic", "anoxic")) %>%
      select(-direction)
  } else {
    res <- res %>%
      select(-starts_with("PB"), -aS, -SO)
  }

  ## extract species names
  all_species <- colnames(res)[!(colnames(res) %in% c("time", "aO", "recovery"))]

  ## prepare storage df
  measures <- data.frame(
    anox_TP = rep(NA, length(all_species)),
    anox_TPafter = rep(NA, length(all_species)),
    state_anox_TP = rep(NA, length(all_species)),
    state_anox_TPafter = rep(NA, length(all_species)),
    ox_TP = rep(NA, length(all_species)),
    ox_TPafter = rep(NA, length(all_species)),
    state_ox_TP = rep(NA, length(all_species)),
    state_ox_TPafter = rep(NA, length(all_species)),
    hyst_area = rep(NA, length(all_species)),
    hyst_range = rep(NA, length(all_species)),
    abs_shift_recovery = rep(NA, length(all_species)),
    abs_shift_catastrophy = rep(NA, length(all_species))
  )

  rownames(measures) <- all_species

  ## for every species do
  for (i in 1:length(all_species)) {
    ## for every species in res calc sym measures
    for (dir in c("oxic", "anoxic")) {
      ## take local derivative at each point
      # delta y
      dy2 <- res %>%
        filter(recovery == dir) %>%
        select(all_of(all_species[i])) %>%
        slice(2:nrow(.))

      dy1 <- res %>%
        filter(recovery == dir) %>%
        select(all_of(all_species[i])) %>%
        slice(1:nrow(.) - 1)

      # delta x
      dx2 <- res %>%
        filter(recovery == dir) %>%
        select(all_of("aO")) %>%
        slice(2:nrow(.))

      dx1 <- res %>%
        filter(recovery == dir) %>%
        select(all_of("aO")) %>%
        slice(1:nrow(.) - 1)

      # derivative at each point
      df <- (dy2 - dy1) / (dx2 - dx1)

      # store df, x and y in temp df for later filtering
      temp <- data.frame(
        df = df[, all_species[i]],
        aO1 = dx1[, "aO"],
        aO2 = dx2[, "aO"],
        state1 = dy1[, all_species[i]],
        state2 = dy2[, all_species[i]]
      )

      # filter for highest local derivative (= TP), take absolute values to account for negative slopes
      # select all values that have same log magnitude as max, in case shift goes over multiple rows
      i_max <- which(abs(temp$df) == max(abs(temp$df)))
      mask <- which((floor(log10(max(abs(temp$df)))) == floor(log10(abs(temp$df)))) & (sign(temp$df) == sign(temp$df[i_max])))
      if (length(mask) > 3) { # not considered a TP anymore
        mask <- i_max
      }
      temp <- temp[mask, ]
      # print(paste(all_species[i], mask))
      # print

      # print(c(i, dir))
      ## fill sym measures into frame
      if (dir == "oxic") {
        # oxic recovery gives TP of anoxic state
        measures$anox_TP[i] <- temp$aO1[1]
        measures$anox_TPafter[i] <- temp$aO2[nrow(temp)]
        measures$state_anox_TP[i] <- temp$state1[1]
        measures$state_anox_TPafter[i] <- temp$state2[nrow(temp)]
      } else {
        # anoxic recovery gives TP of oxic state
        measures$ox_TP[i] <- temp$aO1[1]
        measures$ox_TPafter[i] <- temp$aO2[nrow(temp)]
        measures$state_ox_TP[i] <- temp$state1[1]
        measures$state_ox_TPafter[i] <- temp$state2[nrow(temp)]
      }
    }
    # rm(dy2, dy1, dx2, dx1, df, temp)

    ## calculate hysteresis area between curves with DescTools package (Area Under Curve)
    # anoxic recovery
    area_anox <- DescTools::AUC(
      x = res %>% filter(recovery == "anoxic") %>% pull("aO"),
      y = res %>% filter(recovery == "anoxic") %>% pull(all_species[i]),
      from = measures[all_species[i], ]$ox_TP, # ox TP is has lower aO value than TP of anoxic state
      to = measures[all_species[i], ]$anox_TP
    )
    # oxic recovery
    area_ox <- DescTools::AUC(
      x = res %>% filter(recovery == "oxic") %>% pull("aO"),
      y = res %>% filter(recovery == "oxic") %>% pull(all_species[i]),
      from = measures[all_species[i], ]$ox_TP, # ox TP is has lower aO value than TP of anoxic state
      to = measures[all_species[i], ]$anox_TP
    )

    measures$hyst_area[i] <- abs(area_anox - area_ox)

    ## hysteresis range: distance between TP
    measures$hyst_range[i] <- measures$anox_TP[i] - measures$ox_TP[i]

    ## extent of the catastrophic shifts
    # shift !TO! the oxic state
    ox_shift <- abs(measures$state_anox_TP[i] - measures$state_anox_TPafter[i])
    # shift !TO! the anoxic state
    anox_shift <- abs(measures$state_ox_TP[i] - measures$state_ox_TPafter[i])

    # if species dominates oxic state
    if (substr(all_species[i], 1, 1) %in% c("C", "O")) {
      measures$abs_shift_recovery[i] <- ox_shift
      measures$abs_shift_catastrophy[i] <- anox_shift
      # if species dominates anoxic
    } else if (substr(all_species[i], 1, 1) %in% c("S")) {
      measures$abs_shift_recovery[i] <- anox_shift
      measures$abs_shift_catastrophy[i] <- ox_shift
      # else species is phosphorus
    } else {
      measures$abs_shift_recovery[i] <- ox_shift
      measures$abs_shift_catastrophy[i] <- anox_shift
    }

    # measures$ox_shift[i]
  }

  # return(measures %>% select(c("anox_TP", "anox_shift", "ox_TP", "anox_shift", "hyst_area", "hyst_range")))
  return(measures)
}
