# Food web model, first attempt.
# Thomas M. Massie | July 15, 2012


# Clear working directoy (all lists)
#rm(list = ls())



##################################
# Declare initial values of state variables S0-S6; S1-S6 are the species, S0 is the resource
initial.state <- c(
	Sp0 = 1000,  # Resource
	Sp1 = 300,    # B. subtilus
	Sp2 = 200,    # S. fonticula
	Sp3 = 10,    # Collodyction sp.
	Sp4 = 20,     # Paramecium sp.
	Sp5 = 30,     # Colpidium sp.
	Sp6 = 4)     # Dileptus sp.
#N <- initial.state
##################################



##################################
## Read in the parameter values from a file...
## in matrix and vector form
us <- as.matrix(read.csv("values_u.csv", row.names=1))	# nutrient uptake (carbon)
Ks <- as.matrix(read.csv("values_K.csv", row.names=1))	# half-saturation constant (carbon)
bs <- as.matrix(read.csv("values_b.csv", row.names=1))	# search coefficients
qs <- as.matrix(read.csv("values_q.csv", row.names=1))	# Hill exponent (type II or III functional response), q=1 (II), q>1 (III)
hs <- as.matrix(read.csv("values_h.csv", row.names=1))	# handling times
es <- as.matrix(read.csv("values_e.csv", row.names=1))	# efficiencies
ms <- as.matrix(read.csv("values_m.csv", row.names=1))	# mortality rates
##################################



##################################
## Define parameters.
dil     <- 0.0
out.dil <- c(dil, dil, dil, dil, dil, dil, dil)
in.dil  <- c(dil, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
# in.dil  <- c(dil, dil, dil, 0.0, 0.0, 0.0, 0.0)	# constant supply with bacteria
ext.thresh <- 1e-5
parms <- list(us=us, Ks=Ks, bs=bs, qs=qs, hs=hs, es=es, ms=ms, out.dil=out.dil, in.dil=in.dil, ext.thresh=ext.thresh)
##################################




# ##################################
# ## Here, the ODEs of the matrix model are integrated.
# # timing of periodical dilution (semi-continuous culture)
# tperiod = 2    # replacing flask content every 'tperiod' days
# ncycles = 10     # number of replacement events, also defining the time span of the simulation
# # time span of the simulation
# t_start = 0
# # t_stop  = 10
# t_stop  = tperiod*(ncycles)
# t_step  = 0.05
# # define time range for simulation as well as steps in time
 times <- seq(t_start, t_stop, t_step)
# timing <- seq(tperiod, tperiod*ncycles, tperiod)
# # model integration
# library(deSolve)
 out1.2 <- ode(y = initial.state, times = times, func = interact, parms = parms)
# # out2 <- ode(func = interact, y = initial.state, times = times, parms = parms,
            # # events = list(func = eventfun, time = timing))
# ##################################



matplot(out1, type="l")
par(new=T)
matplot(out1.2, type="l")




##################################
## Save output to csv-file format.
##write.csv(out1, file = "out_Matrix_ContinuousDilution.csv", fileEncoding = "macroman")
# write.csv(out2, file = "out_Matrix_DiscreteDilution.csv", fileEncoding = "macroman")
##################################



# layout(matrix(1:4, 2, 2, byrow=T))
# matplot(out1[,1], out1[,-1], type="l", xlab="Time", ylab="Abundance")
# matplot(out1[,1], log10(out1[,-1]), type="l", xlab="Time", ylab="log Abundance")
# matplot(out2[,1], out2[,-1], type="l", xlab="Time", ylab="Abundance")
# matplot(out2[,1], log10(out2[,-1]), type="l", xlab="Time", ylab="log Abundance")

# # 

# # output variables
# Time = out1[, "time"]
# Res  = out1[, "Sp0"]
# Sp1  = out1[, "Sp1"]
# Sp2  = out1[, "Sp2"]
# Sp3  = out1[, "Sp3"]
# Sp4  = out1[, "Sp4"]
# Sp5  = out1[, "Sp5"]
# Sp6  = out1[, "Sp6"]


# Ini = sum(initial.state)
# Sum = Sp1 + Sp2 + Sp3 + Sp4 + Sp5 + Sp6 + Res + Los
# Sumd = Sp1d + Sp2d + Sp3d + Sp4d + Sp5d + Sp6d + Resd + Losd

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
     # xlim = c(t_start, t_stop), 
     # ylim = c(0, 1200)) 
# lines(Time, Sp1, type="l", col="#339933")
# lines(Time, Sp2, type="l", col="#66CC00")
# lines(Time, Sp3, type="l", col="#3399FF")
# lines(Time, Sp4, type="l", col="#0066CC")
# lines(Time, Sp5, type="l", col="#003366")
# lines(Time, Sp6, type="l", col="#FF9933")
# # lines(Time, Los, type="l", col="#FF66FF")
# # lines(Time, Sum, type="l", col="#888888")
# # abline(h=Ini,col="#000000",lty=3)
# abline(h=Ini,col="#000000",lty=3)
# legend("topright", inset=.00,
       # c("Resource", "B. subtilus", "S. fonticula", "Collodyction sp.", "Paramecium sp.", "Colpidium sp.", "Dileptus sp."),
       # text.col=c("#8B7D6B", "#339933", "#66CC00", "#3399FF", "#0066CC", "#003366", "#FF9933"), cex=0.9)

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

# # plot(Time, Resd, type="l", col="#8B7D6B",
     # xlab = "Time (days)",
     # ylab = "Concentration (C units)",
     # ylim = c(0, max(Res))) 
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




