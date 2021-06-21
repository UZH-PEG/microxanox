test_that("multiplication works", {
expect_snapshot_value(
  x = {
    # default_event_definition <- event_definition_1
    # default_noise_sigma <- 0
    # ssfind_minimum_abundances <- rep(0, 3)
    # names(ssfind_minimum_abundances) <- c("CB", "PB", "SB")
    # ssfind_simulation_duration <- 50000
    # ssfind_simulation_sampling_interval <- ssfind_simulation_duration
    # ssfind_event_interval <- ssfind_simulation_duration
    # ssfind_parameters <- new_starter(n_CB = 1,
    #                                  n_PB = 1,
    #                                  n_SB = 1,
    #                                  values_initial_state = "bush_ssfig3")
    # 
    # grid_num_a <- 100 ## number of a_0 values
    # a_Os <- 10^seq(-6, -2, length=grid_num_a) ## sequence of a_0 values
    # grid_num_N <- 2 ## number of N values
    # initial_CBs <- 10^seq(0, 10, length=grid_num_N) ## sequence of N values
    # initial_PBs <- 1e8 ## not varied
    # initial_SBs <- 1e8 ## not varied
    # ## next line creates all possible combinations
    # expt <- expand.grid(N_CB = initial_CBs,
    #                     N_PB = initial_PBs,
    #                     N_SB = initial_SBs,
    #                     a_O = a_Os)
    # system.time({x_0 <- ss_by_a_N(expt, ssfind_parameters, mc.cores = 0)})
    # system.time({x_4 <- ss_by_a_N(expt, ssfind_parameters, mc.cores = 4)})
  },
  cran = FALSE
)
})
