## ----setup, output = FALSE, message = FALSE, echo = FALSE---------------------

knitr::opts_chunk$set(echo = TRUE,
                      cache = FALSE,
                      fig.align = "centre",
                      fig.width = 7,
                      fig.height = 4)


library(tidyverse)
library(deSolve)
library(rootSolve)
library(here)
#if (!require("microxanoxBeta")) {
  devtools::load_all(here::here())
#}
library(patchwork)

## Set random number generator seed
## Is redundant if there are no stochastic components in the model
set.seed(13)

## should some of the more intense simulations be run...
run_steadystate_sims <- FALSE
options(mc.cores=8)

## -----------------------------------------------------------------------------
ma <- rep(1e2, 3)
names(ma) <- c("CB", "PB", "SB")
parameter <- new_runsim_parameter(
  dynamic_model = bushplus_dynamic_model,
  strain_parameter = new_strain_parameter(),
  ## no default_initial_state
  sim_duration = 2000,
  sim_sample_interval = 1,
  log10a_series = c(
    log10(new_strain_parameter()$a_O),
    log10(new_strain_parameter()$a_O)
  ),
  event_definition = event_definition_1,
  event_interval = 10,
  noise_sigma = 0,
  minimum_abundances = ma
)

rm(ma)

## -----------------------------------------------------------------------------
parameter$strain_parameter$initial_state  <-  new_initial_state(values = "bush_anoxic_fig2ab")
sim_res <- run_simulation(parameter)
plot_dynamics(simulation_result = sim_res)

## -----------------------------------------------------------------------------
parameter$strain_parameter$initial_state = new_initial_state(values = "bush_oxic_fig2cd")
sim_res <- run_simulation(parameter)
plot_dynamics(sim_res)
##ggsave("high_CB.png")

## ----echo = FALSE, sim_ss_CB_SB_PB1, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/ss_CB_SB_PB.RDS")----
#  
#  grid_num_a <- 100
#  a_Os <- 10^seq(-6, -2, length=grid_num_a)
#  grid_num_N <- 2
#  initial_CBs <- 10^seq(0, 10, length=grid_num_N)
#  initial_PBs <- 1e8
#  initial_SBs <- 1e8
#  ss_expt <- expand.grid(N_CB = initial_CBs,
#                      N_PB = initial_PBs,
#                      N_SB = initial_SBs,
#                      a_O = a_Os)
#  
#  ma <- rep(0, 3)
#  names(ma) <- c("CB", "PB", "SB")
#  
#  parameter <- new_ss_by_a_N_parameter(
#    dynamic_model = bushplus_dynamic_model,
#    strain_parameter = new_strain_parameter(n_CB = 1,
#                                   n_PB = 1,
#                                   n_SB = 1,
#                                   values_initial_state = "bush_ssfig3"),
#    sim_duration = 50000,
#    sim_sample_interval = 50000,
#    event_definition = event_definition_1,
#    event_interval = 50000,
#    ss_expt = ss_expt,
#    noise_sigma = 0,
#    minimum_abundances = ma
#  )
#  rm(grid_num_a, a_Os, grid_num_N, initial_CBs, initial_PBs, initial_SBs, ma, ss_expt)
#  
#  sim_res <- ss_by_a_N(parameter)
#  saveRDS(sim_res, file = "data/partial_reproduction/ss_CB_SB_PB.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
ss_CB_SB_PB <- readRDS(file = "data/partial_reproduction/ss_CB_SB_PB.RDS")

## ----echo = FALSE-------------------------------------------------------------
p1 <- ss_CB_SB_PB$result %>%
  mutate(direction = ifelse(initial_N_CB == 1, "up", "down")) %>%
  select(a, direction,
         starts_with("CB"),
         starts_with("PB"),
         starts_with("SB"))  %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction),
            size=0.8) +
  ylab(expression(Log[10](Abundance+1))) +
  xlab(expression(Log[10](Oxygen~diffusivity))) +
  ylim(0,10) +
  #theme(plot.title=element_text(size=10, hjust=0.5)) +
  labs(title="Organisms")
##ggsave("figures/CB_SB_PB.png", width = 3, height = 2)

p2 <- ss_CB_SB_PB$result %>%
  mutate(direction = ifelse(initial_N_CB == 1, "up", "down"))%>%
  select(a, direction, SO, SR, O, P) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction)) +
  labs(title="Substrates")


p1 / p2


## ----sim_lhl_with_defaults, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/lhl_with_defaults.RDS")----
#  
#  ## low-high-low oxgygen diffusivity
#  lhl_log10a_series <- c(-8, -8, -2, -2, -2, -2, -2, -8, -8)
#  
#  ma <- rep(1e2, 3)
#  names(ma) <- c("CB", "PB", "SB")
#  
#  parameter <- new_runsim_parameter(
#    dynamic_model = bushplus_dynamic_model,
#    strain_parameter = new_strain_parameter(values_initial_state ="bush_anoxic_fig2ab"),
#  #   initial_state = new_initial_state(values = "bush_anoxic_fig2ab"),
#  #   strain_parameter = new_strain_parameter(),
#    ## no default_initial_state
#    sim_duration = 5000,
#    sim_sample_interval = 10,
#    log10a_series = lhl_log10a_series,
#    event_definition = event_definition_1,
#    event_interval = 100,
#    noise_sigma = 0,
#    minimum_abundances = ma
#  )
#  
#  rm(ma, lhl_log10a_series)
#  
#  ## run simulation
#  
#  sim_res <- run_simulation(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/lhl_with_defaults.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
lhl_with_defaults <- readRDS("data/partial_reproduction/lhl_with_defaults.RDS")

## -----------------------------------------------------------------------------
plot_dynamics(lhl_with_defaults)

## ----eval = FALSE, echo = FALSE-----------------------------------------------
#  lhl_with_defaults$result %>%
#    dplyr::filter(between(time, 1000, 73000)) %>%
#    ggplot() +
#    geom_path(aes(x=a, y=log10(O)),
#              arrow = arrow(type = "open", angle = 30, length = unit(0.1, "inches")))

## ----sim_hlh_with_defaults, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/hlh_with_defaults.RDS")----
#  hlh_log10a_series <- c(-2, -2, -10, -14, -18, -22, -2, -2, -2)
#  
#  ma <- rep(1e2, 3)
#  names(ma) <- c("CB", "PB", "SB")
#  
#  parameter <- new_runsim_parameter(
#    dynamic_model = bushplus_dynamic_model,
#    strain_parameter = new_strain_parameter(values_initial_state = "bush_oxic_fig2cd"),
#  #  initial_state = new_initial_state(values = "bush_oxic_fig2cd"),
#  #   strain_parameter = new_strain_parameter(),
#    ## no default_initial_state
#    sim_duration = 50000,
#    sim_sample_interval = 10,
#    log10a_series = hlh_log10a_series,
#    event_definition = event_definition_1,
#    event_interval = 100,
#    noise_sigma = 0,
#    minimum_abundances = ma
#  )
#  
#  rm(ma, hlh_log10a_series)
#  
#  
#  simulation_duration <- 50000
#  
#  ## low-high-low oxgygen diffusivity
#  
#  ## run simulation
#  sim_res <- run_simulation(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/hlh_with_defaults.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
hlh_with_defaults <- readRDS("data/partial_reproduction/hlh_with_defaults.RDS")

## -----------------------------------------------------------------------------
plot_dynamics(hlh_with_defaults)

## ----eval = FALSE, echo = FALSE-----------------------------------------------
#  hlh_with_defaults$result %>%
#    dplyr::filter(between(time, 1000, 100000)) %>%
#    ggplot() +
#    geom_path(aes(x=a, y=log10(O)),
#              arrow = arrow(type = "open", angle = 30, length = unit(0.1, "inches")))

## -----------------------------------------------------------------------------
ma <- rep(0, 3)
names(ma) <- c("CB", "PB", "SB")

parameter <- new_ss_by_a_N_parameter(
  dynamic_model = bushplus_dynamic_model,
  strain_parameter = new_strain_parameter(
    n_CB = 1,
    n_PB = 1,
    n_SB = 1,
    values_initial_state = "bush_ssfig3"
  ),
  sim_duration = 50000,
  sim_sample_interval = 50000,
  event_definition = event_definition_1,
  event_interval = 50000,
  ss_expt = NA,
  noise_sigma = 0,
  minimum_abundances = ma
)

rm(ma)

## ----sim_ss_no_biology, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/ss_no_biology.RDS")----
#  grid_num_a <- 100
#  grid_num_N <- 2
#  
#  initial_CBs <- 0
#  initial_PBs <- 0
#  initial_SBs <- 0
#  a_Os <- 10^seq(-6, -2, length=grid_num_a)
#  expt <- expand.grid(N_CB = initial_CBs,
#                      N_PB = initial_PBs,
#                      N_SB = initial_SBs,
#                      a_O = a_Os)
#  parameter$ss_expt <- expt
#  rm(grid_num_a, grid_num_N, initial_CBs, initial_PBs, initial_SBs, a_Os, expt)
#  
#  sim_res <- ss_by_a_N(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/ss_no_biology.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
ss_no_biology <- readRDS("data/partial_reproduction/ss_no_biology.RDS")

## ----echo = FALSE-------------------------------------------------------------
ss_no_biology$result %>%
  select(a,
         starts_with("CB"),
         starts_with("PB"),
         starts_with("SB")) %>%
  gather(key = Species, value=Quantity, 2:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species))

## ----echo = FALSE-------------------------------------------------------------
ss_no_biology$result %>%
  select(a, SO, SR, O, P) %>%
  gather(key = Species, value=Quantity, 2:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species))

## ----sim_ss_only_CB, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/ss_only_CB.RDS")----
#  grid_num_a <- 100
#  grid_num_N <- 2
#  
#  initial_CBs <- 10^seq(0, 10, length=grid_num_N)
#  initial_PBs <- 0
#  initial_SBs <- 0
#  a_Os <- 10^seq(-6, -2, length=grid_num_a)
#  expt <- expand.grid(N_CB = initial_CBs,
#                      N_PB = initial_PBs,
#                      N_SB = initial_SBs,
#                      a_O = a_Os)
#  parameter$ss_expt <- expt
#  rm(grid_num_a, grid_num_N, initial_CBs, initial_PBs, initial_SBs, a_Os, expt)
#  
#  sim_res <- ss_by_a_N(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/ss_only_CB.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
ss_only_CB <- readRDS("data/partial_reproduction/ss_only_CB.RDS")

## ----echo = FALSE-------------------------------------------------------------
tempx1 <- ss_only_CB$result %>%
  select(a,
         starts_with("CB"),
         starts_with("PB"),
         starts_with("SB")) %>%
  gather(key = Species, value=Quantity, 2:ncol(.))

tempx1 %>%
  ggplot(aes(x = a, y = log10(Quantity +1), col = Species)) +
  geom_path(size=0.8) +
  ylab(expression(Log[10](Abundance+1))) +
  xlab(expression(Log[10](Oxygen~diffusivity))) +
  #theme_light() +
  ylim(0,10) +
  #geom_path(data = filter(tempx1, Species == "PB"),
  #          aes(y=0.2), size = 0.8) +
  theme(plot.title=element_text(size=10, hjust=0.5)) +
  labs(title="Only CB")

##ggsave("figures/CB.png", width = 3, height = 2)

## ----echo = FALSE-------------------------------------------------------------
ss_only_CB$result %>%
  select(a, SO, SR, O, P) %>%
  gather(key = Species, value=Quantity, 2:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species))

## ----sim_ss_only_SB, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/ss_only_SB.RDS")----
#  grid_num_a <- 100
#  grid_num_N <- 2
#  
#  initial_CBs <- 0  # this one is varied
#  initial_PBs <- 0
#  initial_SBs <- 10^seq(0, 8, length=grid_num_N)
#  a_Os <- 10^seq(-6, -2, length=grid_num_a)
#  expt <- expand.grid(N_CB = initial_CBs,
#                      N_PB = initial_PBs,
#                      N_SB = initial_SBs,
#                      a_O = a_Os)
#  parameter$ss_expt <- expt
#  rm(grid_num_a, grid_num_N, initial_CBs, initial_PBs, initial_SBs, a_Os, expt)
#  
#  sim_res <- ss_by_a_N(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/ss_only_SB.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
ss_only_SB <- readRDS("data/partial_reproduction/ss_only_SB.RDS")

## ----echo = FALSE-------------------------------------------------------------
ss_only_SB$result %>%
  mutate(direction = ifelse(initial_N_SB == 1, "down", "up")) %>%
  select(a, direction,
         starts_with("CB"),
         starts_with("PB"),
         starts_with("SB")) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

## ----echo = FALSE-------------------------------------------------------------
ss_only_SB$result %>%
  mutate(direction = ifelse(initial_N_SB == 1, "down", "up"))%>%
  select(a, direction, SO, SR, O, P) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

## ----sim_ss_only_PB, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/ss_only_PB.RDS")----
#  grid_num_a <- 100
#  grid_num_N <- 2
#  
#  initial_CBs <- 0  # this one is varied
#  initial_PBs <- 10^seq(0, 8, length=grid_num_N)
#  initial_SBs <- 0
#  a_Os <- 10^seq(-6, -2, length=grid_num_a)
#  expt <- expand.grid(N_CB = initial_CBs,
#                      N_PB = initial_PBs,
#                      N_SB = initial_SBs,
#                      a_O = a_Os)
#  parameter$ss_expt <- expt
#  rm(grid_num_a, grid_num_N, initial_CBs, initial_PBs, initial_SBs, a_Os, expt)
#  
#  sim_res <- ss_by_a_N(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/ss_only_PB.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
ss_only_PB <- readRDS("data/partial_reproduction/ss_only_PB.RDS")

## ----echo = FALSE-------------------------------------------------------------
tempx1 <- ss_only_PB$result %>%
  select(a,
         starts_with("CB"),
         starts_with("PB"),
         starts_with("SB")) %>%
  gather(key = Species, value=Quantity, 2:ncol(.))
tempx1 %>%
  ggplot(aes(x = a, y = log10(Quantity+1), col = Species)) +
  geom_path(size = 0.8) +
  #theme_light() +
  ylim(0,10) +
  ylab(expression(Log[10](Abundance))) +
  xlab(expression(Log[10](Oxygen~diffusivity))) +
  #geom_path(data = filter(tempx1, Species == "CB"),
  #          aes(y=0.2), size = 0.8)+
  #geom_path(data = filter(tempx1, Species == "PB"),
  #          size = 0.8) +
  theme(plot.title=element_text(size=10, hjust=0.5)) +
  labs(title="Only PB")

##ggsave("figures/PB.png", width = 3, height = 2)


## ----echo = FALSE-------------------------------------------------------------
ss_only_PB$result %>%
  select(a, SO, SR, O, P) %>%
  gather(key = Species, value=Quantity, 2:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species))

## ----sim_ss_only_SB_PB, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/ss_only_SB_PB.RDS")----
#  grid_num_a <- 100
#  grid_num_N <- 2
#  
#  initial_CBs <- 0  # this one is varied
#  initial_PBs <- 10^seq(0, 8, length=grid_num_N)
#  initial_SBs <- 0
#  a_Os <- 10^seq(-6, -2, length=grid_num_a)
#  expt <- expand.grid(N_CB = initial_CBs,
#                      N_PB = initial_PBs,
#                      N_SB = initial_SBs,
#                      a_O = a_Os)
#  expt$N_SB <- expt$N_PB
#  parameter$ss_expt <- expt
#  rm(grid_num_a, grid_num_N, initial_CBs, initial_PBs, initial_SBs, a_Os, expt)
#  
#  sim_res <- ss_by_a_N(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/ss_only_SB_PB.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
ss_only_SB_PB <- readRDS("data/partial_reproduction/ss_only_SB_PB.RDS")

## ----echo = FALSE-------------------------------------------------------------
ss_only_SB_PB$result %>%
  mutate(direction = ifelse(initial_N_SB == 1, "down", "up")) %>%
  select(a, direction,
         starts_with("CB"),
         starts_with("PB"),
         starts_with("SB")) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

## ----echo = FALSE-------------------------------------------------------------
ss_only_SB_PB$result %>%
  mutate(direction = ifelse(initial_N_SB == 1, "down", "up")) %>%
  select(a, direction, SO, SR, O, P) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

## ----sim_ss_only_SB_CB, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/ss_only_SB_CB.RDS")----
#  grid_num_a <- 100
#  grid_num_N <- 2
#  
#  initial_CBs <- 10^seq(0, 10, length=grid_num_N)
#  initial_PBs <- 0
#  initial_SBs <- 10^8
#  a_Os <- 10^seq(-6, -2, length=grid_num_a)
#  expt <- expand.grid(N_CB = initial_CBs,
#                      N_PB = initial_PBs,
#                      N_SB = initial_SBs,
#                      a_O = a_Os)
#  # expt$N_SB <- expt$N_CB
#  parameter$ss_expt <- expt
#  rm(grid_num_a, grid_num_N, initial_CBs, initial_PBs, initial_SBs, a_Os, expt)
#  
#  sim_res <- ss_by_a_N(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/ss_only_SB_CB.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
ss_only_SB_CB <- readRDS("data/partial_reproduction/ss_only_SB_CB.RDS")

## ----echo = FALSE-------------------------------------------------------------
ss_only_SB_CB$result  %>%
  mutate(direction = ifelse(initial_N_CB == 1, "up", "down")) %>%
  select(a, direction,
         starts_with("CB"),
         starts_with("PB"),
         starts_with("SB")) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

## ----echo = FALSE-------------------------------------------------------------
ss_only_SB_CB$result %>%
  mutate(direction = ifelse(initial_N_CB == 1, "up", "down")) %>%
  select(a, direction, SO, SR, O, P) %>%
  gather(key = Species, value=Quantity, 3:6) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

## ----sim_ss_only_CB_PB, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/ss_only_CB_PB.RDS")----
#  grid_num_a <- 100
#  grid_num_N <- 2
#  
#  initial_CBs <- 10^seq(0, 10, length=grid_num_N)  # this one is varied
#  initial_PBs <- 10^8
#  initial_SBs <- 0
#  a_Os <- 10^seq(-6, -2, length=grid_num_a)
#  expt <- expand.grid(N_CB = initial_CBs,
#                      N_PB = initial_PBs,
#                      N_SB = initial_SBs,
#                      a_O = a_Os)
#  expt$N_CB <- expt$N_PB
#  parameter$ss_expt <- expt
#  rm(grid_num_a, grid_num_N, initial_CBs, initial_PBs, initial_SBs, a_Os, expt)
#  
#  sim_res <- ss_by_a_N(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/ss_only_CB_PB.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
ss_only_CB_PB <- readRDS("data/partial_reproduction/ss_only_CB_PB.RDS")

## ----echo = FALSE-------------------------------------------------------------
ss_only_CB_PB$result %>%
  mutate(direction = ifelse(initial_N_CB == 1, "up", "down")) %>%
  select(a, direction,
         starts_with("CB"),
         starts_with("PB"),
         starts_with("SB")) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

## ----echo = FALSE-------------------------------------------------------------
ss_only_CB_PB$result %>%
  mutate(direction = ifelse(initial_N_CB == 1, "up", "down")) %>%
  select(a, direction, SO, SR, O, P) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

## ----sim_ss_CB_SB_PB, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/ss_CB_SB_PB.RDS")----
#  grid_num_a <- 100
#  grid_num_N <- 2
#  
#  initial_CBs <- 10^seq(0, 10, length=grid_num_N)
#  initial_PBs <- 1e8
#  initial_SBs <- 1e8
#  a_Os <- 10^seq(-6, -2, length=grid_num_a)
#  expt <- expand.grid(N_CB = initial_CBs,
#                      N_PB = initial_PBs,
#                      N_SB = initial_SBs,
#                      a_O = a_Os)
#  parameter$ss_expt <- expt
#  rm(grid_num_a, grid_num_N, initial_CBs, initial_PBs, initial_SBs, a_Os, expt)
#  
#  sim_res <- ss_by_a_N(parameter)
#  saveRDS(sim_res, "data/partial_reproduction/ss_CB_SB_PB.RDS")
#  rm(sim_res)

## ----echo = FALSE-------------------------------------------------------------
ss_CB_SB_PB <- readRDS("data/partial_reproduction/ss_CB_SB_PB.RDS")

## ----echo = FALSE-------------------------------------------------------------
ss_CB_SB_PB$result %>%
  mutate(direction = ifelse(initial_N_CB == 1, "up", "down")) %>%
  select(a, direction,
         starts_with("CB"),
         starts_with("PB"),
         starts_with("SB")) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

# ss_CB_SB_PB %>%
#   select(a, CB=N_CB, SB=N_SB, PB=N_PB) %>%
#   gather(key = Species, value=Quantity, 2:ncol(.)) %>%
#   ggplot() +
#   geom_path(aes(x = a, y = log10(Quantity), col = Species),
#             size=0.8) +
#   ylab(expression(Log[10](Abundance))) +
#   xlab(expression(Log[10](Oxygen~diffusivity))) +
#   theme_light() +
#   ylim(0,10) +
#   theme(plot.title=element_text(size=10, hjust=0.5)) +
#   labs(title="CB, SB, & PB")
##ggsave("figures/CB_SB_PB.png", width = 3, height = 2)


## ----echo = FALSE-------------------------------------------------------------
ss_CB_SB_PB$result %>%
  mutate(direction = ifelse(initial_N_CB == 1, "up", "down")) %>%
  select(a, direction, SO, SR, O, P) %>%
  gather(key = Species, value=Quantity, 3:ncol(.)) %>%
  ggplot() +
  geom_path(aes(x = a, y = log10(Quantity+1), col = Species, linetype = direction))

## ----echo = FALSE, sim_resp_summary, eval = run_steadystate_sims | !file.exists("data/partial_reproduction/resp_summary.RDS")----
all_ss <- tibble(readRDS("data/partial_reproduction/ss_no_biology.RDS")$result,
                 composition = "No organisms") %>%
  bind_rows(tibble(readRDS("data/partial_reproduction/ss_only_CB.RDS")$result,
                   composition = "CB")) %>%
  bind_rows(tibble(readRDS("data/partial_reproduction/ss_only_SB.RDS")$result,
                   composition = "SB")) %>%
  bind_rows(tibble(readRDS("data/partial_reproduction/ss_only_PB.RDS")$result,
                   composition = "PB")) %>%
  bind_rows(tibble(readRDS("data/partial_reproduction/ss_only_SB_PB.RDS")$result,
                   composition = "SB-PB")) %>%
  bind_rows(tibble(readRDS("data/partial_reproduction/ss_only_SB_CB.RDS")$result,
                   composition = "SB-CB")) %>%
  bind_rows(tibble(readRDS("data/partial_reproduction/ss_only_CB_PB.RDS")$result,
                   composition = "CB-PB")) %>%
  bind_rows(tibble(readRDS("data/partial_reproduction/ss_CB_SB_PB.RDS")$result,
                   composition = "CB-SB-PB"))

#ss_object <- all_ss %>%
#  filter(composition == "No organisms")

stab_res <- all_ss %>%
  group_by(composition) %>%
  do(stab_measures = get_stability_measures(.)) %>%
  unnest(cols = c(stab_measures)) %>%
  mutate(composition = as.factor(composition),
         composition = fct_relevel(composition,
                                   "No organisms",
                                   "CB",
                                   "SB",
                                   "PB",
                                   "CB-PB",
                                   "SB-CB",
                                   "SB-PB",
                                   "CB-SB-PB"),
         num_func_groups = case_when(composition =="No organisms" ~ 0,
                                     composition == "CB" ~ 1,
                                     composition == "SB" ~ 1,
                                     composition == "PB" ~ 1,
                                     composition == "CB-PB" ~ 2,
                                     composition == "SB-CB" ~ 2,
                                     composition == "SB-PB" ~ 2,
                                     composition == "CB-SB-PB" ~ 3
         ),
         var_type = ifelse(str_sub(Species, 3, 3)=="_", "Organism", "Substrate")) %>%
  gather(key = "stab_measure", value = "value", 3:14)
saveRDS(stab_res, "data/partial_reproduction/stab_res.RDS")

## ----echo = FALSE, fig.height=8-----------------------------------------------
stab_res <- readRDS("data/partial_reproduction/stab_res.RDS")
stab_res %>%
  ggplot() +
  geom_point(aes(x = composition, y = value)) +
  facet_grid(Species ~ stab_measure, scales = "free") +
  coord_flip()


## ----echo = FALSE-------------------------------------------------------------
resp_summ1 <- stab_res %>%
  dplyr::filter(stab_measure %in% c("nl_down_log", "nl_up_log")) %>%
  group_by(composition, Species, num_func_groups, var_type) %>%
  summarise(ave_nl = mean(value))

resp_summ1 %>%
  ggplot() +
  geom_point(aes(composition, ave_nl)) +
  facet_wrap( ~ Species)+
  coord_flip()


## ----echo = FALSE-------------------------------------------------------------
focus_on <- "Substrate"
ave_nl_substrate <- resp_summ1 %>%
  dplyr::filter(var_type == focus_on) %>%
  group_by(composition) %>%
  summarise(ave_ave_nl = mean(ave_nl))
ave_nl_substrate %>%
  ggplot() +
  geom_point(aes(composition, ave_ave_nl)) +
  ggtitle(paste("Nonlinearity in", focus_on, "response."))+
  coord_flip()

## ----echo = FALSE-------------------------------------------------------------
focus_on <- "Organism"
ave_nl_organism <- resp_summ1 %>%
  dplyr::filter(var_type == focus_on) %>%
  group_by(composition) %>%
  summarise(ave_ave_nl = mean(ave_nl, na.rm = TRUE))
ave_nl_organism %>%
  ggplot() +
  geom_point(aes(composition, ave_ave_nl)) +
  ggtitle(paste("Nonlinearity in", focus_on, "response."))+
  coord_flip()

## ----echo = FALSE-------------------------------------------------------------
focus_on <- "System"
ave_nl_system <- resp_summ1 %>%
  group_by(composition) %>%
  summarise(ave_ave_nl = mean(ave_nl, na.rm = TRUE))
ave_nl_system %>%
  ggplot() +
  geom_point(aes(composition, ave_ave_nl)) +
  ggtitle(paste("Nonlinearity in", focus_on, "response."))+
  coord_flip()
##ggsave("figures/system_nonlinearity.png", width = 3, height = 2)


## ----echo = FALSE-------------------------------------------------------------
focus_on <- "Substrate"
resp_summ3 <- stab_res %>%
  dplyr::filter(stab_measure %in% c("hyst_tot_log", "hyst_range_log"),
                var_type == focus_on) %>%
  group_by(composition, num_func_groups, stab_measure, var_type) %>%
  summarise(ave_hyst = mean(value, na.rm = TRUE))

resp_summ3 %>%
  ggplot() +
  geom_point(aes(x = composition, y = ave_hyst)) +
  facet_wrap( ~ stab_measure, scales="free") +
  ggtitle(paste("Hysteresis in", focus_on, "response."))+
  coord_flip()


## ----echo = FALSE-------------------------------------------------------------
focus_on <- "Organism"
resp_summ3 <- stab_res %>%
  dplyr::filter(stab_measure %in% c("hyst_tot_log", "hyst_range_log"),
                var_type == focus_on) %>%
  group_by(composition, num_func_groups, stab_measure, var_type) %>%
  summarise(ave_hyst = mean(value, na.rm = TRUE))

resp_summ3 %>%
  ggplot() +
  geom_point(aes(x = composition, y = ave_hyst)) +
  facet_wrap( ~ stab_measure, scales="free") +
  ggtitle(paste("Hysteresis in", focus_on, "response."))+
  coord_flip()


## ----echo = FALSE-------------------------------------------------------------
resp_summ4 <- stab_res %>%
  dplyr::filter(stab_measure %in% c("hyst_tot_log", "hyst_range_log")) %>%
  group_by(stab_measure, composition) %>%
  summarise(mean_hyst = mean(value, na.rm = TRUE))

resp_summ4 %>%
  ggplot() +
  geom_point(aes(x = composition, y = mean_hyst)) +
  facet_wrap( ~ stab_measure) +
  ggtitle("Hysteresis in system response.")+
  coord_flip()


## ----echo = FALSE-------------------------------------------------------------
resp_summ5 <- resp_summ4 %>%
  group_by(composition) %>%
  summarise(mean_mean_hyst = mean(mean_hyst))

resp_summ5 %>%
  ggplot() +
  geom_point(aes(x = composition, y = mean_mean_hyst)) +
  xlab("Functional groups present") +
  ylab("Amount of hysteresis") +
  #ylim(0,2) +
  theme_light() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  coord_flip()
##ggsave("figures/composition_system_hysteresis.png", width = 2.5, height = 2.5)


