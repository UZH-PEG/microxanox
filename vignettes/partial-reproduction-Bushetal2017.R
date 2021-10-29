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

