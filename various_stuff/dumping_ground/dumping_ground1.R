## Code test

```{r eval = FALSE}
dynamic_model = bushplus_dynamic_model
event_definition = default_event_definition
parameter_values = default_parameter_values
event_interval = default_event_interval
noise_sigma = default_noise_sigma
minimum_abundances = default_minimum_abundances
sim_duration = default_sim_duration
sim_sample_interval = default_sim_sample_interval
log10a_series = default_log10a_series
initial_state = default_initial_state
solver_method = "radau"

times <- seq(0,
             sim_duration,
             by = sim_sample_interval)

event_times <- seq(min(times),
                   max(times),
                   by = event_interval)

log10a_forcing <- matrix(ncol=2,
                         byrow=F,
                         data=c(ceiling(seq(0,
                                            max(times),
                                            length=length(log10a_series))),
                                log10a_series))


log10a_forcing <- approxfun(x = log10a_forcing[,1],
                            y = log10a_forcing[,2],
                            method = "linear",
                            rule = 2)
assign("log10a_forcing_func", log10a_forcing, envir = .GlobalEnv)

out <- as.data.frame(ode(y = initial_state,
                         times = times,
                         func = dynamic_model,
                         parms = parameter_values,
                         method = solver_method,
                         events = list(func=event_definition,
                                       time=event_times)))

bushplus_dynamic_model(1, initial_state, default_parameter_values)

sim_res <- run_simulation(
  parameter
  # dynamic_model = bushplus_dynamic_model,
  # event_definition = default_event_definition,
  # parameter_values = default_parameter_values,
  # event_interval = default_event_interval,
  # noise_sigma = default_noise_sigma,
  # minimum_abundances = default_minimum_abundances,
  # sim_duration = default_sim_duration,
  # sim_sample_interval = default_sim_sample_interval,
  # log10a_series = default_log10a_series,
  # initial_state = default_initial_state,
  # solver_method = "radau"
)

sim_res <- run_simulation(
  parameter
  # dynamic_model = bushplus_dynamic_model
)

plot_dynamics(sim_res)

```





## runsteady function not finding correct values

```{r eval = FALSE}

init_state_anoxic_2 <- c(N_CB = 1e1,
                         N_PB = 1e8,
                         N_SB = 1e8,
                         SO = 300,
                         SR = 300,
                         O = 1e-5,
                         P = 1e1)


RS <- runsteady(y = init_state_anoxic_2,
                fun = bushplus_dynamic_model,
                parms = default_parameter_values,
                times = c(0, 1e5),
                stol=1)
RS$y
RS <- runsteady(y = init_state_favouring_oxic,
                fun = bushplus_dynamic_model,
                parms = default_parameter_values,
                times = c(0, 1e5),
                stol=1)
RS$y

```

## Separatrix

Note that this section not working / updated since the code was made into functions

### Effect of N_CB and oxygen diffusability

```{r eval = FALSE}

noise_sigma <- 0.0

get_final_states_N_CB <- function(x) { 
  
  #give N_CB, N_SB, N_PB and a_O values and put these into state and parameters
  state["N_CB"] <- x["N_CB"]
  parameters["a_O"] <- x["a_O"]
  
  ## update forcing function
  a_forcing1 <- matrix(ncol=2, byrow=T, data=c(0,
                                               log10(parameters["a_O"]),
                                               max(times),
                                               log10(parameters["a_O"])))
  log10a_forcing2 <- approxfun(x = a_forcing1[,1],
                               y = a_forcing1[,2],
                               method = "linear",
                               rule = 2)
  
  ## assign the changed a_forcing2 into the global environment, from where the model gets a_forcing2
  assign("log10a_forcing2", log10a_forcing2, envir = .GlobalEnv)
  
  as.data.frame(ode(y = state,
                    times = times,
                    func = micro_mod_var,
                    parms = parameters,
                    method = "radau",
                    events = list(func=noise_events, time=times)))[2,-1] 
  #gives you values for the last time step
}

times <- seq(0, 50000, by = 50000)

state <- c(N_CB = NA, #this one is varied
           N_PB = 1e8,
           N_SB = 1e8,
           SO = 200,
           SR = 200,
           O = 10,
           P = 9.5)

#different combinations of N_CB and oxygen diffusability
grid_num <- 50
expt <- expand.grid(N_CB = 10^seq(0, 8, length=grid_num),
                    a_O = 10^seq(-3.5, -2, length=grid_num))


result <- apply(expt, 1, function(x) get_final_states_N_CB(x)) %>%
  tibble() %>%
  unnest() %>%
  mutate(initial_N_CB=expt$N_CB,
         a_O=expt$a_O,
         highlow=ifelse(N_CB>2e8, 'high', 'low'))

result <- result %>%
  mutate(N_CB = ifelse(N_CB < minimum_abundance, minimum_abundance, N_CB))



result$highlow <- as.factor(result$highlow)
saveRDS(result, "data/CB_oxdiff_hyst.RDS")
```

```{r eval = FALSE}
result <- readRDS("data/CB_oxdiff_hyst.RDS")
```



```{r eval = FALSE}

#plot N_CB / P_CB against a_0
p <- ggplot(result) + 
  geom_line(aes(x=log10(a_O), y=log10(N_CB), color=highlow), size=1.25) +
  ggtitle("Stable states of the system")+
  xlab('log[oxygen diffusivity]') +
  ylab('Initial cyanobacteria abundance')
p <- p + geom_point(data=result, aes(x=log10(a_O), y=log10(initial_N_CB), color=highlow)) + labs(color = "Final CB concentration")
plot(p)
#ggsave("initial conditions_1.png")
```



```{r eval = FALSE}
#show hysterisis effects for all the parameters
#plot oxygen against diffusability
ggplot(result) + 
  geom_point(aes(x=log10(a_O), y=(log10(O))))+
  xlab('log[oxygen diffusivity]') +
  ylab('log[oxygen concentration]')+
  geom_segment(aes(x=log10(result$a_O[839]), y=log10(result$O[839]), xend=log10(result$a_O[838]), yend=log10(result$O[838])), arrow=arrow(), colour="blue", size=0.5)+
  geom_segment(aes(x=log10(result$a_O[1761]), y=log10(result$O[1761]), xend=log10(result$a_O[1762]), yend=log10(result$O[1762])), arrow=arrow(), colour="blue", size=0.5)+
  geom_segment(aes(x=-4.25, y=-0.45, xend=-3.75, yend=0.1), arrow=arrow(), colour="blue", size=0.5)+
  geom_curve(aes(x = -3.75, y = 1.9, xend = -4.25, yend = 1.5), arrow=arrow(), colour='blue', size = 0.5, curvature = -0.2)
#ggsave("hysterisis_CB_1.png")
```

```{r eval = FALSE}
ggplot(result) + 
  geom_point(aes(x=log10(a_O), y=(log10(P))))+
  ggtitle("Hysterisis effect of phoshate concentration")+
  xlab('log[oxygen diffusivity]') +
  ylab('log[phosphate concentration]')
#ggsave("hysterisis_CB_2.png")
```

```{r eval = FALSE}
ggplot(result) + 
  geom_point(aes(x=log10(a_O), y=(log10(SO))))+
  ggtitle("Hysterisis effect of oxidized sulfur concentration")+
  xlab('log[oxygen diffusivity]') +
  ylab('log[oxydized sulfur concentration]')
#ggsave("hysterisis_CB_3.png")
```

```{r eval = FALSE}
ggplot(result) + 
  geom_point(aes(x=log10(a_O), y=(log10(SR))))+
  ggtitle("Hysterisis effect of reduced sulfur concentration")+
  xlab('log[oxygen diffusivity]') +
  ylab('log[reduced sulfur] concentration]')
#ggsave("hysterisis_CB_4.png")
```

These graphs show an at least qualitative match to the result in the paper.


### Effect of PB/SB depending on oxygen diffusability


```{r eval = FALSE}
noise_sigma <- 0.00
get_final_states_N_PB <- function(x) { 
  #give in N_CB, N_SB, N_PB and a_O values and put these into state and parameters
  state["N_PB"] <- x["var"]
  state["N_SB"] <- x["var"]
  parameters["a_O"] <- x["a_O"]
  
  ## update forcing function
  a_forcing1 <- matrix(ncol=2, byrow=T, data=c(0,
                                               log10(parameters["a_O"]),
                                               max(times),
                                               log10(parameters["a_O"])))
  log10a_forcing2 <- approxfun(x = a_forcing1[,1],
                               y = a_forcing1[,2],
                               method = "linear",
                               rule = 2)
  ## assign the changed a_forcing2 into the global environment, from where the model gets a_forcing2
  assign("log10a_forcing2", log10a_forcing2, envir = .GlobalEnv)
  
  as.data.frame(ode(y = state,
                    times = times,
                    func = micro_mod_var,
                    parms = parameters,
                    method = "radau", events = list(func=noise_events, time=times)))[2,-1] 
  #gives you values for the last time step
}

times <- seq(0, 50000, by = 5000)
state <- c(N_CB = 5, 
           N_PB = NA,#this one is varied
           N_SB = NA,
           SO = 200,
           SR = 200,
           O = 10,
           P = 9.5)

#different combinations of N_PB and oxygen diffusivity
grid_num <- 50
expt <- expand.grid(var=10^seq(0, 7, length=grid_num),
                    a_O = 10^seq(-3, -2, length=grid_num))


result2 <- apply(expt, 1, function(x) get_final_states_N_PB(x)) %>%
  tibble() %>%
  unnest() %>%
  mutate(initial_N_PB=expt$var,
         initial_N_SB=expt$var,
         a_O=expt$a_O,
         highlow=ifelse(N_PB>1e8, 'high', 'low')) 

result2 <- result2 %>%
  mutate(N_PB = ifelse(N_PB < minimum_abundance, minimum_abundance, N_PB))

result2$highlow <- as.factor(result2$highlow)
saveRDS(result2, "data/PBSB_oxdiff_hyst.RDS")
```

```{r eval = FALSE}
result2 <- readRDS("data/PBSB_oxdiff_hyst.RDS")
```


```{r eval = FALSE}
#plot N_PB against a_0
p <- ggplot(result2) + 
  geom_line(aes(x=log10(a_O), y=log10(N_PB), color=highlow), size=1.25) +
  ggtitle("Stable states of the system")+
  xlab('log[oxygen diffusivity]') +
  ylab('Initial PS and SR bacteria concentration')
p <- p + geom_point(data=result2,
                    aes(x=log10(a_O), y=log10(initial_N_PB), color=highlow))
p <- p + labs(color = "Final PB and SB concentration")
plot(p)
#ggsave("initial conditions_2.png")
```




