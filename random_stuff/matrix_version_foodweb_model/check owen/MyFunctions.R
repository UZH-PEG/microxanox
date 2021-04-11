##########################################################
#####
Monod    <- function(u, R, K)     R*u/(K+R)
#####
##########################################################




##########################################################
######
attack   <- function(b, S, q)     b*S^q
######
##########################################################




##########################################################
########
interact <- function(t, N, parms) {
	with(parms, {
		# extinction threshold
		N[N < ext.thresh] <- 0						
		## per capita consumption of resource
		resource.rate <- N*us / (Ks + N)
		## catch the NaNs that result from when N=0
		resource.rate[is.nan(resource.rate)] <- 0
		## per capita feeding rate
		predation.rate <- t(t(bs*N^(qs+1)) / (1 + colSums(hs*bs*N^(qs+1))))
		## mortality rate
		mortality.rate <- N*ms
		## calculate the rate of change for each species
		dN <- - rowSums(t(t(resource.rate)*N))  +			## loss to resource consumption
        	    rowSums(t(resource.rate)*N)	    -			## gain from resource consumption
        	    rowSums(t(t(predation.rate)*N)) +
        	    rowSums(t(es*predation.rate)*N) -
	 		    mortality.rate
		#dN  ## correct number of values... but the values need to be checked.
		#dN[4:7] <- 0
		list(dN)
	}) 
}
########
##########################################################




##########################################################
########
eventfun <- function(t, y, parms){
  with(as.list(y), {
  	N.current  <- c(Sp0, Sp1, Sp2, Sp3, Sp4, Sp5, Sp6)
  	dN <- N.current - 
  	      out.dil*N.current + 
  	      in.dil*Init
    return(dN)
  })
}
########
##########################################################




##########################################################
########
interact.chem <- function(t, N, parms) {
	with(parms, {
		# extinction threshold
		N[N < ext.thresh] <- 1e-5							
		## per capita consumption of resource
		resource.rate <- N*us / (Ks + N)  
		## per capita feeding rate
		predation.rate <- t(t(bs*N^qs) / (1 + colSums(hs*bs*N^qs)))
		## mortality rate
		mortality.rate <- N*ms
		## calculate the rate of change for each species
		dN <-   in.dil*initial.state			-
				out.dil*N						-
				rowSums(t(t(resource.rate)*N))  +			## loss to resource consumption
        	    rowSums(t(resource.rate)*N)	    -			## gain from resource consumption
        	    rowSums(t(t(predation.rate)*N)) +
        	    rowSums(t(es*predation.rate)*N) 
		#dN  ## correct number of values... but the values need to be checked.
		list(dN)
	}) 
}
########
##########################################################