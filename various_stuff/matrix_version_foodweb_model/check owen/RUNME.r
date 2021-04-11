rm(list=ls())


## set the working directory
setwd("~/Desktop/check")



## source the functions used (none at the moment)
source("MyFunctions.R")

## run the nonmatrix version
source("nonmatrix.r")
head(out1)

## run the matrix version
source("matrix.r")
head(out1.2)

## plot both on top of each other
matplot(out1[,1], out1[,2:8], type="l", col=1:8, lty=1, lwd=4,
	ylim=c(0,1200))
par(new=T)
matplot(out1.2[,1], out1.2[,-1], type="l", col=c(8, 1:7), lty=3, lwd=2,
	ylim=c(0,1200))
par(new=F)

