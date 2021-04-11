# Food web model, first attempt.
# Thomas M. Massie | July 15, 2012


#rm(list=ls())

## set the working directory

## source the functions used (none at the moment)


## Read parameters values from the shared values file.
data   <- read.csv("values_all.csv", row.names=1)
# for (i in 1:length(data[,1])) {
	# values <- data[i,1]
	# names  <- rownames(data)[i]
	# assign(names,values)
# }
parms <- c(data[,1])
names(parms) <- rownames(data)

# parameters <- data[,1]


##################################
## Define parameters.
dil     <- 0.0
ext.thresh.Sp1 <- 1e-5
ext.thresh.Sp2 <- 1e-5
ext.thresh.Sp3 <- 1e-5
ext.thresh.Sp4 <- 1e-5
ext.thresh.Sp5 <- 1e-5
ext.thresh.Sp6 <- 1e-5



# declare initial values of state variables S1-S6 (species) and Res (resource)
Res_ini = 1000  # Resource
Sp1_ini = 300    # B. subtilus
Sp2_ini = 200    # S. fonticula
Sp3_ini = 10    # Collodyction sp.
Sp4_ini = 20     # Paramecium sp.
Sp5_ini = 30     # Colpidium sp.
Sp6_ini = 4     # Dileptus sp.
Los_ini = 0     # Losses

#Ini     = Sp1_ini + Sp2_ini + Sp3_ini + Sp4_ini + Sp5_ini + Sp6_ini + Res_ini + Los_ini

state <- c(
  Sp1 = Sp1_ini,    # B. subtilus
  Sp2 = Sp2_ini,    # S. fonticula
  Sp3 = Sp3_ini,    # Collodyction sp.
  Sp4 = Sp4_ini,    # Paramecium sp.
  Sp5 = Sp5_ini,    # Colpidium sp.
  Sp6 = Sp6_ini,    # Dileptus sp.
  Res = Res_ini,    # Resource
  Los = Los_ini     # Losses due to mortality, inefficiencies...
)


# tperiod = 2    # replacing flask content every 'tperiod' days
# ncycles = 10     # number of replacement events, also defining the time span of the simulation
# # time span of the simulation
 t_start = 0
 t_stop  = 20
#t_stop  = tperiod*(ncycles)
t_step  = 0.05
# # define time range for simulation as well as steps in time
 times <- seq(t_start, t_stop, t_step)
# timing <- seq(tperiod, tperiod*ncycles, tperiod)


# define function 'simchem'
foodweb_multi_f <- function(t, state, parameters) {
	
  with(as.list(c(state, parameters)), {
  	##print(Sp1)
    # extinction thresholdSp1
    Sp1[Sp1 < ext.thresh.Sp1] <- 1e-5	
    Sp2[Sp2 < ext.thresh.Sp2] <- 1e-5	
    Sp3[Sp3 < ext.thresh.Sp3] <- 1e-5	
    Sp4[Sp4 < ext.thresh.Sp4] <- 1e-5	
    Sp5[Sp5 < ext.thresh.Sp5] <- 1e-5	
    Sp6[Sp6 < ext.thresh.Sp6] <- 1e-5	
    # FUNCTIONAL RESPONSES discribing resource-dependent growth of the bacteria
    # bacterium B. subtilus taking up medium, Monod-wise
    f71 = Monod(u=u01, R=Res, K=K01)
    # bacterium S. fonticola taking up medium, Monod-wise
    f72 = Monod(u=u02, R=Res, K=K02)
     
    a13 = attack(b=b13, S=Sp1, q=q13)
    a23 = attack(b=b23, S=Sp2, q=q23)
	##print(c(a13, a23))
    a14 = attack(b=b14, S=Sp1, q=q14)
    a24 = attack(b=b24, S=Sp2, q=q24)
    a15 = attack(b=b15, S=Sp1, q=q15)
    a25 = attack(b=b25, S=Sp2, q=q25)
    a36 = attack(b=b36, S=Sp3, q=q36)
    a46 = attack(b=b46, S=Sp4, q=q46)
    a56 = attack(b=b56, S=Sp5, q=q56)    
    
    
    # DIFFERENTIAL EQUATIONS       
    # change in the densities of species 1-6
    ##print(c(f71, f72))
    ##print(c(Sp1, Sp2))

##print(c((a13*Sp3*Sp1)/(1+a13*h13*Sp1+ a23*h23*Sp2), (a23*Sp3*Sp2)/(1+a13*h13*Sp1+ a23*h23*Sp2)))

    dSp1 <-   f71*Sp1 -
    		  (a13*Sp3*Sp1)/(1+a13*h13*Sp1+ a23*h23*Sp2) -
    		  (a14*Sp4*Sp1)/(1+a14*h14*Sp1+ a24*h24*Sp2) -
    		  (a15*Sp5*Sp1)/(1+a15*h15*Sp1+ a25*h25*Sp2) -
    		  m1*Sp1
           
                                                                                                         
    dSp2 <-    f72*Sp2 -
    	(a23*Sp3*Sp2)/(1+a13*h13*Sp1+ a23*h23*Sp2) -
    	(a24*Sp4*Sp2)/(1+a14*h14*Sp1+ a24*h24*Sp2) -
    	(a25*Sp5*Sp2)/(1+a15*h15*Sp1+ a25*h25*Sp2) -
    	m2*Sp2

    ##print(c(dSp1, dSp2))
    
       
    
    dSp3 <- ((e13*a13*Sp1+ e23*a23*Sp2)/(1+(a13*h13*Sp1+a23*h23*Sp2)))*Sp3  -  (a36*Sp3*Sp6)/(1+ a36*h36*Sp3+ a46*h46*Sp4+ a56*h56*Sp5)  						  -  m3*Sp3
    dSp4 <- ((e14*a14*Sp1+ e24*a24*Sp2)/(1+(a14*h14*Sp1+a24*h24*Sp2)))*Sp4  -  (a46*Sp4*Sp6)/(1+ a36*h36*Sp3+ a46*h46*Sp4+ a56*h56*Sp5)  						  -  m4*Sp4
    dSp5 <- ((e15*a15*Sp1+ e25*a25*Sp2)/(1+(a15*h15*Sp1+a25*h25*Sp2)))*Sp5  -  (a56*Sp5*Sp6)/(1+ a36*h36*Sp3+ a46*h46*Sp4+ a56*h56*Sp5)  						  -  m5*Sp5
    dSp6 <- ((e36*a36*Sp3+ e46*a46*Sp4+ e56*a56*Sp5)/(1+(a36*h36*Sp3+ a46*h46*Sp4+ a56*h56*Sp5)))*Sp6            												  -  m6*Sp6
    # change in resource concentration
    dRes <- -  f71*Sp1  -  f72*Sp2
    # change in the losses due to inefficient consumption or mortality
    dLos <- ((a13*Sp1+ a23*Sp2)/(1+(a13*h13*Sp1+a23*h23*Sp2)))*Sp3  -  ((e13*a13*Sp1+ e23*a23*Sp2)/(1+(a13*h13*Sp1+a23*h23*Sp2)))*Sp3 +
            ((a14*Sp1+ a24*Sp2)/(1+(a14*h14*Sp1+a24*h24*Sp2)))*Sp4  -  ((e14*a14*Sp1+ e24*a24*Sp2)/(1+(a14*h14*Sp1+a24*h24*Sp2)))*Sp4 +
            ((a15*Sp1+ a25*Sp2)/(1+(a15*h15*Sp1+a25*h25*Sp2)))*Sp5  -  ((e15*a15*Sp1+ e25*a25*Sp2)/(1+(a15*h15*Sp1+a25*h25*Sp2)))*Sp5 +
            ((a36*Sp3+ a46*Sp4+ a56*Sp5)/(1+(a36*h36*Sp3+ a46*h46*Sp4+ a56*h56*Sp5)))*Sp6 -  
            ((e36*a36*Sp3+ e46*a46*Sp4+ e56*a56*Sp5)/(1+(a36*h36*Sp3+ a46*h46*Sp4+ a56*h56*Sp5)))*Sp6                                 +
            m1*Sp1 + m2*Sp2 + m3*Sp3 + m4*Sp4 + m5*Sp5 + m6*Sp6       
    
   	
    
    list(c(dSp1, dSp2, dSp3, dSp4, dSp5, dSp6, dRes, dLos))
    
#     list(c(f71*Sp1  -  (a13*var[3]*var[1])/(1+a13*h13*var[1]+ a23*h23*var[2])  -  (a14*var[4]*var[1])/(1+a14*h14*var[1]+ a24*h24*var[2])  -  (a15*var[5]*var[1])/(1+a15*h15*var[1]+ a25*h25*var[2])  -  m1*var[1],                                                                     
#            f72*Sp2  -  (a23*var[3]*var[2])/(1+a13*h13*var[1]+ a23*h23*var[2])  -  (a24*var[4]*var[2])/(1+a14*h14*var[1]+ a24*h24*var[2])  -  (a25*var[5]*var[2])/(1+a15*h15*var[1]+ a25*h25*var[2])  -  m2*var[2],
#            ((e13*a13*var[1]+ e23*a23*var[2])/(1+(a13*h13*var[1]+a23*h23*var[2])))*var[3]  -  (a36*var[3]*var[6])/(1+ a36*h36*var[3]+ a46*h46*var[4]+ a56*h56*var[5])                                 -  m3*var[3],
#            ((e14*a14*var[1]+ e24*a24*var[2])/(1+(a14*h14*var[1]+a24*h24*var[2])))*var[4]  -  (a46*var[4]*var[6])/(1+ a36*h36*var[3]+ a46*h46*var[4]+ a56*h56*var[5])                                 -  m4*var[4],
#            ((e15*a15*var[1]+ e25*a25*var[2])/(1+(a15*h15*var[1]+a25*h25*var[2])))*var[5]  -  (a56*var[5]*var[6])/(1+ a36*h36*var[3]+ a46*h46*var[4]+ a56*h56*var[5])                                 -  m5*var[5],
#            ((e36*a36*var[3]+ e46*a46*var[4]+ e56*a56*var[5])/(1+ a36*h36*var[3]+ a46*h46*var[4]+ a56*h56*var[5]))*var[6]                                                                             -  m6*var[6],
#            f71*var[1]  -  f72*var[2],
#            ((a13*var[1]+ a23*var[2])/(1+(a13*h13*var[1]+a23*h23*var[2])))*Sp3  -  ((e13*a13*var[1]+ e23*a23*var[2])/(1+(a13*h13*var[1]+a23*h23*var[2])))*var[3] +
#              ((a14*var[1]+ a24*var[2])/(1+(a14*h14*var[1]+a24*h24*var[2])))*var[4]  -  ((e14*a14*var[1]+ e24*a24*var[2])/(1+(a14*h14*var[1]+a24*h24*var[2])))*var[4] +
#              ((a15*var[1]+ a25*var[2])/(1+(a15*h15*var[1]+a25*h25*var[2])))*var[5]  -  ((e15*a15*var[1]+ e25*a25*var[2])/(1+(a15*h15*var[1]+a25*h25*var[2])))*var[5] +
#              ((a36*var[3]+ a46*var[4]+ a56*var[5])/(1+(a36*h36*var[3]+ a46*h46*var[4]+ a56*h56*var[5])))*var[6] -  
#              ((e36*a36*var[3]+ e46*a46*var[4]+ e56*a56*var[5])/(1+(a36*h36*var[3]+ a46*h46*var[4]+ a56*h56*var[5])))*var[6] +
#              m1*var[1] + m2*var[2] + m3*var[3] + m4*var[4] + m5*var[5] + m6*var[6]))   
  })
}


# events: subtract 10% ('dil') from all variables
# eventfun <- function(t, y, parameters){
  # dil = 0.0
  # with (as.list(y),{
    # Sp1 <- Sp1-dil*Sp1
    # Sp2 <- Sp2-dil*Sp2
# #     Sp1 <- Sp1-dil*Sp1+0.9*Sp1_ini
# #     Sp2 <- Sp2-dil*Sp2+0.9*Sp2_ini
    # Sp3 <- Sp3-dil*Sp3
    # Sp4 <- Sp4-dil*Sp4
    # Sp5 <- Sp5-dil*Sp5
    # Sp6 <- Sp6-dil*Sp6
    # Res <- Res-dil*Res + dil*Res_ini
    # Los <- Los
    # return(c(Sp1, Sp2, Sp3, Sp4, Sp5, Sp6, Res, Los))
  # })
# }

# timing <- seq(tperiod, tperiod*ncycles, by = tperiod)

# model integration
library(deSolve)
out1 <- ode(y = state, times = times, func = foodweb_multi_f, parms = parms)
#out2 <- ode(func = foodweb_multi_f, y = state, times = times, parms = parameters,
#            events = list(func = eventfun, time = timing))
head(out1)
# head(out2)


# # # output variables
# Time = out1[, "time"]
# Sp1  = out1[, "Sp1"]
# Sp2  = out1[, "Sp2"]
# Sp3  = out1[, "Sp3"]
# Sp4  = out1[, "Sp4"]
# Sp5  = out1[, "Sp5"]
# Sp6  = out1[, "Sp6"]
# Res  = out1[, "Res"]
# Los  = out1[, "Los"]
# Sp1d  = out2[, "Sp1"]
# Sp2d  = out2[, "Sp2"]
# Sp3d  = out2[, "Sp3"]
# Sp4d  = out2[, "Sp4"]
# Sp5d  = out2[, "Sp5"]
# Sp6d  = out2[, "Sp6"]
# Resd  = out2[, "Res"]
# Losd  = out2[, "Los"]

#Sum = Sp1 + Sp2 + Sp3 + Sp4 + Sp5 + Sp6 + Res + Los
#Sumd = Sp1d + Sp2d + Sp3d + Sp4d + Sp5d + Sp6d + Resd + Losd

# Res_rel = Res/Ini
# Sp1_rel = Sp1/Ini
# Sp2_rel = Sp2/Ini
# Sp3_rel = Sp3/Ini
# Sp4_rel = Sp4/Ini
# Sp5_rel = Sp5/Ini
# Sp6_rel = Sp6/Ini
# Los_rel = Los/Ini
# Sum_rel = Sum/Ini
# Resd_rel = Resd/Ini
# Sp1d_rel = Sp1d/Ini
# Sp2d_rel = Sp2d/Ini
# Sp3d_rel = Sp3d/Ini
# Sp4d_rel = Sp4d/Ini
# Sp5d_rel = Sp5d/Ini
# Sp6d_rel = Sp6d/Ini
# Losd_rel = Losd/Ini
# Sumd_rel = Sumd/Ini

# plot simulation results

# # plot(Time, Res, type="l", col="#8B7D6B",
     # xlab = "Time (days)",
     # ylab = "Concentration (C units)",
     # ylim = c(0, 1200)) 
# lines(Time, Sp1, type="l", col="#339933")
# lines(Time, Sp2, type="l", col="#66CC00")
# lines(Time, Sp3, type="l", col="#3399FF")
# lines(Time, Sp4, type="l", col="#0066CC")
# lines(Time, Sp5, type="l", col="#003366")
# lines(Time, Sp6, type="l", col="#FF9933")
# ##lines(Time, Los, type="l", col="#FF66FF")
# ##lines(Time, Sum, type="l", col="#888888")
# abline(h=Ini,col="#000000",lty=3)
       
# legend("topright", inset=.00,
       # c("Resource", "B. subtilus", "S. fonticula", "Collodyction sp.", "Paramecium sp.", "Colpidium sp.", "Dileptus sp.", "Losses", "Sum"),
       # text.col=c("#8B7D6B", "#339933", "#66CC00", "#3399FF", "#0066CC", "#003366", "#FF9933", "#FF66FF", "#888888"), cex=0.9)

# plot(Time, Res_rel*100, type="l", col="#8B7D6B",
     # xlab = "Time (days)",
     # ylab = "Relative concentration (%)",
     # ylim = c(0, max(Sum_rel*100))) 
# lines(Time, Sp1_rel*100, type="l", col="#339933")
# lines(Time, Sp2_rel*100, type="l", col="#66CC00")
# lines(Time, Sp3_rel*100, type="l", col="#3399FF")
# lines(Time, Sp4_rel*100, type="l", col="#0066CC")
# lines(Time, Sp5_rel*100, type="l", col="#003366")
# lines(Time, Sp6_rel*100, type="l", col="#FF9933")
# lines(Time, Los_rel*100, type="l", col="#FF66FF")
# lines(Time, Sum_rel*100, type="l", col="#888888")
# abline(h=100,col="#000000",lty=3)

# legend("topright", inset=.00,
       # c("Resource", "B. subtilus", "S. fonticula", "Collodyction sp.", "Paramecium sp.", "Colpidium sp.", "Dileptus sp.", "Losses", "Sum"),
       # text.col=c("#8B7D6B", "#339933", "#66CC00", "#3399FF", "#0066CC", "#003366", "#FF9933", "#FF66FF", "#888888"), cex=0.9)

# plot(Time, Resd, type="l", col="#8B7D6B",
     # xlab = "Time (days)",
     # ylab = "Concentration (C units)",
     # ylim = c(0, max(Sum))) 
# lines(Time, Sp1d, type="l", col="#339933")
# lines(Time, Sp2d, type="l", col="#66CC00")
# lines(Time, Sp3d, type="l", col="#3399FF")
# lines(Time, Sp4d, type="l", col="#0066CC")
# lines(Time, Sp5d, type="l", col="#003366")
# lines(Time, Sp6d, type="l", col="#FF9933")
# lines(Time, Losd, type="l", col="#FF66FF")
# lines(Time, Sumd, type="l", col="#888888")
# abline(h=Ini,col="#000000",lty=3)

# legend("topright", inset=.00,
       # c("Resource", "B. subtilus", "S. fonticula", "Collodyction sp.", "Paramecium sp.", "Colpidium sp.", "Dileptus sp.", "Losses", "Sum"),
       # text.col=c("#8B7D6B", "#339933", "#66CC00", "#3399FF", "#0066CC", "#003366", "#FF9933", "#FF66FF", "#888888"), cex=0.9)


# plot(Time, Resd_rel*100, type="l", col="#8B7D6B",
     # xlab = "Time (days)",
     # ylab = "Relative concentration (%)",
     # ylim = c(0, max(Sum_rel*100))) 
# lines(Time, Sp1d_rel*100, type="l", col="#339933")
# lines(Time, Sp2d_rel*100, type="l", col="#66CC00")
# lines(Time, Sp3d_rel*100, type="l", col="#3399FF")
# lines(Time, Sp4d_rel*100, type="l", col="#0066CC")
# lines(Time, Sp5d_rel*100, type="l", col="#003366")
# lines(Time, Sp6d_rel*100, type="l", col="#FF9933")
# lines(Time, Losd_rel*100, type="l", col="#FF66FF")
# lines(Time, Sumd_rel*100, type="l", col="#888888")
# abline(h=100,col="#000000",lty=3)

# legend("topright", inset=.00,
       # c("Resource", "B. subtilus", "S. fonticula", "Collodyction sp.", "Paramecium sp.", "Colpidium sp.", "Dileptus sp.", "Losses", "Sum"),
       # text.col=c("#8B7D6B", "#339933", "#66CC00", "#3399FF", "#0066CC", "#003366", "#FF9933", "#FF66FF", "#888888"), cex=0.9)




