## set the working directory
setwd("~/Dropbox/TMMassie/check")


# number of species
species.number <- 7 
 
 
########################################################################  
######################################################################## 
## Define parameter values here!

## Define all time related parameters for integration.
tperiod = 5      # replacing flask content every 'tperiod' days
ncycles = 5      # number of replacement events
t_start = 0		 # simulation starts at t_start
t_stop  = tperiod*(1+ncycles)	# total simulation time
t_step  = 0.05	 # time steps for output data
# define time range for simulation as well as steps in time
times   <- seq(t_start, t_stop, t_step)				# for the simulation, seq(from, to, by)
timing  <- seq(tperiod, tperiod*ncycles, tperiod)	# for the discrete events, seq(from, to, by)

## BACTERIAL UPTAKE RATES for resource
u01 = 2.00     	 # bacterial species 1
u02 = 2.00     	 # bacterial species 2

## HALF-SATURATION CONSTANTS for bacterial resource uptake
K01 = 0.50  	 # 1st halfsaturation constant, affinity for medium resource
K02 = 0.50 		 # 2nd halfsaturation constant, affinity for medium resource
 
## SEARCH COEFFICIENTS describing the increase in the instantaneous search rate a
b13 = 0.70       # species 3 on species 1
b23 = 0.70       # species 3 on species 2
b14 = 0.70       # species 4 on species 1
b24 = 0.70       # species 4 on species 2
b15 = 0.70       # species 5 on species 1
b25 = 0.70       # species 5 on species 2
b36 = 0.80       # species 6 on species 3
b46 = 0.80       # species 6 on species 4
b56 = 0.80       # species 6 on species 5
 
## HANDLING TIMES
h13 = 1.50       # time spent of species 3 handling species 1
h23 = 1.50       # time spent of species 3 handling species 2
h24 = 1.50       # time spent of species 4 handling species 2
h15 = 1.50       # time spent of species 5 handling species 1
h14 = 1.50       # time spent of species 4 handling species 1
h25 = 1.50       # time spent of species 5 handling species 2
h36 = 1.70       # time spent of species 6 handling species 3
h46 = 1.70       # time spent of species 6 handling species 4
h56 = 1.70       # time spent of species 6 handling species 5

## CONVERSION EFFICIENCIES
e13 = 0.95	     # conversion efficiency by which species 3 consumes species 1
e23 = 0.95       # conversion efficiency by which species 3 consumes species 2
e14 = 0.95       # conversion efficiency by which species 4 consumes species 1
e24 = 0.95       # conversion efficiency by which species 4 consumes species 2
e15 = 0.95       # conversion efficiency by which species 5 consumes species 1
e25 = 0.95       # conversion efficiency by which species 5 consumes species 2
e36 = 0.80       # conversion efficiency by which species 6 consumes species 3
e46 = 0.80       # conversion efficiency by which species 6 consumes species 4
e56 = 0.80       # conversion efficiency by which species 6 consumes species 5

## SCALING (HILL) EXPONENTS converting Type II (q=1) into Type III (q>1) functional response
q13 = 1.00  
q23 = 1.00  
q14 = 1.00  
q24 = 1.00  
q15 = 1.00  
q25 = 1.00  
q36 = 1.00  
q46 = 1.00  
q56 = 1.00
  
## MORTALITY RATES for species i; constant losses due to respration, for instance
m0  = 0.00  
m1  = 0.00  
m2  = 0.00  
m3  = 0.00  
m4  = 0.00  
m5  = 0.00  
m6  = 0.05 


########################################################################
######################################################################## 
## The matrices are generated here!

## BACTERIAL UPTAKE RATES for resource #################################
u   <- matrix(0.0,species.number,species.number,
              dimnames = list(c("s0", "s1", "s2", "s3", "s4", "s5", "s6"),
                              c("s0", "s1", "s2", "s3", "s4", "s5", "s6")))
u[1,2] <- u01
u[1,3] <- u02
write.csv(u, file = "values_u.csv", fileEncoding = "macroman")

## HALF-SATURATION CONSTANTS ###########################################
K   <- matrix(0.0,species.number,species.number,
              dimnames = list(c("s0", "s1", "s2", "s3", "s4", "s5", "s6"),
                              c("s0", "s1", "s2", "s3", "s4", "s5", "s6")))
K[1,2] <- K01
K[1,3] <- K02
write.csv(K, file = "values_K.csv", fileEncoding = "macroman")

## SEARCH COEFFICIENTS #################################################
b   <- matrix(0.0,species.number,species.number,
              dimnames = list(c("s0", "s1", "s2", "s3", "s4", "s5", "s6"),
                              c("s0", "s1", "s2", "s3", "s4", "s5", "s6")))
b[2,4] <- b13
b[3,4] <- b23
b[2,5] <- b14
b[3,5] <- b24
b[2,6] <- b15
b[3,6] <- b25
b[4,7] <- b36
b[5,7] <- b46
b[6,7] <- b56
write.csv(b, file = "values_b.csv", fileEncoding = "macroman")

## HANDLING TIMES ######################################################
h   <- matrix(0.0,species.number,species.number,
              dimnames = list(c("s0", "s1", "s2", "s3", "s4", "s5", "s6"),
                              c("s0", "s1", "s2", "s3", "s4", "s5", "s6")))
h[2,4] <- h13
h[3,4] <- h23
h[2,5] <- h14
h[3,5] <- h24
h[2,6] <- h15
h[3,6] <- h25
h[4,7] <- h36
h[5,7] <- h46
h[6,7] <- h56
write.csv(h, file = "values_h.csv", fileEncoding = "macroman")

## CONVERSION EFFICIENCIES #############################################
e   <- matrix(0.0,species.number,species.number,
              dimnames = list(c("s0", "s1", "s2", "s3", "s4", "s5", "s6"),
                              c("s0", "s1", "s2", "s3", "s4", "s5", "s6")))
e[2,4] <- e13
e[3,4] <- e23
e[2,5] <- e14
e[3,5] <- e24
e[2,6] <- e15
e[3,6] <- e25
e[4,7] <- e36
e[5,7] <- e46
e[6,7] <- e56
write.csv(e, file = "values_e.csv", fileEncoding = "macroman")

## SCALING (HILL) EXPONENTS ############################################
q   <- matrix(0.0,species.number,species.number,
              dimnames = list(c("s0", "s1", "s2", "s3", "s4", "s5", "s6"),
                              c("s0", "s1", "s2", "s3", "s4", "s5", "s6")))
q[2,4] <- q13
q[3,4] <- q23
q[2,5] <- q14
q[3,5] <- q24
q[2,6] <- q15
q[3,6] <- q25
q[4,7] <- q36
q[5,7] <- q46
q[6,7] <- q56
write.csv(q, file = "values_q.csv", fileEncoding = "macroman")

## MORTALITY RATES #####################################################
m   <- c(m0, m1, m2, m3, m4, m5, m6)
m   <- matrix(m,
              dimnames = list(c("s0", "s1", "s2", "s3", "s4", "s5", "s6"),
                              c("mortality rate")))
write.csv(m, file = "values_m.csv", fileEncoding = "macroman")


## ALL VALUES ##########################################################
values.all <- c(
  tperiod, ncycles,
  t_start, t_stop, t_step,
  u01, u02,
  K01, K02,
  b13, b23, b14, b24, b15, b25, b36, b46, b56,
  h13, h23, h14, h24, h15, h25, h36, h46, h56,
  e13, e23, e14, e24, e15, e25, e36, e46, e56,
  q13, q23, q14, q24, q15, q25, q36, q46, q56,
  m0, m1, m2, m3, m4, m5, m6)
values.all <- matrix(values.all,
              dimnames = list(c("tperiod", "ncycles",
              					"t_start", "t_stop", "t_step",
              					"u01", "u02", 
              					"K01", "K02", 
              					"b13", "b23", "b14", "b24", "b15", "b25", "b36", "b46", "b56",
              					"h13", "h23", "h24", "h15", "h14", "h25", "h36", "h46", "h56",
              					"e13", "e23", "e24", "e15", "e14", "e25", "e36", "e46", "e56",
              					"q13", "q23", "q24", "q15", "q14", "q25", "q36", "q46", "q56",
              					"m0", "m1", "m2", "m3", "m4", "m5", "m6"),
                              c("value")))

write.csv(values.all, file = "values_all.csv", fileEncoding = "macroman")

#  h13, h23, h24, h15, h14, h25, h36, h46, h56,
